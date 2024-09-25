-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_bone_lod.lua

local BoneLodManager = require("scripts/managers/bone_lod/bone_lod_manager")
local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepNavigation = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_navigation")
local GameplayInitStepBoneLod = class("GameplayInitStepBoneLod")

GameplayInitStepBoneLod.on_enter = function (self, parent, params)
	local shared_state = params.shared_state

	self._shared_state = shared_state

	local world = shared_state.world
	local is_server = shared_state.is_server

	Managers.state.bone_lod = BoneLodManager:new(world, DEDICATED_SERVER, is_server)
end

GameplayInitStepBoneLod.update = function (self, main_dt, main_t)
	self._shared_state.initialized_steps.GameplayInitStepBoneLod = true

	local next_step_params = {
		shared_state = self._shared_state,
	}

	return GameplayInitStepNavigation, next_step_params
end

implements(GameplayInitStepBoneLod, GameplayInitStepInterface)

return GameplayInitStepBoneLod
