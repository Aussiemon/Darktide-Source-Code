local GameplayRpcs = require("scripts/game_states/game/utilities/gameplay_rpcs")
local GameplayStateInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_state_interface")
local StateGameplayTestify = GameParameters.testify and require("scripts/game_states/game/state_gameplay_testify")
local UnitSpawnerManager = require("scripts/foundation/managers/unit_spawner/unit_spawner_manager")
local WorldRenderUtils = require("scripts/utilities/world_render")

local function _error(...)
	Log.error("StateGameplay", ...)
end

local SERVER_RPCS = GameplayRpcs.COMMON_SERVER_RPCS
local CLIENT_RPCS = GameplayRpcs.COMMON_CLIENT_RPCS
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
	self._world_name = "level_world"
	self._viewport_name = "player1"
	self._game_world_disabled = false
	self._game_world_fullscreen_blur_enabled = false
	self._game_world_fullscreen_blur_amount = 0
	self._failed_clients = {}
	self._delayed_disconnects = {}
	self._local_hard_cap_out_of_bounds_units = {}

	Profiler.start("_register_run_network_events")
	self:_register_run_network_events(is_server)
	Profiler.stop("_register_run_network_events")
	Profiler.start("_reload_imgui_guis")
	Profiler.stop("_reload_imgui_guis")
	Managers.event:trigger("event_loading_finished")

	local mission_name = shared_state.mission_name
	local telemetry_params = {
		mission_name = mission_name
	}

	Managers.telemetry_reporters:start_reporter("frame_time", telemetry_params)
	Managers.telemetry_reporters:start_reporter("ping", telemetry_params)

	if DEDICATED_SERVER then
		Managers.telemetry_reporters:start_reporter("player_dealt_damage")
		Managers.telemetry_reporters:start_reporter("player_taken_damage")
	end

	local do_activate_boons = self:_do_activate_boons()

	if do_activate_boons then
		Managers.boons:activate_boons()
	end
end

GameplayStateRun.on_exit = function (self)
	local shared_state = self._shared_state

	Profiler.start("physics_world_fetching_queries")

	local physics_world = shared_state.physics_world

	PhysicsWorld.fetch_queries(physics_world)
	Profiler.stop("physics_world_fetching_queries")

	REPORTIFY_NETWORK_READY = false
	local is_server = shared_state.is_server
	local is_dedicated_server = shared_state.is_dedicated_server
	local is_dedicated_mission_server = shared_state.is_dedicated_mission_server
	local gameplay_state = self._gameplay_state
	local world = shared_state.world
	local level = shared_state.level
	local themes = shared_state.themes

	Network.set_max_transmit_rate(GameParameters.default_transmit_rate)
	self:_music_notify_shutdown(is_dedicated_server)
	self:_mission_server_notify_shutdown(is_dedicated_mission_server)
	self:_player_notify_shutdown(gameplay_state)
	self:_unregister_network_events(is_server)
	self:_destroy_nvidia_ai_agent(is_dedicated_server, shared_state)
	Managers.state.game_session:disconnect()
	Managers.state.cinematic:stop_all_stories()
	self:_despawn_units(is_server, world, level, themes)
	Managers.state:destroy()
	Managers.world:destroy_world(self._world_name)
	self:_destroy_nav_world(shared_state)
	self:_unregister_timer(is_server, shared_state)
	self:_deinit_frame_rate()
	Profiler.start("_unregister_network_events")
	self:_unregister_run_network_events(is_server)
	Profiler.stop("_unregister_network_events")

	if DEDICATED_SERVER then
		Managers.telemetry_reporters:stop_reporter("player_taken_damage")
		Managers.telemetry_reporters:stop_reporter("player_dealt_damage")
	end

	Managers.telemetry_reporters:stop_reporter("frame_time")
	Managers.telemetry_reporters:stop_reporter("ping")
end

GameplayStateRun._do_activate_boons = function (self)
	local shared_state = self._shared_state
	local is_server = shared_state.is_server

	if not is_server then
		return false
	end

	local game_mode_name = Managers.state.game_mode:game_mode_name()
	local game_mode_hub = game_mode_name == "hub"

	if game_mode_hub then
		return false
	end

	return true
end

