script_data = script_data or {}
Development = Development or {}
Development.application_parameter = {}

Development.init_application_parameters = function (args, do_pretty_print_args)
	Development.application_parameter = {}
	local application_parameters = Development.application_parameter

	local function printf(...)
		print(string.format(...))
	end

	local function first_char(s)
		return s:sub(1, 1)
	end

	local function is_parameter(s)
		return first_char(s) == "-"
	end

	local function parameter(s)
		return s:sub(2)
	end

	local num_args = #args
	local i = 1

	local function has_more_args()
		return i <= num_args
	end

	local function has_more_args_after_current()
		return num_args >= i + 1
	end

	local function step_to_next_arg()
		i = i + 1
	end

	local function current_arg()
		return args[i]
	end

	local function next_arg()
		return args[i + 1]
	end

	local function next_is_parameter()
		assert(has_more_args_after_current())

		return is_parameter(next_arg())
	end

	local function warn_multiple_definitions(parameter_name, old)
		local value = application_parameters[parameter_name]

		if type(value) ~= "table" or not value then
			local t = {
				value
			}
		end

		printf("[parse_application_parameters] multiple defintions of '%s' using [%s]. old value [%s]", parameter_name, table.concat(t, ", "), table.concat(old, ", "))
	end

	local function copy_parameter_value(parameter_name)
		local value = application_parameters[parameter_name]

		if not value then
			return nil
		end

		local t = {}

		if type(value) == "table" then
			for i = 1, #value, 1 do
				t[i] = value[i]
			end
		else
			t[1] = value
		end

		return t
	end

	local max_param_string_length = 0

	while has_more_args() do
		local arg = current_arg()

		if not is_parameter(arg) then
			step_to_next_arg()
		else
			local param = parameter(arg)
			max_param_string_length = math.max(max_param_string_length, #param)

			if application_parameters[param] then
				local old_values_to_warn_about = copy_parameter_value(param)

				warn_multiple_definitions(param, old_values_to_warn_about)

				application_parameters[param] = nil
			end

			local no_value_exists_for_param = (has_more_args_after_current() and next_is_parameter()) or not has_more_args_after_current()

			if no_value_exists_for_param then
				application_parameters[param] = true

				step_to_next_arg()
			else
				while has_more_args_after_current() and not next_is_parameter() do
					step_to_next_arg()

					local value = current_arg()
					local current_value = application_parameters[param]

					if value == "true" then
						value = true
					end

					if value == "false" then
						value = false
					end

					if not current_value then
						application_parameters[param] = value
					elseif type(application_parameters[param]) == "table" then
						local value_table = application_parameters[param]
						value_table[#value_table + 1] = value
					else
						local value_table = {
							current_value,
							value
						}
						application_parameters[param] = value_table
					end
				end
			end
		end
	end

	local script_data = script_data

	for param, value in pairs(application_parameters) do
		if type(value) == "string" then
			local fixedparam = string.gsub(param, "-", "_")
			script_data[fixedparam] = value
		else
			script_data[param] = value
		end
	end
end

return
