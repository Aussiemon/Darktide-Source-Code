local elements = {
	{
		package = "packages/ui/hud/wield_info/wield_info",
		offscreen_target = "monitor_effect",
		class_name = "HudElementWieldInfo",
		filename = "scripts/ui/hud/elements/wield_info/hud_element_wield_info",
		visibility_groups = {
			"alive"
		}
	},
	{
		offscreen_target = "monitor_effect",
		class_name = "HudElementCharacterNewsFeed",
		filename = "scripts/ui/hud/elements/character_news_feed/hud_element_character_news_feed",
		visibility_groups = {
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
		package = "packages/ui/hud/boss_health/boss_health",
		offscreen_target = "monitor_effect",
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
		package = "packages/ui/hud/player_ability/player_ability",
		use_retained_mode = true,
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementPlayerAbilityHandler",
		filename = "scripts/ui/hud/elements/player_ability_handler/hud_element_player_ability_handler",
		visibility_groups = {
			"alive",
			"communication_wheel"
		},
		customizable_scenegraph_id = {
			"slot_combat_ability",
			"slot_support_ability"
		}
	},
	{
		package = "packages/ui/hud/player_weapon/player_weapon",
		use_retained_mode = true,
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementPlayerWeaponHandler",
		filename = "scripts/ui/hud/elements/player_weapon_handler/hud_element_player_weapon_handler",
		visibility_groups = {
			"alive",
			"communication_wheel"
		},
		customizable_scenegraph_id = {
			"weapon_slot_1",
			"weapon_slot_2"
		}
	},
	{
		package = "packages/ui/hud/damage_indicator/damage_indicator",
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementDamageIndicator",
		filename = "scripts/ui/hud/elements/damage_indicator/hud_element_damage_indicator",
		visibility_groups = {
			"alive",
			"communication_wheel"
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
			"alive",
			"communication_wheel"
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
			"alive"
		},
		customizable_scenegraph_id = {
			"overcharge",
			"overheat"
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
		package = "packages/ui/hud/smart_tagging/smart_tagging",
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementSmartTagging",
		filename = "scripts/ui/hud/elements/smart_tagging/hud_element_smart_tagging",
		visibility_groups = {
			"alive",
			"communication_wheel"
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
		package = "packages/ui/hud/prologue_tutorial_popup/prologue_tutorial_popup",
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementPrologueTutorialPopup",
		filename = "scripts/ui/hud/elements/prologue_tutorial_popup/hud_element_prologue_tutorial_popup",
		visibility_groups = {
			"dead",
			"alive",
			"communication_wheel"
		}
	},
	{
		customizable_scenegraph_id = "background",
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementCombatFeed",
		filename = "scripts/ui/hud/elements/combat_feed/hud_element_combat_feed",
		visibility_groups = {
			"dead",
			"alive",
			"communication_wheel"
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
		package = "packages/ui/hud/player_buffs/player_buffs",
		use_retained_mode = true,
		customizable_scenegraph_id = "background",
		offscreen_target = "monitor_effect",
		use_hud_scale = true,
		class_name = "HudElementPlayerBuffs",
		filename = "scripts/ui/hud/elements/player_buffs/hud_element_player_buffs",
		visibility_groups = {
			"dead",
			"alive",
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
		class_name = "HudElementSuppressionIndicators",
		filename = "scripts/ui/hud/elements/suppression/hud_element_suppression_indicators",
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
