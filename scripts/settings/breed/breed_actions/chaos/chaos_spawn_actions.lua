-- chunkname: @scripts/settings/breed/breed_actions/chaos/chaos_spawn_actions.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GroundImpactFxTemplates = require("scripts/settings/fx/ground_impact_fx_templates")
local PushSettings = require("scripts/settings/damage/push_settings")
local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local damage_types = DamageSettings.damage_types
local action_data = {
	name = "chaos_spawn",
	idle = {
		anim_events = "idle",
	},
	death = {
		instant_ragdoll_chance = 1,
	},
	change_target = {
		rotate_towards_target_on_fwd = true,
		rotation_speed = 6,
		change_target_anim_events = {
			bwd = "move_start_bwd",
			fwd = "move_start_fwd",
			left = "move_start_left",
			right = "move_start_right",
		},
		change_target_anim_data = {
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
		change_target_rotation_timings = {
			move_start_bwd = 0,
			move_start_fwd = 0,
			move_start_left = 0,
			move_start_right = 0,
		},
		change_target_rotation_durations = {
			move_start_bwd = 0.5,
			move_start_fwd = 0.3333333333333333,
			move_start_left = 0.3333333333333333,
			move_start_right = 0.3333333333333333,
		},
		change_target_event_anim_speed_durations = {
			move_start_fwd = 0.7692307692307693,
		},
	},
	leap = {
		aoe_bot_threat_duration = 1,
		land_anim_event = "attack_leap_land",
		land_impact_timing = 0.16666666666666666,
		landing_duration = 0.6944444444444444,
		push_enemies_power_level = 2000,
		push_enemies_radius = 2,
		push_minions_damage_type = nil,
		push_minions_power_level = 2000,
		push_minions_radius = 2,
		push_minions_side_relation = "allied",
		short_start_leap_anim_event = "attack_leap_short_start",
		shortest_start_leap_anim_event = "attack_leap_shortest_start",
		start_leap_anim_event = "attack_leap_start",
		start_offset_distance = 2,
		start_movement_duration = {
			attack_leap_short_start = 0,
			attack_leap_shortest_start = 0,
			attack_leap_start = 0.5555555555555556,
		},
		start_leap_timing = {
			attack_leap_short_start = 0.43333333333333335,
			attack_leap_shortest_start = 0.3333333333333333,
			attack_leap_start = 0.7777777777777778,
		},
		stagger_type_reduction = {
			melee = -20,
			ranged = 20,
		},
		push_minions_damage_profile = DamageProfileTemplates.chaos_hound_push,
		push_enemies_damage_profile = DamageProfileTemplates.chaos_hound_push,
		aoe_bot_threat_size = Vector3Box(1.5, 2, 2),
		land_ground_impact_fx_template = GroundImpactFxTemplates.chaos_spawn_leap,
		catapult_or_push_players = {
			radius = 4,
			speed = 6,
			angle = math.pi / 6,
			catapult_breed_names = {
				human = true,
			},
			push_template = PushSettings.push_templates.chaos_spawn_leap,
		},
	},
	erratic_follow = {
		enter_walk_distance = 0,
		idle_anim_events = "idle",
		leave_walk_distance = 4,
		rotation_speed = 6,
		run_anim_event = "move_fwd",
		uses_high_jumps = true,
		utility_weight = 1,
		walk_anim_event = "move_fwd",
		considerations = UtilityConsiderations.melee_follow,
		start_move_anim_events = {
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
			walk_start_fwd = {
				rad = nil,
				sign = nil,
			},
			walk_start_bwd = {
				sign = -1,
				rad = math.pi,
			},
			walk_start_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			walk_start_right = {
				sign = -1,
				rad = math.pi / 2,
			},
		},
		start_move_rotation_timings = {
			move_start_bwd = 0,
			move_start_fwd = 0,
			move_start_left = 0,
			move_start_right = 0,
			walk_start_bwd = 0,
			walk_start_fwd = 0,
			walk_start_left = 0,
			walk_start_right = 0,
		},
		start_rotation_durations = {
			move_start_bwd = 0.6666666666666666,
			move_start_fwd = 0,
			move_start_left = 0.3333333333333333,
			move_start_right = 0.3333333333333333,
			walk_start_bwd = 0.7666666666666667,
			walk_start_fwd = 0,
			walk_start_left = 0.7,
			walk_start_right = 0.7666666666666667,
		},
		start_move_event_anim_speed_durations = {
			move_start_fwd = 0.9333333333333333,
			walk_start_bwd = 0.7666666666666667,
			walk_start_fwd = 0.9333333333333333,
			walk_start_left = 0.7,
			walk_start_right = 0.7666666666666667,
		},
		move_jump_left_anims = {
			ray_angle = math.pi * 0.25,
			{
				"move_jump_left_45",
				ray_angle = 0,
				ray_dist = 5,
			},
			{
				"move_jump_left_45_turn_right_45",
				ray_dist = 5,
				ray_angle = -math.pi * 0.25,
			},
			{
				"move_jump_left_45_turn_right_90",
				ray_dist = 5,
				ray_angle = -math.pi * 0.5,
			},
			name = "move_jump_left_anims",
			ray_dist = 8,
		},
		move_jump_right_anims = {
			ray_angle = -math.pi * 0.25,
			{
				"move_jump_right_45",
				ray_angle = 0,
				ray_dist = 5,
			},
			{
				"move_jump_right_45_turn_left_45",
				ray_dist = 5,
				ray_angle = math.pi * 0.25,
			},
			{
				"move_jump_right_45_turn_left_90",
				ray_dist = 5,
				ray_angle = math.pi * 0.5,
			},
			name = "move_jump_right_anims",
			ray_dist = 8,
		},
		move_jump_fwd_anims = {
			{
				"move_jump_fwd",
				ray_angle = 0,
				ray_dist = 5,
			},
			{
				"move_jump_fwd_turn_left_45",
				ray_dist = 5,
				ray_angle = math.pi * 0.25,
			},
			{
				"move_jump_fwd_turn_left_90",
				ray_dist = 5,
				ray_angle = math.pi * 0.5,
			},
			{
				"move_jump_fwd_turn_right_45",
				ray_dist = 5,
				ray_angle = -math.pi * 0.25,
			},
			{
				"move_jump_fwd_turn_right_90",
				ray_dist = 5,
				ray_angle = -math.pi * 0.5,
			},
			name = "move_jump_fwd_anims",
			ray_angle = 0,
			ray_dist = 8,
		},
		move_jump_only_left_anims = {
			ray_angle = math.pi * 0.25,
			{
				"move_jump_left_45",
				ray_angle = 0,
				ray_dist = 5,
			},
			{
				"move_jump_left_90",
				ray_angle = 0,
				ray_dist = 5,
			},
			ray_dist = 8,
		},
		move_jump_only_fwd_left_anims = {
			{
				"move_jump_fwd_turn_left_45",
				ray_dist = 5,
				ray_angle = math.pi * 0.25,
			},
			{
				"move_jump_fwd_turn_left_90",
				ray_dist = 5,
				ray_angle = math.pi * 0.5,
			},
			ray_angle = 0,
			ray_dist = 8,
		},
		move_jump_only_right_anims = {
			ray_angle = -math.pi * 0.25,
			{
				"move_jump_right_45",
				ray_angle = 0,
				ray_dist = 5,
			},
			{
				"move_jump_right_90",
				ray_angle = 0,
				ray_dist = 5,
			},
			ray_dist = 8,
		},
		move_jump_only_fwd_right_anims = {
			{
				"move_jump_fwd_turn_right_45",
				ray_dist = 5,
				ray_angle = -math.pi * 0.25,
			},
			{
				"move_jump_fwd_turn_right_90",
				ray_dist = 5,
				ray_angle = -math.pi * 0.5,
			},
			ray_angle = 0,
			ray_dist = 8,
		},
		jump_durations = {
			move_jump_fwd = 1.1333333333333333,
			move_jump_fwd_turn_left_45 = 1.1333333333333333,
			move_jump_fwd_turn_left_90 = 1.1333333333333333,
			move_jump_fwd_turn_right_45 = 1.1333333333333333,
			move_jump_fwd_turn_right_90 = 1.1333333333333333,
			move_jump_left_45 = 1.1333333333333333,
			move_jump_left_45_turn_right_45 = 1.1333333333333333,
			move_jump_left_45_turn_right_90 = 1.1333333333333333,
			move_jump_left_90 = 1.1333333333333333,
			move_jump_right_45 = 1.1333333333333333,
			move_jump_right_45_turn_left_45 = 1.1333333333333333,
			move_jump_right_45_turn_left_90 = 1.1333333333333333,
			move_jump_right_90 = 1.1333333333333333,
		},
	},
	climb = {
		rotation_duration = 0.1,
		stagger_immune = true,
		anim_timings = {
			jump_down_land = 0.26666666666666666,
			jump_down_land_3m = 0.9333333333333333,
			jump_up_1m = 0.5333333333333333,
			jump_up_2m = 0.5666666666666667,
			jump_up_3m = 0.9333333333333333,
			jump_up_5m = 0.9333333333333333,
			jump_up_fence_1m = 0.43333333333333335,
			jump_up_fence_2m = 0.6333333333333333,
			jump_up_fence_3m = 0.9666666666666667,
			jump_up_fence_5m = 1.3666666666666667,
		},
		ending_move_states = {
			jump_down_fence_land_1m = "jumping",
			jump_down_land = "jumping",
			jump_down_land_3m = "jumping",
			jump_up_1m = "jumping",
			jump_up_2m = "jumping",
			jump_up_3m = "jumping",
			jump_up_5m = "jumping",
		},
		blend_timings = {
			jump_down = 0.1,
			jump_down_1m = 0.1,
			jump_down_fence_land_1m = 0,
			jump_down_land = 0,
			jump_down_land_1m = 0,
			jump_down_land_3m = 0,
			jump_up_1m = 0.1,
			jump_up_2m = 0.1,
			jump_up_3m = 0.1,
			jump_up_5m = 0.1,
			jump_up_fence_1m = 0.1,
			jump_up_fence_2m = 0.1,
			jump_up_fence_3m = 0.1,
			jump_up_fence_5m = 0.1,
		},
		catapult_units = {
			radius = 2,
			speed = 7,
			angle = math.pi / 6,
		},
	},
	jump_across = {
		rotation_duration = 0.1,
		stagger_immune = true,
		anim_timings = {
			jump_over_gap_4m = 0.9666666666666667,
		},
		ending_move_states = {
			jump_over_gap_4m = "jumping",
		},
		blend_timings = {
			jump_over_gap_4m = 0.1,
		},
	},
	claw_attack = {
		aoe_threat_duration = 0.75,
		aoe_threat_timing = 0.4,
		attack_type = "oobb",
		bot_power_level_modifier = 0.4,
		collision_filter = "filter_minion_melee_friendly_fire",
		height = 5,
		ignore_blocked = true,
		range = 3.5,
		utility_weight = 1,
		width = 1.25,
		considerations = UtilityConsiderations.chaos_spawn_claw_attack,
		attack_anim_events = {
			normal = {
				"attack_melee_claw",
				"attack_melee_claw_02",
			},
		},
		attack_anim_damage_timings = {
			attack_melee_claw = 0.6666666666666666,
			attack_melee_claw_02 = 0.6666666666666666,
		},
		attack_anim_durations = {
			attack_melee_claw = 1.1666666666666667,
			attack_melee_claw_02 = 1.1666666666666667,
		},
		attack_intensities = {
			elite_ranged = 4,
			melee = 0.25,
			moving_melee = 0.1,
			ranged = 5,
			running_melee = 2,
		},
		damage_profile = DamageProfileTemplates.chaos_spawn_claw,
		damage_type = damage_types.minion_monster_sharp,
		aoe_bot_threat_oobb_size = Vector3Box(1.5, 2.25, 2.5),
		ground_impact_fx_template = GroundImpactFxTemplates.chaos_spawn_claw,
	},
	grab = {
		after_throw_taunt_anim = "change_target_fwd",
		after_throw_taunt_duration = 0,
		aoe_threat_duration = 0.75,
		aoe_threat_timing = 0.4,
		attack_type = "oobb",
		bot_power_level_modifier = 0.4,
		check_for_smash_radius = 3,
		collision_filter = "filter_minion_melee_friendly_fire",
		cooldown = 10,
		degree_per_throw_direction = 20,
		dodge_grab_check_radius = 0.75,
		dodge_weapon_reach = 1.25,
		grab_check_radius = 1.75,
		grab_node = "j_leftfinger4_jnt",
		grab_target_node = "j_hips",
		height = 2,
		ignore_blocked = true,
		oobb_node = "j_leftfinger4_jnt",
		oobb_use_unit_rotation = true,
		range = 2,
		rotation_speed = 6,
		start_eat_anim = "attack_grabbed_eat_start",
		sweep_node = "j_leftfinger3_jnt",
		throw_test_distance = 15,
		utility_weight = 200,
		vo_event = "chaos_spawn_chew",
		vo_event_release = "monster_release",
		weapon_reach = 2.25,
		width = 2,
		considerations = UtilityConsiderations.chaos_spawn_grab_attack,
		grab_anims = {
			human = "attack_grab",
			ogryn = "attack_grab",
		},
		drag_in_anims = {
			human = "attack_grab_player",
			ogryn = "attack_grab_player_ogryn",
		},
		grab_timings = {
			human = {
				0.7666666666666667,
				0.9333333333333333,
			},
			ogryn = {
				0.7666666666666667,
				0.9333333333333333,
			},
		},
		total_grab_durations = {
			human = 10.333333333333334,
			ogryn = 10.566666666666666,
		},
		grab_durations = {
			human = 1.3333333333333333,
			ogryn = 1.9666666666666666,
		},
		grab_durations_missed = {
			human = 1.9,
			ogryn = 1.9,
		},
		rotation_durations = {
			attack_grab = 0.3333333333333333,
		},
		smash_anims = {
			human = "attack_grabbed_smash",
			ogryn = "attack_grabbed_smash",
		},
		smash_durations = {
			human = 3.2,
			ogryn = 3.6666666666666665,
		},
		smash_timings = {
			human = {
				0.5,
				1,
				1.4333333333333333,
			},
			ogryn = {
				1.0333333333333334,
				1.8333333333333333,
				2.566666666666667,
			},
		},
		smash_sweep_start_timings = {
			ogryn = {
				{
					0.7,
					0.9666666666666667,
					"j_leftfinger3_jnt",
				},
				{
					1.7666666666666666,
					1.9666666666666666,
					"j_leftfinger3_jnt",
				},
				{
					2.466666666666667,
					2.9,
					"j_leftfinger3_jnt",
				},
			},
			human = {
				{
					0.6333333333333333,
					0.8,
					"j_leftfinger3_jnt",
				},
				{
					1.4333333333333333,
					1.5666666666666667,
					"j_leftfinger3_jnt",
				},
				{
					2.466666666666667,
					2.533333333333333,
					"j_leftfinger3_jnt",
				},
			},
		},
		damage_profile = DamageProfileTemplates.chaos_spawn_grab_smash,
		smash_damage_profile = {
			human = DamageProfileTemplates.chaos_spawn_grab_smash,
			ogryn = DamageProfileTemplates.chaos_spawn_grab_smash,
		},
		damage_type = damage_types.minion_monster_blunt,
		aoe_bot_threat_oobb_size = Vector3Box(1.5, 2.25, 2.5),
		ground_impact_fx_template = GroundImpactFxTemplates.chaos_spawn_tentacle,
		sweep_ground_impact_fx_timing = {
			ogryn = {
				0.9666666666666667,
			},
		},
		start_eat_timings = {
			human = 1.2,
			ogryn = 1.5666666666666667,
		},
		damage_timings = {
			human = {
				5.533333333333333,
				8.033333333333333,
				10.533333333333333,
			},
			ogryn = {
				5.533333333333333,
				8.033333333333333,
				10.533333333333333,
			},
		},
		anim_data = {
			attack_grabbed_throw = {
				rad = nil,
				sign = nil,
			},
			attack_grabbed_throw_bwd = {
				sign = 1,
				rad = math.pi,
			},
			attack_grabbed_throw_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			attack_grabbed_throw_right = {
				sign = -1,
				rad = math.pi / 2,
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
		start_rotation_timings = {
			attack_grabbed_throw = 0,
			move_start_bwd = 1.6666666666666667,
			move_start_left = 1,
			move_start_right = 1.2666666666666666,
		},
		throw_anims = {
			human = {
				bwd = "attack_grabbed_throw",
				fwd = "attack_grabbed_throw",
				left = "attack_grabbed_throw",
				right = "attack_grabbed_throw",
			},
			ogryn = {
				bwd = "attack_grabbed_throw_bwd",
				fwd = "attack_grabbed_throw",
				left = "attack_grabbed_throw_left",
				right = "attack_grabbed_throw_right",
			},
		},
		throw_timing = {
			human = 0.7,
			ogryn = {
				from_eating = 0.9333333333333333,
				from_smashing = 0.6333333333333333,
			},
		},
		throw_duration = {
			ogryn = 1.6666666666666667,
			human = {
				from_eating = 1.6666666666666667,
				from_smashing = 1.6666666666666667,
			},
		},
		catapult_force = {
			human = 14,
			ogryn = 12,
		},
		catapult_z_force = {
			human = 3,
			ogryn = 4,
		},
		power_level = {
			120,
			200,
			250,
			350,
			450,
		},
		heal_amount = {
			200,
			400,
			600,
			800,
			1000,
		},
		eat_damage_profile = DamageProfileTemplates.beast_of_nurgle_hit_by_vomit,
		eat_damage_type = {
			human = damage_types.minion_monster_eat,
			ogryn = damage_types.minion_monster_eat,
		},
		attack_intensities = {
			elite_ranged = 20,
			melee = 20,
			moving_melee = 20,
			ranged = 20,
			running_melee = 20,
		},
	},
	combo_attack = {
		aoe_bot_threat_sweep_reach = 5,
		aoe_threat_duration = 2.074074074074074,
		aoe_threat_timing = 0,
		attack_type = "sweep",
		bot_power_level_modifier = 0.5,
		collision_filter = "filter_minion_melee_friendly_fire",
		dodge_weapon_reach = 1.25,
		ignore_blocked = true,
		move_speed = 4,
		moving_attack = true,
		push_enemies_frequency = 0.5,
		push_enemies_include_target_unit = true,
		push_enemies_power_level = 2000,
		push_enemies_radius = 2.25,
		push_minions_damage_type = nil,
		push_minions_power_level = 2000,
		push_minions_radius = 2,
		push_minions_side_relation = "allied",
		rotation_speed = 5,
		sweep_node = "j_righthandmiddle1",
		utility_weight = 8,
		weapon_reach = 2,
		considerations = UtilityConsiderations.chaos_spawn_combo_attack,
		attack_anim_events = {
			directional = {
				bwd = "attack_turn_bwd",
				left = "attack_turn_left",
				right = "attack_turn_right",
				fwd = {
					"attack_melee_combo",
					"attack_melee_combo_2",
					"attack_melee_combo_3",
					"attack_melee_combo_4",
				},
			},
		},
		melee_attack_rotation_durations = {
			attack_melee_combo = 0.6666666666666666,
			attack_turn_bwd = 0.5666666666666667,
			attack_turn_left = 0.4666666666666667,
			attack_turn_right = 0.4,
		},
		melee_rotation_anim_data = {
			attack_melee_combo = {
				rad = nil,
				sign = nil,
			},
			attack_turn_bwd = {
				sign = 1,
				rad = math.pi,
			},
			attack_turn_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			attack_turn_right = {
				sign = -1,
				rad = math.pi / 2,
			},
		},
		attack_anim_durations = {
			attack_melee_combo = 2.1666666666666665,
			attack_melee_combo_2 = 2,
			attack_melee_combo_3 = 2.4,
			attack_melee_combo_4 = 2.5,
			attack_turn_bwd = 2.3333333333333335,
			attack_turn_left = 2.3333333333333335,
			attack_turn_right = 2,
		},
		attack_sweep_damage_timings = {
			attack_melee_combo = {
				{
					0.43333333333333335,
					0.5333333333333333,
				},
				{
					0.8666666666666667,
					1,
					"j_leftfinger3_jnt",
				},
				{
					1.3,
					1.4333333333333333,
				},
				{
					1.7,
					1.8333333333333333,
					"j_leftfinger3_jnt",
				},
			},
			attack_melee_combo_2 = {
				{
					0.4444444444444444,
					0.5555555555555556,
				},
				{
					1.0555555555555556,
					1.1666666666666667,
					"j_leftfinger3_jnt",
				},
				{
					1.6111111111111112,
					1.7222222222222223,
				},
			},
			attack_melee_combo_3 = {
				{
					0.6,
					0.6666666666666666,
				},
				{
					1.0666666666666667,
					1.1666666666666667,
					"j_leftfinger3_jnt",
				},
				{
					1.8,
					1.8333333333333333,
				},
			},
			attack_melee_combo_4 = {
				{
					1,
					1.2,
				},
				{
					2,
					2.2,
					"j_leftfinger3_jnt",
				},
			},
			attack_turn_left = {
				{
					0.5666666666666667,
					0.6666666666666666,
				},
				{
					0.9666666666666667,
					1.1,
					"j_leftfinger3_jnt",
				},
				{
					1.6666666666666667,
					1.7666666666666666,
				},
			},
			attack_turn_right = {
				{
					0.5666666666666667,
					0.6333333333333333,
					"j_leftfinger3_jnt",
				},
				{
					0.9333333333333333,
					1.1333333333333333,
				},
			},
			attack_turn_bwd = {
				{
					0.6666666666666666,
					0.7666666666666667,
				},
				{
					1.8,
					1.9,
					"j_leftfinger3_jnt",
				},
			},
		},
		attack_intensities = {
			melee = 0.25,
			moving_melee = 1,
			ranged = 1,
			running_melee = 2,
		},
		move_start_timings = {
			attack_melee_combo = 0.36666666666666664,
			attack_melee_combo_2 = 0.3055555555555556,
			attack_melee_combo_3 = 0.4,
			attack_melee_combo_4 = 0.36666666666666664,
		},
		damage_profile = DamageProfileTemplates.chaos_spawn_combo,
		damage_type = damage_types.minion_monster_sharp,
		attack_override_damage_data = {
			attack_melee_combo = {
				[2] = {
					override_damage_profile = nil,
					override_damage_type = damage_types.minion_monster_blunt,
				},
				[4] = {
					override_damage_profile = nil,
					override_damage_type = damage_types.minion_monster_blunt,
				},
			},
			attack_melee_combo_2 = {
				[2] = {
					override_damage_profile = nil,
					override_damage_type = damage_types.minion_monster_blunt,
				},
			},
			attack_melee_combo_3 = {
				[2] = {
					override_damage_profile = nil,
					override_damage_type = damage_types.minion_monster_blunt,
				},
			},
			attack_melee_combo_4 = {
				{
					override_damage_profile = DamageProfileTemplates.chaos_spawn_combo_heavy,
					override_damage_type = damage_types.minion_monster_blunt,
				},
				{
					override_damage_profile = DamageProfileTemplates.chaos_spawn_combo_heavy,
					override_damage_type = damage_types.minion_monster_blunt,
				},
			},
			attack_turn_left = {
				[2] = {
					override_damage_profile = nil,
					override_damage_type = damage_types.minion_monster_blunt,
				},
			},
			attack_turn_right = {
				{
					override_damage_profile = nil,
					override_damage_type = damage_types.minion_monster_blunt,
				},
			},
			attack_turn_bwd = {
				{
					override_damage_profile = DamageProfileTemplates.chaos_spawn_combo_heavy,
					override_damage_type = damage_types.minion_monster_blunt,
				},
				{
					override_damage_profile = DamageProfileTemplates.chaos_spawn_combo_heavy,
					override_damage_type = damage_types.minion_monster_blunt,
				},
			},
		},
		stagger_type_reduction = {
			explosion = 100,
			ranged = 100,
		},
		sweep_ground_impact_fx_timing = {
			attack_melee_combo = {
				0.43333333333333335,
				0.8666666666666667,
				1.3,
				1.7,
			},
			attack_melee_combo_2 = {
				1.0833333333333333,
				1.6111111111111112,
			},
			attack_melee_combo_3 = {
				0.6333333333333333,
				1.1333333333333333,
				1.8,
			},
			attack_melee_combo_4 = {
				1,
				2,
				2.033333333333333,
			},
			attack_turn_left = {
				0.5666666666666667,
				1.1,
				1.7333333333333334,
			},
			attack_turn_right = {
				0.6333333333333333,
			},
			attack_turn_bwd = {
				1,
				2,
				2.033333333333333,
			},
		},
		sweep_ground_impact_fx_templates = {
			attack_melee_combo = {
				GroundImpactFxTemplates.chaos_spawn_claw,
				GroundImpactFxTemplates.chaos_spawn_tentacle,
				GroundImpactFxTemplates.chaos_spawn_claw,
				GroundImpactFxTemplates.chaos_spawn_tentacle,
			},
			attack_melee_combo_2 = {
				GroundImpactFxTemplates.chaos_spawn_tentacle,
				GroundImpactFxTemplates.chaos_spawn_claw,
			},
			attack_melee_combo_3 = {
				GroundImpactFxTemplates.chaos_spawn_claw,
				GroundImpactFxTemplates.chaos_spawn_tentacle,
				GroundImpactFxTemplates.chaos_spawn_claw,
			},
			attack_melee_combo_4 = {
				GroundImpactFxTemplates.chaos_spawn_claw,
				GroundImpactFxTemplates.chaos_spawn_claw,
				GroundImpactFxTemplates.chaos_spawn_tentacle,
			},
			attack_turn_left = {
				GroundImpactFxTemplates.chaos_spawn_claw,
				GroundImpactFxTemplates.chaos_spawn_tentacle,
				GroundImpactFxTemplates.chaos_spawn_claw,
			},
			attack_turn_right = {
				GroundImpactFxTemplates.chaos_spawn_tentacle,
			},
			attack_turn_bwd = {
				GroundImpactFxTemplates.chaos_spawn_claw,
				GroundImpactFxTemplates.chaos_spawn_claw,
				GroundImpactFxTemplates.chaos_spawn_tentacle,
			},
		},
		push_enemies_push_template = PushSettings.push_templates.chaos_spawn_combo,
		push_minions_damage_profile = DamageProfileTemplates.chaos_spawn_push_minions,
	},
	change_target_combo = {
		aoe_bot_threat_sweep_reach = 5,
		aoe_threat_duration = 2.074074074074074,
		aoe_threat_timing = 0,
		attack_type = "sweep",
		bot_power_level_modifier = 0.5,
		collision_filter = "filter_minion_melee_friendly_fire",
		dodge_weapon_reach = 1.25,
		ignore_blocked = true,
		move_speed = 4,
		moving_attack = true,
		push_enemies_frequency = 0.5,
		push_enemies_include_target_unit = true,
		push_enemies_power_level = 2000,
		push_enemies_radius = 2.25,
		push_minions_damage_type = nil,
		push_minions_power_level = 2000,
		push_minions_radius = 2,
		push_minions_side_relation = "allied",
		rotation_speed = 5,
		sweep_node = "j_righthandmiddle1",
		utility_weight = 8,
		weapon_reach = 2,
		considerations = UtilityConsiderations.chaos_spawn_combo_attack,
		attack_anim_events = {
			directional = {
				bwd = "attack_turn_bwd",
				left = "attack_turn_left",
				right = "attack_turn_right",
				fwd = {
					"attack_melee_combo",
					"attack_melee_combo_2",
					"attack_melee_combo_3",
					"attack_melee_combo_4",
				},
			},
		},
		melee_attack_rotation_durations = {
			attack_melee_combo = 0.6666666666666666,
			attack_turn_bwd = 0.5666666666666667,
			attack_turn_left = 0.4666666666666667,
			attack_turn_right = 0.4,
		},
		melee_rotation_anim_data = {
			attack_melee_combo = {
				rad = nil,
				sign = nil,
			},
			attack_turn_bwd = {
				sign = 1,
				rad = math.pi,
			},
			attack_turn_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			attack_turn_right = {
				sign = -1,
				rad = math.pi / 2,
			},
		},
		attack_anim_durations = {
			attack_melee_combo = 2.1666666666666665,
			attack_melee_combo_2 = 2,
			attack_melee_combo_3 = 2.4,
			attack_melee_combo_4 = 2.5,
			attack_turn_bwd = 2.3333333333333335,
			attack_turn_left = 2.3333333333333335,
			attack_turn_right = 2,
		},
		attack_sweep_damage_timings = {
			attack_melee_combo = {
				{
					0.43333333333333335,
					0.5333333333333333,
				},
				{
					0.8666666666666667,
					1,
					"j_leftfinger3_jnt",
				},
				{
					1.3,
					1.4333333333333333,
				},
				{
					1.7,
					1.8333333333333333,
					"j_leftfinger3_jnt",
				},
			},
			attack_melee_combo_2 = {
				{
					0.4444444444444444,
					0.5555555555555556,
				},
				{
					1.0555555555555556,
					1.1666666666666667,
					"j_leftfinger3_jnt",
				},
				{
					1.6111111111111112,
					1.7222222222222223,
				},
			},
			attack_melee_combo_3 = {
				{
					0.6,
					0.6666666666666666,
				},
				{
					1.0666666666666667,
					1.1666666666666667,
					"j_leftfinger3_jnt",
				},
				{
					1.8,
					1.8333333333333333,
				},
			},
			attack_melee_combo_4 = {
				{
					1,
					1.2,
				},
				{
					2,
					2.2,
					"j_leftfinger3_jnt",
				},
			},
			attack_turn_left = {
				{
					0.5666666666666667,
					0.6666666666666666,
				},
				{
					0.9666666666666667,
					1.1,
					"j_leftfinger3_jnt",
				},
				{
					1.6666666666666667,
					1.7666666666666666,
				},
			},
			attack_turn_right = {
				{
					0.5666666666666667,
					0.6333333333333333,
					"j_leftfinger3_jnt",
				},
				{
					0.9333333333333333,
					1.1333333333333333,
				},
			},
			attack_turn_bwd = {
				{
					0.6666666666666666,
					0.7666666666666667,
				},
				{
					1.8,
					1.9,
					"j_leftfinger3_jnt",
				},
			},
		},
		attack_intensities = {
			melee = 0.25,
			moving_melee = 1,
			ranged = 1,
			running_melee = 2,
		},
		move_start_timings = {
			attack_melee_combo = 0.36666666666666664,
			attack_melee_combo_2 = 0.3055555555555556,
			attack_melee_combo_3 = 0.4,
			attack_melee_combo_4 = 0.36666666666666664,
		},
		damage_profile = DamageProfileTemplates.chaos_spawn_combo,
		damage_type = damage_types.minion_monster_sharp,
		attack_override_damage_data = {
			attack_melee_combo = {
				[2] = {
					override_damage_profile = nil,
					override_damage_type = damage_types.minion_monster_blunt,
				},
				[4] = {
					override_damage_profile = nil,
					override_damage_type = damage_types.minion_monster_blunt,
				},
			},
			attack_melee_combo_2 = {
				[2] = {
					override_damage_profile = nil,
					override_damage_type = damage_types.minion_monster_blunt,
				},
			},
			attack_melee_combo_3 = {
				[2] = {
					override_damage_profile = nil,
					override_damage_type = damage_types.minion_monster_blunt,
				},
			},
			attack_melee_combo_4 = {
				{
					override_damage_profile = DamageProfileTemplates.chaos_spawn_combo_heavy,
					override_damage_type = damage_types.minion_monster_blunt,
				},
				{
					override_damage_profile = DamageProfileTemplates.chaos_spawn_combo_heavy,
					override_damage_type = damage_types.minion_monster_blunt,
				},
			},
			attack_turn_left = {
				[2] = {
					override_damage_profile = nil,
					override_damage_type = damage_types.minion_monster_blunt,
				},
			},
			attack_turn_right = {
				{
					override_damage_profile = nil,
					override_damage_type = damage_types.minion_monster_blunt,
				},
			},
			attack_turn_bwd = {
				{
					override_damage_profile = DamageProfileTemplates.chaos_spawn_combo_heavy,
					override_damage_type = damage_types.minion_monster_blunt,
				},
				{
					override_damage_profile = DamageProfileTemplates.chaos_spawn_combo_heavy,
					override_damage_type = damage_types.minion_monster_blunt,
				},
			},
		},
		stagger_type_reduction = {
			explosion = 100,
			ranged = 100,
		},
		sweep_ground_impact_fx_timing = {
			attack_melee_combo = {
				0.43333333333333335,
				0.8666666666666667,
				1.3,
				1.7,
			},
			attack_melee_combo_2 = {
				1.0833333333333333,
				1.6111111111111112,
			},
			attack_melee_combo_3 = {
				0.6333333333333333,
				1.1333333333333333,
				1.8,
			},
			attack_melee_combo_4 = {
				1,
				2,
				2.033333333333333,
			},
			attack_turn_left = {
				0.5666666666666667,
				1.1,
				1.7333333333333334,
			},
			attack_turn_right = {
				0.6333333333333333,
			},
			attack_turn_bwd = {
				0.6666666666666666,
				0.7333333333333333,
				1.8666666666666667,
				1.9,
			},
		},
		sweep_ground_impact_fx_templates = {
			attack_melee_combo = {
				GroundImpactFxTemplates.chaos_spawn_claw,
				GroundImpactFxTemplates.chaos_spawn_tentacle,
				GroundImpactFxTemplates.chaos_spawn_claw,
				GroundImpactFxTemplates.chaos_spawn_tentacle,
			},
			attack_melee_combo_2 = {
				GroundImpactFxTemplates.chaos_spawn_tentacle,
				GroundImpactFxTemplates.chaos_spawn_claw,
			},
			attack_melee_combo_3 = {
				GroundImpactFxTemplates.chaos_spawn_claw,
				GroundImpactFxTemplates.chaos_spawn_tentacle,
				GroundImpactFxTemplates.chaos_spawn_claw,
			},
			attack_melee_combo_4 = {
				GroundImpactFxTemplates.chaos_spawn_claw,
				GroundImpactFxTemplates.chaos_spawn_claw,
				GroundImpactFxTemplates.chaos_spawn_tentacle,
			},
			attack_turn_left = {
				GroundImpactFxTemplates.chaos_spawn_claw,
				GroundImpactFxTemplates.chaos_spawn_tentacle,
				GroundImpactFxTemplates.chaos_spawn_claw,
			},
			attack_turn_right = {
				GroundImpactFxTemplates.chaos_spawn_tentacle,
			},
			attack_turn_bwd = {
				GroundImpactFxTemplates.chaos_spawn_claw,
				GroundImpactFxTemplates.chaos_spawn_tentacle,
				GroundImpactFxTemplates.chaos_spawn_claw,
				GroundImpactFxTemplates.chaos_spawn_tentacle,
			},
		},
		push_enemies_push_template = PushSettings.push_templates.chaos_spawn_combo,
		push_minions_damage_profile = DamageProfileTemplates.chaos_spawn_push_minions,
	},
	stagger = {
		stagger_anims = {
			light = {
				fwd = {
					"stagger_fwd_exp",
				},
				bwd = {
					"stagger_bwd_exp",
				},
				left = {
					"stagger_left_exp",
				},
				right = {
					"stagger_right_exp",
				},
				dwn = {
					"stagger_bwd_exp",
				},
			},
			medium = {
				fwd = {
					"stagger_fwd_exp",
				},
				bwd = {
					"stagger_bwd_exp",
				},
				left = {
					"stagger_left_exp",
				},
				right = {
					"stagger_right_exp",
				},
				dwn = {
					"stagger_bwd_exp",
				},
			},
			heavy = {
				fwd = {
					"stagger_fwd_exp",
				},
				bwd = {
					"stagger_bwd_exp",
				},
				left = {
					"stagger_left_exp",
				},
				right = {
					"stagger_right_exp",
				},
				dwn = {
					"stagger_bwd_exp",
				},
			},
			light_ranged = {
				fwd = {
					"stagger_fwd_exp",
				},
				bwd = {
					"stagger_bwd_exp",
				},
				left = {
					"stagger_left_exp",
				},
				right = {
					"stagger_right_exp",
				},
				dwn = {
					"stagger_bwd_exp",
				},
			},
			explosion = {
				fwd = {
					"stagger_fwd_exp",
				},
				bwd = {
					"stagger_bwd_exp",
				},
				left = {
					"stagger_left_exp",
				},
				right = {
					"stagger_right_exp",
				},
				dwn = {
					"stagger_bwd_exp",
				},
			},
			killshot = {
				fwd = {
					"stagger_fwd_exp",
				},
				bwd = {
					"stagger_bwd_exp",
				},
				left = {
					"stagger_left_exp",
				},
				right = {
					"stagger_right_exp",
				},
				dwn = {
					"stagger_bwd_exp",
				},
			},
			sticky = {
				fwd = {
					"stagger_fwd_exp",
				},
				bwd = {
					"stagger_bwd_exp",
				},
				left = {
					"stagger_left_exp",
				},
				right = {
					"stagger_right_exp",
				},
				dwn = {
					"stagger_bwd_exp",
				},
			},
			electrocuted = {
				fwd = {
					"stagger_fwd_exp",
				},
				bwd = {
					"stagger_bwd_exp",
				},
				left = {
					"stagger_left_exp",
				},
				right = {
					"stagger_right_exp",
				},
				dwn = {
					"stagger_bwd_exp",
				},
			},
			blinding = {
				fwd = {
					"stagger_fwd_exp",
				},
				bwd = {
					"stagger_bwd_exp",
				},
				left = {
					"stagger_left_exp",
				},
				right = {
					"stagger_right_exp",
				},
				dwn = {
					"stagger_bwd_exp",
				},
			},
		},
	},
	open_door = {
		rotation_duration = 0.1,
		stagger_immune = true,
	},
	smash_obstacle = {
		damage_type = nil,
		rotation_duration = 0.1,
		attack_anim_events = {
			"attack_melee_claw",
		},
		attack_anim_damage_timings = {
			attack_melee_claw = 0.5,
		},
		attack_anim_durations = {
			attack_melee_claw = 1.6666666666666667,
		},
		damage_profile = DamageProfileTemplates.default,
	},
	exit_spawner = {
		run_anim_event = "move_fwd",
	},
	patrol = {
		anim_events = {
			"walk_fwd",
		},
		speeds = {
			walk_fwd = 1.8,
		},
	},
	alerted = {
		instant_aggro_chance = 1,
		moving_alerted_anim_events = {
			bwd = "turn_bwd",
			fwd = "walk_fwd",
			left = "turn_left",
			right = "turn_right",
		},
		start_move_anim_data = {
			walk_fwd = {
				rad = nil,
				sign = nil,
			},
			turn_bwd = {
				sign = -1,
				rad = math.pi,
			},
			turn_left = {
				sign = 1,
				rad = math.pi / 2,
			},
			turn_right = {
				sign = -1,
				rad = math.pi / 2,
			},
		},
		start_move_rotation_timings = {
			turn_bwd = 0.13333333333333333,
			turn_left = 0.1,
			turn_right = 0.1,
			walk_fwd = nil,
		},
		start_rotation_durations = {
			turn_bwd = 0.4666666666666667,
			turn_left = 0.5,
			turn_right = 0.5,
			walk_fwd = nil,
		},
		alerted_durations = {
			turn_bwd = 0.6666666666666666,
			turn_left = 0.6666666666666666,
			turn_right = 0.6666666666666666,
			walk_fwd = 0.6666666666666666,
		},
	},
}

return action_data
