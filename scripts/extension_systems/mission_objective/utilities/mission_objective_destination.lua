-- chunkname: @scripts/extension_systems/mission_objective/utilities/mission_objective_destination.lua

require("scripts/extension_systems/mission_objective/utilities/mission_objective_base")

local MissionObjectiveDestination = class("MissionObjectiveDestination", "MissionObjectiveBase")

MissionObjectiveDestination.init = function (self)
	MissionObjectiveDestination.super.init(self)

	self._finish_distance = nil
	self._start_distance = nil
	self._target_unit = nil
end

MissionObjectiveDestination.start_objective = function (self, mission_objective_data, registered_units, synchronizer_unit, peer_id)
	MissionObjectiveDestination.super.start_objective(self, mission_objective_data, registered_units, synchronizer_unit, peer_id)

	self._finish_distance = mission_objective_data.finish_distance
end

MissionObjectiveDestination.start_stage = function (self, stage)
	MissionObjectiveDestination.super.start_stage(self, stage)

	for unit, _ in pairs(self._objective_units) do
		if ScriptUnit.has_extension(unit, "mission_objective_target_system") then
			self._target_unit = unit

			break
		end
	end

	self._start_distance = self:_closest_distance()
end

MissionObjectiveDestination.update_progression = function (self)
	MissionObjectiveDestination.super.update_progression(self)

	local distance = self:_closest_distance()

	if distance then
		local completion = math.clamp(1 - distance / self._start_distance, 0, 1)

		self:set_progression(completion)
	else
		self:set_progression(0)
	end

	if self:max_progression_achieved() then
		self:stage_done()
	end
end

local tracked_units = {}

MissionObjectiveDestination._closest_distance = function (self)
	local player_manager = Managers.player
	local players

	if self._peer_id then
		players = player_manager:players_at_peer(self._peer_id)
	else
		players = player_manager:players()
	end

	table.clear(tracked_units)

	for unique_id, player in pairs(players) do
		if player:unit_is_alive() then
			tracked_units[#tracked_units + 1] = player.player_unit
		end
	end

	local lowest_distance

	for ii = 1, #tracked_units do
		local distance = self:_distance(tracked_units[ii], self._target_unit)

		if not lowest_distance or distance < lowest_distance then
			lowest_distance = distance
		end
	end

	return lowest_distance
end

MissionObjectiveDestination._distance = function (self, start_unit, end_unit)
	local start_position = Unit.world_position(start_unit, 1)
	local end_position = Unit.world_position(end_unit, 1)

	return Vector3.length(start_position - end_position) - self._finish_distance
end

return MissionObjectiveDestination
