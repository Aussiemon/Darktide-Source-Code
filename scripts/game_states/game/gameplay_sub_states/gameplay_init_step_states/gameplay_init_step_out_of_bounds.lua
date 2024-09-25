-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_out_of_bounds.lua

local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepNavWorld = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_nav_world")
local OutOfBoundsManager = require("scripts/managers/out_of_bounds/out_of_bounds_manager")
local GameplayInitStepOutOfBounds = class("GameplayInitStepOutOfBounds")

GameplayInitStepOutOfBounds.on_enter = function (self, parent, params)
	local shared_state = params.shared_state

	self._shared_state = shared_state

	local world = shared_state.world

	self:_init_out_of_bounds_checker(world, shared_state)
end

GameplayInitStepOutOfBounds.update = function (self, main_dt, main_t)
	self._shared_state.initialized_steps.GameplayInitStepOutOfBounds = true

	local next_step_params = {
		shared_state = self._shared_state,
	}

	return GameplayInitStepNavWorld, next_step_params
end

GameplayInitStepOutOfBounds._init_out_of_bounds_checker = function (self, world, out_shared_state)
	local min_position, max_position = NetworkConstants.min_position, NetworkConstants.max_position
	local network_position_extent = math.min((max_position - min_position) * 0.5, math.abs(min_position), max_position)
	local hard_cap_extents = Vector3(network_position_extent, network_position_extent, network_position_extent)
	local percentage_of_hard_cap = 0.9
	local soft_cap_extents = hard_cap_extents * percentage_of_hard_cap

	World.set_out_of_bounds_aabb(world, hard_cap_extents, soft_cap_extents)

	out_shared_state.hard_cap_out_of_bounds_units = Script.new_map(16)
	out_shared_state.soft_cap_out_of_bounds_units = Script.new_map(16)
	Managers.state.out_of_bounds = OutOfBoundsManager:new(world, hard_cap_extents, soft_cap_extents)
end

implements(GameplayInitStepOutOfBounds, GameplayInitStepInterface)

return GameplayInitStepOutOfBounds
