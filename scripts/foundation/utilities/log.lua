-- chunkname: @scripts/foundation/utilities/log.lua

Log = Log or {}

local Log = Log

Log.LOG_TYPE_DEBUG = {
	tag = "DEBUG",
	external_func = "debug",
	internal_func = "_debug",
	active_categories = {}
}
Log.LOG_TYPE_INFO = {
	tag = "INFO",
	external_func = "info",
	internal_func = "_info",
	active_categories = {}
}
Log.LOG_TYPE_WARNING = {
	tag = "WARNING",
	external_func = "warning",
	internal_func = "_warning",
	active_categories = {}
}
Log.LOG_TYPE_EXCEPTION = {
	tag = "EXCEPTION",
	external_func = "exception",
	internal_func = "_exception",
	active_categories = {}
}
Log.LOG_TYPE_ERROR = {
	tag = "ERROR",
	external_func = "error",
	internal_func = "_error",
	active_categories = {}
}
Log.DEFAULT_CATEGORY = "Uncategorized"
Log.INTERNAL_CATEGORY = "Log Internal"
__print_error = __print_error or print_error
__print_warning = __print_warning or print_warning
__print = __print or print
Log.DEFAULT_LOG_LEVEL = 2

local temp_args = {}

Log.init = function (global_log_level)
	if Crashify then
		Log._info(Log.INTERNAL_CATEGORY, "Exceptions will be handled by Crashify")
	else
		Log._info(Log.INTERNAL_CATEGORY, "Crashify not found, exceptions will be handled as warnings")
	end

	Log._types = {
		Log.LOG_TYPE_DEBUG,
		Log.LOG_TYPE_INFO,
		Log.LOG_TYPE_WARNING,
		Log.LOG_TYPE_EXCEPTION,
		Log.LOG_TYPE_ERROR
	}
	Log._lowest_category_level = #Log._types
	Log._category_levels = Log._category_levels or {}

	Log.set_global_log_level(global_log_level or Log.DEFAULT_LOG_LEVEL)
end

