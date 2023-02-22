local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local MechanismBase = require("scripts/managers/mechanism/mechanisms/mechanism_base")
local Missions = require("scripts/settings/mission/mission_templates")
local StateGameplay = require("scripts/game_states/game/state_gameplay")
local StateLoading = require("scripts/game_states/game/state_loading")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local SINGLEPLAY_TYPES = MatchmakingConstants.SINGLEPLAY_TYPES
local MechanismOnboarding = class("MechanismOnboarding", "MechanismBase")

MechanismOnboarding.init = function (self, ...)
	MechanismOnboarding.super.init(self, ...)

	local context = self._context
	self._challenge_level = context.challenge_level
	self._mission_name = context.mission_name
	local mission_settings = Missions[self._mission_name]
	self._level_name = mission_settings.level
	self._singleplay_type = context.singleplay_type
	self._init_scenario = context.init_scenario
end

MechanismOnboarding.sync_data = function (self)
	return
end

MechanismOnboarding.game_mode_end = function (self, outcome)
	self:_set_state("game_mode_ended")
end

MechanismOnboarding.all_players_ready = function (self)
	return
end

MechanismOnboarding.client_exit_gameplay = function (self)
	return
end

MechanismOnboarding.wanted_transition = function (self)
	local state = self._state

	if state == "init" then
		self:_set_state("gameplay")

		local challenge = self._challenge_level or DevParameters.challenge
		local resistance = DevParameters.resistance
		local circumstance = GameParameters.circumstance
		local side_mission = GameParameters.side_mission

		Log.info("MechanismOnboarding", "Using dev parameters for challenge and resistance (%s/%s)", challenge, resistance)

		local mechanism_data = {
			challenge = challenge,
			resistance = resistance,
			circumstance_name = circumstance,
			side_mission = side_mission
		}

		return false, StateLoading, {
			wait_for_despawn = true,
			level = self._level_name,
			mission_name = self._mission_name,
			circumstance_name = circumstance,
			side_mission = side_mission,
			next_state = StateGameplay,
			next_state_params = {
				mechanism_data = mechanism_data
			}
		}
	elseif state == "gameplay" then
		if self._init_scenario and Managers.state.game_mode then
			local init_scenario = self._init_scenario

			if init_scenario then
				Managers.state.game_mode:set_init_scenario(init_scenario.alias, init_scenario.name)
			end

			self._init_scenario = nil
		end

		return false
	elseif state == "game_mode_ended" then
		local story_name = Managers.narrative.STORIES.onboarding
		local current_chapter = Managers.narrative:current_chapter(story_name)

		if current_chapter then
			local chapter_data = current_chapter.data
			local mission_name = chapter_data.mission_name
			self._mission_name = mission_name
			self._level_name = Missions[mission_name].level

			self:_set_state("init")

			return false
		else
			Log.info("MechanismOnboarding", "Last onboarding mission ended, joining hub...")
			Managers.multiplayer_session:leave("leave_to_hub")
			self:_set_state("joining_hub_server")

			return false
		end
	elseif state == "joining_hub_server" then
		return false
	end
end

MechanismOnboarding.is_allowed_to_reserve_slots = function (self, peer_ids)
	return true
end

MechanismOnboarding.peers_reserved_slots = function (self, peer_ids)
	return
end

MechanismOnboarding.peer_freed_slot = function (self, peer_id)
	return
end

MechanismOnboarding.destroy = function (self)
	return
end

MechanismOnboarding.singleplay_type = function (self)
	return self._singleplay_type
end

implements(MechanismOnboarding, MechanismBase.INTERFACE)

return MechanismOnboarding
