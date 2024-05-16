-- chunkname: @scripts/settings/perception/perception_settings.lua

local perception_settings = {
	max_priority_blackboard_update_distance = 10,
	aggro_states = table.enum("passive", "alerted", "aggroed"),
	default_minion_line_of_sight_offsets = {
		Vector3Box(0, 0, 0),
		Vector3Box(0.125, 0, 0),
		Vector3Box(-0.125, 0, 0),
	},
	chaos_beast_of_nurgle_minion_line_of_sight_offsets = {
		Vector3Box(0, 0, 0),
	},
}

return settings("PerceptionSettings", perception_settings)
