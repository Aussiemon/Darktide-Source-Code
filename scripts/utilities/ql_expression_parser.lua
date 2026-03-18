-- chunkname: @scripts/utilities/ql_expression_parser.lua

local QLEexpressionParser = {}
local IDENTIFIER_PATTERN = "^%a%d+"
local STRING_PATTERN = "^'.?'+"
local NUMBER_PATTERN = "^%d+"

QLEexpressionParser.TOKEN_TYPE = table.enum("LPAREN", "RPAREN", "COMMA", "AND", "OR", "TRUE", "FALSE", "EQUALS", "NOT_EQUALS", "GREATER_THAN", "GREATER_THAN_OR_EQUAL", "LESS_THAN", "LESS_THAN_OR_EQUAL", "BEGINS_WITH", "IDENT", "NUMBER", "STRING", "PSUM")

local function find_next_token(expression_string)
	local token_table = {}

	if #expression_string == 0 then
		return token_table
	elseif string.sub(expression_string, 1, 1) == "#" then
		if string.find(expression_string, "#t") == 1 then
			token_table.token_type = QLEexpressionParser.TOKEN_TYPE.TRUE
			token_table.value = true
			token_table.num_chars = 2

			return token_table, string.sub(expression_string, 3)
		elseif string.find(expression_string, "#f") == 1 then
			token_table.token_type = QLEexpressionParser.TOKEN_TYPE.FALSE
			token_table.value = false
			token_table.num_chars = 2

			return token_table, string.sub(expression_string, 3)
		else
			return token_table, expression_string, "expected bool expression"
		end
	elseif string.find(expression_string, "(", 1, true) == 1 then
		token_table.token_type = QLEexpressionParser.TOKEN_TYPE.LPAREN
		token_table.value = "("
		token_table.num_chars = 1

		return token_table, string.sub(expression_string, 2)
	elseif string.find(expression_string, ",", 1, true) == 1 then
		token_table.token_type = QLEexpressionParser.TOKEN_TYPE.COMMA
		token_table.value = ","
		token_table.num_chars = 1

		return token_table, string.sub(expression_string, 2)
	elseif string.find(expression_string, ")", 1, true) == 1 then
		token_table.token_type = QLEexpressionParser.TOKEN_TYPE.RPAREN
		token_table.value = ")"
		token_table.num_chars = 1

		return token_table, string.sub(expression_string, 2)
	elseif string.find(expression_string, "AND", 1, true) == 1 then
		token_table.token_type = QLEexpressionParser.TOKEN_TYPE.AND
		token_table.value = "and"
		token_table.num_chars = 3

		return token_table, string.sub(expression_string, 4)
	elseif string.find(expression_string, "OR", 1, true) == 1 then
		token_table.token_type = QLEexpressionParser.TOKEN_TYPE.OR
		token_table.value = "or"
		token_table.num_chars = 2

		return token_table, string.sub(expression_string, 3)
	elseif string.find(expression_string, "<=", 1, true) == 1 then
		token_table.token_type = QLEexpressionParser.TOKEN_TYPE.LESS_THAN_OR_EQUAL
		token_table.value = "<="
		token_table.num_chars = 2

		return token_table, string.sub(expression_string, 3)
	elseif string.find(expression_string, "<", 1, true) == 1 then
		token_table.token_type = QLEexpressionParser.TOKEN_TYPE.LESS_THAN
		token_table.value = "<"
		token_table.num_chars = 1

		return token_table, string.sub(expression_string, 2)
	elseif string.find(expression_string, ">=", 1, true) == 1 then
		token_table.token_type = QLEexpressionParser.TOKEN_TYPE.GREATER_THAN_OR_EQUAL
		token_table.value = ">="
		token_table.num_chars = 2

		return token_table, string.sub(expression_string, 3)
	elseif string.find(expression_string, ">", 1, true) == 1 then
		token_table.token_type = QLEexpressionParser.TOKEN_TYPE.GREATER_THAN
		token_table.value = ">"
		token_table.num_chars = 1

		return token_table, string.sub(expression_string, 2)
	elseif string.find(expression_string, "==", 1, true) == 1 then
		token_table.token_type = QLEexpressionParser.TOKEN_TYPE.EQUALS
		token_table.value = "=="
		token_table.num_chars = 2

		return token_table, string.sub(expression_string, 3)
	elseif string.find(expression_string, "!=", 1, true) == 1 then
		token_table.token_type = QLEexpressionParser.TOKEN_TYPE.NOT_EQUALS
		token_table.value = "not"
		token_table.num_chars = 2

		return token_table, string.sub(expression_string, 3)
	elseif string.find(expression_string, "p_sum", 1, true) == 1 then
		token_table.token_type = QLEexpressionParser.TOKEN_TYPE.PSUM
		token_table.num_chars = 5
		token_table.value = string.sub(expression_string, 1, 5)

		return token_table, string.sub(expression_string, 6)
	elseif string.find(expression_string, IDENTIFIER_PATTERN) == 1 then
		local string_start_index, string_end_index = string.find(expression_string, IDENTIFIER_PATTERN)

		token_table.token_type = QLEexpressionParser.TOKEN_TYPE.IDENT
		token_table.value = string.sub(expression_string, 1, string_end_index)
		token_table.num_chars = #token_table.value

		return token_table, string.sub(expression_string, string_end_index and string_end_index + 1 or 1)
	elseif string.find(expression_string, NUMBER_PATTERN) == 1 then
		local string_start_index, string_end_index = string.find(expression_string, NUMBER_PATTERN)

		token_table.token_type = QLEexpressionParser.TOKEN_TYPE.NUMBER
		token_table.value = string.sub(expression_string, 1, string_end_index)
		token_table.num_chars = #token_table.value

		return token_table, string.sub(expression_string, string_end_index and string_end_index + 1 or 1)
	elseif string.find(expression_string, STRING_PATTERN) == 1 then
		local string_start_index, string_end_index = string.find(expression_string, STRING_PATTERN)

		token_table.token_type = QLEexpressionParser.TOKEN_TYPE.STRING
		token_table.value = string.sub(expression_string, 1, string_end_index)
		token_table.num_chars = #token_table.value

		return token_table, string.sub(expression_string, string_end_index and string_end_index + 1 or 1)
	else
		return token_table, expression_string, "unexpected string values"
	end
