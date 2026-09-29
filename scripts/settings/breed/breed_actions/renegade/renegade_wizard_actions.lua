-- chunkname: @scripts/settings/breed/breed_actions/renegade/renegade_wizard_actions.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local action_data = {
	name = "renegade_wizard",
	idle = {
		anim_events = "idle",
		enraged_anim_events = "idle_aggro",
	},
	intro = {
		anim_events = {
			"boss_intro",
		},
		anim_duration = {
			boss_intro = 16.5,
		},
	},
	exhausted = {
		num_events = 3,
		vo_event = "psyker_boss_hurt_a",
		anim_events = {
			"start_exhaust",
			"loop_exhaust",
			"exit_exhaust",
		},
		anim_duration = {
			exit_exhaust = 5.366666666666666,
			loop_exhaust = 20,
			start_exhaust = 4.033333333333333,
		},
	},
	dance = {
		delay = 0.5,
		knockback_range = 3,
		num_attacks = 10,
		vo_event = "psyker_boss_wall_attack_a",
		wwise_event = "wwise/events/minions/play_enemy_psyker_magic_charge_big",
		anim_event = {
			"tap_floor",
		},
		anim_damage_timings = {
			tap_floor = 4.333333333333333,
		},
		anim_duration = {
			tap_floor = 7.5,
		},
		effect_template_names = {
			dance = "renegade_psyker_boss_circle_dance",
			knockback = "renegade_wizard_knockback",
		},
		target_downed_zone_chance = {
			0.5,
			0.4,
			0.3,
			0,
			0,
		},
		circle_settings = {
			{
				inner_radius = 2.5,
				outer_radius = 8,
			},
			{
				inner_radius = 8,
				outer_radius = 13.5,
			},
			{
				inner_radius = 13.5,
				outer_radius = 19,
			},
			{
				inner_radius = 19,
				outer_radius = 24.5,
			},
		},
	},
	spawn_teeth = {
		anim_duration = 1.5,
		channeling_animation = "teeth_start",
		delay_between_shots = 0.5,
		effect_template_name = "renegade_wizard_pillar",
		exit_channeling_animation = "teeth_end",
		num_shot = 8,
		vo_event = "psyker_boss_spillway_taunt_04_a",
	},
	dive_bomb = {
		anim_duration = 0.03333333333333333,
		damage_timing = 0.03333333333333333,
	},
	force_push = {
		anim_duration = 5.333333333333333,
		damage_timing = 3.3333333333333335,
		vo_event = "psyker_boss_push_attack_a",
		vo_event_chance = 0.3,
		wwise_event = "wwise/events/minions/play_enemy_psyker_magic_charge_big",
		wave_parameters = {
			{
				anim_event = "shockwave_light_01",
				travel_time = 0.5,
				windup_time = {
					3,
					3,
					3,
					2,
					2,
				},
				horizontal_magnitude = {
					15,
					15,
					15,
					15,
					15,
				},
				vertical_magnitude = {
					4,
					4,
					4,
					4,
					4,
				},
				wall_slam_damage_modifier = {
					0.2,
					0.2,
					0.2,
					0.2,
					0.5,
				},
			},
			{
				anim_event = "shockwave_light_02",
				travel_time = 0.5,
				windup_time = {
					3,
					3,
					3,
					2,
					2,
				},
				horizontal_magnitude = {
					19,
					19,
					19,
					19,
					19,
				},
				vertical_magnitude = {
					6,
					6,
					6,
					6,
					6,
				},
				wall_slam_damage_modifier = {
					0.5,
					0.5,
					0.5,
					0.5,
					0.5,
				},
			},
			{
				anim_event = "shockwave_medium_01",
				travel_time = 0.5,
				windup_time = {
					5,
					5,
					4.5,
					2.5,
					2.5,
				},
				horizontal_magnitude = {
					25,
					25,
					25,
					25,
					25,
				},
				vertical_magnitude = {
					8,
					8,
					8,
					8,
					8,
				},
				wall_slam_damage_modifier = {
					1,
					1,
					1,
					1,
					1,
				},
			},
			{
				anim_event = "shockwave_medium_02",
				travel_time = 0.5,
				windup_time = {
					5,
					5,
					4.5,
					2.5,
					2.5,
				},
				horizontal_magnitude = {
					25,
					25,
					25,
					25,
					25,
				},
				vertical_magnitude = {
					8,
					8,
					8,
					8,
					8,
				},
				wall_slam_damage_modifier = {
					1,
					1,
					1,
					1,
					1,
				},
			},
			{
				anim_event = "shockwave_heavy_01",
				travel_time = 0.5,
				windup_time = {
					4,
					4,
					4,
					2.5,
					2.5,
				},
				horizontal_magnitude = {
					25,
					25,
					25,
					25,
					25,
				},
				vertical_magnitude = {
					8,
					8,
					8,
					8,
					8,
				},
				wall_slam_damage_modifier = {
					1,
					1,
					1,
					1,
					1,
				},
			},
			{
				anim_event = "shockwave_heavy_01",
				travel_time = 0.5,
				windup_time = {
					4,
					4,
					4,
					2.5,
					2.5,
				},
				horizontal_magnitude = {
					25,
					25,
					25,
					25,
					25,
				},
				vertical_magnitude = {
					8,
					8,
					8,
					8,
					8,
				},
				wall_slam_damage_modifier = {
					1,
					1,
					1,
					1,
					1,
				},
			},
		},
	},
	upheaval = {
		effect_lerp_duration = 10,
		effect_name = "renegade_wizard_upheaval_charge",
		anim_events = {
			"enter_magic_01",
			"release_upheaval",
		},
		anim_duration = {
			release_upheaval = 1.6666666666666667,
			upheaval = 10,
		},
	},
	shoot = {
		wwise_event = "wwise/events/minions/play_enemy_psyker_magic_charge_small",
		delay_between_basic_attacks = {
			0.5,
			1.5,
		},
		default_trajectory_paramaters = {
			acceptable_accuracy = 1,
			gravity = 0.5,
			speed = 35,
		},
		allowed_attack_types = {
			fan = "fan",
			fan_ground = "fan_ground",
			ground = "ground",
			singular = "singular",
		},
		singular = {
			check_grenade_trajectory_frequency = 0.25,
			multi_shot = false,
			speed = 4.2,
			throw_config = {
				acceptable_accuracy = 0.5,
				item = "content/items/weapons/minions/ranged/minion_psyker_projectile",
				unit_node = "j_rightweaponattach",
				projectile_template = {
					ProjectileTemplates.renegade_wizard_force_ball_nurgle,
					ProjectileTemplates.renegade_wizard_force_ball_warp,
				},
				effect_templates = {
					"renegade_wizard_nurgle_projectile",
					"renegade_wizard_warp_projectile",
				},
			},
			anim_events = {
				"spell_hand_shoot",
			},
			enraged_anim_events = {
				"spell_hand_shoot_aggro",
			},
			anim_timings = {
				ground = {
					2.7333333333333334,
				},
				flying = {
					4,
				},
			},
			enraged_anim_timings = {
				ground = {
					0.9,
				},
				flying = {
					1.2666666666666666,
				},
			},
			anim_duration = {
				flying = 7.333333333333333,
				ground = 4.333333333333333,
			},
			enraged_anim_duration = {
				flying = 2.3333333333333335,
				ground = 2.3333333333333335,
			},
			throw_node_local_offset = Vector3Box(0.2501, 0.6223, 1),
		},
		fan = {
			check_grenade_trajectory_frequency = 0.25,
			multi_shot = true,
			multi_shot_count = 2,
			speed = 4.2,
			throw_config = {
				acceptable_accuracy = 0.5,
				item = "content/items/weapons/minions/ranged/minion_psyker_projectile",
				unit_node = "j_rightweaponattach",
				projectile_template = {
					ProjectileTemplates.renegade_wizard_force_ball_nurgle,
					ProjectileTemplates.renegade_wizard_force_ball_warp,
				},
				effect_templates = {
					"renegade_wizard_nurgle_projectile",
					"renegade_wizard_warp_projectile",
				},
			},
			anim_events = {
				"spell_hand_shoot",
			},
			enraged_anim_events = {
				"spell_hand_shoot_aggro",
			},
			anim_timings = {
				ground = {
					2.7333333333333334,
					2.8333333333333335,
					2.933333333333333,
				},
				flying = {
					3.933333333333333,
					4.033333333333333,
					4.133333333333334,
				},
			},
			enraged_anim_timings = {
				ground = {
					0.9,
					1,
					1.1,
				},
				flying = {
					1.2666666666666666,
					1.3666666666666667,
					1.4666666666666666,
				},
			},
			anim_duration = {
				flying = 7.333333333333333,
				ground = 4.333333333333333,
			},
			enraged_anim_duration = {
				flying = 2.3333333333333335,
				ground = 2.3333333333333335,
			},
			throw_node_local_offset = Vector3Box(0.2501, 0.6223, 1),
			fan_pattern = {
				launch_spread_angle = 12,
				num_shot = 3,
				left_offset = Vector3Box(3, 1, 1),
				right_offset = Vector3Box(-3, 1, 1),
			},
		},
	},
	death = {
		anim_duration = 4.666666666666667,
		death_animation = "kneel",
		effect_template_name = "renegade_wizard_boss_death",
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
		check_grenade_trajectory_frequency = 0.25,
		idle_anim_events = "idle",
		min_distance_from_target = 6,
		move_anim_events = "move_fwd",
		new_location_combat_range = "close",
		new_location_min_dist = 2,
		skulking_vo_interval_t = 2,
		speed = 4.2,
		vo_event = "skulking",
		start_move_anim_events = {
			bwd = "move_start_bwd",
			fwd = "move_start_fwd",
			left = "move_start_left",
			right = "move_start_right",
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
			move_start_bwd = 0,
			move_start_fwd = 0,
			move_start_left = 0,
			move_start_right = 0,
		},
		start_rotation_durations = {
			move_start_bwd = 1,
			move_start_fwd = 0.26666666666666666,
			move_start_left = 0.7666666666666667,
			move_start_right = 0.7,
		},
		throw_distance_thresholds = {
			close = 4,
			medium = 10,
		},
		throw_anim_events = {
			close = {
				"attack_throw_backhand_01",
			},
			medium = {
				"attack_throw_low_01",
			},
			long = {
				"attack_throw_long_01",
				"attack_throw_long_02",
			},
		},
		throw_node_local_offset = {
			attack_throw_backhand_01 = Vector3Box(-0.3496, 0.6266, 1.3162),
			attack_throw_low_01 = Vector3Box(0.2501, 0.6223, 0.4472),
			attack_throw_long_01 = Vector3Box(0.1338, 0.854, 1.8289),
			attack_throw_long_02 = Vector3Box(0.3618, 0.8799, 1.8387),
		},
		throw_config = {
			acceptable_accuracy = 0.5,
			item = "content/items/weapons/minions/ranged/renegade_grenade",
			unit_node = "j_rightweaponattach",
			projectile_template = ProjectileTemplates.renegade_grenadier_fire_grenade,
		},
		throw_position_distance = {
			1,
			2.5,
		},
		new_location_max_dist = math.huge,
	},
	melee_attack = {
		ignore_blocked = true,
		utility_weight = 20,
		weapon_reach = 4,
		considerations = UtilityConsiderations.ranged_elite_melee,
		attack_anim_events = {
			"attack_kick_01",
			"attack_kick_02",
		},
		attack_anim_damage_timings = {
			attack_kick_01 = 0.6944444444444444,
			attack_kick_02 = 0.4444444444444444,
		},
		attack_anim_durations = {
			attack_kick_01 = 1.5555555555555556,
			attack_kick_02 = 1.0555555555555556,
		},
		attack_intensities = {
			melee = 0.5,
			ranged = 2,
		},
		damage_profile = DamageProfileTemplates.spillway_wizard_melee_kick,
		damage_type = damage_types.minion_ogryn_kick,
	},
	summon = {
		amount_of_tries = 5,
		exit_anim_state = "idle",
		initial_delay = 5,
		pre_stinger = "wwise/events/minions/play_enemy_radio_operator_pre_stinger",
		should_refill = false,
		should_spawn_in_los = true,
		shout_radius = 10,
		shout_wwise_event = "wwise/events/minions/play_minion_captain__force_field_overload_vce",
		shout_wwise_event_timing = 0.16666666666666666,
		spawn_aggro_state = "aggroed",
		spawn_using_circle_placement = true,
		stinger = "wwise/events/minions/play_enemy_radio_operator_stinger",
		stinger_delay = 1,
		anim_events = {
			"summon_minions",
		},
		shout_timings = {
			summon_minions = 0.9666666666666667,
		},
		action_durations = {
			summon_minions = 2,
		},
		interval_til_next_summon = {
			4,
			6,
		},
		breed_data = {
			{
				name = "chaos_poxwalker",
				amount = {
					10,
					11,
				},
			},
			{
				name = "chaos_mutated_poxwalker",
				amount = {
					1,
					5,
				},
			},
			{
				name = "chaos_lesser_mutated_poxwalker",
				amount = {
					1,
					4,
				},
			},
		},
		placement_settings = {
			circle_radius = 10,
			num_slots = {
				4,
				7,
			},
			position_offset_range = {
				1,
				7,
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
	warp_teleport = {
		degree_per_direction = 10,
		dive_bomb_t = 0.7333333333333333,
		effect_template_name = "renegade_wizard_boss_teleport",
		max_distance = 2,
		teleport_distance = 4,
		teleport_effect_name = "content/fx/particles/weapons/force_staff/force_staff_impact_01",
		teleport_type = "in",
		utility_weight = 10,
		vo_event = "psyker_boss_combat_taunt_a",
		wwise_teleport_in = "wwise/events/minions/play_enemy_psyker_teleport_out",
		wwise_teleport_out = "wwise/events/minions/play_enemy_psyker_teleport_in",
		considerations = UtilityConsiderations.chaos_daemonhost_warp_teleport,
		teleport_in_anim_events = {
			dive_bomb = "dive_bomb",
			exhausted = "teleport_stunned",
			normal = "teleport_to",
		},
		teleport_timings = {
			dive_bomb = 3,
			teleport_from = 2.066666666666667,
			teleport_stunned = 2.066666666666667,
			teleport_to = 2.8333333333333335,
		},
		teleport_out_anim_events = {
			"teleport_from",
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
}

return action_data
