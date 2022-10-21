local elements = {
	{
		offscreen_target = "monitor_effect",
		class_name = "HudElementCharacterNewsFeed",
		filename = "scripts/ui/hud/elements/character_news_feed/hud_element_character_news_feed",
		visibility_groups = {
			"in_hub_view",
			"alive",
			"communication_wheel"
		}
	},
	{
		use_hud_scale = true,
		offscreen_target = "monitor_effect",
		package = "packages/ui/hud/team_player_panel/team_player_panel",
		use_retained_mode = true,
		class_name = "HudElementTeamPanelHandler",
		filename = "scripts/ui/hud/elements/team_panel_handler/hud_element_team_panel_handler",
		visibility_groups = {
			"dead",
			"alive",
			"communication_wheel"
		},
		customizable_scenegraph_id = {
			"local_player",
			"player_1",
			"player_2",
			"player_3"
		},
		offscreen_target_functions = {
			default = {
				destroy = "visor_effect_destroy",
				set_visible = "visor_effect_set_visible",
				draw = "visor_effect_draw"
			}
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
		package = "packages/ui/hud/mission_objective_feed/mission_objective_feed",
		customizable_scenegraph_id = "area",
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementMissionObjectiveFeed",
		filename = "scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed",
		visibility_groups = {
			"dead",
			"alive",
			"communication_wheel"
		}
	},
	{
		package = "packages/ui/hud/mission_objective_popup/mission_objective_popup",
		customizable_scenegraph_id = "mission_popup",
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementMissionObjectivePopup",
		filename = "scripts/ui/hud/elements/mission_objective_popup/hud_element_mission_objective_popup",
		visibility_groups = {
			"dead",
			"alive",
			"communication_wheel"
		}
	},
	{
		package = "packages/ui/hud/onboarding_popup/onboarding_popup",
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementOnboardingPopup",
		filename = "scripts/ui/hud/elements/onboarding_popup/hud_element_onboarding_popup",
		visibility_groups = {
			"alive",
			"dead",
			"communication_wheel"
		}
	},
	{
		package = "packages/ui/hud/prologue_tutorial_info_box/prologue_tutorial_info_box",
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementPrologueTutorialInfoBox",
		filename = "scripts/ui/hud/elements/prologue_tutorial_info_box/hud_element_prologue_tutorial_info_box",
		visibility_groups = {
			"dead",
			"alive",
			"communication_wheel",
			"training_grounds"
		}
	},
	{
		package = "packages/ui/hud/area_notification_popup/area_notification_popup",
		customizable_scenegraph_id = "area_popup",
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementAreaNotificationPopup",
		filename = "scripts/ui/hud/elements/area_notification_popup/hud_element_area_notification_popup",
		visibility_groups = {
			"dead",
			"alive",
			"communication_wheel"
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
			"cutscene",
			"communication_wheel"
		}
	},
	{
		package = "packages/ui/hud/world_markers/world_markers",
		offscreen_target = "monitor_effect",
		use_hud_scale = false,
		class_name = "HudElementWorldMarkers",
		filename = "scripts/ui/hud/elements/world_markers/hud_element_world_markers",
		visibility_groups = {
			"alive",
			"communication_wheel"
		}
	},
	{
		package = "packages/ui/hud/interaction/interaction",
		offscreen_target = "monitor_effect",
		class_name = "HudElementInteraction",
		filename = "scripts/ui/hud/elements/interaction/hud_element_interaction",
		visibility_groups = {
			"alive",
			"communication_wheel"
		}
	},
	{
		class_name = "HudElementNameplates",
		filename = "scripts/ui/hud/elements/nameplates/hud_element_nameplates",
		visibility_groups = {
			"alive",
			"communication_wheel"
		}
	},
	{
		class_name = "HudElementCutsceneOverlay",
		filename = "scripts/ui/hud/elements/cutscene_overlay/hud_element_cutscene_overlay",
		visibility_groups = {
			"prologue_cutscene",
			"cutscene"
		}
	},
	{
		class_name = "HudElementCutsceneFading",
		filename = "scripts/ui/hud/elements/cutscene_fading/hud_element_cutscene_fading",
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
