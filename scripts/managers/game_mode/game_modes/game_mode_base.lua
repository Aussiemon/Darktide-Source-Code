local BotSpawning = require("scripts/managers/bot/bot_spawning")
local GameModeSettings = require("scripts/settings/game_mode/game_mode_settings")
local GameModeBase = class("GameModeBase")
GameModeBase.INTERFACE = {
	"server_update",
	"complete",
	"fail",
	"evaluate_end_conditions",
	"on_player_unit_spawn",
	"on_player_unit_despawn",
	"can_spawn_player",
	"player_time_until_spawn",
	"cleanup_game_mode_units"
}
local CLIENT_RPCS = {
	"rpc_change_game_mode_state"
}

local function _log(...)
	Log.info("GameModeBase", ...)
end

GameModeBase.init = function (self, game_mode_context, game_mode_name, network_event_delegate)
	self._name = game_mode_name
	self._world = game_mode_context.world
	self._is_server = game_mode_context.is_server
	local settings = GameModeSettings[game_mode_name]
	self._settings = settings
	local states = settings.states
	self._states = states
	self._states_lookup = table.mirror_table(states)
	self._state = states[1]

	if self._is_server then
		local bot_backfilling_allowed = settings.bot_backfilling_allowed
		self._queued_bots_n = 0

		if bot_backfilling_allowed then
			self:_register_bot_events()
			self:_validate_bot_count()

			while self._queued_bots_n > 0 do
				self:_handle_bot_spawning()
			end
		end
	else
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))

		self._network_event_delegate = network_event_delegate
	end
end

GameModeBase.destroy = function (self)
	if self._is_server then
		if self._settings.bot_backfilling_allowed then
			self:_unregister_bot_events()
		end
	else
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

GameModeBase.server_update = function (self, dt, t)
	self:_handle_bot_spawning()
end

GameModeBase.name = function (self)
	return self._name
end

GameModeBase.settings = function (self)
	return self._settings
end

GameModeBase.state = function (self)
	return self._state
end

GameModeBase.on_player_unit_spawn = function (self, player, is_respawn)
	return
end

GameModeBase.on_player_unit_despawn = function (self, player)
	return
end

GameModeBase.can_spawn_player = function (self, player)
	return true
end

GameModeBase.player_time_until_spawn = function (self, player)
	return nil
end

GameModeBase.cleanup_game_mode_units = function (self)
	local bot_backfilling_allowed = self._settings.bot_backfilling_allowed

	if bot_backfilling_allowed then
		local bot_manager = Managers.bot
		local bot_synchronizer_host = bot_manager:synchronizer_host()

		if bot_synchronizer_host then
			local bot_ids = bot_synchronizer_host:active_bot_ids()

			for local_player_id, _ in pairs(bot_ids) do
				bot_synchronizer_host:remove_bot(local_player_id)
			end
		end
	end
end

GameModeBase._change_state = function (self, new_state)
	local old_state = self._state

	_log("[_change_state] Switching game mode state from %q to %q", old_state, new_state)
	self:_game_mode_state_changed(new_state, old_state)

	self._state = new_state

	if self._is_server then
		local new_state_id = self._states_lookup[new_state]

		Managers.state.game_session:send_rpc_clients("rpc_change_game_mode_state", new_state_id)
	end
end

GameModeBase._game_mode_state_changed = function (self, new_state, old_state)
	return
end

GameModeBase.rpc_change_game_mode_state = function (self, channel_id, new_state_id)
	local new_state = self._states_lookup[new_state_id]

	self:_change_state(new_state)
end

GameModeBase.hot_join_sync = function (self, sender, channel)
	local state_id = self._states_lookup[self._state]

	if state_id ~= 1 then
		RPC.rpc_change_game_mode_state(channel, state_id)
	end
end

GameModeBase._register_bot_events = function (self)
	Managers.event:register(self, "host_game_session_manager_player_joined", "_validate_bot_count")
	Managers.event:register(self, "multiplayer_session_client_disconnected", "_validate_bot_count")
end

GameModeBase._unregister_bot_events = function (self)
	Managers.event:unregister(self, "host_game_session_manager_player_joined")
	Managers.event:unregister(self, "multiplayer_session_client_disconnected")
end

GameModeBase._validate_bot_count = function (self)
	if not Managers.bot then
		return
	end

	local bot_synchronizer_host = Managers.bot:synchronizer_host()

	if not bot_synchronizer_host then
		return
	end

	local bot_backfilling_allowed = self._settings.bot_backfilling_allowed
	local max_players = GameParameters.max_players
	local num_players = Managers.player:num_human_players()
	local max_bots = bot_backfilling_allowed and self._settings.max_bots or 0
	local num_bots = bot_synchronizer_host:num_bots() + self._queued_bots_n
	local desired_bot_count = max_players - num_players
	desired_bot_count = math.clamp(desired_bot_count, 0, max_bots)

	if desired_bot_count < num_bots then
		local bots_to_remove = num_bots - desired_bot_count

		for ii = 1, bots_to_remove do
			if self._queued_bots_n > 0 then
				self._queued_bots_n = self._queued_bots_n - 1
			else
				BotSpawning.despawn_best_bot()
			end
		end
	elseif num_bots < desired_bot_count then
		local bots_to_spawn = desired_bot_count - num_bots
		self._queued_bots_n = self._queued_bots_n + bots_to_spawn
	end
end

GameModeBase._handle_bot_spawning = function (self)
	if self._queued_bots_n > 0 then
		local profile_name = "darktide_seven_01"

		BotSpawning.spawn_bot_character(profile_name)

		self._queued_bots_n = self._queued_bots_n - 1
	end
end

GameModeBase._cinematic_active = function (self)
	if Managers.state.cinematic:active() then
		return true
	end

	local cinematic_scene_system = Managers.state.extension:system("cinematic_scene_system")

	return cinematic_scene_system:is_active()
end

GameModeBase.should_spawn_dead = function (self, player)
	return false
end

return GameModeBase
