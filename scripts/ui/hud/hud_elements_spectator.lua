local elements = {
	{
		package = "packages/ui/hud/mission_speaker_popup/mission_speaker_popup",
		customizable_scenegraph_id = "background",
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
	}
}

return elements
