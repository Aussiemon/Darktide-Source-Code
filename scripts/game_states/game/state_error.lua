local StateTitle = require("scripts/game_states/game/state_title")
local StateError = class("StateError")

StateError.on_enter = function (self, parent, params, creation_context)
	self._creation_context = creation_context

	self:_cleanup()

	self._continue = false
	local player_game_state_mapping = {}
	local game_state_context = {}

	Managers.player:on_game_state_enter(self, player_game_state_mapping, game_state_context)
	Managers.error:show_errors():next(function ()
		self._continue = true
	end)
	Managers.presence:set_presence("title_screen")
end

StateError._cleanup = function (self)
	Managers.multiplayer_session:reset("reset_from_state_error")
	Managers.mechanism:leave_mechanism()

	local peer_id = Network.peer_id()
	local player_manager = Managers.player
	local local_players = player_manager:players_at_peer(peer_id)

	if local_players then
		for local_player_id, player in pairs(local_players) do
			player_manager:remove_player(peer_id, local_player_id)
		end
	end

	if GameParameters.prod_like_backend then
		Managers.party_immaterium:leave_party()
	end
end

StateError.update = function (self, main_dt, main_t)
	local context = self._creation_context

	context.network_receive_function(main_dt)
	context.network_transmit_function()
	Managers.player:state_update(main_dt, main_t)

	if self._continue then
		return StateTitle, {}
	end
end

StateError.on_exit = function (self)
	Managers.player:on_game_state_exit(self)
end

return StateError
