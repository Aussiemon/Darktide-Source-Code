-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_extensions.lua

local ExtensionManager = require("scripts/foundation/managers/extension/extension_manager")
local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepManagers = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_managers")
local LevelPropsBroadphaseManager = require("scripts/managers/level_props_broadphase/level_props_broadphase_manager")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local GameplayInitStepExtensions = class("GameplayInitStepExtensions")

GameplayInitStepExtensions.init = function (self)
	self._skipped_first_update = false
end

GameplayInitStepExtensions.on_enter = function (self, parent, params)
	local shared_state = params.shared_state

	self._shared_state = shared_state

	local world = shared_state.world
	local physics_world = shared_state.physics_world
	local is_server = shared_state.is_server
	local mission_name = shared_state.mission_name
	local level_name = shared_state.level_name
	local level_seed = shared_state.level_seed
	local circumstance_name = shared_state.circumstance_name
	local nav_world = shared_state.nav_world
	local has_navmesh = not table.is_empty(shared_state.nav_data)
	local soft_cap_out_of_bounds_units = shared_state.soft_cap_out_of_bounds_units
	local vo_sources_cache = shared_state.vo_sources_cache
	local fixed_time_step = shared_state.fixed_time_step
	local connection_manager = Managers.connection
	local network_event_delegate = connection_manager:network_event_delegate()

	self:_init_extensions(world, physics_world, is_server, mission_name, level_name, level_seed, circumstance_name, nav_world, has_navmesh, soft_cap_out_of_bounds_units, vo_sources_cache, fixed_time_step, network_event_delegate)
end

GameplayInitStepExtensions.update = function (self, main_dt, main_t)
	if not self._skipped_first_update then
		self._skipped_first_update = true

		return nil, nil
	end

	local extension_manager = Managers.state.extension
	local is_initialized = extension_manager:update_time_slice_init()

	if not is_initialized then
		return nil, nil
	end

	self._shared_state.initialized_steps.GameplayInitStepExtensions = true

	local next_step_params = {
		shared_state = self._shared_state,
	}

	return GameplayInitStepManagers, next_step_params
end

GameplayInitStepExtensions._init_extensions = function (self, world, physics_world, is_server, mission_name, level_name, level_seed, circumstance_name, nav_world, has_navmesh, soft_cap_out_of_bounds_units, vo_sources_cache, fixed_time_step, network_event_delegate)
	local wwise_world = Managers.world:wwise_world(world)
	local game_session_manager = Managers.state.game_session
	local game_session = game_session_manager:game_session()
	local game_mode_manager = Managers.state.game_mode
	local default_player_side_name = game_mode_manager:default_player_side_name()
	local side_compositions = game_mode_manager:side_compositions()
	local num_sides = #side_compositions
	local side_names = Script.new_array(num_sides)

	for i = 1, num_sides do
		local side_data = side_compositions[i]

		side_names[i] = side_data.name
	end

	local mission = MissionTemplates[mission_name]
	local system_init_data = {
		broadphase_system = {
			side_names = side_names,
		},
		cinematic_scene_system = {
			mission = mission,
		},
		critter_spawner_system = {
			level_seed = level_seed,
		},
		cutscene_character_system = {
			level_seed = level_seed,
		},
		darkness_system = {
			mission = mission,
		},
		dialogue_context_system = {
			mission = mission,
		},
		dialogue_system = {
			is_rule_db_enabled = true,
			mission = mission,
			vo_sources_cache = vo_sources_cache,
		},
		hazard_prop_system = {
			mission = mission,
			level_seed = level_seed,
		},
		health_station_system = {
			mission = mission,
		},
		light_controller_system = {
			themes = self._shared_state.themes,
		},
		mission_objective_system = {
			mission = mission,
		},
		mission_objective_zone_system = {
			level_seed = level_seed,
		},
		pickup_system = {
			mission = mission,
			level_seed = level_seed,
		},
		side_system = {
			side_compositions = side_compositions,
			default_player_side_name = default_player_side_name,
		},
		spline_follower_system = {
			level_seed = level_seed,
		},
		minigame_system = {
			mission = mission,
			level_seed = level_seed,
		},
		component_system = {
			level_seed = level_seed,
		},
	}

	Managers.state.level_props_broadphase = LevelPropsBroadphaseManager:new()

	local unit_categories = {
		"flow_spawned",
		"level_spawned",
		"cinematic",
	}
	local UnitTemplates = require("scripts/extension_systems/unit_templates")
	local ExtensionSystemConfiguration = require("scripts/extension_systems/extension_system_configuration")
	local use_time_slice = true

	Managers.state.extension = ExtensionManager:new(world, physics_world, wwise_world, nav_world, has_navmesh, level_name, circumstance_name, is_server, UnitTemplates, ExtensionSystemConfiguration, system_init_data, unit_categories, network_event_delegate, fixed_time_step, game_session, soft_cap_out_of_bounds_units, use_time_slice)
end

implements(GameplayInitStepExtensions, GameplayInitStepInterface)

return GameplayInitStepExtensions
