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

	self._event_listener_levels = {}
	self._event_listener_units = {}
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

MissionManager.register_mission_event_listener_unit = function (self, unit, event)
	local units = self._event_listener_units[event]

	if not units then
		units = {
			num = 0,
		}
		self._event_listener_units[event] = units
	end

	units.num = units.num + 1
	units[units.num] = unit
end

MissionManager.unregister_mission_event_listener_unit = function (self, unit, event)
	local units = self._event_listener_units[event]

	if units then
		for i = 1, units.num do
			if units[i] == unit then
				units[i], units[units.num] = units[units.num]
				units.num = units.num - 1

				break
			end
		end
	end
end

MissionManager.trigger_mission_event = function (self, event_name, ...)
	local units = self._event_listener_units[event_name]

	if units then
		for i = 1, units.num do
			local unit = units[i]

			for arg_index = 1, select("#", ...), 2 do
				local arg_name = select(arg_index, ...)
				local arg_value = select(arg_index + 1, ...)

				Unit.set_flow_variable(unit, arg_name, arg_value)
			end

			Unit.flow_event(unit, event_name)
		end
	end

	local levels = self._event_listener_levels[event_name]

	if levels then
		for i = 1, levels.num do
			local level = levels[i]

			for arg_index = 1, select("#", ...), 2 do
				local arg_name = select(arg_index, ...)
				local arg_value = select(arg_index + 1, ...)

				Level.set_flow_variable(level, arg_name, arg_value)
			end

			Level.trigger_event(level, event_name)
		end
	end
end

MissionManager.register_mission_event_listener_level = function (self, level, event)
	local levels = self._event_listener_levels[event]

	if not levels then
		levels = {
			num = 0,
		}
		self._event_listener_levels[event] = levels
	end

	levels.num = levels.num + 1
	levels[levels.num] = level
end

MissionManager.unregister_mission_event_listener_level = function (self, level, event)
	local levels = self._event_listener_levels[event]

	if levels then
		for i = 1, levels.num do
			if levels[i] == level then
				levels[i], levels[levels.num] = levels[levels.num]
				levels.num = levels.num - 1

				break
			end
		end
	end
end

return MissionManager
