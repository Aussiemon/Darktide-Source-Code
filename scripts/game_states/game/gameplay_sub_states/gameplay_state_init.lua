-- chunkname: @scripts/game_states/game/gameplay_sub_states/gameplay_state_init.lua

local GameplayInitStepFrameRate = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_frame_rate")
local GameplayStateInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_state_interface")
local GameplayStateRun = require("scripts/game_states/game/gameplay_sub_states/gameplay_state_run")
local GameStateMachine = require("scripts/foundation/utilities/game_state_machine")
local MissionCleanupUtilies = require("scripts/game_states/game/gameplay_sub_states/utilities/mission_cleanup_utilities")
local PositionLookupManager = require("scripts/managers/position_lookup/position_lookup_manager")
local GameplayStateInit = class("GameplayStateInit")

GameplayStateInit.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	local start_params = {
		shared_state = shared_state,
	}
	local state_machine = GameStateMachine:new(self, GameplayInitStepFrameRate, start_params, nil, nil, "GamePlayInit")

	self._gameplay_state = parent
	self._state_machine = state_machine
	self._shared_state = shared_state
	self._loading_view_opened = false
	self._view_name = nil
	Managers.state.position_lookup = PositionLookupManager:new()
end

GameplayStateInit.on_exit = function (self, on_shutdown)
	local initialized_steps = self._shared_state.initialized_steps

	if not initialized_steps.GameplayInitStepStateLast then
		Log.exception("MissionCleanupUtilies", "Exit in the middle of initialization.")
		table.dump(initialized_steps)
	end

	local shared_state = self._shared_state
	local world = shared_state.world
	local is_server = shared_state.is_server

	if on_shutdown then
		MissionCleanupUtilies.cleanup(shared_state, self._gameplay_state, initialized_steps)
	end

	self:_setup_scene_update_callback(world, is_server)
	self._state_machine:delete()
end

GameplayStateInit.update = function (self, main_dt, main_t)
	local shared_state = self._shared_state

	shared_state.network_receive_function(main_dt)
	Managers.state.position_lookup:pre_update()
	self._state_machine:update(main_dt, main_t)

	if self._state_machine:current_state_name() ~= "GameplayInitStepStateLast" then
		return nil, nil
	end

	local state_run_params = {
		shared_state = shared_state,
	}

	return GameplayStateRun, state_run_params
end

GameplayStateInit.post_update = function (self, main_dt, main_t)
	Managers.state.position_lookup:post_update()

	local shared_state = self._shared_state

	shared_state.network_transmit_function()
end

GameplayStateInit.render = function (self)
	return
end

GameplayStateInit.on_reload = function (self, refreshed_resources)
	return
end

GameplayStateInit._setup_scene_update_callback = function (self, world, is_server)
	if is_server then
		Managers.world:set_scene_update_callback(world, function ()
			Managers.state.extension:physics_async_update()
		end)
	end
end

GameplayStateInit.gameplay_state = function (self)
	return self._gameplay_state
end

implements(GameplayStateInit, GameplayStateInterface)

return GameplayStateInit
