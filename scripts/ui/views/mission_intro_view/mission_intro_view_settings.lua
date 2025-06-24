-- chunkname: @scripts/ui/views/mission_intro_view/mission_intro_view_settings.lua

local mission_intro_view_settings = {
	field_of_view = 40,
	timer_name = "ui",
	viewport_layer = 1,
	viewport_name = "ui_mission_intro_world_viewport",
	viewport_type = "default",
	world_layer = 2,
	world_name = "ui_mission_intro_world",
	intro_levels_by_zone_id = {
		default = {
			level_name = "content/levels/ui/mission_intro/mission_intro",
			shading_environment = "content/shading_environments/ui/mission_intro",
		},
		horde = {
			level_name = "content/levels/ui/horde_mission_intro/horde_mission_intro",
			shading_environment = "content/shading_environments/ui/horde_mission_intro",
		},
	},
	world_custom_flags = {
		Application.ENABLE_VOLUMETRICS,
		Application.ENABLE_RAY_TRACING,
	},
	prioritized_ogryn_slots = {
		3,
		5,
		4,
		6,
	},
	ignored_slots = {
		"slot_primary",
		"slot_secondary",
		"slot_pocketable",
		"slot_pocketable_small",
		"slot_luggable",
		"slot_support_ability",
		"slot_combat_ability",
		"slot_grenade_ability",
		"slot_companion_gear_full",
		"slot_companion_body_skin_color",
		"slot_companion_body_fur_color",
		"slot_companion_body_coat_pattern",
	},
	animations_per_archetype = {
		adamant = {
			"mission_briefing_pose_02",
			"mission_briefing_pose_04",
			"mission_briefing_pose_05",
			"mission_briefing_pose_06",
			"mission_briefing_pose_07",
		},
		ogryn = {
			"mission_briefing_pose_01",
			"mission_briefing_pose_02",
			"mission_briefing_pose_03",
			"mission_briefing_pose_04",
			"mission_briefing_pose_05",
			"mission_briefing_pose_06",
			"mission_briefing_pose_07",
			"mission_briefing_pose_08",
		},
		psyker = {
			"mission_briefing_pose_02",
			"mission_briefing_pose_04",
			"mission_briefing_pose_05",
			"mission_briefing_pose_06",
			"mission_briefing_pose_07",
		},
		veteran = {
			"mission_briefing_pose_02",
			"mission_briefing_pose_04",
			"mission_briefing_pose_05",
			"mission_briefing_pose_06",
			"mission_briefing_pose_07",
		},
		zealot = {
			"mission_briefing_pose_02",
			"mission_briefing_pose_03",
			"mission_briefing_pose_04",
			"mission_briefing_pose_05",
			"mission_briefing_pose_06",
			"mission_briefing_pose_07",
		},
	},
	journey_briefing_lines = {
		player_journey_01 = {
			1,
			1,
			1,
		},
		player_journey_02 = {
			3,
			1,
			4,
		},
		player_journey_03 = {
			3,
			4,
			1,
		},
		player_journey_04 = {
			1,
			2,
			4,
		},
		player_journey_05 = {
			2,
			1,
			3,
		},
		player_journey_06_A = {
			1,
			1,
			2,
		},
		player_journey_07_A = {
			3,
			3,
			3,
		},
		player_journey_06_B = {
			1,
			1,
			1,
		},
		player_journey_07_B = {
			3,
			2,
			3,
		},
		player_journey_08 = {
			1,
			4,
			3,
		},
		player_journey_09 = {
			1,
			2,
			1,
		},
		player_journey_010 = {
			1,
			1,
			1,
		},
		player_journey_011_A = {
			2,
			2,
			2,
		},
		player_journey_012_A = {
			4,
			1,
			4,
		},
		player_journey_013_A = {
			4,
			2,
			1,
		},
		player_journey_011_B = {
			1,
			2,
			1,
			2,
		},
		player_journey_014 = {
			1,
			1,
			3,
		},
	},
}

return settings("MissionIntroViewSettings", mission_intro_view_settings)
