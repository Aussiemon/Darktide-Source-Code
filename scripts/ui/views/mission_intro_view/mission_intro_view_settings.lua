﻿-- chunkname: @scripts/ui/views/mission_intro_view/mission_intro_view_settings.lua

local mission_intro_view_settings = {
	field_of_view = 40,
	level_name = "content/levels/ui/mission_intro/mission_intro",
	shading_environment = "content/shading_environments/ui/mission_intro",
	timer_name = "ui",
	viewport_layer = 1,
	viewport_name = "ui_mission_intro_world_viewport",
	viewport_type = "default",
	world_layer = 2,
	world_name = "ui_mission_intro_world",
	world_custom_flags = {
		Application.ENABLE_VOLUMETRICS,
		Application.ENABLE_RAY_TRACING,
	},
	prioritized_ogryn_slots = {
		3,
		4,
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
	},
	animations_per_archetype = {
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
	},
}

return settings("MissionIntroViewSettings", mission_intro_view_settings)
