local InputDebug = class("InputDebug")
InputDebug.DISPLAY_AS = {
	["left shift"] = "LSHIFT",
	["right shift"] = "RSHIFT",
	["left ctrl"] = "LCTRL",
	["right ctrl"] = "RCTRL",
	["left alt"] = "LALT",
	["right alt"] = "RALT"
}

local function _value_or_table_to_string_array(item, uppercase, out)
	if type(item) == "table" then
		local num_items = #item

		for i = 1, num_items do
			local v = item[i]
			v = InputDebug.DISPLAY_AS[v] or v

			if uppercase then
				v = string.upper(v)
			end

			out[#out + 1] = v
		end

		if num_items > 0 then
			return out
		end

		for k, v in pairs(item) do
			if type(v) == "table" then
				_value_or_table_to_string_array(v, uppercase, out)
			else
				v = InputDebug.DISPLAY_AS[v] or v

				if uppercase then
					v = string.upper(v)
				end

				out[#out + 1] = v
			end
		end

		return out
	end

	item = InputDebug.DISPLAY_AS[item] or item or ""

	if uppercase then
		item = string.upper(item)
	end

	out[#out + 1] = item

	return out
end

local TEMP_STRINGS = {}

InputDebug.value_or_table_to_string = function (item, uppercase)
	local item_string = table.concat(_value_or_table_to_string_array(item, uppercase, TEMP_STRINGS), "|")

	table.clear_array(TEMP_STRINGS, #TEMP_STRINGS)

	return item_string
end

return InputDebug
