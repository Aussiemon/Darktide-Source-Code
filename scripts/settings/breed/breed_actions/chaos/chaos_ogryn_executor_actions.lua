-- chunkname: @scripts/settings/breed/breed_actions/chaos/chaos_ogryn_executor_actions.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GroundImpactFxTemplates = require("scripts/settings/fx/ground_impact_fx_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local action_data = {
	name = "chaos_ogryn_executor",
	idle = {
		rotate_towards_target = true,
		anim_events = {
			"idle",
			"idle_2",
		},
	},
	patrol = {
		anim_events = {
			"move_fwd_1",
			"move_fwd_2",
		},
		speeds = {
			move_fwd_1 = 1.2,
			move_fwd_2 = 1.2,
		},
	},
	death = {
		5,
		instant_ragdoll_chance = 0,
		death_animations = {
			[hit_zone_names.head] = {
				"death_shot_head_left",
				"death_decapitate",
			},
			[hit_zone_names.torso] = {
				"death_strike_chest_front",
				"death_strike_chest_back",
				"death_burn",
			},
			[hit_zone_names.upper_left_arm] = {
				"death_arm_left",
			},
			[hit_zone_names.lower_left_arm] = {
				"death_arm_left",
			},
			[hit_zone_names.upper_right_arm] = {
				"death_arm_right",
			},
			[hit_zone_names.lower_right_arm] = {
				"death_arm_right",
			},
			[hit_zone_names.upper_left_leg] = {
				"death_leg_left",
			},
			[hit_zone_names.lower_left_leg] = {
				"death_leg_left",
			},
			[hit_zone_names.upper_right_leg] = {
				"death_leg_right",
			},
			[hit_zone_names.lower_right_leg] = {
				"death_leg_right",
			},
		},
		ragdoll_timings = {
			death_arm_left = 6,
			death_arm_right = 3.8666666666666667,
			death_burn = 6.333333333333333,
			death_decapitate = 2.1333333333333333,
			death_leg_left = 0.8333333333333334,
			death_leg_right = 0.6666666666666666,
			death_shot_head_left = 3.066666666666667,
			death_strike_chest_back = 2.7666666666666666,
			death_strike_chest_front = 1.6666666666666667,
		},
	},
	combat_idle = {
		anim_events = "idle",
		rotate_towards_target = true,
		utility_weight = 2,
		considerations = UtilityConsiderations.melee_combat_idle,
	},
	alerted = {
		override_aggro_distance = 8,
		vo_event = "alerted_idle",
		moving_alerted_anim_events = {
			bwd = "alerted_bwd",
			fwd = "alerted_fwd",
			left = "alerted_left",
			right = "alerted_right",
		},
		start_move_anim_data = {
			alerted_fwd = {},
			alerted_bwd = {
				sign = -1,
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
		},
		start_move_rotation_timings = {
			alerted_bwd = 3.3666666666666667,
			alerted_left = 3.6666666666666665,
			alerted_right = 3.7333333333333334,
		},
		start_rotation_durations = {
			alerted_bwd = 0.4666666666666667,
			alerted_left = 4.4,
			alerted_right = 4.566666666666666,
		},
		alerted_durations = {
			alerted_bwd = 5.666666666666667,
			alerted_fwd = 3.8333333333333335,
			alerted_left = 5.5,
			alerted_right = 6.233333333333333,
		},
	},
	climb = {
		rotation_duration = 0.1,
		stagger_immune = true,
		anim_timings = {
			jump_down_land = 1.3333333333333333,
			jump_up_1m = 1.2424242424242424,
			jump_up_1m_2 = 1.2424242424242424,
			jump_up_2m = 1.2424242424242424,
			jump_up_3m = 2.923076923076923,
			jump_up_3m_2 = 2.923076923076923,
			jump_up_5m = 4.166666666666667,
			jump_up_fence_1m = 0.6,
			jump_up_fence_2m = 0.6,
			jump_up_fence_3m = 1.4,
			jump_up_fence_5m = 1.3,
		},
		land_timings = {
			jump_down_1m = 0.2,
			jump_down_1m_2 = 0.2,
			jump_down_3m = 0.3333333333333333,
			jump_down_3m_2 = 0.3333333333333333,
			jump_down_fence_1m = 0.26666666666666666,
			jump_down_fence_3m = 0.3333333333333333,
			jump_down_fence_5m = 0.3333333333333333,
		},
		ending_move_states = {
			jump_down_land = "jumping",
			jump_up_1m = "jumping",
			jump_up_1m_2 = "jumping",
			jump_up_2m = "jumping",
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
			jump_up_2m = 0.1,
			jump_up_3m = 0.1,
			jump_up_3m_2 = 0.1,
			jump_up_5m = 0.1,
			jump_up_fence_1m = 0.2,
			jump_up_fence_2m = 0.2,
			jump_up_fence_3m = 0.2,
			jump_up_fence_5m = 0.2,
		},
	},
	disable = {
		disable_anims = {},
	},
	jump_across = {
		rotation_duration = 0.1,
		stagger_immune = true,
		anim_timings = {
			jump_over_gap_4m = 1.2333333333333334,
			jump_over_gap_4m_2 = 1.2333333333333334,
		},
		ending_move_states = {
			jump_over_gap_4m = "jumping",
			jump_over_gap_4m_2 = "jumping",
		},
	},
	follow = {
		enter_walk_distance = 6,
		follow_vo_interval_t = 3,
		idle_anim_events = "idle",
		leave_walk_distance = 10,
		run_anim_event = "move_fwd",
		utility_weight = 1,
		vo_event = "assault",
		walk_anim_event = "move_fwd_walk",
		considerations = UtilityConsiderations.melee_follow,
		start_move_anim_events = {
			walking = {
				bwd = "move_bwd_walk",
				left = "move_left_walk",
				right = "move_right_walk",
				fwd = {
					"move_fwd_walk",
					"move_fwd_walk_2",
					"move_fwd_walk_3",
				},
			},
			running = {
				bwd = "move_start_bwd",
				fwd = "move_start_fwd",
				left = "move_start_left",
				right = "move_start_right",
			},
		},
		start_move_anim_data = {
			move_start_fwd = {},
			move_start_bwd = {
				sign = 1,
				rad = math.pi,
			},
			move_start_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			move_start_right = {
				sign = -1,
				rad = math.pi / 2,
			},
		},
		start_move_rotation_timings = {
			move_start_bwd = 0,
			move_start_fwd = 0,
			move_start_left = 0,
			move_start_right = 0,
		},
		start_rotation_durations = {
			move_start_bwd = 1.4333333333333333,
			move_start_fwd = 0.26666666666666666,
			move_start_left = 1.5,
			move_start_right = 1.4333333333333333,
		},
		start_move_event_anim_speed_durations = {
			move_start_fwd = 1.2666666666666666,
		},
	},
	melee_attack = {
		aoe_threat_timing = 0.4,
		ignore_blocked = false,
		max_z_diff = 3,
		utility_weight = 5,
		considerations = UtilityConsiderations.chaos_ogryn_executor_melee_attack,
		attack_anim_events = {
			normal = {
				"attack_03",
				"attack_04",
				"attack_05",
				"attack_06",
			},
			up = {
				"attack_reach_up",
			},
			down = {
				"attack_down_01",
			},
		},
		attack_anim_damage_timings = {
			attack_03 = 0.7272727272727273,
			attack_04 = 0.5747126436781609,
			attack_05 = 0.6206896551724138,
			attack_06 = 0.5057471264367817,
			attack_down_01 = 1.0666666666666667,
			attack_reach_up = 0.6923076923076923,
		},
		attack_anim_durations = {
			attack_03 = 1.8484848484848484,
			attack_04 = 1.3793103448275863,
			attack_05 = 1.6091954022988506,
			attack_06 = 1.7241379310344827,
			attack_down_01 = 2.6666666666666665,
			attack_reach_up = 1.7435897435897436,
		},
		attack_intensities = {
			melee = 3,
			ranged = 1,
		},
		damage_profile = DamageProfileTemplates.chaos_ogryn_executor_default,
		damage_type = damage_types.minion_melee_blunt_elite,
		weapon_reach = {
			attack_reach_up = 4,
			default = 3.75,
		},
		stagger_type_reduction = {
			melee = 50,
			ranged = 50,
		},
	},
	melee_attack_cleave = {
		assault_vo_interval_t = 3,
		attack_type = "oobb",
		bot_power_level_modifier = 0.25,
		collision_filter = "filter_minion_melee_friendly_fire",
		dodge_range = 2.75,
		dodge_width = 1.1,
		height = 3,
		range = 4,
		utility_weight = 5,
		vo_event = "assault",
		width = 2,
		considerations = UtilityConsiderations.chaos_ogryn_executor_cleave_melee_attack,
		attack_anim_events = {
			"attack_01",
			"attack_02",
			"attack_07",
			"attack_08",
		},
		attack_anim_damage_timings = {
			attack_01 = 1.471264367816092,
			attack_02 = 1.3103448275862069,
			attack_07 = 1.6551724137931034,
			attack_08 = 1.5862068965517242,
		},
		attack_anim_durations = {
			attack_01 = 3.103448275862069,
			attack_02 = 2.8735632183908044,
			attack_07 = 3.67816091954023,
			attack_08 = 3.310344827586207,
		},
		attack_intensities = {
			melee = 4,
			ranged = 1,
		},
		damage_profile = DamageProfileTemplates.chaos_ogryn_executor_cleave,
		damage_type = damage_types.minion_melee_blunt_elite,
		ground_impact_fx_template = GroundImpactFxTemplates.chaos_ogryn_executor_cleave,
		stagger_type_reduction = {
			melee = 50,
			ranged = 50,
		},
	},
	melee_attack_pommel = {
		ignore_blocked = false,
		utility_weight = 0.4,
		weapon_reach = 3.5,
		considerations = UtilityConsiderations.melee_attack,
		attack_anim_events = {
			"attack_pommel_01",
		},
		attack_anim_damage_timings = {
			attack_pommel_01 = 0.49382716049382713,
		},
		attack_anim_durations = {
			attack_pommel_01 = 1.7777777777777777,
		},
		attack_intensities = {
			melee = 2,
			ranged = 1,
		},
		damage_profile = DamageProfileTemplates.chaos_ogryn_executor_pommel,
		damage_type = damage_types.minion_ogryn_executor_pommel,
	},
	melee_attack_kick = {
		ignore_blocked = false,
		utility_weight = 3,
		weapon_reach = 3.5,
		considerations = UtilityConsiderations.melee_attack,
		attack_anim_events = {
			"attack_push_kick_01",
		},
		attack_anim_damage_timings = {
			attack_push_kick_01 = 0.7407407407407407,
		},
		attack_anim_durations = {
			attack_push_kick_01 = 1.9753086419753085,
		},
		attack_intensities = {
			melee = 2,
			ranged = 1,
		},
		stagger_type_reduction = {
			melee = 50,
			ranged = 50,
		},
		damage_profile = DamageProfileTemplates.chaos_ogryn_executor_kick,
		damage_type = damage_types.minion_ogryn_kick,
	},
	melee_attack_punch = {
		ignore_blocked = false,
		utility_weight = 0.4,
		weapon_reach = 3.5,
		considerations = UtilityConsiderations.melee_attack,
		attack_anim_events = {
			"attack_push_punch_01",
			"attack_push_punch_02",
			"attack_push_punch_03",
			"attack_push_punch_04",
			"attack_push_punch_05",
			"attack_push_punch_06",
		},
		attack_anim_damage_timings = {
			attack_push_punch_01 = 0.4444444444444444,
			attack_push_punch_02 = 0.5185185185185185,
			attack_push_punch_03 = 0.41975308641975306,
			attack_push_punch_04 = 0.5679012345679012,
			attack_push_punch_05 = 0.691358024691358,
			attack_push_punch_06 = 0.6944444444444444,
		},
		attack_anim_durations = {
			attack_push_punch_01 = 1.3580246913580247,
			attack_push_punch_02 = 1.308641975308642,
			attack_push_punch_03 = 1.4814814814814814,
			attack_push_punch_04 = 1.728395061728395,
			attack_push_punch_05 = 1.6790123456790123,
			attack_push_punch_06 = 1.9444444444444444,
		},
		attack_intensities = {
			melee = 2,
			ranged = 1,
		},
		stagger_type_reduction = {
			melee = 50,
			ranged = 50,
		},
		damage_profile = DamageProfileTemplates.chaos_ogryn_executor_punch,
		damage_type = damage_types.minion_ogryn_punch,
	},
	moving_melee_attack = {
		aoe_threat_timing = 0.4,
		assault_vo_interval_t = 3,
		ignore_blocked = false,
		move_speed = 4,
		move_speed_variable_lerp_speed = 4,
		move_speed_variable_name = "moving_attack_fwd_speed",
		moving_attack = true,
		utility_weight = 1,
		vo_event = "assault",
		weapon_reach = 4,
		considerations = UtilityConsiderations.chaos_ogryn_executor_moving_melee_attack,
		attack_anim_events = {
			"attack_move_02",
			"attack_move_03",
		},
		attack_anim_damage_timings = {
			attack_move_02 = 1.3333333333333333,
			attack_move_03 = 1.0555555555555556,
		},
		attack_anim_durations = {
			attack_move_02 = 2.6666666666666665,
			attack_move_03 = 2.361111111111111,
		},
		attack_intensities = {
			melee = 3,
			moving_melee = 3,
			ranged = 1,
			running_melee = 3,
		},
		move_start_timings = {
			attack_move_02 = 0.1388888888888889,
			attack_move_03 = 0.1388888888888889,
		},
		damage_profile = DamageProfileTemplates.chaos_ogryn_executor_default,
		damage_type = damage_types.minion_melee_blunt_elite,
		stagger_type_reduction = {
			melee = 60,
			ranged = 60,
		},
		animation_move_speed_configs = {
			attack_move_02 = {
				{
					distance = 5.7,
					value = 4,
				},
				{
					distance = 4.18,
					value = 3,
				},
				{
					distance = 3.53,
					value = 2,
				},
				{
					distance = 2.79,
					value = 1,
				},
				{
					distance = 1.84,
					value = 0,
				},
			},
			attack_move_03 = {
				{
					distance = 5.7,
					value = 4,
				},
				{
					distance = 4.18,
					value = 3,
				},
				{
					distance = 3.53,
					value = 2,
				},
				{
					distance = 2.79,
					value = 1,
				},
				{
					distance = 1.84,
					value = 0,
				},
			},
		},
	},
	moving_melee_attack_cleave = {
		assault_vo_interval_t = 3,
		attack_type = "oobb",
		bot_power_level_modifier = 0.25,
		collision_filter = "filter_minion_melee_friendly_fire",
		dodge_range = 2.75,
		dodge_width = 1.1,
		height = 3,
		ignore_blocked = false,
		move_speed = 4,
		move_speed_variable_lerp_speed = 4,
		move_speed_variable_name = "moving_attack_fwd_speed",
		moving_attack = true,
		range = 4,
		utility_weight = 2,
		vo_event = "assault",
		width = 2,
		considerations = UtilityConsiderations.chaos_ogryn_executor_moving_melee_attack,
		attack_anim_events = {
			"attack_move_01",
		},
		attack_anim_damage_timings = {
			attack_move_01 = 1.5308641975308641,
		},
		attack_anim_durations = {
			attack_move_01 = 2.8395061728395063,
		},
		attack_intensities = {
			melee = 3,
			moving_melee = 3,
			ranged = 1,
			running_melee = 3,
		},
		move_start_timings = {
			attack_move_01 = 0.12345679012345678,
		},
		damage_profile = DamageProfileTemplates.chaos_ogryn_executor_cleave,
		damage_type = damage_types.minion_melee_blunt_elite,
		stagger_type_reduction = {
			melee = 60,
			ranged = 60,
		},
		animation_move_speed_configs = {
			attack_move_01 = {
				{
					distance = 5.5,
					value = 2,
				},
				{
					distance = 4.36,
					value = 1,
				},
				{
					distance = 2.16,
					value = 0,
				},
			},
		},
		ground_impact_fx_template = GroundImpactFxTemplates.chaos_ogryn_executor_cleave,
	},
	blocked = {
		blocked_duration = 1.6666666666666667,
		blocked_anims = {
			"blocked",
		},
	},
	stagger = {
		stagger_anims = {
			light = {
				fwd = {
					"stagger_fwd_light",
				},
				bwd = {
					"stagger_bwd_light",
				},
				left = {
					"stagger_left_light",
				},
				right = {
					"stagger_right_light",
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
					"stagger_medium_downward",
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
					"stagger_down_heavy",
				},
			},
			light_ranged = {
				fwd = {
					"stagger_fwd_light",
				},
				bwd = {
					"stagger_bwd_light",
				},
				left = {
					"stagger_left_light",
				},
				right = {
					"stagger_right_light",
				},
				dwn = {
					"stun_down",
				},
			},
			explosion = {
				fwd = {
					"stagger_explosion_fwd",
				},
				bwd = {
					"stagger_explosion_bwd",
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
					"stagger_fwd_light",
				},
				bwd = {
					"stagger_bwd_light",
				},
				left = {
					"stagger_left_light",
				},
				right = {
					"stagger_right_light",
				},
				dwn = {
					"stun_down",
				},
			},
			sticky = {
				bwd = {
					"stagger_front_sticky",
					"stagger_front_sticky_2",
					"stagger_front_sticky_3",
				},
				fwd = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
				left = {
					"stagger_left_sticky",
					"stagger_left_sticky_2",
					"stagger_left_sticky_3",
				},
				right = {
					"stagger_right_sticky",
					"stagger_right_sticky_2",
					"stagger_right_sticky_3",
				},
				dwn = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
			},
			electrocuted = {
				bwd = {
					"stagger_front_sticky",
					"stagger_front_sticky_2",
					"stagger_front_sticky_3",
				},
				fwd = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
				left = {
					"stagger_left_sticky",
					"stagger_left_sticky_2",
					"stagger_left_sticky_3",
				},
				right = {
					"stagger_right_sticky",
					"stagger_right_sticky_2",
					"stagger_right_sticky_3",
				},
				dwn = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3",
				},
			},
			blinding = {
				fwd = {
					"stagger_fwd_light",
				},
				bwd = {
					"stagger_bwd_light",
				},
				left = {
					"stagger_left_light",
				},
				right = {
					"stagger_right_light",
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
			attack_01 = 0.6,
			attack_02 = 0.6,
			attack_03 = 0.6,
			attack_04 = 0.6,
		},
		attack_anim_durations = {
			attack_01 = 1.7241379310344827,
			attack_02 = 1.7241379310344827,
			attack_03 = 1.7241379310344827,
			attack_04 = 1.728395061728395,
		},
		damage_profile = DamageProfileTemplates.chaos_ogryn_executor_default,
		damage_type = damage_types.minion_melee_blunt_elite,
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
