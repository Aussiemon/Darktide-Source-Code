local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local interaction_settings = {
	detection_radius = 1.2,
	sphere_offset = 1.1,
	look_height_scale = 1,
	height_scale = 0.3,
	max_interaction_radian = 0.4,
	states = table.enum("none", "is_interacting", "waiting_to_interact"),
	results = table.enum("success", "stopped_holding", "interaction_cancelled", "ongoing"),
	duration_buffs = {
		revive = stat_buffs.revive_duration_multiplier
	},
	speed_buffs = {
		revive = stat_buffs.revive_speed_modifier,
		pull_up = stat_buffs.assist_speed_modifier,
		remove_net = stat_buffs.assist_speed_modifier
	},
	emissive_colors = {
		used = Vector3Box(Vector3(0, 0, 0)),
		active = Vector3Box(Vector3(0, 0.5, 1)),
		unactive = Vector3Box(Vector3(1, 0.01, 0))
	}
}

return settings("InteractionSettings", interaction_settings)
