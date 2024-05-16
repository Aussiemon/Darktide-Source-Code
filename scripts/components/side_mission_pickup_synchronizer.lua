﻿-- chunkname: @scripts/components/side_mission_pickup_synchronizer.lua

local SideMissionPickupSynchronizer = component("SideMissionPickupSynchronizer")

SideMissionPickupSynchronizer.init = function (self, unit)
	local side_mission_synchronizer_extension = ScriptUnit.fetch_component_extension(unit, "event_synchronizer_system")

	if side_mission_synchronizer_extension then
		local auto_start_on_level_spawned = self:get_data(unit, "automatic_start")

		side_mission_synchronizer_extension:setup_from_component(auto_start_on_level_spawned)
	end
end

SideMissionPickupSynchronizer.editor_init = function (self, unit)
	return
end

SideMissionPickupSynchronizer.editor_validate = function (self, unit)
	return true, ""
end

SideMissionPickupSynchronizer.enable = function (self, unit)
	return
end

SideMissionPickupSynchronizer.disable = function (self, unit)
	return
end

SideMissionPickupSynchronizer.destroy = function (self, unit)
	return
end

SideMissionPickupSynchronizer.component_data = {
	automatic_start = {
		ui_name = "Auto Start On Level Spawned",
		ui_type = "check_box",
		value = false,
	},
	extensions = {
		"SideMissionPickupSynchronizerExtension",
	},
}

return SideMissionPickupSynchronizer
