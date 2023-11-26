-- chunkname: @scripts/managers/mechanism/mechanisms/mechanism_sandbox.lua

local MechanismBase = require("scripts/managers/mechanism/mechanisms/mechanism_base")
local Missions = require("scripts/settings/mission/mission_templates")
local StateGameplay = require("scripts/game_states/game/state_gameplay")
local StateLoading = require("scripts/game_states/game/state_loading")
local MechanismSandbox = class("MechanismSandbox", "MechanismBase")

MechanismSandbox.init = function (self, ...)
	MechanismSandbox.super.init(self, ...)

	local mission_name = GameParameters.mission

	self._mission_name = mission_name

	local level_name

	if LEVEL_EDITOR_TEST then
		level_name = Application.get_data("LevelEditor", "level_resource_name") or "__level_editor_test"

		if not mission_name then
			for listed_mission_name, data in pairs(Missions) do
				if data.level == level_name then
					mission_name = listed_mission_name
					self._mission_name = listed_mission_name

					break
				end
			end

			if not mission_name then
				mission_name = "editor_simulation_without_mission"
				self._mission_name = mission_name
			end
		end
	else
		level_name = Missions[mission_name].level
	end

	self._level_name = level_name
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

		local challenge = DevParameters.challenge
		local resistance = DevParameters.resistance
		local circumstance = GameParameters.circumstance
		local side_mission = GameParameters.side_mission

		Log.info("MechanismSandbox", "Using dev parameters for challenge and resistance (%s/%s)", challenge, resistance)

		local mechanism_data = {
			challenge = challenge,
			resistance = resistance,
			circumstance_name = circumstance,
			side_mission = side_mission
		}

		return false, StateLoading, {
			level = self._level_name,
			mission_name = self._mission_name,
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
