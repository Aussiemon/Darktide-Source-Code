-- chunkname: @scripts/settings/player_character/hub_movement_settings_templates.lua

local HubMovementSettingsTemplates = {}

HubMovementSettingsTemplates.human = {
	shared = {
		animation_rotation_correction_weight = 0,
		mover_max_slope_angle = 45,
		moving_180_turn_half_angle = 35,
		stop_move_speed_threshold = 1,
		turn_in_place_rot_speed_multiplier = 0.3333333333333333,
		turn_in_place_timeout = 0.1,
		velocity_wall_slide_lerp_speed = 5,
		animation_rotation_correction_threshold = math.pi / 8,
		move_state_force_timings = {
			jog = 0.4,
			sprint = 0.6,
			walk = 0.6,
		},
	},
	move_states = {
		walk = {
			acceleration = 5,
			active_deceleration = 7,
			allowed_turning_angle = 115,
			deceleration = 4,
			move_speed = 1.6,
			movement_direction_modifier = 0.5,
			repeat_move_input_timer = 0.1,
			repeat_no_move_input_timer = 0.5,
			rotation_speed = 360,
			from_state_overrides = {
				sprint = {
					acceleration = 10,
					duration = 0.3,
				},
			},
		},
		jog = {
			acceleration = 8,
			active_deceleration = 14,
			allowed_turning_angle = 60,
			deceleration = 6,
			move_speed = 3.5,
			movement_direction_modifier = 0.3,
			repeat_move_input_timer = 0.1,
			repeat_no_move_input_timer = 0.4,
			rotation_speed = 360,
			from_state_overrides = {
				sprint = {
					active_deceleration = 14,
					deceleration = 10,
					duration = 0.5,
				},
			},
		},
		sprint = {
			acceleration = 7,
			active_deceleration = 24,
			allowed_turning_angle = 28,
			deceleration = 10,
			move_speed = 5.6,
			movement_direction_modifier = 0.5,
			repeat_move_input_timer = 0.65,
			repeat_no_move_input_timer = 0.4,
			rotation_speed = 360,
			from_state_overrides = {},
		},
	},
}
HubMovementSettingsTemplates.ogryn = {
	shared = {
		animation_rotation_correction_weight = 0,
		mover_max_slope_angle = 45,
		moving_180_turn_half_angle = 30,
		stop_move_speed_threshold = 0.4,
		turn_in_place_rot_speed_multiplier = 0.3333333333333333,
		turn_in_place_timeout = 0.1,
		velocity_wall_slide_lerp_speed = 5,
		animation_rotation_correction_threshold = math.pi / 8,
		move_state_force_timings = {
			jog = 0.6,
			sprint = 0.6,
			walk = 0.6,
		},
	},
	move_states = {
		walk = {
			acceleration = 5,
			active_deceleration = 7,
			allowed_turning_angle = 85,
			deceleration = 4,
			move_speed = 1.75,
			movement_direction_modifier = 0.3,
			repeat_move_input_timer = 0.1,
			repeat_no_move_input_timer = 0.5,
			rotation_speed = 360,
			from_state_overrides = {
				sprint = {
					acceleration = 16,
					duration = 0.2,
				},
			},
		},
		jog = {
			acceleration = 7.5,
			active_deceleration = 14,
			allowed_turning_angle = 50,
			deceleration = 8,
			move_speed = 4,
			movement_direction_modifier = 0.4,
			repeat_move_input_timer = 0.1,
			repeat_no_move_input_timer = 0.2,
			rotation_speed = 360,
			from_state_overrides = {
				sprint = {
					active_deceleration = 14,
					deceleration = 10,
					duration = 0.5,
				},
			},
		},
		sprint = {
			acceleration = 8,
			active_deceleration = 20,
			allowed_turning_angle = 25,
			deceleration = 11,
			move_speed = 6.3,
			movement_direction_modifier = 0.5,
			repeat_move_input_timer = 0.45,
			repeat_no_move_input_timer = 0.4,
			rotation_speed = 360,
			from_state_overrides = {},
		},
	},
}

local degrees_to_radians = 0.0174532925

for _, template in pairs(HubMovementSettingsTemplates) do
	local shared = template.shared
	local stop_move_speed_threshold = shared.stop_move_speed_threshold

	shared.stop_move_speed_threshold_sq = stop_move_speed_threshold * stop_move_speed_threshold

	local moving_180_turn_half_angle_rad = shared.moving_180_turn_half_angle * degrees_to_radians

	shared.moving_turnaround_angle_rad = math.pi - moving_180_turn_half_angle_rad

	local move_states = template.move_states

	for _, move_state in pairs(move_states) do
		move_state.allowed_turning_angle_rad = move_state.allowed_turning_angle * degrees_to_radians
		move_state.rotation_speed_rad = move_state.rotation_speed * degrees_to_radians
	end
end

return HubMovementSettingsTemplates
