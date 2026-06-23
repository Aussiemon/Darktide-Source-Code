-- chunkname: @scripts/foundation/utilities/debug/property_formatter.lua

local PropertyFormatter = {}
local DEFAULT_NAMESPACE = ""
local NAMEDSPACED_ACCESSORS = {
	[DEFAULT_NAMESPACE] = Crashify.get_print_property,
	ENV = os.getenv,
	DEV = function (key)
		return DevParameters[key]
	end,
	GAME = function (key)
		return GameParameters[key]
	end,
}

local function _is_falsy(v)
	return v == nil or v == "" or v == "false" or v == false or v == 0
end

local function _property_formatter(match)
	local namespace_key, format_truthy, format_falsy = string.fixed_split(string.sub(match, 3, -2), ":")
	local namespace, key = string.fixed_split(namespace_key, ".")

	if not key then
		namespace = DEFAULT_NAMESPACE
		key = namespace_key
	end

	if key == "" then
		return "![NO_MEMBER]"
	end

	local accessor = NAMEDSPACED_ACCESSORS[namespace]

	if not accessor then
		return string.format("![BAD_NAMESPACE:%s]", namespace)
	end

	local value = accessor(key)
	local fmt = _is_falsy(value) and format_falsy or format_truthy or "%s"

	return string.format(fmt, tostring(value))
end

PropertyFormatter.format_template = function (template)
	local formatted = string.gsub(template, "$%b{}", _property_formatter)

	return formatted
end

return PropertyFormatter
