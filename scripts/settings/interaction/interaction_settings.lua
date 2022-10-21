local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local interaction_settings = {}
local detection_radius = 1.2
local sphere_offset = 1.1
local max_interaction_distance = detection_radius + sphere_offset + 0.2
interaction_settings.detection_radius = detection_radius
interaction_settings.sphere_offset = sphere_offset
interaction_settings.look_height_scale = 1
interaction_settings.height_scale = 0.3
interaction_settings.max_interaction_angle = 0.4
interaction_settings.max_interaction_distance = max_interaction_distance
interaction_settings.ongoing_interaction_leeway = 1.2
interaction_settings.states = table.enum("none", "is_interacting", "waiting_to_interact")
interaction_settings.results = table.enum("success", "stopped_holding", "interaction_cancelled", "ongoing")
interaction_settings.duration_buffs = {
	revive = stat_buffs.revive_duration_multiplier
}
interaction_settings.speed_buffs = {
	revive = stat_buffs.revive_speed_modifier,
	pull_up = stat_buffs.assist_speed_modifier,
	remove_net = stat_buffs.assist_speed_modifier
}
interaction_settings.emissive_colors = {
	used = Vector3Box(Vector3(0, 0, 0)),
	active = Vector3Box(Vector3(0, 0.5, 1)),
	inactive = Vector3Box(Vector3(1, 0.01, 0))
}

return settings("InteractionSettings", interaction_settings)
