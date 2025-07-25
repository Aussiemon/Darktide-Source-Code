﻿-- chunkname: @scripts/ui/hud/elements/world_markers/hud_element_world_markers_settings.lua

local hud_element_world_markers_settings = {
	marker_draw_layer_increment = 10,
	max_marker_draw_layer = 300,
	raycasts_frame_delay = 5,
	raycasts_per_frame = 10,
	marker_templates = {
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_beacon",
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_damage_indicator",
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_health_bar",
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_interaction",
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_nameplate",
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_nameplate_combat",
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_nameplate_companion",
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_nameplate_companion_hub",
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_nameplate_party_hud",
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_objective",
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_objective_hub",
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_location_ping",
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_location_threat",
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_location_attention",
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_unit_threat",
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_unit_threat_veteran",
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_unit_threat_adamant",
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_player_assistance",
		"scripts/ui/hud/elements/world_markers/templates/world_marker_template_training_grounds",
	},
}

return settings("HudElementWorldMarkersSettings", hud_element_world_markers_settings)
