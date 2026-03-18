-- chunkname: @scripts/settings/motion_triggered_explosives/motion_triggered_explosives_settings.lua

local motion_triggered_explosives_settings = {}
local PLAZA_SIZE = 30
local STREET_SIZE = 18
local CORRIDOR_SIZE = 10
local DETECTION_RADIUS = CORRIDOR_SIZE / 4

motion_triggered_explosives_settings.explosive_trap = {
	activation_delay = 1,
	armed_flow_event = "mine_armed",
	charges = 1,
	explosion_template_name = "expedition_trap_explosive",
	fuse_time = 1,
	life_time = 60,
	start_flow_event = "mine_dropped",
	triggered_flow_event = "mine_triggered",
	detection_radius = DETECTION_RADIUS,
	required_enemy_tag = table.set({
		"elite",
		"monster",
		"special",
		"captain",
	}),
	cluster_settings = {
		amount = 5,
		item = "content/items/weapons/player/grenade_frag",
		projectile_template_name = "expedition_trap_explosive_cluster",
		start_speed = {
			max = 12,
			min = 8,
		},
	},
}
motion_triggered_explosives_settings.fire_trap = {
	activation_delay = 1,
	armed_flow_event = "mine_armed",
	charges = 4,
	explosion_template_name = "expedition_trap_fire",
	fuse_time = 17,
	life_time = 60,
	liquid_area_template_name = "fire_trap",
	on_destroy_explosion_template_name = "expedition_trap_explosive",
	start_flow_event = "mine_dropped",
	triggered_flow_event = "mine_triggered",
	detection_radius = DETECTION_RADIUS,
}
motion_triggered_explosives_settings.shock_trap = {
	activation_delay = 1,
	armed_flow_event = "mine_armed",
	charges = 4,
	explosion_template_name = "expedition_trap_shock",
	fuse_time = 20,
	life_time = 60,
	liquid_area_template_name = "shock_trap",
	on_destroy_explosion_template_name = "expedition_trap_explosive",
	start_flow_event = "mine_dropped",
	triggered_flow_event = "mine_triggered",
	detection_radius = DETECTION_RADIUS,
}

return settings("MotionTriggeredExplosivesSettings", motion_triggered_explosives_settings)
