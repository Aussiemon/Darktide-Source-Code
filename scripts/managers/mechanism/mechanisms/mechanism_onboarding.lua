local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local MechanismBase = require("scripts/managers/mechanism/mechanisms/mechanism_base")
local Missions = require("scripts/settings/mission/mission_templates")
local StateGameplay = require("scripts/game_states/game/state_gameplay")
local StateLoading = require("scripts/game_states/game/state_loading")
local ProfileUtils = require("scripts/utilities/profile_utils")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local MechanismOnboarding = class("MechanismOnboarding", "MechanismBase")

MechanismOnboarding.init = function (self, ...)
	MechanismOnboarding.super.init(self, ...)
	fassert(not DEDICATED_SERVER, "Onboarding expected to be hosted locally by a player but was run on a dedicated server")

	local context = self._context
	self._mission_name = context.mission_name
	self._level_name = Missions[self._mission_name].level
	local players = Managers.player:players_at_peer(Network.peer_id())

	for local_player_id, player in pairs(players) do
		local profile = ProfileUtils.replace_profile_for_prologue(player:profile())

		player:set_profile(profile)
	end
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

		local challenge = DevParameters.challenge
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
		return false
	elseif state == "game_mode_ended" then
		local next_mission_name = nil

		if next_mission_name then
			self._mission_name = next_mission_name
			self._level_name = Missions[self._mission_name].level

			self:_set_state("init")

			return false
		else
			Log.info("MechanismOnboarding", "Last onboarding mission ended, joining hub...")
			self:_save_prologue_completed()
			Managers.multiplayer_session:leave("onboarding_ended")
			self:_set_state("joining_hub_server")

			return false
		end
	elseif state == "joining_hub_server" then
		return false
	end
end

MechanismOnboarding._save_prologue_completed = function (self)
	local local_player_id = 1
	local local_player = Managers.player:local_player(local_player_id)
	local profile = local_player:profile()
	local character_id = profile.character_id

	Managers.data_service.profiles:set_prologue_completed(character_id)
	Managers.achievements:unlock_achievement("prologue")
	Log.info("MechanismOnboarding", "Saved prologue completed for character_id %q", character_id)
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

implements(MechanismOnboarding, MechanismBase.INTERFACE)

return MechanismOnboarding
