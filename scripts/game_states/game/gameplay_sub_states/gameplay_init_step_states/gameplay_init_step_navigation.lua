local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepExtensions = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_extensions")
local MainPathManager = require("scripts/managers/main_path/main_path_manager")
local NavMeshManager = require("scripts/managers/nav_mesh/nav_mesh_manager")
local GameplayInitStepNavigation = class("GameplayInitStepNavigation")

GameplayInitStepNavigation.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	self._shared_state = shared_state
	local world = shared_state.world
	local nav_world = shared_state.nav_world
	local is_server = shared_state.is_server
	local level_name = shared_state.level_name
	local level_seed = shared_state.level_seed
	local connection_manager = Managers.connection
	local network_event_delegate = connection_manager:network_event_delegate()

	self:_init_navigation(world, nav_world, is_server, level_name, level_seed, network_event_delegate)
end

GameplayInitStepNavigation.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepExtensions, next_step_params
end

GameplayInitStepNavigation._init_navigation = function (self, world, nav_world, is_server, level_name, level_seed, network_event_delegate)
	local game_mode_manager = Managers.state.game_mode
	local side_compositions = game_mode_manager:side_compositions()
	local num_sides = #side_compositions
	Managers.state.nav_mesh = NavMeshManager:new(world, nav_world, is_server, network_event_delegate, level_name)
	local use_nav_point_time_slice = true
	Managers.state.main_path = MainPathManager:new(world, nav_world, level_name, level_seed, num_sides, is_server, use_nav_point_time_slice)
end

implements(GameplayInitStepNavigation, GameplayInitStepInterface)

return GameplayInitStepNavigation
