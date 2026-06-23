-- chunkname: @scripts/settings/breed/breed_actions/companion/companion_servo_skull_actions.lua

local BreedShootTemplates = require("scripts/settings/breed/breed_shoot_templates")
local CompanionServoSkullFlamerGasTemplates = require("scripts/settings/projectile/companion_servo_skull_flamer_gas_templates")
local CompanionServoSkullAbility = require("scripts/utilities/companion/companion_servo_skull_ability")
local CompanionServoSkullSettings = require("scripts/settings/companion/companion_servo_skull_settings")
local distance_threshold_sq = CompanionServoSkullSettings.distance_threshold_sq
local action_data = {
	name = "companion_servo_skull",
	manual_teleport = {
		wait_time = 1,
	},
	teleport = {
		keep_outline = false,
	},
	idle = {
		ignore_rotate_towards_target = true,
	},
	shoot = {
		charged_effect_template = "companion_servo_skull_charged_shooting",
		force_start_in_cooldown = true,
		fx_source_name = "muzzle",
		inventory_slot = "slot_weapon",
		on_shoot_animation = "shoot",
		restore_ammo_if_no_line_of_sight = true,
		update_game_object_shooting_cooldown = true,
		aim_anim_events = {
			"aim_standing",
		},
		aim_duration = {
			aim_standing = {
				{
					0,
					0,
				},
			},
		},
		shoot_cooldown = {
			{
				3,
				3.25,
			},
		},
		num_shots = {
			{
				1,
				1,
			},
		},
		time_per_shot = {
			{
				0.5,
				0.8,
			},
		},
		aim_dot_threshold = math.cos(math.pi / 9),
		shoot_template = BreedShootTemplates.companion_servo_skull_default,
	},
	shoot_flames = {
		duration = 15,
		effect_template_name = "companion_servo_skull_flamer",
		flame_start_animation = "start_flame",
		flame_stop_animation = "stop_flame",
		fx_source_name = "fx_muzzle",
		in_rotation_speed = 10,
		initial_pitch_rotation_angle = -11.25,
		inventory_slot = "slot_full",
		max_range = 10,
		move_effect_template = "companion_servo_skull_move_action_effect",
		number_of_rays_per_frame = 4,
		out_rotation_speed = 0,
		shooting_collision_filter = "filter_player_character_shooting_raycast",
		spread_angle_pitch = 4,
		spread_angle_yaw = 12.5,
		suppression_cone_radius = 2,
		wait_to_reach_position = true,
		flame_cone = {
			rotation_angle_speed = 2,
			max_angle = math.pi / 18,
		},
		flame_circle = {
			rotation_angle_speed = 3.5,
		},
		flamer_gas_template = CompanionServoSkullFlamerGasTemplates.auto,
		optional_leave_function = CompanionServoSkullAbility.finish_flamethrower_ability,
		trigger_stat_hooks_for_player_owner = {
			action_enter = "hook_cryptic_servo_skull_flame_attack_start",
			unique_hit = "hook_cryptic_servo_skull_flame_attack_unique_minion_hit",
		},
		distance_threshold_sq = distance_threshold_sq.flamethrower,
	},
	inject_ally = {
		assist_notification_type = "stimmed",
		buff_name = "cryptic_servo_skull_medicae_buff",
		delay_before_reviving = 1,
		inject_start_animation = "start_inject",
		inject_stop_animation = "stop_inject",
		move_effect_template = "companion_servo_skull_move_action_effect",
		position_height = 1,
		revive = true,
		syringe_effect_template_name = "companion_servo_skull_heal_effect",
		optional_leave_function = CompanionServoSkullAbility.finish_inject_ally_ability,
		distance_threshold_sq = distance_threshold_sq.inject_ally,
	},
	hack_decode = {
		hacking_effect_template_name = "companion_servo_skull_hacking_effect",
		hacking_start_animation = "start_hacking",
		hacking_stop_animation = "stop_hacking",
		in_rotation_speed = 10,
		move_effect_template = "companion_servo_skull_move_action_effect",
		out_rotation_speed = 0,
		hacking_minigame_duration = CompanionServoSkullSettings.hacking_minigame_duration,
		optional_leave_function = CompanionServoSkullAbility.finish_hacking_ability,
		distance_threshold_sq = distance_threshold_sq.hacking,
	},
}

return action_data