GameplayStateRun.update = function (self, main_dt, main_t)
	local shared_state = self._shared_state
	local is_server = shared_state.is_server
	local is_dedicated_server = shared_state.is_dedicated_server
	self._fixed_frame_parsed = false

	Profiler.start("physics_world_fetching_queries")

	local physics_world = shared_state.physics_world

	PhysicsWorld.fetch_queries(physics_world)
	Profiler.stop("physics_world_fetching_queries")
	Profiler.start("network_receive_function")
	shared_state.network_receive_function(main_dt)
	Profiler.stop("network_receive_function")
	Profiler.start("game_session_update")
	Managers.state.game_session:update(main_dt)
	Profiler.stop("game_session_update")
	Profiler.start("unit_spawner_set_deletion_state")
	Managers.state.unit_spawner:set_deletion_state(DELETION_STATES.during_extension_update)
	Profiler.stop("unit_spawner_set_deletion_state")
	Profiler.start("position_lookup_pre_update")
	Managers.state.position_lookup:pre_update()
	Profiler.stop("position_lookup_pre_update")
	Profiler.start("_update_out_of_bounds")
	self:_update_out_of_bounds()
	Profiler.stop("_update_out_of_bounds")
	Profiler.start("bone_lod_pre_update")
	Managers.state.bone_lod:pre_update()
	Profiler.stop("bone_lod_pre_update")

	if not is_dedicated_server then
		Profiler.start("_handle_world_fullscreen_blur")
		self:_handle_world_fullscreen_blur()
		Profiler.stop("_handle_world_fullscreen_blur")
		Profiler.start("_handle_world_enabled_state")
		self:_handle_world_enabled_state()
		Profiler.stop("_handle_world_enabled_state")
	end

	local gameplay_timer_registered = self._gameplay_timer_registered
	local t = gameplay_timer_registered and Managers.time:time("gameplay")
	local dt = gameplay_timer_registered and Managers.time:delta_time("gameplay")

	Profiler.start("player_manager_pre_update")

	local player_manager = Managers.player

	player_manager:state_pre_update(main_dt, main_t)
	Profiler.stop("player_manager_pre_update")
	Profiler.start("unit_spawner_commit_and_remove_pending_units")
	Managers.state.unit_spawner:commit_and_remove_pending_units()
	Profiler.stop("unit_spawner_commit_and_remove_pending_units")

	local extension_manager = Managers.state.extension
	local player_unit_spawn_manager = Managers.state.player_unit_spawn

	if gameplay_timer_registered then
		Profiler.start("extension_manager_pre_update")
		extension_manager:pre_update(dt, t)
		Profiler.stop("extension_manager_pre_update")
		Profiler.start("fixed_update")
		self:_fixed_update(extension_manager, player_manager, player_unit_spawn_manager, t)
		Profiler.stop("fixed_update")
		Profiler.start("nav_mesh_manager_update")
		Managers.state.nav_mesh:update(dt, t)
		Profiler.stop("nav_mesh_manager_update")
		Profiler.start("main_path_manager_update")
		Managers.state.main_path:update(dt, t)
		Profiler.stop("main_path_manager_update")
		Profiler.start("blood_manager_update")
		Managers.state.blood:update(dt, t)
		Profiler.stop("blood_manager_update")
		Profiler.start("decal_manager_update")
		Managers.state.decal:update(dt, t)
		Profiler.stop("decal_manager_update")
		Profiler.start("cinematic_manager_update")
		Managers.state.cinematic:update(dt, t)
		Profiler.stop("cinematic_manager_update")
		Profiler.start("network_story_manager_update")
		Managers.state.network_story:update(dt, t)
		Profiler.stop("network_story_manager_update")
		Profiler.start("rooms_and_portals_manager_update")
		Managers.state.rooms_and_portals:update(dt, t)
		Profiler.stop("rooms_and_portals_manager_update")
		Profiler.start("mutator_manager_update")
		Managers.state.mutator:update(dt, t)
		Profiler.stop("mutator_manager_update")
		Profiler.start("attack_report_manager")
		Managers.state.attack_report:update(dt, t)
		Profiler.stop("attack_report_manager")
	end

	Profiler.start("player_manager_state_update")
	player_manager:state_update(main_dt, main_t)
	Profiler.stop("player_manager_state_update")
	Profiler.start("chunk_lod_manager_update")
	Managers.state.chunk_lod:update(main_dt, main_t)
	Profiler.stop("chunk_lod_manager_update")
	Profiler.start("handle_load_failures")
	self:_handle_load_failures()
	Profiler.stop("handle_load_failures")
	Profiler.start("handle_session_disconnect")
	self:_handle_session_disconnects()
	Profiler.stop("handle_session_disconnect")

	if gameplay_timer_registered then
		Profiler.start("level_props_broadphase_update")
		Managers.state.level_props_broadphase:update(dt, t)
		Profiler.stop("level_props_broadphase_update")
		Profiler.start("extension_manager_update")
		extension_manager:update()
		Profiler.stop("extension_manager_update")
		Profiler.start("minion_death_manager_udpate")
		Managers.state.minion_death:update(dt, t)
		Profiler.stop("minion_death_manager_udpate")

		if is_server then
			Profiler.start("terror_event_manager_update")
			Managers.state.terror_event:update(dt, t)
			Profiler.stop("terror_event_manager_update")
			Profiler.start("pacing_manager_update")
			Managers.state.pacing:update(dt, t)
			Profiler.stop("pacing_manager_update")
			Profiler.start("minion_spawn_manager_update")
			Managers.state.minion_spawn:update(dt, t)
			Profiler.stop("minion_spawn_manager_update")
			Profiler.start("horde_manager_update")
			Managers.state.horde:update(dt, t)
			Profiler.stop("horde_manager_update")
		end

		Profiler.start("player_unit_spawn_manager_update")
		Managers.state.player_unit_spawn:update(dt, t)
		Profiler.stop("player_unit_spawn_manager_update")
		Profiler.start("game_mode_manager_update")
		Managers.state.game_mode:update(dt, t)
		Profiler.stop("game_mode_manager_update")
		Profiler.start("_check_nav_data")
		Profiler.stop("_check_nav_data")
	end

	Managers.state.unit_job:update(dt, t)

	if not is_dedicated_server then
		Managers.state.world_interaction:update(dt, t)
	end

	if GameParameters.testify then
		Profiler.start("poll_testify_results")
		Testify:poll_requests_through_handler(StateGameplayTestify, self._gameplay_state)
		Profiler.stop("poll_testify_results")
	end

	if GameParameters.nvidia_ai_agent and not is_dedicated_server then
		Profiler.start("nvidia_ai_agent_manager_update")

		local nvidia_ai_agent = shared_state.nvidia_ai_agent

		nvidia_ai_agent:update(dt, t)
		Profiler.stop("nvidia_ai_agent_manager_update")
	end

	Profiler.start("breed_unit_tester_update")
	Profiler.stop("breed_unit_tester_update")
