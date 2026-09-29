-- chunkname: @scripts/managers/mechanism/mechanisms/mechanism_sandbox.lua

local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local MechanismBase = require("scripts/managers/mechanism/mechanisms/mechanism_base")
local Missions = require("scripts/settings/mission/mission_templates")
local StateGameplay = require("scripts/game_states/game/state_gameplay")
local StateLoading = require("scripts/game_states/game/state_loading")
local MechanismSandbox = class("MechanismSandbox", "MechanismBase")

MechanismSandbox.init = function (self, ...)
	MechanismSandbox.super.init(self, ...)

	local mission_name = GameParameters.mission
	local level_name

	if LEVEL_EDITOR_TEST then
		level_name = Application.get_data("LevelEditor", "level_resource_name") or "__level_editor_test"

		if not mission_name then
			for listed_mission_name, data in pairs(Missions) do
				if data.level == level_name then
					mission_name = listed_mission_name

					break
				end
			end

			if not mission_name then
				mission_name = "editor_simulation_without_mission"
			end
		end
	else
		level_name = Missions[mission_name].level
	end

	local circumstance_name = GameParameters.circumstance

	if not CircumstanceTemplates[circumstance_name] then
		Log.error("MechanismSandbox", "[init] circumstance_name '%s' does not exists. Fallback to 'default'", circumstance_name)

		circumstance_name = "default"
	end

	local mechanism_data = self._mechanism_data

	mechanism_data.level_name = level_name
	mechanism_data.mission_name = mission_name
	mechanism_data.challenge = DevParameters.challenge
	mechanism_data.resistance = DevParameters.resistance
	mechanism_data.circumstance_name = circumstance_name
	mechanism_data.side_mission = GameParameters.side_mission
end

MechanismSandbox.sync_data = function (self)
	return
end

MechanismSandbox.game_mode_end = function (self, outcome)
	self:_set_state("game_mode_ended")
end

MechanismSandbox.wanted_transition = function (self)
	if self._state == "init" or self._state == "game_mode_ended" then
		self:_set_state("gameplay")

		local mechanism_data = self._mechanism_data
		local mission_name = mechanism_data.mission_name
		local level_name = mechanism_data.level_name
		local circumstance = mechanism_data.circumstance_name
		local side_mission = mechanism_data.side_mission
		local challenge = mechanism_data.challenge
		local resistance = mechanism_data.resistance

		Log.info("MechanismSandbox", "Using dev parameters for challenge and resistance (%s/%s)", challenge, resistance)

		return false, StateLoading, {
			level = level_name,
			mission_name = mission_name,
			circumstance_name = circumstance,
			side_mission = side_mission,
			next_state = StateGameplay,
			next_state_params = {
				mechanism_data = mechanism_data
			}
		}
	end

	return false
end

MechanismSandbox.is_allowed_to_reserve_slots = function (self, peer_ids)
	return true
end

MechanismSandbox.peers_reserved_slots = function (self, peer_ids)
	return
end

MechanismSandbox.peer_freed_slot = function (self, peer_id)
	return
end

implements(MechanismSandbox, MechanismBase.INTERFACE)

return MechanismSandbox
