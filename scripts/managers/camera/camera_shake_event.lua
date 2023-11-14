local CameraEffectSettings = require("scripts/settings/camera/camera_effect_settings")
local CameraShakeEvent = class("CameraShakeEvent")
local PI = math.pi

CameraShakeEvent.init = function (self, event_name, source_unit_data)
	local event = CameraEffectSettings.shake[event_name]
	local fade_in = event.fade_in
	local fade_out = event.fade_out
	local duration = event.duration
	duration = (duration or 0) + (fade_in or 0) + (fade_out or 0)
	self._event = event
	self._current_time = 0
	self._end_time = duration
	self._fade_in_time = fade_in
	self._fade_out_time = fade_out
	self._seed = event.seed or math.random(1, 100)
	self._source_unit_data = source_unit_data
	self._is_done = false
	self._engine_math = rawget(_G, "EditorApi") and Math or math
	self._math_utils_or_math = rawget(_G, "EditorApi") and MathUtils or math
	local save_manager = Managers.save
	local sway_intensity = nil

	if save_manager then
		local account_data = save_manager:account_data()
		local value = account_data.interface_settings.camera_movement_offset_sway_intensity
		sway_intensity = math.ilerp(0, 1, value)
	end

	self._sway_intensity = sway_intensity or 1
end

CameraShakeEvent.update = function (self, dt, camera_data, camera_position)
	self:_apply_shake_event(dt, camera_data, camera_position)
end

CameraShakeEvent.done = function (self)
	return self._is_done
end

CameraShakeEvent._apply_shake_event = function (self, dt, camera_data, camera_position)
	local current_time = self._current_time + dt
	self._current_time = current_time
	local end_time = self._end_time
	local fade_in_time = self._fade_in_time
	local fade_out_time = self._fade_out_time
	local _math_utils_or_math = self._math_utils_or_math
	local fade_progress = nil

	if fade_in_time and current_time <= fade_in_time then
		fade_progress = _math_utils_or_math.clamp(current_time / fade_in_time, 0, 1) or 0
	elseif fade_out_time and fade_out_time <= current_time then
		fade_progress = _math_utils_or_math.clamp((end_time - current_time) / (end_time - fade_out_time), 0, 1) or 0
	end

	local scale = 1

	if self._source_unit_data then
		local unit_data = self._source_unit_data
		local source_position = unit_data.source_position:unbox()
		local near_dist = unit_data.near_dist
		local far_dist = unit_data.far_dist
		local near_value = unit_data.near_value
		local far_value = unit_data.far_value
		local d = Vector3.distance(source_position, camera_position)
		scale = 1 - _math_utils_or_math.clamp((d - near_dist) / (far_dist - near_dist), 0, 1)
		scale = far_value + scale * (near_value - far_value)
	end

	scale = scale * self._sway_intensity
	local pitch_noise_value = self:_calculate_perlin_value(current_time, fade_progress) * scale
	local yaw_noise_value = self:_calculate_perlin_value(current_time + 10, fade_progress) * scale
	local current_rot = camera_data.rotation
	local deg_to_rad = PI / 180
	local yaw_offset = yaw_noise_value * deg_to_rad
	local pitch_offset = pitch_noise_value * deg_to_rad
	local total_offset = Quaternion.from_yaw_pitch_roll(yaw_offset, pitch_offset, 0)
	camera_data.rotation = Quaternion.multiply(current_rot, total_offset)

	if end_time <= current_time then
		self._is_done = true
	end
end

CameraShakeEvent._calculate_perlin_value = function (self, x, fade_progress)
	local total = 0
	local event_settings = self._event
	local persistance = event_settings.persistance
	local number_of_octaves = event_settings.octaves

	for i = 0, number_of_octaves do
		local frequency = 2^i
		local amplitude = persistance^i
		total = total + self:_interpolated_noise(x * frequency) * amplitude
	end

	local amplitude_multiplier = event_settings.amplitude or 1
	local fade_multiplier = fade_progress or 1
	total = total * amplitude_multiplier * fade_multiplier

	return total
end

CameraShakeEvent._interpolated_noise = function (self, x)
	local x_floored = math.floor(x)
	local remainder = x - x_floored
	local v1 = self:_smoothed_noise(x_floored)
	local v2 = self:_smoothed_noise(x_floored + 1)
	local _math_utils_or_math = self._math_utils_or_math

	return _math_utils_or_math.lerp(v1, v2, remainder)
end

CameraShakeEvent._smoothed_noise = function (self, x)
	return self:_noise(x) / 2 + self:_noise(x - 1) / 4 + self:_noise(x + 1) / 4
end

CameraShakeEvent._noise = function (self, x)
	local seed = self._seed
	local math = self._engine_math
	local next_seed, _ = math.next_random(x + seed)
	local _, value = math.next_random(next_seed)

	return value * 2 - 1
end

return CameraShakeEvent
