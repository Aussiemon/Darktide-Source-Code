require("scripts/foundation/utilities/error")

local destroyed_mt = {
	__index = function (t, k)
		local message = string.format("Cannot access property %q on destroyed object of type %s", tostring(k), rawget(t, "__class_name") or "<unknown>")

		error(message, 3)
	end
}
local special_functions = {
	__index = true,
	super = true,
	delete = true,
	new = true,
	__interfaces = true,
	__class_name = true
}
local CLASSES = CLASSES

function assert_interface(object, interface)
	return
end

function assert_type(object, asserted_base_class)
	return
end

function class(class_name, super_name)
	local class_table = CLASSES[class_name]
	local super = nil

	if super_name then
		super = CLASSES[super_name]
	end

	if not class_table then
		class_table = {
			super = super,
			__class_name = class_name,
			__index = class_table,
			__interfaces = {}
		}

		class_table.new = function (self, ...)
			local object = {}

			setmetatable(object, class_table)

			if object.init then
				return object, object:init(...)
			else
				return object
			end
		end

		class_table.delete = function (self, ...)
			if self.destroy then
				self:destroy(...)
			end

			self.__class_name = class_name
			self.__deleted = true

			setmetatable(self, destroyed_mt)
		end

		CLASSES[class_name] = class_table
	end

	if super then
		for k, v in pairs(super) do
			if not special_functions[k] then
				class_table[k] = v
			end
		end
	end

	return class_table
end

function implements(class, ...)
	return
end
