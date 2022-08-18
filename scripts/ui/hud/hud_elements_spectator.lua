local elements = {
	{
		use_hud_scale = true,
		offscreen_target = "monitor_effect",
		package = "packages/ui/hud/team_player_panel/team_player_panel",
		use_retained_mode = true,
		class_name = "HudElementTeamPanelHandler",
		filename = "scripts/ui/hud/elements/team_panel_handler/hud_element_team_panel_handler",
		visibility_groups = {
			"dead",
			"alive"
		},
		customizable_scenegraph_id = {
			"local_player",
			"player_1",
			"player_2",
			"player_3"
		},
		offscreen_target_draw_functions = {
			default = "visir_effect_draw"
		}
	},
	{
		package = "packages/ui/hud/damage_indicator/damage_indicator",
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementDamageIndicator",
		filename = "scripts/ui/hud/elements/damage_indicator/hud_element_damage_indicator",
		visibility_groups = {
			"alive"
		}
	},
	{
		package = "packages/ui/hud/boss_health/boss_health",
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementBossHealth",
		filename = "scripts/ui/hud/elements/boss_health/hud_element_boss_health",
		visibility_groups = {
			"dead",
			"alive"
		}
	},
	{
		package = "packages/ui/hud/blocking/blocking",
		customizable_scenegraph_id = "area",
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementBlocking",
		filename = "scripts/ui/hud/elements/blocking/hud_element_blocking",
		visibility_groups = {
			"alive"
		}
	},
	{
		package = "packages/ui/hud/crosshair/crosshair",
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementCrosshair",
		filename = "scripts/ui/hud/elements/crosshair/hud_element_crosshair",
		visibility_groups = {
			"alive"
		}
	},
	{
		package = "packages/ui/hud/world_markers/world_markers",
		offscreen_target = "monitor_effect",
		use_hud_scale = false,
		class_name = "HudElementWorldMarkers",
		filename = "scripts/ui/hud/elements/world_markers/hud_element_world_markers",
		visibility_groups = {
			"alive"
		}
	},
	{
		package = "packages/ui/hud/mission_objective_feed/mission_objective_feed",
		customizable_scenegraph_id = "area",
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementMissionObjectiveFeed",
		filename = "scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed",
		visibility_groups = {
			"dead",
			"alive"
		}
	},
	{
		package = "packages/ui/hud/mission_speaker_popup/mission_speaker_popup",
		customizable_scenegraph_id = "background",
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementMissionSpeakerPopup",
		filename = "scripts/ui/hud/elements/mission_speaker_popup/hud_element_mission_speaker_popup",
		visibility_groups = {
			"dead",
			"alive",
			"cutscene"
		}
	},
	{
		package = "packages/ui/hud/interaction/interaction",
		offscreen_target = "monitor_effect",
		class_name = "HudElementInteraction",
		filename = "scripts/ui/hud/elements/interaction/hud_element_interaction",
		visibility_groups = {
			"alive"
		}
	},
	{
		offscreen_target = "monitor_effect",
		class_name = "HudElementSuppressionIndicators",
		filename = "scripts/ui/hud/elements/suppression/hud_element_suppression_indicators",
		visibility_groups = {
			"alive"
		}
	},
	{
		offscreen_target = "monitor_effect",
		class_name = "HudElementNameplates",
		filename = "scripts/ui/hud/elements/nameplates/hud_element_nameplates",
		visibility_groups = {
			"alive"
		}
	},
	{
		class_name = "HudElementSpectatorText",
		filename = "scripts/ui/hud/elements/spectator/hud_element_spectator_text",
		visibility_groups = {
			"dead",
			"alive"
		}
	},
	{
		package = "packages/ui/hud/overcharge/overcharge",
		use_retained_mode = true,
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementOvercharge",
		filename = "scripts/ui/hud/elements/overcharge/hud_element_overcharge",
		visibility_groups = {
			"dead",
			"alive"
		},
		customizable_scenegraph_id = {
			"overcharge",
			"overheat"
		}
	},
	{
		offscreen_target = "monitor_effect",
		class_name = "HudElementCutsceneOverlay",
		filename = "scripts/ui/hud/elements/cutscene_overlay/hud_element_cutscene_overlay",
		visibility_groups = {
			"prologue_cutscene",
			"cutscene"
		}
	},
	{
		offscreen_target = "monitor_effect",
		class_name = "HudElementCutsceneFading",
		filename = "scripts/ui/hud/elements/cutscene_overlay/hud_element_cutscene_overlay",
		visibility_groups = {
			"popup",
			"prologue_cutscene",
			"cutscene",
			"in_view",
			"tactical_overlay",
			"communication_wheel",
			"testify",
			"dead",
			"alive"
		}
	}
}

return elements
