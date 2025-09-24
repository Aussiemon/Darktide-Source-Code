-- chunkname: @scripts/settings/breed/breed_actions/companion/companion_dog_hub_actions.lua

local CompanionDogLocomotionSettings = require("scripts/settings/companion/companion_dog_locomotion_settings")
local idle_circle_distances = {
	inner_circle_distance = 0.75,
	outer_circle_distance = 2.5,
}
local hub_far_distance = idle_circle_distances.outer_circle_distance * 2
local move_to_position_default = {
	enable_disable_locomotion_speed = false,
	leave_distance = 16,
	rotation_speed = 20,
	skip_start_anim = true,
	skip_start_animation_event = "to_walk",
	skip_start_animation_on_crouch = true,
	speed = 5,
	too_close_distance = 1.5,
	start_move_anim_events = {
		bwd = "run_start_bwd",
		fwd = "run_start_fwd",
		left = "run_start_left",
		right = "run_start_right",
	},
	start_move_anim_data = {
		run_start_fwd = {},
		run_start_bwd = {
			sign = 1,
			rad = math.pi,
		},
		run_start_left = {
			sign = 1,
			rad = math.pi / 2,
		},
		run_start_right = {
			sign = -1,
			rad = math.pi / 2,
		},
	},
	start_move_rotation_timings = {
		run_start_bwd = 0,
		run_start_left = 0,
		run_start_right = 0,
	},
	start_rotation_durations = {
		run_start_bwd = 0.26666666666666666,
		run_start_left = 0.23333333333333334,
		run_start_right = 0.23333333333333334,
	},
	start_move_event_anim_speed_durations = {
		run_start_fwd = 0,
	},
	idle_anim_events = {
		"idle",
	},
	adapt_speed = {
		epsilon = 0.3,
		max_acceleration = 12,
		max_deceleration = 8,
		max_speed_multiplier = 1.8,
		min_speed_multiplier = 0,
		slow_epsilon = 1.3,
		slow_max_deceleration = 16,
		speed_timer = 0,
	},
	dog_owner_follow_config = CompanionDogLocomotionSettings.dog_owner_follow_config,
	dog_forward_follow_config = CompanionDogLocomotionSettings.dog_forward_follow_hub_config,
	dog_lrb_follow_config = CompanionDogLocomotionSettings.dog_lrb_follow_hub_config,
}
local action_data = {
	name = "companion_dog_hub",
	idle = {
		anim_events = {
			"idle_to_sit",
			"idle",
		},
	},
	manual_teleport = {
		wait_time = 0.1,
	},
	move_close_to_owner_selector = {
		angle_rotation_for_check = 40,
		distance_from_owner = 2.85,
		idle_circle_distances = idle_circle_distances,
		far_distance = hub_far_distance,
		close_distance = idle_circle_distances.inner_circle_distance,
	},
	move_close_to_owner_follow_selector = {
		angle_rotation_for_check = 40,
		close_distance = 2,
		idle_circle_distances = idle_circle_distances,
		far_distance = math.huge,
		companion_cone_check = {
			angle = 90,
		},
	},
	companion_has_move_position = {
		follow_owner_cooldown = 1,
		override_lrb_to_use_owner_speed = true,
		reset_position_timer = 0.1,
		dog_owner_follow_config = CompanionDogLocomotionSettings.dog_owner_follow_config,
		dog_forward_follow_config = CompanionDogLocomotionSettings.dog_forward_follow_hub_config,
		dog_lrb_follow_config = CompanionDogLocomotionSettings.dog_lrb_follow_hub_config,
		companion_cone_check = {
			angle = 90,
		},
	},
	follow = {
		follow_owner_cooldown = 1,
		reset_position_timer = 0.1,
		idle_circle_distances = idle_circle_distances,
		dog_owner_follow_config = CompanionDogLocomotionSettings.dog_owner_follow_config,
		dog_forward_follow_config = CompanionDogLocomotionSettings.dog_forward_follow_hub_config,
		dog_lrb_follow_config = CompanionDogLocomotionSettings.dog_lrb_follow_hub_config,
		far_distance = hub_far_distance,
		cone_angle = math.pi / 3,
	},
	move_to_position = table.merge(table.clone(move_to_position_default), {
		arrived_at_distance_threshold_sq = 1,
		stop_at_target_position = true,
	}),
	move_close_to_owner_action = table.merge(table.clone(move_to_position_default), {
		arrived_at_distance_threshold_sq = 0.1,
		stop_at_target_position = true,
		follow_aim = {
			player = {
				0,
				math.huge,
			},
		},
	}),
	hub_interaction_with_player_selector = {
		relocation_speed = 1,
		rotation_speed = 1,
	},
	hub_interaction_move_to_position = table.merge(table.clone(move_to_position_default), {
		stop_at_target_position = true,
		stop_when_not_following_path = true,
	}),
	start_hub_interaction_with_player = table.merge(table.clone(move_to_position_default), {
		stop_at_target_position = true,
	}),
}

return action_data
