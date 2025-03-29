-- chunkname: @scripts/components/minion_roamer_group.lua

local MinionRoamerGroup = component("MinionRoamerGroup")

MinionRoamerGroup.init = function (self, unit)
	Managers.state.main_path:add_group_location(unit)
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
