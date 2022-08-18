-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
string.starts_with = function (str, start)
	return str:sub(1, #start) == start
end

string.ends_with = function (str, ending)
	return ending == "" or str:sub(-(#ending)) == ending
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

	for idx = 2, #str, 1 do
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
	local rltrim = string.match(string.match(str, "%S.*"), ".*%S")

	return rltrim
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
		array[#array + 1] = string.sub(str, i, (i + chunk_size) - 1)
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

	return data:gsub(".", function (x)
		local r = ""
		local b = x:byte()

		for i = 8, 1, -1 do
			r = r .. ((b % 2^i - b % 2^(i - 1) > 0 and "1") or "0")
		end

		return r
	end) .. "0000":gsub("%d%d%d?%d?%d?%d?", function (x)
		if #x < 6 then
			return ""
		end

		local c = 0

		for i = 1, 6, 1 do
			c = c + ((x:sub(i, i) == "1" and 2^(6 - i)) or 0)
		end

		return b:sub(c + 1, c + 1)
	end) .. ({
		"",
		"==",
		"="
	})[#data % 3 + 1]
end

string.decode_base64 = function (data)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-23, warpins: 1 ---
	local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	data = string.gsub(data, "[^" .. b .. "=]", "")

	return data:gsub(".", function (x)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-2, warpins: 1 ---
		if x == "=" then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 3-4, warpins: 1 ---
			return ""
			--- END OF BLOCK #0 ---



		end

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 5-15, warpins: 2 ---
		local r = ""
		local f = b:find(x) - 1

		--- END OF BLOCK #1 ---

		FLOW; TARGET BLOCK #2



		-- Decompilation error in this vicinity:
		--- BLOCK #2 16-32, warpins: 0 ---
		for i = 6, 1, -1 do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 16-27, warpins: 2 ---
			r = r .. ((f % 2^i - f % 2^(i - 1) > 0 and "1") or "0")
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 31-32, warpins: 2 ---
			--- END OF BLOCK #1 ---



		end

		--- END OF BLOCK #2 ---

		FLOW; TARGET BLOCK #3



		-- Decompilation error in this vicinity:
		--- BLOCK #3 33-33, warpins: 1 ---
		return r
		--- END OF BLOCK #3 ---



	end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function (x)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-3, warpins: 1 ---
		if #x ~= 8 then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 4-5, warpins: 1 ---
			return ""
			--- END OF BLOCK #0 ---



		end

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 6-10, warpins: 2 ---
		local c = 0

		--- END OF BLOCK #1 ---

		FLOW; TARGET BLOCK #2



		-- Decompilation error in this vicinity:
		--- BLOCK #2 11-25, warpins: 0 ---
		for i = 1, 8, 1 do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 11-17, warpins: 2 ---
			c = c + ((x:sub(i, i) == "1" and 2^(8 - i)) or 0)
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 24-25, warpins: 2 ---
			--- END OF BLOCK #1 ---



		end

		--- END OF BLOCK #2 ---

		FLOW; TARGET BLOCK #3



		-- Decompilation error in this vicinity:
		--- BLOCK #3 26-29, warpins: 1 ---
		return string.char(c)
		--- END OF BLOCK #3 ---



	end)
	--- END OF BLOCK #0 ---



end

return
