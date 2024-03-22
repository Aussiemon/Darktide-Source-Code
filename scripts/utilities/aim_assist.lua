local InputDevice = require("scripts/managers/input/input_device")
local SmartTargeting = require("scripts/utilities/smart_targeting")
local AimAssist = {}
local MULTIPLIER_EPSILON = 0.0001
local _aim_assist_multiplier = nil

AimAssist.increase_ramp_multiplier = function (t, aim_assist_ramp_component, ramp_settings)
	if not ramp_settings then
		return
	end

	local multiplier = ramp_settings.ramp_multiplier
	local max_multiplier = ramp_settings.max_ramp_multiplier
	local delay = ramp_settings.ramp_decay_delay or 0
	local current_multiplier = aim_assist_ramp_component.multiplier
	local new_multiplier = math.min(current_multiplier + multiplier, max_multiplier)
	aim_assist_ramp_component.multiplier = new_multiplier
	aim_assist_ramp_component.decay_end_time = t + delay
end

AimAssist.reset_ramp_multiplier = function (aim_assist_ramp_component)
	aim_assist_ramp_component.multiplier = 0
	aim_assist_ramp_component.decay_end_time = 0
end

AimAssist.update_ramp_multiplier = function (dt, t, aim_assist_ramp_component)
	local multiplier = aim_assist_ramp_component.multiplier
	local decay_end_time = aim_assist_ramp_component.decay_end_time

	if decay_end_time <= t then
		multiplier = math.max(multiplier - dt, 0)
		aim_assist_ramp_component.multiplier = multiplier
	end
end

AimAssist.apply_aim_assist = function (main_t, main_dt, input, targeting_data, aim_assist_ramp_component, combat_ability_action_component, weapon_action_component, look_yaw, look_pitch, position)
	local last_pressed_device = InputDevice.last_pressed_device
	local gamepad_active = last_pressed_device and last_pressed_device:type() == "xbox_controller"
	local enable_aim_assist = gamepad_active
	enable_aim_assist = enable_aim_assist and targeting_data and not not targeting_data.unit
	local aim_assist_type = Managers.save:account_data().input_settings.controller_aim_assist

	if aim_assist_type ~= "old" then
		enable_aim_assist = false
	end

	if not enable_aim_assist then
		return look_yaw, look_pitch
	end

	local game_t = Managers.time:time("gameplay")
	local smart_targeting_template = SmartTargeting.smart_targeting_template(game_t, combat_ability_action_component, weapon_action_component)
	local aim_assist_settings = smart_targeting_template and smart_targeting_template.aim_assist

	if not aim_assist_settings or not aim_assist_settings.always_auto_aim then
		return look_yaw, look_pitch
	end

	local target_rotation = targeting_data.target_rotation:unbox()
	local aim_assist_multiplier = _aim_assist_multiplier(input, aim_assist_ramp_component, aim_assist_settings, gamepad_active)
	local yaw_lerp_t = math.clamp(main_dt * aim_assist_multiplier * 5, 0, 1)
	local pitch_lerp_t = math.clamp(main_dt * aim_assist_multiplier * aim_assist_multiplier * 25, 0, 1)
	local look_yaw_rotation = Quaternion(Vector3.up(), look_yaw)
	local look_pitch_rotation = Quaternion(Vector3.right(), look_pitch)
	local look_rotation = Quaternion.multiply(look_yaw_rotation, look_pitch_rotation)
	local horizontal_lerp = Quaternion.lerp(look_rotation, target_rotation, yaw_lerp_t)
	local vertical_lerp = Quaternion.lerp(look_rotation, target_rotation, pitch_lerp_t)
	local lerp_yaw = Quaternion.yaw(horizontal_lerp)
	local lerp_pitch = Quaternion.pitch(vertical_lerp)

	return lerp_yaw, lerp_pitch
end

