-- chunkname: @scripts/settings/breed/breed_actions/cultist/cultist_berzerker_actions.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local action_data = {
	name = "cultist_berzerker",
	idle = {
		anim_events = "idle",
		rotate_towards_target = true,
	},
	patrol = {
		anim_events = "move_fwd_1",
		idle_anim_events = "idle",
		speeds = {
			move_fwd_1 = 1.5,
		},
	},
	death = {
		instant_ragdoll_chance = 1,
	},
	combat_idle = {
		anim_events = "idle",
		rotate_towards_target = true,
		utility_weight = 2,
		considerations = UtilityConsiderations.melee_combat_idle,
	},
	alerted = {
		instant_aggro_chance = 0,
		override_aggro_distance = 8,
		moving_alerted_anim_events = {
			fwd = {
				"alerted_fwd",
				"alerted_fwd_2",
			},
			bwd = {
				"alerted_bwd",
				"alerted_bwd_2",
			},
			left = {
				"alerted_left",
				"alerted_left_2",
			},
			right = {
				"alerted_right",
				"alerted_right_2",
			},
		},
		hesitate_anim_events = {
			"alerted",
		},
		start_move_anim_data = {
			alerted_fwd = {},
			alerted_bwd = {
				sign = 1,
				rad = math.pi,
			},
			alerted_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			alerted_right = {
				sign = -1,
				rad = math.pi / 2,
			},
			alerted_fwd_2 = {},
			alerted_bwd_2 = {
				sign = 1,
				rad = math.pi,
			},
			alerted_left_2 = {
				sign = 1,
				rad = math.pi / 2,
			},
			alerted_right_2 = {
				sign = -1,
				rad = math.pi / 2,
			},
		},
		start_move_rotation_timings = {
			alerted_bwd = 0,
			alerted_bwd_2 = 0,
			alerted_left = 0,
			alerted_left_2 = 0,
			alerted_right = 0,
			alerted_right_2 = 0,
		},
		start_rotation_durations = {
			alerted_bwd = 2.3666666666666667,
			alerted_bwd_2 = 3.066666666666667,
			alerted_left = 0.4,
			alerted_left_2 = 1.7,
			alerted_right = 0.7666666666666667,
			alerted_right_2 = 0.43333333333333335,
		},
		alerted_durations = {
			alerted_bwd = 4.666666666666667,
			alerted_bwd_2 = 5.1,
			alerted_fwd = 4.4,
			alerted_fwd_2 = 3.9,
			alerted_left = 3.3333333333333335,
			alerted_left_2 = 4.166666666666667,
			alerted_right = 4.466666666666667,
			alerted_right_2 = 3.8,
			alerted = {
				2,
				6.666666666666667,
			},
		},
	},
	climb = {
		rotation_duration = 0.1,
		stagger_immune = true,
		anim_timings = {
			jump_down_land = 1.3333333333333333,
			jump_up_1m = 1.2424242424242424,
			jump_up_1m_2 = 1.0303030303030303,
			jump_up_3m = 2.923076923076923,
			jump_up_3m_2 = 3.051282051282051,
			jump_up_5m = 4.166666666666667,
			jump_up_fence_1m = 0.6,
			jump_up_fence_3m = 1.4,
			jump_up_fence_5m = 1.3,
		},
		land_timings = {
			jump_down_1m = 0.2,
			jump_down_1m_2 = 0.16666666666666666,
			jump_down_3m = 0.3333333333333333,
			jump_down_3m_2 = 0.5,
			jump_down_fence_1m = 0.26666666666666666,
			jump_down_fence_3m = 0.3333333333333333,
			jump_down_fence_5m = 0.3333333333333333,
		},
		ending_move_states = {
			jump_down_land = "jumping",
			jump_up_1m = "jumping",
			jump_up_1m_2 = "jumping",
			jump_up_3m = "jumping",
			jump_up_3m_2 = "jumping",
			jump_up_5m = "jumping",
		},
		blend_timings = {
			jump_down_1m = 0.1,
			jump_down_1m_2 = 0.1,
			jump_down_3m = 0.1,
			jump_down_3m_2 = 0.1,
			jump_down_land = 0,
			jump_up_1m = 0.1,
			jump_up_1m_2 = 0.1,
			jump_up_3m = 0.1,
			jump_up_3m_2 = 0.1,
			jump_up_5m = 0.1,
			jump_up_fence_1m = 0.2,
			jump_up_fence_3m = 0.2,
			jump_up_fence_5m = 0.2,
		},
	},
	jump_across = {
		rotation_duration = 0.1,
		stagger_immune = true,
		anim_timings = {
			jump_over_gap_4m = 1.1666666666666667,
			jump_over_gap_4m_2 = 1.1333333333333333,
		},
		ending_move_states = {
			jump_over_gap_4m = "jumping",
			jump_over_gap_4m_2 = "jumping",
		},
	},
	follow = {
		controlled_stagger = true,
		controlled_stagger_ignored_combat_range = "melee",
		controlled_stagger_min_speed = 2,
		enter_walk_distance = 4,
		follow_vo_interval_t = 2,
		idle_anim_events = "idle",
		leave_walk_distance = 7,
		move_speed = 5.4,
		rotation_speed = 5,
		run_anim_event = "assault_fwd",
		running_stagger_anim_left = "run_stagger_01",
		running_stagger_anim_right = "run_stagger_02",
		running_stagger_duration = 1.1666666666666667,
		use_animation_running_stagger_speed = true,
		utility_weight = 1,
		vo_event = "assault",
		walk_anim_event = "move_fwd_walk_4",
		considerations = UtilityConsiderations.melee_follow,
		start_move_anim_events = {
			walking = {
				bwd = "move_bwd_walk",
				fwd = "move_fwd_walk",
				left = "move_left_walk",
				right = "move_right_walk",
			},
			running = {
				bwd = "move_start_assault_bwd",
				fwd = "move_start_assault_fwd",
				left = "move_start_assault_left",
				right = "move_start_right",
			},
		},
		start_move_anim_data = {
			move_start_assault_fwd = {},
			move_start_assault_bwd = {
				sign = -1,
				rad = math.pi,
			},
			move_start_assault_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			move_start_right = {
				sign = -1,
				rad = math.pi / 2,
			},
		},
		start_move_rotation_timings = {
			move_start_assault_bwd = 0,
			move_start_assault_fwd = 0,
			move_start_assault_left = 0,
			move_start_right = 0,
		},
		start_rotation_durations = {
			move_start_assault_bwd = 0.26666666666666666,
			move_start_assault_fwd = 0.26666666666666666,
			move_start_assault_left = 0.26666666666666666,
			move_start_right = 0.26666666666666666,
		},
		start_move_event_anim_speed_durations = {
			move_start_assault_fwd = 0.5,
		},
	},
	assault_follow = {
		controlled_stagger = true,
		controlled_stagger_ignored_combat_range = "melee",
		controlled_stagger_min_speed = 2,
		enter_walk_distance = 4,
		follow_vo_interval_t = 2,
		force_move_anim_event = "assault_fwd",
		idle_anim_events = "idle",
		is_assaulting = true,
		leave_walk_distance = 7,
		move_speed = 6.2,
		rotation_speed = 5,
		run_anim_event = "assault_fwd",
		running_stagger_anim_left = "run_stagger_01",
		running_stagger_anim_right = "run_stagger_02",
		running_stagger_duration = 1.1666666666666667,
		use_animation_running_stagger_speed = true,
		vo_event = "assault",
		walk_anim_event = "move_fwd_walk",
	},
	melee_attack = {
		ignore_blocked = true,
		stagger_reduction = 50,
		utility_weight = 1,
		weapon_reach = 3.5,
		considerations = UtilityConsiderations.melee_attack,
		attack_anim_events = {
			normal = {
				"attack_01",
				"attack_02",
				"attack_03",
				"attack_04",
				"attack_combo_standing_06",
			},
			up = {
				"attack_reach_up",
			},
			down = {
				"attack_down_01",
			},
		},
		attack_anim_damage_timings = {
			attack_01 = 0.43333333333333335,
			attack_02 = 0.4666666666666667,
			attack_03 = 0.4666666666666667,
			attack_04 = 0.5666666666666667,
			attack_down_01 = 0.7,
			attack_reach_up = 0.7666666666666667,
			attack_combo_standing_06 = {
				0.4666666666666667,
				0.9666666666666667,
			},
		},
		attack_anim_durations = {
			attack_01 = 0.9333333333333333,
			attack_02 = 0.9333333333333333,
			attack_03 = 0.9333333333333333,
			attack_04 = 1,
			attack_combo_standing_06 = 1.2666666666666666,
			attack_down_01 = 2.1,
			attack_reach_up = 1.6666666666666667,
		},
		attack_intensities = {
			melee = 0.5,
			ranged = 1,
		},
		stagger_type_reduction = {
			killshot = 20,
			ranged = 20,
		},
		damage_profile = DamageProfileTemplates.melee_fighter_default,
		damage_type = damage_types.minion_melee_sharp,
	},
	combo_attack = {
		assault_vo_interval_t = 1,
		ignore_blocked = true,
		move_speed_variable_lerp_speed = 5,
		move_speed_variable_name = "moving_attack_fwd_speed",
		moving_attack = true,
		stagger_reduction = 50,
		utility_weight = 1,
		vo_event = "assault",
		weapon_reach = 3.75,
		considerations = UtilityConsiderations.cultist_berzerker_combo_attack,
		attack_anim_events = {
			"attack_move_combo_01_fast",
			"attack_move_combo_08_fast",
		},
		attack_anim_damage_timings = {
			attack_move_combo_01_fast = {
				0.5833333333333334,
				1.1875,
				1.25,
				1.8541666666666667,
				1.8958333333333333,
				2.5208333333333335,
				2.5833333333333335,
			},
			attack_move_combo_08_fast = {
				0.5,
				1.1944444444444444,
				1.25,
				2.1666666666666665,
				2.888888888888889,
			},
		},
		move_start_timings = {
			attack_move_combo_01_fast = 0,
			attack_move_combo_08_fast = 0,
		},
		attack_anim_durations = {
			attack_move_combo_01_fast = 2.9166666666666665,
			attack_move_combo_08_fast = 3.0555555555555554,
		},
		attack_intensities = {
			melee = 2,
			ranged = 1,
		},
		animation_move_speed_configs = {
			attack_move_combo_01_fast = {
				{
					distance = 2.6,
					value = 4,
				},
				{
					distance = 2.5,
					value = 3,
				},
				{
					distance = 2.2,
					value = 2,
				},
				{
					distance = 1.5,
					value = 1,
				},
				{
					distance = 0.8,
					value = 0,
				},
			},
			attack_move_combo_08_fast = {
				{
					distance = 3.3,
					value = 4,
				},
				{
					distance = 2.3,
					value = 3,
				},
				{
					distance = 2.1,
					value = 2,
				},
				{
					distance = 1.2,
					value = 1,
				},
				{
					distance = 0.86,
					value = 0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.melee_berzerker_combo,
		damage_type = damage_types.minion_melee_sharp,
	},
	leap_attack = {
		assault_vo_interval_t = 1,
		ignore_blocked = true,
		move_speed_variable_lerp_speed = 10,
		move_speed_variable_name = "moving_attack_fwd_speed",
		moving_attack = true,
		stagger_reduction = 50,
		utility_weight = 1,
		vo_event = "assault",
		weapon_reach = 3.75,
		considerations = UtilityConsiderations.cultist_berzerker_leap_attack,
		attack_anim_events = {
			"attack_move_combo_04_fast",
		},
		attack_anim_damage_timings = {
			attack_move_combo_04_fast = {
				0.4722222222222222,
				0.8055555555555556,
				1.25,
				1.2777777777777777,
				1.9722222222222223,
				2.5833333333333335,
			},
		},
		move_start_timings = {
			attack_move_combo_04_fast = 0,
		},
		attack_anim_durations = {
			attack_move_combo_04_fast = 2.7222222222222223,
		},
		attack_intensities = {
			melee = 2,
			ranged = 1,
		},
		animation_move_speed_configs = {
			attack_move_combo_04_fast = {
				{
					distance = 3.5,
					value = 4,
				},
				{
					distance = 2.68,
					value = 3,
				},
				{
					distance = 1.2,
					value = 2,
				},
				{
					distance = 0.5,
					value = 1,
				},
				{
					distance = 0.2,
					value = 0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.melee_berzerker_combo,
		damage_type = damage_types.minion_melee_sharp,
	},
	moving_melee_attack = {
		ignore_blocked = true,
		move_speed_variable_lerp_speed = 4,
		move_speed_variable_name = "moving_attack_fwd_speed",
		moving_attack = true,
		stagger_reduction = 50,
		utility_weight = 5,
		vo_event = "assault",
		weapon_reach = 3.75,
		considerations = UtilityConsiderations.renegade_melee_moving_melee_attack,
		attack_anim_events = {
			"attack_move_01",
		},
		attack_anim_damage_timings = {
			attack_move_01 = {
				0.9629629629629629,
			},
		},
		move_start_timings = {
			attack_move_01 = 0,
		},
		attack_anim_durations = {
			attack_move_01 = 1.8518518518518519,
		},
		attack_intensities = {
			melee = 2,
			ranged = 1,
		},
		damage_profile = DamageProfileTemplates.melee_fighter_default,
		damage_type = damage_types.minion_melee_sharp,
		animation_move_speed_configs = {
			attack_move_01 = {
				{
					distance = 5.61,
					value = 4,
				},
				{
					distance = 4.39,
					value = 3,
				},
				{
					distance = 3.12,
					value = 2,
				},
				{
					distance = 2.12,
					value = 1,
				},
				{
					distance = 0.1,
					value = 0,
				},
			},
		},
	},
	blocked = {
		blocked_duration = 1.6666666666666667,
		blocked_anims = {
			"blocked",
		},
	},
	stagger = {
		stagger_duration_mods = {
			stagger_explosion_back_2 = 0.9,
		},
		stagger_anims = {
			light = {
				fwd = {
					"stagger_fwd_light",
					"stagger_fwd_light_2",
				},
				bwd = {
					"stagger_bwd_light",
					"stagger_bwd_light_2",
				},
				left = {
					"stagger_left_light",
					"stagger_left_light_2",
				},
				right = {
					"stagger_right_light",
					"stagger_right_light_2",
				},
				dwn = {
					"stun_down",
				},
			},
			medium = {
				fwd = {
					"stagger_fwd",
				},
				bwd = {
					"stagger_bwd",
				},
				left = {
					"stagger_left",
				},
				right = {
					"stagger_right",
				},
				dwn = {
					"stagger_downward",
				},
			},
			heavy = {
				fwd = {
					"stagger_fwd_heavy",
				},
				bwd = {
					"stagger_bwd_heavy",
				},
				left = {
					"stagger_left_heavy",
				},
				right = {
					"stagger_right_heavy",
				},
				dwn = {
					"stagger_dwn_heavy",
				},
			},
			light_ranged = {
				fwd = {
					"stun_fwd_ranged_light",
					"stun_fwd_ranged_light_2",
				},
				bwd = {
					"stun_bwd_ranged_light",
					"stun_bwd_ranged_light_2",
				},
				left = {
					"stun_left_ranged_light",
					"stun_left_ranged_light_2",
				},
				right = {
					"stun_right_ranged_light",
					"stun_right_ranged_light_2",
				},
			},
			explosion = {
				fwd = {
					"stagger_explosion_front",
				},
				bwd = {
					"stagger_explosion_back",
				},
				left = {
					"stagger_explosion_left",
				},
				right = {
					"stagger_explosion_right",
				},
			},
			killshot = {
				fwd = {
					"stagger_fwd_killshot_1",
				},
				bwd = {
					"stagger_bwd_killshot_1",
				},
				left = {
					"stagger_left_killshot_1",
				},
				right = {
					"stagger_right_killshot_1",
				},
				dwn = {
					"stagger_bwd_killshot_1",
				},
			},
			sticky = {
				fwd = {
					"stagger_bwd_sticky",
				},
				bwd = {
					"stagger_front_sticky",
				},
				right = {
					"stagger_left_sticky",
				},
				left = {
					"stagger_right_sticky",
				},
				dwn = {
					"stagger_bwd_sticky",
				},
			},
			electrocuted = {
				fwd = {
					"stagger_bwd_sticky",
				},
				bwd = {
					"stagger_front_sticky",
				},
				right = {
					"stagger_left_sticky",
				},
				left = {
					"stagger_right_sticky",
				},
				dwn = {
					"stagger_bwd_sticky",
				},
			},
			blinding = {
				fwd = {
					"stagger_fwd_light",
					"stagger_fwd_light_2",
				},
				bwd = {
					"stagger_bwd_light",
					"stagger_bwd_light_2",
				},
				left = {
					"stagger_left_light",
					"stagger_left_light_2",
				},
				right = {
					"stagger_right_light",
					"stagger_right_light_2",
				},
				dwn = {
					"stun_down",
				},
			},
		},
	},
	smash_obstacle = {
		rotation_duration = 0.1,
		attack_anim_events = {
			"attack_01",
			"attack_02",
			"attack_03",
			"attack_04",
		},
		attack_anim_damage_timings = {
			attack_01 = 0.43333333333333335,
			attack_02 = 0.4666666666666667,
			attack_03 = 0.4666666666666667,
			attack_04 = 0.5666666666666667,
		},
		attack_anim_durations = {
			attack_01 = 1.5666666666666667,
			attack_02 = 1.6666666666666667,
			attack_03 = 1.8333333333333333,
			attack_04 = 1.8333333333333333,
		},
		damage_profile = DamageProfileTemplates.melee_fighter_default,
	},
	open_door = {
		rotation_duration = 0.1,
		stagger_immune = true,
	},
	exit_spawner = {
		run_anim_event = "move_fwd",
	},
}

return action_data
