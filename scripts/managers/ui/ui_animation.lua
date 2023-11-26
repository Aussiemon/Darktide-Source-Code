-- chunkname: @scripts/managers/ui/ui_animation.lua

require("scripts/extension_systems/dialogue/utils/varargs")

local UIAnimation = {
	catmullrom = {
		num_args = 8,
		num_data = 1,
		init = function (target, target_index, target_value, p0, p1, p2, p3, time)
			if target_index then
				target[target_index] = p1 * target_value
			else
				local start_value = p1 * target_value

				for i = 1, #target do
					target[i] = start_value
				end
			end

			return 0
		end,
		update = function (dt, target, target_index, target_value, p0, p1, p2, p3, time, progressed_time)
			progressed_time = progressed_time + dt

			local progress_fraction = math.min(progressed_time / time, 1)
			local catmullrom_value = math.catmullrom(progress_fraction, p0, p1, p2, p3)
			local new_value = catmullrom_value * target_value

			if target_index then
				target[target_index] = new_value
			else
				for i = 1, #target do
					target[i] = new_value
				end
			end

			return progressed_time <= time, progressed_time
		end
	},
	size_offset_scale = {
		num_args = 9,
		num_data = 1,
		init = function (target, offset_target, target_index, target_value, p0, p1, p2, p3, time)
			local start_value = p1 * target_value
			local value_diff = (target_value - start_value) * 0.5

			if target_index then
				target[target_index] = start_value
				offset_target[target_index] = value_diff
			else
				for i = 1, #target do
					target[i] = start_value
					offset_target[i] = value_diff
				end
			end

			return 0
		end,
		update = function (dt, target, offset_target, target_index, target_value, p0, p1, p2, p3, time, progressed_time)
			progressed_time = progressed_time + dt

			local progress_fraction = math.min(progressed_time / time, 1)
			local catmullrom_value = math.catmullrom(progress_fraction, p0, p1, p2, p3)
			local new_value = catmullrom_value * target_value
			local value_diff = (target_value - new_value) * 0.5

			if target_index then
				target[target_index] = new_value
				offset_target[target_index] = value_diff
			else
				for i = 1, #target do
					target[i] = new_value
					offset_target[i] = value_diff
				end
			end

			return progressed_time <= time, progressed_time
		end
	},
	pulse_animation = {
		num_args = 5,
		num_data = 1,
		init = function (target, target_index, min, max, speed)
			target[target_index] = min

			return 0
		end,
		update = function (dt, target, target_index, min, max, speed, progressed_time)
			progressed_time = progressed_time + dt

			local wave_value = math.sin(progressed_time * speed)
			local current_value = min + wave_value * wave_value * (max - min)

			target[target_index] = current_value

			return true, progressed_time
		end
	},
	pulse_animation2 = {
		num_args = 4,
		num_data = 1,
		init = function (target, target_index, min, max, speed)
			return 0
		end,
		update = function (dt, target, min, max, speed, progressed_time)
			progressed_time = progressed_time + dt

			local wave_value = math.sin(progressed_time * speed)

			for target_index, target_value in pairs(target) do
				local current_value = min[target_index] + wave_value * wave_value * (max[target_index] - min[target_index])

				target[target_index] = math.floor(current_value)
			end

			return true, progressed_time
		end
	},
	pulse_animation3 = {
		num_args = 6,
		num_data = 1,
		init = function (target, target_index, origin, mod, speed, time)
			return 0
		end,
		update = function (dt, target, target_index, origin, mod, speed, time, progressed_time)
			progressed_time = progressed_time + dt * speed

			local alive = progressed_time <= time * speed
			local value

			if alive then
				value = math.sirp(origin, mod, progressed_time)
			else
				value = origin
			end

			target[target_index] = value

			return alive, progressed_time
		end
	},
	text_flash = {
		num_args = 6,
		num_data = 1,
		init = function (target, target_index, origin, mod, speed, time)
			return 0
		end,
		update = function (dt, target, target_index, origin, mod, speed, time, progressed_time)
			progressed_time = progressed_time + dt * speed

			local alive = progressed_time <= time * speed
			local value

			if alive then
				value = math.sirp(origin, mod, progressed_time)
			else
				value = origin
			end

			for i = 2, #target do
				target[i] = value
			end

			return alive, progressed_time
		end
	},
	update_function_by_time = {
		num_args = 6,
		num_data = 1,
		init = function (target, target_index, from, to, time, func_ptr)
			target[target_index] = from

			return 0
		end,
		update = function (dt, target, target_index, from, to, time, func_ptr, progressed_time)
			progressed_time = progressed_time + dt
			target[target_index] = from + func_ptr(progressed_time) * (to - from)

			return true, progressed_time
		end
	},
	linear_scale2 = {
		num_args = 6,
		num_data = 1,
		init = function (target, from_x, from_y, to_x, to_y, time)
			return 0
		end,
		update = function (dt, target, from_x, from_y, to_x, to_y, time, progressed_time)
			progressed_time = progressed_time + dt

			local delta_time = progressed_time / time

			target[1] = (to_x - from_x) * delta_time + from_x
			target[2] = (to_y - from_y) * delta_time + from_y

			return progressed_time <= time, progressed_time
		end
	},
	linear_scale_color = {
		num_args = 8,
		num_data = 1,
		init = function (target, from_2, from_3, from_4, to_2, to_3, to_4, time)
			return 0
		end,
		update = function (dt, target, from_2, from_3, from_4, to_2, to_3, to_4, time, progressed_time)
			progressed_time = progressed_time + dt

			local delta_time = math.min(1, progressed_time / time)

			target[2] = (to_2 - from_2) * delta_time + from_2
			target[3] = (to_3 - from_3) * delta_time + from_3
			target[4] = (to_4 - from_4) * delta_time + from_4

			return progressed_time <= time, progressed_time
		end
	},
	function_by_time = {
		num_args = 6,
		num_data = 1,
		init = function (target, target_index, from, to, time, func_ptr, offset_value)
			target[target_index] = from

			return 0
		end,
		update = function (dt, target, target_index, from, to, time, func_ptr, progressed_time)
			progressed_time = progressed_time + dt

			local delta_time = math.min(1, progressed_time / time)

			target[target_index] = from + func_ptr(delta_time) * (to - from)

			return progressed_time <= time, progressed_time
		end
	},
	function_by_time_with_offset = {
		num_args = 7,
		num_data = 1,
		init = function (target, target_index, from, to, time, offset, func_ptr)
			target[target_index] = from

			return 0
		end,
		update = function (dt, target, target_index, from, to, time, offset, func_ptr, progressed_time)
			progressed_time = progressed_time + dt

			local delta_time = math.min(1, progressed_time / time)

			target[target_index] = from + func_ptr(delta_time, offset) * (to - from)

			return progressed_time <= time, progressed_time
		end
	},
	linear_scale = {
		num_args = 5,
		num_data = 1,
		init = function (target, target_index, from, to, time)
			target[target_index] = from

			return 0
		end,
		update = function (dt, target, target_index, from, to, time, progressed_time)
			progressed_time = progressed_time + dt

			local delta_time = math.min(1, progressed_time / time)

			target[target_index] = (to - from) * delta_time + from

			return progressed_time <= time, progressed_time
		end
	},
	wait = {
		num_args = 1,
		num_data = 1,
		init = function (time)
			return 0
		end,
		update = function (dt, time, progressed_time)
			progressed_time = progressed_time + dt

			return progressed_time <= time, progressed_time
		end
	},
	set_visible = {
		num_args = 1,
		num_data = 0,
		init = function ()
			return
		end,
		update = function (dt, target)
			target.visible = true

			return false
		end
	},
	set_invisible = {
		num_args = 1,
		num_data = 0,
		init = function ()
			return
		end,
		update = function (dt, target)
			target.visible = false

			return false
		end
	},
	picture_sequence = {
		num_args = 4,
		num_data = 2,
		init = function (target, target_index, pictures, total_time)
			local num_pictures = #pictures
			local time_step = total_time / num_pictures

			return 0, time_step
		end,
		update = function (dt, target, target_index, pictures, total_time, progressed_time, time_step)
			progressed_time = math.min(progressed_time + dt, total_time)

			local picture_id = math.floor(progressed_time / time_step) + 1
			local picture = pictures[picture_id] or pictures[#pictures]

			target[target_index] = picture

			return progressed_time < total_time, progressed_time, time_step
		end
	},
	timestep_setter_tables = {
		num_args = 4,
		num_data = 1,
		init = function ()
			return 0
		end,
		update = function (dt, target, target_index, timer_steps, values, progressed_time)
			progressed_time = progressed_time + dt

			local timer_index

			for i = 1, #timer_steps do
				local timer_step = timer_steps[i]

				if progressed_time < timer_step then
					timer_index = i

					break
				end
			end

			local timer_value = values[timer_index or #values]

			target[target_index] = timer_value

			return timer_index and true or false, progressed_time
		end
	}
}

UIAnimation.init = function (...)
	local data_array = {}
	local ui_animation = {
		current_index = 1,
		data_array = data_array
	}
	local num_varargs = select("#", ...)
	local i = 0
	local current_index = 0

	while i < num_varargs do
		i = i + 1

		local animation_type = select(i, ...)
		local num_args = animation_type.num_args

		data_array[current_index + 1] = animation_type

		for j = 1, num_args do
			data_array[current_index + 1 + j] = select(i + j, ...)
		end

		current_index = current_index + 1 + num_args + animation_type.num_data
		i = i + num_args
	end

	local num_args = data_array[1].num_args
	local num_data = data_array[1].num_data
	local pack_func = pack_index[num_data]
	local unpack_func = unpack_index[num_args]

	pack_func(data_array, 2 + num_args, data_array[1].init(unpack_func(data_array, 2)))

	return ui_animation
end

local function _debug_print_ui_animation(...)
	Log.set_global_log_level(Log.INFO)
	Log.info("UIAnimation", "########### ANIMATION DEBUG START ###########")
	Log.set_global_log_level(Log.DEBUG)

	local num_varargs = select("#", ...)

	for i = 1, num_varargs do
		local var = select(i, ...)

		Log.debug("Variable", "%d: %s", i, tostring(var))
	end

	Log.set_global_log_level(Log.INFO)
	Log.info("UIAnimation", "########### ANIMATION DEBUG END ###########")
end

UIAnimation.init_debug = function (...)
	local data_array = {}
	local ui_animation = {
		current_index = 1,
		data_array = data_array
	}
	local num_varargs = select("#", ...)
	local i = 0
	local current_index = 0

	while i < num_varargs do
		i = i + 1

		local animation_type = select(i, ...)

		if not animation_type or type(animation_type) ~= "table" then
			_debug_print_ui_animation(...)

			return nil
		end

		local num_args = animation_type.num_args

		data_array[current_index + 1] = animation_type

		for j = 1, num_args do
			data_array[current_index + 1 + j] = select(i + j, ...)
		end

		current_index = current_index + 1 + num_args + animation_type.num_data
		i = i + num_args
	end

	local num_args = data_array[1].num_args
	local num_data = data_array[1].num_data
	local pack_func = pack_index[num_data]
	local unpack_func = unpack_index[num_args]

	pack_func(data_array, 2 + num_args, data_array[1].init(unpack_func(data_array, 2)))

	return ui_animation
end

local function _extract_continue_amount(pack_amount, array, index, continue, ...)
	pack_index[pack_amount](array, index, ...)

	return continue
end

UIAnimation.update = function (ui_animation, dt)
	local current_index = ui_animation.current_index
	local data_array = ui_animation.data_array
	local animation_type = data_array[current_index]
	local num_args, num_data = animation_type.num_args, animation_type.num_data
	local continue = _extract_continue_amount(num_data, data_array, current_index + num_args + 1, animation_type.update(dt, unpack_index[num_args + num_data](data_array, current_index + 1)))

	if not continue then
		current_index = current_index + num_args + num_data + 1
		ui_animation.current_index = current_index

		local new_animation = data_array[current_index]

		if new_animation then
			local pack_func = pack_index[new_animation.num_data]
			local unpack_func = unpack_index[new_animation.num_args]

			pack_func(data_array, current_index + 1 + new_animation.num_args, new_animation.init(unpack_func(data_array, current_index + 1)))
		end
	end
end

UIAnimation.completed = function (ui_animation)
	return ui_animation.current_index >= #ui_animation.data_array
end

return UIAnimation
