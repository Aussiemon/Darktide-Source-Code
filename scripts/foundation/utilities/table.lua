﻿-- chunkname: @scripts/foundation/utilities/table.lua

local table = table

table.is_empty = function (t)
	return next(t) == nil
end

table.size = function (t)
	local elements = 0

	for _ in pairs(t) do
		elements = elements + 1
	end

	return elements
end

if pcall(require, "table.new") then
	Script.new_array = function (narr)
		return table.new(narr, 0)
	end

	Script.new_map = function (nrec)
		return table.new(0, nrec)
	end

	Script.new_table = table.new
end

table.clone = function (t)
	local clone = {}

	for key, value in pairs(t) do
		if value == t then
			clone[key] = clone
		elseif type(value) == "table" then
			clone[key] = table.clone(value)
		else
			clone[key] = value
		end
	end

	return clone
end

table.clone_instance = function (t, lookup)
	lookup = lookup or {}

	if lookup[t] then
		return lookup[t]
	end

	lookup[t] = {}

	local clone = lookup[t]

	for key, value in pairs(t) do
		if type(value) == "table" then
			clone[key] = table.clone_instance(value, lookup)
		else
			clone[key] = value
		end
	end

	setmetatable(clone, getmetatable(t))

	return clone
end

table.shallow_copy = function (t)
	local copy = {}

	for key, value in pairs(t) do
		copy[key] = value
	end

	return copy
end

table.crop = function (t, index)
	local new_table = {}
	local new_table_size = 0

	for idx = index, #t do
		new_table_size = new_table_size + 1
		new_table[new_table_size] = t[idx]
	end

	return new_table, new_table_size
end

table.create_copy = function (copy, original)
	if not copy then
		return table.clone(original)
	else
		for key, value in pairs(original) do
			if value == original then
				copy[key] = copy
			elseif type(value) == "table" then
				copy[key] = table.create_copy(copy[key], value)
			else
				copy[key] = value
			end
		end

		for key, _ in pairs(copy) do
			if original[key] == nil then
				copy[key] = nil
			end
		end

		return copy
	end
end

table.create_copy_instance = function (copy, original)
	if not copy then
		return table.clone_instance(original)
	else
		setmetatable(copy, getmetatable(original))

		for key, value in pairs(original) do
			if value == original then
				copy[key] = copy
			elseif type(value) == "table" then
				copy[key] = table.create_copy_instance(copy[key], value)
			else
				copy[key] = value
			end
		end

		for key, _ in pairs(copy) do
			if original[key] == nil then
				copy[key] = nil
			end
		end

		return copy
	end
end

table.merge = function (dest, source)
	for key, value in pairs(source) do
		dest[key] = value
	end

	return dest
end

table.merge_array = function (dest, source)
	for i = 1, #source do
		dest[i] = source[i]
	end

	return dest
end

table.compact_array = function (t)
	local p = 0

	for k, v in pairs(t) do
		p = v and p + 1 or p
	end

	local i, k = 1, 1

	while k <= p do
		if t[i] then
			t[k] = t[i]
			t[i] = k == i and t[i] or nil
			k = k + 1
		end

		i = i + 1
	end

	return t
end

table.filter_array = function (arr, condition, o)
	o = o or {}

	local skipped = 0

	for i = 1, #arr do
		if condition(arr[i]) then
			o[i - skipped] = arr[i]
		else
			skipped = skipped + 1
		end
	end

	return o
end

table.filter = function (t, func)
	local copy = {}

	for k, v in pairs(t) do
		if func(v) then
			copy[k] = v
		end
	end

	return copy
end

table.add_missing = function (dest, source)
	for key, value in pairs(source) do
		if dest[key] == nil then
			dest[key] = value
		end
	end

	return dest
end

table.add_missing_recursive = function (dest, source)
	for key, value in pairs(source) do
		if dest[key] == nil then
			dest[key] = value
		elseif type(dest[key]) == "table" and type(source[key]) == "table" then
			table.add_missing_recursive(dest[key], source[key])
		end
	end

	return dest
end

