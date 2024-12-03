-- chunkname: @scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_game.lua

require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_base")

local CinematicSceneTemplates = require("scripts/settings/cinematic_scene/cinematic_scene_templates")
local PartyConstants = require("scripts/settings/network/party_constants")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local WwiseStateGroupGame = class("WwiseStateGroupGame", "WwiseStateGroupBase")
local STATES = WwiseGameSyncSettings.state_groups.music_game_state

WwiseStateGroupGame.init = function (self, wwise_world, wwise_state_group_name)
	WwiseStateGroupGame.super.init(self, wwise_world, wwise_state_group_name)

	self._wwise_state = {
		StateGameScore = "game_score",
		StateGameplay = "mission",
		StateLoading = "loading",
		StateMainMenu = "main_menu",
		StateTitle = "title",
		StateVictoryDefeat = "None",
	}
end

WwiseStateGroupGame.update = function (self, dt, t)
	WwiseStateGroupGame.super.update(self, dt, t)

	if GameParameters.prod_like_backend then
		local party_status = Managers.party_immaterium:current_state()
		local mission_ready = party_status == PartyConstants.State.matchmaking or party_status == PartyConstants.State.matchmaking_acceptance_vote

		if mission_ready then
			self:_set_wwise_state(STATES.mission_ready)

			return
		end
	end

	if self:_in_cinematic_mode() then
		local cinematic_scene_system = Managers.state.extension:system("cinematic_scene_system")
		local cinematic_name = cinematic_scene_system:current_cinematic_name()
		local template = CinematicSceneTemplates[cinematic_name]
		local cutscene_music = template and template.music

		if cutscene_music then
			self:_set_wwise_state(cutscene_music)
		else
			self:_set_wwise_state("None")
		end
	else
		local ui_wwise_state = Managers.ui:wwise_music_state(self._wwise_state_group_name)

		if ui_wwise_state then
			self:_set_wwise_state(ui_wwise_state)

			return
		end

		local game_state_machine = self:get_game_state_machine()

		if game_state_machine then
			local game_state_name = game_state_machine:current_state_name()
			local wwise_state = self._wwise_state[game_state_name]

			if wwise_state then
				if wwise_state == STATES.main_menu then
					local current_state = game_state_machine:current_state()
					local in_character_create_state = current_state:in_character_create_state()

					if in_character_create_state then
						wwise_state = STATES.character_creation
					end
				elseif wwise_state == STATES.mission then
					if self._current_wwise_state == STATES.loading then
						self._initial_gameplay_setup = true
					end

					if self._initial_gameplay_setup then
						local unit_spawner_manager = Managers.state.unit_spawner
						local cinematic_manager = Managers.state.cinematic

						if unit_spawner_manager and unit_spawner_manager.is_fully_hot_join_synced and not cinematic_manager:is_loading_cinematic_levels() and not cinematic_manager:has_queued_stories() then
							self._initial_gameplay_setup = false
						else
							wwise_state = STATES.loading
						end
					end
				elseif game_state_name == "StateVictoryDefeat" then
					local end_result = Managers.mechanism:end_result()

					wwise_state = self:_get_victory_defeat_wwise_state(end_result, wwise_state)
				elseif game_state_name == "StateGameScore" then
					local end_result = Managers.mechanism:end_result()

					wwise_state = self:_get_game_score_wwise_state(end_result, wwise_state)
				end

				self:_set_wwise_state(wwise_state)
			end
		end
	end
end

WwiseStateGroupGame._get_victory_defeat_wwise_state = function (self, end_result, wwise_state)
	if end_result and end_result == "won" then
		wwise_state = STATES.victory
	elseif end_result and end_result == "lost" then
		wwise_state = STATES.defeat
	else
		wwise_state = STATES.none
	end

	return wwise_state
end

WwiseStateGroupGame._get_game_score_wwise_state = function (self, end_result, wwise_state)
	if end_result and end_result == "won" then
		wwise_state = STATES.game_score_win
	elseif end_result and end_result == "lost" then
		wwise_state = STATES.game_score_lose
	else
		wwise_state = STATES.none
	end

	return wwise_state
end

WwiseStateGroupGame._in_cinematic_mode = function (self)
	local cinematic_manager = Managers.state.cinematic

	if cinematic_manager then
		return cinematic_manager:cinematic_active()
	end

	return false
end

return WwiseStateGroupGame
