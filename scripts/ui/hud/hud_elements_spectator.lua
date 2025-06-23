-- chunkname: @scripts/ui/hud/hud_elements_spectator.lua

local elements = {
	{
		package = "packages/ui/hud/mission_speaker_popup/mission_speaker_popup",
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
		class_name = "HudElementNameplates",
		filename = "scripts/ui/hud/elements/nameplates/hud_element_nameplates",
		visibility_groups = {
			"alive"
		}
	},
	{
		package = "packages/ui/hud/spactator_text/spactator_text",
		class_name = "HudElementSpectatorText",
		filename = "scripts/ui/hud/elements/spectator/hud_element_spectator_text",
		visibility_groups = {
			"dead",
			"alive"
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
			"communication_wheel",
			"tactical_overlay"
		}
	},
	{
		package = "packages/ui/hud/boss_health/boss_health",
		use_hud_scale = true,
		class_name = "HudElementBossHealth",
		filename = "scripts/ui/hud/elements/boss_health/hud_element_boss_health",
		visibility_groups = {
			"dead",
			"alive",
			"communication_wheel"
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
			"communication_wheel",
			"tactical_overlay"
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
			"communication_wheel",
			"tactical_overlay"
		}
	},
	{
		use_hud_scale = true,
		class_name = "HudElementCombatFeed",
		filename = "scripts/ui/hud/elements/combat_feed/hud_element_combat_feed",
		visibility_groups = {
			"dead",
			"alive",
			"communication_wheel",
			"tactical_overlay"
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
			"communication_wheel",
			"tactical_overlay"
		}
	},
	{
		class_name = "HudElementCharacterNewsFeed",
		filename = "scripts/ui/hud/elements/character_news_feed/hud_element_character_news_feed",
		visibility_groups = {
			"alive",
			"communication_wheel"
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
	},
	{
		class_name = "HudElementSpectateFading",
		filename = "scripts/ui/hud/elements/spectate_fading/hud_element_spectate_fading",
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
