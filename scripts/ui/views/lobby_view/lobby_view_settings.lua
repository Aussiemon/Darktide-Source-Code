-- chunkname: @scripts/ui/views/lobby_view/lobby_view_settings.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local lobby_view_settings = {
	field_of_view = 40,
	raycast_delay_duration = 0.15,
	viewport_type = "default",
	world_layer = 2,
	list_button_spacing = 10,
	character_spacing_width = 1.1,
	character_name_y_offset_no_title = 115,
	back_row_additional_spacing_depth = 0.8,
	max_player_slots = 4,
	timer_name = "ui",
	tooltip_fade_delay = 0.3,
	debug_character_count = 4,
	tooltip_fade_speed = 7,
	back_row_additional_spacing_width = 0.05,
	character_archetype_title_y_offset_no_title = 140,
	delay_ready_exit = 3,
	viewport_name = "ui_lobby_view_world_viewport",
	viewport_layer = 1,
	character_name_y_offset = 105,
	character_archetype_title_y_offset = 152,
	world_name = "ui_lobby_view_world",
	grid_size = {
		ButtonPassTemplates.ready_button.size[1],
		400
	},
	grid_spacing = {
		0,
		0
	},
	panel_size = {
		350,
		200
	},
	loading_size = {
		80,
		80
	},
	inspect_button_size = {
		250,
		64
	},
	loadout_size = {
		270,
		200
	},
	levels_by_id = {
		default = {
			shading_environment = "content/shading_environments/ui/lobby",
			level_name = "content/levels/ui/lobby/lobby"
		},
		havoc = {
			shading_environment = "content/shading_environments/ui/lobby",
			level_name = "content/levels/ui/havoc_lobby/havoc_lobby"
		},
		horde = {
			shading_environment = "content/shading_environments/ui/lobby",
			level_name = "content/levels/ui/horde_lobby/horde_lobby"
		}
	},
	ignored_slots = {
		"slot_pocketable",
		"slot_pocketable_small",
		"slot_luggable",
		"slot_support_ability",
		"slot_combat_ability",
		"slot_grenade_ability"
	},
	animations_per_archetype = {
		psyker = {
			initial_event = "lobby_wait_psyker_01",
			events = {
				"to_ready"
			}
		},
		veteran = {
			initial_event = "lobby_wait_veteran_01",
			events = {
				"to_ready"
			}
		},
		zealot = {
			initial_event = "lobby_wait_zealot_01",
			events = {
				"to_ready"
			}
		},
		ogryn = {
			initial_event = "lobby_wait_ogryn_01",
			events = {
				"to_ready"
			}
		}
	}
}

return settings("LobbyViewSettings", lobby_view_settings)
