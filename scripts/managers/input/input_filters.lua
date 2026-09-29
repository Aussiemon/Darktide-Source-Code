-- chunkname: @scripts/managers/input/input_filters.lua

local InputDevice = require("scripts/managers/input/input_device")
local UISettings = require("scripts/settings/ui/ui_settings")
local InputFilters = {}
local math_abs = math.abs
local math_acos = math.acos
local math_atan2 = math.atan2
local math_clamp = math.clamp
local math_lerp = math.lerp
local math_pow = math.pow
local math_sign = math.sign
local math_min = math.min
local math_max = math.max
local math_ease_out_exp = math.ease_out_exp
local math_pi = math.pi
local min, max = -100, 100

local function _k_value(k_min, k_max, strength)
	local lerp_t = (strength - min) / (max - min)

	return math_lerp(k_min, k_max, lerp_t)
end

local _response_curve_funcs = {
	linear = function (n, strength)
		return n
	end,
	exponential = function (n, strength)
		local k = _k_value(0.5, 2, strength)
		local abs_n = math_abs(n)
		local mod = abs_n^k * math_sign(n)

		return mod
	end,
	dynamic = function (n, strength)
		local k = _k_value(0.7, -0.7, strength)
		local mod
		local abs_n = math_abs(n)

		if abs_n > 0.5 then
			local numerator = -k * (2 * (abs_n - 0.5)) - 2 * (abs_n - 0.5)
			local denominator = 2 * -k * (2 * (abs_n - 0.5)) + k - 1

			mod = (numerator / denominator * 0.5 + 0.5) * math_sign(n)
		else
			mod = (k * 2 * abs_n - 2 * abs_n) / (2 * k * (2 * abs_n) - k - 1) * 0.5 * math_sign(n)
		end

		return mod
	end
}

InputFilters.vector3_default = function (default_value)
	return default_value:unbox()
end

InputFilters.default = function (default_value)
	return default_value
end

