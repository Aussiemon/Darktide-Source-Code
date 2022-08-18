local GameModeManager = require("scripts/managers/game_mode/game_mode_manager")
local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepMission = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_mission")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local GameplayInitStepGameMode = class("GameplayInitStepGameMode")

GameplayInitStepGameMode.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	self._shared_state = shared_state
	local mission_name = shared_state.mission_name
	local world = shared_state.world
	local physics_world = shared_state.physics_world
	local is_server = shared_state.is_server
	local connection_manager = Managers.connection
	local network_event_delegate = connection_manager:network_event_delegate()

	self:_init_game_mode(mission_name, world, physics_world, is_server, network_event_delegate)
end

GameplayInitStepGameMode.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepMission, next_step_params
end

GameplayInitStepGameMode._init_game_mode = function (self, mission_name, world, physics_world, is_server, network_event_delegate)
	local mission = MissionTemplates[mission_name]
	local game_mode_name = mission.game_mode_name
	local gameplay_modifiers = mission.gameplay_modifiers
	local game_mode_context = {
		world = world,
		physics_world = physics_world,
		is_server = is_server
	}
	local game_mode_manager = GameModeManager:new(game_mode_context, game_mode_name, gameplay_modifiers, network_event_delegate)
	Managers.state.game_mode = game_mode_manager
end

implements(GameplayInitStepGameMode, GameplayInitStepInterface)

return GameplayInitStepGameMode
