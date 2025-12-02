-- chunkname: @scripts/extension_systems/talent/player_husk_talent_extension.lua

local CharacterSheet = require("scripts/utilities/character_sheet")
local WarpCharge = require("scripts/utilities/warp_charge")
local RPCS = {
	"rpc_update_talents",
}
local PlayerHuskTalentExtension = class("PlayerHuskTalentExtension")

PlayerHuskTalentExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit

	local player = extension_init_data.player

	self._player = player
	self._local_player = Managers.player:local_player(1)
	self._world = extension_init_context.world
	self._wwise_world = extension_init_context.wwise_world

	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	local first_person_unit = first_person_extension:first_person_unit()

	self._first_person_unit = first_person_unit
	self._is_local_unit = extension_init_data.is_local_unit

	local peer_id = player:peer_id()

	self._channel_id = Managers.state.game_session:peer_to_channel(peer_id)
	self._game_object_id = Managers.state.unit_spawner:game_object_id(self._unit)

	local archetype = extension_init_data.archetype
	local talents = extension_init_data.talents

	self._archetype = archetype
	self._talents = talents
	self._initialized_fixed_frame_t = extension_init_context.fixed_frame_t
	self._game_object_id = Managers.state.unit_spawner:game_object_id(self._unit)
	self._network_event_delegate = extension_init_context.network_event_delegate

	self._network_event_delegate:register_session_unit_events(self, self._game_object_id, unpack(RPCS))

	self._active_special_rules = {}
	self._buff_template_tiers = {}

	self:_init_components()
end

PlayerHuskTalentExtension._init_components = function (self)
	if self._is_local_unit then
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
		self._warp_charge_component = warp_charge_component
		self._unit_data_extension = unit_data_extension
	end
end

PlayerHuskTalentExtension.extensions_ready = function (self, world, unit)
	self._first_person_extension = ScriptUnit.extension(unit, "first_person_system")

	self:_update_talents(self._talents)
end

PlayerHuskTalentExtension.buff_template_tier = function (self, buff_template_name)
	return self._buff_template_tiers[buff_template_name]
end

PlayerHuskTalentExtension.fixed_update = function (self, unit, dt, t, fixed_frame, context, ...)
	local camera_handler = self._local_player.camera_handler
	local is_observing = camera_handler and camera_handler:is_observing()
	local player = self._player
	local first_person_unit = self._first_person_unit
	local is_local_unit = self._is_local_unit
	local warp_charge_component = self._warp_charge_component

	if not is_observing and is_local_unit then
		WarpCharge.update(dt, t, warp_charge_component, player, unit, first_person_unit, is_local_unit, self._wwise_world)
	elseif is_observing and not is_local_unit then
		local follow_unit = camera_handler:camera_follow_unit()

		WarpCharge.update_observer(dt, t, player, unit, first_person_unit, self._wwise_world, follow_unit)
	end
end

PlayerHuskTalentExtension.destroy = function (self)
	self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(RPCS))
end

PlayerHuskTalentExtension.has_special_rule = function (self, special_rule_name)
	local active_special_rules = self._active_special_rules

	return active_special_rules[special_rule_name]
end

local class_loadout = {
	passives = {},
	coherency = {},
	special_rules = {},
	buff_template_tiers = {},
}

PlayerHuskTalentExtension._update_talents = function (self, talents)
	self._talents = talents

	local special_rules, buff_template_tiers

	if Managers.state.game_mode:talents_disabled() then
		special_rules, buff_template_tiers = {}, {}
	else
		local game_mode_settings = Managers.state.game_mode:settings()
		local force_base_talents = game_mode_settings and game_mode_settings.force_base_talents
		local player = self._player
		local profile = player:profile()

		CharacterSheet.class_loadout(profile, class_loadout, force_base_talents, talents)

		special_rules = class_loadout.special_rules
		buff_template_tiers = class_loadout.buff_template_tiers
	end

	local active_special_rules = self._active_special_rules

	table.clear(self._active_special_rules)

	for _, special_rule_name in pairs(special_rules) do
		active_special_rules[special_rule_name] = true
	end

	local active_buff_template_tiers = self._buff_template_tiers

	table.clear(active_buff_template_tiers)

	for buff_template_name, tier in pairs(buff_template_tiers) do
		active_buff_template_tiers[buff_template_name] = tier
	end
end

local temp_talent_name_set = {}

PlayerHuskTalentExtension.rpc_update_talents = function (self, channel_id, unit_id, talent_id_array, talent_tier_array)
	table.clear(temp_talent_name_set)

	for ii = 1, #talent_id_array do
		local talent_name_id = talent_id_array[ii]
		local talent_name = NetworkLookup.archetype_talent_names[talent_name_id]

		temp_talent_name_set[talent_name] = talent_tier_array[ii]
	end

	self:_update_talents(temp_talent_name_set)
end

return PlayerHuskTalentExtension
