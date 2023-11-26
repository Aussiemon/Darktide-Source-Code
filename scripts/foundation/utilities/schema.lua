-- chunkname: @scripts/foundation/utilities/schema.lua

local Schema = class("Schema")

Schema.init = function (self, schema)
	self._schema = schema
end

Schema.validate = function (self, object, ref)
	local ref = ref or "#/"

	if type(ref) ~= "string" then
		return false, "Invalid ref"
	end

	local definition = self:get_path(ref)

	if definition == nil then
		return false, "Invalid ref " .. ref
	end

	return self:_validate(object, definition)
end

Schema.get_path = function (self, ref)
	ref = ref:gsub("#", "")

	local pattern = "([^/]+)"
	local parts = {}

	for substring in ref:gmatch(pattern) do
		table.insert(parts, substring)
	end

	local t = self._schema
	local n = #parts

	if n == 0 then
		return t
	end

	for i, part in ipairs(parts) do
		t = t[part]

		if t == nil then
			return nil
		end

		if i == n then
			return t
		end
	end

	return nil
end

Schema._validate = function (self, object, definition)
	local object_type = type(object)

	if definition.type == "object" then
		if object_type ~= "table" then
			return false, "Not valid type " .. object_type
		end

		local properties = definition.properties

		if type(properties) ~= "table" then
			return false, "Invalid definition"
		end

		local additional_properties = definition.additionalProperties

		for k, v in pairs(object) do
			local property_definition = properties[k]

			if property_definition == nil then
				if additional_properties == false then
					return false, "Missing property " .. k
				elseif type(additional_properties) == "object" then
					local valid, error = self:_validate(v, additional_properties)

					if not valid then
						return valid, error
					end
				end
			else
				local valid, error = self:_validate(v, property_definition)

				if not valid then
					return valid, error
				end
			end
		end

		return true, nil
	elseif definition.type == "array" then
		if object_type ~= "table" then
			return false, "Not valid type " .. object_type
		end

		local items_definition = definition.items

		if items_definition == nil then
			return false, "Invalid definition"
		end

		for i, v in ipairs(object) do
			local valid, error = self:_validate(v, items_definition)

			if not valid then
				return valid, error
			end
		end

		return true, nil
	elseif definition.type == "string" then
		if object_type ~= "string" then
			return false, "Not valid type " .. object_type
		end

		if definition.enum then
			for i, v in ipairs(definition.enum) do
				if v == object then
					return true, nil
				end
			end

			return false, "Not part of enumeration " .. object
		else
			return true, nil
		end
	elseif definition.type == "integer" then
		if object_type ~= "number" then
			return false, "Not valid type " .. object_type
		end

		local _, fractional = math.modf(object)

		if fractional == 0 then
			return true, nil
		else
			return false, "Not an integer"
		end
	elseif definition.type == "number" then
		if object_type ~= "number" then
			return false, "Not valid type " .. object_type
		else
			return true, nil
		end
	else
		local inner_ref = definition["$ref"]

		if inner_ref then
			local inner_definition = self:get_path(inner_ref)

			return self:_validate(object, inner_definition)
		else
			return false, "Invalid definition type " .. definition.type
		end
	end
end

return Schema
