-- chunkname: @scripts/extension_systems/ability/player_husk_ability_extension.lua

local AbilityTemplates = require("scripts/settings/ability/ability_templates/ability_templates")
local EquippedAbilityEffectScripts = require("scripts/extension_systems/ability/utilities/equipped_ability_effect_scripts")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerHuskAbilityExtension = class("PlayerHuskAbilityExtension")
local ability_types = table.keys(PlayerCharacterConstants.ability_configuration)

PlayerHuskAbilityExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id)
	self._game_session = game_session
	self._game_object_id = game_object_id
	self._equipped_abilities = {}
	self._enabled_abilities = {}
	self._ability_max_charges = {}
	self._ability_max_cooldown = {}
	self._components = {}

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	for i = 1, #ability_types do
		local component_name = ability_types[i]

		self._enabled_abilities[component_name] = false
		self._ability_max_charges[component_name] = 0
		self._ability_max_cooldown[component_name] = 0
		self._components[component_name] = unit_data_extension:read_component(component_name)
	end

	self._equipped_ability_effect_scripts = {}
	self._equipped_ability_effect_scripts_context = {
		world = extension_init_context.world,
		physics_world = extension_init_context.physics_world,
		wwise_world = extension_init_context.wwise_world,
		unit = unit,
		unit_data_extension = unit_data_extension,
		is_local_unit = extension_init_data.is_server,
		is_server = extension_init_data.is_local_unit,
	}

	self:_read_game_object(game_session, game_object_id)

	self._last_read_t = 0
end

PlayerHuskAbilityExtension.extensions_ready = function (self, world, unit)
	for ability_type, ability_effect_scripts in pairs(self._equipped_ability_effect_scripts) do
		EquippedAbilityEffectScripts.extensions_ready(ability_effect_scripts, world, unit)
	end
end

local READ_GAME_OBJECT_FREQUENCY = 0.5

PlayerHuskAbilityExtension.update = function (self, unit, dt, t)
	if t - self._last_read_t > READ_GAME_OBJECT_FREQUENCY then
		self._last_read_t = t

		self:_read_game_object(self._game_session, self._game_object_id)
	end

	for ability_type, ability_effect_scripts in pairs(self._equipped_ability_effect_scripts) do
		EquippedAbilityEffectScripts.update(ability_effect_scripts, unit, dt, t)
	end
end

PlayerHuskAbilityExtension.fixed_update = function (self, unit, dt, t, fixed_frame)
	for ability_type, ability_effect_scripts in pairs(self._equipped_ability_effect_scripts) do
		EquippedAbilityEffectScripts.fixed_update(ability_effect_scripts, unit, dt, t)
	end
end

PlayerHuskAbilityExtension.post_update = function (self, unit, dt, t, fixed_frame)
	for ability_type, ability_effect_scripts in pairs(self._equipped_ability_effect_scripts) do
		EquippedAbilityEffectScripts.post_update(ability_effect_scripts, unit, dt, t)
	end
end

local game_object_fields = {}

for i = 1, #ability_types do
	local ability_type = ability_types[i]

	game_object_fields[ability_type .. "_equipped"] = 0
	game_object_fields[ability_type .. "_enabled"] = false
	game_object_fields[ability_type .. "_max_charges"] = 0
	game_object_fields[ability_type .. "_max_cooldown"] = 0
end

PlayerHuskAbilityExtension._read_game_object = function (self, game_session, game_object_id)
	GameSession.game_object_fields(game_session, game_object_id, game_object_fields)

	for i = 1, #ability_types do
		local component_name = ability_types[i]
		local equipped_abilities = self._equipped_abilities

		self:_handle_ability_equip(equipped_abilities, component_name, game_object_fields[component_name .. "_equipped"])

		self._enabled_abilities[component_name] = game_object_fields[component_name .. "_enabled"]
		self._ability_max_charges[component_name] = game_object_fields[component_name .. "_max_charges"]
		self._ability_max_cooldown[component_name] = game_object_fields[component_name .. "_max_cooldown"]
	end
end

