-- chunkname: @scripts/ui/views/havoc_reward_presentation_view/havoc_reward_presentation_view_settings.lua

local grid_size = {
	500,
	700,
}
local grid_width = grid_size[1]
local grid_height = grid_size[2]
local grid_content_edge_margin = 40
local grid_blur_edge_size = {
	80,
	0,
}
local mask_size = {
	grid_width + grid_blur_edge_size[1] * 2,
	grid_height + grid_blur_edge_size[2] * 2,
}
local havoc_reward_presentation_view_settings = {
	scrollbar_width = 7,
	shading_environment = "content/shading_environments/ui/ui_item_preview",
	stats_anim_duration = 2,
	trait_spacing = -10,
	weapon_height_anim = 0.2,
	weapon_spawn_depth = 1.2,
	grid_spacing = {
		0,
		10,
	},
	grid_size = grid_size,
	mask_size = mask_size,
	grid_content_edge_margin = grid_content_edge_margin,
	stats_size = {
		grid_size[1] - grid_content_edge_margin * 3,
		6,
	},
	trait_size = {
		64,
		64,
	},
	trait_size_big = {
		128,
		128,
	},
	vo_event_vendor_first_interaction = {
		"hub_greeting_first_interaction_commissar_a",
		"hub_greeting_first_interaction_commissar_b",
		"hub_greeting_first_interaction_commissar_c",
		"hub_greeting_first_interaction_commissar_d",
	},
	vo_event_vendor_greeting = {
		"hub_greeting_commissar_a",
	},
	vo_event_promotion = {
		"hub_greeting_mission_success_a",
	},
	vo_event_demotion = {
		"hub_greeting_mission_failure_a",
	},
	vo_event_weekly_reward = {
		"hub_greeting_reward_a",
	},
}

return settings("HavocRewardPresentationViewSettings", havoc_reward_presentation_view_settings)