end

GameplayStateRun.post_update = function (self, main_dt, main_t)
	local shared_state = self._shared_state
	local physics_world = shared_state.physics_world
	local is_server = shared_state.is_server

	if self._gameplay_timer_registered then
		Profiler.start("extension_manager_post_update")
		Managers.state.extension:post_update()
		Profiler.stop("extension_manager_post_update")
	end

	Profiler.start("player_manager_state_post_update")
	Managers.player:state_post_update(main_dt, main_t)
	Profiler.stop("player_manager_state_post_update")
	Managers.state.unit_spawner:set_deletion_state(DELETION_STATES.default)

	if self._fixed_frame_parsed or not self._gameplay_timer_registered then
		Profiler.start("network_transmit_function")
		shared_state.network_transmit_function()
		Profiler.stop("network_transmit_function")
	end

	Profiler.start("unit_spawner_commit_and_remove_pending_units")
	Managers.state.unit_spawner:commit_and_remove_pending_units()
	Profiler.stop("unit_spawner_commit_and_remove_pending_units")
	Profiler.start("physics_world_run_queries")
	PhysicsWorld.run_queries(physics_world)
	Profiler.stop("physics_world_run_queries")

	if not is_server then
		Profiler.start("clock_handler_client_manager_post_update")
		shared_state.clock_handler_client:post_update(main_dt)
		Profiler.stop("clock_handler_client_manager_post_update")
	end

	Profiler.start("position_lookup_manager_post_update")
	Managers.state.position_lookup:post_update()
	Profiler.stop("position_lookup_manager_post_update")
end

GameplayStateRun.render = function (self)
	Profiler.start("player_manager_state_render")
	Managers.player:state_render(Managers.time:delta_time("main"), Managers.time:time("main"))
	Profiler.stop("player_manager_state_render")
end

GameplayStateRun.on_reload = function (self, refreshed_resources)
	Profiler.start("extension_on_reload")
	Managers.state.extension:on_reload(refreshed_resources)
	Profiler.stop("extension_on_reload")
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

GameplayStateRun._music_notify_shutdown = function (self, is_dedicated_server)
	if not is_dedicated_server then
		Managers.wwise_game_sync:on_gameplay_shutdown()
	end
