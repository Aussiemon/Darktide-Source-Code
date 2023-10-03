local GameplayStateInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_state_interface")
local MissionCleanupUtilies = require("scripts/game_states/game/gameplay_sub_states/utilities/mission_cleanup_utilities")
local StateGameplayTestify = GameParameters.testify and require("scripts/game_states/game/state_gameplay_testify")
local TaskbarFlash = require("scripts/utilities/taskbar_flash")
local UnitSpawnerManager = require("scripts/foundation/managers/unit_spawner/unit_spawner_manager")
local RUN_CLIENT_RPCS = {
	"rpc_sync_clock"
}
local DELETION_STATES = UnitSpawnerManager.DELETION_STATES
local GameplayStateRun = class("GameplayStateRun")

GameplayStateRun.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	local is_server = shared_state.is_server
	self._gameplay_state = parent
	self._shared_state = shared_state
	self._gameplay_timer_registered = is_server
	self._fixed_frame_parsed = false
	self._max_dt = 0
	self._fixed_frame_counter = 0
	self._failed_clients = {}
	self._delayed_disconnects = {}
	self._crash_countdown = GameParameters.crash_countdown

	self:_register_run_network_events(is_server)
	Managers.event:trigger("event_loading_finished")

	if not DEDICATED_SERVER then
		Managers.dlc:evaluate_consumables()
	end

	local telemetry_params = {
		mission_name = shared_state.mission_name,
		host_type = Managers.connection:host_type()
	}

	Managers.telemetry_events:gameplay_started(telemetry_params)
	TaskbarFlash.flash_window()
end

GameplayStateRun.on_exit = function (self)
	local shared_state = self._shared_state
	local gameplay_state = self._gameplay_state
	local is_server = shared_state.is_server

	Managers.telemetry_events:gameplay_stopped()
	MissionCleanupUtilies.cleanup(shared_state, gameplay_state)
	self:_unregister_run_network_events(is_server)
end

GameplayStateRun.update = function (self, main_dt, main_t)
	local shared_state = self._shared_state
	local is_server = shared_state.is_server
	local is_dedicated_server = shared_state.is_dedicated_server
	self._fixed_frame_parsed = false

	if self._crash_countdown > -1 then
		self._crash_countdown = self._crash_countdown - main_dt
		self._crash_countdown = math.max(self._crash_countdown, 0)

		if self._crash_countdown == 0 then
			Application.crash(GameParameters.crash_type)
		end
	end

	if not Managers.state.game_mode:run_single_threaded_physics() then
		local physics_world = shared_state.physics_world

		PhysicsWorld.fetch_queries(physics_world)
	end

	shared_state.network_receive_function(main_dt)
	Managers.state.game_session:update(main_dt)
	Managers.state.unit_spawner:set_deletion_state(DELETION_STATES.during_extension_update)
	Managers.state.position_lookup:pre_update()
	Managers.state.out_of_bounds:pre_update(shared_state)
	Managers.state.bone_lod:pre_update()

	local gameplay_timer_registered = self._gameplay_timer_registered
	local t = gameplay_timer_registered and Managers.time:time("gameplay")
	local dt = gameplay_timer_registered and Managers.time:delta_time("gameplay")
	local player_manager = Managers.player

	player_manager:state_pre_update(main_dt, main_t)
	Managers.state.unit_spawner:commit_and_remove_pending_units()
	Managers.state.out_of_bounds:update(shared_state)

	local extension_manager = Managers.state.extension
	local player_unit_spawn_manager = Managers.state.player_unit_spawn

	if gameplay_timer_registered then
		extension_manager:pre_update(dt, t)
		self:_fixed_update(extension_manager, player_manager, player_unit_spawn_manager, t, dt)
		Managers.state.nav_mesh:update(dt, t)
		Managers.state.main_path:update(dt, t)
		Managers.state.blood:update(dt, t)
		Managers.state.decal:update(dt, t)
		Managers.state.cinematic:update(dt, t)
		Managers.state.network_story:update(dt, t)
		Managers.state.rooms_and_portals:update(dt, t)
		Managers.state.mutator:update(dt, t)
		Managers.state.attack_report:update(dt, t)
		Managers.state.emote:update(dt, t)
	end

	player_manager:state_update(main_dt, main_t)
	Managers.state.chunk_lod:update(main_dt, main_t)
	self:_handle_load_failures()
	self:_handle_session_disconnects()

	if gameplay_timer_registered then
		Managers.state.level_props_broadphase:update(dt, t)
		extension_manager:update()
		Managers.state.minion_death:update(dt, t)

		if is_server then
			Managers.state.terror_event:update(dt, t)
			Managers.state.pacing:update(dt, t)
			Managers.state.minion_spawn:update(dt, t)
			Managers.state.horde:update(dt, t)
		end

		Managers.state.player_unit_spawn:update(dt, t)
		Managers.state.game_mode:update(dt, t)
	end

	Managers.state.unit_job:update(dt, t)

	if not is_dedicated_server then
		Managers.state.world_interaction:update(dt, t)
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(StateGameplayTestify, self._gameplay_state)
	end

	if GameParameters.nvidia_ai_agent and not is_dedicated_server then
		local nvidia_ai_agent = shared_state.nvidia_ai_agent

		nvidia_ai_agent:update(dt, t)
	end
