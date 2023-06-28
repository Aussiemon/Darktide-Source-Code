local StateTitle = require("scripts/game_states/game/state_title")
local StateError = class("StateError")

StateError.on_enter = function (self, parent, params, creation_context)
	self._creation_context = creation_context

	self:_cleanup()

	self._continue = false
	self._params = params
	local player_game_state_mapping = {}
	local game_state_context = {}

	Managers.player:on_game_state_enter(self, player_game_state_mapping, game_state_context)

	self._has_shown_errors = false
end

StateError._cleanup = function (self)
	Managers.ui:close_all_views(true, {
		"loading_view"
	})
	Managers.multiplayer_session:reset("reset_from_state_error")
	Managers.mechanism:leave_mechanism()

	local connection_manager = Managers.connection

	if connection_manager:is_initialized() then
		local peer_id = Network.peer_id()
		local player_manager = Managers.player
		local local_players = player_manager:players_at_peer(peer_id)

		if local_players then
			for local_player_id, player in pairs(local_players) do
				player_manager:remove_player(peer_id, local_player_id)
			end
		end

		if connection_manager.platform == "wan_client" then
			connection_manager:destroy_wan_client()
		end
	end

	Managers.chat:logout()
	Managers.backend:logout()

	if GameParameters.prod_like_backend then
		Managers.party_immaterium:reset()
		Managers.presence:reset()
	end

	Managers.data_service:reset()
end

StateError.update = function (self, main_dt, main_t)
	local context = self._creation_context

	context.network_receive_function(main_dt)
	context.network_transmit_function()
	Managers.player:state_update(main_dt, main_t)

	if not self._has_shown_errors and not Managers.ui:handling_popups() then
		self._has_shown_errors = true

		Managers.error:show_errors():next(function ()
			self._continue = true
		end)
	end

	if self._continue then
		return StateTitle, self._params
	end
end

StateError.on_exit = function (self)
	Managers.player:on_game_state_exit(self)
end

return StateError
