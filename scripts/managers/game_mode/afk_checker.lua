local InputUtils = require("scripts/managers/input/input_utils")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local AFKChecker = class("AFKChecker")
local SERVER_RPCS = {
	"rpc_report_menu_activity"
}
local CLIENT_RPCS = {
	"rpc_enable_inactivity_warning",
	"rpc_disable_inactivity_warning"
}
local MENU_ACTIVITY_REPORT_INTERVAL = 30

AFKChecker.init = function (self, is_server, settings, network_event_delegate)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate

	if is_server then
		local warning_time_minutes, kick_time_minutes = nil
		local location = settings.location

		if location == "hub" then
			warning_time_minutes = GameParameters.afk_warning_time_hub
			kick_time_minutes = GameParameters.afk_kick_time_hub
		elseif location == "mission" then
			warning_time_minutes = GameParameters.afk_warning_time_mission
			kick_time_minutes = GameParameters.afk_kick_time_mission
		end

		self._ignore_disabled_players = settings.ignore_disabled_players
		self._minutes_from_warning_to_kick = kick_time_minutes - warning_time_minutes
		self._warning_time = warning_time_minutes * 60
		self._kick_time = kick_time_minutes * 60
		self._players_last_input_time = {}
		self._warned_players = {}
		self._kicked_players = {}

		self._network_event_delegate:register_session_events(self, unpack(SERVER_RPCS))
	else
		self._warning_popup_id = nil

		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))

		if Managers.ui and settings.include_menu_activity then
			self._report_menu_activity = true
			self._menu_input_detected = false
			self._menu_activity_report_time = 0
		end
	end
end

AFKChecker.destroy = function (self)
	if self._is_server then
		self._network_event_delegate:unregister_events(unpack(SERVER_RPCS))
	else
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))

		if self._warning_popup_id then
			self:_hide_warning_popup()
		end
	end

	self._network_event_delegate = nil
end

local temp_existing_player_ids = {}

AFKChecker.server_update = function (self, dt, t)
	if not GameParameters.enable_afk_check then
		return
	end

	table.clear(temp_existing_player_ids)

	local players_last_input_time = self._players_last_input_time
	local warned_players = self._warned_players
	local kicked_players = self._kicked_players
	local ignore_disabled_players = self._ignore_disabled_players

	for _, player in pairs(Managers.player:players()) do
		local player_id = player:unique_id()
		temp_existing_player_ids[player_id] = true

		if player:is_human_controlled() and player.remote and not kicked_players[player_id] then
			if player:unit_is_alive() then
				if players_last_input_time[player_id] then
					local player_unit = player.player_unit
					local check_input = true

					if ignore_disabled_players and not warned_players[player_id] then
						local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
						local character_state_component = unit_data_extension:read_component("character_state")
						local is_disabled = PlayerUnitStatus.is_disabled(character_state_component)

						if is_disabled then
							check_input = false
							players_last_input_time[player_id] = t
						end
					end

					if check_input then
						local input_extension = ScriptUnit.extension(player_unit, "input_system")
						local move_vector = input_extension:get("move")

						if Vector3.length_squared(move_vector) > 0 then
							players_last_input_time[player_id] = t
						end
					end
				else
					players_last_input_time[player_id] = t
				end
			end

			local last_input_time = players_last_input_time[player_id]

			if last_input_time then
				if t > last_input_time + self._kick_time then
					self:_kick(player_id)
				elseif t > last_input_time + self._warning_time then
					if not self._warned_players[player_id] then
						self:_enable_warning(player_id)
					end
				elseif self._warned_players[player_id] then
					self:_disable_warning(player_id)
				end
			end
		end
	end

	for player_id, _ in pairs(players_last_input_time) do
		if not temp_existing_player_ids[player_id] then
			players_last_input_time[player_id] = nil
			warned_players[player_id] = nil
			kicked_players[player_id] = nil
		end
	end
end