InputFilters.virtual_axis = {
	init = function (filter_data)
		return table.clone(filter_data)
	end,
	update = function (filter_data, input_service)
		local input_mappings = filter_data.input_mappings
		local right = input_service:get(input_mappings.right)
		local left = input_service:get(input_mappings.left)
		local forward = input_service:get(input_mappings.forward)
		local back = input_service:get(input_mappings.back)
		local up_key = input_mappings.up
		local up = up_key and input_service:get(up_key) or 0
		local down_key = input_mappings.down
		local down = down_key and input_service:get(down_key) or 0
		local result = Vector3(right - left, forward - back, up - down)

		return result
	end,
	edit_types = {
		{
			"up",
			"keymap",
			"soft_button",
			"input_mappings"
		},
		{
			"down",
			"keymap",
			"soft_button",
			"input_mappings"
		},
		{
			"left",
			"keymap",
			"soft_button",
			"input_mappings"
		},
		{
			"right",
			"keymap",
			"soft_button",
			"input_mappings"
		},
		{
			"forward",
			"keymap",
			"soft_button",
			"input_mappings"
		},
		{
			"back",
			"keymap",
			"soft_button",
			"input_mappings"
		}
	}
}
InputFilters.scale_vector3 = {
	init = function (filter_data)
		return table.clone(filter_data)
	end,
	update = function (filter_data, input_service)
		local settings = Managers.save:account_data().input_settings
		local invert_look_y = settings[filter_data.invert_look_y] and 1 or -1
		local scale = settings[filter_data.scale]
		local val = input_service:get(filter_data.input_mappings)

		val = Vector3.multiply_elements(val, Vector3(1, invert_look_y, 1))

		return val * scale
	end,
	edit_types = {
		{
			"multiplier",
			"number"
		}
	}
}
InputFilters.scale_vector3_xy_accelerated_x = {
	init = function (filter_data)
		local internal_filter_data = table.clone(filter_data)

		internal_filter_data.input_x = 0
		internal_filter_data.input_x_t = 0
		internal_filter_data.input_x_turnaround_t = 0
		internal_filter_data.multiplier_min_x = internal_filter_data.multiplier_min_x or internal_filter_data.multiplier_x * 0.25

		return internal_filter_data
	end,
	update = function (filter_data, input_service)
		local settings = Managers.save:account_data().input_settings
		local invert_look_y = settings[filter_data.invert_look_y] and -1 or 1
		local scale = settings[filter_data.scale]
		local scale_y = settings[filter_data.scale_y] or scale
		local response_curve_strength = settings[filter_data.response_curve_strength]
		local val = input_service:get(filter_data.input_mappings)

		val = Vector3.multiply_elements(val, Vector3(1, invert_look_y, 1))

		local mean_dt = Managers.time:mean_dt()
		local time = Application.time_since_launch()

		if filter_data.turnaround_threshold and math_abs(val.x) >= filter_data.turnaround_threshold and math_sign(val.x) ~= filter_data.input_x_turnaround then
			filter_data.input_x_turnaround = math_sign(val.x)
			filter_data.input_x_turnaround_t = time
		elseif math_abs(val.x) >= filter_data.threshold and math_sign(val.x) ~= filter_data.input_x then
			filter_data.input_x = math_sign(val.x)
			filter_data.input_x_t = time
		elseif math_abs(val.x) < filter_data.threshold then
			filter_data.input_x_t = time
		end

		if math_abs(val.x) < 0.1 then
			filter_data.input_x = 0
		end

		if filter_data.turnaround_threshold and math_abs(val.x) < filter_data.turnaround_threshold then
			filter_data.input_x_turnaround = 0
		end

		local x, y, z
		local elapsed_time = time - filter_data.input_x_t
		local turnaround_elapsed_time = time - filter_data.input_x_turnaround_t

		if math_abs(val.x) > 0.75 then
			val.y = val.y * (1 - (math_abs(val.x) - 0.75) / 0.25)
		end

		local response_curve = settings[filter_data.response_curve]

		if val.x ~= 0 then
			val.x = _response_curve_funcs[response_curve](val.x, response_curve_strength)
		end

		if val.y ~= 0 then
			val.y = _response_curve_funcs[response_curve](val.y, response_curve_strength)
		end

		if not settings[filter_data.enable_acceleration] then
			x = val.x * filter_data.multiplier_min_x
		elseif filter_data.turnaround_threshold and turnaround_elapsed_time >= filter_data.acceleration_delay + filter_data.turnaround_delay and math_abs(val.x) >= filter_data.turnaround_threshold then
			local value = math_clamp(elapsed_time - (filter_data.acceleration_delay + filter_data.turnaround_delay) / filter_data.turnaround_time_ref, 0, 1)
			local lerp_t = math_pow(value, filter_data.turnaround_power_of)

			x = val.x * math_lerp(filter_data.multiplier_min_x, filter_data.turnaround_multiplier_x, lerp_t)
		elseif elapsed_time >= filter_data.acceleration_delay then
			local value = math_clamp((elapsed_time - filter_data.acceleration_delay) / filter_data.accelerate_time_ref, 0, 1)

			x = val.x * math_lerp(filter_data.multiplier_min_x, filter_data.multiplier_x, math_pow(value, filter_data.power_of))
		else
			x = val.x * filter_data.multiplier_min_x
		end

		local multiplier_y = filter_data.multiplier_y

		if val.y ~= 0 and filter_data.multiplier_return_y and filter_data.angle_to_slow_down_inside then
			local player = Managers.player:local_player(1)
			local viewport_name = player.viewport_name
			local camera_rotation = Managers.state.camera:camera_rotation(viewport_name)
			local camera_forward = Quaternion.forward(camera_rotation)
			local camera_horizon = Vector3.flat(camera_forward)
			local dot = Vector3.dot(camera_forward, camera_horizon)
			local acos = math_acos(math_clamp(dot, -1, 1))
			local atan2 = math_atan2(camera_forward.z - camera_horizon.z, camera_forward.y - camera_horizon.y)
			local above_horizont = atan2 > 0
			local moving_down = val.y < 0
			local moving_towards_horizont = above_horizont and moving_down or not above_horizont and not moving_down

			if moving_towards_horizont then
				local slow_down_angle = filter_data.angle_to_slow_down_inside
				local lerp_value = math_clamp(acos / slow_down_angle, 0, 1)

				multiplier_y = math_lerp(filter_data.multiplier_y, filter_data.multiplier_return_y, lerp_value)
			end
		end

		y = val.y
		x = x * scale * mean_dt
		y = y * multiplier_y * scale_y * mean_dt
		z = val.z

		return Vector3(x, y, z)
	end,
	edit_types = {
		{
			"multiplier_x",
			"number"
		},
		{
			"multiplier_y",
			"number"
		}
	}
}

