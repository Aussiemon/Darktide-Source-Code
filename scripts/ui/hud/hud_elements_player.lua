﻿-- chunkname: @scripts/ui/hud/hud_elements_player.lua

local elements = {
	{
		class_name = "HudElementWieldInfo",
		filename = "scripts/ui/hud/elements/wield_info/hud_element_wield_info",
		package = "packages/ui/hud/wield_info/wield_info",
		use_hud_scale = true,
		visibility_groups = {
			"alive",
		},
	},
	{
		class_name = "HudElementCharacterNewsFeed",
		filename = "scripts/ui/hud/elements/character_news_feed/hud_element_character_news_feed",
		visibility_groups = {
			"alive",
			"communication_wheel",
		},
	},
	{
		class_name = "HudElementTeamPanelHandler",
		filename = "scripts/ui/hud/elements/team_panel_handler/hud_element_team_panel_handler",
		package = "packages/ui/hud/team_player_panel/team_player_panel",
		use_hud_scale = true,
		use_retained_mode = true,
		visibility_groups = {
			"dead",
			"alive",
			"communication_wheel",
			"tactical_overlay",
		},
	},
	{
		class_name = "HudElementBossHealth",
		filename = "scripts/ui/hud/elements/boss_health/hud_element_boss_health",
		package = "packages/ui/hud/boss_health/boss_health",
		use_hud_scale = true,
		visibility_groups = {
			"dead",
			"alive",
			"communication_wheel",
		},
	},
	{
		class_name = "HudElementPlayerAbilityHandler",
		filename = "scripts/ui/hud/elements/player_ability_handler/hud_element_player_ability_handler",
		package = "packages/ui/hud/player_ability/player_ability",
		use_hud_scale = true,
		use_retained_mode = true,
		visibility_groups = {
			"alive",
			"communication_wheel",
			"tactical_overlay",
		},
	},
	{
		class_name = "HudElementPlayerWeaponHandler",
		filename = "scripts/ui/hud/elements/player_weapon_handler/hud_element_player_weapon_handler",
		package = "packages/ui/hud/player_weapon/player_weapon",
		use_hud_scale = true,
		use_retained_mode = true,
		visibility_groups = {
			"alive",
			"communication_wheel",
			"tactical_overlay",
		},
	},
	{
		class_name = "HudElementDamageIndicator",
		filename = "scripts/ui/hud/elements/damage_indicator/hud_element_damage_indicator",
		package = "packages/ui/hud/damage_indicator/damage_indicator",
		use_hud_scale = true,
		visibility_groups = {
			"alive",
			"communication_wheel",
		},
	},
	{
		class_name = "HudElementBlocking",
		filename = "scripts/ui/hud/elements/blocking/hud_element_blocking",
		package = "packages/ui/hud/blocking/blocking",
		use_hud_scale = true,
		visibility_groups = {
			"alive",
			"communication_wheel",
		},
	},
	{
		class_name = "HudElementOvercharge",
		filename = "scripts/ui/hud/elements/overcharge/hud_element_overcharge",
		package = "packages/ui/hud/overcharge/overcharge",
		use_hud_scale = true,
		use_retained_mode = true,
		visibility_groups = {
			"alive",
		},
	},
	{
		class_name = "HudElementTacticalOverlay",
		filename = "scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay",
		package = "packages/ui/hud/tactical_overlay/tactical_overlay",
		use_hud_scale = false,
		visibility_groups = {
			"tactical_overlay",
			"alive",
			"communication_wheel",
		},
	},
	{
		class_name = "HudElementCrosshair",
		filename = "scripts/ui/hud/elements/crosshair/hud_element_crosshair",
		package = "packages/ui/hud/crosshair/crosshair",
		use_hud_scale = false,
		visibility_groups = {
			"alive",
		},
	},
	{
		class_name = "HudElementSmartTagging",
		filename = "scripts/ui/hud/elements/smart_tagging/hud_element_smart_tagging",
		package = "packages/ui/hud/smart_tagging/smart_tagging",
		use_hud_scale = true,
		visibility_groups = {
			"alive",
			"communication_wheel",
		},
	},
	{
		class_name = "HudElementMissionObjectiveFeed",
		filename = "scripts/ui/hud/elements/mission_objective_feed/hud_element_mission_objective_feed",
		package = "packages/ui/hud/mission_objective_feed/mission_objective_feed",
		use_hud_scale = true,
		visibility_groups = {
			"dead",
			"alive",
			"communication_wheel",
			"tactical_overlay",
		},
	},
	{
		class_name = "HudElementMissionObjectivePopup",
		filename = "scripts/ui/hud/elements/mission_objective_popup/hud_element_mission_objective_popup",
		package = "packages/ui/hud/mission_objective_popup/mission_objective_popup",
		use_hud_scale = true,
		visibility_groups = {
			"dead",
			"alive",
			"communication_wheel",
			"tactical_overlay",
		},
	},
	{
		class_name = "HudElementCombatFeed",
		filename = "scripts/ui/hud/elements/combat_feed/hud_element_combat_feed",
		use_hud_scale = true,
		visibility_groups = {
			"dead",
			"alive",
			"communication_wheel",
			"tactical_overlay",
		},
	},
	{
		class_name = "HudElementAreaNotificationPopup",
		filename = "scripts/ui/hud/elements/area_notification_popup/hud_element_area_notification_popup",
		package = "packages/ui/hud/area_notification_popup/area_notification_popup",
		use_hud_scale = true,
		visibility_groups = {
			"dead",
			"alive",
			"communication_wheel",
			"tactical_overlay",
		},
	},
	{
		class_name = "HudElementMissionSpeakerPopup",
		filename = "scripts/ui/hud/elements/mission_speaker_popup/hud_element_mission_speaker_popup",
		package = "packages/ui/hud/mission_speaker_popup/mission_speaker_popup",
		use_hud_scale = true,
		visibility_groups = {
			"dead",
			"alive",
			"cutscene",
			"communication_wheel",
			"tactical_overlay",
		},
	},
	{
		class_name = "HudElementPlayerBuffs",
		filename = "scripts/ui/hud/elements/player_buffs/hud_element_player_buffs_polling",
		package = "packages/ui/hud/player_buffs/player_buffs",
		use_hud_scale = true,
		use_retained_mode = true,
		visibility_groups = {
			"dead",
			"alive",
			"communication_wheel",
		},
	},
	{
		class_name = "HudElementWorldMarkers",
		filename = "scripts/ui/hud/elements/world_markers/hud_element_world_markers",
		package = "packages/ui/hud/world_markers/world_markers",
		use_hud_scale = true,
		visibility_groups = {
			"alive",
			"communication_wheel",
		},
	},
	{
		class_name = "HudElementInteraction",
		filename = "scripts/ui/hud/elements/interaction/hud_element_interaction",
		package = "packages/ui/hud/interaction/interaction",
		use_hud_scale = true,
		visibility_groups = {
			"alive",
			"communication_wheel",
		},
	},
	{
		class_name = "HudElementNameplates",
		filename = "scripts/ui/hud/elements/nameplates/hud_element_nameplates",
		use_hud_scale = false,
		visibility_groups = {
			"alive",
			"communication_wheel",
		},
	},
	{
		class_name = "HudElementCutsceneOverlay",
		filename = "scripts/ui/hud/elements/cutscene_overlay/hud_element_cutscene_overlay",
		visibility_groups = {
			"prologue_cutscene",
			"cutscene",
		},
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
			"alive",
		},
	},
	{
		class_name = "HudElementPrologueTutorialInfoBox",
		filename = "scripts/ui/hud/elements/prologue_tutorial_info_box/hud_element_prologue_tutorial_info_box",
		package = "packages/ui/hud/prologue_tutorial_info_box/prologue_tutorial_info_box",
		use_hud_scale = true,
		visibility_groups = {
			"dead",
			"alive",
			"communication_wheel",
		},
	},
}

return elements
