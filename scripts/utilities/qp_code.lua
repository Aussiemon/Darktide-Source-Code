-- chunkname: @scripts/utilities/qp_code.lua

local QPCode = {}
local accepted_keys = {
	"challenge",
	"resistance",
	"auric",
	"category"
}

QPCode.encode = function (keys)
	local qp_entries = {}

	for _, key in ipairs(accepted_keys) do
		local value = keys[key]

		if value == true then
			qp_entries[#qp_entries + 1] = key
		elseif value ~= nil then
			if type(value) == "table" then
				value = table.concat(value, ",")
				qp_entries[#qp_entries + 1] = string.format("%s=%s", key, value)
			else
				qp_entries[#qp_entries + 1] = string.format("%s=%s", key, tostring(value))
			end
		end
	end

	return "qp:" .. table.concat(qp_entries, "|")
end

QPCode.decode = function (qp_code)
	local keys = {}
	local qp_entries = string.split(string.sub(qp_code, 4), "|")

	for _, full_key in ipairs(qp_entries) do
		local split_pos = string.find(full_key, "=")

		if split_pos then
			local key, value = string.sub(full_key, 1, split_pos - 1), string.sub(full_key, split_pos + 1)

			keys[key] = tonumber(value) or value
		else
			keys[full_key] = true
		end
	end

	return keys
end

return QPCode
