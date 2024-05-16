-- chunkname: @scripts/extension_systems/mission_objective/utilities/mission_objective_side.lua

require("scripts/extension_systems/mission_objective/utilities/mission_objective_base")

local MissionObjectiveSide = class("MissionObjectiveSide", "MissionObjectiveBase")
local SIDE_MISSION_TYPES = Managers.state.mission.SIDE_MISSION_TYPES

MissionObjectiveSide.init = function (self)
	MissionObjectiveSide.super.init(self)
	self:set_updated_externally(true)
end

MissionObjectiveSide.start_objective = function (self, mission_objective_data, units, synchronizer_unit)
	MissionObjectiveSide.super.start_objective(self, mission_objective_data, units, synchronizer_unit)

	if mission_objective_data.side_objective_type == SIDE_MISSION_TYPES.collect then
		self:_set_side_mission_type(SIDE_MISSION_TYPES.collect)

		self._collect_amount = mission_objective_data.collect_amount
		self._proc_event_at_max_progression = mission_objective_data.proc_event_at_max_progression
	elseif mission_objective_data.side_objective_type == SIDE_MISSION_TYPES.luggable then
		self:_set_side_mission_type(SIDE_MISSION_TYPES.luggable)

		local luggable_synchronizer_extension = self:synchronizer_extension()
		local stages = luggable_synchronizer_extension:get_objective_stages()

		self:set_stage_count(stages)
	end
end

MissionObjectiveSide.start_stage = function (self, stage)
	MissionObjectiveSide.super.start_stage(self, stage)

	if self._side_mission_type == SIDE_MISSION_TYPES.collect then
		self:set_max_increment(self._collect_amount)
	elseif self._side_mission_type == SIDE_MISSION_TYPES.luggable then
		local luggable_synchronizer_extension = self:synchronizer_extension()

		self:set_max_increment(luggable_synchronizer_extension:sockets_to_fill())
	end
end

MissionObjectiveSide.update_progression = function (self)
	MissionObjectiveSide.super.update_progression(self)

	local amount_to_collect = self:max_incremented_progression()

	Managers.stats:record_team("hook_objective_side_incremented_progression", self._name, self._incremented_progression)

	if amount_to_collect > 0 then
		local current_amount = self:incremented_progression()
		local progression = current_amount / amount_to_collect

		progression = math.clamp(progression, 0, 1)

		self:set_progression(progression)

		if self:max_progression_achieved() then
			self:stage_done()

			local proc_event_at_max_progression = self._proc_event_at_max_progression

			if proc_event_at_max_progression then
				local players = Managers.player:human_players()

				for id, player in pairs(players) do
					self:_proc_mission_objective_at_max_progression(player, proc_event_at_max_progression)
				end
			end
		end
	end
end

MissionObjectiveSide._proc_mission_objective_at_max_progression = function (self, player, proc_event)
	local player_unit = player.player_unit

	if not player_unit then
		return
	end

	local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.unit = player_unit

		buff_extension:add_proc_event(proc_event, param_table)
	end
end

MissionObjectiveSide._set_side_mission_type = function (self, side_mission_type)
	self._side_mission_type = side_mission_type
end

return MissionObjectiveSide
