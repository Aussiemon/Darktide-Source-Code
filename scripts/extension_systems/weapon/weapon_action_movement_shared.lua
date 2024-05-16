-- chunkname: @scripts/extension_systems/weapon/weapon_action_movement_shared.lua

local Action = require("scripts/utilities/weapon/action")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WeaponActionMovementSharedFunctions = {}

WeaponActionMovementSharedFunctions.action_movement_curve = function (weapon_action_component, action_sweep_component)
	local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
	local current_action_name, action_settings = Action.current_action(weapon_action_component, weapon_template)

	if current_action_name == "none" or not action_settings then
		return nil
	end

	local special_active_at_start = weapon_action_component.special_active_at_start
	local is_sticky = action_sweep_component.is_sticky
	local hit_stickyness_settings = is_sticky and (special_active_at_start and action_settings.hit_stickyness_settings_special_active or action_settings.hit_stickyness_settings)
	local hit_sticky_movement_curve = hit_stickyness_settings and hit_stickyness_settings.movement_curve

	if hit_sticky_movement_curve then
		local start_t = action_sweep_component.sweep_aborted_t

		return hit_sticky_movement_curve, start_t
	end

	local action_movement_curve = action_settings.action_movement_curve
	local start_t = weapon_action_component.start_t

	return action_movement_curve, start_t
end

return WeaponActionMovementSharedFunctions
