-- chunkname: @scripts/settings/breed/breed_actions/chaos/chaos_ogryn_houndmaster_actions.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionPushFxTemplates = require("scripts/settings/fx/minion_push_fx_templates")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local action_data = {
	name = "chaos_ogryn_houndmaster",
	summon = {
		amount_of_tries = 5,
		calculate_after_delay = true,
		ignore_rotate_towards_target = false,
		initial_delay = 3,
		pre_stinger = "wwise/events/minions/play_chaos_hound_mutator_houndmaster_stinger",
		should_close_spawn_outside_los = true,
		should_patrol = true,
		shout_radius = 10,
		spawn_aggro_state = "passive",
		stinger = "wwise/events/minions/play_chaos_hound_mutator_spawn",
		stinger_delay = 3,
		vo_event = "summon_minions",
		anim_events = {
			"summon_minions",
		},
		shout_timings = {
			summon_minions = 1.6,
		},
		action_durations = {
			summon_minions = 2.6666666666666665,
		},
		interval_til_next_summon = {
			10,
			20,
		},
		breed_data = {
			{
				name = "chaos_hound",
				amount = {
					1,
					2,
				},
			},
			{
				name = "chaos_armored_hound",
				amount = {
					1,
					2,
				},
			},
		},
		additional_blackboard_values = {
			num_pounced = "number",
		},
	},
	idle = {
		rotate_towards_target = true,
		anim_events = {
			"idle",
			"idle_2",
		},
	},
	patrol = {
		anim_events = {
			"move_fwd_passive",
		},
		speeds = {
			move_fwd_passive = 1.2,
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
		utility_weight = 0.1,
		considerations = UtilityConsiderations.melee_combat_idle,
	},
	alerted = {
		override_aggro_distance = 8,
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
			alerted_fwd = nil,
			alerted_left = 3.6666666666666665,
			alerted_right = 3.7333333333333334,
		},
		start_rotation_durations = {
			alerted_bwd = 0.4666666666666667,
			alerted_fwd = nil,
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
	far_moving_attack = {
		aoe_threat_timing = 0.4,
		attack_type = "oobb",
		bot_power_level_modifier = 0.25,
		collision_filter = "filter_minion_melee_friendly_fire",
		dodge_range = 2.75,
		dodge_width = 1.1,
		effect_template_name = "chaos_ogryn_houndmaster_electric",
		height = 4,
		ignore_blocked = true,
		ignore_stun_immunity = true,
		move_speed = 4,
		move_speed_variable_lerp_speed = 4,
		move_speed_variable_name = "moving_attack_fwd_speed",
		moving_attack = true,
		range = 4,
		utility_weight = 4.5,
		width = 2,
		considerations = UtilityConsiderations.chaos_ogryn_houndmaster_moving_melee_attack,
		attack_anim_events = {
			"move_attack_06",
			"move_attack_07",
			"move_attack_09",
		},
		attack_anim_damage_timings = {
			move_attack_06 = {
				1.2121212121212122,
				2.121212121212121,
			},
			move_attack_07 = {
				1.1111111111111112,
				1.9444444444444444,
			},
			move_attack_09 = {
				1.0666666666666667,
				1.8666666666666667,
			},
		},
		attack_anim_durations = {
			move_attack_06 = 2.787878787878788,
			move_attack_07 = 2.5555555555555554,
			move_attack_09 = 2.453333333333333,
		},
		attack_intensities = {
			melee = 3,
			moving_melee = 3,
			ranged = 1,
			running_melee = 3,
		},
		move_start_timings = {
			move_attack_06 = 0.16666666666666666,
			move_attack_07 = 0.16666666666666666,
			move_attack_09 = 0.16666666666666666,
		},
		animation_move_speed_configs = {
			move_attack_06 = {
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
			move_attack_07 = {
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
			move_attack_09 = {
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
		damage_profile = DamageProfileTemplates.chaos_ogryn_houndmaster_moving,
		damage_type = damage_types.minion_melee_blunt_elite,
		stagger_type_reduction = {
			melee = 60,
			ranged = 60,
		},
		effect_template_start_timings = {
			move_attack_06 = 0.16666666666666666,
			move_attack_07 = 0.16666666666666666,
			move_attack_09 = 0.16666666666666666,
		},
		apply_buff_to_target_unit = {
			allow_refresh = true,
			buff_template_name = "houndmaster_electrocution",
		},
		debuff_allowed_per_strike = {
			move_attack_06 = {
				true,
				true,
			},
			move_attack_07 = {
				false,
				false,
			},
			move_attack_09 = {
				true,
				false,
			},
		},
	},
	moving_melee_attack_cleave = {
		attack_type = "oobb",
		bot_power_level_modifier = 0.25,
		collision_filter = "filter_minion_melee_friendly_fire",
		dodge_range = 2.75,
		dodge_width = 1.1,
		effect_template_name = "chaos_ogryn_houndmaster_electric",
		height = 4,
		ignore_blocked = true,
		ignore_stun_immunity = true,
		move_speed = 2,
		move_speed_variable_lerp_speed = 4,
		move_speed_variable_name = "moving_attack_fwd_speed",
		moving_attack = true,
		range = 4,
		utility_weight = 4.5,
		width = 2,
		considerations = UtilityConsiderations.chaos_ogryn_houndmaster_moving_melee_attack_cleave,
		attack_anim_events = {
			"move_attack_cleave",
			"move_attack_cleave_02",
			"move_attack_cleave_03",
			"move_attack_cleave_04",
		},
		attack_anim_damage_timings = {
			move_attack_cleave = 1.1111111111111112,
			move_attack_cleave_02 = 1.5277777777777777,
			move_attack_cleave_03 = 0.8888888888888888,
			move_attack_cleave_04 = 1,
		},
		attack_anim_durations = {
			move_attack_cleave = 2.4166666666666665,
			move_attack_cleave_02 = 2.5,
			move_attack_cleave_03 = 1.8611111111111112,
			move_attack_cleave_04 = 1.6666666666666667,
		},
		attack_intensities = {
			melee = 3,
			moving_melee = 3,
			ranged = 1,
			running_melee = 3,
		},
		move_start_timings = {
			move_attack_cleave = 0.1388888888888889,
			move_attack_cleave_02 = 0.1388888888888889,
			move_attack_cleave_03 = 0.1388888888888889,
			move_attack_cleave_04 = 0.1388888888888889,
		},
		damage_profile = DamageProfileTemplates.chaos_ogryn_houndmaster_moving,
		damage_type = damage_types.minion_melee_blunt_elite,
		stagger_type_reduction = {
			melee = 60,
			ranged = 60,
		},
		animation_move_speed_configs = {
			move_attack_cleave = {
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
			move_attack_cleave_02 = {
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
			move_attack_cleave_03 = {
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
			move_attack_cleave_04 = {
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
		effect_template_start_timings = {
			move_attack_cleave = 0.16666666666666666,
			move_attack_cleave_02 = 0.16666666666666666,
			move_attack_cleave_04 = 0.16666666666666666,
		},
		debuff_allowed_per_strike = {
			move_attack_cleave = {
				true,
			},
			move_attack_cleave_02 = {
				true,
			},
			move_attack_cleave_03 = {
				false,
			},
			move_attack_cleave_04 = {
				true,
			},
		},
		apply_buff_to_target_unit = {
			allow_refresh = true,
			buff_template_name = "houndmaster_electrocution",
		},
	},
	charge = {
		attack_anim = "charge_hit",
		attack_anim_damage_timing = 0.06666666666666667,
		charge_max_speed_at = 2,
		charge_speed_max = 11,
		charge_speed_min = 8,
		charged_past_dot = 0.45,
		charged_past_duration = 1.5,
		close_distance = 12,
		close_rotation_speed = 5,
		collision_radius = 2,
		default_lean_value = 1,
		dodge_rotation_speed = 0.01,
		ignore_blocked = true,
		lean_variable_name = "lean",
		left_lean_value = 0,
		max_dot_lean_value = 0.1,
		max_slowdown_angle = 40,
		max_slowdown_percentage = 0.25,
		min_slowdown_angle = 20,
		min_time_navigating = 0.5,
		min_time_spent_charging = 1,
		minion_can_steal = true,
		power_level = 250,
		push_enemies_power_level = 2000,
		push_enemies_radius = 1,
		push_minions_damage_type = nil,
		push_minions_power_level = 1000,
		push_minions_radius = 4,
		push_minions_side_relation = "allied",
		right_lean_value = 2,
		rotation_speed = 6,
		target_extrapolation_length_scale = 0.5,
		trigger_move_to_target = true,
		utility_weight = 5,
		wall_raycast_distance = 4.25,
		wall_raycast_node_name = "j_spine",
		wall_stun_time = 2.5,
		considerations = UtilityConsiderations.houndmaster_charge,
		charge_anim_events = {
			"charge_started",
		},
		charge_durations = {
			charge_started = 0.36666666666666664,
		},
		push_minions_damage_profile = DamageProfileTemplates.chaos_plague_ogryn_minion_charge_push,
		push_minions_fx_template = MinionPushFxTemplates.captain_charge_push,
		push_minions_fx_cooldown = {
			0.03,
			0.18,
		},
		push_enemies_damage_profile = DamageProfileTemplates.chaos_hound_push,
		attack_anim_duration = {
			default = 0.8333333333333334,
		},
		collision_angle = math.degrees_to_radians(100),
		damage_profile = DamageProfileTemplates.chaos_ogryn_houndmaster_charge,
		damage_type = damage_types.minion_charge,
		miss_animations = {
			"charge_miss",
		},
		miss_durations = {
			charge_miss = 1.6666666666666667,
		},
		can_hit_wall_durations = {
			charge_miss = 0.16666666666666666,
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
			jump_over_gap_4m = 1.2333333333333334,
			jump_over_gap_4m_2 = 1.2333333333333334,
		},
		ending_move_states = {
			jump_over_gap_4m = "jumping",
			jump_over_gap_4m_2 = "jumping",
		},
	},
	follow = {
		enter_walk_distance = 2,
		follow_vo_interval_t = 3,
		idle_anim_events = "idle",
		leave_walk_distance = 4,
		rotation_speed = 2.5,
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
	assault_follow = {
		enter_walk_distance = 7,
		follow_vo_interval_t = 3,
		idle_anim_events = "idle",
		leave_walk_distance = 12,
		move_speed = 8,
		rotation_speed = 5,
		run_anim_event = "move_fwd",
		utility_weight = 0.5,
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
		attack_type = "oobb",
		bot_power_level_modifier = 0.25,
		collision_filter = "filter_minion_melee_friendly_fire",
		dodge_range = 2.75,
		dodge_width = 1.1,
		effect_template_name = "chaos_ogryn_houndmaster_electric",
		height = 4,
		ignore_blocked = true,
		ignore_stun_immunity = true,
		max_z_diff = 3,
		range = 4,
		utility_weight = 5,
		width = 2,
		considerations = UtilityConsiderations.chaos_ogryn_houndmaster_melee_attack,
		attack_anim_events = {
			normal = {
				"attack_03",
				"attack_04",
				"attack_05",
				"attack_06",
				"attack_standing_combo",
			},
			up = {
				"attack_reach_up",
			},
			down = {
				"attack_down_01",
			},
		},
		attack_anim_damage_timings = {
			attack_03 = 0.7666666666666667,
			attack_04 = 0.8333333333333334,
			attack_05 = 0.8333333333333334,
			attack_06 = 1,
			attack_down_01 = 1.0666666666666667,
			attack_reach_up = 0.9,
			attack_standing_combo = {
				0.7,
				1.7,
			},
		},
		attack_anim_durations = {
			attack_03 = 1.5,
			attack_04 = 1.6666666666666667,
			attack_05 = 1.5,
			attack_06 = 1.9,
			attack_down_01 = 2.6666666666666665,
			attack_reach_up = 2.2666666666666666,
			attack_standing_combo = 2.3,
		},
		attack_override_damage_data = {
			attack_standing_combo = {
				[2] = {
					override_damage_profile = DamageProfileTemplates.chaos_ogryn_houndmaster_standing_combo,
					override_damage_type = damage_types.minion_charge,
				},
			},
		},
		attack_intensities = {
			melee = 3,
			ranged = 1,
		},
		damage_profile = DamageProfileTemplates.chaos_ogryn_houndmaster_default,
		damage_type = damage_types.minion_melee_blunt_elite,
		stagger_type_reduction = {
			melee = 50,
			ranged = 50,
		},
		effect_template_start_timings = {
			attack_03 = 0.16666666666666666,
			attack_04 = 0.16666666666666666,
			attack_05 = 0.16666666666666666,
			attack_06 = 0.16666666666666666,
			attack_standing_combo = 0.16666666666666666,
		},
		apply_buff_to_target_unit = {
			allow_refresh = true,
			buff_template_name = "houndmaster_electrocution",
		},
	},
	blocked = {
		blocked_duration = 0.03333333333333333,
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
			companion_push = {
				fwd = {
					"stagger_companion_push_bwd",
				},
				bwd = {
					"stagger_companion_push_fwd",
				},
				left = {
					"stagger_companion_push_right",
				},
				right = {
					"stagger_companion_push_left",
				},
			},
			wall_collision = {
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
			attack_01 = 0.6896551724137931,
			attack_02 = 0.6896551724137931,
			attack_03 = 0.6896551724137931,
			attack_04 = 0.7407407407407407,
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
