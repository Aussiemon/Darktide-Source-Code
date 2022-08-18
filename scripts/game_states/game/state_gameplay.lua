local GameplayStateInit = require("scripts/game_states/game/gameplay_sub_states/gameplay_state_init")
local GameStateMachine = require("scripts/foundation/utilities/game_state_machine")
local PerformanceReporter = require("scripts/utilities/performance_reporter")
local StateGameplay = class("StateGameplay")
StateGameplay.NEEDS_MISSION_LEVEL = true

StateGameplay.on_enter = function (self, parent, params, creation_context)
	local mechanism_data = params.mechanism_data

	fassert(mechanism_data.challenge, "[StateGameplay] 'challenge' missing in game state params")
	fassert(mechanism_data.resistance, "[StateGameplay] 'resistance' missing in game state params")
	fassert(mechanism_data.circumstance_name, "[StateGameplay] 'circumstance_name' missing in game state params")
	fassert(mechanism_data.side_mission, "[StateGameplay] 'side_mission' missing in game state params")
	fassert(params.mission_name, "[StateGameplay] 'mission_name' missing in game state params")

	local world = params.world
	local shared_state = {
		is_server = params.is_host,
		world = world,
		level_name = params.level_name,
		level = params.level,
		mission_name = params.mission_name,
		themes = params.themes,
		challenge = mechanism_data.challenge,
		resistance = mechanism_data.resistance,
		circumstance_name = mechanism_data.circumstance_name,
		side_mission = mechanism_data.side_mission,
		physics_world = World.physics_world(world),
		level_seed = GameParameters.level_seed or Managers.connection:session_seed(),
		vo_sources_cache = creation_context.vo_sources_cache,
		fixed_frame_time = GameParameters.fixed_time_step,
		is_dedicated_server = Managers.connection:is_dedicated_hub_server() or Managers.connection:is_dedicated_mission_server(),
		is_dedicated_mission_server = Managers.connection:is_dedicated_mission_server(),
		spawn_group_id = params.spawn_group_id,
		nav_world = nil,
		nav_data = nil,
		hard_cap_out_of_bounds_units = nil,
		soft_cap_out_of_bounds_units = nil,
		nvidia_ai_agent = nil,
		free_flight_teleporter = nil,
		clock_handler_client = nil,
		breed_unit_tester = nil,
		network_receive_function = creation_context.network_receive_function,
		network_transmit_function = creation_context.network_transmit_function
	}

	fassert((shared_state.is_dedicated_server == true and DEDICATED_SERVER) or shared_state.is_dedicated_server == false, "[StateGameplay][on_enter] Please check connection type.")
	Crashify.print_property("mission", tostring(params.mission_name))

	local start_params = {
		shared_state = shared_state
	}
	local sub_state_change_callbacks = {}

	if Managers.ui then
		sub_state_change_callbacks.UIManager = callback(Managers.ui, "cb_on_game_sub_state_change")
	end

	local state_machine = GameStateMachine:new(self, GameplayStateInit, start_params, nil, sub_state_change_callbacks)
	self._state_machine = state_machine
	self._shared_state = shared_state
	self._testify_performance_reporter = nil
	self._next_state = nil
	self._next_state_context = nil
end

StateGameplay.on_exit = function (self)
	self._next_state = nil
	self._next_state_context = nil

	if Managers.ui then
		self._state_machine:unregister_on_state_change_callback("UIManager")
	end

	self._state_machine:delete()
end

StateGameplay.update = function (self, main_dt, main_t)
	self._state_machine:update(main_dt, main_t)
	self:_update_performance_reporter(main_dt, main_t)
	self:_check_transition()

	if self:_should_transition() then
		return self._next_state, self._next_state_context
	end

	return nil, nil
end

StateGameplay._check_transition = function (self)
	if not DEDICATED_SERVER then
		local error_state, error_state_params = Managers.error:wanted_transition()

		if error_state then
			self._next_state = error_state
			self._next_state_context = error_state_params
		elseif IS_XBS then
			local error_state, error_state_params = Managers.account:wanted_transition()

			if error_state then
				self._next_state = error_state
				self._next_state_context = error_state_params
			end
		end
	end

	if self._next_state == nil then
		local next_state, next_state_context = Managers.mechanism:wanted_transition()
		self._next_state = next_state
		self._next_state_context = next_state_context
	end
end

StateGameplay._should_transition = function (self)
	local gameplay_running = self._state_machine:current_state_name() ~= "GameplayStateInit"
	local has_next_state = self._next_state ~= nil

	return gameplay_running and has_next_state
end

StateGameplay.post_update = function (self, main_dt, main_t)
	self._state_machine:post_update(main_dt, main_t)
end

StateGameplay.render = function (self)
	self._state_machine:render()
end

StateGameplay.on_reload = function (self, refreshed_resources)
	self._state_machine:on_reload(refreshed_resources)
end

StateGameplay._update_performance_reporter = function (self, dt, t)
	local testify_performance_reporter = self._testify_performance_reporter

	if GameParameters.testify and testify_performance_reporter then
		testify_performance_reporter:update(dt, t)
	end
end

StateGameplay.rpc_player_input_array = function (self, channel_id, local_player_id, ...)
	local sender = Managers.state.game_session:channel_to_peer(channel_id)
	local player = Managers.player:player(sender, local_player_id)

	player.input_handler:rpc_player_input_array(channel_id, local_player_id, ...)
end

StateGameplay.rpc_player_input_array_ack = function (self, channel_id, local_player_id, ...)
	local player = Managers.player:local_player(local_player_id)

	player.input_handler:rpc_player_input_array_ack(channel_id, local_player_id, ...)
end

StateGameplay.init_performance_reporter = function (self)
	self._testify_performance_reporter = PerformanceReporter:new()
end

StateGameplay.destroy_performance_reporter = function (self)
	self._testify_performance_reporter = nil
end

StateGameplay.performance_reporter = function (self)
	return self._testify_performance_reporter
end

return StateGameplay