local function _motion_gravity_vector(dt, gravity_vector, input, radian_velocity)
	local current_gravity_vector = gravity_vector:unbox()
	local acceleration = input:get("acceleration")
	local rotation = Quaternion.axis_angle(-radian_velocity, Vector3.length(radian_velocity) * dt)

	current_gravity_vector = Quaternion.rotate(rotation, current_gravity_vector)

	local new_gravity = -acceleration
	local new_gravity_vector = current_gravity_vector + (new_gravity - current_gravity_vector) * 0.02

	gravity_vector:store(new_gravity_vector)

	return new_gravity_vector
end

local function _tiered_smoothed_motion(current_input, threshold, input_magnitude, filter_data)
	local motion_input_buffer_length = 6
	local lower_threshold = threshold / 4
	local direct_weight = math_clamp((input_magnitude - lower_threshold) / (threshold - lower_threshold), 0, 1)
	local weighted_current_input = current_input * (1 - direct_weight)
	local smoothing_input_buffer = filter_data.motion_smoothing_input_buffer

	filter_data.motion_current_smoothing_input_index = filter_data.motion_current_smoothing_input_index % motion_input_buffer_length + 1

	if not smoothing_input_buffer[filter_data.motion_current_smoothing_input_index] then
		smoothing_input_buffer[filter_data.motion_current_smoothing_input_index] = Vector3Box(0, 0, 0)
	end

	smoothing_input_buffer[filter_data.motion_current_smoothing_input_index]:store(weighted_current_input)

	local averaged_smoothed_input = Vector3.zero()

	for _, input in ipairs(smoothing_input_buffer) do
		local val = Vector3Box.unbox(input)

		averaged_smoothed_input = averaged_smoothed_input + val
	end

	averaged_smoothed_input = averaged_smoothed_input / motion_input_buffer_length

	return current_input * direct_weight + averaged_smoothed_input
end

local function _tiered_smoothed_stick_rotation(angle_change, filter_data)
	local flick_input_buffer_length = 6
	local turn_smooth_threshold = 0.1
	local half_turn_smooth_threshold = turn_smooth_threshold / 2
	local input_magnitude = math_abs(angle_change)
	local direct_weight = math_clamp((input_magnitude - half_turn_smooth_threshold) / (turn_smooth_threshold - half_turn_smooth_threshold), 0, 1)
	local weighted_angle_change = angle_change * (1 - direct_weight)
	local smoothing_input_buffer = filter_data.flick_smoothing_input_buffer

	filter_data.flick_current_smoothing_input_index = filter_data.flick_current_smoothing_input_index % flick_input_buffer_length + 1
	smoothing_input_buffer[filter_data.flick_current_smoothing_input_index] = weighted_angle_change

	local averaged_smoothed_change = 0

	for _, val in ipairs(smoothing_input_buffer) do
		averaged_smoothed_change = averaged_smoothed_change + val
	end

	averaged_smoothed_change = averaged_smoothed_change / flick_input_buffer_length

	return angle_change * direct_weight + averaged_smoothed_change
end

local function _motion_acceleration(current_input, settings, fast_multiplier, input_magnitude)
	local lower_threshold = settings.controller_motion_acceleration_start_threshold
	local zone_size = settings.controller_motion_acceleration_zone_size
	local threshold = lower_threshold + zone_size
	local direct_weight = math_clamp((input_magnitude - lower_threshold) / (threshold - lower_threshold), 0, 1)

	return current_input * (1 - direct_weight) + fast_multiplier * current_input * direct_weight
end

local function _steadied_motion(current_input, steadying_threshold, input_magnitude)
	if input_magnitude < steadying_threshold then
		local input_scale = input_magnitude / steadying_threshold

		current_input = current_input * input_scale
	end

	return current_input
end

