-- chunkname: @scripts/settings/breed/breed_actions/cultist/cultist_captain_actions.lua

local BreedShootTemplates = require("scripts/settings/breed/breed_shoot_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local GroundImpactFxTemplates = require("scripts/settings/fx/ground_impact_fx_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local MinionPushFxTemplates = require("scripts/settings/fx/minion_push_fx_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local shooting_difficulty_settings = MinionDifficultySettings.shooting
local shooting_difficulty_settings_bolt_pistol = shooting_difficulty_settings.renegade_captain_bolt_pistol
local shooting_difficulty_settings_plasma_pistol = shooting_difficulty_settings.renegade_captain_plasma_pistol
local shooting_difficulty_settings_plasma_pistol_volley = shooting_difficulty_settings.renegade_captain_plasma_pistol_volley
local shooting_difficulty_settings_fullauto = shooting_difficulty_settings.renegade_captain_fullauto
local shooting_difficulty_settings_burst = shooting_difficulty_settings.renegade_captain_burst
local shooting_difficulty_settings_netgun = shooting_difficulty_settings.renegade_captain_netgun
local shooting_difficulty_settings_shotgun = shooting_difficulty_settings.renegade_captain_shotgun
local hit_zone_names = HitZone.hit_zone_names
local action_data = {
	name = "cultist_captain",
	idle = {
		anim_events = "idle"
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
	melee_combat_idle = {
		utility_weight = 2,
		anim_events = "idle",
		rotate_towards_target = true,
		considerations = UtilityConsiderations.melee_combat_idle
	},
	alerted = {
		alerted_duration = 1,
		alerted_anim_events = {
			"alerted"
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
	ranged_follow = {
		idle_anim_events = "idle",
		min_distance_to_target = 4.5,
		utility_weight = 5,
		vo_event = "taunt_combat",
		move_to_fail_cooldown = 1,
		randomized_direction_degree_range = 120,
		degree_per_direction = 10,
		move_anim_events = "move_fwd",
		move_to_cooldown = 0.25,
		speed = 4.2,
		max_distance_to_target = 8,
		considerations = UtilityConsiderations.ranged_follow_no_los,
		start_move_anim_events = {
			bwd = "move_start_bwd",
			fwd = "move_start_fwd",
			left = "move_start_left",
			right = "move_start_right"
		},
		start_move_anim_data = {
			move_start_fwd = {},
			move_start_bwd = {
				sign = -1,
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
			move_start_right = 0,
			move_start_fwd = 0,
			move_start_bwd = 0,
			move_start_left = 0
		},
		start_rotation_durations = {
			move_start_right = 0.26666666666666666,
			move_start_fwd = 0.26666666666666666,
			move_start_bwd = 0.26666666666666666,
			move_start_left = 0.26666666666666666
		}
	},
	bolt_pistol_shoot = {
		max_distance_to_target = 12,
		strafe_speed = 2.3,
		can_strafe_shoot = true,
		strafe_shoot_distance = 3,
		degree_per_direction = 10,
		strafe_end_anim_event = "aim_standing",
		strafe_shoot_ranged_position_fallback = true,
		inventory_slot = "slot_bolt_pistol",
		randomized_direction_degree_range = 180,
		exit_after_cooldown = true,
		utility_weight = 5,
		move_to_fail_cooldown = 1,
		suppressive_fire = true,
		attack_intensity_type = "ranged",
		reset_dodge_check_after_each_shot = true,
		move_to_cooldown = 0.25,
		min_distance_to_target = 6,
		fx_source_name = "muzzle",
		considerations = UtilityConsiderations.renegade_captain_bolt_pistol_shoot,
		aim_anim_events = {
			"aim_standing"
		},
		aim_duration = {
			aim_standing = shooting_difficulty_settings_bolt_pistol.aim_durations
		},
		aim_stances = {
			aim_standing = "pistol_standing"
		},
		shoot_cooldown = shooting_difficulty_settings_bolt_pistol.shoot_cooldown,
		num_shots = shooting_difficulty_settings_bolt_pistol.num_shots,
		time_per_shot = shooting_difficulty_settings_bolt_pistol.time_per_shot,
		dodge_window = shooting_difficulty_settings_bolt_pistol.shoot_dodge_window,
		attack_intensities = {
			ranged = 3
		},
		shoot_template = BreedShootTemplates.renegade_captain_bolt_pistol,
		multi_target_config = {
			rotation_speed = 4.5,
			max_switches = 2,
			force_new_target_attempt_config = {
				max_distance = 15,
				max_angle = math.degrees_to_radians(100)
			}
		},
		strafe_anim_events = {
			bwd = "move_bwd_walk_aim",
			fwd = "move_fwd_walk_aim",
			left = "move_left_walk_aim",
			right = "move_right_walk_aim"
		}
	},
	plasma_pistol_shoot = {
		max_distance_to_target = 12,
		strafe_speed = 2.3,
		can_strafe_shoot = true,
		strafe_shoot_distance = 3,
		degree_per_direction = 10,
		strafe_end_anim_event = "aim_standing",
		inventory_slot = "slot_plasma_pistol",
		randomized_direction_degree_range = 180,
		utility_weight = 2,
		exit_after_cooldown = true,
		move_to_fail_cooldown = 1,
		before_shoot_effect_template_timing = 1.25,
		strafe_shoot_ranged_position_fallback = true,
		suppressive_fire = true,
		attack_intensity_type = "ranged",
		reset_dodge_check_after_each_shot = true,
		move_to_cooldown = 0.25,
		min_distance_to_target = 6,
		fx_source_name = "muzzle",
		considerations = UtilityConsiderations.renegade_captain_bolt_pistol_shoot,
		aim_anim_events = {
			"aim_standing"
		},
		aim_duration = {
			aim_standing = shooting_difficulty_settings_plasma_pistol.aim_durations
		},
		aim_stances = {
			aim_standing = "pistol_standing"
		},
		shoot_cooldown = shooting_difficulty_settings_plasma_pistol.shoot_cooldown,
		num_shots = shooting_difficulty_settings_plasma_pistol.num_shots,
		time_per_shot = shooting_difficulty_settings_plasma_pistol.time_per_shot,
		dodge_window = shooting_difficulty_settings_plasma_pistol.shoot_dodge_window,
		attack_intensities = {
			ranged = 6
		},
		shoot_template = BreedShootTemplates.renegade_captain_plasma_pistol,
		strafe_anim_events = {
			bwd = "move_bwd_walk_aim",
			fwd = "move_fwd_walk_aim",
			left = "move_left_walk_aim",
			right = "move_right_walk_aim"
		},
		before_shoot_effect_template = EffectTemplates.renegade_captain_plasma_pistol_charge_up
	},
	plasma_pistol_shoot_volley = {
		max_distance_to_target = 12,
		strafe_speed = 2.3,
		can_strafe_shoot = true,
		strafe_shoot_distance = 3,
		degree_per_direction = 10,
		strafe_end_anim_event = "aim_standing",
		inventory_slot = "slot_plasma_pistol",
		randomized_direction_degree_range = 180,
		utility_weight = 2,
		exit_after_cooldown = true,
		move_to_fail_cooldown = 1,
		before_shoot_effect_template_timing = 1.25,
		strafe_shoot_ranged_position_fallback = true,
		suppressive_fire = true,
		attack_intensity_type = "ranged",
		reset_dodge_check_after_each_shot = true,
		move_to_cooldown = 0.25,
		min_distance_to_target = 6,
		fx_source_name = "muzzle",
		considerations = UtilityConsiderations.renegade_captain_plasma_pistol_shoot_volley,
		aim_anim_events = {
			"aim_standing"
		},
		aim_duration = {
			aim_standing = shooting_difficulty_settings_plasma_pistol_volley.aim_durations
		},
		aim_stances = {
			aim_standing = "pistol_standing"
		},
		shoot_cooldown = shooting_difficulty_settings_plasma_pistol_volley.shoot_cooldown,
		num_shots = shooting_difficulty_settings_plasma_pistol_volley.num_shots,
		time_per_shot = shooting_difficulty_settings_plasma_pistol_volley.time_per_shot,
		dodge_window = shooting_difficulty_settings_plasma_pistol_volley.shoot_dodge_window,
		attack_intensities = {
			ranged = 6
		},
		shoot_template = BreedShootTemplates.renegade_captain_plasma_pistol,
		strafe_anim_events = {
			bwd = "move_bwd_walk_aim",
			fwd = "move_fwd_walk_aim",
			left = "move_left_walk_aim",
			right = "move_right_walk_aim"
		},
		before_shoot_effect_template = EffectTemplates.renegade_captain_plasma_pistol_charge_up,
		multi_target_config = {
			rotation_speed = 4.5,
			max_switches = 8,
			force_new_target_attempt_config = {
				max_distance = 15,
				max_angle = math.degrees_to_radians(180)
			}
		}
	},
	hellgun_shoot = {
		max_distance_to_target = 12,
		strafe_speed = 2.3,
		can_strafe_shoot = true,
		utility_weight = 5,
		strafe_shoot_distance = 3,
		degree_per_direction = 10,
		inventory_slot = "slot_hellgun",
		randomized_direction_degree_range = 180,
		strafe_end_anim_event = "aim_standing",
		move_to_fail_cooldown = 1,
		exit_after_cooldown = true,
		strafe_shoot_ranged_position_fallback = true,
		suppressive_fire = true,
		attack_intensity_type = "ranged",
		move_to_cooldown = 0.25,
		min_distance_to_target = 6,
		fx_source_name = "muzzle",
		considerations = UtilityConsiderations.renegade_captain_hellgun_shoot,
		aim_anim_events = {
			"hip_fire"
		},
		aim_duration = {
			hip_fire = shooting_difficulty_settings_burst.aim_durations
		},
		shoot_cooldown = shooting_difficulty_settings_burst.shoot_cooldown,
		num_shots = shooting_difficulty_settings_burst.num_shots,
		time_per_shot = shooting_difficulty_settings_burst.time_per_shot,
		dodge_window = shooting_difficulty_settings_burst.shoot_dodge_window,
		attack_intensities = {
			ranged = 3
		},
		shoot_template = BreedShootTemplates.renegade_captain_hellgun_default,
		strafe_anim_events = {
			bwd = "move_bwd_walk_aim",
			fwd = "move_fwd_walk_aim",
			left = "move_left_walk_aim",
			right = "move_right_walk_aim"
		}
	},
	hellgun_spray_and_pray = {
		exit_after_cooldown = true,
		utility_weight = 10,
		suppressive_fire = true,
		attack_intensity_type = "ranged",
		inventory_slot = "slot_hellgun",
		fx_source_name = "muzzle",
		considerations = UtilityConsiderations.renegade_captain_hellgun_spray_and_pray,
		aim_anim_events = {
			"hip_fire"
		},
		aim_duration = {
			hip_fire = shooting_difficulty_settings_fullauto.aim_durations
		},
		shoot_cooldown = shooting_difficulty_settings_fullauto.shoot_cooldown,
		num_shots = shooting_difficulty_settings_fullauto.num_shots,
		time_per_shot = shooting_difficulty_settings_fullauto.time_per_shot,
		dodge_window = shooting_difficulty_settings_fullauto.shoot_dodge_window,
		attack_intensities = {
			ranged = 20
		},
		shoot_template = BreedShootTemplates.renegade_captain_hellgun_default
	},
	kick = {
		height = 2.5,
		ignore_blocked = true,
		utility_weight = 5,
		aoe_threat_timing = 0.3,
		attack_type = "oobb",
		collision_filter = "filter_minion_melee",
		moving_attack = true,
		range = 3,
		ignore_dodge = true,
		width = 2.25,
		considerations = UtilityConsiderations.renegade_captain_kick,
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
			attack_kick_02 = 1.2266666666666666,
			attack_knee_01 = 1.68,
			attack_kick_01 = 1.7333333333333334
		},
		attack_intensities = {
			ranged = 1,
			running_melee = 2,
			moving_melee = 0.1,
			melee = 0.25
		},
		damage_profile = DamageProfileTemplates.renegade_captain_kick,
		damage_type = damage_types.minion_melee_blunt_elite
	},
	punch = {
		range = 3,
		ignore_blocked = true,
		attack_type = "oobb",
		collision_filter = "filter_minion_melee",
		height = 2.5,
		ignore_dodge = true,
		moving_attack = true,
		width = 2.25,
		utility_weight = 5,
		considerations = UtilityConsiderations.renegade_captain_punch,
		attack_anim_events = {
			"attack_pommel_01",
			"attack_pommel_02",
			"attack_pommel_03"
		},
		attack_anim_damage_timings = {
			attack_pommel_01 = 0.5432098765432098,
			attack_pommel_03 = 0.8148148148148148,
			attack_pommel_02 = 0.7160493827160493
		},
		attack_anim_durations = {
			attack_pommel_01 = 1.3580246913580247,
			attack_pommel_03 = 1.8518518518518519,
			attack_pommel_02 = 1.6049382716049383
		},
		attack_intensities = {
			ranged = 1,
			running_melee = 2,
			moving_melee = 0.1,
			melee = 0.25
		},
		damage_profile = DamageProfileTemplates.renegade_captain_punch,
		damage_type = damage_types.minion_melee_blunt_elite
	},
	melee_follow_power_sword = {
		idle_anim_events = "idle",
		utility_weight = 1,
		follow_vo_interval_t = 1,
		leave_walk_distance = 6,
		run_anim_event = "move_fwd",
		vo_event = "taunt_combat",
		enter_walk_distance = 4,
		walk_anim_event = "move_start_fwd",
		considerations = UtilityConsiderations.melee_follow,
		start_move_anim_events = {
			walking = {
				bwd = "move_bwd_walk",
				fwd = "move_fwd_walk",
				left = "move_left_walk",
				right = "move_right_walk"
			},
			running = {
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
	power_sword_melee_attack = {
		weapon_reach = 3.5,
		ignore_blocked = true,
		utility_weight = 1,
		considerations = UtilityConsiderations.melee_attack,
		attack_anim_events = {
			"attack_04",
			"attack_05",
			"attack_06",
			"attack_07"
		},
		attack_anim_damage_timings = {
			attack_05 = 0.6875,
			attack_06 = 0.6458333333333334,
			attack_04 = 0.6458333333333334,
			attack_07 = 0.6458333333333334
		},
		attack_anim_durations = {
			attack_05 = 1.3958333333333333,
			attack_06 = 1.25,
			attack_04 = 1.25,
			attack_07 = 1.3333333333333333
		},
		attack_intensities = {
			ranged = 1,
			melee = 0.25
		},
		damage_profile = DamageProfileTemplates.renegade_captain_melee_default,
		damage_type = damage_types.minion_powered_sharp
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
		considerations = UtilityConsiderations.renegade_captain_power_sword_moving_melee_attack,
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
		damage_profile = DamageProfileTemplates.renegade_captain_melee_default,
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
		move_speed = 4,
		rotation_speed = 12,
		ignore_dodge = true,
		width = 1.75,
		considerations = UtilityConsiderations.renegade_captain_power_sword_melee_combo_attack,
		attack_anim_events = {
			"attack_swing_combo_01",
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
			attack_swing_combo_02 = 3.466666666666667,
			attack_swing_combo_01 = 2.4,
			attack_swing_combo_05 = 2.8,
			attack_swing_combo_04 = 2.6666666666666665,
			attack_swing_combo_03 = 2.8533333333333335
		},
		attack_override_damage_data = {
			attack_swing_combo_01 = {
				[3] = {
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
		damage_profile = DamageProfileTemplates.renegade_captain_melee_default,
		damage_type = damage_types.minion_powered_sharp,
		multi_target_config = {
			rotation_speed = 4.5,
			max_switches = 2,
			force_new_target_attempt_config = {
				max_distance = 3,
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
	power_sword_melee_sweep = {
		ignore_blocked = true,
		utility_weight = 30,
		vo_event = "taunt_combat",
		attack_type = "sweep",
		collision_filter = "filter_minion_melee_friendly_fire",
		aoe_threat_timing = 0.3,
		assault_vo_interval_t = 1,
		move_speed_variable_lerp_speed = 4,
		weapon_reach = 4,
		move_speed_variable_name = "moving_attack_fwd_speed",
		sweep_node = "j_lefthandmiddle1",
		hit_zone_name = "center_mass",
		considerations = UtilityConsiderations.renegade_captain_power_sword_melee_sweep,
		attack_anim_events = {
			"attack_heavy_swing"
		},
		attack_sweep_damage_timings = {
			attack_heavy_swing = {
				2.1666666666666665,
				2.3333333333333335
			}
		},
		attack_anim_durations = {
			attack_heavy_swing = 3.3333333333333335
		},
		attack_intensities = {
			melee = 0.25,
			running_melee = 2,
			moving_melee = 1,
			ranged = 1
		},
		damage_profile = DamageProfileTemplates.renegade_captain_power_sword_melee_sweep,
		offtarget_damage_profile = DamageProfileTemplates.renegade_captain_offtarget_melee,
		stagger_type_reduction = {
			ranged = 100
		},
		damage_type = damage_types.minion_powered_sharp,
		effect_template = EffectTemplates.renegade_captain_power_sword_sweep,
		effect_template_start_timings = {
			attack_heavy_swing = 0.6666666666666666
		}
	},
	melee_follow_powermaul = {
		idle_anim_events = "idle",
		utility_weight = 1,
		follow_vo_interval_t = 1,
		leave_walk_distance = 6,
		run_anim_event = "move_fwd",
		vo_event = "taunt_combat",
		enter_walk_distance = 4,
		walk_anim_event = "move_fwd_walk",
		considerations = UtilityConsiderations.melee_follow,
		start_move_anim_events = {
			walking = {
				bwd = "move_bwd_walk",
				fwd = "move_fwd_walk",
				left = "move_left_walk",
				right = "move_right_walk"
			},
			running = {
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
			move_start_right = 0,
			move_start_fwd = 0,
			move_start_bwd = 0,
			move_start_left = 0
		},
		start_rotation_durations = {
			move_start_right = 0.9333333333333333,
			move_start_fwd = 0.26666666666666666,
			move_start_bwd = 1.1333333333333333,
			move_start_left = 0.8333333333333334
		},
		start_move_event_anim_speed_durations = {
			move_start_fwd = 1.2666666666666666
		}
	},
	powermaul_melee_cleave = {
		height = 3,
		utility_weight = 1,
		aoe_threat_timing = 0.3,
		attack_type = "oobb",
		collision_filter = "filter_minion_melee",
		dodge_range = 2.75,
		power_level_type = "melee_two_hand",
		dodge_width = 1.1,
		range = 4,
		width = 2,
		considerations = UtilityConsiderations.melee_attack,
		attack_anim_events = {
			"attack_01",
			"attack_02"
		},
		attack_anim_damage_timings = {
			attack_01 = 1.5172413793103448,
			attack_02 = 1.3103448275862069
		},
		attack_anim_durations = {
			attack_01 = 3.103448275862069,
			attack_02 = 2.8735632183908044
		},
		attack_intensities = {
			melee = 2.5,
			running_melee = 2.5,
			moving_melee = 2.5,
			ranged = 1
		},
		stagger_type_reduction = {
			ranged = 20,
			melee = 20
		},
		damage_profile = DamageProfileTemplates.renegade_captain_powermaul_melee_cleave,
		damage_type = damage_types.minion_melee_blunt_elite,
		ground_impact_fx_template = GroundImpactFxTemplates.renegade_captain_powermaul_melee_cleave,
		effect_template = EffectTemplates.renegade_captain_powermaul_ground_slam,
		effect_template_start_timings = {
			attack_01 = 0,
			attack_02 = 0
		}
	},
	powermaul_moving_melee_cleave = {
		height = 3,
		move_speed = 4,
		utility_weight = 1,
		range = 4,
		attack_type = "oobb",
		collision_filter = "filter_minion_melee_friendly_fire",
		aoe_threat_timing = 0.3,
		moving_attack = true,
		dodge_range = 2.75,
		move_speed_variable_lerp_speed = 4,
		dodge_width = 1.1,
		power_level_type = "melee_two_hand",
		move_speed_variable_name = "moving_attack_fwd_speed",
		width = 2,
		considerations = UtilityConsiderations.renegade_executor_moving_melee_attack,
		attack_anim_events = {
			"attack_move_01"
		},
		attack_anim_damage_timings = {
			attack_move_01 = 1.4814814814814814
		},
		attack_anim_durations = {
			attack_move_01 = 2.8395061728395063
		},
		attack_intensities = {
			melee = 2.5,
			running_melee = 2.5,
			moving_melee = 2.5,
			ranged = 1
		},
		move_start_timings = {
			attack_move_01 = 0.12345679012345678
		},
		stagger_type_reduction = {
			ranged = 20,
			melee = 20
		},
		animation_move_speed_configs = {
			attack_move_01 = {
				{
					value = 4,
					distance = 5.47
				},
				{
					value = 3,
					distance = 4.08
				},
				{
					value = 2,
					distance = 3.04
				},
				{
					value = 1,
					distance = 1.86
				},
				{
					value = 0,
					distance = 0.95
				}
			}
		},
		damage_profile = DamageProfileTemplates.renegade_captain_powermaul_melee_cleave,
		damage_type = damage_types.minion_melee_blunt_elite,
		ground_impact_fx_template = GroundImpactFxTemplates.renegade_captain_powermaul_melee_cleave,
		effect_template = EffectTemplates.renegade_captain_powermaul_ground_slam,
		effect_template_start_timings = {
			attack_move_01 = 0
		}
	},
	powermaul_melee_attack = {
		weapon_reach = 3.5,
		ignore_blocked = true,
		utility_weight = 1,
		power_level_type = "melee_two_hand",
		aoe_threat_timing = 0.3,
		considerations = UtilityConsiderations.melee_attack,
		attack_anim_events = {
			"cultist_captain_heavy"
		},
		attack_anim_damage_timings = {
			cultist_captain_heavy = 1.1
		},
		attack_anim_durations = {
			cultist_captain_heavy = 2
		},
		attack_intensities = {
			melee = 2.5,
			running_melee = 2.5,
			moving_melee = 2.5,
			ranged = 1
		},
		damage_profile = DamageProfileTemplates.renegade_captain_melee_default,
		damage_type = damage_types.minion_melee_blunt_elite,
		effect_template = EffectTemplates.renegade_captain_powermaul_ground_slam,
		effect_template_start_timings = {
			cultist_captain_heavy = 0
		}
	},
	powermaul_moving_melee_attack = {
		power_level_type = "melee_two_hand",
		ignore_blocked = true,
		utility_weight = 1,
		move_speed_variable_name = "moving_attack_fwd_speed",
		aoe_threat_timing = 0.3,
		moving_attack = true,
		move_speed_variable_lerp_speed = 4,
		weapon_reach = 3.25,
		move_speed = 4,
		dodge_weapon_reach = 3,
		considerations = UtilityConsiderations.renegade_executor_moving_melee_attack,
		attack_anim_events = {
			"cultist_heavy_moving"
		},
		attack_anim_damage_timings = {
			cultist_heavy_moving = 1.1358024691358024
		},
		attack_anim_durations = {
			cultist_heavy_moving = 2.0246913580246915
		},
		attack_intensities = {
			melee = 2.5,
			running_melee = 2.5,
			moving_melee = 2.5,
			ranged = 1
		},
		move_start_timings = {
			attack_move_02 = 0.12345679012345678
		},
		damage_profile = DamageProfileTemplates.renegade_captain_melee_default,
		damage_type = damage_types.minion_melee_blunt_elite,
		stagger_type_reduction = {
			ranged = 20,
			melee = 20
		},
		animation_move_speed_configs = {
			cultist_heavy_moving = {
				{
					value = 4,
					distance = 7.7
				},
				{
					value = 3,
					distance = 5.18
				},
				{
					value = 2,
					distance = 3.53
				},
				{
					value = 1,
					distance = 1.79
				},
				{
					value = 0,
					distance = 0.84
				}
			}
		},
		effect_template = EffectTemplates.renegade_captain_powermaul_ground_slam,
		effect_template_start_timings = {
			cultist_heavy_moving = 0
		}
	},
	powermaul_ground_slam = {
		height = 3,
		utility_weight = 1,
		vo_event = "taunt_combat",
		attack_type = "oobb",
		stagger_reduction = 40,
		collision_filter = "filter_minion_melee",
		power_level_type = "melee_two_hand",
		ignore_blocked = true,
		assault_vo_interval_t = 1,
		range = 5,
		aoe_threat_timing = 0.3,
		width = 2.5,
		considerations = UtilityConsiderations.renegade_captain_powermaul_ground_slam_attack,
		attack_anim_events = {
			"cultist_heavy_slam"
		},
		attack_anim_damage_timings = {
			cultist_heavy_slam = 1.488888888888889
		},
		attack_anim_durations = {
			cultist_heavy_slam = 3
		},
		attack_intensities = {
			melee = 0.25,
			running_melee = 2,
			moving_melee = 1,
			ranged = 1
		},
		damage_profile = DamageProfileTemplates.renegade_captain_powermaul_ground_slam,
		damage_type = damage_types.minion_powered_blunt,
		effect_template = EffectTemplates.renegade_captain_powermaul_ground_slam,
		effect_template_start_timings = {
			cultist_heavy_slam = 0
		},
		ground_impact_fx_template = GroundImpactFxTemplates.renegade_captain_powermaul_melee_ground_slam
	},
	powermaul_pommel = {
		range = 3,
		ignore_blocked = true,
		aoe_threat_timing = 0.3,
		attack_type = "oobb",
		collision_filter = "filter_minion_melee",
		height = 2.5,
		moving_attack = true,
		width = 2.25,
		utility_weight = 5,
		considerations = UtilityConsiderations.renegade_captain_punch,
		attack_anim_events = {
			"attack_2h_pommel"
		},
		attack_anim_damage_timings = {
			attack_2h_pommel = 0.7333333333333333
		},
		attack_anim_durations = {
			attack_2h_pommel = 1.6
		},
		attack_intensities = {
			ranged = 1,
			running_melee = 2,
			moving_melee = 0.1,
			melee = 0.25
		},
		damage_profile = DamageProfileTemplates.renegade_captain_punch,
		damage_type = damage_types.minion_melee_blunt_elite
	},
	void_shield_explosion = {
		radius = 5,
		utility_weight = 10,
		hit_effect = "content/fx/particles/screenspace/screen_disturbance_scanlines_pulse",
		relation = "enemy",
		hit_zone_name = "center_mass",
		power_level = 100,
		considerations = UtilityConsiderations.renegade_captain_void_shield_explosion,
		attack_anim_events = {
			"force_shield_knockback"
		},
		attack_anim_damage_timings = {
			force_shield_knockback = 0.5523809523809524
		},
		attack_anim_durations = {
			force_shield_knockback = 1.1428571428571428
		},
		damage_profile = DamageProfileTemplates.renegade_captain_void_shield_explosion,
		damage_type = damage_types.minion_powered_sharp,
		effect_template = EffectTemplates.void_shield_explosion
	},
	throw_frag_grenade = {
		utility_weight = 20,
		considerations = UtilityConsiderations.renegade_captain_throw_frag_grenade,
		aim_anim_events = {
			"throw_grenade"
		},
		aim_duration = {
			throw_grenade = 1.2916666666666667
		},
		action_durations = {
			throw_grenade = 2.5
		},
		effect_template = EffectTemplates.renegade_captain_grenade,
		effect_template_timings = {
			throw_grenade = 0.4375
		},
		throw_config = {
			acceptable_accuracy = 1,
			item = "content/items/weapons/minions/ranged/renegade_grenade",
			unit_node = "j_righthand",
			projectile_template = ProjectileTemplates.renegade_captain_frag_grenade
		}
	},
	throw_fire_grenade = {
		utility_weight = 20,
		considerations = UtilityConsiderations.renegade_captain_throw_fire_grenade,
		aim_anim_events = {
			"throw_grenade"
		},
		aim_duration = {
			throw_grenade = 1.2916666666666667
		},
		action_durations = {
			throw_grenade = 2.5
		},
		effect_template = EffectTemplates.renegade_captain_grenade,
		effect_template_timings = {
			throw_grenade = 0.4375
		},
		throw_config = {
			acceptable_accuracy = 1,
			item = "content/items/weapons/minions/ranged/renegade_grenade",
			unit_node = "j_righthand",
			projectile_template = ProjectileTemplates.renegade_captain_fire_grenade
		}
	},
	approach_target = {
		speed = 5.5,
		leave_distance = 10,
		clear_shot_line_of_sight_id = "netgun"
	},
	shoot_net = {
		aim_wwise_event = "wwise/events/minions/play_weapon_netgunner_wind_up",
		fx_source_name = "muzzle",
		drag_wwise_event = "wwise/events/weapon/play_enemy_netgunner_net_pull",
		net_dodge_sweep_radius = 0.25,
		vo_event = "throwing_net",
		drag_anim_exit_delay = 2.3333333333333335,
		shoot_net_cooldown = 0,
		net_sweep_radius = 0.5,
		aim_duration = 0.8333333333333334,
		drag_anim_event = "drag_player",
		aim_anim_event = "aim_loop",
		shoot_anim_event = "shoot_net",
		stagger_immune = true,
		inventory_slot = "slot_netgun",
		net_speed = 20,
		max_net_distance = 14,
		drag_anim_delay = PlayerCharacterConstants.netted_fp_anim_duration,
		shoot_template = BreedShootTemplates.renegade_netgunner_default,
		effect_template = EffectTemplates.renegade_netgunner_net,
		num_shots = shooting_difficulty_settings_netgun.num_shots
	},
	charge = {
		charged_past_dot = 0.1,
		close_rotation_speed = 2,
		close_distance = 8,
		max_dot_lean_value = 0.1,
		lean_variable_name = "lean",
		wall_raycast_distance = 3,
		max_slowdown_percentage = 0.15,
		default_lean_value = 1,
		left_lean_value = 0,
		min_time_navigating = 0.5,
		push_minions_radius = 3,
		trigger_move_to_target = true,
		charge_max_speed_at = 2,
		attack_anim = "cultist_heavy_moving",
		charged_past_duration = 1.25,
		collision_radius = 1.8,
		power_level = 150,
		attack_anim_damage_timing = 1.0222222222222221,
		ignore_dodge = true,
		min_time_spent_charging = 1,
		dodge_rotation_speed = 0.01,
		target_extrapolation_length_scale = 0.5,
		wall_stun_time = 1.5,
		max_slowdown_angle = 40,
		min_slowdown_angle = 20,
		utility_weight = 5,
		wall_raycast_node_name = "j_spine",
		push_minions_side_relation = "allied",
		charge_speed_min = 6,
		push_minions_power_level = 150,
		right_lean_value = 2,
		rotation_speed = 6,
		charge_speed_max = 11,
		considerations = UtilityConsiderations.renegade_captain_charge,
		charge_anim_events = {
			"attack_charge_start_fwd"
		},
		charge_durations = {
			attack_charge_start_fwd = 0.36666666666666664
		},
		push_minions_damage_profile = DamageProfileTemplates.renegade_captain_minion_charge_push,
		push_minions_fx_template = MinionPushFxTemplates.captain_charge_push,
		push_minions_fx_cooldown = {
			0.03,
			0.18
		},
		attack_anim_duration = {
			default = 0.5,
			slot_powermaul = 1.8222222222222222
		},
		collision_angle = math.degrees_to_radians(100),
		damage_profile = DamageProfileTemplates.renegade_captain_charge,
		damage_type = damage_types.minion_charge,
		miss_animations = {
			"attack_charge_miss"
		},
		miss_durations = {
			attack_charge_miss = 1.3333333333333333
		},
		can_hit_wall_durations = {
			attack_charge_miss = 1.1333333333333333
		}
	},
	shotgun_shoot = {
		attack_intensity_type = "elite_ranged",
		ignore_backstab_sfx = true,
		can_strafe_shoot = true,
		first_shoot_timing = 1.2,
		degree_per_direction = 10,
		strafe_end_anim_event = "hip_fire",
		move_to_fail_cooldown = 1,
		randomized_direction_degree_range = 180,
		dodge_tell_sfx_delay = 0.13333333333333333,
		dodge_tell_sfx = "wwise/events/weapon/play_minion_captain_shotgun_mech",
		inventory_slot = "slot_shotgun",
		max_distance_to_target = 12,
		strafe_speed = 2.3,
		utility_weight = 10,
		dodge_tell_animation = "offset_shotgun_standing_shoot_pump",
		strafe_shoot_distance = 3,
		exit_after_cooldown = true,
		trigger_shoot_sound_event_once = true,
		strafe_shoot_ranged_position_fallback = true,
		suppressive_fire = true,
		move_to_cooldown = 0.25,
		min_distance_to_target = 7,
		fx_source_name = "muzzle",
		considerations = UtilityConsiderations.renegade_captain_shotgun_shoot,
		aim_anim_events = {
			"hip_fire"
		},
		aim_duration = {
			hip_fire = shooting_difficulty_settings_shotgun.aim_durations
		},
		aim_stances = {
			hip_fire = "standing"
		},
		attack_intensities = {
			ranged = 2,
			elite_ranged = 2
		},
		shoot_cooldown = shooting_difficulty_settings_shotgun.shoot_cooldown,
		num_shots = shooting_difficulty_settings_shotgun.num_shots,
		time_per_shot = shooting_difficulty_settings_shotgun.time_per_shot,
		dodge_window = shooting_difficulty_settings_shotgun.shoot_dodge_window,
		shoot_template = BreedShootTemplates.renegade_captain_shotgun,
		strafe_anim_events = {
			bwd = "move_bwd_walk_aim",
			fwd = "move_fwd_walk_aim",
			left = "move_left_walk_aim",
			right = "move_right_walk_aim"
		}
	},
	exit_anim_states = {
		slot_powermaul = "to_2h_melee",
		slot_hellgun = "to_riflemen",
		slot_plasma_pistol = "to_pistol",
		slot_bolt_pistol = "to_pistol",
		slot_shotgun = "to_assaulter",
		slot_power_sword = "to_melee",
		slot_netgun = "to_netgun"
	},
	switch_weapon = {
		slot_powermaul = {
			anim_state = "to_2h_melee",
			switch_anim_events = {
				"equip_2h_weapon"
			},
			switch_anim_equip_timings = {
				equip_2h_weapon = 0.26666666666666666
			},
			switch_anim_durations = {
				equip_2h_weapon = 1
			}
		},
		slot_power_sword = {
			switch_anim_events = {
				"equip_sword"
			},
			switch_anim_equip_timings = {
				equip_sword = 0.3111111111111111
			},
			switch_anim_durations = {
				equip_sword = 0.5555555555555556
			}
		},
		slot_hellgun = {
			switch_anim_events = {
				"equip_rifle"
			},
			switch_anim_equip_timings = {
				equip_rifle = 0.2222222222222222
			},
			switch_anim_durations = {
				equip_rifle = 0.6666666666666666
			}
		},
		slot_bolt_pistol = {
			switch_anim_events = {
				"equip_pistol"
			},
			switch_anim_equip_timings = {
				equip_pistol = 0.06666666666666667
			},
			switch_anim_durations = {
				equip_pistol = 0.5
			}
		},
		slot_plasma_pistol = {
			switch_anim_events = {
				"equip_pistol"
			},
			switch_anim_equip_timings = {
				equip_pistol = 0.06666666666666667
			},
			switch_anim_durations = {
				equip_pistol = 0.5
			}
		},
		slot_netgun = {
			switch_anim_events = {
				"equip_netgun"
			},
			switch_anim_equip_timings = {
				equip_netgun = 0.2222222222222222
			},
			switch_anim_durations = {
				equip_netgun = 0.6666666666666666
			}
		},
		slot_shotgun = {
			switch_anim_events = {
				"equip_rifle"
			},
			switch_anim_equip_timings = {
				equip_rifle = 0.06666666666666667
			},
			switch_anim_durations = {
				equip_rifle = 0.5
			}
		}
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
					"stagger_fwd_heavy",
					"stagger_fwd_heavy_2",
					"stagger_fwd_heavy_3",
					"stagger_fwd_heavy_4"
				},
				bwd = {
					"stagger_bwd_heavy",
					"stagger_bwd_heavy_2",
					"stagger_bwd_heavy_3",
					"stagger_bwd_heavy_4"
				},
				left = {
					"stagger_left_heavy",
					"stagger_left_heavy_2",
					"stagger_left_heavy_3",
					"stagger_left_heavy_4"
				},
				right = {
					"stagger_right_heavy",
					"stagger_right_heavy_2",
					"stagger_right_heavy_3",
					"stagger_right_heavy_4"
				},
				dwn = {
					"stagger_dwn_heavy",
					"stagger_dwn_heavy_2",
					"stagger_dwn_heavy_3"
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
					"stagger_explosion_back"
				},
				bwd = {
					"stagger_explosion_back"
				},
				left = {
					"stagger_explosion_back"
				},
				right = {
					"stagger_explosion_back"
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
	open_door = {
		rotation_duration = 0.1,
		stagger_immune = true
	},
	smash_obstacle = {
		rotation_duration = 0.1,
		attack_anim_events = {
			"attack_kick_01"
		},
		attack_anim_damage_timings = {
			attack_kick_01 = 0.6666666666666666
		},
		attack_anim_durations = {
			attack_kick_01 = 1.7333333333333334
		},
		damage_profile = DamageProfileTemplates.default
	},
	exit_spawner = {
		run_anim_event = "move_fwd"
	},
	blocked = {
		blocked_duration = 0.6666666666666666,
		blocked_anims = {
			"blocked"
		}
	}
}

return action_data