function _aim_assist_multiplier(input, aim_assist_ramp_component, aim_assist_settings, gamepad_active)
	local base_multiplier = aim_assist_settings.base_multiplier
	local no_aim_input_multiplier = aim_assist_settings.no_aim_input_multiplier
	local ramp_multiplier = aim_assist_ramp_component.multiplier
	local multiplier = nil
	local input_alias = "look_raw_controller"
	local look_raw = input:get(input_alias)

	if Vector3.length_squared(look_raw) < MULTIPLIER_EPSILON then
		multiplier = math.min(no_aim_input_multiplier + ramp_multiplier, 1)
		local move = input:get("move")

		if Vector3.length_squared(move) < MULTIPLIER_EPSILON then
			multiplier = 0
		end
	end

	multiplier = multiplier or math.min(base_multiplier + ramp_multiplier, 1)

	return multiplier
end

AimAssist.sensitivity_modifier = function (aim_assist_context)
	local aim_assist_type = Managers.save:account_data().input_settings.controller_aim_assist

	if aim_assist_type ~= "new_slim" and aim_assist_type ~= "new_full" then
		return 1
	end

	if not aim_assist_context.input_device_wants_aim_assist then
		return 1
	end

	if not aim_assist_context.targeting_data.unit then
		return 1
	end

	return 0.5
end

local function _stop_movement_aim_assist(internal)
	internal.assisting = false
	internal.assist_sticky_timer = nil
end

local function _handle_start_stop_movement_assist(internal, aim_assist_context, move_input, targeting_data, t)
	local is_assisting = internal.assisting
	local aim_assist_type = Managers.save:account_data().input_settings.controller_aim_assist

	if aim_assist_type ~= "new_full" then
		if is_assisting then
			_stop_movement_aim_assist(internal)
		end

		return false
	end

	if not aim_assist_context.input_device_wants_aim_assist then
		if is_assisting then
			_stop_movement_aim_assist(internal)
		end

		return false
	end

	if Vector3.length_squared(move_input) == 0 then
		if is_assisting then
			_stop_movement_aim_assist(internal)
		end

		return false
	end

	local unit = targeting_data.unit
	local has_good_target = unit and targeting_data.distance_to_box < 0.1

	if not is_assisting then
		if has_good_target then
			internal.assisting = true
		end

		return false
	end

	if not has_good_target then
		local sticky_timer = 0.1

		if not internal.assist_sticky_timer then
			internal.assist_sticky_timer = t + sticky_timer
		end

		if internal.assist_sticky_timer <= t then
			_stop_movement_aim_assist(internal)

			return false
		end
	elseif internal.assist_sticky_timer then
		internal.assist_sticky_timer = nil
	end

	return true
end

local TAU = math.pi * 2
local YAW_PER_SECOND_MIN = TAU / 128
local YAW_PER_SECOND_MAX = TAU / 24
local _internal = {
	lock_start_t = 0,
	previous_distance = 0,
	has_lock = false,
	finding_lock = false,
	locking = false,
	assisting = false,
	finding_lock_start_t = 0,
	lock_modifies_pitch = false,
	lock_modifies_yaw = false,
	target_position = Vector3Box(Vector3.zero()),
	lock_position = Vector3Box(Vector3.zero())
}

AimAssist.apply_movement_aim_assist = function (aim_assist_context, orientation, input, look_delta, dt, t)
	local targeting_data = aim_assist_context.targeting_data
	local move_input = input:get("move")
	local is_assisting = _handle_start_stop_movement_assist(_internal, aim_assist_context, move_input, targeting_data, t)

	if not is_assisting then
		return
	end

	local before_corrected_yaw = orientation.yaw
	local flat_rotation = Quaternion.from_yaw_pitch_roll(before_corrected_yaw, 0, orientation.roll)
	local fp_pos = Unit.world_position(aim_assist_context.first_person_unit, 1)
	local target_position = _internal.target_position:unbox()
	local target_rotation = Quaternion.look(target_position - fp_pos)
	local delta_rotation = Quaternion.multiply(Quaternion.inverse(target_rotation), flat_rotation)
	local yaw_delta = Quaternion.yaw(delta_rotation)
	local yaw_delta_dir = math.sign(yaw_delta)
	local yaw_per_second = math.lerp(YAW_PER_SECOND_MIN, YAW_PER_SECOND_MAX, math.abs(move_input.x))
	local yaw_correction = yaw_delta_dir * yaw_per_second * dt

	if math.abs(yaw_delta) < math.abs(yaw_correction) then
		yaw_correction = yaw_delta
	end

	orientation.yaw = before_corrected_yaw - yaw_correction
