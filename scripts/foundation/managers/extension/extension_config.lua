require("scripts/foundation/utilities/script_unit")

local ExtensionConfig = class("ExtensionConfig")
local EMPTY_TABLE = {}

ExtensionConfig.init = function (self)
	self._extension_data = {}
	self._num_extensions = 0
	self._unit_extensions = {}
end

ExtensionConfig.reset = function (self)
	table.clear(self._extension_data)

	self._num_extensions = 0

	table.clear(self._unit_extensions)
end

ExtensionConfig.parse_unit = function (self, unit)
	self._unit_extensions = ScriptUnit.extension_definitions(unit)
end

ExtensionConfig.add = function (self, extension_class_name, init_args, remove_when_killed)
	local index = self._num_extensions * 3 + 1
	local exts = self._extension_data
	exts[index] = extension_class_name
	exts[index + 1] = init_args
	exts[index + 2] = remove_when_killed
	self._num_extensions = self._num_extensions + 1
end

ExtensionConfig.num_extensions = function (self)
	if #self._unit_extensions > 0 then
		return #self._unit_extensions
	else
		return self._num_extensions
	end
end

ExtensionConfig.extension = function (self, i)
	local unit_extensions = self._unit_extensions

	if #unit_extensions > 0 then
		return unit_extensions[i], EMPTY_TABLE, false
	else
		local index = (i - 1) * 3 + 1
		local extension_data = self._extension_data

		return extension_data[index], extension_data[index + 1], extension_data[index + 2]
	end
end

return ExtensionConfig
