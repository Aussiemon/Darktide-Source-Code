require("scripts/extension_systems/weapon/actions/action_ability_base")

local Lunge = require("scripts/utilities/player_state/lunge")
local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local ActionTargetedDashAim = class("ActionTargetedDashAim", "ActionAbilityBase")

ActionTargetedDashAim.init = function (self, action_context, action_params, action_setting)
	ActionTargetedDashAim.super.init(self, action_context, action_params, action_setting)

	self._input_extension = action_context.input_extension
	self._aim_ready_up_time = action_setting.aim_ready_up_time or 0
	local unit_data_extension = action_context.unit_data_extension
	self._lunge_character_state_component = unit_data_extension:write_component("lunge_character_state")
end

ActionTargetedDashAim.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionTargetedDashAim.super.start(self, action_settings, t, time_scale, action_start_params)

	local lunge_template = self:get_lunge_template()
	self._lunge_character_state_component.is_aiming = true
	self._lunge_character_state_component.lunge_template = lunge_template.name
end

ActionTargetedDashAim.finish = function (self, reason, data, t, time_in_action)
	ActionTargetedDashAim.super.finish(self, reason, data, t, time_in_action)

	self._lunge_character_state_component.is_aiming = false
	self._lunge_character_state_component.lunge_template = "none"

	if self._unit_data_extension.is_resimulating then
		return
	end
end

ActionTargetedDashAim.fixed_update = function (self, dt, t, time_in_action)
	if self._unit_data_extension.is_resimulating then
		return
	end

	local new_target = self:_find_target(time_in_action)
	self._lunge_character_state_component.lunge_target = new_target
end

ActionTargetedDashAim._find_target = function (self, time_in_action)
	local new_target = nil

	if self._aim_ready_up_time <= time_in_action then
		local lunge_template = self:get_lunge_template()
		local smart_targeting_data = self._smart_targeting_extension:targeting_data()
		local smart_target_unit = smart_targeting_data.unit

		if smart_target_unit then
			local has_target = true
			local lunge_distance = Lunge.distance(lunge_template, has_target)

			if smart_targeting_data.distance <= lunge_distance then
				new_target = smart_target_unit
			end
		end
	end

	return new_target
end

ActionTargetedDashAim._check_input = function (self, time_in_action, aim_ready_up_time)
	local input_extension = self._input_extension
	local move_vector = input_extension:get("move")
	local time_check = time_in_action < aim_ready_up_time
	local right_left = move_vector.x

	if time_check and math.abs(right_left) > 0 then
		return false
	end

	local back_forth = move_vector.y

	if time_check and back_forth < 0 then
		return false
	end

	return true
end

ActionTargetedDashAim.get_lunge_template = function (self)
	local action_settings = self._action_settings
	local ability_template_tweak_data = self._ability_template_tweak_data
	local lunge_template_name = nil

	if ability_template_tweak_data and ability_template_tweak_data.lunge_template_name then
		lunge_template_name = ability_template_tweak_data.lunge_template_name
	else
		lunge_template_name = action_settings.lunge_template_name
	end

	local lunge_template = LungeTemplates[lunge_template_name]

	return lunge_template
end

return ActionTargetedDashAim
