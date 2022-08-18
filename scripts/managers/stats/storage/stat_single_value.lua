local StatStorage = require("scripts/managers/stats/storage/stat_storage")
local StatSingleValue = class("StatSingleValue", "StatStorage")

StatSingleValue.init = function (self, id, optional_default_value)
	StatSingleValue.super.init(self, id)

	self._default_value = optional_default_value == nil and 0 or optional_default_value
end

StatSingleValue.set_value = function (self, stat_table, value)
	stat_table[self._id] = value
end

StatSingleValue.get_value = function (self, stat_table)
	return stat_table[self._id] or self._default_value
end

implements(StatSingleValue, StatStorage.INTERFACE)

return StatSingleValue