end

GameplayStateRun._mission_server_notify_shutdown = function (self, is_dedicated_mission_server)
	if is_dedicated_mission_server then
		local end_conditions_met, outcome = Managers.state.game_mode:has_met_end_conditions()
		local mission_result = end_conditions_met and outcome or "incomplete"

		Managers.mission_server:on_gameplay_shutdown(mission_result)
	end
end

GameplayStateRun._player_notify_shutdown = function (self, gameplay_state)
	Managers.player:unset_network()
	Managers.player:on_game_state_exit(gameplay_state)
end

GameplayStateRun._unregister_network_events = function (self, is_server)
	local connection_manager = Managers.connection
	local network_event_delegate = connection_manager:network_event_delegate()

	if is_server then
		network_event_delegate:unregister_events(unpack(SERVER_RPCS))
	else
		network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

GameplayStateRun._destroy_nvidia_ai_agent = function (self, is_dedicated_server, out_shared_state)
	if GameParameters.nvidia_ai_agent and not is_dedicated_server then
		out_shared_state.nvidia_ai_agent:destroy()

		out_shared_state.nvidia_ai_agent = nil
	end
end

GameplayStateRun._despawn_units = function (self, is_server, world, level, themes)
	local extension_manager = Managers.state.extension
	local unit_spawner_manager = Managers.state.unit_spawner

	Managers.state.blood:delete_units()
	Managers.state.minion_death:delete_units()
	Managers.state.decal:delete_units()

	if is_server then
		Managers.state.voice_over_spawn:delete_units()
		Managers.state.minion_spawn:delete_units()
		Managers.state.bot_nav_transition:clear_temp_transitions()
	end

	Managers.state.camera:delete_units()
	extension_manager:system("liquid_area_system"):delete_units()
	extension_manager:system("pickup_system"):delete_units()
	extension_manager:system("weapon_system"):delete_units()
	extension_manager:system("mission_objective_zone_system"):delete_units()
	Managers.state.unit_job:delete_units()

	local flow_spawned_units = extension_manager:units_by_category("flow_spawned")

	for unit, _ in pairs(flow_spawned_units) do
		unit_spawner_manager:mark_for_deletion(unit)
	end

	Managers.state.game_mode:cleanup_game_mode_units()

	local level_units = Level.units(level, true)
	local num_level_units = #level_units

	for i = 1, num_level_units do
		local unit = level_units[i]

		unit_spawner_manager:mark_for_deletion(unit)
	end

	unit_spawner_manager:commit_and_remove_pending_units()

	local World_destroy_theme = World.destroy_theme

	for i = 1, #themes do
		World_destroy_theme(world, themes[i])
	end

	World.destroy_level(world, level)

	local remaining_units = World.units(world)
	local num_remaining_units = #remaining_units

	for i = 1, num_remaining_units do
		local unit = remaining_units[i]

		_error("Unregistering orphaned unit %s.", unit)
	end

	extension_manager:unregister_units(remaining_units, num_remaining_units)
	unit_spawner_manager:commit_and_remove_pending_units()

	local remaining_base_units = World.units(world)
	local num_remaining_base_units = #remaining_base_units

	for i = 1, num_remaining_base_units do
		local unit = remaining_base_units[i]

		unit_spawner_manager:mark_for_deletion(unit)
	end

	unit_spawner_manager:commit_and_remove_pending_units()
end

GameplayStateRun._destroy_nav_world = function (self, out_shared_state)
	local nav_world = out_shared_state.nav_world

	GwNavWorld.destroy(nav_world)

	out_shared_state.nav_data = nil
	out_shared_state.nav_world = nil
end

GameplayStateRun._unregister_timer = function (self, is_server, out_shared_state)
	if is_server then
		Managers.time:unregister_timer("gameplay")
	else
		out_shared_state.clock_handler_client:delete()

		out_shared_state.clock_handler_client = nil
	end
end

GameplayStateRun._deinit_frame_rate = function (self)
	Managers.frame_rate:relinquish_request("gameplay")
end

local RAGDOLL_POSITION_NODE_NAME = "j_hips"

