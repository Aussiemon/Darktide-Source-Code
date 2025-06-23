-- chunkname: @scripts/settings/breed/breed_actions/renegade/renegade_twin_captain_two_actions.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionPushFxTemplates = require("scripts/settings/fx/minion_push_fx_templates")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local action_data = {
	name = "renegade_twin_captain_two",
	idle = {
		anim_events = "idle"
	},
	disappear_idle = {
		anim_events = {
			{
				"foff_rinda_weaklings"
			},
			{
				"foff_rinda_curse_you"
			}
		},
		durations = {
			foff_rinda_curse_you = 5.5,
			foff_rinda_weaklings = 7
		},
		vo_trigger_timings = {
			foff_rinda_curse_you = 0.6666666666666666,
			foff_rinda_weaklings = 0.23333333333333334
		}
	},
	disappear = {
		explode_position_node = "j_spine",
		power_level = 5,
		anim_events = "foff",
		disappear_timings = {
			foff = 0.9333333333333333
		},
		explosion_template = ExplosionTemplates.twin_disappear_explosion,
		vo_event = {
			trigger_id = "cult_retreat_a",
			voice_profile = "captain_twin_female_a"
		}
	},
	disappear_instant = {
		explode_position_node = "j_spine",
		power_level = 5,
		anim_events = "foff",
		disappear_timings = {
			foff = 0
		},
		explosion_template = ExplosionTemplates.twin_disappear_explosion
	},
	move_to_position = {
		idle_anim_events = "idle",
		move_anim_event = "move_fwd_sword",
		speeds = {
			move_fwd_sword = 2
		}
	},
	intro = {
		idle_anim_events = "idle",
		duration = 6,
		move_anim_event = "move_fwd_sword",
		speeds = {
			move_fwd_sword = 0.9
		}
	},
	death = {
		ignore_hit_during_death_ragdoll = true,
		instant_ragdoll_chance = 0,
		death_animations = {
			default = {
				"death_burn_3"
			},
			[hit_zone_names.head] = {
				"death_burn_3"
			},
			[hit_zone_names.torso] = {
				"death_burn_3"
			},
			[hit_zone_names.upper_left_arm] = {
				"death_arm_left"
			},
			[hit_zone_names.lower_left_arm] = {
				"death_burn_3"
			},
			[hit_zone_names.upper_right_arm] = {
				"death_burn_3"
			},
			[hit_zone_names.lower_right_arm] = {
				"death_burn_3"
			},
			[hit_zone_names.upper_left_leg] = {
				"death_burn_3"
			},
			[hit_zone_names.lower_left_leg] = {
				"death_burn_3"
			},
			[hit_zone_names.upper_right_leg] = {
				"death_burn_3"
			},
			[hit_zone_names.lower_right_leg] = {
				"death_burn_3"
			},
			[hit_zone_names.captain_void_shield] = {
				"death_burn_3"
			},
			[hit_zone_names.afro] = {
				"death_burn_3"
			},
			[hit_zone_names.center_mass] = {
				"death_burn_3"
			}
		},
		ragdoll_timings = {
			death_shot_head_right = 4.566666666666666,
			death_slash_left = 3.2666666666666666,
			death_decapitate_3 = 1.4,
			death_strike_chest_right = 1.2666666666666666,
			death_strike_chest_back = 3.1666666666666665,
			death_strike_chest_left = 3.2,
			death_leg_right = 4.5,
			death_slash_right = 2.6666666666666665,
			death_arm_left = 3.033333333333333,
			death_strike_chest_front = 1.6666666666666667,
			death_arm_left_2 = 4,
			death_arm_left_3 = 3.9,
			death_arm_right = 5.1,
			death_decapitate = 3.566666666666667,
			death_arm_right_3 = 2.566666666666667,
			death_stab_chest_front = 3.6333333333333333,
			death_leg_left = 3.066666666666667,
			death_stab_chest_back = 2.5,
			death_burn = 2.566666666666667,
			death_burn_2 = 2.566666666666667,
			death_arm_right_2 = 4.233333333333333,
			death_shot_head_bwd = 3.3333333333333335,
			death_shot_head_left = 2.1,
			death_burn_3 = 4.666666666666667,
			death_shot_head_front = 1.4666666666666666,
			death_burn_4 = 4.4,
			death_leg_both = 4.5,
			death_shot_head_fwd = 2.3666666666666667,
			death_decapitate_2 = 3.1666666666666665
		},
		death_animation_vo = {
			death_burn_3 = "long_death",
			death_arm_left = "long_death"
		}
	},
	climb = {
		stagger_immune = true,
		rotation_duration = 0.1,
		anim_timings = {
			jump_up_3m = 2.923076923076923,
			jump_up_3m_2 = 3.051282051282051,
			jump_down_land = 1.3333333333333333,
			jump_up_1m_2 = 1.0303030303030303,
			jump_up_fence_1m = 0.6,
			jump_up_fence_3m = 1.4,
			jump_up_5m = 4.166666666666667,
			jump_up_fence_5m = 1.3,
			jump_up_1m = 1.2424242424242424
		},
		land_timings = {
			jump_down_1m_2 = 0.16666666666666666,
			jump_down_fence_3m = 0.3333333333333333,
			jump_down_3m = 0.3333333333333333,
			jump_down_fence_5m = 0.3333333333333333,
			jump_down_1m = 0.2,
			jump_down_3m_2 = 0.5,
			jump_down_fence_1m = 0.26666666666666666
		},
		ending_move_states = {
			jump_up_3m = "jumping",
			jump_up_3m_2 = "jumping",
			jump_up_5m = "jumping",
			jump_up_1m_2 = "jumping",
			jump_down_land = "jumping",
			jump_up_1m = "jumping"
		},
		blend_timings = {
			jump_up_3m = 0.1,
			jump_up_3m_2 = 0.1,
			jump_down_land = 0,
			jump_up_1m_2 = 0.1,
			jump_down_3m = 0.1,
			jump_down_3m_2 = 0.1,
			jump_down_1m_2 = 0.1,
			jump_up_fence_1m = 0.2,
			jump_up_fence_3m = 0.2,
			jump_up_5m = 0.1,
			jump_up_fence_5m = 0.2,
			jump_down_1m = 0.1,
			jump_up_1m = 0.1
		}
	},
	jump_across = {
		stagger_immune = true,
		rotation_duration = 0.1,
		anim_timings = {
			jump_over_gap_4m_2 = 1.1333333333333333,
			jump_over_gap_4m = 1.1666666666666667
		},
		ending_move_states = {
			jump_over_gap_4m_2 = "jumping",
			jump_over_gap_4m = "jumping"
		}
	},
	melee_follow = {
		idle_anim_events = "idle",
		utility_weight = 1,
		follow_vo_interval_t = 1,
		leave_walk_distance = 10,
		run_anim_event = "assault_fwd",
		vo_event = "taunt_combat",
		enter_walk_distance = 4,
		walk_anim_event = "move_start_fwd",
		considerations = UtilityConsiderations.melee_follow,
		start_move_anim_events = {
			walking = {
				bwd = "move_start_bwd",
				fwd = "move_start_fwd",
				left = "move_start_left",
				right = "move_start_right"
			}
		},
		start_move_anim_data = {
			move_start_fwd = {},
			move_start_bwd = {
				sign = 1,
				rad = math.pi
			},
			move_start_left = {
				sign = 1,
				rad = math.pi / 2
			},
			move_start_right = {
				sign = -1,
				rad = math.pi / 2
			}
		},
		start_move_rotation_timings = {
			move_start_right = 0.16666666666666666,
			move_start_fwd = 0,
			move_start_bwd = 0.16666666666666666,
			move_start_left = 0.16666666666666666
		},
		start_rotation_durations = {
			move_start_right = 0.7,
			move_start_fwd = 0.26666666666666666,
			move_start_bwd = 1,
			move_start_left = 0.7666666666666667
		},
		start_move_event_anim_speed_durations = {
			move_start_fwd = 1.0666666666666667
		}
	},
	power_sword_moving_melee_attack = {
		height = 3,
		utility_weight = 5,
		ignore_blocked = true,
		aoe_threat_timing = 0.3,
		attack_type = "oobb",
		collision_filter = "filter_minion_melee",
		move_speed_variable_name = "moving_attack_fwd_speed",
		moving_attack = true,
		move_speed_variable_lerp_speed = 4,
		range = 4,
		move_speed = 4,
		width = 2,
		considerations = UtilityConsiderations.renegade_melee_moving_melee_attack,
		attack_anim_events = {
			"attack_move_01",
			"attack_move_02",
			"attack_move_03",
			"attack_move_04"
		},
		attack_anim_damage_timings = {
			attack_move_03 = 1.1111111111111112,
			attack_move_01 = 0.9382716049382716,
			attack_move_04 = 1.0617283950617284,
			attack_move_02 = 1.1111111111111112
		},
		attack_anim_durations = {
			attack_move_03 = 1.728395061728395,
			attack_move_01 = 1.728395061728395,
			attack_move_04 = 1.728395061728395,
			attack_move_02 = 1.728395061728395
		},
		attack_intensities = {
			melee = 0.25,
			running_melee = 1,
			moving_melee = 0.5,
			ranged = 1
		},
		move_start_timings = {
			attack_move_03 = 0.11494252873563218,
			attack_move_01 = 0.11494252873563218,
			attack_move_04 = 0.11494252873563218,
			attack_move_02 = 0.11494252873563218
		},
		damage_profile = DamageProfileTemplates.twin_captain_two_melee_default,
		damage_type = damage_types.minion_powered_sharp,
		stagger_type_reduction = {
			ranged = 20
		},
		animation_move_speed_configs = {
			attack_move_01 = {
				{
					value = 4,
					distance = 4.61
				},
				{
					value = 3,
					distance = 3.39
				},
				{
					value = 2,
					distance = 2.12
				},
				{
					value = 1,
					distance = 1.12
				},
				{
					value = 0,
					distance = 0.35
				}
			},
			attack_move_02 = {
				{
					value = 4,
					distance = 4.64
				},
				{
					value = 3,
					distance = 3.31
				},
				{
					value = 2,
					distance = 2.14
				},
				{
					value = 1,
					distance = 1.13
				},
				{
					value = 0,
					distance = 0.35
				}
			},
			attack_move_03 = {
				{
					value = 4,
					distance = 4.53
				},
				{
					value = 3,
					distance = 3.02
				},
				{
					value = 2,
					distance = 2.12
				},
				{
					value = 1,
					distance = 1.09
				},
				{
					value = 0,
					distance = 0.35
				}
			},
			attack_move_04 = {
				{
					value = 4,
					distance = 4.5
				},
				{
					value = 3,
					distance = 3.42
				},
				{
					value = 2,
					distance = 2.12
				},
				{
					value = 1,
					distance = 1
				},
				{
					value = 0,
					distance = 0.35
				}
			}
		}
	},
	power_sword_melee_combo_attack = {
		height = 2.75,
		ignore_blocked = true,
		utility_weight = 10,
		moving_attack = true,
		range = 3.25,
		attack_type = "oobb",
		collision_filter = "filter_minion_melee",
		aoe_threat_timing = 0.3,
		bot_power_level_modifier = 0.35,
		move_speed = 4,
		rotation_speed = 12,
		ignore_dodge = true,
		width = 1.75,
		considerations = UtilityConsiderations.twin_captain_power_sword_melee_combo_attack,
		attack_anim_events = {
			"attack_swing_combo_02",
			"attack_swing_combo_03",
			"attack_swing_combo_04",
			"attack_swing_combo_05"
		},
		attack_anim_damage_timings = {
			attack_swing_combo_01 = {
				0.6236559139784946,
				1.075268817204301,
				1.8709677419354838
			},
			attack_swing_combo_02 = {
				0.6021505376344086,
				1.075268817204301,
				1.7419354838709677,
				2.4301075268817205
			},
			attack_swing_combo_03 = {
				0.6021505376344086,
				1.2043010752688172,
				1.7419354838709677,
				2.2795698924731185
			},
			attack_swing_combo_04 = {
				0.5591397849462365,
				1.010752688172043,
				1.4838709677419355,
				2.129032258064516
			},
			attack_swing_combo_05 = {
				0.5376344086021505,
				1.075268817204301,
				1.5483870967741935,
				2.150537634408602
			}
		},
		attack_anim_durations = {
			attack_swing_combo_02 = 2.795698924731183,
			attack_swing_combo_01 = 2.150537634408602,
			attack_swing_combo_05 = 2.2580645161290325,
			attack_swing_combo_04 = 2.3655913978494625,
			attack_swing_combo_03 = 2.3010752688172045
		},
		attack_override_damage_data = {
			attack_swing_combo_01 = {
				[3] = {
					override_damage_profile = DamageProfileTemplates.renegade_captain_kick,
					override_damage_type = damage_types.minion_ogryn_kick
				}
			},
			attack_swing_combo_04 = {
				[4] = {
					override_damage_profile = DamageProfileTemplates.renegade_captain_kick,
					override_damage_type = damage_types.minion_ogryn_kick
				}
			}
		},
		attack_intensities = {
			melee = 0.25,
			running_melee = 2,
			moving_melee = 1,
			ranged = 1
		},
		move_start_timings = {
			attack_swing_combo_02 = 0,
			attack_swing_combo_01 = 0,
			attack_swing_combo_05 = 0,
			attack_swing_combo_04 = 0,
			attack_swing_combo_03 = 0
		},
		damage_profile = DamageProfileTemplates.twin_captain_two_melee_default,
		damage_type = damage_types.minion_powered_sharp,
		multi_target_config = {
			rotation_speed = 4.5,
			max_switches = 2,
			force_new_target_attempt_config = {
				max_distance = 4,
				max_angle = math.degrees_to_radians(180)
			}
		},
		effect_template = EffectTemplates.renegade_captain_power_sword_sweep,
		effect_template_start_timings = {
			attack_swing_combo_02 = 0.16666666666666666,
			attack_swing_combo_01 = 0.16666666666666666,
			attack_swing_combo_05 = 0.16666666666666666,
			attack_swing_combo_04 = 0.16666666666666666,
			attack_swing_combo_03 = 0.16666666666666666
		}
	},
	kick = {
		height = 2.5,
		ignore_blocked = true,
		utility_weight = 50,
		aoe_threat_timing = 0.3,
		attack_type = "oobb",
		collision_filter = "filter_minion_melee",
		moving_attack = true,
		range = 3,
		ignore_dodge = true,
		width = 2.25,
		considerations = UtilityConsiderations.twin_kick,
		attack_anim_events = {
			"attack_kick_01",
			"attack_kick_02",
			"attack_knee_01"
		},
		attack_anim_damage_timings = {
			attack_kick_02 = 0.4266666666666667,
			attack_knee_01 = 0.6133333333333333,
			attack_kick_01 = 0.6666666666666666
		},
		attack_anim_durations = {
			attack_kick_02 = 0.6666666666666666,
			attack_knee_01 = 1.2,
			attack_kick_01 = 1.2
		},
		attack_intensities = {
			ranged = 1,
			running_melee = 2,
			moving_melee = 0.1,
			melee = 0.25
		},
		damage_profile = DamageProfileTemplates.renegade_captain_kick,
		damage_type = damage_types.minion_ogryn_kick
	},
	dash = {
		collision_radius = 1.8,
		utility_weight = 10,
		max_duration = 5,
		push_minions_side_relation = "allied",
		dash_speed = 25,
		push_minions_radius = 3,
		power_level = 150,
		vo_event = "cult_switch_focus_a",
		push_minions_power_level = 150,
		considerations = UtilityConsiderations.twin_captain_dash,
		dash_anim_events = {
			"twin_dash_start"
		},
		dash_durations = {
			twin_dash_start = 0.18333333333333332
		},
		reached_destination_anim_events = {
			"attack_charge_miss"
		},
		reached_destination_durations = {
			attack_charge_miss = 0.625
		},
		dash_effect_template = EffectTemplates.renegade_captain_power_sword_sweep,
		push_minions_damage_profile = DamageProfileTemplates.renegade_captain_minion_charge_push,
		push_minions_fx_template = MinionPushFxTemplates.captain_charge_push,
		push_minions_fx_cooldown = {
			0.03,
			0.18
		},
		collision_angle = math.degrees_to_radians(100),
		damage_profile = DamageProfileTemplates.twin_dash,
		damage_type = damage_types.minion_charge
	},
	dash_fast = {
		collision_radius = 1.8,
		utility_weight = 10,
		max_duration = 5,
		push_minions_side_relation = "allied",
		dash_speed = 25,
		push_minions_radius = 3,
		power_level = 150,
		vo_event = "cult_switch_focus_a",
		push_minions_power_level = 150,
		considerations = UtilityConsiderations.twin_captain_dash,
		dash_anim_events = {
			"twin_dash_start"
		},
		dash_durations = {
			twin_dash_start = 0.18333333333333332
		},
		reached_destination_anim_events = {
			"attack_charge_miss"
		},
		reached_destination_durations = {
			attack_charge_miss = 0.0625
		},
		dash_effect_template = EffectTemplates.renegade_captain_power_sword_sweep,
		push_minions_damage_profile = DamageProfileTemplates.renegade_captain_minion_charge_push,
		push_minions_fx_template = MinionPushFxTemplates.captain_charge_push,
		push_minions_fx_cooldown = {
			0.03,
			0.18
		},
		collision_angle = math.degrees_to_radians(100),
		damage_profile = DamageProfileTemplates.twin_dash_light,
		damage_type = damage_types.minion_charge
	},
	random_dash = {
		utility_weight = 10,
		random_target_position = true,
		push_minions_side_relation = "allied",
		dash_speed = 30,
		collision_radius = 1.8,
		power_level = 150,
		max_duration = 5,
		push_minions_power_level = 150,
		push_minions_radius = 3,
		considerations = UtilityConsiderations.twin_captain_random_dash,
		num_dashes = {
			4,
			6
		},
		random_position_distance = {
			3,
			8
		},
		dash_anim_events = {
			"twin_dash_start"
		},
		dash_durations = {
			twin_dash_start = 0.18333333333333332
		},
		reached_destination_anim_events = {
			"attack_charge_miss"
		},
		reached_destination_durations = {
			attack_charge_miss = 0.625
		},
		dash_effect_template = EffectTemplates.renegade_captain_power_sword_sweep,
		push_minions_damage_profile = DamageProfileTemplates.renegade_captain_minion_charge_push,
		push_minions_fx_template = MinionPushFxTemplates.captain_charge_push,
		push_minions_fx_cooldown = {
			0.03,
			0.18
		},
		collision_angle = math.degrees_to_radians(100),
		damage_profile = DamageProfileTemplates.twin_dash,
		damage_type = damage_types.minion_charge
	},
	random_dash_short = {
		utility_weight = 10,
		random_target_position = true,
		push_minions_side_relation = "allied",
		dash_speed = 30,
		collision_radius = 1.8,
		power_level = 150,
		max_duration = 5,
		push_minions_power_level = 150,
		push_minions_radius = 3,
		considerations = UtilityConsiderations.twin_captain_random_dash,
		num_dashes = {
			1,
			1
		},
		random_position_distance = {
			3,
			8
		},
		dash_anim_events = {
			"twin_dash_start"
		},
		dash_durations = {
			twin_dash_start = 0.18333333333333332
		},
		reached_destination_anim_events = {
			"attack_charge_miss"
		},
		reached_destination_durations = {
			attack_charge_miss = 0.0625
		},
		dash_effect_template = EffectTemplates.renegade_captain_power_sword_sweep,
		push_minions_damage_profile = DamageProfileTemplates.renegade_captain_minion_charge_push,
		push_minions_fx_template = MinionPushFxTemplates.captain_charge_push,
		push_minions_fx_cooldown = {
			0.03,
			0.18
		},
		collision_angle = math.degrees_to_radians(100),
		damage_profile = DamageProfileTemplates.twin_dash,
		damage_type = damage_types.minion_charge
	},
	power_sword_melee_sweep = {
		ignore_blocked = true,
		utility_weight = 30,
		vo_event = "taunt_combat",
		aoe_bot_threat_broadphase_size = 5,
		attack_type = "sweep",
		collision_filter = "filter_minion_melee_friendly_fire",
		move_speed_variable_name = "moving_attack_fwd_speed",
		moving_attack = true,
		aoe_threat_timing = 1,
		move_speed_variable_lerp_speed = 4,
		assault_vo_interval_t = 1,
		weapon_reach = 3.5,
		bot_power_level_modifier = 0.2,
		sweep_node = "j_lefthandmiddle1",
		hit_zone_name = "center_mass",
		aoe_threat_duration = 1.5,
		considerations = UtilityConsiderations.renegade_captain_power_sword_melee_sweep,
		attack_anim_events = {
			"attack_heavy_swing_fast",
			"attack_heavy_swing_fast_02"
		},
		attack_sweep_damage_timings = {
			attack_heavy_swing_fast = {
				0.8333333333333334,
				1.1666666666666667
			},
			attack_heavy_swing_fast_02 = {
				1.3541666666666667,
				1.4583333333333333
			}
		},
		attack_anim_durations = {
			attack_heavy_swing_fast = 1.6666666666666667,
			attack_heavy_swing_fast_02 = 1.6666666666666667
		},
		attack_intensities = {
			melee = 0.25,
			running_melee = 2,
			moving_melee = 1,
			ranged = 1
		},
		damage_profile = DamageProfileTemplates.twin_captain_two_aoe_sweep,
		offtarget_damage_profile = DamageProfileTemplates.twin_captain_two_aoe_sweep,
		stagger_type_reduction = {
			ranged = 100
		},
		damage_type = damage_types.minion_powered_sharp,
		effect_template = EffectTemplates.renegade_twin_captain_power_sword_sweep,
		effect_template_start_timings = {
			attack_heavy_swing_fast = 0.16666666666666666,
			attack_heavy_swing_fast_02 = 0.3333333333333333
		}
	},
	power_sword_moving_melee_sweep = {
		ignore_blocked = true,
		utility_weight = 30,
		vo_event = "taunt_combat",
		aoe_threat_timing = 0.3,
		attack_type = "sweep",
		collision_filter = "filter_minion_melee_friendly_fire",
		dodge_weapon_reach = 3.5,
		moving_attack = true,
		assault_vo_interval_t = 1,
		move_speed_variable_lerp_speed = 4,
		weapon_reach = 5,
		move_speed_variable_name = "moving_attack_fwd_speed",
		sweep_node = "j_lefthandmiddle1",
		hit_zone_name = "center_mass",
		considerations = UtilityConsiderations.renegade_captain_power_sword_melee_sweep,
		attack_anim_events = {
			"attack_heavy_swing_moving"
		},
		attack_sweep_damage_timings = {
			attack_heavy_swing_moving = {
				1.4666666666666666,
				1.6
			}
		},
		attack_anim_durations = {
			attack_heavy_swing_moving = 2.5
		},
		attack_intensities = {
			melee = 0.25,
			running_melee = 2,
			moving_melee = 1,
			ranged = 1
		},
		damage_profile = DamageProfileTemplates.twin_captain_two_aoe_sweep,
		offtarget_damage_profile = DamageProfileTemplates.twin_captain_two_aoe_sweep,
		stagger_type_reduction = {
			ranged = 100
		},
		damage_type = damage_types.minion_powered_sharp,
		effect_template = EffectTemplates.renegade_twin_captain_power_sword_sweep,
		effect_template_start_timings = {
			attack_heavy_swing_moving = 0.3333333333333333
		}
	},
	shield_down_recharge = {
		shield_break_duration = 10,
		vo_event = "taunt_shield",
		stand_up_anim_duration = 1.3333333333333333,
		anim_events = {
			"stagger_shield_break_charge_into"
		},
		stand_up_anim_events = {
			"stagger_shield_break_charge_outof"
		},
		regen_speed = {
			300,
			400,
			500,
			600,
			800
		},
		charge_effect_template = EffectTemplates.linked_beam,
		regenerate_full_delay = {
			20,
			18,
			16,
			14,
			12
		}
	},
	dash_and_sweep = {
		utility_weight = 300,
		considerations = UtilityConsiderations.twin_captain_dash_and_sweep
	},
	empowered_dash_and_sweep = {
		utility_weight = 600,
		considerations = UtilityConsiderations.twin_captain_dash_and_sweep
	},
	stagger = {
		stagger_duration_mods = {
			stagger_explosion_front_2 = 0.8
		},
		stagger_anims = {
			light = {
				fwd = {
					"stagger_fwd_light",
					"stagger_fwd_light_2",
					"stagger_fwd_light_3",
					"stagger_fwd_light_4",
					"stagger_fwd_light_5",
					"stagger_fwd_light_6"
				},
				bwd = {
					"stagger_bwd_light",
					"stagger_bwd_light_2",
					"stagger_bwd_light_3",
					"stagger_bwd_light_4",
					"stagger_bwd_light_5",
					"stagger_bwd_light_6",
					"stagger_bwd_light_7",
					"stagger_bwd_light_8"
				},
				left = {
					"stagger_left_light",
					"stagger_left_light_2",
					"stagger_left_light_3",
					"stagger_left_light_4"
				},
				right = {
					"stagger_right_light",
					"stagger_right_light_2",
					"stagger_right_light_3",
					"stagger_right_light_4"
				},
				dwn = {
					"stagger_bwd_light"
				}
			},
			medium = {
				fwd = {
					"stagger_fwd",
					"stagger_fwd_2",
					"stagger_fwd_3",
					"stagger_fwd_4"
				},
				bwd = {
					"stagger_bwd",
					"stagger_bwd_2",
					"stagger_bwd_3",
					"stagger_bwd_4"
				},
				left = {
					"stagger_left",
					"stagger_left_2",
					"stagger_left_3",
					"stagger_left_4",
					"stagger_left_5"
				},
				right = {
					"stagger_right",
					"stagger_right_2",
					"stagger_right_3",
					"stagger_right_4",
					"stagger_right_5"
				},
				dwn = {
					"stagger_medium_downward",
					"stagger_medium_downward_2",
					"stagger_medium_downward_3"
				}
			},
			heavy = {
				fwd = {
					"stagger_fwd_heavy"
				},
				bwd = {
					"stagger_bwd_heavy"
				},
				left = {
					"stagger_left_heavy"
				},
				right = {
					"stagger_right_heavy"
				},
				dwn = {
					"stagger_dwn_heavy"
				}
			},
			light_ranged = {
				fwd = {
					"stagger_fwd_light"
				},
				bwd = {
					"stagger_bwd_light"
				},
				left = {
					"stagger_left_light"
				},
				right = {
					"stagger_right_light"
				}
			},
			explosion = {
				fwd = {
					"stagger_fwd_heavy"
				},
				bwd = {
					"stagger_bwd_heavy"
				},
				left = {
					"stagger_left_heavy"
				},
				right = {
					"stagger_right_heavy"
				}
			},
			killshot = {
				fwd = {
					"stagger_fwd_light",
					"stagger_fwd_light_2",
					"stagger_fwd_light_3",
					"stagger_fwd_light_4",
					"stagger_fwd_light_5",
					"stagger_fwd_light_6"
				},
				bwd = {
					"stagger_bwd_light",
					"stagger_bwd_light_2",
					"stagger_bwd_light_3",
					"stagger_bwd_light_4",
					"stagger_bwd_light_5",
					"stagger_bwd_light_6",
					"stagger_bwd_light_7",
					"stagger_bwd_light_8"
				},
				left = {
					"stagger_left_light",
					"stagger_left_light_2",
					"stagger_left_light_3",
					"stagger_left_light_4"
				},
				right = {
					"stagger_right_light",
					"stagger_right_light_2",
					"stagger_right_light_3",
					"stagger_right_light_4"
				},
				dwn = {
					"stagger_bwd_light"
				}
			},
			sticky = {
				bwd = {
					"stagger_front_sticky",
					"stagger_front_sticky_2",
					"stagger_front_sticky_3"
				},
				fwd = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3"
				},
				left = {
					"stagger_left_sticky",
					"stagger_left_sticky_2",
					"stagger_left_sticky_3"
				},
				right = {
					"stagger_right_sticky",
					"stagger_right_sticky_2",
					"stagger_right_sticky_3"
				},
				dwn = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3"
				}
			},
			electrocuted = {
				bwd = {
					"stagger_front_sticky",
					"stagger_front_sticky_2",
					"stagger_front_sticky_3"
				},
				fwd = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3"
				},
				left = {
					"stagger_left_sticky",
					"stagger_left_sticky_2",
					"stagger_left_sticky_3"
				},
				right = {
					"stagger_right_sticky",
					"stagger_right_sticky_2",
					"stagger_right_sticky_3"
				},
				dwn = {
					"stagger_bwd_sticky",
					"stagger_bwd_sticky_2",
					"stagger_bwd_sticky_3"
				}
			},
			shield_broken = {
				fwd = {
					"stagger_shield_break"
				},
				bwd = {
					"stagger_shield_break"
				},
				left = {
					"stagger_shield_break"
				},
				right = {
					"stagger_shield_break"
				},
				dwn = {
					"stagger_shield_break"
				}
			},
			wall_collision = {
				fwd = {
					"stagger_wall_hit"
				},
				bwd = {
					"stagger_wall_hit"
				},
				left = {
					"stagger_wall_hit"
				},
				right = {
					"stagger_wall_hit"
				},
				dwn = {
					"stagger_wall_hit"
				}
			},
			blinding = {
				fwd = {
					"stagger_fwd_light",
					"stagger_fwd_light_2",
					"stagger_fwd_light_3",
					"stagger_fwd_light_4",
					"stagger_fwd_light_5",
					"stagger_fwd_light_6"
				},
				bwd = {
					"stagger_bwd_light",
					"stagger_bwd_light_2",
					"stagger_bwd_light_3",
					"stagger_bwd_light_4",
					"stagger_bwd_light_5",
					"stagger_bwd_light_6",
					"stagger_bwd_light_7",
					"stagger_bwd_light_8"
				},
				left = {
					"stagger_left_light",
					"stagger_left_light_2",
					"stagger_left_light_3",
					"stagger_left_light_4"
				},
				right = {
					"stagger_right_light",
					"stagger_right_light_2",
					"stagger_right_light_3",
					"stagger_right_light_4"
				},
				dwn = {
					"stagger_bwd_light"
				}
			}
		}
	},
	smash_obstacle = {
		power_level = 1000,
		rotation_duration = 0.1,
		attack_anim_events = {
			"attack_kick_01"
		},
		attack_anim_damage_timings = {
			attack_kick_01 = 0.6666666666666666
		},
		attack_anim_durations = {
			attack_kick_01 = 1.0666666666666667
		},
		damage_profile = DamageProfileTemplates.default
	},
	open_door = {
		rotation_duration = 0.1,
		stagger_immune = true
	},
	exit_spawner = {
		run_anim_event = "move_fwd"
	}
}

return action_data
