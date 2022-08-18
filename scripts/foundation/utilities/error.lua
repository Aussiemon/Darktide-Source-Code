local temp_args = {}

local function format_error_message(message, ...)
	local num_new_args = select("#", ...)

	for i = 1, num_new_args, 1 do
		temp_args[i] = tostring(select(i, ...))
	end

	for i = num_new_args + 1, #temp_args, 1 do
		temp_args[i] = nil
	end

	return string.format(message, unpack(temp_args))
end

Application.warning = function (...)
	if BUILD ~= "release" then
		Application.console_send({
			system = "Lua",
			level = "warning",
			type = "message",
			message = format_error_message(...)
		})
	end
end

Application.error = function (...)
	if BUILD ~= "release" then
		Application.console_send({
			system = "Lua",
			level = "error",
			type = "message",
			message = format_error_message(...)
		})
	end
end

function fassert(condition, message, ...)
	if not condition then
		local message = format_error_message(message, ...)

		assert(false, message)
	end
end

function ferror(message, ...)
	local message = format_error_message(message, ...)

	error(message)
end

return
