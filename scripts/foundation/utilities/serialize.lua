require("scripts/foundation/utilities/error")

local function _basic_serialize(object)
	if type(object) == "number" or type(object) == "boolean" then
		return tostring(object)
	else
		return string.format("%q", object)
	end
end

local lua_reserved_words = {}

for _, v in ipairs({
	"and",
	"break",
	"do",
	"else",
	"elseif",
	"end",
	"for",
	"function",
	"if",
	"in",
	"local",
	"nil",
	"not",
	"or",
	"repeat",
	"return",
	"then",
	"until",
	"while"
}) do
	lua_reserved_words[v] = true
end

local function _save_item(value, out, indent)
	local value_type = type(value)

	if value_type == "number" or value_type == "string" or value_type == "boolean" then
		table.insert(out, _basic_serialize(value))
	elseif value_type == "table" then
		table.insert(out, "{\n")

		for k, v in pairs(value) do
			table.insert(out, string.rep("\t", indent))

			if not string.find(k, "^[_%a][_%w]*$") or lua_reserved_words[k] then
				table.insert(out, "[" .. _basic_serialize(k) .. "] = ")
			else
				table.insert(out, k .. " = ")
			end

			_save_item(v, out, indent + 1)
			table.insert(out, ",\n")
		end

		table.insert(out, string.rep("\t", indent - 1) .. "}")
	else
		ferror("Cannot serialize %q.", value_type)
	end
end

local function _save(value)
	local out = {}

	_save_item(value, out, 1)

	return table.concat(out)
end

local serialize = {
	save = _save
}

return serialize
