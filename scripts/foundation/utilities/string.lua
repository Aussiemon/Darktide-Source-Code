-- chunkname: @scripts/foundation/utilities/string.lua

local string = string
local sub = string.sub

string.starts_with = function (str, start)
	return sub(str, 1, #start) == start
end

string.ends_with = function (str, ending)
	return ending == "" or sub(str, -#ending) == ending
end

string.split = function (str, sep)
	local array = {}
	local reg = string.format("([^%s]+)", sep)

	for mem in string.gmatch(str, reg) do
		table.insert(array, mem)
	end

	return array
end

string.double_dash_split = function (str)
	local array = {}
	local dash_byte = string.byte("-")
	local from = 1

	for idx = 2, #str do
		if str:byte(idx) == dash_byte and str:byte(idx - 1) == dash_byte then
			local to = idx - 2

			if from < to then
				table.insert(array, str:sub(from, to))
			else
				table.insert(array, "")
			end

			from = idx + 1
		end
	end

	return array
end

string.trim = function (str)
	local _, first = string.find(str, "^%s*")
	local last = string.find(str, "%s*$")

	return sub(str, first + 1, last - 1)
end

string.split_and_trim = function (str, sep)
	local array = {}
	local reg = string.format("([^%s]+)", sep)

	for mem in string.gmatch(str, reg) do
		mem = string.trim(mem)

		table.insert(array, mem)
	end

	return array
end

string.split_by_chunk = function (str, chunk_size)
	local array = {}

	for i = 1, #str, chunk_size do
		array[#array + 1] = sub(str, i, i + chunk_size - 1)
	end

	return array
end

string.value_or_nil = function (value)
	if value == "" or value == false then
		return nil
	else
		return value
	end
end

string.encode_base64 = function (data)
	local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

	return (data:gsub(".", function (x)
		local r, b = "", x:byte()

		for i = 8, 1, -1 do
			r = r .. (b % 2^i - b % 2^(i - 1) > 0 and "1" or "0")
		end

		return r
	end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function (x)
		if #x < 6 then
			return ""
		end

		local c = 0

		for i = 1, 6 do
			c = c + (x:sub(i, i) == "1" and 2^(6 - i) or 0)
		end

		return b:sub(c + 1, c + 1)
	end) .. ({
		"",
		"==",
		"=",
	})[#data % 3 + 1]
end

string.decode_base64 = function (data)
	local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

	data = string.gsub(data, "[^" .. b .. "=]", "")

	return (data:gsub(".", function (x)
		if x == "=" then
			return ""
		end

		local r, f = "", b:find(x) - 1

		for i = 6, 1, -1 do
			r = r .. (f % 2^i - f % 2^(i - 1) > 0 and "1" or "0")
		end

		return r
	end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function (x)
		if #x ~= 8 then
			return ""
		end

		local c = 0

		for i = 1, 8 do
			c = c + (x:sub(i, i) == "1" and 2^(8 - i) or 0)
		end

		return string.char(c)
	end))
end

string.is_snake_case = function (str)
	if string.ends_with(str, "_") then
		return false
	end

	local arr = string.split(str, "_")

	for _, substr in pairs(arr) do
		if string.match(substr, "%w+") ~= substr or substr:lower() ~= substr then
			return false
		end
	end

	return true
end

string.pad_right = function (str, target_length, pad_str, cache)
	local str_size = #str
	local pad_size = #pad_str

	if cache then
		local slack = math.max(0, target_length - str_size)
		local cached = cache[slack]

		if cached then
			return str .. cached
		end

		cache[slack] = string.pad_right("", slack, pad_str)

		return str .. cache[slack]
	end

	local padding = ""

	for i = str_size + pad_size, target_length, pad_size do
		padding = padding .. pad_str
	end

	local rest = (target_length - str_size) % pad_size

	if rest ~= 0 then
		padding = padding .. string.sub(pad_str, 1, rest)
	end

	return str .. padding
end
