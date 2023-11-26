-- chunkname: @scripts/managers/input/null_input_service.lua

local NullInputService = class("NullInputService")

NullInputService.init = function (self, parent)
	self._parent = parent
	self.name = parent.name
	self.type = parent.type
end

NullInputService.is_null_service = function (self)
	return true
end

NullInputService.null_service = function (self)
	return self
end

NullInputService.get = function (self, action_name)
	return self._parent:get_default(action_name)
end

NullInputService.get_default = function (self, action_name)
	return self._parent:get_default(action_name)
end

return NullInputService
