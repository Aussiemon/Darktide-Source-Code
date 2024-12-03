-- chunkname: @scripts/multiplayer/matchmaking_notification_handler.lua

local DangerSettings = require("scripts/settings/difficulty/danger_settings")
local InputUtils = require("scripts/managers/input/input_utils")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local PartyConstants = require("scripts/settings/network/party_constants")
local MatchmakingNotificationHandler = class("MatchmakingNotificationHandler")
local INPUT_SERVICE_TYPE = "View"
local CANCEL_INPUT_ALIAS = "cancel_matchmaking"

local function _danger_display_name(challenge, resistance)
	local danger = DangerSettings.calculate_danger(challenge, resistance)
	local danger_settings = DangerSettings.by_index[danger]
	local danger_string = danger_settings and Localize(danger_settings.display_name)

	return danger_string
end

local function _get_havoc_rank(mission_data)
	local min_havoc_rank = 1
	local max_havoc_rank = 100
	local havoc_rank_string = "havoc-rank-"

	for i = min_havoc_rank, max_havoc_rank do
		if mission_data.mission.flags[havoc_rank_string .. tostring(i)] then
			return i
		end
	end

	Log.error("Matchmaking Notification Handler", "Unable to get havoc rank")

	return nil
end

local function _try_get_mission_text()
	local game_state = Managers.party_immaterium:party_game_state()
	local quickplay = game_state.params.qp == "true"

	if quickplay then
		local mission_id = game_state.params.backend_mission_id
		local danger

		if mission_id then
			local _, index = string.find(mission_id, "challenge=")
			local challenge = index and tonumber(string.sub(mission_id, index + 1, index + 2))

			danger = challenge and _danger_display_name(challenge, nil)
		end

		local mission_name = Localize("loc_mission_board_quickplay_header")

		return danger and string.format("%s - %s", mission_name, danger) or mission_name
	else
		local mission_data_json = game_state.params.mission_data

		if mission_data_json then
			local mission_data = cjson.decode(mission_data_json)
			local mission_key = mission_data.mission.map
			local mission_template = MissionTemplates[mission_key]
			local mission_name = Localize(mission_template.mission_name)

			if mission_data.mission.category == "havoc" then
				return string.format("%s - %s", mission_name, Localize("loc_havoc_order_info_overlay") .. tostring(_get_havoc_rank(mission_data)))
			else
				local challenge = mission_data.mission.challenge
				local resistance = mission_data.mission.resistance
				local danger = _danger_display_name(challenge, resistance)

				return string.format("%s - %s", mission_name, danger)
			end
		end
	end
end

local function _cancel_matchmaking_text()
	local color_tint_text = true
	local input_text = InputUtils.input_text_for_current_input_device(INPUT_SERVICE_TYPE, CANCEL_INPUT_ALIAS, color_tint_text)
	local loc_context = {
		input = input_text,
	}

	return Localize("loc_matchmaking_cancel_search", true, loc_context)
end

MatchmakingNotificationHandler.init = function (self)
	self._state = nil

	Managers.event:register(self, "event_multiplayer_session_joined_host", "event_multiplayer_session_joined_host")
	Managers.event:register(self, "event_multiplayer_session_failed_to_boot", "event_multiplayer_session_failed_to_boot")
	Managers.event:register(self, "event_multiplayer_session_disconnected_from_host", "event_multiplayer_session_disconnected_from_host")
end

MatchmakingNotificationHandler.destroy = function (self)
	Managers.event:unregister(self, "event_multiplayer_session_joined_host")
	Managers.event:unregister(self, "event_multiplayer_session_failed_to_boot")
	Managers.event:unregister(self, "event_multiplayer_session_disconnected_from_host")
	self:_remove_notification_if_active()
end

MatchmakingNotificationHandler.state_changed = function (self, last_state, new_state)
	self._state = new_state

	Log.info("MatchmakingNotificationHandler", "State changed %s -> %s", last_state, new_state)

	if new_state == PartyConstants.State.none then
		self:_remove_notification_if_active()
	elseif new_state == PartyConstants.State.matchmaking then
		local mission_text = _try_get_mission_text()

		self._mission_text = mission_text
		self._matchmaking_time = 0
		self._matchmaking_time_update = 1
		self._canceled = false

		self:_create_or_update_notification({
			Localize("loc_matchmaking_looking_for_team"),
			mission_text or "???",
			(_cancel_matchmaking_text()),
		})
	elseif new_state == PartyConstants.State.matchmaking_acceptance_vote then
		self:_remove_notification_if_active()
	elseif new_state == PartyConstants.State.in_mission then
		if last_state == PartyConstants.State.matchmaking or last_state == PartyConstants.State.matchmaking_acceptance_vote then
			local mission_text = _try_get_mission_text()

			self._mission_text = mission_text

			self:_create_or_update_notification({
				Localize("loc_matchmaking_connecting_to_mission"),
				mission_text or "???",
				[3] = "",
			})
		else
			self:_remove_notification_if_active()
		end
	end
end

MatchmakingNotificationHandler.event_multiplayer_session_joined_host = function (self)
	Log.info("MatchmakingNotificationHandler", "Joined host")
	self:_remove_notification_if_active()
end

MatchmakingNotificationHandler.event_multiplayer_session_failed_to_boot = function (self)
	Log.info("MatchmakingNotificationHandler", "Failed to boot")
	self:_remove_notification_if_active()
end

MatchmakingNotificationHandler.event_multiplayer_session_disconnected_from_host = function (self)
	Log.info("MatchmakingNotificationHandler", "Disconnected from host")
	self:_remove_notification_if_active()
end

MatchmakingNotificationHandler.update = function (self, dt)
	if not self._notification_id then
		return
	end

	local state = self._state

	if state == PartyConstants.State.matchmaking then
		local t = self._matchmaking_time + dt

		self._matchmaking_time = t

		if t >= self._matchmaking_time_update then
			self._matchmaking_time_update = math.floor(t) + 1

			self:_create_or_update_notification({
				Localize("loc_matchmaking_looking_for_team"),
				self._mission_text or "???",
				(_cancel_matchmaking_text()),
			})
		end

		if not self._canceled then
			local input_service = Managers.ui:input_service()

			if input_service:get(CANCEL_INPUT_ALIAS) then
				Managers.party_immaterium:cancel_matchmaking()

				self._canceled = true
			end
		end
	end
end

MatchmakingNotificationHandler._create_or_update_notification = function (self, texts)
	if self._notification_id then
		Managers.event:trigger("event_update_notification_message", self._notification_id, texts)
	else
		Managers.event:trigger("event_add_notification_message", "matchmaking", {
			texts = texts,
		}, function (id)
			self._notification_id = id
		end)
	end
end

MatchmakingNotificationHandler._remove_notification_if_active = function (self)
	if self._notification_id then
		Managers.event:trigger("event_remove_notification", self._notification_id)

		self._notification_id = nil
	end
end

return MatchmakingNotificationHandler
