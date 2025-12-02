-- chunkname: @scripts/settings/mechanism/mechanism_settings.lua

local StateGameScore = require("scripts/game_states/game/state_game_score")
local StateMissionServerExit = require("scripts/game_states/game/state_mission_server_exit")
local mechanism_settings = {
	sandbox = {
		class_file_name = "scripts/managers/mechanism/mechanisms/mechanism_sandbox",
		class_name = "MechanismSandbox",
		states = {
			"init",
			"gameplay",
			"game_mode_ended",
		},
		player_package_synchronization_settings = {
			prioritization_template = "default",
		},
		loader_paths = {},
	},
	onboarding = {
		class_file_name = "scripts/managers/mechanism/mechanisms/mechanism_onboarding",
		class_name = "MechanismOnboarding",
		states = {
			"init",
			"gameplay",
			"game_mode_ended",
			"joining_hub_server",
			"joining_party_game_session",
			"client_exit_gameplay",
			"client_wait_for_server",
		},
		player_package_synchronization_settings = {
			prioritization_template = "default",
		},
		loader_paths = {},
	},
	hub = {
		class_file_name = "scripts/managers/mechanism/mechanisms/mechanism_hub",
		class_name = "MechanismHub",
		states = {
			"init",
			"request_hub_config",
			"init_hub",
			"in_hub",
			"joining_party_game_session",
			"client_exit_gameplay",
			"client_wait_for_server",
		},
		player_package_synchronization_settings = {
			prioritization_template = "hub",
		},
		loader_paths = {},
	},
	idle = {
		class_file_name = "scripts/managers/mechanism/mechanisms/mechanism_idle",
		class_name = "MechanismIdle",
		states = {
			"idle",
		},
		player_package_synchronization_settings = {
			prioritization_template = "default",
		},
		loader_paths = {},
	},
	adventure = {
		class_file_name = "scripts/managers/mechanism/mechanisms/mechanism_adventure",
		class_name = "MechanismAdventure",
		states = {
			"adventure_selected",
			"mission_server_exit",
			"client_exit_gameplay",
			"client_wait_for_server",
			"adventure",
			"score",
			"joining_party_game_session",
		},
		game_states = {
			score = StateGameScore,
			mission_server_exit = StateMissionServerExit,
		},
		player_package_synchronization_settings = {
			prioritization_template = "default",
			required_index = nil,
		},
		loader_paths = {},
	},
	left_session = {
		class_file_name = "scripts/managers/mechanism/mechanisms/mechanism_left_session",
		class_name = "MechanismLeftSession",
		states = {
			"init",
			"search_for_session",
			"wait_for_session",
		},
		player_package_synchronization_settings = {
			prioritization_template = "default",
			required_index = nil,
		},
		loader_paths = {},
	},
}

return settings("MechanismSettings", mechanism_settings)
