-- chunkname: @scripts/settings/player_character/hub_movement_settings_templates.lua

local HubMovementSettingsTemplates = {}

HubMovementSettingsTemplates.human = {
	shared = {
		stop_move_speed_threshold = 1,
		velocity_wall_slide_lerp_speed = 5,
		turn_in_place_rot_speed_multiplier = 0.3333333333333333,
		moving_180_turn_half_angle = 35,
		animation_rotation_correction_weight = 0,
		turn_in_place_timeout = 0.1,
		mover_max_slope_angle = 45,
		animation_rotation_correction_threshold = math.pi / 8,
		move_state_force_timings = {
			sprint = 0.6,
			jog = 0.4,
			walk = 0.6
		}
	},
	move_states = {
		walk = {
			move_speed = 1.6,
			acceleration = 5,
			rotation_speed = 360,
			repeat_no_move_input_timer = 0.5,
			deceleration = 4,
			allowed_turning_angle = 115,
			repeat_move_input_timer = 0.1,
			active_deceleration = 7,
			movement_direction_modifier = 0.5,
			from_state_overrides = {
				sprint = {
					acceleration = 10,
					duration = 0.3
				}
			}
		},
		jog = {
			move_speed = 3.5,
			acceleration = 8,
			rotation_speed = 360,
			repeat_no_move_input_timer = 0.4,
			deceleration = 6,
			allowed_turning_angle = 60,
			repeat_move_input_timer = 0.1,
			active_deceleration = 14,
			movement_direction_modifier = 0.3,
			from_state_overrides = {
				sprint = {
					deceleration = 10,
					duration = 0.5,
					active_deceleration = 14
				}
			}
		},
		sprint = {
			move_speed = 5.6,
			acceleration = 7,
			rotation_speed = 360,
			repeat_no_move_input_timer = 0.4,
			deceleration = 10,
			allowed_turning_angle = 28,
			repeat_move_input_timer = 0.65,
			active_deceleration = 24,
			movement_direction_modifier = 0.5,
			from_state_overrides = {}
		}
	}
}
HubMovementSettingsTemplates.ogryn = {
	shared = {
		stop_move_speed_threshold = 0.4,
		velocity_wall_slide_lerp_speed = 5,
		turn_in_place_rot_speed_multiplier = 0.3333333333333333,
		moving_180_turn_half_angle = 30,
		animation_rotation_correction_weight = 0,
		turn_in_place_timeout = 0.1,
		mover_max_slope_angle = 45,
		animation_rotation_correction_threshold = math.pi / 8,
		move_state_force_timings = {
			sprint = 0.6,
			jog = 0.6,
			walk = 0.6
		}
	},
	move_states = {
		walk = {
			move_speed = 1.75,
			acceleration = 5,
			rotation_speed = 360,
			repeat_no_move_input_timer = 0.5,
			deceleration = 4,
			allowed_turning_angle = 85,
			repeat_move_input_timer = 0.1,
			active_deceleration = 7,
			movement_direction_modifier = 0.3,
			from_state_overrides = {
				sprint = {
					acceleration = 16,
					duration = 0.2
				}
			}
		},
		jog = {
			move_speed = 4,
			acceleration = 7.5,
			rotation_speed = 360,
			repeat_no_move_input_timer = 0.2,
			deceleration = 8,
			allowed_turning_angle = 50,
			repeat_move_input_timer = 0.1,
			active_deceleration = 14,
			movement_direction_modifier = 0.4,
			from_state_overrides = {
				sprint = {
					deceleration = 10,
					duration = 0.5,
					active_deceleration = 14
				}
			}
		},
		sprint = {
			move_speed = 6.3,
			acceleration = 8,
			rotation_speed = 360,
			repeat_no_move_input_timer = 0.4,
			deceleration = 11,
			allowed_turning_angle = 25,
			repeat_move_input_timer = 0.45,
			active_deceleration = 20,
			movement_direction_modifier = 0.5,
			from_state_overrides = {}
		}
	}
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
