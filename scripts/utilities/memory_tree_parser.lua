-- chunkname: @scripts/utilities/memory_tree_parser.lua

local MemoryTreeParser = {}

MemoryTreeParser.__index = MemoryTreeParser

local ALLOCATOR_SPLIT_MARKER = "Temp Pool:"
local PROCESS_MEMORY_SPLIT_MARKER = "Process Memory:"
local ALLOCATOR_NAME_HEADER = "allocator_name"
local PROCESS_MEMORY_KEY = "process_memory"

MemoryTreeParser.new = function (separator)
	return setmetatable({
		separator = separator,
	}, MemoryTreeParser)
end

MemoryTreeParser.parse_output = function (self, output)
	local memory_tree = {}
	local _, allocator_lines, summary_lines = self:_extract_lines(output, ALLOCATOR_SPLIT_MARKER)
	local header_line = self:_first_line(output)
	local header_data = self:_parse_header_data(header_line)
	local allocator_data = self:_parse_allocator_data(header_data, allocator_lines)

	memory_tree.allocator_data = self:_nest_by_level(allocator_data)
	memory_tree.summary_data = self:_parse_summary_data(header_data, summary_lines)

	return memory_tree
end

MemoryTreeParser._split_lines = function (self, data)
	if type(data) == "string" then
		local lines = {}

		for line in (data .. "\n"):gmatch("(.-)\n") do
			if line ~= "" then
				lines[#lines + 1] = line
			end
		end

		return lines
	end

	return data
end

MemoryTreeParser._first_line = function (self, data)
	return self:_split_lines(data)[1] or ""
end

MemoryTreeParser._extract_lines = function (self, data, marker)
	local lines = self:_split_lines(data)
	local split_index

	for i, line in ipairs(lines) do
		if line:sub(1, #marker) == marker then
			split_index = i

			break
		end
	end

	if not split_index then
		return "", {}, {}
	end

	local first_line = lines[1]
	local up_until = {}

	for i = 2, split_index - 1 do
		up_until[#up_until + 1] = lines[i]
	end

	local after = {}

	for i = split_index, #lines do
		after[#after + 1] = lines[i]
	end

	return first_line, up_until, after
end

MemoryTreeParser._parse_header_data = function (self, line)
	local ordered = {}
	local current_key = ""
	local current_number_of_separators = 0
	local is_parsing_key = true

	for i = 1, #line do
		local c = line:sub(i, i)

		if c ~= self.separator then
			if is_parsing_key then
				current_key = current_key .. c
			else
				is_parsing_key = true
				ordered[#ordered + 1] = {
					key = self:_format_header(current_key),
					separators = current_number_of_separators,
				}
				current_key = c
				current_number_of_separators = 0
			end
		else
			is_parsing_key = false
			current_number_of_separators = current_number_of_separators + 1
		end
	end

	if is_parsing_key then
		ordered[#ordered + 1] = {
			separators = -1,
			key = self:_format_header(current_key),
		}
	end

	return ordered
end

MemoryTreeParser._format_header = function (self, header)
	return header:gsub(":", ""):gsub(" ", "_"):lower()
end

MemoryTreeParser._parse_allocator_data = function (self, header_data, lines)
	local parsed = {}

	for _, line in ipairs(lines) do
		local current = {}
		local to_be_parsed = line

		for _, entry in ipairs(header_data) do
			local rest, current_data = self:_split_at_nth_separator_and_format(to_be_parsed, entry.separators)

			to_be_parsed = rest
			current[entry.key] = current_data
		end

		current.level = self:_count_starts_with(line, self.separator) + 1
		parsed[#parsed + 1] = current
	end

	return parsed
end

MemoryTreeParser._parse_summary_data = function (self, header_data, lines)
	local summary = {}
	local temp_pool_line, allocator_lines, process_memory_lines = self:_extract_lines_from_list(lines, PROCESS_MEMORY_SPLIT_MARKER)
	local current_key = ""
	local temp_pool_data = {}
	local to_be_parsed = temp_pool_line

	for _, entry in ipairs(header_data) do
		local rest, current_data = self:_split_at_nth_separator_and_format(to_be_parsed, entry.separators)

		to_be_parsed = rest

		if entry.key == ALLOCATOR_NAME_HEADER then
			current_key = current_data
		else
			temp_pool_data[entry.key] = current_data
		end

		current_key = self:_format_header(current_key)
		summary[current_key] = temp_pool_data
	end

	for _, line in ipairs(allocator_lines) do
		local value, key = self:_split_and_format_at_first_separator(line)

		summary[key] = value
	end

	for index, line in ipairs(process_memory_lines) do
		local value, key = self:_split_and_format_at_first_separator(line)

		if index == 1 then
			summary[key] = {}
		else
			summary[PROCESS_MEMORY_KEY][key] = value
		end
	end

	return summary
end

MemoryTreeParser._extract_lines_from_list = function (self, lines, marker)
	return self:_extract_lines(lines, marker)
end

MemoryTreeParser._split_and_format_at_first_separator = function (self, line)
	local value, key = self:_split_at_nth_separator_and_format(line, 1)

	return self:_format_value(value), self:_format_header(key)
end

MemoryTreeParser._split_at_nth_separator_and_format = function (self, line, num_separators)
	local first, last = self:_split_at_nth(line, num_separators, self.separator)

	return last, self:_format_value(first)
end

MemoryTreeParser._format_value = function (self, value)
	value = value:gsub("KiB", ""):gsub("%%", "")
	value = self:_replace_char(value, self.separator, " ")

	return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

MemoryTreeParser._replace_char = function (self, str, char, replacement)
	local parts = {}
	local start = 1

	while true do
		local idx = str:find(char, start, true)

		if not idx then
			parts[#parts + 1] = str:sub(start)

			break
		end

		parts[#parts + 1] = str:sub(start, idx - 1)
		parts[#parts + 1] = replacement
		start = idx + #char
	end

	return table.concat(parts)
end

MemoryTreeParser._count_occurrences = function (self, str, char)
	local count = 0
	local start = 1

	while true do
		local idx = str:find(char, start, true)

		if not idx then
			break
		end

		count = count + 1
		start = idx + #char
	end

	return count
end

MemoryTreeParser._split_at_nth = function (self, str, n, char)
	local occurrences = self:_count_occurrences(str, char)

	if n == 0 or occurrences < n then
		return str, ""
	end

	local parts = self:_split_with_limit(str, char, n + 1)
	local last = parts[#parts]

	parts[#parts] = nil

	return table.concat(parts, char), last
end

MemoryTreeParser._split_with_limit = function (self, str, char, limit)
	local parts = {}
	local start = 1

	while true do
		if limit > 0 and #parts == limit - 1 then
			parts[#parts + 1] = str:sub(start)

			break
		end

		local idx = str:find(char, start, true)

		if not idx then
			parts[#parts + 1] = str:sub(start)

			break
		end

		parts[#parts + 1] = str:sub(start, idx - 1)
		start = idx + #char
	end

	if limit == 0 then
		while #parts > 0 and parts[#parts] == "" do
			parts[#parts] = nil
		end
	end

	return parts
end

MemoryTreeParser._count_starts_with = function (self, str, char)
	local i = 1

	while i <= #str and str:sub(i, i) == char do
		i = i + 1
	end

	return i - 1
end

MemoryTreeParser._nest_by_level = function (self, arr)
	local stack = {}
	local result = {}

	for _, obj in ipairs(arr) do
		local level = obj.level

		while level <= #stack do
			stack[#stack] = nil
		end

		if #stack == 0 then
			result[#result + 1] = obj
		else
			local parent = stack[#stack]

			parent.children = parent.children or {}
			parent.children[#parent.children + 1] = obj
		end

		stack[#stack + 1] = obj
	end

	return result
end

return MemoryTreeParser
