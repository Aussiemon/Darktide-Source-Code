-- chunkname: @scripts/settings/breed/breed_actions/cultist/cultist_vanguard_actions.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local action_data = {
	name = "cultist_vanguard",
	idle = {
		rotate_towards_target = true,
		vo_event = "passive_idle",
		anim_events = {
			"idle_2",
		},
	},
	patrol = {
		anim_events = {
			"move_fwd_1",
			"move_fwd_2",
			"move_fwd_3",
		},
		idle_anim_events = {
			"idle",
			"idle_2",
		},
		speeds = {
			move_fwd_1 = 1.1,
			move_fwd_2 = 1.1,
			move_fwd_3 = 1.1,
		},
	},
	death = {
		instant_ragdoll_chance = 0.5,
		death_animations = {
			[hit_zone_names.head] = {
				"death_shot_head_front",
				"death_shot_head_fwd",
				"death_shot_head_left",
				"death_shot_head_right",
				"death_shot_head_bwd",
				"death_decapitate_3",
			},
			[hit_zone_names.torso] = {
				"death_stab_chest_front",
				"death_stab_chest_back",
				"death_slash_left",
				"death_slash_right",
				"death_strike_chest_front",
				"death_strike_chest_back",
				"death_strike_chest_left",
				"death_strike_chest_right",
			},
			[hit_zone_names.upper_left_arm] = {
				"death_arm_left",
				"death_arm_left_2",
				"death_arm_left_3",
			},
			[hit_zone_names.lower_left_arm] = {
				"death_arm_left",
				"death_arm_left_2",
				"death_arm_left_3",
			},
			[hit_zone_names.upper_right_arm] = {
				"death_arm_right",
				"death_arm_right_2",
				"death_arm_right_3",
			},
			[hit_zone_names.lower_right_arm] = {
				"death_arm_right",
				"death_arm_right_2",
				"death_arm_right_3",
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
			death_arm_left = 3.033333333333333,
			death_arm_left_2 = 4,
			death_arm_left_3 = 3.9,
			death_arm_right = 5.1,
			death_arm_right_2 = 4.233333333333333,
			death_arm_right_3 = 2.566666666666667,
			death_decapitate_3 = 1.4,
			death_leg_left = 3.066666666666667,
			death_leg_right = 4.5,
			death_shot_head_bwd = 3.3333333333333335,
			death_shot_head_front = 1.4666666666666666,
			death_shot_head_fwd = 2.3666666666666667,
			death_shot_head_left = 2.1,
			death_shot_head_right = 4.566666666666666,
			death_slash_left = 3.2666666666666666,
			death_slash_right = 2.6666666666666665,
			death_stab_chest_back = 2.5,
			death_stab_chest_front = 3.6333333333333333,
			death_strike_chest_back = 3.1666666666666665,
			death_strike_chest_front = 1.6666666666666667,
			death_strike_chest_left = 3.2,
			death_strike_chest_right = 1.2666666666666666,
		},
	},
	combat_idle = {
		rotate_towards_target = true,
		utility_weight = 2,
		vo_event = "melee_idle",
		considerations = UtilityConsiderations.melee_combat_idle,
		anim_events = {
			"idle_2",
		},
	},
	alerted = {
		hesitate_chance = 0.5,
		instant_aggro_chance = 0,
		override_aggro_distance = 8,
		vo_event = "alerted_idle",
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
			"hesitate_1",
			"hesitate_2",
			"alerted",
			"alerted_2",
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
			alerted_fwd_2 = {
				rad = nil,
				sign = nil,
			},
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
			alerted_fwd_3 = {
				rad = nil,
				sign = nil,
			},
			alerted_bwd_3 = {
				sign = 1,
				rad = math.pi,
			},
			alerted_left_3 = {
				sign = 1,
				rad = math.pi / 2,
			},
			alerted_right_3 = {
				sign = -1,
				rad = math.pi / 2,
			},
		},
		start_move_rotation_timings = {
			alerted_bwd = 0,
			alerted_bwd_2 = 0,
			alerted_bwd_3 = 0,
			alerted_fwd = nil,
			alerted_fwd_2 = nil,
			alerted_fwd_3 = nil,
			alerted_left = 0,
			alerted_left_2 = 0,
			alerted_left_3 = 0,
			alerted_right = 0,
			alerted_right_2 = 0,
			alerted_right_3 = 0,
		},
		start_rotation_durations = {
			alerted_bwd = 3.8,
			alerted_bwd_2 = 3.5,
			alerted_bwd_3 = 3.8,
			alerted_fwd = nil,
			alerted_fwd_2 = nil,
			alerted_fwd_3 = nil,
			alerted_left = 1.5,
			alerted_left_2 = 2.1666666666666665,
			alerted_left_3 = 1.5,
			alerted_right = 1.4,
			alerted_right_2 = 0.8,
			alerted_right_3 = 1.4,
		},
		alerted_durations = {
			alerted_bwd = 4.433333333333334,
			alerted_bwd_2 = 5.1,
			alerted_bwd_3 = 4.433333333333334,
			alerted_fwd = 4.5,
			alerted_fwd_2 = 3.9,
			alerted_fwd_3 = 4.5,
			alerted_left = 3.3333333333333335,
			alerted_left_2 = 3.9,
			alerted_left_3 = 3.3333333333333335,
			alerted_right = 4.466666666666667,
			alerted_right_2 = 3.9,
			alerted_right_3 = 4.466666666666667,
			hesitate_1 = {
				2.6666666666666665,
				6.333333333333333,
			},
			hesitate_2 = {
				1.3333333333333333,
				5.333333333333333,
			},
			alerted = {
				2,
				6.666666666666667,
			},
			alerted_2 = {
				2.6666666666666665,
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
		enter_walk_distance = 3,
		follow_vo_interval_t = 1,
		idle_anim_events = "idle",
		leave_walk_distance = 6,
		move_speed = 4.5,
		rotation_speed = 5,
		run_anim_event = "move_fwd",
		use_animation_running_stagger_speed = true,
		utility_weight = 1,
		vo_event = "melee_idle",
		walk_anim_event = "move_fwd_walk",
		considerations = UtilityConsiderations.melee_follow,
		walk_speeds = {
			move_fwd_walk = 2,
		},
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
			move_start_bwd = 0.16666666666666666,
			move_start_fwd = 0,
			move_start_left = 0.16666666666666666,
			move_start_right = 0.16666666666666666,
		},
		start_rotation_durations = {
			move_start_bwd = 1,
			move_start_fwd = 0.26666666666666666,
			move_start_left = 0.7666666666666667,
			move_start_right = 0.7,
		},
		start_move_event_anim_speed_durations = {
			move_start_fwd = 1.0666666666666667,
		},
		running_stagger_anim_left = {
			"run_stagger_01",
			"run_stagger_03",
		},
		running_stagger_anim_right = {
			"run_stagger_02",
			"run_stagger_03",
		},
		running_stagger_duration = {
			run_stagger_01 = 1.3666666666666667,
			run_stagger_02 = 1.5,
			run_stagger_03 = 1.3333333333333333,
		},
	},
	assault_follow = {
		controlled_stagger = true,
		controlled_stagger_ignored_combat_range = "melee",
		controlled_stagger_min_speed = 2,
		enter_walk_distance = 2,
		follow_vo_interval_t = 1,
		force_move_anim_event = "assault_fwd",
		idle_anim_events = "idle",
		is_assaulting = true,
		leave_walk_distance = 4,
		move_speed = 5.6,
		rotation_speed = 6,
		run_anim_event = "assault_fwd",
		use_animation_running_stagger_speed = true,
		vo_event = "assault",
		walk_anim_event = "move_fwd_walk",
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
				right = "move_start_assault_right",
			},
		},
		start_move_anim_data = {
			move_start_assault_fwd = {
				rad = nil,
				sign = nil,
			},
			move_start_assault_bwd = {
				sign = -1,
				rad = math.pi,
			},
			move_start_assault_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			move_start_assault_right = {
				sign = -1,
				rad = math.pi / 2,
			},
		},
		start_move_rotation_timings = {
			move_start_assault_bwd = 0,
			move_start_assault_fwd = 0,
			move_start_assault_left = 0,
			move_start_assault_right = 0,
		},
		start_rotation_durations = {
			move_start_assault_bwd = 0.26666666666666666,
			move_start_assault_fwd = 1.0666666666666667,
			move_start_assault_left = 0.26666666666666666,
			move_start_assault_right = 0.26666666666666666,
		},
		start_move_event_anim_speed_durations = {
			move_start_assault_fwd = 1.0666666666666667,
		},
		running_stagger_anim_left = {
			"run_stagger_01",
			"run_stagger_03",
		},
		running_stagger_anim_right = {
			"run_stagger_02",
			"run_stagger_03",
		},
		running_stagger_duration = {
			run_stagger_01 = 1.3666666666666667,
			run_stagger_02 = 1.5,
			run_stagger_03 = 1.3333333333333333,
		},
	},
	melee_attack = {
		utility_weight = 1,
		weapon_reach = 3.5,
		considerations = UtilityConsiderations.melee_attack,
		attack_anim_events = {
			normal = {
				"attack_01",
				"attack_02",
				"attack_06",
				"attack_07",
			},
			up = {
				"attack_reach_up",
			},
			down = {
				"attack_down_01",
			},
		},
		attack_anim_damage_timings = {
			attack_01 = 1.5942028985507246,
			attack_02 = 1.5942028985507246,
			attack_06 = 0.8985507246376812,
			attack_07 = 0.7,
			attack_down_01 = 1.3333333333333333,
			attack_reach_up = 1.3333333333333333,
		},
		attack_anim_durations = {
			attack_01 = 2.608695652173913,
			attack_02 = 2.608695652173913,
			attack_06 = 1.7391304347826086,
			attack_07 = 1.8333333333333333,
			attack_down_01 = 3.3333333333333335,
			attack_reach_up = 3.0434782608695654,
		},
		attack_intensities = {
			melee = 0.25,
			ranged = 1,
		},
		stagger_type_reduction = {
			killshot = 20,
			ranged = 20,
		},
		damage_profile = DamageProfileTemplates.melee_bruiser_default,
		damage_type = damage_types.minion_melee_blunt,
	},
	moving_melee_attack = {
		catch_up_movementspeed = true,
		move_speed = 4,
		move_speed_variable_lerp_speed = 4,
		move_speed_variable_name = "moving_attack_fwd_speed",
		moving_attack = true,
		utility_weight = 1,
		weapon_reach = 3.25,
		considerations = UtilityConsiderations.renegade_melee_moving_melee_attack,
		attack_anim_events = {
			"attack_move_01",
			"attack_move_02",
		},
		attack_anim_damage_timings = {
			attack_move_01 = 1.1014492753623188,
			attack_move_02 = 1.3043478260869565,
			attack_move_03 = 1.3043478260869565,
			attack_move_04 = 1.2463768115942029,
		},
		attack_anim_durations = {
			attack_move_01 = 2.4927536231884058,
			attack_move_02 = 2.4057971014492754,
			attack_move_03 = 2.608695652173913,
			attack_move_04 = 2.260869565217391,
		},
		attack_intensities = {
			melee = 0.25,
			moving_melee = 0.5,
			ranged = 1,
			running_melee = 1,
		},
		move_start_timings = {
			attack_move_01 = 0.14492753623188406,
			attack_move_02 = 0.14492753623188406,
			attack_move_03 = 0.14492753623188406,
			attack_move_04 = 0.14492753623188406,
		},
		damage_profile = DamageProfileTemplates.melee_bruiser_default,
		damage_type = damage_types.minion_melee_blunt,
		stagger_type_reduction = {
			killshot = 60,
			ranged = 60,
		},
		animation_move_speed_configs = {
			attack_move_01 = {
				{
					distance = 4.61,
					value = 4,
				},
				{
					distance = 3.39,
					value = 3,
				},
				{
					distance = 2.12,
					value = 2,
				},
				{
					distance = 1.12,
					value = 1,
				},
				{
					distance = 0.35,
					value = 0,
				},
			},
			attack_move_02 = {
				{
					distance = 4.64,
					value = 4,
				},
				{
					distance = 3.31,
					value = 3,
				},
				{
					distance = 2.14,
					value = 2,
				},
				{
					distance = 1.13,
					value = 1,
				},
				{
					distance = 0.35,
					value = 0,
				},
			},
			attack_move_03 = {
				{
					distance = 4.53,
					value = 4,
				},
				{
					distance = 3.02,
					value = 3,
				},
				{
					distance = 2.12,
					value = 2,
				},
				{
					distance = 1.09,
					value = 1,
				},
				{
					distance = 0.35,
					value = 0,
				},
			},
			attack_move_04 = {
				{
					distance = 4.5,
					value = 4,
				},
				{
					distance = 3.42,
					value = 3,
				},
				{
					distance = 2.12,
					value = 2,
				},
				{
					distance = 1,
					value = 1,
				},
				{
					distance = 0.35,
					value = 0,
				},
			},
		},
	},
	running_melee_attack = {
		assault_vo_interval_t = 1,
		catch_up_movementspeed = true,
		move_speed = 4,
		move_speed_variable_lerp_speed = 4,
		move_speed_variable_name = "moving_attack_fwd_speed",
		moving_attack = true,
		utility_weight = 1,
		vo_event = "assault",
		weapon_reach = 3.25,
		considerations = UtilityConsiderations.renegade_melee_running_melee_attack,
		attack_anim_events = {
			"attack_run_01",
		},
		attack_anim_damage_timings = {
			attack_run_01 = 0.7333333333333333,
			attack_run_02 = 1.5666666666666667,
			attack_run_03 = 1.5,
		},
		attack_anim_durations = {
			attack_run_01 = 2,
			attack_run_02 = 2.8666666666666667,
			attack_run_03 = 2.6666666666666665,
		},
		attack_intensities = {
			melee = 0.25,
			moving_melee = 0.5,
			ranged = 1,
			running_melee = 1,
		},
		move_start_timings = {
			attack_run_01 = 0,
			attack_run_02 = 0,
			attack_run_03 = 0,
		},
		damage_profile = DamageProfileTemplates.melee_bruiser_default,
		damage_type = damage_types.minion_melee_blunt,
		stagger_type_reduction = {
			killshot = 60,
			ranged = 60,
		},
		animation_move_speed_configs = {
			attack_run_01 = {
				{
					distance = 5,
					value = 4,
				},
				{
					distance = 3.9,
					value = 3,
				},
				{
					distance = 2.5,
					value = 2,
				},
				{
					distance = 1.5,
					value = 1,
				},
				{
					distance = 0.5,
					value = 0,
				},
			},
			attack_run_02 = {
				{
					distance = 5,
					value = 4,
				},
				{
					distance = 4,
					value = 3,
				},
				{
					distance = 2,
					value = 2,
				},
				{
					distance = 0.25,
					value = 1,
				},
				{
					distance = 0.1,
					value = 0,
				},
			},
			attack_run_03 = {
				{
					distance = 4.2,
					value = 4,
				},
				{
					distance = 2.9,
					value = 3,
				},
				{
					distance = 1.5,
					value = 2,
				},
				{
					distance = 0.4,
					value = 1,
				},
				{
					distance = 0.2,
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
			stagger_explosion_front_2 = 0.8,
		},
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
					"stagger_fwd_heavy_2",
					"stagger_fwd_heavy_3",
					"stagger_fwd_heavy_4",
				},
				bwd = {
					"stagger_up_heavy",
					"stagger_up_heavy_2",
					"stagger_up_heavy_3",
					"stagger_bwd_heavy",
					"stagger_bwd_heavy_2",
					"stagger_bwd_heavy_3",
					"stagger_bwd_heavy_4",
				},
				left = {
					"stagger_left_heavy",
					"stagger_left_heavy_2",
					"stagger_left_heavy_3",
					"stagger_left_heavy_4",
				},
				right = {
					"stagger_right_heavy",
					"stagger_right_heavy_2",
					"stagger_right_heavy_3",
					"stagger_right_heavy_4",
				},
				dwn = {
					"stagger_dwn_heavy",
					"stagger_dwn_heavy_2",
					"stagger_dwn_heavy_3",
				},
			},
			light_ranged = {
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
			explosion = {
				fwd = {
					"stagger_explosion_front",
					"stagger_explosion_front_2",
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
					"stagger_fwd_killshot_2",
				},
				bwd = {
					"stagger_bwd_killshot_1",
					"stagger_bwd_killshot_2",
				},
				left = {
					"stagger_left_killshot_1",
					"stagger_left_killshot_2",
				},
				right = {
					"stagger_right_killshot_1",
					"stagger_right_killshot_2",
				},
				dwn = {
					"stagger_bwd_killshot_1",
					"stagger_bwd_killshot_2",
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
					"stagger_fwd_light_2",
					"stagger_fwd_light_3",
					"stagger_fwd_light_4",
					"stagger_fwd_light_5",
					"stagger_fwd_light_6",
				},
				bwd = {
					"stagger_bwd_light",
					"stagger_bwd_light_2",
					"stagger_bwd_light_3",
					"stagger_bwd_light_4",
					"stagger_bwd_light_5",
					"stagger_bwd_light_6",
					"stagger_bwd_light_7",
					"stagger_bwd_light_8",
				},
				left = {
					"stagger_left_light",
					"stagger_left_light_2",
					"stagger_left_light_3",
					"stagger_left_light_4",
				},
				right = {
					"stagger_right_light",
					"stagger_right_light_2",
					"stagger_right_light_3",
					"stagger_right_light_4",
				},
				dwn = {
					"stun_down",
				},
			},
			shield_block = {
				fwd = {
					"stagger_shield_light_fwd",
				},
				bwd = {
					"stagger_shield_light_fwd",
				},
				left = {
					"stagger_shield_light_left",
				},
				right = {
					"stagger_shield_light_right",
				},
				dwn = {
					"stun_down",
				},
			},
			shield_heavy_block = {
				fwd = {
					"stagger_shield_medium_fwd",
				},
				bwd = {
					"stagger_shield_medium_fwd",
				},
				left = {
					"stagger_shield_medium_left",
				},
				right = {
					"stagger_shield_medium_right",
				},
				dwn = {
					"stun_down",
				},
			},
			shield_broken = {
				fwd = {
					"stagger_shield_medium_fwd",
				},
				bwd = {
					"stagger_shield_medium_fwd",
				},
				left = {
					"stagger_shield_medium_left",
				},
				right = {
					"stagger_shield_medium_right",
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
		},
		attack_anim_damage_timings = {
			attack_01 = 1.5277777777777777,
			attack_02 = 1.5277777777777777,
			attack_03 = 1.4444444444444444,
			attack_04 = 0.6,
			attack_05 = 0.6,
			attack_06 = 0.6,
			attack_07 = 0.6,
		},
		attack_anim_durations = {
			attack_01 = 2.9166666666666665,
			attack_02 = 3.138888888888889,
			attack_03 = 3.611111111111111,
			attack_04 = 2.028985507246377,
			attack_05 = 2.463768115942029,
			attack_06 = 2.0833333333333335,
			attack_07 = 2.463768115942029,
		},
		damage_profile = DamageProfileTemplates.melee_bruiser_default,
		damage_type = damage_types.minion_melee_blunt,
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
		duration = 1.6666666666666667,
		effect_template_name = "minion_stim_effect",
		exit_state = "to_melee",
		stim_buffs = {
			"mutator_stimmed_minion_red",
			"mutator_stimmed_minion_yellow",
			"mutator_stimmed_minion_green",
			"mutator_stimmed_minion_blue",
		},
	},
}

return action_data