table.merge_recursive = function (dest, source)
	for key, value in pairs(source) do
		local is_table = type(value) == "table"

		if value == source then
			dest[key] = dest
		elseif is_table and type(dest[key]) == "table" then
			table.merge_recursive(dest[key], value)
		elseif is_table then
			dest[key] = table.clone(value)
		else
			dest[key] = value
		end
	end

	return dest
end

table.merge_recursive_advanced = function (dest, source, allow_overwrites)
	local is_overwrite = false

	for key, value in pairs(source) do
		local is_table = type(value) == "table"

		if value == source then
			dest[key] = dest
		elseif is_table and type(dest[key]) == "table" then
			local _, recursive_overwrite = table.merge_recursive_advanced(dest[key], value, allow_overwrites)

			is_overwrite = is_overwrite or recursive_overwrite
		elseif is_table then
			dest[key] = table.clone(value)
		elseif dest[key] == nil or allow_overwrites then
			is_overwrite = is_overwrite or dest[key] ~= nil
			dest[key] = value
		end
	end

	return dest, is_overwrite
end

table.append = function (dest, source)
	local dest_size = #dest

	for i = 1, #source do
		dest_size = dest_size + 1
		dest[dest_size] = source[i]
	end

	return dest
end

table.append_non_indexed = function (dest, source)
	local dest_size = #dest

	for _, value in pairs(source) do
		dest_size = dest_size + 1
		dest[dest_size] = value
	end
end

table.array_contains = function (t, element)
	for i = 1, #t do
		if t[i] == element then
			return true
		end
	end

	return false
end

table.array_equals = function (a, b)
	local a_size, b_size = #a, #b

	if a_size ~= b_size then
		return false
	end

	for i = 1, a_size do
		if a[i] ~= b[i] then
			return false
		end
	end

	return true
end

table.equals = function (a, b)
	for key, a_value in pairs(a) do
		local b_value = b[key]
		local a_type, b_type = type(a_value), type(b_value)

		if a_value == b_value then
			-- Nothing
		elseif a_type == "table" and b_type == "table" and table.equals(a_value, b_value) then
			-- Nothing
		else
			return false
		end
	end

	for key, _ in pairs(b) do
		if a[key] == nil then
			return false
		end
	end

	return true
end

table.contains = function (t, element)
	for _, value in pairs(t) do
		if value == element then
			return true
		end
	end

	return false
end

table.has_intersection = function (t1, t2)
	for _, v1 in pairs(t1) do
		for _, v2 in pairs(t2) do
			if v1 == v2 then
				return true
			end
		end
	end

	return false
end

table.find = function (t, element)
	for key, value in pairs(t) do
		if value == element then
			return key
		end
	end
end

table.find_by_key = function (t, search_key, search_value)
	for key, value in pairs(t) do
		if value[search_key] == search_value then
			return key, value
		end
	end

	return nil
end

table.index_of = function (t, element)
	for i = 1, #t do
		if t[i] == element then
			return i
		end
	end

	return -1
end

table.index_of_condition = function (t, condition)
	for i = 1, #t do
		if condition(t[i]) then
			return i
		end
	end

	return -1
end

