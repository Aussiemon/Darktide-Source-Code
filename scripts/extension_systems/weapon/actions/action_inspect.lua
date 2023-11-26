-- chunkname: @scripts/extension_systems/weapon/actions/action_inspect.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionInspect = class("ActionInspect", "ActionWeaponBase")

ActionInspect.start = function (self, action_settings, ...)
	ActionInspect.super.start(self, action_settings, ...)

	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local weapon_template = self._weapon_template

	weapon_tweak_templates_component.spread_template_name = action_settings.spread_template or weapon_template.spread_template or "none"
	weapon_tweak_templates_component.recoil_template_name = action_settings.recoil_template or weapon_template.recoil_template or "none"
	weapon_tweak_templates_component.sway_template_name = action_settings.sway_template or weapon_template.sway_template or "none"
	weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or weapon_template.charge_template or "none"
end

ActionInspect.finish = function (self, reason, data, t, time_in_action)
	ActionInspect.super.finish(self, reason, data, t, time_in_action)

	if reason ~= "new_interrupting_action" then
		local weapon_tweak_templates_component = self._weapon_tweak_templates_component
		local weapon_template = self._weapon_template

		weapon_tweak_templates_component.spread_template_name = weapon_template.spread_template or "none"
		weapon_tweak_templates_component.sway_template_name = weapon_template.sway_template or "none"
	end
end

return ActionInspect
