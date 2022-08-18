local StatStorage = class("StatStorage")
StatStorage.INTERFACE = {
	"set_value",
	"get_value"
}

StatStorage.init = function (self, id, optional_parameters)
	self._parameters = optional_parameters or {}
	self._id = id
end

StatStorage.get_id = function (self)
	return self._id
end

StatStorage.get_parameters = function (self)
	return self._parameters
end

StatStorage.get_raw = function (self, stat_table)
	return stat_table[self._id]
end

return StatStorage
