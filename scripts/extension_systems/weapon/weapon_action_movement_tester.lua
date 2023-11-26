-- chunkname: @scripts/extension_systems/weapon/weapon_action_movement_tester.lua

local WeaponActionMovementTester = {}
local _verify_curve

WeaponActionMovementTester.parse_weapon_templates = function (weapon_templates)
	for name, weapon_template in pairs(weapon_templates) do
		for action_name, action_settings in pairs(weapon_template.actions) do
			local action_movement_curve = action_settings.action_movement_curve

			if action_movement_curve then
				_verify_curve(action_movement_curve, "action_movement_curve", action_name, name)
			end

			local hit_stickyness_settings = action_settings.hit_stickyness_settings
			local hit_sticky_movement_curve = hit_stickyness_settings and hit_stickyness_settings.movement_curve

			if hit_sticky_movement_curve then
				_verify_curve(hit_sticky_movement_curve, "hit_stickyness_settings.movement_curve", action_name, name)
			end
		end
	end
end

function _verify_curve(curve, curve_type, action_name, weapon_template_name)
	return
end

return WeaponActionMovementTester
