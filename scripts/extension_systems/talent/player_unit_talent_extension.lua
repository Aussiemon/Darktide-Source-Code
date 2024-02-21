local CharacterSheet = require("scripts/utilities/character_sheet")
local WarpCharge = require("scripts/utilities/warp_charge")
local PlayerUnitTalentExtension = class("PlayerUnitTalentExtension")

PlayerUnitTalentExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	local player = extension_init_data.player
	self._player = player
	self._world = extension_init_context.world
	self._wwise_world = extension_init_context.wwise_world
	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	local first_person_unit = first_person_extension:first_person_unit()
	self._first_person_unit = first_person_unit
	self._is_local_unit = extension_init_data.is_local_unit
	local archetype = extension_init_data.archetype
	local talents = extension_init_data.talents
	self._archetype = archetype
	self._talents = talents
	self._active_special_rules = {}
	self._initialized_fixed_frame_t = extension_init_context.fixed_frame_t
	self._coherency_system = Managers.state.extension:system("coherency_system")
	self._passive_buff_indices = {}
	self._coherency_external_buff_indices = {}
	self._buff_template_tiers = {}
	self._latest_fixed_frame = extension_init_context.fixed_frame

	self:_init_components()
end

PlayerUnitTalentExtension._init_components = function (self)
	local unit_data_extension = ScriptUnit.extension(self._unit, "unit_data_system")
	local warp_charge_component = unit_data_extension:write_component("warp_charge")
	local talent_resource_component = unit_data_extension:write_component("talent_resource")
	warp_charge_component.state = "idle"
	warp_charge_component.last_charge_at_t = 0
	warp_charge_component.remove_at_t = 0
	warp_charge_component.current_percentage = 0
	warp_charge_component.starting_percentage = 0
	warp_charge_component.ramping_modifier = 0
	talent_resource_component.current_resource = 0
	talent_resource_component.max_resource = 0
	self._fx_extension = ScriptUnit.extension(self._unit, "fx_system")
	self._unit_data_extension = unit_data_extension
	self._warp_charge_component = warp_charge_component
end

PlayerUnitTalentExtension.extensions_ready = function (self, world, unit)
	self._ability_extension = ScriptUnit.extension(unit, "ability_system")
	self._buff_extension = ScriptUnit.extension(unit, "buff_system")
	self._first_person_extension = ScriptUnit.extension(unit, "first_person_system")
end

PlayerUnitTalentExtension.game_object_initialized = function (self, game_object_id)
	local fixed_t = self._initialized_fixed_frame_t

	self:_apply_talents(self._archetype, self._talents, fixed_t)
end

PlayerUnitTalentExtension.buff_template_tier = function (self, buff_template_name)
	return self._buff_template_tiers[buff_template_name] or 1
end

PlayerUnitTalentExtension.update = function (self, unit, dt, t)
	return
end

PlayerUnitTalentExtension.fixed_update = function (self, unit, dt, t, fixed_frame, context, ...)
	self._latest_fixed_frame = fixed_frame

	WarpCharge.update(dt, t, self._warp_charge_component, self._player, self._unit, self._first_person_unit, self._is_local_unit, self._wwise_world)
end

PlayerUnitTalentExtension.destroy = function (self)
	self:_remove_gameplay_features(self._latest_fixed_frame)
end

PlayerUnitTalentExtension.has_special_rule = function (self, special_rule_name)
	local active_special_rules = self._active_special_rules

	return active_special_rules[special_rule_name]
end

PlayerUnitTalentExtension.select_new_talents = function (self, talents, fixed_t)
	self:_remove_gameplay_features(fixed_t)

	self._talents = talents

	self:_send_rpc_update_to_client(self._player, talents)
	self:_apply_talents(self._archetype, talents, fixed_t)
end

PlayerUnitTalentExtension.remove_gameplay_features = function (self, fixed_t)
	self:_remove_gameplay_features(fixed_t)
end

local class_loadout = {
	passives = {},
	coherency = {},
	special_rules = {},
	buff_template_tiers = {}
}

