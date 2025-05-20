-- chunkname: @scripts/game_states/game/gameplay_sub_states/utilities/mission_cleanup_utilities.lua

local GameplayRpcs = require("scripts/game_states/game/utilities/gameplay_rpcs")
local SERVER_RPCS = GameplayRpcs.COMMON_SERVER_RPCS
local CLIENT_RPCS = GameplayRpcs.COMMON_CLIENT_RPCS

local function _error(...)
	Log.error("MissionCleanupUtilies", ...)
end

local MissionCleanupUtilies = {}

MissionCleanupUtilies.cleanup = function (shared_state, gameplay_state, initialized_steps)
	if Managers.account:leaving_game() then
		local ui_manager = Managers.ui
		local active_views = ui_manager:active_views()
		local force_close = true

		while not table.is_empty(active_views) do
			local view_name = active_views[1]

			ui_manager:close_view(view_name, force_close)
		end
	end

	REPORTIFY_NETWORK_READY = false

	local physics_world = shared_state.physics_world

	if physics_world then
		PhysicsWorld.fetch_queries(physics_world)
	end

	local is_server = shared_state.is_server
	local is_dedicated_server = shared_state.is_dedicated_server
	local world = rawget(shared_state, "world")

	Network.set_max_transmit_rate(GameParameters.default_transmit_rate)

	if not is_dedicated_server then
		Managers.wwise_game_sync:on_gameplay_shutdown()
	end

	Managers.player:unset_network()
	Managers.player:on_game_state_exit(gameplay_state)
	MissionCleanupUtilies._unregister_network_events(is_server, shared_state)
	MissionCleanupUtilies._destroy_nvidia_ai_agent(is_dedicated_server, shared_state)

	if Managers.state.game_session then
		Managers.state.game_session:disconnect()
	end

	if Managers.state.cinematic then
		Managers.state.cinematic:stop_all_stories()
	end

	if Managers.state.game_mode then
		Managers.state.game_mode:cleanup_game_mode_dynamic_lavels()
	end

	if world then
		local level = shared_state.level
		local themes = shared_state.themes

		MissionCleanupUtilies._despawn_units(is_server, world, level, themes)
	end

	if Managers.state.mission then
		local mission_name = Managers.state.mission:mission_name()

		Managers.player:set_last_mission(mission_name)
	end

	Managers.state:destroy()
	Crashify.print_property("in_havoc_mission", "")

	if world then
		local world_name = shared_state.world_name
		local level = shared_state.level
		local level_name = shared_state.level_name
		local themes = shared_state.themes

		Managers.world_level_despawn:despawn(world, world_name, level, level_name, themes)
	end

	MissionCleanupUtilies._destroy_nav_world(shared_state)
	MissionCleanupUtilies._unregister_timer(is_server, shared_state)
	Managers.frame_rate:relinquish_request("gameplay")
end

MissionCleanupUtilies._unregister_network_events = function (is_server, shared_state)
	if not shared_state.session_rpcs_registered then
		return
	end

	local connection_manager = Managers.connection
	local network_event_delegate = connection_manager:network_event_delegate()

	if is_server then
		network_event_delegate:unregister_events(unpack(SERVER_RPCS))
	else
		network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

MissionCleanupUtilies._destroy_nvidia_ai_agent = function (is_dedicated_server, shared_state)
	if GameParameters.nvidia_ai_agent and not is_dedicated_server and shared_state.nvidia_ai_agent then
		shared_state.nvidia_ai_agent:destroy()

		shared_state.nvidia_ai_agent = nil
	end
end

MissionCleanupUtilies._despawn_units = function (is_server, world, level, themes)
	local extension_manager = Managers.state.extension
	local unit_spawner_manager = Managers.state.unit_spawner

	if Managers.state.blood then
		Managers.state.blood:delete_units()
	end

	if Managers.state.minion_death then
		Managers.state.minion_death:delete_units()
	end

	if is_server then
		if Managers.state.voice_over_spawn then
			Managers.state.voice_over_spawn:delete_units()
		end

		if Managers.state.minion_spawn then
			Managers.state.minion_spawn:delete_units()
		end

		if Managers.state.bot_nav_transition then
			Managers.state.bot_nav_transition:clear_temp_transitions()
		end
	end

	if Managers.state.decal then
		Managers.state.decal:delete_units()
	end

	if Managers.state.camera then
		Managers.state.camera:delete_units()
	end

	if extension_manager then
		if extension_manager:has_system("liquid_area_system") then
			extension_manager:system("liquid_area_system"):delete_units()
		end

		if extension_manager:has_system("pickup_system") then
			extension_manager:system("pickup_system"):delete_units()
		end

		if extension_manager:has_system("weapon_system") then
			extension_manager:system("weapon_system"):delete_units()
		end

		if extension_manager:has_system("mission_objective_zone_system") then
			extension_manager:system("mission_objective_zone_system"):delete_units()
		end

		if extension_manager:has_system("fx_system") then
			extension_manager:system("fx_system"):delete_units()
		end
	end

	if Managers.state.unit_job then
		Managers.state.unit_job:delete_units()
	end

	if extension_manager and unit_spawner_manager then
		local flow_spawned_units = extension_manager:units_by_category("flow_spawned")

		for unit, _ in pairs(flow_spawned_units) do
			unit_spawner_manager:mark_for_deletion(unit)
		end
	end

	if Managers.state.game_mode then
		Managers.state.game_mode:cleanup_game_mode_units()
	end

	if extension_manager then
		local level_units = extension_manager:registered_level_units()
		local num_level_units = #level_units

		extension_manager:unregister_units(level_units, num_level_units)
	end

	if unit_spawner_manager then
		unit_spawner_manager:commit_and_remove_pending_units()
	end

	if extension_manager then
		local orphaned_units = extension_manager:units()

		for unit, _ in pairs(orphaned_units) do
			_error("Unregistering orphaned unit %s.", unit)
			extension_manager:unregister_unit(unit)
		end
	end

	if unit_spawner_manager then
		unit_spawner_manager:commit_and_remove_pending_units()
	end
end

MissionCleanupUtilies._destroy_nav_world = function (shared_state)
	local nav_data = shared_state.nav_data

	if nav_data then
		for i = #nav_data, 1, -1 do
			local data = nav_data[i]

			GwNavWorld.remove_navdata(data)
		end

		shared_state.nav_data = nil
	end

	local nav_world = shared_state.nav_world

	if nav_world then
		GwNavWorld.destroy(nav_world)

		shared_state.nav_world = nil
	end
end

MissionCleanupUtilies._unregister_timer = function (is_server, shared_state)
	if not shared_state.gameplay_timer_registered then
		return
	end

	if is_server then
		Managers.time:unregister_timer("gameplay")
	else
		shared_state.clock_handler_client:delete()

		shared_state.clock_handler_client = nil
	end
end

return MissionCleanupUtilies
