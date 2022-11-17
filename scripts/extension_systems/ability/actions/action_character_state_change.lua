require("scripts/extension_systems/weapon/actions/action_ability_base")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local Crouch = require("scripts/extension_systems/character_state_machine/character_states/utilities/crouch")
local Vo = require("scripts/utilities/vo")
local proc_events = BuffSettings.proc_events
local ActionCharacterStateChange = class("ActionCharacterStateChange", "ActionAbilityBase")

ActionCharacterStateChange.init = function (self, action_context, action_params, action_settings)
	ActionCharacterStateChange.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = self._unit_data_extension
	self._character_sate_component = unit_data_extension:read_component("character_state")
	self._sway_component = unit_data_extension:read_component("sway")
	self._sway_control_component = unit_data_extension:write_component("sway_control")
	self._spread_control_component = unit_data_extension:write_component("spread_control")
end

ActionCharacterStateChange.start = function (self, action_settings, t, time_scale, action_start_params)
	self._wanted_state_name = action_settings.state_name
	local unit = self._player_unit
	local valid = true

	if self._wanted_state_name == "lunging" then
		local input_extension = ScriptUnit.extension(unit, "input_system")
		local movement_state_component = self._unit_data_extension:write_component("movement_state")
		local is_crouching = Crouch.check(unit, self._first_person_extension, self._animation_extension, self._weapon_extension, movement_state_component, self._sway_control_component, self._sway_component, self._spread_control_component, input_extension, t)

		if is_crouching then
			local can_exit = Crouch.can_exit(unit)

			if can_exit then
				Crouch.exit(unit, self._first_person_extension, self._animation_extension, self._weapon_extension, movement_state_component, self._sway_control_component, self._sway_component, self._spread_control_component, t)
			end

			valid = can_exit
		end
	end

	if valid then
		local ability_template_tweak_data = self._ability_template_tweak_data

		if next(ability_template_tweak_data) then
			self._wanted_state_params = ability_template_tweak_data
		elseif action_settings.state_params then
			self._wanted_state_params = action_settings.state_params
		end
	else
		self._wanted_state_name = "walking"
		self._wanted_state_params = {}
	end
end

ActionCharacterStateChange.wanted_character_state_transition = function (self)
	return self._wanted_state_name, self._wanted_state_params
end

ActionCharacterStateChange.fixed_update = function (self, dt, t, time_in_action)
	local current_state = self._character_sate_component.state_name
	local wanted_state = self._wanted_state_name

	if current_state == wanted_state then
		return true
	end

	return false
end

ActionCharacterStateChange.finish = function (self, reason, data, t, time_in_action)
	local current_state = self._character_sate_component.state_name
	local wanted_state = self._wanted_state_name
	local is_in_wanted_state = current_state == wanted_state
	local unit = self._player_unit
	local input_extension = ScriptUnit.extension(unit, "input_system")
	local movement_state_component = self._unit_data_extension:write_component("movement_state")
	local is_crouching = Crouch.check(unit, self._first_person_extension, self._animation_extension, self._weapon_extension, movement_state_component, self._sway_control_component, self._sway_component, self._spread_control_component, input_extension, t)
	local valid = true

	if is_crouching then
		local can_exit = Crouch.can_exit(unit)

		if can_exit then
			Crouch.exit(unit, self._first_person_extension, self._animation_extension, self._weapon_extension, movement_state_component, self._sway_control_component, self._sway_component, self._spread_control_component, t)
		end

		if not can_exit then
			valid = false
		end
	end

	local action_settings = self._action_settings

	if action_settings then
		local use_ability_charge = action_settings.use_ability_charge
		local ability_interrupted_reasons = action_settings.ability_interrupted_reasons
		local should_use_charge = (not ability_interrupted_reasons or not ability_interrupted_reasons[reason]) and is_in_wanted_state
		local player_unit = self._player_unit
		local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.unit = player_unit

			buff_extension:add_proc_event(proc_events.on_combat_ability, param_table)
		end

		if use_ability_charge and should_use_charge and valid then
			local ability_type = action_settings.ability_type
			local ability_extension = self._ability_extension

			ability_extension:use_ability_charge(ability_type)
		end
	end

	if is_in_wanted_state then
		local vo_tag = action_settings.vo_tag
		local player_unit = unit

		if vo_tag then
			Vo.play_combat_ability_event(player_unit, vo_tag)
		end
	end

	self._wanted_state_name = nil
	self._wanted_state_params = nil
end

return ActionCharacterStateChange