end

local peek, consume, parse_or, parse_and, parse_comparison
local flipped_ops = {
	["!="] = "!=",
	["<"] = ">",
	["<="] = ">=",
	["=="] = "==",
	[">"] = "<",
	[">="] = "<=",
}
local pos = 1

function peek(tokens)
	return tokens[pos]
end

function consume(tokens)
	local t = tokens[pos]

	pos = pos + 1

	return t
end

function parse_comparison(tokens)
	local token = peek(tokens)
	local token_type = token and token.token_type

	if token_type == QLEexpressionParser.TOKEN_TYPE.LPAREN then
		consume(tokens)

		local node = parse_or(tokens)

		if consume(tokens).token_type ~= QLEexpressionParser.TOKEN_TYPE.RPAREN then
			error("Missing closing parenthesis")
		end

		return node
	else
		local left = consume(tokens)
		local op = consume(tokens)
		local right = consume(tokens)
		local final_node, final_value, final_operator

		if (left.token_type == QLEexpressionParser.TOKEN_TYPE.PSUM or left.token_type == QLEexpressionParser.TOKEN_TYPE.IDENT) and right.token_type == QLEexpressionParser.TOKEN_TYPE.NUMBER then
			final_node = left
			final_value = right
			final_operator = op
		elseif (right.token_type == QLEexpressionParser.TOKEN_TYPE.PSUM or right.token_type == QLEexpressionParser.TOKEN_TYPE.IDENT) and left.token_type == QLEexpressionParser.TOKEN_TYPE.NUMBER then
			final_node = right
			final_value = left
			op = find_next_token(flipped_ops[op.value])
			final_operator = op
		else
			error("Invalid comparison format. Expected ID and Number.")
		end

		return {
			type = "condition",
			node = final_node,
			operator = final_operator,
			value = final_value,
		}
	end
end

function parse_and(tokens)
	local node = parse_comparison(tokens)

	while true do
		local token = peek(tokens)
		local token_type = token and token.token_type

		if token_type == QLEexpressionParser.TOKEN_TYPE.AND then
			consume(tokens)

			local right = parse_comparison(tokens)

			node = {
				op = "AND",
				type = "AST_NODE",
				left = node,
				right = right,
			}
		else
			break
		end
	end

	return node
end

function parse_or(tokens)
	local node = parse_and(tokens)

	while true do
		local token = peek(tokens)
		local token_type = token and token.token_type

		if token_type == QLEexpressionParser.TOKEN_TYPE.OR then
			consume(tokens)

			local right = parse_and(tokens)

			node = {
				op = "OR",
				type = "AST_NODE",
				left = node,
				right = right,
			}
		else
			break
		end
	end

	return node
end

QLEexpressionParser.parse = function (expression_string)
	local cleaned_string = string.gsub(expression_string, "\t", "")

	cleaned_string = string.gsub(cleaned_string, " ", "")

	local guards = {}
	local tokens = {}
	local token_table, next_expression, err = find_next_token(cleaned_string)

	while next_expression do
		if err then
			Log.error("ql_expression", "failed evaluating string " .. next_expression or "" .. " " .. err)

			break
		end

		local index = #tokens + 1

		token_table.index = index
		tokens[index] = token_table
		token_table, next_expression, err = find_next_token(next_expression)
	end

	if not err then
		pos = 1

		local success, result = pcall(parse_or, tokens)

		if not success then
			Log.error("ql_expression", result)

			return {}
		end

		return result
	end

	return {}
end

return QLEexpressionParser