GameplayStateRun._update_out_of_bounds = function (self)
	local shared_state = self._shared_state
	local hard_cap_out_of_bounds_units = shared_state.hard_cap_out_of_bounds_units
	local soft_cap_out_of_bounds_units = shared_state.soft_cap_out_of_bounds_units
	local world = shared_state.world

	table.clear(soft_cap_out_of_bounds_units)
	table.clear(hard_cap_out_of_bounds_units)

	local num_hard_cap_units, _ = World.update_out_of_bounds_checker(world, hard_cap_out_of_bounds_units, soft_cap_out_of_bounds_units)
	local local_hard_cap_out_of_bounds_units = self._local_hard_cap_out_of_bounds_units

	for unit, _ in pairs(local_hard_cap_out_of_bounds_units) do
		if hard_cap_out_of_bounds_units[unit] == nil then
			local_hard_cap_out_of_bounds_units[unit] = nil
		end
	end

	if num_hard_cap_units <= 0 then
		return
	end

	local trigger_out_of_bounds_error = false
	local unit_spawner_manager = Managers.state.unit_spawner

	for unit, _ in pairs(hard_cap_out_of_bounds_units) do
		local game_object_id_or_nil = unit_spawner_manager:game_object_id(unit)

		if game_object_id_or_nil or local_hard_cap_out_of_bounds_units[unit] then
			trigger_out_of_bounds_error = true

			break
		else
			local_hard_cap_out_of_bounds_units[unit] = true
		end
	end

	if trigger_out_of_bounds_error then
		local units_text = ""

		for unit, _ in pairs(hard_cap_out_of_bounds_units) do
			local position = Unit.local_position(unit, 1)
			local ragdoll_position_text = ""

			if Unit.has_node(unit, RAGDOLL_POSITION_NODE_NAME) then
				local ragdoll_position_node_index = Unit.node(unit, RAGDOLL_POSITION_NODE_NAME)
				local ragdoll_position = Unit.world_position(unit, ragdoll_position_node_index)
				ragdoll_position_text = string.format(" : %s = %s", RAGDOLL_POSITION_NODE_NAME, tostring(ragdoll_position))
			end

			local is_owned_by_death_manager = false
			local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

			if unit_data_extension and unit_data_extension:is_owned_by_death_manager() then
				is_owned_by_death_manager = true
			end

			units_text = string.format("%s\n\t%s (%s%s) is_owned_by_death_manager: %s", units_text, tostring(unit), tostring(position), ragdoll_position_text, tostring(is_owned_by_death_manager))
		end

		ferror("[StateGameplay] Following units were out-of-bounds: %s\n", units_text)
	end
end

GameplayStateRun._handle_world_fullscreen_blur = function (self)
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

GameplayStateRun._handle_world_enabled_state = function (self)
	local ui_manager = Managers.ui

	if ui_manager then
		local disable_game_world = ui_manager:disable_game_world()

		if disable_game_world ~= self._game_world_disabled then
			local world_name = self._world_name
			local viewport_name = self._viewport_name
			self._game_world_disabled = disable_game_world

			if disable_game_world then
				WorldRenderUtils.deactivate_world(world_name, viewport_name)
			else
				WorldRenderUtils.activate_world(world_name, viewport_name)
			end
		end
	end
end

GameplayStateRun._fixed_update = function (self, extension_manager, player_manager, player_unit_spawn_manager, t)
	local shared_state = self._shared_state
	local fixed_frame_time = shared_state.fixed_frame_time
	local last_frame = math.floor(t / fixed_frame_time)
	local fixed_dt = fixed_frame_time
	local keep_in_scope = true

	for frame = self._fixed_frame_counter + 1, last_frame do
		Profiler.start("internal_fixed_update", keep_in_scope)

		local fixed_t = fixed_dt * frame

		player_manager:state_fixed_update(fixed_dt, fixed_t, frame)
		player_unit_spawn_manager:fixed_update(fixed_dt, fixed_t, frame)
		extension_manager:fixed_update(fixed_dt, fixed_t, frame)

		self._fixed_frame_parsed = true

		Profiler.stop("internal_fixed_update", not keep_in_scope)
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
		local fixed_frame_time = shared_state.fixed_frame_time
		local last_frame = math.floor(time / fixed_frame_time)

		shared_state.clock_handler_client:rpc_sync_clock(time + Managers.time:delta_time("main"), offset, last_frame)

		self._fixed_frame_counter = last_frame
		local world = shared_state.world

		Managers.world:set_scene_update_callback(world, function ()
			Profiler.start("Scene update Callback")
			Managers.state.extension:physics_async_update()
			Profiler.stop("Scene update Callback")
		end)
	end
end

implements(GameplayStateRun, GameplayStateInterface)

return GameplayStateRun