AFKChecker._enable_warning = function (self, player_id)
	local player = Managers.player:player_from_unique_id(player_id)
	local peer_id = player:peer_id()

	Managers.state.game_session:send_rpc_client("rpc_enable_inactivity_warning", peer_id, self._minutes_from_warning_to_kick)

	self._warned_players[player:unique_id()] = true

	Log.info("AFKChecker", "Enabled inactivity warning for player %s at peer %s, will be kicked in %s minutes", player_id, peer_id, self._minutes_from_warning_to_kick)
end

AFKChecker._disable_warning = function (self, player_id)
	local player = Managers.player:player_from_unique_id(player_id)
	local peer_id = player:peer_id()

	Managers.state.game_session:send_rpc_client("rpc_disable_inactivity_warning", peer_id)

	self._warned_players[player:unique_id()] = nil

	Log.info("AFKChecker", "Disabled inactivity warning for player %s at peer %s", player_id, peer_id)
end

AFKChecker._kick = function (self, player_id)
	local player = Managers.player:player_from_unique_id(player_id)
	local peer_id = player:peer_id()
	local kick_reason = "afk"
	local details = nil

	Managers.connection:kick(peer_id, kick_reason, details)

	self._kicked_players[player_id] = true

	Log.info("AFKChecker", "Kicked player %s at peer %s for inactivity", player_id, peer_id)
end

AFKChecker.rpc_report_menu_activity = function (self, channel_id)
	local peer_id = Managers.state.game_session:channel_to_peer(channel_id)
	local players_at_peer = Managers.player:players_at_peer(peer_id)
	local t = Managers.time:time("gameplay")

	for _, player in pairs(players_at_peer) do
		local player_id = player:unique_id()
		self._players_last_input_time[player_id] = t
	end
end

AFKChecker.rpc_enable_inactivity_warning = function (self, channel_id, minutes_to_kick)
	Log.info("AFKChecker", "Enabled inactivity warning, getting kicked in %s minutes", minutes_to_kick)

	if not self._warning_popup_id then
		self:_show_warning_popup(minutes_to_kick)
	end
end

AFKChecker.rpc_disable_inactivity_warning = function (self, channel_id)
	Log.info("AFKChecker", "Disabled inactivity warning")

	if self._warning_popup_id then
		self:_hide_warning_popup()
	end
end

AFKChecker._show_warning_popup = function (self, minutes_to_kick)
	local context = {
		title_text = "loc_popup_header_afk_kick_warning",
		description_text = "loc_popup_description_afk_kick_warning_dynamic",
		priority_order = 10,
		description_text_params = {
			time = minutes_to_kick
		},
		options = {
			{
				text = "loc_popup_button_cancel",
				callback = callback(function ()
					Managers.state.game_session:send_rpc_server("rpc_report_menu_activity")
				end)
			}
		}
	}

	Managers.event:trigger("event_show_ui_popup", context, function (id)
		self._warning_popup_id = id
	end)
end

AFKChecker._hide_warning_popup = function (self)
	Managers.event:trigger("event_remove_ui_popup", self._warning_popup_id)

	self._warning_popup_id = nil
end

local device_list = {
	Keyboard,
	Mouse,
	Pad1
}

local function _any_pressed()
	if IS_XBS then
		local input_device_list = InputUtils.input_device_list
		local xbox_controllers = input_device_list.xbox_controller

		for i = 1, #xbox_controllers do
			local xbox_controller = xbox_controllers[i]

			if xbox_controller.active() and xbox_controller.any_pressed() then
				return true
			end
		end
	else
		for i = 1, #device_list do
			local device = device_list[i]

			if device and device.active and device.any_pressed() then
				return true
			end
		end
	end
end

AFKChecker.client_update = function (self, dt, t)
	if self._report_menu_activity then
		if self._menu_input_detected then
			if self._menu_activity_report_time < t then
				Managers.state.game_session:send_rpc_server("rpc_report_menu_activity")

				self._menu_activity_report_time = t + MENU_ACTIVITY_REPORT_INTERVAL
				self._menu_input_detected = false
			end
		elseif Managers.ui:has_active_view() and _any_pressed() then
			self._menu_input_detected = true
		end
	end
end

return AFKChecker
