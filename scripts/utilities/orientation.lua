local InputDevice = require("scripts/managers/input/input_device")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local Orientation = {}
local _mouse_input, _gamepad_input = nil

Orientation.look_delta = function (main_dt, input, fov_sensitivity, mouse_scale, look_delta_context)
	local mouse_input = _mouse_input(input, look_delta_context)
	local gamepad_input = _gamepad_input(input, look_delta_context)
	local look_delta = (mouse_input * mouse_scale + gamepad_input) * fov_sensitivity

	return look_delta
end

local PI = math.pi
local PI_2 = PI * 2

Orientation.clamp_from_origin = function (current_rad, delta_rad, origin_rad, constraint_rad)
	local min = origin_rad - constraint_rad * 0.5
	local max = origin_rad + constraint_rad * 0.5
	local mod = 0

	if min < 0 or PI_2 < max then
		mod = PI
	end

	min = (min + mod) % PI_2
	max = (max + mod) % PI_2
	current_rad = (current_rad + mod) % PI_2
	local new_value = math.clamp(current_rad - delta_rad, min, max) - mod

	return new_value
end

function _mouse_input(input, look_delta_context)
	local weapon_action_component = look_delta_context.weapon_action_component
	local alternate_fire_component = look_delta_context.alternate_fire_component
	local weapon_template = weapon_action_component and WeaponTemplate.current_weapon_template(weapon_action_component)
	local ranged_weapon_wielded = weapon_template and WeaponTemplate.is_ranged(weapon_template)
	local grenade_weapon_wielded = weapon_template and WeaponTemplate.is_grenade(weapon_template)
	local use_ranged_filter = ranged_weapon_wielded or grenade_weapon_wielded
	local alternate_fire_is_active = alternate_fire_component and alternate_fire_component.is_active
	local input_filter_name = nil

	if use_ranged_filter and alternate_fire_is_active then
		input_filter_name = "look_ranged_alternate_fire"
	elseif use_ranged_filter then
		input_filter_name = "look_ranged"
	else
		input_filter_name = "look"
	end

	local mouse_input = input:get(input_filter_name)
	mouse_input.z = 0

	return mouse_input
end

function _gamepad_input(input, look_delta_context)
	local last_pressed_device = InputDevice.last_pressed_device

	if last_pressed_device and last_pressed_device:type() ~= "xbox_controller" then
		return Vector3.zero()
	end

	local weapon_action_component = look_delta_context.weapon_action_component
	local alternate_fire_component = look_delta_context.alternate_fire_component
	local targeting_data = look_delta_context.targeting_data
	local weapon_template = weapon_action_component and WeaponTemplate.current_weapon_template(weapon_action_component)
	local ranged_weapon_wielded = weapon_template and WeaponTemplate.is_ranged(weapon_template)
	local grenade_weapon_wielded = weapon_template and WeaponTemplate.is_grenade(weapon_template)
	local melee_weapon_wielded = weapon_template and WeaponTemplate.is_melee(weapon_template)
	local use_ranged_filter = ranged_weapon_wielded or grenade_weapon_wielded
	local use_melee_filter = melee_weapon_wielded
	local alternate_fire_is_active = alternate_fire_component and alternate_fire_component.is_active
	local targets_within_range = targeting_data and targeting_data.targets_within_range
	local is_sticky = look_delta_context.is_sticky
	local is_lunging = look_delta_context.is_lunging
	local new_input_filter_method = false
	local aim_assist_type = Managers.save:account_data().input_settings.controller_aim_assist

	if aim_assist_type ~= "old" then
		new_input_filter_method = true
	end

	local input_filter_name = nil

	if new_input_filter_method then
		if is_lunging then
			input_filter_name = "look_controller_lunging"
		elseif use_ranged_filter and alternate_fire_is_active then
			input_filter_name = "look_controller_ranged_alternate_fire_improved"
		elseif use_ranged_filter then
			input_filter_name = "look_controller_ranged_improved"
		else
			input_filter_name = "look_controller_improved"
		end
	elseif is_lunging then
		input_filter_name = "look_controller_lunging"
	elseif use_ranged_filter and alternate_fire_is_active then
		input_filter_name = "look_controller_ranged_alternate_fire"
	elseif use_ranged_filter then
		input_filter_name = "look_controller_ranged"
	elseif use_melee_filter and targets_within_range then
		if is_sticky then
			input_filter_name = "look_controller_melee_sticky"
		else
			input_filter_name = "look_controller_melee"
		end
	else
		input_filter_name = "look_controller"
	end

	local gamepad_input = input:get(input_filter_name)

	return gamepad_input
end

return Orientation
