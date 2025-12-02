-- chunkname: @scripts/managers/mission/mission_manager.lua

local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local MissionTypes = require("scripts/settings/mission/mission_types")
local MissionSettings = require("scripts/settings/mission/mission_settings")
local SideMissionTypes = require("scripts/settings/mission/side_mission_types")
local mission_zone_ids = MissionSettings.mission_zone_ids
local mission_game_mode_names = MissionSettings.mission_game_mode_names
local MissionManager = class("MissionManager")

MissionManager._num_missions_started = MissionManager._num_missions_started or 0

MissionManager.init = function (self, mission_name, level, level_name, side_mission_name)
	side_mission_name = side_mission_name or "default"

	rawset(_G, "SPAWNED_LEVEL_NAME", level_name)

	local mission = MissionTemplates[mission_name]
	local side_mission

	if side_mission_name ~= "default" then
		side_mission = MissionObjectiveTemplates.side_mission.objectives[side_mission_name]
	end

	self._mission_level = level
	self._mission_name = mission_name
	self._mission = mission
	self._side_mission = side_mission
	self._side_mission_name = side_mission_name
	self._side_mission_type = SideMissionTypes.none

	if side_mission then
		self:_set_side_mission_type(side_mission.side_objective_type)
	end

	MissionManager._num_missions_started = MissionManager._num_missions_started + 1

	Crashify.print_property("num_missions_started", MissionManager._num_missions_started)
end

MissionManager.num_missions_started = function (self)
	return MissionManager._num_missions_started
end

MissionManager.destroy = function (self)
	rawset(_G, "SPAWNED_LEVEL_NAME", nil)
end

MissionManager.mission_level = function (self)
	return self._mission_level
end

MissionManager.side_mission = function (self)
	return self._side_mission
end

MissionManager.mission = function (self)
	return self._mission
end

MissionManager.mission_name = function (self)
	return self._mission_name
end

MissionManager.side_mission_name = function (self)
	return self._side_mission_name
end

MissionManager.force_third_person_mode = function (self)
	return self._mission.force_third_person_mode or false
end

MissionManager._set_side_mission_type = function (self, side_mission_type)
	self._side_mission_type = side_mission_type
end

MissionManager.side_mission_is_pickup = function (self)
	return self._side_mission_type == SideMissionTypes.collect
end

MissionManager.side_mission_is_luggable = function (self)
	return self._side_mission_type == SideMissionTypes.luggable
end

MissionManager.mission_type_index = function (self)
	local mission = self._mission
	local mission_type = MissionTypes[mission.mission_type]

	return mission_type and mission_type.index or -1
end

return MissionManager
