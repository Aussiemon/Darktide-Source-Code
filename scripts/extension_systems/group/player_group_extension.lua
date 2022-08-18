local PlayerGroupExtension = class("PlayerGroupExtension")

PlayerGroupExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._bot_group = extension_init_data.bot_group
	self._group_id = extension_init_data.group_id
	self._player = extension_init_data.player
	self._unit = unit
end

PlayerGroupExtension.extensions_ready = function (self, world, unit)
	local group_system = Managers.state.extension:system("group_system")
	local group = group_system:group_from_id(self._group_id)
	self._group = group
end

PlayerGroupExtension.register_extension_update = function (self, unit)
	local player = self._player

	if not player:is_human_controlled() then
		local bot_group = self._bot_group

		bot_group:add_bot_unit(unit)
	end
end

PlayerGroupExtension.destroy = function (self, unit)
	local player = self._player

	if not player:is_human_controlled() then
		local bot_group = self._bot_group

		bot_group:remove_bot_unit(unit)
	end
end

PlayerGroupExtension.bot_group = function (self)
	return self._bot_group
end

PlayerGroupExtension.bot_group_data = function (self)
	local unit = self._unit
	local data = self._bot_group:data_by_unit(unit)

	return data
end

PlayerGroupExtension.group = function (self)
	return self._group
end

PlayerGroupExtension.group_id = function (self)
	return self._group_id
end

PlayerGroupExtension.leave_group = function (self)
	self._group_id = nil
	self._group = nil
end

return PlayerGroupExtension
