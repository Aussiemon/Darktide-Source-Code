local ActivationFunctions = {
	with_delay = function (delay, activation)
		return function (...)
			local is_triggered, value = activation(...)

			if is_triggered then
				return delay, value
			end
		end
	end,
	constant = function (value)
		return function (...)
			return 0, value
		end
	end,
	replace_trigger_value = function (activation_function, value_function)
		return function (stat_table, current_value, trigger_value, ...)
			local new_trigger_value = value_function(stat_table, current_value, trigger_value, ...)

			return activation_function(stat_table, current_value, new_trigger_value, ...)
		end
	end,
	echo = function (_, _, trigger_value, ...)
		return 0, trigger_value
	end,
	set = function (value)
		return function (_, current_value, trigger_value, ...)
			if value ~= current_value then
				return 0, value
			end
		end
	end,
	sum = function (_, current_value, trigger_value, ...)
		return 0, current_value + trigger_value
	end,
	difference = function (_, current_value, trigger_value, ...)
		return 0, current_value - trigger_value
	end,
	min = function (_, current_value, trigger_value, ...)
		if trigger_value < current_value then
			return 0, trigger_value
		end
	end,
	max = function (_, current_value, trigger_value, ...)
		if current_value < trigger_value then
			return 0, trigger_value
		end
	end,
	clamp = function (activation, lower_limit, upper_limit)
		return function (stat_table, current_value, ...)
			local delay, value = activation(stat_table, current_value, ...)
			value = value and math.clamp(value, lower_limit, upper_limit)

			if value == current_value then
				return
			end

			return delay, value
		end
	end,
	increment = function (_, current_value, _, ...)
		return 0, current_value + 1
	end,
	on_condition = function (condition, on_true, optional_on_false)
		return function (...)
			if condition(...) then
				return on_true(...)
			elseif optional_on_false then
				return optional_on_false(...)
			end
		end
	end
}

return ActivationFunctions