Log.set_global_log_level = function (level)
	local error_string = string.format("Global log level must be an integer between 1 and %i.", #Log._types)

	Log._global_log_level = level

	Log._update_external_functions(level, Log._lowest_category_level)
	Log._info(Log.INTERNAL_CATEGORY, "Global log level set to: %i", level)
end

Log.reset_all_category_log_levels = function ()
	Log._category_levels = {}

	Log._find_lowest_category_level()
	Log._update_external_functions(Log._global_log_level, Log._lowest_category_level)
	Log._info(Log.INTERNAL_CATEGORY, "Resetting all category log levels.")
end

Log.global_log_level = function ()
	return Log._global_log_level, Log._types[Log._global_log_level].tag
end

Log.print_log_levels = function ()
	Log._info(Log.INTERNAL_CATEGORY, "Global log level: %i", Log._global_log_level)

	local categories = table.clone(Log._category_levels)

	table.sort(categories)

	for key, value in pairs(categories) do
		local tag = Log._types[value].tag

		Log._info(Log.INTERNAL_CATEGORY, "Category %s log level is: %s (%s)", key, value, tag)
	end
end

Log._update_external_functions = function (global_level, lowest_category_level)
	local log_types = Log._types
	local num_log_types = #log_types

	for i = 1, num_log_types do
		local item = log_types[i]

		Log[item.tag] = i

		if global_level <= i then
			Log[item.external_func] = Log[item.internal_func]
		elseif lowest_category_level <= i then
			Log[item.external_func] = Log[item.internal_func .. "_category"]
		else
			Log[item.external_func] = Log._void
		end
	end
end

Log._find_lowest_category_level = function ()
	local lowest_category_level = #Log._types

	for _, category_level in pairs(Log._category_levels) do
		if category_level < lowest_category_level then
			lowest_category_level = category_level
		end
	end

	Log._lowest_category_level = lowest_category_level
end

Log.set_category_log_level = function (category, level)
	Log._category_levels[category] = level

	local log_types = Log._types

	for i = 1, #log_types do
		local active = level <= i or nil

		log_types[i].active_categories[category] = active
	end

	Log._find_lowest_category_level()
	Log._update_external_functions(Log._global_log_level, Log._lowest_category_level)
end

Log.reset_category_log_level = function (category)
	Log._category_levels[category] = nil

	local log_types = Log._types

	for i = 1, #log_types do
		log_types[i].active_categories[category] = nil
	end

	Log._find_lowest_category_level()
	Log._update_external_functions(Log._global_log_level, Log._lowest_category_level)
end

Log._format_log_category_message = function (tag, category, message, ...)
	local num_new_args = select("#", ...)

	for i = 1, num_new_args do
		temp_args[i] = tostring(select(i, ...))
	end

	for i = num_new_args + 1, #temp_args do
		temp_args[i] = nil
	end

	return string.format(string.format("%s [%s] %s", tag, category, message), unpack(temp_args))
end

Log._format_message = function (message, ...)
	local num_new_args = select("#", ...)

	for i = 1, num_new_args do
		temp_args[i] = tostring(select(i, ...))
	end

	for i = num_new_args + 1, #temp_args do
		temp_args[i] = nil
	end

	return string.format(message, unpack(temp_args))
end

Log._void = function (category, message, ...)
	return
end

Log._error = function (category, message, ...)
	if Crashify and GameParameters.testify then
		Crashify.print_exception(category, Log._format_message(message, ...), __print)

		return
	end

	__print_error(Log._format_log_category_message(Log.LOG_TYPE_ERROR.tag, category, message, ...))
end

Log._error_category = function (category, message, ...)
	if Log.LOG_TYPE_ERROR.active_categories[category] then
		if Crashify and GameParameters.testify then
			Crashify.print_exception(category, Log._format_message(message, ...), __print)

			return
		end

		__print_error(Log._format_log_category_message(Log.LOG_TYPE_ERROR.tag, category, message, ...))
	end
end

Log._exception_category = function (category, message, ...)
	if Log.LOG_TYPE_EXCEPTION.active_categories[category] then
		if Crashify then
			Crashify.print_exception(category, Log._format_message(message, ...), __print)
		else
			__print_warning(Log._format_log_category_message(Log.LOG_TYPE_EXCEPTION.tag, category, message, ...))
		end
	end
end

Log._exception = function (category, message, ...)
	if Crashify then
		Crashify.print_exception(category, Log._format_message(message, ...), __print)
	else
		__print_warning(Log._format_log_category_message(Log.LOG_TYPE_EXCEPTION.tag, category, message, ...))
	end
end

Log._warning = function (category, message, ...)
	__print_warning(Log._format_log_category_message(Log.LOG_TYPE_WARNING.tag, category, message, ...))
end

Log._warning_category = function (category, message, ...)
	if Log.LOG_TYPE_WARNING.active_categories[category] then
		__print_warning(Log._format_log_category_message(Log.LOG_TYPE_WARNING.tag, category, message, ...))
	end
end

Log._info = function (category, message, ...)
	__print(Log._format_log_category_message(Log.LOG_TYPE_INFO.tag, category, message, ...))
end

Log._info_category = function (category, message, ...)
	if Log.LOG_TYPE_INFO.active_categories[category] then
		__print(Log._format_log_category_message(Log.LOG_TYPE_INFO.tag, category, message, ...))
	end
end

Log._debug = function (category, message, ...)
	__print(Log._format_log_category_message(Log.LOG_TYPE_DEBUG.tag, category, message, ...))
end

Log._debug_category = function (category, message, ...)
	if Log.LOG_TYPE_DEBUG.active_categories[category] then
		__print(Log._format_log_category_message(Log.LOG_TYPE_DEBUG.tag, category, message, ...))
	end
end

Log._default_print = function (message, ...)
	local num_new_args = select("#", ...)

	Log.info(Log.DEFAULT_CATEGORY, string.format("%s%s", tostring(message), string.rep(" %s", num_new_args)), ...)
end

Log._msg_print_error = function (...)
	ferror("print_error() is deprecated use Log.error instead")
end

Log._msg_print_warning = function (...)
	ferror("print_warning() is deprecated use Log.warning instead")
end

Log.init(GameParameters.log_level)

local log_levels

if log_levels ~= Log.__old_log_levels then
	Log._info(Log.INTERNAL_CATEGORY, "Reloading log levels.")

	for i = 1, #log_levels, 2 do
		local category, level = log_levels[i], log_levels[i + 1]

		Log.set_category_log_level(category, level)
	end

	Log.__old_log_levels = log_levels
end

print_error = Log._msg_print_error
print_warning = Log._msg_print_warning