PlayerHuskAbilityExtension._handle_ability_equip = function (self, equipped_abilities, ability_type, sync_value)
	local current_equipped_ability = equipped_abilities[ability_type]
	local equipped_ability = NetworkLookup.player_abilities[sync_value]

	if equipped_ability == "not_equipped" and current_equipped_ability ~= nil then
		equipped_abilities[ability_type] = nil

		local equipped_ability_effect_scripts = self._equipped_ability_effect_scripts[ability_type]

		if equipped_ability_effect_scripts then
			EquippedAbilityEffectScripts.destroy(equipped_ability_effect_scripts)

			self._equipped_ability_effect_scripts[ability_type] = nil
		end

		return
	end

	if equipped_ability ~= "not_equipped" and (not current_equipped_ability or current_equipped_ability.name ~= equipped_ability) then
		local ability = PlayerAbilities[equipped_ability]

		equipped_abilities[ability_type] = ability

		local ability_template_name = ability.ability_template

		if ability_template_name then
			local ability_template = AbilityTemplates[ability_template_name]
			local equipped_ability_effect_scripts = {}

			self._equipped_ability_effect_scripts[ability_type] = equipped_ability_effect_scripts

			local equipped_ability_effect_scripts_context = self._equipped_ability_effect_scripts_context

			EquippedAbilityEffectScripts.create(equipped_ability_effect_scripts_context, equipped_ability_effect_scripts, ability_template, ability_type)
		end
	end
end

PlayerHuskAbilityExtension.ability_enabled = function (self, ability_type)
	return self._enabled_abilities[ability_type] or false
end

PlayerHuskAbilityExtension.equipped_abilities = function (self)
	return self._equipped_abilities
end

PlayerHuskAbilityExtension.ability_is_equipped = function (self, ability_type)
	return self._equipped_abilities[ability_type]
end

PlayerHuskAbilityExtension.remaining_ability_charges = function (self, ability_type)
	local enabled = self:ability_enabled(ability_type)

	if not enabled then
		return 0
	end

	return self._components[ability_type].num_charges
end

PlayerHuskAbilityExtension.max_ability_charges = function (self, ability_type)
	return self._ability_max_charges[ability_type] or 0
end

PlayerHuskAbilityExtension.missing_ability_charges = function (self, ability_type)
	local max_charges = self:max_ability_charges(ability_type)
	local remaining_ability_charges = self:remaining_ability_charges(ability_type)
	local missing_charges = max_charges - remaining_ability_charges

	return missing_charges
end

PlayerHuskAbilityExtension.is_cooldown_paused = function (self, ability_type)
	local enabled = self:ability_enabled(ability_type)

	if not enabled then
		return true
	end

	local ability_components = self._ability_components
	local component = ability_components[ability_type]

	return component.cooldown_paused
end

PlayerHuskAbilityExtension.pause_cooldown = function (self, ability_type)
	local ability_components = self._ability_components
	local component = ability_components[ability_type]

	component.cooldown_paused = true
end

PlayerHuskAbilityExtension.remaining_ability_cooldown = function (self, ability_type)
	local enabled = self:ability_enabled(ability_type)

	if not enabled then
		return math.huge
	end

	local cooldown = self._components[ability_type].cooldown
	local fixed_frame_t = FixedFrame.get_latest_fixed_time()
	local remaining_cooldown = math.max(cooldown - fixed_frame_t, 0)

	return remaining_cooldown
end

PlayerHuskAbilityExtension.max_ability_cooldown = function (self, ability_type)
	return self._ability_max_cooldown[ability_type] or 0
end

PlayerHuskAbilityExtension.set_ability_enabled = function (self)
	error("not allowed to call on husk.")
end

PlayerHuskAbilityExtension.set_ability_charges = function (self)
	error("not allowed to call on husk.")
end

PlayerHuskAbilityExtension.can_use_ability = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.wanted_character_state_transition = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.action_input_is_currently_valid = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.has_ability_type = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.equip_ability = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.unequip_ability = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.update_ability_actions = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.stop_action = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.use_ability_charge = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.restore_ability_charge = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.reduce_ability_cooldown_percentage = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.reduce_ability_cooldown_time = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.can_wield = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.can_be_scroll_wielded = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.server_correction_occurred = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.running_action_settings = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.get_slot_name = function (self)
	error("not implemented.")
end

PlayerHuskAbilityExtension.charge_replenished = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.get_current_ability_cooldown_time = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.get_current_ability_name = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.get_current_grenade_ability_name = function (self)
	error("not allowed to call on husk")
end

PlayerHuskAbilityExtension.ability_pause_cooldown_settings = function (self)
	error("not allowed to call on husk")
end

return PlayerHuskAbilityExtension
