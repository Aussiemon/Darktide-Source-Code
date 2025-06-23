-- chunkname: @scripts/settings/interaction/interaction_settings.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local interaction_settings = {}

interaction_settings.ogryn_detection_radius = 1.7
interaction_settings.ogryn_sphere_offset = 1.5
interaction_settings.detection_radius = 1.3
interaction_settings.sphere_offset = 1.2
interaction_settings.height_scale = 0.3
interaction_settings.max_interaction_angle = 0.4
interaction_settings.max_interaction_angle_3p = 0.8
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
