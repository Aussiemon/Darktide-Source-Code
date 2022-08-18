local MinionGroupExtension = class("MinionGroupExtension")

MinionGroupExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	local group_id = extension_init_data.group_id
	self._group_id = group_id
end

MinionGroupExtension.extensions_ready = function (self, world, unit)
	local group_system = Managers.state.extension:system("group_system")
	local group = group_system:group_from_id(self._group_id)
	self._group = group
end

MinionGroupExtension.group = function (self)
	return self._group
end

MinionGroupExtension.group_id = function (self)
	return self._group_id
end

MinionGroupExtension.leave_group = function (self)
	self._group_id = nil
	self._group = nil
end

return MinionGroupExtension
