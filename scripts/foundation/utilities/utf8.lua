Utf8.string_length = function (text)
	local length = string.len(text)
	local index = 1
	local num_chars = 0
	local _ = nil

	while index <= length do
		_, index = Utf8.location(text, index)
		num_chars = num_chars + 1
	end

	return num_chars
end

Utf8.sub_string = function (text, from, to)
	if to == 0 or text == "" then
		return ""
	end

	local length = string.len(text)
	local tmp_byte_from, tmp_byte_to, byte_from, byte_to = nil
	local index = 1
	local i = 1

	while length >= i do
		tmp_byte_from, tmp_byte_to = Utf8.location(text, i)

		if index == from then
			byte_from = tmp_byte_from
		end

		if index == to then
			byte_to = tmp_byte_to - 1
		end

		index = index + 1
		i = tmp_byte_to
	end

	if byte_from and byte_to then
		return string.sub(text, byte_from, byte_to)
	elseif byte_from then
		return string.sub(text, byte_from)
	else
		return ""
	end
end

Utf8.string_insert = function (text, pos, text_to_insert)
	if not text_to_insert then
		text_to_insert = pos
		pos = Utf8.string_length(text) + 1
	end

	text = Utf8.sub_string(text, 1, pos - 1) .. text_to_insert .. Utf8.sub_string(text, pos)

	return text
end

Utf8.string_remove = function (text, pos, num_chars)
	num_chars = num_chars or 1
	pos = pos or Utf8.string_length(text)
	text = Utf8.sub_string(text, 1, pos - 1) .. Utf8.sub_string(text, pos + num_chars)

	return text
end

Utf8.find = function (text, pattern, init, plain)
	if not init or init < 1 then
		init = 1
	end

	local string_length = Utf8.string_length(text)

	if string_length < init then
		init = string_length
	end

	local length = string.len(text)
	local tmp_init_byte, init_byte = nil
	local index = 1
	local next_byte = 1

	while not init_byte and next_byte <= length do
		tmp_init_byte, next_byte = Utf8.location(text, next_byte)

		if index == init then
			init_byte = tmp_init_byte
		end

		index = index + 1
	end

	local byte_from, byte_to = string.find(text, pattern, init_byte, plain)
	local index_from, index_to = nil

	if byte_from then
		local index_byte = nil
		next_byte = init_byte
		index_from = init - 1
		index_to = init - 1

		while next_byte <= length do
			index_byte, next_byte = Utf8.location(text, next_byte)

			if index_byte <= byte_from then
				index_from = index_from + 1
			end

			if index_byte <= byte_to then
				index_to = index_to + 1
			end
		end
	end

	return index_from, index_to
end

return
