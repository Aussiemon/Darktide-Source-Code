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

	if PLATFORM ~= "win32" then
		Application.add_crash_property(tostring(key), tostring(value))
	end

	print_func = print_func or __raw_print

	print_func(output)
end

Crashify.print_breadcrumb = function (crumb, print_func)
	if crumb == nil then
		return Application.warning("[Crashify] Breadcrumb can't be nil")
	end

	local output = string.format([[
<<crashify-breadcrumb>>
	<<timestamp>%f<</timestamp>>
	<<value>>%s<</value>>
<</crashify-breadcrumb>>]], Application.time_since_launch(), crumb)
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

	local exception = string.format([[
<<crashify-exception>>
	<<system>>%s<</system>>
	<<message>>%s<</message>>
	<<callstack>>%s<</callstack>>
<</crashify-exception>>]], system, message, Script.callstack())
	print_func = print_func or __raw_print

	print_func(exception)
end

return Crashify
