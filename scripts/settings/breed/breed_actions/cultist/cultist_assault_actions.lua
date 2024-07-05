-- chunkname: @scripts/settings/breed/breed_actions/cultist/cultist_assault_actions.lua

local BreedShootTemplates = require("scripts/settings/breed/breed_shoot_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local shooting_difficulty_settings = MinionDifficultySettings.shooting.cultist_assault
local action_data = {
	name = "cultist_assault",
	idle = {
		rotate_towards_target = true,
		anim_events = {
			"idle",
			"idle_2",
			"idle_3",
		},
	},
	patrol = {
		idle_anim_events = {
			"idle",
			"idle_2",
		},
		anim_events = {
			"move_fwd_1",
			"move_fwd_2",
			"move_fwd_3",
			"move_fwd_4",
			"move_fwd_5",
			"move_fwd_6",
			"move_fwd_7",
		},
		speeds = {
			move_fwd_1 = 0.89,
			move_fwd_2 = 0.91,
			move_fwd_3 = 0.87,
			move_fwd_4 = 0.78,
			move_fwd_5 = 0.73,
			move_fwd_6 = 1,
			move_fwd_7 = 0.97,
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
	melee_combat_idle = {
		rotate_towards_target = true,
		utility_weight = 2,
		considerations = UtilityConsiderations.melee_combat_idle,
		anim_events = {
			"idle",
			"idle_2",
			"idle_3",
		},
	},
	alerted = {
		alert_spread_max_distance_to_target = 30,
		alert_spread_radius = 8,
		hesitate_chance = 0.1,
		instant_aggro_chance = 0,
		override_aggro_distance = 8,
		vo_event = "alerted_idle",
		alerted_anim_events = {
			"alerted",
			"alerted_2",
		},
		directional_alerted_anim_events = {
			fwd = {
				"alerted_fwd",
				"alerted_fwd_2",
				"alerted_fwd_3",
			},
			bwd = {
				"alerted_bwd",
				"alerted_bwd_2",
				"alerted_bwd_3",
			},
			left = {
				"alerted_left",
				"alerted_left_2",
				"alerted_left_3",
			},
			right = {
				"alerted_right",
				"alerted_right_2",
				"alerted_right_3",
			},
		},
		hesitate_anim_events = {
			"hesitate_1",
		},
		start_move_anim_data = {
			alerted_bwd = {
				sign = -1,
				rad = math.pi,
			},
			alerted_bwd_2 = {
				sign = 1,
				rad = math.pi,
			},
			alerted_bwd_3 = {
				sign = 1,
				rad = math.pi,
			},
			alerted_fwd = {},
			alerted_fwd_2 = {},
			alerted_fwd_3 = {},
			alerted_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			alerted_left_2 = {
				sign = 1,
				rad = math.pi / 2,
			},
			alerted_left_3 = {
				sign = 1,
				rad = math.pi / 2,
			},
			alerted_right = {
				sign = -1,
				rad = math.pi / 2,
			},
			alerted_right_2 = {
				sign = -1,
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
			alerted_left = 0,
			alerted_left_2 = 0,
			alerted_left_3 = 0,
			alerted_right = 0,
			alerted_right_2 = 0,
			alerted_right_3 = 0,
		},
		start_rotation_durations = {
			alerted_bwd = 1.0333333333333334,
			alerted_bwd_2 = 2.2333333333333334,
			alerted_bwd_3 = 2.2666666666666666,
			alerted_left = 1,
			alerted_left_2 = 3.066666666666667,
			alerted_left_3 = 0.6,
			alerted_right = 0.9666666666666667,
			alerted_right_2 = 3.466666666666667,
			alerted_right_3 = 0.8,
		},
		alerted_durations = {
			alerted_bwd = 1.2333333333333334,
			alerted_bwd_2 = 3.5,
			alerted_bwd_3 = 2.2666666666666666,
			alerted_fwd = 1.6666666666666667,
			alerted_fwd_2 = 2.466666666666667,
			alerted_fwd_3 = 2.6666666666666665,
			alerted_left = 1.2666666666666666,
			alerted_left_2 = 3.3666666666666667,
			alerted_left_3 = 2.3333333333333335,
			alerted_right = 2.566666666666667,
			alerted_right_2 = 3.7,
			alerted_right_3 = 3.066666666666667,
			hesitate_1 = {
				6.666666666666667,
				7,
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
	suppressed = {
		chance_of_jump_animation = 0.5,
		anim_events = {
			"suppressed_loop_01",
			"suppressed_loop_02",
			"suppressed_loop_03",
			"suppressed_loop_knee_01",
			"suppressed_loop_knee_02",
		},
		durations = {
			suppressed_loop_01 = {
				10.5,
				11,
			},
			suppressed_loop_02 = {
				10.5,
				11,
			},
			suppressed_loop_03 = {
				10.5,
				11,
			},
			suppressed_loop_knee_01 = {
				10.5,
				11,
			},
			suppressed_loop_knee_02 = {
				10.5,
				11,
			},
		},
		jump_anim_events = {
			fwd = {
				"suppressed_jump_fwd_01",
				"suppressed_jump_fwd_02",
			},
			right = {
				"suppressed_jump_right_01",
				"suppressed_jump_right_02",
			},
			bwd = {
				"suppressed_jump_bwd_01",
				"suppressed_jump_bwd_02",
				"suppressed_jump_bwd_03",
			},
			left = {
				"suppressed_jump_left_01",
				"suppressed_jump_left_02",
			},
		},
		jump_durations = {
			suppressed_jump_bwd_01 = 1.1466666666666667,
			suppressed_jump_bwd_02 = 1.8933333333333333,
			suppressed_jump_bwd_03 = 2,
			suppressed_jump_fwd_01 = 1.4666666666666666,
			suppressed_jump_fwd_02 = 1.2266666666666666,
			suppressed_jump_left_01 = 1.2,
			suppressed_jump_left_02 = 1.2,
			suppressed_jump_right_01 = 1.36,
			suppressed_jump_right_02 = 0.8533333333333334,
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
		controlled_stagger_min_speed = 2,
		degree_per_direction = 10,
		max_distance_to_target = 22,
		min_distance_to_target = 14,
		move_anim_events = "move_fwd",
		move_to_cooldown = 0.25,
		move_to_fail_cooldown = 1,
		randomized_direction_degree_range = 120,
		speed = 4.2,
		use_animation_running_stagger_speed = true,
		utility_weight = 1,
		considerations = UtilityConsiderations.ranged_follow,
		idle_anim_events = {
			"idle",
			"idle_2",
			"idle_3",
		},
		start_move_anim_events = {
			bwd = "move_start_bwd",
			fwd = "move_start_fwd",
			left = "move_start_left",
			right = "move_start_right",
		},
		start_move_anim_data = {
			move_start_fwd = {},
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
			move_start_bwd = 0,
			move_start_fwd = 0,
			move_start_left = 0,
			move_start_right = 0,
		},
		start_rotation_durations = {
			move_start_bwd = 1,
			move_start_fwd = 0.4666666666666667,
			move_start_left = 0.8,
			move_start_right = 0.7333333333333333,
		},
		running_stagger_anim_left = {
			"run_stagger_right",
			"shotgun_run_stagger_01",
			"shotgun_run_stagger_02",
			"shotgun_run_stagger_03",
			"shotgun_run_stagger_04",
		},
		running_stagger_anim_right = {
			"run_stagger_left",
			"shotgun_run_stagger_01",
			"shotgun_run_stagger_02",
			"shotgun_run_stagger_03",
			"shotgun_run_stagger_04",
		},
		running_stagger_duration = {
			run_stagger_left = 1.8333333333333333,
			run_stagger_right = 1.7333333333333334,
			shotgun_run_stagger_01 = 1.5333333333333334,
			shotgun_run_stagger_02 = 1.6333333333333333,
			shotgun_run_stagger_03 = 1.7333333333333334,
			shotgun_run_stagger_04 = 2,
		},
		running_stagger_min_duration = {
			shotgun_run_stagger_04 = 1.6666666666666667,
		},
	},
	ranged_follow_no_los = {
		controlled_stagger = true,
		controlled_stagger_min_speed = 2,
		degree_per_direction = 10,
		max_distance_to_target = 18,
		min_distance_to_target = 10,
		move_anim_events = "move_fwd",
		move_to_cooldown = 0.25,
		move_to_fail_cooldown = 1,
		randomized_direction_degree_range = 120,
		speed = 4.2,
		use_animation_running_stagger_speed = true,
		utility_weight = 1,
		considerations = UtilityConsiderations.ranged_follow_no_los,
		idle_anim_events = {
			"idle",
			"idle_2",
			"idle_3",
		},
		start_move_anim_events = {
			bwd = "move_start_bwd",
			fwd = "move_start_fwd",
			left = "move_start_left",
			right = "move_start_right",
		},
		start_move_anim_data = {
			move_start_fwd = {},
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
			move_start_bwd = 0,
			move_start_fwd = 0,
			move_start_left = 0,
			move_start_right = 0,
		},
		start_rotation_durations = {
			move_start_bwd = 1,
			move_start_fwd = 0.4666666666666667,
			move_start_left = 0.8,
			move_start_right = 0.7333333333333333,
		},
		running_stagger_anim_left = {
			"run_stagger_right",
			"shotgun_run_stagger_01",
			"shotgun_run_stagger_02",
			"shotgun_run_stagger_03",
			"shotgun_run_stagger_04",
		},
		running_stagger_anim_right = {
			"run_stagger_left",
			"shotgun_run_stagger_01",
			"shotgun_run_stagger_02",
			"shotgun_run_stagger_03",
			"shotgun_run_stagger_04",
		},
		running_stagger_duration = {
			run_stagger_left = 1.8333333333333333,
			run_stagger_right = 1.7333333333333334,
			shotgun_run_stagger_01 = 1.5333333333333334,
			shotgun_run_stagger_02 = 1.6333333333333333,
			shotgun_run_stagger_03 = 1.7333333333333334,
			shotgun_run_stagger_04 = 2,
		},
		running_stagger_min_duration = {
			shotgun_run_stagger_04 = 1.6666666666666667,
		},
	},
	move_to_combat_vector = {
		controlled_stagger = true,
		controlled_stagger_min_speed = 2,
		degree_per_direction = 10,
		max_distance_to_target = 18,
		min_distance_to_target = 10,
		move_anim_events = "move_fwd",
		move_to_cooldown = 0.25,
		move_to_fail_cooldown = 1,
		randomized_direction_degree_range = 120,
		range = "close",
		speed = 4.2,
		use_animation_running_stagger_speed = true,
		utility_weight = 1,
		considerations = UtilityConsiderations.move_to_combat_vector,
		idle_anim_events = {
			"idle",
			"idle_2",
			"idle_3",
		},
		start_move_anim_events = {
			bwd = "move_start_bwd",
			fwd = "move_start_fwd",
			left = "move_start_left",
			right = "move_start_right",
		},
		start_move_anim_data = {
			move_start_fwd = {},
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
			move_start_bwd = 0,
			move_start_fwd = 0,
			move_start_left = 0,
			move_start_right = 0,
		},
		start_rotation_durations = {
			move_start_bwd = 1,
			move_start_fwd = 0.4666666666666667,
			move_start_left = 0.8,
			move_start_right = 0.7333333333333333,
		},
		running_stagger_anim_left = {
			"run_stagger_right",
			"shotgun_run_stagger_01",
			"shotgun_run_stagger_02",
			"shotgun_run_stagger_03",
			"shotgun_run_stagger_04",
		},
		running_stagger_anim_right = {
			"run_stagger_left",
			"shotgun_run_stagger_01",
			"shotgun_run_stagger_02",
			"shotgun_run_stagger_03",
			"shotgun_run_stagger_04",
		},
		running_stagger_duration = {
			run_stagger_left = 1.8333333333333333,
			run_stagger_right = 1.7333333333333334,
			shotgun_run_stagger_01 = 1.5333333333333334,
			shotgun_run_stagger_02 = 1.6333333333333333,
			shotgun_run_stagger_03 = 1.7333333333333334,
			shotgun_run_stagger_04 = 2,
		},
		running_stagger_min_duration = {
			shotgun_run_stagger_04 = 1.6666666666666667,
		},
	},
	run_stop_and_shoot = {
		attack_intensity_type = "ranged",
		fx_source_name = "muzzle",
		inventory_slot = "slot_ranged_weapon",
		move_distance = 3.35,
		suppressive_fire = true,
		start_move_anim_events = {
			bwd = "run_into_shoot_bwd",
			fwd = "run_into_shoot_fwd",
			left = "run_into_shoot_left",
			right = "run_into_shoot_right",
		},
		start_move_anim_data = {
			run_into_shoot_fwd = {},
			run_into_shoot_bwd = {
				sign = -1,
				rad = math.pi,
			},
			run_into_shoot_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			run_into_shoot_right = {
				sign = -1,
				rad = math.pi / 2,
			},
		},
		start_move_rotation_timings = {
			run_into_shoot_bwd = 0.6333333333333333,
			run_into_shoot_fwd = 0,
			run_into_shoot_left = 0.7666666666666667,
			run_into_shoot_right = 0.5,
		},
		start_rotation_durations = {
			run_into_shoot_bwd = 0.4,
			run_into_shoot_fwd = 0,
			run_into_shoot_left = 0.3,
			run_into_shoot_right = 0.3333333333333333,
		},
		blend_timings = {
			run_into_shoot_bwd = 0.2,
			run_into_shoot_fwd = 0.2,
			run_into_shoot_left = 0.2,
			run_into_shoot_right = 0.2,
		},
		move_durations = {
			run_into_shoot_bwd = 1.5,
			run_into_shoot_fwd = 1.3333333333333333,
			run_into_shoot_left = 1.6,
			run_into_shoot_right = 1.4666666666666666,
		},
		action_duration = {
			run_into_shoot_bwd = 3.1666666666666665,
			run_into_shoot_fwd = 2.6666666666666665,
			run_into_shoot_left = 2.6666666666666665,
			run_into_shoot_right = 2.6666666666666665,
		},
		dodge_window = shooting_difficulty_settings.shoot_dodge_window,
		shoot_cooldown = shooting_difficulty_settings.shoot_cooldown,
		num_shots = shooting_difficulty_settings.num_shots,
		time_per_shot = shooting_difficulty_settings.time_per_shot,
		attack_intensities = {
			ranged = 0.5,
		},
		shoot_template = BreedShootTemplates.cultist_assault_default,
	},
	assault = {
		controlled_stagger = true,
		controlled_stagger_min_speed = 2,
		degree_per_direction = 10,
		is_assaulting = true,
		max_distance_to_target = 12,
		min_distance_to_target = 8,
		move_anim_event = "assault_fwd",
		move_to_cooldown = 0.25,
		move_to_fail_cooldown = 1,
		randomized_direction_degree_range = 60,
		speed = 6.2,
		use_animation_running_stagger_speed = true,
		utility_weight = 10,
		vo_event = "assault",
		considerations = UtilityConsiderations.assault_far,
		idle_anim_events = {
			"idle",
			"idle_2",
			"idle_3",
		},
		running_stagger_anim_left = {
			"run_stagger_right",
			"shotgun_run_stagger_01",
			"shotgun_run_stagger_02",
			"shotgun_run_stagger_03",
			"shotgun_run_stagger_04",
		},
		running_stagger_anim_right = {
			"run_stagger_left",
			"shotgun_run_stagger_01",
			"shotgun_run_stagger_02",
			"shotgun_run_stagger_03",
			"shotgun_run_stagger_04",
		},
		running_stagger_duration = {
			run_stagger_left = 1.8333333333333333,
			run_stagger_right = 1.7333333333333334,
			shotgun_run_stagger_01 = 1.5333333333333334,
			shotgun_run_stagger_02 = 1.6333333333333333,
			shotgun_run_stagger_03 = 1.7333333333333334,
			shotgun_run_stagger_04 = 2,
		},
		running_stagger_min_duration = {
			shotgun_run_stagger_04 = 1.6666666666666667,
		},
	},
	shoot_close = {
		attack_intensity_type = "ranged",
		can_strafe_shoot = true,
		degree_per_direction = 10,
		first_shoot_timing = 0.5,
		fx_source_name = "muzzle",
		inventory_slot = "slot_ranged_weapon",
		max_distance_to_target = 14,
		min_distance_to_target = 6,
		move_to_cooldown = 0.25,
		move_to_fail_cooldown = 1,
		new_combat_vector_position_min_distance = 8,
		randomized_direction_degree_range = 180,
		strafe_end_anim_event = "aim_standing",
		strafe_shoot_distance = 3,
		strafe_shoot_ranged_position_fallback = true,
		strafe_speed = 2.3,
		suppressive_fire = true,
		utility_weight = 10,
		considerations = UtilityConsiderations.shoot_close,
		aim_anim_events = {
			"aim_standing",
		},
		aim_duration = {
			aim_standing = shooting_difficulty_settings.aim_durations,
		},
		dodge_window = shooting_difficulty_settings.shoot_dodge_window,
		shoot_cooldown = shooting_difficulty_settings.shoot_cooldown,
		num_shots = shooting_difficulty_settings.num_shots,
		time_per_shot = shooting_difficulty_settings.time_per_shot,
		attack_intensities = {
			ranged = 0.5,
		},
		cooldown_anim_events = {
			"idle",
			"idle_2",
			"idle_3",
			"hesitate_1",
		},
		shoot_template = BreedShootTemplates.cultist_assault_default,
		strafe_anim_events = {
			bwd = "move_bwd_walk_aim",
			fwd = "move_fwd_walk_aim",
			left = "move_left_walk_aim",
			right = "move_right_walk_aim",
		},
	},
	shoot = {
		attack_intensity_type = "ranged",
		first_shoot_timing = 0.5,
		fx_source_name = "muzzle",
		inventory_slot = "slot_ranged_weapon",
		new_combat_vector_position_min_distance = 8,
		suppressive_fire = true,
		utility_weight = 10,
		considerations = UtilityConsiderations.shoot_close,
		aim_anim_events = {
			"aim_standing",
		},
		aim_duration = {
			aim_standing = shooting_difficulty_settings.aim_durations,
			turn_shoot_bwd = shooting_difficulty_settings.aim_durations,
			turn_shoot_left = shooting_difficulty_settings.aim_durations,
			turn_shoot_right = shooting_difficulty_settings.aim_durations,
		},
		shoot_turn_anims = {
			bwd = "turn_shoot_bwd",
			left = "turn_shoot_left",
			right = "turn_shoot_right",
		},
		start_move_anim_data = {
			turn_shoot_bwd = {
				sign = -1,
				rad = math.pi,
			},
			turn_shoot_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			turn_shoot_right = {
				sign = -1,
				rad = math.pi / 2,
			},
		},
		start_move_rotation_timings = {
			turn_shoot_bwd = 0,
			turn_shoot_left = 0,
			turn_shoot_right = 0,
		},
		start_rotation_durations = {
			turn_shoot_bwd = 0.5714285714285714,
			turn_shoot_left = 0.6410256410256411,
			turn_shoot_right = 0.6410256410256411,
		},
		aim_stances = {
			aim_standing = "standing",
		},
		dodge_window = shooting_difficulty_settings.shoot_dodge_window,
		shoot_cooldown = shooting_difficulty_settings.shoot_cooldown,
		num_shots = shooting_difficulty_settings.num_shots,
		time_per_shot = shooting_difficulty_settings.time_per_shot,
		attack_intensities = {
			ranged = 0.5,
		},
		cooldown_anim_events = {
			"idle",
			"idle_2",
			"idle_3",
			"hesitate_1",
		},
		shoot_template = BreedShootTemplates.cultist_assault_default,
	},
	melee_follow = {
		enter_walk_distance = 5,
		leave_walk_distance = 8,
		run_anim_event = "move_fwd",
		utility_weight = 1,
		walk_anim_event = "move_fwd_walk_2",
		considerations = UtilityConsiderations.melee_follow,
		idle_anim_events = {
			"idle",
			"idle_2",
			"idle_3",
		},
		walk_speeds = {
			move_fwd_walk = 2,
			move_fwd_walk_2 = 2,
			move_fwd_walk_3 = 2.4,
			move_fwd_walk_4 = 1.9,
			move_fwd_walk_5 = 2,
		},
		start_move_anim_events = {
			walking = {
				bwd = "move_bwd_walk",
				left = "move_left_walk",
				right = "move_right_walk",
				fwd = {
					"move_fwd_walk",
					"move_fwd_walk_2",
					"move_fwd_walk_3",
					"move_fwd_walk_4",
					"move_fwd_walk_5",
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
			move_start_bwd = 0,
			move_start_fwd = 0,
			move_start_left = 0,
			move_start_right = 0,
		},
		start_rotation_durations = {
			move_start_bwd = 0.26666666666666666,
			move_start_fwd = 0.26666666666666666,
			move_start_left = 0.26666666666666666,
			move_start_right = 0.26666666666666666,
		},
	},
	melee_attack = {
		utility_weight = 1,
		weapon_reach = 3.5,
		considerations = UtilityConsiderations.melee_attack,
		attack_anim_events = {
			normal = {
				"attack_04",
				"attack_05",
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
			attack_04 = 0.7654320987654321,
			attack_05 = 0.8148148148148148,
			attack_06 = 0.7126436781609196,
			attack_07 = 0.7,
			attack_down_01 = 1.3333333333333333,
			attack_reach_up = 1.1794871794871795,
		},
		attack_anim_durations = {
			attack_04 = 1.3793103448275863,
			attack_05 = 1.5402298850574712,
			attack_06 = 1.3793103448275863,
			attack_07 = 1.8333333333333333,
			attack_down_01 = 3.3333333333333335,
			attack_reach_up = 2.6923076923076925,
		},
		attack_intensities = {
			melee = 0.25,
			ranged = 1,
		},
		stagger_type_reduction = {
			killshot = 20,
			ranged = 20,
		},
		damage_profile = DamageProfileTemplates.melee_fighter_default,
		damage_type = damage_types.minion_melee_sharp,
	},
	moving_melee_attack = {
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
			"attack_move_03",
			"attack_move_04",
		},
		attack_anim_damage_timings = {
			attack_move_01 = 0.9382716049382716,
			attack_move_02 = 1.1111111111111112,
			attack_move_03 = 1.1111111111111112,
			attack_move_04 = 1.0617283950617284,
		},
		attack_anim_durations = {
			attack_move_01 = 2.123456790123457,
			attack_move_02 = 2.049382716049383,
			attack_move_03 = 2.2222222222222223,
			attack_move_04 = 1.9259259259259258,
		},
		attack_intensities = {
			melee = 0.25,
			moving_melee = 0.5,
			ranged = 0.75,
			running_melee = 1,
		},
		move_start_timings = {
			attack_move_01 = 0.12345679012345678,
			attack_move_02 = 0.12345679012345678,
			attack_move_03 = 0.12345679012345678,
			attack_move_04 = 0.12345679012345678,
		},
		damage_profile = DamageProfileTemplates.melee_fighter_default,
		damage_type = damage_types.minion_melee_sharp,
		stagger_type_reduction = {
			killshot = 20,
			ranged = 20,
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
	switch_weapon = {
		vo_event = "switch_to_melee",
		slot_melee_weapon = {
			switch_anim_events = {
				"equip_sword",
			},
			switch_anim_equip_timings = {
				equip_sword = 0.2833333333333333,
			},
			switch_anim_durations = {
				equip_sword = 0.5,
			},
		},
		slot_ranged_weapon = {
			switch_anim_events = {
				"equip_gun",
			},
			switch_anim_equip_timings = {
				equip_gun = 0.2,
			},
			switch_anim_durations = {
				equip_gun = 0.4,
			},
		},
	},
	has_cover = {
		utility_weight = 3,
		considerations = UtilityConsiderations.has_cover,
	},
	move_to_cover = {
		anim_driven_min_distance = 3,
		controlled_stagger = true,
		controlled_stagger_min_speed = 2,
		move_type_switch_stickiness = 2,
		sprint_anim_event = "assault_fwd",
		use_animation_running_stagger_speed = true,
		idle_anim_events = {
			"idle",
			"idle_2",
			"idle_3",
		},
		start_move_anim_events = {
			bwd = "move_start_bwd",
			fwd = "move_start_fwd",
			left = "move_start_left",
			right = "move_start_right",
		},
		start_move_anim_data = {
			move_start_fwd = {},
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
			move_start_bwd = 0,
			move_start_fwd = 0,
			move_start_left = 0,
			move_start_right = 0,
		},
		start_rotation_durations = {
			move_start_bwd = 0.26666666666666666,
			move_start_fwd = 0.26666666666666666,
			move_start_left = 0.26666666666666666,
			move_start_right = 0.26666666666666666,
		},
		speeds = {
			jogging = 4.2,
			sprinting = 5.6,
		},
		running_stagger_anim_left = {
			"run_stagger_right",
			"shotgun_run_stagger_01",
			"shotgun_run_stagger_02",
			"shotgun_run_stagger_03",
			"shotgun_run_stagger_04",
		},
		running_stagger_anim_right = {
			"run_stagger_left",
			"shotgun_run_stagger_01",
			"shotgun_run_stagger_02",
			"shotgun_run_stagger_03",
			"shotgun_run_stagger_04",
		},
		running_stagger_duration = {
			run_stagger_left = 1.8333333333333333,
			run_stagger_right = 1.7333333333333334,
			shotgun_run_stagger_01 = 1.5333333333333334,
			shotgun_run_stagger_02 = 1.6333333333333333,
			shotgun_run_stagger_03 = 1.7333333333333334,
			shotgun_run_stagger_04 = 2,
		},
		running_stagger_min_duration = {
			shotgun_run_stagger_04 = 1.6666666666666667,
		},
	},
	move_to_cover_shoot = {
		attack_intensity_type = "ranged",
		cover_crouch_check = true,
		cover_crouch_check_replacement_anim_event = "aim_standing",
		exit_after_cooldown = true,
		fx_source_name = "muzzle",
		inventory_slot = "slot_ranged_weapon",
		suppressive_fire = true,
		utility_weight = 20,
		considerations = UtilityConsiderations.move_to_cover_shoot,
		aim_anim_events = {
			"aim_standing",
			"aim_crouching",
		},
		aim_duration = {
			aim_standing = shooting_difficulty_settings.aim_durations,
			aim_crouching = shooting_difficulty_settings.aim_durations,
			turn_shoot_bwd = shooting_difficulty_settings.aim_durations,
			turn_shoot_left = shooting_difficulty_settings.aim_durations,
			turn_shoot_right = shooting_difficulty_settings.aim_durations,
		},
		shoot_turn_anims = {
			bwd = "turn_shoot_bwd",
			left = "turn_shoot_left",
			right = "turn_shoot_right",
		},
		start_move_anim_data = {
			turn_shoot_bwd = {
				sign = -1,
				rad = math.pi,
			},
			turn_shoot_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			turn_shoot_right = {
				sign = -1,
				rad = math.pi / 2,
			},
		},
		start_move_rotation_timings = {
			turn_shoot_bwd = 0,
			turn_shoot_left = 0,
			turn_shoot_right = 0,
		},
		start_rotation_durations = {
			turn_shoot_bwd = 0.5714285714285714,
			turn_shoot_left = 0.6410256410256411,
			turn_shoot_right = 0.6410256410256411,
		},
		aim_stances = {
			aim_crouching = "crouching",
			aim_standing = "standing",
		},
		attack_intensities = {
			ranged = 0.5,
		},
		idle_anim_events = {
			"idle",
			"idle_2",
			"idle_3",
		},
		shoot_cooldown = shooting_difficulty_settings.shoot_cooldown,
		num_shots = shooting_difficulty_settings.num_shots,
		time_per_shot = shooting_difficulty_settings.time_per_shot,
		shoot_template = BreedShootTemplates.cultist_assault_default,
	},
	in_cover = {
		aim_anim_event = "aim",
		aim_duration = 0.8333333333333334,
		attack_intensity_type = "ranged",
		clear_shot_line_of_sight_id = "gun",
		enter_cover_speed = 2,
		exit_anim_event = "exit_cover",
		fx_source_name = "muzzle",
		inventory_slot = "slot_ranged_weapon",
		peek_duration = 1,
		suppressed_anim = "suppressed_loop",
		suppressive_fire = true,
		suppressive_fire_spread_multiplier = 4,
		enter_cover_anim_states = {
			high = "to_high_cover",
			low = "to_low_cover",
		},
		enter_cover_durations = {
			to_high_cover = 1.1111111111111112,
			to_low_cover = 1.25,
		},
		peek_anim_events = {
			left = "peek_left",
			right = "peek_right",
			up = "peek_up",
		},
		start_aiming_at_target_timings = {
			aim = 0.5,
		},
		num_shots = shooting_difficulty_settings.num_shots_cover,
		time_per_shot = shooting_difficulty_settings.time_per_shot,
		attack_intensities = {
			ranged = 0.5,
		},
		shoot_template = BreedShootTemplates.cultist_assault_default,
		stagger_type_reduction = {
			ranged = 10,
		},
		clear_shot_offset_from_peeking = {
			high = {
				left = Vector3Box(-0.613639, -0.611683, 1.4754),
				right = Vector3Box(0.641053, -0.445854, 1.46142),
			},
			low = {
				left = Vector3Box(-0.770176, -0.433462, 0.893286),
				right = Vector3Box(0.675663, -0.477724, 0.9158),
				up = Vector3Box(0.00311852, -0.440826, 1.32431),
			},
		},
	},
	blocked = {
		blocked_duration = 1,
		blocked_anims = {
			"blocked",
		},
	},
	throw_frag_grenade = {
		utility_weight = 10,
		considerations = UtilityConsiderations.frag_grenade,
		aim_anim_events = {
			"throw_grenade",
		},
		throw_timing = {
			throw_grenade = 1.2083333333333333,
		},
		action_durations = {
			throw_grenade = 2.5,
		},
		attack_intensities = {
			grenade = 20,
		},
		effect_template = EffectTemplates.renegade_captain_grenade,
		effect_template_timings = {
			throw_grenade = 0.4375,
		},
		throw_config = {
			acceptable_accuracy = 1,
			item = "content/items/weapons/minions/ranged/renegade_grenade",
			unit_node = "j_lefthand",
			projectile_template = ProjectileTemplates.renegade_frag_grenade,
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
			medium = {
				fwd = {
					"stagger_fwd",
					"stagger_fwd_2",
					"stagger_fwd_3",
					"stagger_fwd_4",
				},
				bwd = {
					"stagger_bwd",
					"stagger_bwd_2",
					"stagger_bwd_3",
					"stagger_bwd_4",
				},
				left = {
					"stagger_left",
					"stagger_left_2",
					"stagger_left_3",
					"stagger_left_4",
					"stagger_left_5",
				},
				right = {
					"stagger_right",
					"stagger_right_2",
					"stagger_right_3",
					"stagger_right_4",
					"stagger_right_5",
				},
				dwn = {
					"stagger_medium_downward",
					"stagger_medium_downward_2",
					"stagger_medium_downward_3",
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
					"stun_fwd_ranged_light",
					"stun_fwd_ranged_light_2",
					"stun_fwd_ranged_light_3",
				},
				bwd = {
					"stun_bwd_ranged_light",
					"stun_bwd_ranged_light_2",
					"stun_bwd_ranged_light_3",
				},
				left = {
					"stun_left_ranged_light",
					"stun_left_ranged_light_2",
					"stun_left_ranged_light_3",
				},
				right = {
					"stun_right_ranged_light",
					"stun_right_ranged_light_2",
					"stun_right_ranged_light_3",
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
		},
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
