-- chunkname: @scripts/foundation/utilities/parameters/parameter_resolver.lua

local DefaultGameParameters = require("scripts/foundation/utilities/parameters/default_game_parameters")
local DefaultDevParameters = require("scripts/foundation/utilities/parameters/default_dev_parameters").parameters

GameParameters = GameParameters or {}
DevParameters = DevParameters or {}
ParameterResolver = ParameterResolver or {}
ParameterResolver.DEBUG_TAG = "[ParameterResolver]"

local function debug(str, ...)
	print(string.format(ParameterResolver.DEBUG_TAG .. " " .. str, ...))
end

ParameterResolver.resolve_command_line = function ()
	local args = {
		Application.argv()
	}

	ParameterResolver._command_line_parameters = {}
	ParameterResolver._command_line_parameters.parameters = {}
	ParameterResolver._command_line_parameters.game = {}
	ParameterResolver._command_line_parameters.dev = {}

	local parameters = ParameterResolver._command_line_parameters.parameters

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
		return num_args >= i
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
		return is_parameter(next_arg())
	end

	local function warn_multiple_definitions(parameter_name, old)
		local value = parameters[parameter_name]
		local t = type(value) == "table" and value or {
			value
		}

		debug("Multiple defintions of '%s'\nUsing [%s].\nold value [%s]", parameter_name, table.tostring(t), table.tostring(old))
	end

	local function copy_parameter_value(parameter_name)
		local value = parameters[parameter_name]

		if not value then
			return nil
		end

		local t = {}

		if type(value) == "table" then
			for _i = 1, #value do
				t[_i] = value[_i]
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

			if parameters[param] then
				local old_values_to_warn_about = copy_parameter_value(param)

				warn_multiple_definitions(param, old_values_to_warn_about)

				parameters[param] = nil
			end

			local no_value_exists_for_param = has_more_args_after_current() and next_is_parameter() or not has_more_args_after_current()

			if no_value_exists_for_param then
				parameters[param] = true

				if param == "game" then
					parameters = ParameterResolver._command_line_parameters.game
				elseif param == "dev" then
					parameters = ParameterResolver._command_line_parameters.dev
				end

				step_to_next_arg()
			else
				while has_more_args_after_current() and not next_is_parameter() do
					step_to_next_arg()

					local value = current_arg()
					local current_value = parameters[param]

					if value == "true" then
						value = true
					end

					if value == "false" then
						value = false
					end

					value = tonumber(value) or value

					if not current_value then
						parameters[param] = value
					elseif type(parameters[param]) == "table" then
						local value_table = parameters[param]

						value_table[#value_table + 1] = value
					else
						local value_table = {
							current_value,
							value
						}

						parameters[param] = value_table
					end
				end
			end
		end
	end
end

local function _find_value_in_options(value, options)
	local max_number_diff = 1e-08
	local value_type = type(value)

	if value_type == "table" then
		return true
	end

	for i = 1, #options do
		local option = options[i]

		if value_type == "number" and type(option) == "number" then
			if max_number_diff >= math.abs(value - option) then
				return true
			end
		elseif value == option then
			return true
		end
	end

	return false
end

ParameterResolver.resolve_dev_parameters = function ()
	debug("Resolving Development Parameters")

	local dev_parameters = {}

	for param, config in pairs(DefaultDevParameters) do
		local value = config.value

		dev_parameters[param] = type(value) == "table" and table.clone(value) or value
	end

	if BUILD ~= "release" then
		local loaded_parameters = Application.user_setting("development_settings")

		if loaded_parameters then
			if table.is_empty(loaded_parameters) then
				Application.set_user_setting("development_settings", nil)
			else
				for param, value in pairs(loaded_parameters) do
					if dev_parameters[param] ~= nil then
						local default_config = DefaultDevParameters[param]

						if default_config.user_setting == false then
							debug("User independent development parameter [%s] read from user settings, parameter skipped!", param)
						else
							local options = default_config.options

							if options and not _find_value_in_options(value, options) then
								debug("Trying to set param [%s] from user settings. Value [%s] not found in parameter options, keeping default value [%s]", param, tostring(value), dev_parameters[param])
							else
								debug("Overriding param [%s] from user settings, setting it to [%s]", param, tostring(value))

								dev_parameters[param] = value
							end
						end
					else
						debug("Undecleared development parameter [%s] read from user settings, parameter skipped!", param)
					end
				end
			end
		end

		local cmd_line_dev_parameters = ParameterResolver._command_line_parameters.dev

		for param, value in pairs(cmd_line_dev_parameters) do
			if dev_parameters[param] ~= nil then
				dev_parameters[param] = value

				debug("Overriding param [%s] from command line, setting it to [%s]", param, tostring(value))
			else
				debug("Trying to set param [%s] from command line. Dev parameter not declared in DefaultDevParameters, ignoring parameter", param)
			end
		end

		if GameParameters.dump_dev_parameters_on_startup then
			debug("Combined Dev Parameters:")
			table.dump(dev_parameters, nil, 5)
		end
	end

	DevParameters = table.set_readonly(dev_parameters)

	ParameterResolver.set_dev_parameter = function (param, value, skip_save)
		local old_value = DevParameters[param]

		if old_value == nil then
			debug("Runtime change of undecleared development parameter [%s], skipping!", param)

			return
		end

		debug("Runtime change of development parameter [%s] from [%s] to [%s]", param, tostring(old_value), tostring(value))

		dev_parameters[param] = value

		if DefaultDevParameters[param] ~= nil and DefaultDevParameters[param].user_setting ~= false and not skip_save then
			debug("Setting locally saved development setting [%s] to [%s]", param, tostring(value))
			Application.set_user_setting("development_settings", param, value)

			if not DEDICATED_SERVER then
				Application.save_user_settings()
			end
		end
	end

	ParameterResolver.load_config = function (index)
		local loaded_config = Application.user_setting("development_setting_configs", index)

		if loaded_config then
			debug("Loading config %i", index)

			local mode = loaded_config.mode

			if mode == "additive" then
				for param, value in pairs(loaded_config) do
					if dev_parameters[param] ~= nil then
						debug("Setting param [%s] to [%s]", param, tostring(value))

						dev_parameters[param] = value
					elseif param ~= "mode" then
						debug("Undecleared development parameter [%s], parameter skipped!", param)
					end
				end
			elseif mode == "replacing" then
				for param, _ in pairs(dev_parameters) do
					local value = loaded_config[param]

					if value ~= nil then
						debug("Setting param [%s] to [%s]", param, tostring(value))

						dev_parameters[param] = value
					elseif param ~= "mode" then
						value = DefaultDevParameters[param].value

						if type(value) == "table" then
							value = table.clone(value)
						end

						debug("Resetting param [%s] to DEFAULT [%s]", param, tostring(value))

						dev_parameters[param] = value
					end
				end
			else
				debug("Config %i missing mode, ignoring!", index)
			end
		else
			debug("No config saved with index %i", index)
		end
	end

	ParameterResolver.save_config = function (index, mode)
		debug("Saving config %i with mode %s", index, mode)

		local defaults = DefaultDevParameters
		local saved_profile = {
			mode = mode
		}

		for param, value in pairs(dev_parameters) do
			if type(value) == "table" or value ~= defaults[param].value then
				debug("Saving parameter [%s] as [%s]", param, tostring(value))

				saved_profile[param] = value
			end
		end

		Application.set_user_setting("development_setting_configs", index, saved_profile)
		Application.save_user_settings()
	end

	ParameterResolver.reset_defaults = function ()
		local defaults = DefaultDevParameters

		for param, config in pairs(defaults) do
			local def = config.value

			if type(def) == "table" then
				def = table.clone(def)
			end

			debug("Setting param [%s] to DEFAULT [%s]", param, tostring(def))

			dev_parameters[param] = def
		end

		Application.set_user_setting("development_settings", nil)
		Application.save_user_settings()
	end
end

ParameterResolver.resolve_game_parameters = function ()
	debug("Resolving Game Parameters")

	local game_parameters = table.clone(DefaultGameParameters)
	local cmd_line_game_parameters = ParameterResolver._command_line_parameters.game

	for param, value in pairs(cmd_line_game_parameters) do
		if game_parameters[param] ~= nil then
			game_parameters[param] = value

			debug("Overriding param [%s] from command line, setting it to [%s]", param, tostring(value))
		else
			debug("Trying to set param [%s] from command line. Game parameter not declared in DefaultGameParameters, ignoring parameter", param)
		end
	end

	if game_parameters.dump_game_parameters_on_startup then
		debug("Combined Game Parameters:")
		table.dump(game_parameters, nil, 5, debug)
	end

	GameParameters = table.set_readonly(game_parameters)

	ParameterResolver.resolve_dynamic_game_parameters = function (overrides)
		local parameters = table.clone(game_parameters)

		for param, value in pairs(overrides) do
			if parameters[param] ~= nil then
				parameters[param] = value

				debug("Overriding param [%s] from backend, setting it to [%s]", param, tostring(value))
			else
				debug("Trying to set param [%s] from backend. Game parameter not declared in DefaultGameParameters, ignoring parameter", param)
			end
		end

		if parameters.dump_game_parameters_on_startup then
			debug("Game Parameters after backend overrides:")
			table.dump(parameters, nil, 5, debug)
		end

		GameParameters = table.set_readonly(parameters)
	end
end

return ParameterResolver
