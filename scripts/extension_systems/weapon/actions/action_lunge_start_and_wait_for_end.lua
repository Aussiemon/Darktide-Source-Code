-- chunkname: @scripts/extension_systems/weapon/actions/action_lunge_start_and_wait_for_end.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionLungeStartAndWaitForEnd = class("ActionLungeStartAndWaitForEnd", "ActionWeaponBase")

ActionLungeStartAndWaitForEnd.init = function (self, action_context, action_params, action_settings)
	ActionLungeStartAndWaitForEnd.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._character_sate_component = unit_data_extension:read_component("character_state")
	self._lunge_character_state_component = unit_data_extension:read_component("lunge_character_state")
end

ActionLungeStartAndWaitForEnd.start = function (self, action_settings, t, time_scale, params)
	ActionLungeStartAndWaitForEnd.super.start(self, action_settings, t, time_scale, params)

	self._has_entered_state = false
	self._lunging_state_name = "lunging"
	self._lunging_state_params = action_settings.lunge_state_params
end

ActionLungeStartAndWaitForEnd.running_action_state = function (self, t, time_in_action)
	local character_sate_component = self._character_sate_component
	local current_character_state = character_sate_component.state_name
	local previous_character_state = character_sate_component.previous_state_name
	local lunging_state_name = self._lunging_state_name

	if not self._has_entered_state then
		local has_started_lunging = current_character_state == lunging_state_name

		self._has_entered_state = has_started_lunging

		return has_started_lunging and "lunging" or "waiting_for_lunge"
	end

	if previous_character_state == lunging_state_name then
		return "lunge_ended"
	elseif current_character_state == lunging_state_name then
		return "lunging"
	else
		return "cancel"
	end
end

ActionLungeStartAndWaitForEnd.server_correction_occurred = function (self)
	local character_sate_component = self._character_sate_component
	local lunging_state_name = self._lunging_state_name
	local current_character_state = character_sate_component.state_name
	local previous_character_state = character_sate_component.previous_state_name

	self._has_entered_state = current_character_state == lunging_state_name and previous_character_state == lunging_state_name
end

ActionLungeStartAndWaitForEnd.wanted_character_state_transition = function (self)
	return self._lunging_state_name, self._lunging_state_params
end

ActionLungeStartAndWaitForEnd.finish = function (self, reason, data, t, time_in_action)
	ActionLungeStartAndWaitForEnd.super.finish(self, reason, data, t, time_in_action)
end

return ActionLungeStartAndWaitForEnd
