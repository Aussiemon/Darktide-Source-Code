local LookDeltaTemplates = require("scripts/settings/equipment/look_delta_templates")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local LookDelta = {
	look_delta_template = function (weapon_action_component, alternate_fire_component)
		local look_delta_template_name = nil
		local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)

		if alternate_fire_component.is_active then
			look_delta_template_name = weapon_template and weapon_template.alternate_fire_settings.look_delta_template or "default_aiming"
		else
			look_delta_template_name = weapon_template and weapon_template.look_delta_template or "default"
		end

		return LookDeltaTemplates[look_delta_template_name]
	end,
	look_delta_values = function (settings, look_delta_x, look_delta_y)
		local new_look_delta_x = look_delta_x * settings.delta_x_modifier
		local new_look_delta_y = look_delta_y * settings.delta_y_modifier
		local lerp_constant_x = settings.lerp_constant_x_func(new_look_delta_x)
		local lerp_constant_y = settings.lerp_constant_x_func(new_look_delta_y)

		if math.abs(new_look_delta_x) <= settings.deadzone_x then
			new_look_delta_x = 0
		end

		if math.abs(new_look_delta_y) <= settings.deadzone_y then
			new_look_delta_y = 0
		end

		if new_look_delta_x == 0 then
			lerp_constant_x = settings.deadzone_x_lerp_constant
		end

		if new_look_delta_y == 0 then
			lerp_constant_y = settings.deadzone_y_lerp_constant
		end

		return new_look_delta_x, new_look_delta_y, lerp_constant_x, lerp_constant_y
	end
}

return LookDelta