table.slice = function (t, start_index, length)
	local end_index = math.min(start_index + length - 1, #t)
	local slice = {}

	for i = start_index, end_index do
		slice[i - start_index + 1] = t[i]
	end

	return slice
end

table.sorted = function (t, keys, order_func)
	for k, _ in pairs(t) do
		keys[#keys + 1] = k
	end

	if order_func then
		table.sort(keys, function (a, b)
			return order_func(t, a, b)
		end)
	else
		table.sort(keys)
	end

	local i = 0

	return function ()
		i = i + 1

		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

table.reverse = function (t)
	local size = #t

	for i = 1, math.floor(size / 2) do
		t[i], t[size - i + 1] = t[size - i + 1], t[i]
	end
end

if not pcall(require, "table.clear") then
	table.clear = function (t)
		for key in pairs(t) do
			t[key] = nil
		end
	end
end

table.clear_array = function (t, n)
	for i = 1, n do
		t[i] = nil
	end
end

local function _table_dump(key, value, depth, max_depth, print_func)
	if max_depth < depth then
		return
	end

	local prefix = string.rep("  ", depth) .. "[" .. tostring(key) .. "]"

	if type(value) == "table" then
		prefix = prefix .. " = "

		print_func(prefix .. "table")

		if max_depth then
			for k, v in pairs(value) do
				_table_dump(k, v, depth + 1, max_depth, print_func)
			end
		end

		local meta = getmetatable(value)

		if meta then
			print_func(prefix .. "metatable")

			if max_depth then
				for k, v in pairs(meta) do
					if key ~= "__index" and key ~= "super" then
						_table_dump(k, v, depth + 1, max_depth, print_func)
					end
				end
			end
		end
	elseif type(value) == "function" or type(value) == "thread" or type(value) == "userdata" or value == nil then
		print_func(prefix .. " = " .. tostring(value))
	else
		print_func(prefix .. " = " .. tostring(value) .. " (" .. type(value) .. ")")
	end
end

table.dump = function (t, tag, max_depth, print_func)
	print_func = print_func or print

	if tag then
		print_func(string.format("<%s>", tag))
	end

	for key, value in pairs(t) do
		_table_dump(key, value, 0, max_depth or 0, print_func)
	end

	if tag then
		print_func(string.format("</%s>", tag))
	end
end

local _value_to_string_array, _table_tostring_array

function _value_to_string_array(v, depth, max_depth, skip_private, sort_keys)
	if type(v) == "table" then
		if depth <= max_depth then
			return _table_tostring_array(v, depth + 1, max_depth, skip_private, sort_keys)
		else
			return {
				"(rec-limit)",
			}
		end
	elseif type(v) == "string" then
		return {
			"\"",
			v,
			"\"",
		}
	else
		return {
			tostring(v),
		}
	end
end

function _table_tostring_array(t, depth, max_depth, skip_private, sort_keys)
	local str = {
		"{\n",
	}
	local last_tabs = string.rep("\t", depth - 1)
	local tabs = last_tabs .. "\t"
	local len = #t

	for i = 1, len do
		str[#str + 1] = tabs

		table.append(str, _value_to_string_array(t[i], depth, max_depth, skip_private, sort_keys))

		str[#str + 1] = ",\n"
	end

	local string_key_count = 0
	local string_keys = {}

	for key, value in pairs(t) do
		local key_type = type(key)
		local is_string = key_type == "string"
		local is_number = key_type == "number"

		if is_string and skip_private and key:sub(1, 1) == "_" then
			-- Nothing
		elseif is_number and key > 0 and key <= len then
			-- Nothing
		elseif is_string then
			string_keys[string_key_count + 1] = key
			string_key_count = string_key_count + 1
		else
			local key_str

			if is_number then
				key_str = string.format("[%i]", key)
			else
				key_str = tostring(key)
			end

			str[#str + 1] = tabs
			str[#str + 1] = key_str
			str[#str + 1] = " = "

			table.append(str, _value_to_string_array(value, depth, max_depth, skip_private, sort_keys))

			str[#str + 1] = ",\n"
		end
	end

	if sort_keys then
		table.sort(string_keys)
	end

	for i = 1, string_key_count do
		local key_str = string_keys[i]
		local value = t[key_str]

		str[#str + 1] = tabs
		str[#str + 1] = key_str
		str[#str + 1] = " = "

		table.append(str, _value_to_string_array(value, depth, max_depth, skip_private, sort_keys))

		str[#str + 1] = ",\n"
	end

	str[#str + 1] = last_tabs
	str[#str + 1] = "}"

	return str
end

table.tostring = function (t, max_depth, skip_private, sort_keys)
	return table.concat(_table_tostring_array(t, 1, max_depth or 1, skip_private, sort_keys ~= false))
end

local _buffer = {}

table.minidump = function (t, name)
	local b, i = _buffer, 1

	if name then
		b[1] = "["
		b[2] = name
		b[3] = "] "
		i = 4
	end

	for key, value in pairs(t) do
		b[i] = key
		b[i + 1] = " = "
		b[i + 2] = tostring(value)
		b[i + 3] = "; "
		i = i + 4
	end

	local result = table.concat(b, 1, i - 2)

	table.clear(b)

	return result
end

table.shuffle = function (source, seed)
	if seed then
		for ii = #source, 2, -1 do
			local swap

			seed, swap = math.next_random(seed, ii)
			source[swap], source[ii] = source[ii], source[swap]
		end
	else
		for ii = #source, 2, -1 do
			local swap = math.random(ii)

			source[swap], source[ii] = source[ii], source[swap]
		end
	end

	return seed
end

table.max = function (t)
	local max_key, max_value = next(t)

	for key, value in pairs(t) do
		if max_value < value then
			max_key, max_value = key, value
		end
	end

	return max_key, max_value
end

table.reduce = function (t, f, e)
	for _, value in pairs(t) do
		e = f(e, value)
	end

	return e
end

table.for_each = function (t, f)
	for key, value in pairs(t) do
		t[key] = f(value)
	end
end

table.map = function (t, f, r)
	r = r or {}

	for key, value in pairs(t) do
		r[key] = f(value)
	end

	return r
end

local random_indices = {}
local all = {}

table.get_random_array_indices = function (size, num_picks)
	for i = 1, size do
		all[i] = i
	end

	for i = 1, num_picks do
		local random_index = math.random(1, size)

		random_indices[i] = all[random_index]
		all[random_index] = all[size]
		size = size - 1
	end

	return random_indices
end

table.set = function (list, destination)
	local set = destination or {}

	for _, l in ipairs(list) do
		set[l] = true
	end

	return set
end

table.mirror_table = function (source, dest)
	local result = dest or {}

	for k, v in pairs(source) do
		result[k] = v
		result[v] = k
	end

	return result
end

table.mirror_array = function (source, dest)
	local result = dest or {}

	for index, value in ipairs(source) do
		result[index] = value
		result[value] = index
	end

	return result
end

table.add_mirrored_entry = function (list, a, b)
	list[a] = b
	list[b] = a
end

table.mirror_array_inplace = function (t)
	for i = 1, #t do
		local value = t[i]

		t[value] = i
	end

	return t
end

table.ukeys = function (t, output)
	return table.keys(t.__data, output)
end

table.keys = function (t, output)
	local n = 0
	local result = output or {}

	for key, _ in pairs(t) do
		n = n + 1
		result[n] = key
	end

	return result
end

table.values = function (t, output)
	local n = 0
	local result = output or {}

	for _, value in pairs(t) do
		n = n + 1
		result[n] = value
	end

	return result
end

table.append_varargs = function (t, ...)
	local num_varargs = select("#", ...)
	local t_size = #t

	for i = 1, num_varargs do
		t[t_size + i] = select(i, ...)
	end

	return t
end

table.merge_varargs = function (args, num_args, ...)
	local merged = {
		unpack(args, 1, num_args),
	}
	local num_varargs = select("#", ...)

	for i = 1, num_varargs do
		merged[num_args + i] = select(i, ...)
	end

	return merged, num_args + num_varargs
end

table.pack = function (...)
	return {
		...,
	}, select("#", ...)
end

table.array_to_table = function (array, array_n, out_table)
	for i = 1, array_n, 2 do
		local key = array[i]
		local value = array[i + 1]

		out_table[key] = value
	end
end

table.table_to_array = function (t, array_out, values_only)
	local array_out_n = 0

	for key, value in pairs(t) do
		if not values_only then
			array_out[array_out_n + 1] = key
			array_out[array_out_n + 2] = value
			array_out_n = array_out_n + 2
		else
			array_out[array_out_n + 1] = value
			array_out_n = array_out_n + 1
		end
	end

	return array_out_n
end

table.add_meta_logging = function (real_table, debug_enabled, debug_name)
	real_table = real_table or {}

	if debug_enabled then
		local front_table = {}

		front_table.__index = function (t, key)
			local value = rawget(real_table, key)

			print("meta getting", debug_name, key, value)

			return value
		end

		setmetatable(front_table, front_table)

		front_table.__newindex = function (t, key, value)
			print("meta setting", debug_name, key, value)
			rawset(real_table, key, value)
		end

		return front_table
	else
		return real_table
	end
end

local function ripairs_it(t, i)
	i = i - 1

	local v = t[i]

	if v ~= nil then
		return i, v
	end
end

function ripairs(t)
	return ripairs_it, t, #t + 1
end

function upairs(t)
	return next, t.__data, nil
end

table.swap_delete = function (t, index)
	local table_length = #t

	t[index] = t[table_length]
	t[table_length] = nil
end

table.set_readonly = function (t)
	return setmetatable({}, {
		__index = t,
		__newindex = function (_, key, value)
			error("Attempt to modify read-only table")
		end,
	})
end

table.remove_sequence = function (t, from, to)
	local length = #t
	local num_remove = to - from + 1

	for i = 0, length - to do
		t[from + i] = t[to + 1 + i]
	end

	for i = length - num_remove + 1, length do
		t[i] = nil
	end
end

local _enum_index_metatable = {
	__index = function (_, k)
		return error("Don't know `" .. tostring(k) .. "` for enum.")
	end,
}

table.enum = function (...)
	local t = {}

	for i = 1, select("#", ...) do
		local v = select(i, ...)

		t[v] = v
	end

	setmetatable(t, _enum_index_metatable)

	return t
end

local _lookup_index_metatable = {
	__index = function (_, k)
		return error("Don't know `" .. tostring(k) .. "` for lookup.")
	end,
}

table.index_lookup_table = function (...)
	local t = {}

	for i = 1, select("#", ...) do
		local v = select(i, ...)

		t[v] = i
		t[i] = v
	end

	setmetatable(t, _lookup_index_metatable)

	return t
end

table.make_unique = function (t)
	t.__data = {}

	local metatable = {
		__index = function (t, k)
			return rawget(t.__data, k)
		end,
		__newindex = function (t, k, v)
			local data = rawget(t, "__data")

			data[k] = v
		end,
	}

	setmetatable(t, metatable)
end

table.make_non_unique = function (t)
	return table.clone_instance(t.__data)
end

table.make_strict = function (t, name, optional_error_message__index, optional_error_message__newindex)
	local __index_err_msg = optional_error_message__index or ""
	local __newindex_err_msg = optional_error_message__newindex or ""
	local metatable = {
		__index = function (_, field_name)
			ferror("Table %q does not have field_name %q defined. %s", name, field_name, __index_err_msg)
		end,
		__newindex = function ()
			ferror("Table %q is strict. Not allowed to add new fields. %s", name, __newindex_err_msg)
		end,
	}

	setmetatable(t, metatable)
end

table.make_strict_with_interface = function (t, name, interface)
	local valid_keys = {}

	for i = 1, #interface do
		local field_name = interface[i]

		valid_keys[field_name] = true
	end

	for field_name, field in pairs(t) do
		-- Nothing
	end

	return setmetatable(t, {
		__index = function (t, key)
			return nil
		end,
		__newindex = function (t, key, val)
			rawset(t, key, val)
		end,
	})
end

table.verify_schema = function (t, name, schema)
	for key, _ in pairs(schema) do
		if t[key] == nil then
			Log.warning("SchemaVerifier", "Tried to verify %q, but it's not matching the schema", name)
			table.dump(t, name)
			table.dump(schema, "schema")

			return false
		end
	end

	for key, _ in pairs(t) do
		if schema[key] == nil then
			Log.warning("SchemaVerifier", "Tried to verify %q, but it's not matching the schema", name)
			table.dump(t, name)
			table.dump(schema, "schema")

			return false
		end
	end

	return true
end

table.make_locked = function (original_t, optional_error_message)
	local locked_table = {
		__locked = true,
		__data = original_t,
	}
	local error_msg = optional_error_message or "Table is locked."

	return setmetatable(locked_table, {
		__index = function (t, key)
			t.__locked = true

			return rawget(t.__data, key)
		end,
		__newindex = function (t, key, val)
			t.__locked = true

			local data = rawget(t, "__data")

			data[key] = val
		end,
	})
end

StrictNil = StrictNil or {}

table.make_strict_nil_exceptions = function (t)
	local declared_args = {}

	for k, v in pairs(t) do
		declared_args[k] = true

		if v == StrictNil then
			t[k] = nil
		end
	end

	local meta = {
		__declared = declared_args,
	}

	meta.__newindex = function (t, k, v)
		if meta.__declared[k] then
			rawset(t, k, v)
		else
			ferror("Table is strict. Not allowed to add new fields.")
		end
	end

	meta.__index = function (t, k)
		if not meta.__declared[k] then
			ferror("Table does not have field_name %q defined.", k)
		end
	end

	setmetatable(t, meta)

	return t
end

table.check_interface = function (data, interface_lookup, optional_error_message_interface)
	local error_msg = optional_error_message_interface or ""

	for field_name, field in pairs(data) do
		-- Nothing
	end

	return interface_lookup
end

table.make_strict_readonly = function (data, name, optional_interface, optional_error_message_interface, optional_error_message__index, optional_error_message__newindex)
	local interface

	if optional_interface then
		interface = table.set(optional_interface, {})

		table.check_interface(data, interface, optional_error_message_interface)
	end

	local strict_readonly_t = {
		__data = data,
		__interface = interface,
	}
	local __index_error_msg = optional_error_message__index or ""
	local __newindex_error_msg = optional_error_message__newindex or ""
	local metatable = {
		__index = function (t, field_name)
			local __interface = rawget(t, "__interface")

			if __interface then
				local valid_field = __interface[field_name]

				return rawget(t.__data, field_name)
			else
				local field = rawget(t.__data, field_name)

				return field
			end
		end,
		__newindex = function (t, field_name, value)
			ferror("Table %q is readonly.%s", name, __newindex_error_msg)
		end,
	}

	setmetatable(strict_readonly_t, metatable)

	return strict_readonly_t
end

local TEMP_CHECKED_VALUES = {}

table.unique_array_values = function (t, destination)
	local result = destination or {}
	local next_index = 1

	for i = 1, #t do
		local value = t[i]

		if not TEMP_CHECKED_VALUES[value] then
			result[next_index] = value
			next_index = next_index + 1
			TEMP_CHECKED_VALUES[value] = true
		end
	end

	table.clear(TEMP_CHECKED_VALUES)

	return result
end

local random_indexed_meta = {
	__index = function (_, i)
		return i
	end,
}

table.generate_random_table = function (from, to, seed)
	local result = {}
	local temp = setmetatable({}, random_indexed_meta)
	local last_seed = seed

	for iter = 1, to do
		local index

		if last_seed then
			local new_seed, rnd = math.next_random(last_seed, from, to)

			index = rnd
			last_seed = new_seed
		else
			index = math.random(from, to)
		end

		local val = temp[index]

		temp[index] = temp[from]
		result[iter] = val
		from = from + 1
	end

	return result, last_seed
end

table.remove_empty_values = function (t)
	if table.is_empty(t) then
		return nil
	end

	local result = {}

	for k, v in pairs(t) do
		if k ~= StrictNil then
			local value_type = type(v)

			if value_type == "table" then
				if not table.is_empty(v) then
					result[k] = table.remove_empty_values(v)
				end
			elseif value_type == "string" and v ~= "" then
				result[k] = v
			elseif value_type ~= "nil" then
				result[k] = v
			end
		end
	end

	if table.is_empty(result) then
		return nil
	else
		return result
	end
end

table.array_remove_if = function (t, predicate)
	local i, v = 1

	for j = 1, #t do
		v, t[j] = t[j]

		if not predicate(v) then
			t[i], i = v, i + 1
		end
	end
end

table.sum = function (t)
	local s = 0

	for _, elem in pairs(t) do
		s = s + elem
	end

	return s
end

table.average = function (t)
	return table.sum(t) / #t
end

table.percentile = function (t, p)
	return t[math.round(p / 100 * #t)]
end

table.variance = function (t)
	local avg = table.average(t)
	local diff = {}

	for i, v in pairs(t) do
		diff[i] = (v - avg)^2
	end

	return table.average(diff)
end

table.nested_get = function (t, key, ...)
	if key == nil or t == nil then
		return t
	end

	return table.nested_get(t[key], ...)
end

table.conditional_copy = function (t, condition, o)
	o = o or {}

	for key, value in pairs(t) do
		if condition(key, value) then
			o[key] = value
		end
	end

	return o
end

table.is_array = function (t)
	if type(t) ~= "table" then
		return false
	end

	local i = 0

	for _, _ in pairs(t) do
		i = i + 1

		if t[i] == nil then
			return false
		end
	end

	return true
end
