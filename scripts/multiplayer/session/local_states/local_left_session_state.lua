-- chunkname: @scripts/multiplayer/session/local_states/local_left_session_state.lua

local LocalLeftSessionState = class("LocalLeftSessionState")

LocalLeftSessionState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
end

LocalLeftSessionState.enter = function (self, reason)
	local shared_state = self._shared_state

	reason.peer_id = shared_state.peer_id
	reason.channel_id = shared_state.channel_id
	shared_state.event_list[#shared_state.event_list + 1] = {
		name = "session_left",
		parameters = reason
	}

	if shared_state.has_joined_session then
		local world = Managers.world:world("level_world")
		local physics_world = World.physics_world(world)

		PhysicsWorld.fetch_queries(physics_world)
		GameSession.leave(shared_state.engine_gamesession, shared_state.gameobject_callback_object)

		shared_state.has_joined_session = false
	end

	if shared_state.channel_id then
		shared_state.engine_lobby:close_channel(shared_state.channel_id)
	end
end

return LocalLeftSessionState