PlayerUnitTalentExtension._apply_talents = function (self, archetype, talents, fixed_t)
	local ability_extension = self._ability_extension
	local buff_extension = self._buff_extension
	local combat_ability, grenade_ability, passives, coherency_buffs, special_rules, buff_template_tiers = nil
	local game_mode_manager = Managers.state.game_mode
	local game_mode_settings = game_mode_manager:settings()

	if game_mode_manager:talents_disabled() then
		buff_template_tiers = {}
		special_rules = {}
		coherency_buffs = {}
		passives = {}
	else
		local force_base_talents = game_mode_settings and game_mode_settings.force_base_talents
		local profile = self._player:profile()
		local selected_nodes = CharacterSheet.convert_talents_to_node_layout(profile, talents)

		CharacterSheet.class_loadout(profile, class_loadout, force_base_talents, selected_nodes)

		combat_ability = class_loadout.combat_ability
		grenade_ability = class_loadout.grenade_ability
		passives = class_loadout.passives
		coherency_buffs = class_loadout.coherency
		special_rules = class_loadout.special_rules
		buff_template_tiers = class_loadout.buff_template_tiers
	end

	if combat_ability then
		ability_extension:equip_ability("combat_ability", combat_ability, fixed_t)
	end

	if grenade_ability then
		ability_extension:equip_ability("grenade_ability", grenade_ability, fixed_t)
	end

	local active_special_rules = self._active_special_rules

	table.clear(self._active_special_rules)

	local unit = self._unit

	for _, special_rule_name in pairs(special_rules) do
		active_special_rules[special_rule_name] = true
	end

	local active_buff_template_tiers = self._buff_template_tiers

	table.clear(active_buff_template_tiers)

	for buff_template_name, tier in pairs(buff_template_tiers) do
		active_buff_template_tiers[buff_template_name] = tier
	end

	local passive_buff_indices = self._passive_buff_indices

	for _, buff_template_name in pairs(passives) do
		local _, local_index, component_index = buff_extension:add_externally_controlled_buff(buff_template_name, fixed_t, "from_talent", true)
		passive_buff_indices[#passive_buff_indices + 1] = {
			local_index = local_index,
			component_index = component_index
		}
	end

	local coherency_system = self._coherency_system
	local coherency_external_buff_indices = self._coherency_external_buff_indices

	for _, buff_template_name in pairs(coherency_buffs) do
		coherency_external_buff_indices[#coherency_external_buff_indices + 1] = coherency_system:add_external_buff(unit, buff_template_name, "from_talent", true)
	end
end

PlayerUnitTalentExtension._remove_gameplay_features = function (self, fixed_t)
	if GameParameters.testify then
		Log.info("PlayerUnitTalentExtension", "remove_gameplay_features - %s", debug.traceback())
	end

	local unit = self._unit
	local coherency_system = self._coherency_system
	local coherency_external_buff_indices = self._coherency_external_buff_indices

	for i = #coherency_external_buff_indices, 1, -1 do
		local index = coherency_external_buff_indices[i]

		coherency_system:remove_external_buff(unit, index)

		coherency_external_buff_indices[i] = nil
	end

	local buff_extension = self._buff_extension
	local passive_buff_indices = self._passive_buff_indices

	for i = #passive_buff_indices, 1, -1 do
		local indices = passive_buff_indices[i]
		local local_index = indices.local_index
		local component_index = indices.component_index

		buff_extension:remove_externally_controlled_buff(local_index, component_index)

		passive_buff_indices[i] = nil
	end

	local ability_extension = self._ability_extension
	local equipped_abilities = ability_extension:equipped_abilities()

	for ability_type, _ in pairs(equipped_abilities) do
		ability_extension:unequip_ability(ability_type, fixed_t)
	end
end

local temp_talent_id_array = {}
local temp_talent_tier_array = {}

PlayerUnitTalentExtension._send_rpc_update_to_client = function (self, player, talents)
	if not player.remote then
		return
	end

	table.clear(temp_talent_id_array)

	local index = 0

	for talent_name, tier in pairs(talents) do
		index = index + 1
		temp_talent_id_array[index] = NetworkLookup.archetype_talent_names[talent_name]
		temp_talent_tier_array[index] = tier
	end

	local channel_id = player:channel_id()
	local unit_id = Managers.state.unit_spawner:game_object_id(self._unit)

	RPC.rpc_update_talents(channel_id, unit_id, temp_talent_id_array, temp_talent_tier_array)
end

return PlayerUnitTalentExtension
