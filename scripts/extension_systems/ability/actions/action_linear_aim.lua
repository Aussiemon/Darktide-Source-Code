require("scripts/extension_systems/weapon/actions/action_ability_base")

local ActionLinearAim = class("ActionLinearAim", "ActionAbilityBase")
local LungeTemplates = require("scripts/settings/lunge/lunge_templates")

ActionLinearAim.init = function (self, action_context, ...)
	ActionLinearAim.super.init(self, action_context, ...)

	local unit_data_extension = action_context.unit_data_extension
	self._lunge_character_state_component = unit_data_extension:write_component("lunge_character_state")
end

ActionLinearAim.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionLinearAim.super.start(self, action_settings, t, time_scale, action_start_params)

	local lunge_template = self:get_lunge_template()
	self._lunge_character_state_component.is_aiming = true
	self._lunge_character_state_component.lunge_template = lunge_template.name
end

ActionLinearAim.finish = function (self, reason, data, t, time_in_action)
	ActionLinearAim.super.finish(self, reason, data, t, time_in_action)

	self._lunge_character_state_component.is_aiming = false
	self._lunge_character_state_component.lunge_template = "none"
end

ActionLinearAim.get_lunge_template = function (self)
	local action_settings = self._action_settings
	local ability_template_tweak_data = self._ability_template_tweak_data
	local lunge_template_name = nil

	if ability_template_tweak_data and ability_template_tweak_data.lunge_template_name then
		lunge_template_name = ability_template_tweak_data.lunge_template_name
	elseif action_settings.lunge_template then
		lunge_template_name = action_settings.lunge_template_name
	end

	local lunge_template = LungeTemplates[lunge_template_name]

	return lunge_template
end

return ActionLinearAim