local function _eased_turn(dt, turn_time, turn_size, filter_data)
	local last_turn_progress = filter_data.turn_progress
	local temp_turn_progress = filter_data.turn_progress + dt

	filter_data.turn_progress = math_min(temp_turn_progress, turn_time)

	local last_per_one = last_turn_progress / turn_time
	local this_per_one = filter_data.turn_progress / turn_time
	local warped_last_per_one = math_ease_out_exp(last_per_one)
	local warped_this_per_one = temp_turn_progress < turn_time and math_ease_out_exp(this_per_one) or 1

	return Vector3((warped_this_per_one - warped_last_per_one) * turn_size, 0, 0)
end

local LAST_TURN = Vector3Box(0, 0, 0)

local function _update_flick_stick(dt, input, filter_data)
	local last_turn = LAST_TURN
	local gamepad_override = Vector3.zero()
	local flick_threshold = 0.9
	local flick_time = 0.1
	local last_input = last_turn:unbox()
	local current_input = input:get("look_raw_controller")
	local length = Vector3.length(current_input)
	local last_length = Vector3.length(last_input)

	last_turn:store(current_input)

	if flick_threshold <= length then
		if last_length < flick_threshold then
			filter_data.turn_progress = 0
		else
			local stick_angle = math_atan2(-current_input.x, current_input.y)
			local last_stick_angle = math_atan2(-last_input.x, last_input.y)
			local angle_change = stick_angle - last_stick_angle

			if angle_change > 1 or angle_change < -1 then
				angle_change = 0
			end

			local smoothed_change = _tiered_smoothed_stick_rotation(angle_change, filter_data)

			gamepad_override = Vector3(-smoothed_change, 0, 0)
		end
	elseif flick_threshold <= last_length then
		local flick_smoothing_input_buffer = filter_data.flick_smoothing_input_buffer

		table.clear(flick_smoothing_input_buffer)

		filter_data.flick_current_smoothing_input_index = 0
	end

	if flick_time > filter_data.turn_progress then
		local flick_size = math_atan2(current_input.x, current_input.y)

		gamepad_override = _eased_turn(dt, flick_time, flick_size, filter_data)
	end

	return gamepad_override
end

local function _update_quick_turn_tilt(dt, input, filter_data)
	local gamepad_override
	local angular_velocity = input:get("angular_velocity")
	local up_tilt = angular_velocity and angular_velocity.x > 0 and angular_velocity.x or 0
	local quick_turn_time = 0.15

	if up_tilt > 4 and filter_data.turn_progress == quick_turn_time then
		filter_data.turn_progress = 0
	end

	if quick_turn_time > filter_data.turn_progress then
		local one_eighty = math_pi

		gamepad_override = _eased_turn(dt, quick_turn_time, one_eighty, filter_data)
	else
		filter_data.turn_progress = quick_turn_time
	end

	return gamepad_override
end

