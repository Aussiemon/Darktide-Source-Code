-- chunkname: @scripts/foundation/utilities/error.lua

local _stringified_args = {}

local function _format_error_message(format, ...)
	local num_args = select("#", ...)

	for i = 1, num_args do
		_stringified_args[i] = tostring(select(i, ...))
	end

	return string.format(format, unpack(_stringified_args, 1, num_args))
end

Application.warning = function (...)
	if BUILD ~= "release" then
		Application.console_send({
			level = "warning",
			system = "Lua",
			type = "message",
			message = _format_error_message(...),
		})
	end
end

Application.error = function (...)
	if BUILD ~= "release" then
		Application.console_send({
			level = "error",
			system = "Lua",
			type = "message",
			message = _format_error_message(...),
		})
	end
end

local function _fassert(condition, ...)
	if condition then
		return
	end

	local error_message = _format_error_message(...)

	return error(error_message)
end

debug_fassert = _fassert
release_fassert = _fassert

function fassert(...)
	return _fassert(...)
end

function ferror(message, ...)
	local error_message = _format_error_message(message, ...)

	return error(error_message)
end
