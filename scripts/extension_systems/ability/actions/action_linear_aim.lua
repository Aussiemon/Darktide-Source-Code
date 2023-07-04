require("scripts/extension_systems/weapon/actions/action_ability_base")

local ActionLinearAim = class("ActionLinearAim", "ActionAbilityBase")

ActionLinearAim.init = function (self, action_context, ...)
	ActionLinearAim.super.init(self, action_context, ...)

	local unit_data_extension = action_context.unit_data_extension
	self._lunge_character_state_component = unit_data_extension:write_component("lunge_character_state")
end

ActionLinearAim.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionLinearAim.super.start(self, action_settings, t, time_scale, action_start_params)

	self._lunge_character_state_component.is_aiming = true
end

ActionLinearAim.finish = function (self, reason, data, t, time_in_action)
	ActionLinearAim.super.finish(self, reason, data, t, time_in_action)

	self._lunge_character_state_component.is_aiming = false
end

return ActionLinearAim
