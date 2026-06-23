-- chunkname: @scripts/extension_systems/weapon/actions/action_inspect_3p.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local FirstPersonView = require("scripts/utilities/first_person_view")
local ForceRotation = require("scripts/extension_systems/locomotion/utilities/force_rotation")
local LagCompensation = require("scripts/utilities/lag_compensation")
local ActionInspect3p = class("ActionInspect3p", "ActionWeaponBase")

ActionInspect3p.init = function (self, action_context, action_params, action_settings)
	ActionInspect3p.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._first_person_mode_component = unit_data_extension:write_component("first_person_mode")
	self._force_look_rotation_component = unit_data_extension:write_component("locomotion_force_rotation")
	self._locomotion_steering_component = unit_data_extension:write_component("locomotion_steering")
end

ActionInspect3p.start = function (self, action_settings, t, ...)
	ActionInspect3p.super.start(self, action_settings, t, ...)

	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local weapon_template = self._weapon_template

	self:_stop_movement(t)
	FirstPersonView.exit(t, self._first_person_mode_component)

	weapon_tweak_templates_component.spread_template_name = action_settings.spread_template or weapon_template.spread_template or "none"
	weapon_tweak_templates_component.recoil_template_name = action_settings.recoil_template or weapon_template.recoil_template or "none"
	weapon_tweak_templates_component.sway_template_name = action_settings.sway_template or weapon_template.sway_template or "none"
	weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or weapon_template.charge_template or weapon_template.special_charge_template or "none"
end

ActionInspect3p.finish = function (self, reason, data, t, time_in_action)
	ActionInspect3p.super.finish(self, reason, data, t, time_in_action)

	local locomotion_force_rotation = self._force_look_rotation_component
	local first_person_extension = self._first_person_extension
	local first_person_mode_component = self._first_person_mode_component

	if locomotion_force_rotation.use_force_rotation then
		ForceRotation.stop(locomotion_force_rotation)
	end

	local rewind_ms = LagCompensation.rewind_ms(self._is_server, self._is_local_unit, self._player)

	FirstPersonView.enter(t, self._first_person_mode_component, rewind_ms)

	if reason ~= "new_interrupting_action" then
		local weapon_tweak_templates_component = self._weapon_tweak_templates_component
		local weapon_template = self._weapon_template

		weapon_tweak_templates_component.spread_template_name = weapon_template.spread_template or "none"
		weapon_tweak_templates_component.sway_template_name = weapon_template.sway_template or "none"
	end
end

ActionInspect3p._stop_movement = function (self, t)
	local first_person = self._first_person_component
	local locomotion_force_rotation = self._force_look_rotation_component
	local locomotion_steering = self._locomotion_steering_component

	locomotion_steering.velocity_wanted = Vector3.zero()
	locomotion_steering.move_method = "script_driven"

	local forced_rotation = Quaternion.look(Vector3.flat(Quaternion.forward(first_person.rotation)))

	if not locomotion_force_rotation.use_force_rotation then
		ForceRotation.start(locomotion_force_rotation, locomotion_steering, forced_rotation, forced_rotation, t, 0)
	end
end

return ActionInspect3p
