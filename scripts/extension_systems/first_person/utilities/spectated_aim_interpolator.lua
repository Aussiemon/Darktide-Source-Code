-- chunkname: @scripts/extension_systems/first_person/utilities/spectated_aim_interpolator.lua

local SpectatedAimInterpolator = class("SpectatedAimInterpolator")
local INTERP_DELAY_STEPS = 2
local MAX_EXTRAP_STEPS = 1
local MAX_SAMPLES = 8
local DUPLICATE_EPSILON = 0.0001
local PI = math.pi
local TWO_PI = PI * 2

local function _sample_index(start_index, logical_index)
	return (start_index + logical_index - 2) % MAX_SAMPLES + 1
end

local function _next_index(index)
	return index == MAX_SAMPLES and 1 or index + 1
end

local function _shortest_angle_delta(a, b)
	return (b - a + PI) % TWO_PI - PI
end

local function _hermite_non_uniform(s, p0, p1, p2, p3, t0, t1, t2, t3)
	local h = t2 - t1
	local left_span = t2 - t0
	local right_span = t3 - t1
	local m1 = left_span > 0 and (p2 - p0) / left_span or 0
	local m2 = right_span > 0 and (p3 - p1) / right_span or 0
	local s2 = s * s
	local s3 = s2 * s
	local h00 = 2 * s3 - 3 * s2 + 1
	local h10 = s3 - 2 * s2 + s
	local h01 = -2 * s3 + 3 * s2
	local h11 = s3 - s2

	return h00 * p1 + h10 * h * m1 + h01 * p2 + h11 * h * m2
end

SpectatedAimInterpolator.init = function (self, fixed_time_step)
	self._fixed_time_step = fixed_time_step
	self._interp_delay = fixed_time_step * INTERP_DELAY_STEPS
	self._max_extrap = fixed_time_step * MAX_EXTRAP_STEPS
	self._samples = Script.new_array(MAX_SAMPLES)
	self._sample_start = 1
	self._sample_count = 0
	self._last_sample_frame = nil
	self._last_raw_yaw = nil
	self._continuous_yaw = 0
	self._render_time = nil

	for i = 1, MAX_SAMPLES do
		self._samples[i] = {
			frame = -1,
			pitch = 0,
			time = 0,
			yaw = 0,
		}
	end
end

SpectatedAimInterpolator.reset = function (self)
	self._sample_start = 1
	self._sample_count = 0
	self._last_sample_frame = nil
	self._last_raw_yaw = nil
	self._continuous_yaw = 0
	self._render_time = nil

	for i = 1, MAX_SAMPLES do
		self._samples[i].frame = -1
	end
end

SpectatedAimInterpolator.update = function (self, rotation, sample_frame, dt)
	if sample_frame ~= self._last_sample_frame then
		local yaw, pitch, _ = Quaternion.to_yaw_pitch_roll(rotation)

		self:_push_sample(sample_frame, yaw, pitch)

		self._last_sample_frame = sample_frame
	end

	return self:_interpolated_rotation(dt)
end

SpectatedAimInterpolator._sample = function (self, logical_index)
	return self._samples[_sample_index(self._sample_start, logical_index)]
end

SpectatedAimInterpolator._sample_rotation = function (self, sample)
	return Quaternion.from_yaw_pitch_roll(sample.yaw, sample.pitch, 0)
end

SpectatedAimInterpolator._push_sample = function (self, sample_frame, raw_yaw, pitch)
	local sample_count = self._sample_count

	if sample_count > 0 then
		local newest_sample = self:_sample(sample_count)

		if sample_frame <= newest_sample.frame then
			return
		end
	end

	local continuous_yaw

	if self._last_raw_yaw then
		continuous_yaw = self._continuous_yaw + _shortest_angle_delta(self._last_raw_yaw, raw_yaw)
	else
		continuous_yaw = raw_yaw
	end

	self._last_raw_yaw = raw_yaw
	self._continuous_yaw = continuous_yaw

	if sample_count > 0 then
		local newest_sample = self:_sample(sample_count)

		if math.abs(continuous_yaw - newest_sample.yaw) <= DUPLICATE_EPSILON and math.abs(pitch - newest_sample.pitch) <= DUPLICATE_EPSILON then
			newest_sample.frame = sample_frame
			newest_sample.time = sample_frame * self._fixed_time_step

			return
		end
	end

	local write_index

	if sample_count < MAX_SAMPLES then
		sample_count = sample_count + 1
		self._sample_count = sample_count
		write_index = _sample_index(self._sample_start, sample_count)
	else
		write_index = self._sample_start
		self._sample_start = _next_index(self._sample_start)
	end

	local sample = self._samples[write_index]

	sample.frame = sample_frame
	sample.time = sample_frame * self._fixed_time_step
	sample.yaw = continuous_yaw
	sample.pitch = pitch
end

SpectatedAimInterpolator._interpolated_rotation = function (self, dt)
	local sample_count = self._sample_count

	if sample_count == 1 then
		return self:_sample_rotation(self:_sample(1))
	end

	local newest_sample = self:_sample(sample_count)
	local target_time = newest_sample.time - self._interp_delay
	local render_ceiling = newest_sample.time + self._max_extrap
	local render_floor = target_time - self._max_extrap

	if not self._render_time then
		self._render_time = target_time
	else
		self._render_time = math.clamp(self._render_time + dt, render_floor, render_ceiling)
	end

	local render_time = self._render_time
	local oldest_sample = self:_sample(1)

	if render_time <= oldest_sample.time then
		return self:_sample_rotation(oldest_sample)
	end

	for i = 1, sample_count - 1 do
		local to_sample = self:_sample(i + 1)

		if render_time <= to_sample.time then
			local from_sample = self:_sample(i)
			local segment_duration = to_sample.time - from_sample.time
			local s = segment_duration > 0 and math.clamp((render_time - from_sample.time) / segment_duration, 0, 1) or 1
			local before_sample = i > 1 and self:_sample(i - 1) or from_sample
			local after_sample = sample_count >= i + 2 and self:_sample(i + 2) or to_sample
			local yaw = _hermite_non_uniform(s, before_sample.yaw, from_sample.yaw, to_sample.yaw, after_sample.yaw, before_sample.time, from_sample.time, to_sample.time, after_sample.time)
			local pitch = _hermite_non_uniform(s, before_sample.pitch, from_sample.pitch, to_sample.pitch, after_sample.pitch, before_sample.time, from_sample.time, to_sample.time, after_sample.time)

			return Quaternion.from_yaw_pitch_roll(yaw, pitch, 0)
		end
	end

	local prev_sample = self:_sample(sample_count - 1)
	local prev_duration = newest_sample.time - prev_sample.time
	local extrap = math.min(render_time - newest_sample.time, self._max_extrap)

	if prev_duration > 0 and extrap > 0 then
		local yaw_velocity = (newest_sample.yaw - prev_sample.yaw) / prev_duration
		local pitch_velocity = (newest_sample.pitch - prev_sample.pitch) / prev_duration
		local yaw = newest_sample.yaw + yaw_velocity * extrap
		local pitch = newest_sample.pitch + pitch_velocity * extrap

		return Quaternion.from_yaw_pitch_roll(yaw, pitch, 0)
	end

	return self:_sample_rotation(newest_sample)
end

return SpectatedAimInterpolator
