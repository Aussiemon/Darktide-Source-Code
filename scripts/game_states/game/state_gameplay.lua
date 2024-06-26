-- chunkname: @scripts/game_states/game/state_gameplay.lua

local GameplayStateInit = require("scripts/game_states/game/gameplay_sub_states/gameplay_state_init")
local GameStateMachine = require("scripts/foundation/utilities/game_state_machine")
local PerformanceReporter = require("scripts/utilities/performance_reporter")
local WorldRenderUtils = require("scripts/utilities/world_render")
local StateGameplay = class("StateGameplay")

StateGameplay.NEEDS_MISSION_LEVEL = true

StateGameplay.on_enter = function (self, parent, params, creation_context)
	local mechanism_data = params.mechanism_data
	local world = params.world
	local shared_state = {}

	shared_state.is_server = params.is_host
	shared_state.world = world
	shared_state.world_name = params.world_name
	shared_state.level_name = params.level_name
	shared_state.level = params.level
	shared_state.mission_name = params.mission_name
	shared_state.themes = params.themes
	shared_state.challenge = mechanism_data.challenge
	shared_state.resistance = mechanism_data.resistance
	shared_state.circumstance_name = mechanism_data.circumstance_name
	shared_state.side_mission = mechanism_data.side_mission
	shared_state.mission_giver_vo = mechanism_data.mission_giver_vo_override or "none"
	shared_state.physics_world = World.physics_world(world)
	shared_state.level_seed = GameParameters.level_seed or Managers.connection:session_seed()
	shared_state.vo_sources_cache = creation_context.vo_sources_cache

	local tick_rate = Managers.connection:tick_rate()

	shared_state.fixed_time_step = 1 / tick_rate
	shared_state.is_dedicated_server = Managers.connection:is_dedicated_hub_server() or Managers.connection:is_dedicated_mission_server()
	shared_state.is_dedicated_mission_server = Managers.connection:is_dedicated_mission_server()
	shared_state.spawn_group_id = params.spawn_group_id
	shared_state.pacing_control = mechanism_data.pacing_control
	shared_state.nav_world = nil
	shared_state.nav_data = nil
	shared_state.hard_cap_out_of_bounds_units = nil
	shared_state.soft_cap_out_of_bounds_units = nil
	shared_state.nvidia_ai_agent = nil
	shared_state.free_flight_teleporter = nil
	shared_state.clock_handler_client = nil
	shared_state.breed_unit_tester = nil
	shared_state.network_receive_function = creation_context.network_receive_function
	shared_state.network_transmit_function = creation_context.network_transmit_function

	Crashify.print_property("mission", tostring(params.mission_name))
	Crashify.print_breadcrumb(string.format("StateGameplay:on_enter(): %s", tostring(params.mission_name)))
	Crashify.print_property("circumstance", tostring(mechanism_data.circumstance_name))

	local start_params = {
		shared_state = shared_state,
	}
	local sub_state_change_callbacks = {}

	if Managers.ui then
		sub_state_change_callbacks.UIManager = callback(Managers.ui, "cb_on_game_sub_state_change")
	end

	local state_machine = GameStateMachine:new(self, GameplayStateInit, start_params, nil, sub_state_change_callbacks, "GamePlay")

	self._state_machine = state_machine
	self._shared_state = shared_state
	self._testify_performance_reporter = nil
	self._next_state = nil
	self._next_state_context = nil
	self._is_dedicated_server = shared_state.is_dedicated_server
	self._world_name = shared_state.world_name
	self._viewport_name = "player1"
	self._game_world_fullscreen_blur_enabled = false
	self._game_world_fullscreen_blur_amount = 0
end

StateGameplay.on_exit = function (self, on_shutdown)
	self._next_state = nil
	self._next_state_context = nil

	if Managers.ui then
		self._state_machine:unregister_on_state_change_callback("UIManager")
	end

	self._state_machine:delete(on_shutdown)
end

StateGameplay.update = function (self, main_dt, main_t)
	self._state_machine:update(main_dt, main_t)
	self:_update_performance_reporter(main_dt, main_t)

	if not self._is_dedicated_server then
		self:_handle_world_fullscreen_blur()
		self:_handle_world_enabled_state()
	end

	self:_check_transition()

	if self:_should_transition() then
		return self._next_state, self._next_state_context
	end

	return nil, nil
end

StateGameplay._handle_world_fullscreen_blur = function (self)
	local ui_manager = Managers.ui

	if ui_manager then
		local apply_blur, blur_amount = ui_manager:use_fullscreen_blur()

		if apply_blur ~= self._game_world_fullscreen_blur_enabled or self._game_world_fullscreen_blur_amount ~= blur_amount then
			local world_name = self._world_name
			local viewport_name = self._viewport_name

			self._game_world_fullscreen_blur_enabled = apply_blur
			self._game_world_fullscreen_blur_amount = blur_amount

			if apply_blur then
				WorldRenderUtils.enable_world_fullscreen_blur(world_name, viewport_name, blur_amount)
			else
				WorldRenderUtils.disable_world_fullscreen_blur(world_name, viewport_name)
			end
		end
	end
end

StateGameplay._handle_world_enabled_state = function (self)
	local ui_manager = Managers.ui

	if ui_manager then
		local world_name = self._world_name
		local world_manager = Managers.world
		local has_world = world_manager:has_world(world_name)
		local disable_game_world = ui_manager:disable_game_world()
		local game_world_disabled = not world_manager:is_world_enabled(world_name)

		if disable_game_world ~= game_world_disabled then
			local viewport_name = self._viewport_name

			if disable_game_world then
				WorldRenderUtils.deactivate_world(world_name, viewport_name)
			else
				WorldRenderUtils.activate_world(world_name, viewport_name)
			end
		end
	end
end

StateGameplay._check_transition = function (self)
	if not DEDICATED_SERVER then
		local error_state, error_state_params = Managers.error:wanted_transition()

		if error_state then
			self._next_state = error_state
			self._next_state_context = error_state_params
		elseif IS_XBS or IS_GDK or IS_PLAYSTATION then
			local error_state, error_state_params = Managers.account:wanted_transition()

			if error_state then
				self._next_state = error_state
				self._next_state_context = error_state_params
			end
		end
	end

	if self._next_state == nil then
		local next_state, next_state_context = Managers.mechanism:wanted_transition()

		if next_state then
			self._next_state = next_state
			self._next_state_context = next_state_context
		end
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

StateGameplay.init_performance_reporter = function (self, values_to_measure)
	self._testify_performance_reporter = PerformanceReporter:new(values_to_measure)
end

StateGameplay.destroy_performance_reporter = function (self)
	self._testify_performance_reporter = nil
end

StateGameplay.performance_reporter = function (self)
	return self._testify_performance_reporter
end

return StateGameplay
