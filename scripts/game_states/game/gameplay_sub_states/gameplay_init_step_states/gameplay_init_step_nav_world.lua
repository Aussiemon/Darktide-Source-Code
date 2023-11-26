-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_nav_world.lua

local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepDebug = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_debug")
local Navigation = require("scripts/extension_systems/navigation/utilities/navigation")
local NavigationGameplaySettings = require("scripts/settings/navigation/navigation_gameplay_settings")
local GameplayInitStepNavWorld = class("GameplayInitStepNavWorld")

GameplayInitStepNavWorld.on_enter = function (self, parent, params)
	local shared_state = params.shared_state

	self._shared_state = shared_state

	local level_name = shared_state.level_name

	self:_init_nav_world(level_name, shared_state)
end

GameplayInitStepNavWorld.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepDebug, next_step_params
end

GameplayInitStepNavWorld._init_nav_world = function (self, level_name, out_shared_state)
	local nav_world = GwNavWorld.create(Matrix4x4.identity())
	local budget_config = NavigationGameplaySettings.nav_world_config.budget
	local pathfinder_world_update_budget = budget_config.pathfinder_world_update
	local pathfinder_outside_world_update_budget = budget_config.pathfinder_outside_world_update
	local pathfinder_working_memory = budget_config.pathfinder_working_memory

	GwNavWorld.set_pathfinder_budget(nav_world, pathfinder_world_update_budget)
	GwNavWorld.set_pathfinder_outside_world_update_budget(nav_world, pathfinder_outside_world_update_budget)
	GwNavWorld.set_pathfinder_working_memory_max_size(nav_world, pathfinder_working_memory)

	local crowd_dispersion_config = NavigationGameplaySettings.nav_world_config.crowd_dispersion
	local crowd_dispersion_min_distance = crowd_dispersion_config.min_check_distance
	local crowd_dispersion_max_distance = crowd_dispersion_config.max_check_distance

	GwNavWorld.enable_crowd_dispersion(nav_world, crowd_dispersion_min_distance, crowd_dispersion_max_distance)
	GwNavWorld.init_async_update(nav_world)
	GwNavWorld.enable_sparse_graph(nav_world)

	local nav_data = {}

	Navigation.add_nav_data(nav_world, nav_data, level_name)

	out_shared_state.nav_world = nav_world
	out_shared_state.nav_data = nav_data
end

implements(GameplayInitStepNavWorld, GameplayInitStepInterface)

return GameplayInitStepNavWorld