end

GameplayStateRun.post_update = function (self, main_dt, main_t)
	local shared_state = self._shared_state
	local physics_world = shared_state.physics_world
	local is_server = shared_state.is_server
	local wants_single_threaded_physics = Managers.state.game_mode:wants_single_threaded_physics()

	Managers.state.game_mode:_set_single_threaded_physics(wants_single_threaded_physics)

	if wants_single_threaded_physics then
		PhysicsWorld.run_queries(physics_world)
		PhysicsWorld.fetch_queries(physics_world)
	end

	if self._gameplay_timer_registered then
		Managers.state.extension:post_update()
	end

	Managers.player:state_post_update(main_dt, main_t)
	Managers.state.unit_spawner:set_deletion_state(DELETION_STATES.default)
	Managers.state.player_unit_spawn:process_queued_despawns()

	if self._fixed_frame_parsed or not self._gameplay_timer_registered then
		shared_state.network_transmit_function()
	end

	Managers.state.unit_spawner:commit_and_remove_pending_units()

	if not wants_single_threaded_physics then
		PhysicsWorld.run_queries(physics_world)
	end

	if not is_server then
		shared_state.clock_handler_client:post_update(main_dt)
	end

	Managers.state.position_lookup:post_update()
end

GameplayStateRun.render = function (self)
	Managers.player:state_render(Managers.time:delta_time("main"), Managers.time:time("main"))
end

GameplayStateRun.on_reload = function (self, refreshed_resources)
	Managers.state.extension:on_reload(refreshed_resources)
end

GameplayStateRun._register_run_network_events = function (self, is_server)
	if not is_server then
		local connection_manager = Managers.connection
		local network_event_delegate = connection_manager:network_event_delegate()

		network_event_delegate:register_session_events(self, unpack(RUN_CLIENT_RPCS))
	end
end

GameplayStateRun._unregister_run_network_events = function (self, is_server)
	if not is_server then
		local connection_manager = Managers.connection
		local network_event_delegate = connection_manager:network_event_delegate()

		network_event_delegate:unregister_events(unpack(RUN_CLIENT_RPCS))
	end
end

GameplayStateRun._fixed_update = function (self, extension_manager, player_manager, player_unit_spawn_manager, t, dt)
	local shared_state = self._shared_state
	local fixed_time_step = shared_state.fixed_time_step
	local last_frame = math.floor(t / fixed_time_step)
	local fixed_dt = fixed_time_step
	local keep_in_scope = true

	for frame = self._fixed_frame_counter + 1, last_frame do
		local fixed_t = fixed_dt * frame

		player_manager:state_fixed_update(fixed_dt, fixed_t, frame)
		player_unit_spawn_manager:fixed_update(fixed_dt, fixed_t, frame)
		Managers.state.player_overlap_manager:fixed_update(fixed_dt, fixed_t, frame)
		extension_manager:fixed_update(fixed_dt, fixed_t, frame)

		self._fixed_frame_parsed = true
	end

	self._fixed_frame_counter = last_frame
end

GameplayStateRun._handle_load_failures = function (self)
	local loading_manager = Managers.loading

	if loading_manager:is_host() then
		local failed_clients = self._failed_clients

		table.clear(failed_clients)
		loading_manager:failed_clients(failed_clients)

		for i = 1, #failed_clients do
			local peer_id = failed_clients[i]

			Managers.connection:disconnect(peer_id)
		end
	end
end

GameplayStateRun._handle_session_disconnects = function (self)
	local delayed_disconnects = self._delayed_disconnects

	Managers.state.game_session:delayed_disconnects(delayed_disconnects)

	for _, peer_id in ipairs(delayed_disconnects) do
		Managers.connection:disconnect(peer_id)
	end
end

GameplayStateRun.rpc_sync_clock = function (self, channel_id, time, offset)
	if not self._gameplay_timer_registered then
		self._gameplay_timer_registered = true
		REPORTIFY_NETWORK_READY = true
		local fixed_frame_transmit_rate = GameParameters.fixed_frame_transmit_rate

		Network.set_max_transmit_rate(fixed_frame_transmit_rate)

		local shared_state = self._shared_state
		local fixed_time_step = shared_state.fixed_time_step
		local last_frame = math.floor(time / fixed_time_step)

		shared_state.clock_handler_client:rpc_sync_clock(time + Managers.time:delta_time("main"), offset, last_frame)

		self._fixed_frame_counter = last_frame
		local world = shared_state.world

		Managers.world:set_scene_update_callback(world, function ()
			Managers.state.extension:physics_async_update()
		end)
	end
end

implements(GameplayStateRun, GameplayStateInterface)

return GameplayStateRun
