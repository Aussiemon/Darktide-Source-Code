-- chunkname: @scripts/ui/hud/hud_elements_player_hub.lua

local elements = {
	{
		class_name = "HudElementCharacterNewsFeed",
		filename = "scripts/ui/hud/elements/character_news_feed/hud_element_character_news_feed",
		visibility_groups = {
			"in_hub_view",
			"alive",
			"emote_wheel"
		}
	},
	{
		package = "packages/ui/hud/team_player_panel/team_player_panel",
		use_retained_mode = true,
		use_hud_scale = true,
		class_name = "HudElementTeamPanelHandler",
		filename = "scripts/ui/hud/elements/team_panel_handler/hud_element_team_panel_handler",
		visibility_groups = {
			"dead",
			"alive",
			"emote_wheel"
		}
	},
	{
		package = "packages/ui/hud/crosshair/crosshair",
		use_hud_scale = true,
		class_name = "HudElementCrosshair",
		filename = "scripts/ui/hud/elements/crosshair/hud_element_crosshair",
		visibility_groups = {
			"alive"
		}
	},
	{
		package = "packages/ui/hud/tactical_overlay/tactical_overlay",
		use_hud_scale = false,
		class_name = "HudElementTacticalOverlay",
		filename = "scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay",
		visibility_groups = {
			"tactical_overlay",
			"alive",
			"emote_wheel"
		},
		context = {
			show_left_side_details = false
		}
	},
	{
		package = "packages/ui/hud/mission_objective_feed/mission_objective_feed",
		use_hud_scale = true,
		class_name = "HudElementMissionObjectiveFeed",
		filename = "scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed",
		visibility_groups = {
			"dead",
			"alive",
			"emote_wheel"
		}
	},
	{
		package = "packages/ui/hud/mission_objective_popup/mission_objective_popup",
		use_hud_scale = true,
		class_name = "HudElementMissionObjectivePopup",
		filename = "scripts/ui/hud/elements/mission_objective_popup/hud_element_mission_objective_popup",
		visibility_groups = {
			"dead",
			"alive",
			"emote_wheel"
		}
	},
	{
		package = "packages/ui/hud/objective_progress_bar/objective_progress_bar",
		use_hud_scale = true,
		class_name = "HudElementObjectiveProgressBar",
		filename = "scripts/ui/hud/elements/objective_progress_bar/hud_element_objective_progress_bar",
		visibility_groups = {
			"dead",
			"alive",
			"communication_wheel"
		}
	},
	{
		package = "packages/ui/hud/onboarding_popup/onboarding_popup",
		use_hud_scale = true,
		class_name = "HudElementOnboardingPopup",
		filename = "scripts/ui/hud/elements/onboarding_popup/hud_element_onboarding_popup",
		visibility_groups = {
			"alive",
			"dead",
			"emote_wheel"
		}
	},
	{
		package = "packages/ui/hud/area_notification_popup/area_notification_popup",
		use_hud_scale = true,
		class_name = "HudElementAreaNotificationPopup",
		filename = "scripts/ui/hud/elements/area_notification_popup/hud_element_area_notification_popup",
		visibility_groups = {
			"dead",
			"alive",
			"emote_wheel"
		}
	},
	{
		package = "packages/ui/hud/mission_speaker_popup/mission_speaker_popup",
		use_hud_scale = true,
		class_name = "HudElementMissionSpeakerPopup",
		filename = "scripts/ui/hud/elements/mission_speaker_popup/hud_element_mission_speaker_popup",
		visibility_groups = {
			"dead",
			"alive",
			"cutscene",
			"emote_wheel"
		}
	},
	{
		package = "packages/ui/hud/world_markers/world_markers",
		use_hud_scale = false,
		class_name = "HudElementWorldMarkers",
		filename = "scripts/ui/hud/elements/world_markers/hud_element_world_markers",
		visibility_groups = {
			"alive",
			"emote_wheel"
		}
	},
	{
		package = "packages/ui/hud/interaction/interaction",
		class_name = "HudElementInteraction",
		filename = "scripts/ui/hud/elements/interaction/hud_element_interaction",
		visibility_groups = {
			"alive",
			"emote_wheel"
		}
	},
	{
		package = "packages/ui/hud/emote_wheel/emote_wheel",
		use_hud_scale = false,
		class_name = "HudElementEmoteWheel",
		filename = "scripts/ui/hud/elements/emote_wheel/hud_element_emote_wheel",
		visibility_groups = {
			"alive",
			"emote_wheel"
		}
	},
	{
		class_name = "HudElementNameplates",
		filename = "scripts/ui/hud/elements/nameplates/hud_element_nameplates",
		visibility_groups = {
			"alive",
			"emote_wheel"
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
			"emote_wheel",
			"testify",
			"dead",
			"alive"
		}
	}
}

return elements
