-- chunkname: @scripts/settings/breed/breed_actions/chaos/chaos_ogryn_bulwark_actions.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local action_data = {
	name = "chaos_ogryn_bulwark",
	idle = {
		rotate_towards_target = true,
		anim_events = {
			"idle",
		},
	},
	patrol = {
		anim_events = {
			"move_fwd_2",
		},
		speeds = {
			move_fwd_2 = 1.25,
		},
	},
	death = {
		instant_ragdoll_chance = 0.5,
		remove_linked_decals = true,
		death_animations = {
			[hit_zone_names.head] = {
				"death_shot_head_left",
				"death_decapitate",
			},
			[hit_zone_names.torso] = {
				"death_strike_chest_front",
				"death_strike_chest_back",
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
		vo_event = "assault",
		moving_alerted_anim_events = {
			bwd = "alerted_bwd",
			fwd = "alerted_fwd",
			left = "alerted_left",
			right = "alerted_right",
		},
		start_move_anim_data = {
			alerted_fwd = {
				rad = nil,
				sign = nil,
			},
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
		},
		start_move_rotation_timings = {
			alerted_bwd = 1.6333333333333333,
			alerted_fwd = nil,
			alerted_left = 0.5,
			alerted_right = 0.8666666666666667,
		},
		start_rotation_durations = {
			alerted_bwd = 1.4333333333333333,
			alerted_fwd = nil,
			alerted_left = 0.5666666666666667,
			alerted_right = 1.0666666666666667,
		},
		alerted_durations = {
			alerted_bwd = 5.7,
			alerted_fwd = 6.333333333333333,
			alerted_left = 6,
			alerted_right = 4.866666666666666,
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
		disable_anims = {
			pounced = {
				fwd = {
					"dog_leap_pinned",
				},
				bwd = {
					"dog_leap_pinned",
				},
				left = {
					"dog_leap_pinned",
				},
				right = {
					"dog_leap_pinned",
				},
			},
		},
		stand_anim = {
			duration = 4,
			name = "dog_leap_pinned_stand",
		},
	},
	jump_across = {
		rotation_duration = 0.1,
		stagger_immune = true,
		anim_timings = {
			jump_over_gap_4m = 1.1666666666666667,
			jump_over_gap_4m_2 = 1.1666666666666667,
		},
		ending_move_states = {
			jump_over_gap_4m = "jumping",
			jump_over_gap_4m_2 = "jumping",
		},
	},
	follow = {
		enter_walk_distance = 6,
		follow_vo_interval_t = 5,
		idle_anim_events = "idle",
		leave_walk_distance = 8,
		rotation_speed = 4,
		run_anim_event = "move_fwd",
		utility_weight = 1,
		vo_event = "assault",
		walk_anim_event = "move_fwd_walk",
		considerations = UtilityConsiderations.melee_follow,
		start_move_anim_events = {
			walking = {
				bwd = "move_bwd_walk",
				fwd = "move_fwd_walk",
				left = "move_left_walk",
				right = "move_right_walk",
			},
			running = {
				bwd = "move_start_bwd",
				fwd = "move_start_fwd",
				left = "move_start_left",
				right = "move_start_right",
			},
		},
		start_move_anim_data = {
			move_start_fwd = {
				rad = nil,
				sign = nil,
			},
			move_start_bwd = {
				sign = -1,
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
			move_start_bwd = 0.36666666666666664,
			move_start_fwd = 0,
			move_start_left = 0.5333333333333333,
			move_start_right = 0.36666666666666664,
		},
		start_rotation_durations = {
			move_start_bwd = 0.4666666666666667,
			move_start_fwd = 0.26666666666666666,
			move_start_left = 0.3333333333333333,
			move_start_right = 0.4,
		},
	},
	far_follow = {
		enter_walk_distance = 5,
		follow_vo_interval_t = 5,
		idle_anim_events = "idle",
		is_assaulting = true,
		leave_walk_distance = 7,
		run_anim_event = "move_fwd",
		utility_weight = 1,
		vo_event = "assault",
		walk_anim_event = "move_fwd_walk",
		considerations = UtilityConsiderations.melee_follow,
		start_move_anim_events = {
			walking = {
				bwd = "move_bwd_walk",
				fwd = "move_fwd_walk",
				left = "move_left_walk",
				right = "move_right_walk",
			},
			running = {
				bwd = "move_start_bwd",
				fwd = "move_start_fwd",
				left = "move_start_left",
				right = "move_start_right",
			},
		},
		start_move_anim_data = {
			move_start_fwd = {
				rad = nil,
				sign = nil,
			},
			move_start_bwd = {
				sign = -1,
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
			move_start_bwd = 0.36666666666666664,
			move_start_fwd = 0,
			move_start_left = 0.5333333333333333,
			move_start_right = 0.36666666666666664,
		},
		start_rotation_durations = {
			move_start_bwd = 0.4666666666666667,
			move_start_fwd = 0.26666666666666666,
			move_start_left = 0.3333333333333333,
			move_start_right = 0.4,
		},
	},
	melee_attack = {
		assault_vo_interval_t = 5,
		collision_filter = "filter_minion_melee",
		dodge_weapon_reach = 0.35,
		max_z_diff = 3,
		rotation_speed = 8,
		sweep_node = "j_righthandmiddle1",
		up_z_threshold = 2.5,
		utility_weight = 1,
		vo_event = "assault",
		considerations = UtilityConsiderations.bulwark_melee_attack,
		attack_anim_events = {
			normal = {
				"attack_01",
				"attack_02",
				"attack_03",
			},
			up = {
				"attack_reach_up",
			},
			down = {
				"attack_down_01",
			},
		},
		attack_sweep_damage_timings = {
			attack_01 = {
				0.9090909090909091,
				1.1818181818181819,
			},
			attack_02 = {
				0.8461538461538461,
				1.1538461538461537,
			},
			attack_03 = {
				1.4666666666666666,
				1.7333333333333334,
			},
			attack_down_01 = {
				1.1333333333333333,
				1.4,
			},
		},
		attack_anim_damage_timings = {
			attack_reach_up = 1.1794871794871795,
		},
		attack_anim_durations = {
			attack_01 = 2.6363636363636362,
			attack_02 = 2.1794871794871793,
			attack_03 = 2.8444444444444446,
			attack_down_01 = 3.3333333333333335,
			attack_reach_up = 2.6923076923076925,
		},
		attack_intensities = {
			melee = 2,
			ranged = 1,
		},
		damage_profile = DamageProfileTemplates.bulwark_melee,
		damage_type = damage_types.minion_melee_blunt_elite,
		attack_type = {
			attack_01 = "sweep",
			attack_02 = "sweep",
			attack_03 = "sweep",
			attack_down_01 = "sweep",
			attack_reach_up = nil,
		},
		weapon_reach = {
			attack_reach_up = 4,
			default = 1.1,
		},
		disable_shield_block_timing = {
			attack_01 = 0.45454545454545453,
			attack_02 = 0.1282051282051282,
			attack_03 = 1.1111111111111112,
		},
		enable_shield_block_timing = {
			attack_01 = 1.9696969696969697,
			attack_02 = 1.9230769230769231,
			attack_03 = 2.5555555555555554,
		},
		stagger_type_reduction = {
			melee = -30,
			stab = -20,
			uppercut = -30,
		},
	},
	shield_push = {
		ignore_dodge = true,
		rotation_speed = 10,
		utility_weight = 20,
		weapon_reach = 4,
		considerations = UtilityConsiderations.shield_push,
		attack_anim_events = {
			"shield_push",
		},
		attack_anim_damage_timings = {
			shield_push = 0.4666666666666667,
		},
		attack_anim_durations = {
			shield_push = 1,
		},
		attack_intensities = {
			melee = 3,
			ranged = 1,
		},
		damage_profile = DamageProfileTemplates.bulwark_shield_push,
		damage_type = damage_types.shield_push,
	},
	moving_melee_attack = {
		assault_vo_interval_t = 5,
		attack_type = "sweep",
		collision_filter = "filter_minion_melee",
		dodge_weapon_reach = 0.35,
		move_speed = 4,
		move_speed_variable_lerp_speed = 4,
		move_speed_variable_name = "moving_attack_fwd_speed",
		moving_attack = true,
		sweep_node = "j_righthandmiddle1",
		utility_weight = 10,
		vo_event = "assault",
		weapon_reach = 1.1,
		considerations = UtilityConsiderations.chaos_ogryn_bulwark_moving_melee_attack,
		attack_anim_events = {
			"attack_move_01",
		},
		attack_sweep_damage_timings = {
			attack_move_01 = {
				1.0606060606060606,
				1.303030303030303,
			},
		},
		attack_anim_durations = {
			attack_move_01 = 2.4242424242424243,
		},
		attack_intensities = {
			melee = 2,
			moving_melee = 3,
			ranged = 1,
			running_melee = 3,
		},
		move_start_timings = {
			attack_move_01 = 0.15151515151515152,
		},
		damage_profile = DamageProfileTemplates.bulwark_melee,
		damage_type = damage_types.minion_melee_blunt_elite,
		disable_shield_block_timing = {
			attack_move_01 = 0.9090909090909091,
		},
		enable_shield_block_timing = {
			attack_move_01 = 2.121212121212121,
		},
		animation_move_speed_configs = {
			attack_move_01 = {
				{
					distance = 2.61,
					value = 4,
				},
				{
					distance = 1.39,
					value = 3,
				},
				{
					distance = 1.12,
					value = 2,
				},
				{
					distance = 0.12,
					value = 1,
				},
				{
					distance = 0.06,
					value = 0,
				},
			},
		},
		stagger_type_reduction = {
			melee = -30,
			stab = -20,
			uppercut = -30,
		},
	},
	blocked = {
		blocked_duration = 1.6666666666666667,
		blocked_anims = {
			"blocked",
		},
		disable_shield_block_timing = {
			blocked = 0,
		},
		enable_shield_block_timing = {
			blocked = 0.6666666666666666,
		},
	},
	stagger = {
		ignore_extra_stagger_duration = true,
		disable_shield_block_timing = {
			stagger_bwd_heavy = 0,
			stagger_bwd_sticky = 0,
			stagger_bwd_sticky_2 = 0,
			stagger_bwd_sticky_3 = 0,
			stagger_dwn_heavy = 0,
			stagger_explosion_back = 0,
			stagger_explosion_front = 0,
			stagger_explosion_left = 0,
			stagger_explosion_right = 0,
			stagger_front_sticky = 0,
			stagger_front_sticky_2 = 0,
			stagger_front_sticky_3 = 0,
			stagger_fwd_heavy = 0,
			stagger_fwd_light = 0.5,
			stagger_left_heavy = 0,
			stagger_left_sticky = 0,
			stagger_left_sticky_2 = 0,
			stagger_left_sticky_3 = 0,
			stagger_right_heavy = 0,
			stagger_right_sticky = 0,
			stagger_right_sticky_2 = 0,
			stagger_right_sticky_3 = 0,
			stagger_shield_break_01 = 0.3333333333333333,
			stagger_shield_break_02 = 0.3333333333333333,
			stagger_shield_break_03 = 0.3333333333333333,
			stagger_shield_break_04 = 0.3333333333333333,
			stagger_shield_break_05 = 0.3333333333333333,
			stagger_shield_damage_01 = 0,
			stagger_shield_damage_01_fast = 0,
			stagger_shield_damage_02 = 0,
			stagger_shield_damage_02_fast = 0,
			stagger_shield_damage_03 = 0,
			stagger_shield_damage_03_fast = 0,
			stagger_shield_damage_04 = 0,
			stagger_shield_damage_04_fast = 0,
		},
		enable_shield_block_timing = {
			stagger_bwd_heavy = 104.33333333333333,
			stagger_bwd_sticky = 2,
			stagger_bwd_sticky_2 = 2,
			stagger_bwd_sticky_3 = 2,
			stagger_dwn_heavy = 104.33333333333333,
			stagger_explosion_back = 3,
			stagger_explosion_front = 3,
			stagger_explosion_left = 3,
			stagger_explosion_right = 3,
			stagger_front_sticky = 2,
			stagger_front_sticky_2 = 2,
			stagger_front_sticky_3 = 2,
			stagger_fwd_heavy = 104.33333333333333,
			stagger_fwd_light = 1.5,
			stagger_left_heavy = 104.33333333333333,
			stagger_left_sticky = 2,
			stagger_left_sticky_2 = 2,
			stagger_left_sticky_3 = 2,
			stagger_right_heavy = 104.33333333333333,
			stagger_right_sticky = 2,
			stagger_right_sticky_2 = 2,
			stagger_right_sticky_3 = 2,
			stagger_shield_break_01 = 104.48717948717949,
			stagger_shield_break_02 = 112.48717948717949,
			stagger_shield_break_03 = 104.48717948717949,
			stagger_shield_break_04 = 104.48717948717949,
			stagger_shield_break_05 = 122.48717948717949,
			stagger_shield_damage_01 = 109.48717948717949,
			stagger_shield_damage_01_fast = 109.55555555555556,
			stagger_shield_damage_02 = 134.48717948717947,
			stagger_shield_damage_02_fast = 119.55555555555556,
			stagger_shield_damage_03 = 139.48717948717947,
			stagger_shield_damage_03_fast = 129.55555555555554,
			stagger_shield_damage_04 = 119.48717948717949,
			stagger_shield_damage_04_fast = 109.55555555555556,
		},
		stagger_duration_mods = {
			stagger_shield_block_01 = 0.8,
			stagger_shield_block_05 = 1.4,
			stagger_shield_block_left = 1.28,
			stagger_shield_block_right = 1.44,
			stagger_shield_damage_01 = 1.05,
			stagger_shield_damage_02 = 1.2,
			stagger_shield_damage_03 = 1.4,
			stagger_shield_damage_04 = 1.2,
		},
		stagger_anims = {
			light = {
				bwd = {
					"stagger_shield_damage_01_fast",
					"stagger_shield_damage_02_fast",
					"stagger_shield_damage_03_fast",
					"stagger_shield_damage_04_fast",
				},
				left = {
					"stagger_shield_damage_01_fast",
					"stagger_shield_damage_02_fast",
					"stagger_shield_damage_03_fast",
					"stagger_shield_damage_04_fast",
				},
				right = {
					"stagger_shield_damage_01_fast",
					"stagger_shield_damage_02_fast",
					"stagger_shield_damage_03_fast",
					"stagger_shield_damage_04_fast",
				},
				dwn = {
					"stagger_shield_damage_01_fast",
					"stagger_shield_damage_02_fast",
					"stagger_shield_damage_03_fast",
					"stagger_shield_damage_04_fast",
				},
				fwd = {
					"stagger_fwd_light",
				},
			},
			medium = {
				bwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				left = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				right = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				dwn = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				fwd = {
					"stagger_fwd_light",
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
				bwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				left = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				right = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				dwn = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				fwd = {
					"stagger_fwd_light",
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
				bwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				left = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				right = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				dwn = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				fwd = {
					"stagger_fwd_light",
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
			shield_block = {
				fwd = {
					"stagger_shield_block_01",
					"stagger_shield_block_02",
					"stagger_shield_block_03",
					"stagger_shield_block_04",
					"stagger_shield_block_05",
				},
				bwd = {
					"stagger_shield_block_01",
					"stagger_shield_block_02",
					"stagger_shield_block_03",
					"stagger_shield_block_04",
					"stagger_shield_block_05",
				},
				left = {
					"stagger_shield_block_left",
				},
				right = {
					"stagger_shield_block_right",
				},
				dwn = {
					"stagger_shield_block_01",
					"stagger_shield_block_02",
					"stagger_shield_block_03",
					"stagger_shield_block_04",
					"stagger_shield_block_05",
				},
			},
			shield_heavy_block = {
				fwd = {
					"stagger_shield_break_01",
					"stagger_shield_break_02",
					"stagger_shield_break_03",
					"stagger_shield_break_04",
					"stagger_shield_break_05",
				},
				bwd = {
					"stagger_shield_break_01",
					"stagger_shield_break_02",
					"stagger_shield_break_03",
					"stagger_shield_break_04",
					"stagger_shield_break_05",
				},
				left = {
					"stagger_shield_break_01",
					"stagger_shield_break_02",
					"stagger_shield_break_03",
					"stagger_shield_break_04",
					"stagger_shield_break_05",
				},
				right = {
					"stagger_shield_break_01",
					"stagger_shield_break_02",
					"stagger_shield_break_03",
					"stagger_shield_break_04",
					"stagger_shield_break_05",
				},
				dwn = {
					"stagger_shield_break_01",
					"stagger_shield_break_02",
					"stagger_shield_break_03",
					"stagger_shield_break_04",
					"stagger_shield_break_05",
				},
			},
			shield_broken = {
				fwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				bwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				left = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				right = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				dwn = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
			},
			blinding = {
				bwd = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				left = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				right = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				dwn = {
					"stagger_shield_damage_01",
					"stagger_shield_damage_02",
					"stagger_shield_damage_03",
					"stagger_shield_damage_04",
				},
				fwd = {
					"stagger_fwd_light",
				},
			},
		},
	},
	smash_obstacle = {
		damage_type = nil,
		rotation_duration = 0.1,
		attack_anim_events = {
			"attack_01",
			"attack_02",
			"attack_03",
		},
		attack_anim_damage_timings = {
			attack_01 = 1.264367816091954,
			attack_02 = 1.264367816091954,
			attack_03 = 1.1954022988505748,
			attack_04 = 0.6,
			attack_05 = 0.6,
			attack_06 = 0.6,
			attack_07 = 0.6,
		},
		attack_anim_durations = {
			attack_01 = 2.413793103448276,
			attack_02 = 2.5977011494252875,
			attack_03 = 2.9885057471264367,
			attack_04 = 1.728395061728395,
			attack_05 = 2.0987654320987654,
			attack_06 = 1.7241379310344827,
			attack_07 = 2.0987654320987654,
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
	use_stim = {
		anim_event = "use_syringe",
		duration = 1.3333333333333333,
		exit_state = "to_bulwark",
		special_visual_wield_considerations = "slot_melee_weapon",
		effect_template = EffectTemplates.minion_stim_effect,
		stim_buffs = {
			"mutator_stimmed_minion_red",
			"mutator_stimmed_minion_yellow",
			"mutator_stimmed_minion_green",
			"mutator_stimmed_minion_blue",
		},
	},
}

return action_data
