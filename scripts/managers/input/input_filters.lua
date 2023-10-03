local UISettings = require("scripts/settings/ui/ui_settings")
local InputFilters = {}
local math_abs = math.abs
local math_acos = math.acos
local math_atan2 = math.atan2
local math_clamp = math.clamp
local math_lerp = math.lerp
local math_pow = math.pow
local math_sign = math.sign

local function _input_threshold(input_axis, threshold)
	local length = Vector3.length(input_axis)

	if length < threshold then
		input_axis.x = 0
		input_axis.y = 0
		input_axis.z = 0
	end
end

local min = -100
local max = 100

local function _k_value(k_min, k_max, strength)
	local lerp_t = (strength - min) / (max - min)

	return math.lerp(k_min, k_max, lerp_t)
end

local _response_curve_funcs = {
	linear = function (n, strength)
		return n
	end,
	exponential = function (n, strength)
		local k = _k_value(0.5, 2, strength)
		local abs_n = math.abs(n)
		local mod = abs_n^k * math.sign(n)

		return mod
	end,
	dynamic = function (n, strength)
		local k = _k_value(0.7, -0.7, strength)
		local mod = nil
		local abs_n = math.abs(n)

		if abs_n > 0.5 then
			local numerator = -k * 2 * (abs_n - 0.5) - 2 * (abs_n - 0.5)
			local denominator = 2 * -k * 2 * (abs_n - 0.5) + k - 1
			mod = (numerator / denominator * 0.5 + 0.5) * math.sign(n)
		else
			mod = (k * 2 * abs_n - 2 * abs_n) / (2 * k * 2 * abs_n - k - 1) * 0.5 * math.sign(n)
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
		local multiplier = settings[filter_data.multiplier]
		local val = input_service:get(filter_data.input_mappings)
		val = Vector3.multiply_elements(val, Vector3(1, invert_look_y, 1))

		_input_threshold(val, settings[filter_data.input_threshold] or 0)

		return val * multiplier
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
		local multiplier = settings[filter_data.multiplier]
		local response_curve_strength = settings[filter_data.response_curve_strength]
		local val = input_service:get(filter_data.input_mappings)
		val = Vector3.multiply_elements(val, Vector3(1, invert_look_y, 1))

		_input_threshold(val, settings[filter_data.input_threshold] or 0)

		local mean_dt = Managers.time:mean_dt()
		local time = Application.time_since_launch()

		if filter_data.turnaround_threshold and filter_data.turnaround_threshold <= math_abs(val.x) and math_sign(val.x) ~= filter_data.input_x_turnaround then
			filter_data.input_x_turnaround = math_sign(val.x)
			filter_data.input_x_turnaround_t = time
		elseif filter_data.threshold <= math_abs(val.x) and math_sign(val.x) ~= filter_data.input_x then
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

		local x, y, z = nil
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
		elseif filter_data.turnaround_threshold and turnaround_elapsed_time >= filter_data.acceleration_delay + filter_data.turnaround_delay and filter_data.turnaround_threshold <= math_abs(val.x) then
			local value = math_clamp(elapsed_time - (filter_data.acceleration_delay + filter_data.turnaround_delay) / filter_data.turnaround_time_ref, 0, 1)
			local lerp_t = math_pow(value, filter_data.turnaround_power_of)
			x = val.x * math_lerp(filter_data.multiplier_min_x, filter_data.turnaround_multiplier_x, lerp_t)
		elseif filter_data.acceleration_delay <= elapsed_time then
			local value = math_clamp((elapsed_time - filter_data.acceleration_delay) / filter_data.accelerate_time_ref, 0, 1)
			x = val.x * math_lerp(filter_data.multiplier_min_x, filter_data.multiplier_x, math_pow(value, filter_data.power_of))
		else
			x = val.x * filter_data.multiplier_min_x
		end

		local multiplier_y = filter_data.multiplier_y

		if val.y ~= 0 and filter_data.multiplier_return_y and filter_data.angle_to_slow_down_inside then
			local player = Managers.player:local_player()
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
		x = x * multiplier * mean_dt
		y = y * multiplier_y * multiplier * mean_dt
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
InputFilters.vector_y = {
	init = function (filter_data)
		local new_filter_data = table.clone(filter_data)
		new_filter_data.multiplier = new_filter_data.multiplier or 1

		return new_filter_data
	end,
	update = function (filter_data, input_service)
		local input = input_service:get(filter_data.input_mappings)

		return input.y * filter_data.multiplier
	end
}
InputFilters.vector_x = {
	init = function (filter_data)
		local new_filter_data = table.clone(filter_data)
		new_filter_data.multiplier = new_filter_data.multiplier or 1

		return new_filter_data
	end,
	update = function (filter_data, input_service)
		local input = input_service:get(filter_data.input_mappings)

		return input.x * filter_data.multiplier
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
			return_value = math.min(return_value, filter_data.max_value)
		end

		if filter_data.min_value then
			return_value = math.max(return_value, filter_data.min_value)
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

			if Vector3.length(return_vector) < Vector3.length(new_vector) then
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
		filter_data.cooldown = math.max(filter_data.cooldown - dt, 0)
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

			if axis_state and filter_data.threshold <= Vector3.dot(axis_state, axis) then
				axis_mapping_found = true

				break
			end
		end

		local menu_navigation_settings = UISettings.menu_navigation

		if disabled and (input_mapping_found or axis_mapping_found) then
			local min_multiplier = menu_navigation_settings.view_min_speed_multiplier
			local view_speed_multiplier_decrease = menu_navigation_settings.view_speed_multiplier_decrease
			filter_data.cooldown_speed_multiplier = math.max(filter_data.cooldown_speed_multiplier - view_speed_multiplier_decrease * dt, min_multiplier)
		end

		if not input_mapping_found and not axis_mapping_found then
			filter_data.cooldown_speed_multiplier = 1
			filter_data.cooldown = 0
		end

		if not disabled and (input_mapping_found or axis_mapping_found) then
			local using_gamepad = Managers.input:device_in_use("gamepad")
			local cooldown = nil

			if input_mapping_found then
				cooldown = menu_navigation_settings.button_navigation_cooldown
			elseif using_gamepad then
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
		filter_data.cooldown = math.max(filter_data.cooldown - dt, 0)
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

			if axis_state and filter_data.threshold <= Vector3.dot(axis_state, axis) then
				axis_mapping_found = true

				break
			end
		end

		local menu_navigation_settings = UISettings.menu_navigation

		if disabled and (input_mapping_found or axis_mapping_found) then
			local min_multiplier = menu_navigation_settings.view_min_fast_speed_multiplier
			local view_speed_multiplier_decrease = menu_navigation_settings.view_speed_multiplier_decrease
			filter_data.cooldown_speed_multiplier = math.max(filter_data.cooldown_speed_multiplier - view_speed_multiplier_decrease * dt, min_multiplier)
		end

		if not input_mapping_found and not axis_mapping_found then
			filter_data.cooldown_speed_multiplier = 1
			filter_data.cooldown = 0
		end

		if not disabled and (input_mapping_found or axis_mapping_found) then
			local using_gamepad = Managers.input:device_in_use("gamepad")
			local cooldown = nil

			if input_mapping_found then
				cooldown = menu_navigation_settings.button_navigation_cooldown
			elseif using_gamepad then
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
		filter_data.cooldown = math.max(filter_data.cooldown - dt, 0)
		local disabled = filter_data.cooldown > 0
		local input_vector = Vector3(0, 0, 0)
		local input_vector_length = 0

		for _, input_mapping in pairs(filter_data.input_mappings) do
			local new_vector = input_service:get(input_mapping)
			local new_vector_length = Vector3.length(new_vector)

			if input_vector_length < new_vector_length and filter_data.threshold_length < new_vector_length then
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
			filter_data.cooldown_speed_multiplier = math.max(filter_data.cooldown_speed_multiplier - view_speed_multiplier_decrease * dt, min_multiplier)
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

		return math.atan2(current_pos.y, current_pos.x)
	end
}

return InputFilters
