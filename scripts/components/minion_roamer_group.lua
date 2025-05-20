-- chunkname: @scripts/components/minion_roamer_group.lua

local MinionRoamerGroup = component("MinionRoamerGroup")

MinionRoamerGroup.init = function (self, unit)
	local location = Unit.world_position(unit, 1)

	Managers.state.main_path:add_group_location(location)
end

MinionRoamerGroup.editor_init = function (self)
	return
end

MinionRoamerGroup.enable = function (self, unit)
	return
end

MinionRoamerGroup.disable = function (self, unit)
	return
end

MinionRoamerGroup.destroy = function (self, unit)
	return
end

MinionRoamerGroup.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

MinionRoamerGroup.component_data = {}

return MinionRoamerGroup
