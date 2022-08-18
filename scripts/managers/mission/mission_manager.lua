local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local MissionSettings = require("scripts/settings/mission/mission_settings")
local mission_zone_ids = MissionSettings.mission_zone_ids
local mission_game_mode_names = MissionSettings.mission_game_mode_names
local main_objective_names = MissionSettings.main_objective_names
local MissionManager = class("MissionManager")
MissionManager.SIDE_MISSION_TYPES = table.enum("none", "luggable", "collect")
local SIDE_MISSION_TYPES = MissionManager.SIDE_MISSION_TYPES

MissionManager.init = function (self, mission_name, level, level_name, side_mission_name)
	rawset(_G, "SPAWNED_LEVEL_NAME", level_name)

	local mission = MissionTemplates[mission_name]
	local side_mission = nil

	if side_mission_name ~= "default" then
		side_mission = MissionObjectiveTemplates.side_mission.objectives[side_mission_name]

		fassert(side_mission.is_side_mission, "[MissionManager][set_side_mission]  %s missing field 'is_side_mission = true'.", side_mission_name)
	end

	self._mission_level = level
	self._mission_name = mission_name
	self._mission = mission
	self._side_mission = side_mission
	self._side_mission_name = side_mission_name
	self._side_mission_type = SIDE_MISSION_TYPES.none

	if side_mission then
		self:_set_side_mission_type(side_mission.side_objective_type)
	end
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

MissionManager._set_side_mission_type = function (self, side_mission_type)
	fassert(SIDE_MISSION_TYPES[side_mission_type], "[MissionManager] side mission type: [%s] is not specified in SIDE_MISSION_TYPES.", side_mission_type)

	self._side_mission_type = side_mission_type
end

MissionManager.side_mission_is_pickup = function (self)
	return self._side_mission_type == SIDE_MISSION_TYPES.collect
end

MissionManager.side_mission_is_luggable = function (self)
	return self._side_mission_type == SIDE_MISSION_TYPES.luggable
end

MissionManager.main_objective_type = function (self)
	local mission = self._mission
	local mission_objectives = mission.objectives
	local mission_objective_template = MissionObjectiveTemplates[mission_objectives]

	if not mission_objective_template then
		return "default"
	end

	local main_objective_type = mission_objective_template.main_objective_type

	return main_objective_type
end

return MissionManager