end

AimAssist.apply_lock_on = function (aim_assist_context, main_t, targeting_data, look_delta, yaw, pitch)
	local currently_locking = _internal.locking
	local aim_assist_type = Managers.save:account_data().input_settings.controller_aim_assist

	if aim_assist_type ~= "new_slim" and aim_assist_type ~= "new_full" then
		if currently_locking then
			_internal.locking = false
		end

		return yaw, pitch
	end

	if not aim_assist_context.input_device_wants_aim_assist then
		if currently_locking then
			_internal.locking = false
		end

		return yaw, pitch
	end

	if math.abs(look_delta.x) > 0 then
		if currently_locking then
			_internal.locking = false
		end

		return yaw, pitch
	end

	if not currently_locking and aim_assist_context.wants_lock_on then
		_internal.locking = true
		currently_locking = true
		_internal.finding_lock = true
		_internal.finding_lock_start_t = main_t
		_internal.has_lock = false
	end

	if not currently_locking then
		return yaw, pitch
	end

	if _internal.finding_lock then
		local unit = targeting_data.unit
		local has_good_target = unit and targeting_data.distance_to_box_x < 0.5 and targeting_data.distance_to_box_y < 0.2

		if has_good_target then
			_internal.lock_position:store(targeting_data.target_position:unbox())

			_internal.lock_start_t = main_t
			_internal.has_lock = true
			_internal.finding_lock = false
			_internal.lock_modifies_pitch = targeting_data.distance_to_box_y > 0.05
			_internal.lock_modifies_yaw = true
		elseif main_t - _internal.finding_lock_start_t > 0.1 then
			_internal.locking = false

			return yaw, pitch
		end
	end

	if _internal.has_lock then
		local lock_position = _internal.lock_position:unbox()
		local fp_pos = Unit.world_position(aim_assist_context.first_person_unit, 1)
		local target_dir = Vector3.normalize(lock_position - fp_pos)
		local time_to_lock = 0.1
		local t = math.min((main_t - _internal.lock_start_t) / time_to_lock, 1)
		local target_rotation = Quaternion.look(target_dir)
		local current_rotation = Quaternion.from_yaw_pitch_roll(yaw, pitch, 0)
		local delta_rotation = Quaternion.multiply(Quaternion.inverse(target_rotation), current_rotation)

		if _internal.lock_modifies_yaw then
			local delta_yaw = Quaternion.yaw(delta_rotation)
			local target_yaw = yaw - delta_yaw
			local lerped_yaw = math.lerp(yaw, target_yaw, t)
			yaw = lerped_yaw

			if math.abs(target_yaw - lerped_yaw) < 0.001 then
				_internal.lock_modifies_yaw = false
			end
		end

		if _internal.lock_modifies_pitch then
			local delta_pitch = Quaternion.pitch(delta_rotation)
			local target_pitch = pitch - delta_pitch
			local lerped_pitch = math.lerp(pitch, target_pitch, t)
			pitch = lerped_pitch

			if math.abs(target_pitch - lerped_pitch) < 0.001 then
				_internal.lock_modifies_pitch = false
			end
		end

		if t == 1 or not _internal.lock_modifies_yaw and not _internal.lock_modifies_pitch then
			_internal.locking = false
			_internal.has_lock = false
		end
	end

	return yaw, pitch
end

AimAssist.store_target_position = function (aim_assist_context, orientation)
	if not _internal.assisting then
		return
	end

	local fp_pos = Unit.world_position(aim_assist_context.first_person_unit, 1)
	local flat_rotation = Quaternion.from_yaw_pitch_roll(orientation.yaw, 0, orientation.roll)
	local flat_player_forward = Quaternion.forward(flat_rotation)
	local targeting_data = aim_assist_context.targeting_data
	local distance_to_target = math.max(targeting_data.distance or _internal.previous_distance, 2.5)
	local target_position = fp_pos + flat_player_forward * distance_to_target

	_internal.target_position:store(target_position)

	_internal.previous_distance = distance_to_target
end

return AimAssist