InputFilters.scale_vector3_angular_velocity = {
	init = function (filter_data)
		local internal_filter_data = table.clone(filter_data)

		internal_filter_data.radian_scale = math_pi * 2 / 373
		internal_filter_data.gravity_vector = Vector3Box(0, 0, 0)
		internal_filter_data.motion_smoothing_input_buffer = {}
		internal_filter_data.motion_current_smoothing_input_index = 0
		internal_filter_data.flick_smoothing_input_buffer = {}
		internal_filter_data.flick_current_smoothing_input_index = 0
		internal_filter_data.turn_progress = 1
		internal_filter_data.return_table = {
			active = false,
			override = false,
			input = Vector3.zero()
		}

		return internal_filter_data
	end,
	update = function (filter_data, input_service)
		local dt = Managers.time:mean_dt()
		local settings = Managers.save:account_data().input_settings
		local motion_template = settings.controller_motion_template
		local state = filter_data.state
		local apply_motion = false

		if motion_template == "all" then
			apply_motion = true
		elseif state == motion_template then
			apply_motion = true
		elseif state == "ranged_alternate_fire" and motion_template == "ranged" then
			apply_motion = true
		elseif (state == "melee" or state == "ranged_alternate_fire") and motion_template == "melee_ranged_alternate_fire" then
			apply_motion = true
		end

		local motion_input = Vector3.zero()
		local gamepad_override
		local disable_motion = settings.controller_motion_touchbar_disable_motion

		if disable_motion then
			local touch_input = input_service:get("touch_1")
			local stop_motion = touch_input.z ~= -1

			if stop_motion then
				apply_motion = false
			end
		end

		local return_table = filter_data.return_table

		if apply_motion then
			local invert_look_y = settings[filter_data.invert_look_y] and -1 or 1
			local scale = settings[filter_data.scale]
			local val = input_service:get(filter_data.input_mappings)

			val = Vector3.multiply_elements(val, Vector3(invert_look_y, 1, 1))

			local radian_scale = filter_data.radian_scale
			local radian_velocity = Vector3.multiply(val, radian_scale)
			local old_gravity_vector = filter_data.gravity_vector
			local current_gravity_vector = _motion_gravity_vector(dt, old_gravity_vector, input_service, radian_velocity)

			scale = (settings[filter_data.sensitivity_modifier] or filter_data.sensitivity_modifier) * scale

			local vertical_multiplier = settings.controller_motion_look_vertical_multiplier
			local magnitude_x = (radian_velocity.y * current_gravity_vector.y + radian_velocity.z * current_gravity_vector.z) * scale
			local magnitude_y = radian_velocity.x * scale * vertical_multiplier

			motion_input.x = magnitude_x
			motion_input.y = magnitude_y

			local degrees_per_second = math_abs(Vector3.length(motion_input / radian_scale)) / dt
			local fast_multiplier = settings.controller_motion_acceleration_fast_multiplier

			if fast_multiplier > 1 then
				motion_input = _motion_acceleration(motion_input, settings, fast_multiplier, degrees_per_second)
			end

			local steadying_threshold = settings.controller_motion_steadying_threshold

			if steadying_threshold > 0 then
				motion_input = _steadied_motion(motion_input, steadying_threshold, degrees_per_second)
			end

			local smoothing_threshold = settings.controller_motion_smoothing_threshold

			if smoothing_threshold > 0 then
				motion_input = _tiered_smoothed_motion(motion_input, smoothing_threshold, degrees_per_second, filter_data)
			end

			local flick_stick = settings.controller_motion_flick_stick

			if flick_stick then
				gamepad_override = _update_flick_stick(dt, input_service, filter_data)
			end

			return_table.active = true
		else
			local quick_turn_tilt = settings.controller_motion_disabled_quick_turn_tilt

			if quick_turn_tilt then
				gamepad_override = _update_quick_turn_tilt(dt, input_service, filter_data)
			end

			return_table.active = false
		end

		if gamepad_override then
			return_table.input = motion_input + gamepad_override
			return_table.override = true
		else
			return_table.input = motion_input
			return_table.override = false
		end

		return return_table
	end,
	edit_types = {
		{
			"multiplier",
			"number"
		}
	}
}
InputFilters.vector_y = {
	init = function (filter_data)
		local new_filter_data = table.clone(filter_data)

		new_filter_data.scale = new_filter_data.scale or 1

		return new_filter_data
	end,
	update = function (filter_data, input_service)
		local input = input_service:get(filter_data.input_mappings)

		return input.y * filter_data.scale
	end
}
InputFilters.vector_x = {
	init = function (filter_data)
		local new_filter_data = table.clone(filter_data)

		new_filter_data.scale = new_filter_data.scale or 1

		return new_filter_data
	end,
	update = function (filter_data, input_service)
		local input = input_service:get(filter_data.input_mappings)

		return input.x * filter_data.scale
	end
}
InputFilters["or"] = {
	init = function (filter_data)
		return table.clone(filter_data)
	end,
	update = function (filter_data, input_service)
		for _, input_mapping in pairs(filter_data.input_mappings) do
			if input_service:get(input_mapping) == true then
				return true
			end
		end

		return false
	end
}
InputFilters["and"] = {
	init = function (filter_data)
		return table.clone(filter_data)
	end,
	update = function (filter_data, input_service)
		for _, input_mapping in pairs(filter_data.input_mappings) do
			if input_service:get(input_mapping) == false then
				return false
			end
		end

		return true
	end
}
InputFilters["not"] = {
	init = function (filter_data)
		return table.clone(filter_data)
	end,
	update = function (filter_data, input_service)
		for _, input_mapping in pairs(filter_data.input_mappings) do
			if not input_service:get(input_mapping) then
				return true
			end
		end
	end
}
InputFilters.scalar_combine = {
	init = function (filter_data)
		return table.clone(filter_data)
	end,
	update = function (filter_data, input_service)
		local return_value = 0

		for source, input_mapping in pairs(filter_data.input_mappings) do
			return_value = return_value + input_service:get(input_mapping)
		end

		if filter_data.max_value then
			return_value = math_min(return_value, filter_data.max_value)
		end

		if filter_data.min_value then
			return_value = math_max(return_value, filter_data.min_value)
		end

		if filter_data.to_bool then
			return_value = return_value > 0.5
		end

		return return_value
	end
}
InputFilters.axis_combine = {
	init = function (filter_data)
		return table.clone(filter_data)
	end,
	update = function (filter_data, input_service)
		local return_vector = Vector3(0, 0, 0)

		for source, input_mapping in pairs(filter_data.input_mappings) do
			local new_vector = input_service:get(input_mapping)

			if Vector3.length(new_vector) > Vector3.length(return_vector) then
				return_vector = new_vector
			end
		end

		return return_vector
	end
}
InputFilters.navigate_filter_continuous = {
	init = function (filter_data)
		local new_filter_data = table.clone(filter_data)
		local axis = Vector3(unpack(filter_data.axis))

		axis = Vector3.normalize(axis)
		new_filter_data.axis = Vector3Box(axis)
		new_filter_data.cooldown = 0
		new_filter_data.cooldown_speed_multiplier = 1

		return new_filter_data
	end,
	update = function (filter_data, input_service)
		local dt = Managers.time:mean_dt()

		filter_data.cooldown = math_max(filter_data.cooldown - dt, 0)

		local disabled = filter_data.cooldown > 0
		local input_mapping_found = false

		for _, input_mapping in pairs(filter_data.input_mappings) do
			if input_service:get(input_mapping) then
				input_mapping_found = true

				break
			end
		end

		local axis_mapping_found = false
		local axis = filter_data.axis:unbox()

		for _, axis_mapping in pairs(filter_data.axis_mappings) do
			local axis_state = input_service:get(axis_mapping)

			if axis_state and Vector3.dot(axis_state, axis) >= filter_data.threshold then
				axis_mapping_found = true

				break
			end
		end

		local menu_navigation_settings = UISettings.menu_navigation

		if disabled and (input_mapping_found or axis_mapping_found) then
			local min_multiplier = menu_navigation_settings.view_min_speed_multiplier
			local view_speed_multiplier_decrease = menu_navigation_settings.view_speed_multiplier_decrease

			filter_data.cooldown_speed_multiplier = math_max(filter_data.cooldown_speed_multiplier - view_speed_multiplier_decrease * dt, min_multiplier)
		end

		if not input_mapping_found and not axis_mapping_found then
			filter_data.cooldown_speed_multiplier = 1
			filter_data.cooldown = 0
		end

		if not disabled and (input_mapping_found or axis_mapping_found) then
			local gamepad_active = InputDevice.gamepad_active
			local cooldown

			if input_mapping_found then
				cooldown = menu_navigation_settings.button_navigation_cooldown
			elseif gamepad_active then
				cooldown = menu_navigation_settings.gamepad_view_cooldown
			else
				cooldown = menu_navigation_settings.view_cooldown
			end

			filter_data.cooldown = cooldown * filter_data.cooldown_speed_multiplier

			return true
		end

		return false
	end
}
InputFilters.navigate_filter_continuous_fast = {
	init = function (filter_data)
		local new_filter_data = table.clone(filter_data)
		local axis = Vector3(unpack(filter_data.axis))

		axis = Vector3.normalize(axis)
		new_filter_data.axis = Vector3Box(axis)
		new_filter_data.cooldown = 0
		new_filter_data.cooldown_speed_multiplier = 1

		return new_filter_data
	end,
	update = function (filter_data, input_service)
		local dt = Managers.time:mean_dt()

		filter_data.cooldown = math_max(filter_data.cooldown - dt, 0)

		local disabled = filter_data.cooldown > 0
		local input_mapping_found = false

		for _, input_mapping in pairs(filter_data.input_mappings) do
			if input_service:get(input_mapping) then
				input_mapping_found = true

				break
			end
		end

		local axis_mapping_found = false
		local axis = filter_data.axis:unbox()

		for _, axis_mapping in pairs(filter_data.axis_mappings) do
			local axis_state = input_service:get(axis_mapping)

			if axis_state and Vector3.dot(axis_state, axis) >= filter_data.threshold then
				axis_mapping_found = true

				break
			end
		end

		local menu_navigation_settings = UISettings.menu_navigation

		if disabled and (input_mapping_found or axis_mapping_found) then
			local min_multiplier = menu_navigation_settings.view_min_fast_speed_multiplier
			local view_speed_multiplier_decrease = menu_navigation_settings.view_speed_multiplier_decrease

			filter_data.cooldown_speed_multiplier = math_max(filter_data.cooldown_speed_multiplier - view_speed_multiplier_decrease * dt, min_multiplier)
		end

		if not input_mapping_found and not axis_mapping_found then
			filter_data.cooldown_speed_multiplier = 1
			filter_data.cooldown = 0
		end

		if not disabled and (input_mapping_found or axis_mapping_found) then
			local gamepad_active = InputDevice.gamepad_active
			local cooldown

			if input_mapping_found then
				cooldown = menu_navigation_settings.button_navigation_cooldown
			elseif gamepad_active then
				cooldown = menu_navigation_settings.gamepad_view_fast_cooldown
			else
				cooldown = menu_navigation_settings.view_fast_cooldown
			end

			filter_data.cooldown = cooldown * filter_data.cooldown_speed_multiplier

			return true
		end

		return false
	end
}
InputFilters.navigate_axis_filter_continuous = {
	init = function (filter_data)
		local new_filter_data = table.clone(filter_data)

		new_filter_data.cooldown = 0
		new_filter_data.cooldown_speed_multiplier = 1
		new_filter_data.initial_cooldown = filter_data.initial_cooldown or UISettings.menu_navigation.view_cooldown
		new_filter_data.threshold_length = filter_data.threshold_length or 0.05

		return new_filter_data
	end,
	update = function (filter_data, input_service)
		local dt = Managers.time:mean_dt()

		filter_data.cooldown = math_max(filter_data.cooldown - dt, 0)

		local disabled = filter_data.cooldown > 0
		local input_vector = Vector3(0, 0, 0)
		local input_vector_length = 0

		for _, input_mapping in pairs(filter_data.input_mappings) do
			local new_vector = input_service:get(input_mapping)
			local new_vector_length = Vector3.length(new_vector)

			if input_vector_length < new_vector_length and new_vector_length > filter_data.threshold_length then
				input_vector = new_vector
				input_vector_length = new_vector_length
			end
		end

		local menu_navigation_settings = UISettings.menu_navigation

		if input_vector_length == 0 then
			filter_data.cooldown_speed_multiplier = 1
			filter_data.cooldown = 0
		elseif disabled and input_vector_length > 0 then
			local min_multiplier = menu_navigation_settings.view_min_speed_multiplier
			local view_speed_multiplier_decrease = menu_navigation_settings.view_speed_multiplier_decrease

			filter_data.cooldown_speed_multiplier = math_max(filter_data.cooldown_speed_multiplier - view_speed_multiplier_decrease * dt, min_multiplier)
			input_vector = Vector3(0, 0, 0)
		elseif not disabled and input_vector_length > 0 then
			filter_data.cooldown = filter_data.initial_cooldown * filter_data.cooldown_speed_multiplier

			Vector3.normalize(input_vector)
		end

		return input_vector
	end
}
InputFilters.mouse_angle_constrained = {
	init = function (filter_data)
		local new_filter_data = table.clone(filter_data)

		new_filter_data.current_pos = Vector3Box(Vector3(0, 0, 0))

		return new_filter_data
	end,
	update = function (filter_data, input_service)
		local input = input_service:get(filter_data.input_mappings)
		local current_pos = filter_data.current_pos:unbox()

		current_pos = current_pos + input
		current_pos = Vector3.clamp(current_pos, -filter_data.constraint, filter_data.constraint)
		filter_data.current_pos = Vector3Box(current_pos)

		return math_atan2(current_pos.y, current_pos.x)
	end
}

return InputFilters
