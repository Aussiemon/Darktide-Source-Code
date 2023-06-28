local AFKChecker = require("scripts/managers/game_mode/afk_checker")
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

	if not self._is_server then
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))

		self._network_event_delegate = network_event_delegate
	end

	if not DEDICATED_SERVER and settings.cache_local_player_profile then
		local local_player_id = 1
		local player = Managers.player:local_player(local_player_id)
		local player_profile = player:profile()
		self._cached_player_profile = table.clone_instance(player_profile)
	end

	if settings.afk_check then
		self._afk_checker = AFKChecker:new(self._is_server, settings.afk_check, network_event_delegate)
	end
end

GameModeBase.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	local settings = self._settings

	if not DEDICATED_SERVER and settings.cache_local_player_profile then
		local cached_profile = self._cached_player_profile
		local player = Managers.player:local_player(1)

		player:set_profile(cached_profile)
	end

	if self._afk_checker then
		self._afk_checker:delete()

		self._afk_checker = nil
	end
end

GameModeBase.server_update = function (self, dt, t)
	if self._afk_checker then
		self._afk_checker:server_update(dt, t)
	end
end

GameModeBase.client_update = function (self, dt, t)
	if self._afk_checker then
		self._afk_checker:client_update(dt, t)
	end
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

GameModeBase.on_player_unit_spawn = function (self, player, unit, is_respawn)
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
		Managers.state.player_unit_spawn:remove_all_bots()
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
