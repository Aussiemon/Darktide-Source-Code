-- chunkname: @scripts/settings/live_event/leftover.lua

local leftover = {
	condition = "loc_leftover_condition",
	description = "loc_leftover_description",
	event_context = "loc_leftover_event_context",
	id = "leftover",
	lore = "loc_leftover_description_lore",
	name = "loc_leftover_name",
	hub_mutators = {
		"mutator_live_event_leftover_hub",
	},
	faction_network_lookup = {
		[1] = "pure",
		[2] = "impure",
	},
	item_rewards = {
		"content/items/2d/portrait_frames/portrait_frame_event_leftover",
	},
	global_stats = {
		category = "lw-mb",
		stats = {
			heretical_artifacts_impure = "impure",
			heretical_artifacts_pure = "pure",
			impure = "heretical_artifacts_impure",
			pure = "heretical_artifacts_pure",
		},
		buffs = {
			heretical_artifacts_pure = {
				"live_event_leftover_buff_faction_a",
				"live_event_leftover_buff_faction_a_apply_bleed_damage",
			},
			heretical_artifacts_impure = {
				"live_event_leftover_buff_faction_b",
				"live_event_leftover_buff_faction_b_apply_burn_damage",
			},
		},
	},
	objective = {
		widgets = {
			{
				template = "title",
				context = {
					mission_circumstance_family = "leftover",
					text = "loc_leftover_name",
				},
			},
			{
				template = "tug_o_war",
				context = {
					left_name = "loc_leftover_faction_a_name_short",
					left_stat = "heretical_artifacts_pure",
					mission_circumstance_family = "leftover",
					right_name = "loc_leftover_faction_b_name_short",
					right_stat = "heretical_artifacts_impure",
				},
			},
			{
				template = "sub_header",
				context = {
					mission_circumstance_family = "leftover",
					text = "loc_mission_objective_feed_leftover_hub_objective_sub_header",
				},
			},
		},
	},
}

return leftover
