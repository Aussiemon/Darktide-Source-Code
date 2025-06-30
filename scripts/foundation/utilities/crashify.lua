-- chunkname: @scripts/foundation/utilities/crashify.lua

Crashify = Crashify or {}

local __raw_print = print

Crashify.print_property = function (key, value, print_func)
	if key == nil then
		return Application.warning("[Crashify] Property key can't be nil")
	end

	if value == nil then
		return Application.warning("[Crashify] Property value for key %q can't be nil", key)
	end

	local property = string.format("%s = %s", key, value)
	local output = string.format("<<crashify-property>>%s<</crashify-property>>", property)

	Application.add_crash_property(tostring(key), tostring(value))

	print_func = print_func or __raw_print

	print_func(output)
end

Crashify.remove_print_property = function (key, print_func)
	if key == nil then
		return Application.warning("[Crashify] Property key can't be nil")
	end

	local property = string.format("%s = ", key)
	local output = string.format("<<crashify-property>>%s<</crashify-property>>", property)

	Application.remove_crash_property(tostring(key))

	print_func = print_func or __raw_print

	print_func(output)
end

Crashify.get_print_properties = function (optional_key)
	if optional_key == nil then
		return Application.get_crash_properties()
	end

	return Application.get_crash_properties(tostring(optional_key))
end

Crashify.print_breadcrumb = function (crumb, print_func)
	if crumb == nil then
		return Application.warning("[Crashify] Breadcrumb can't be nil")
	end

	local output = string.format("<<crashify-breadcrumb>>\n\t<<timestamp>%f<</timestamp>>\n\t<<value>>%s<</value>>\n<</crashify-breadcrumb>>", Application.time_since_launch(), crumb)

	print_func = print_func or __raw_print

	print_func(output)
end

Crashify.print_exception = function (system, message, print_func)
	if system == nil then
		return Application.warning("[Crashify] System can't be nil")
	end

	if message == nil then
		return Application.warning("[Crashify] Message can't be nil")
	end

	local exception = string.format("<<crashify-exception>>\n\t<<system>>%s<</system>>\n\t<<message>>%s<</message>>\n\t<<callstack>>%s<</callstack>>\n<</crashify-exception>>", system, message, Script.callstack())

	print_func = print_func or __raw_print

	print_func(exception)
end

return Crashify
