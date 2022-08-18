local SweepSplineExported = class("SweepSplineExported")
local _find_frame, _apply_first_person_context, _damage_window_frames, _build_matrix = nil

SweepSplineExported.init = function (self, action_settings, first_person_component)
	fassert(action_settings.spline_settings, "Requires spline_settings.")
	fassert(action_settings.damage_window_start, "Requires damage_window_start.")
	fassert(action_settings.damage_window_end, "Requires damage_window_end.")

	self._first_person_component = first_person_component
	self._action_settings = action_settings

	self:_build(action_settings)
end

SweepSplineExported.position_and_rotation = function (self, t)
	local frame = t == 0 and 1 or math.ceil(self._num_frames * t)
	local local_matrix = Matrix4x4Box.unbox(self._matrices[frame])
	local local_point = Matrix4x4.translation(local_matrix)
	local local_rotation = Matrix4x4.rotation(local_matrix)
	local sweep_position, sweep_rotation = _apply_first_person_context(local_point, local_rotation, self._first_person_component, self._action_settings.spline_settings.anchor_point_offset)

	return sweep_position, sweep_rotation
end

SweepSplineExported.rebuild = function (self, action_settings)
	self._action_settings = action_settings

	self:_build(action_settings)
end

SweepSplineExported._build = function (self, action_settings)
	local spline_settings = action_settings.spline_settings
	local matrices_data_location = spline_settings.matrices_data_location

	fassert(matrices_data_location, "Could not find any matrices data.")

	local matrices_data = dofile(matrices_data_location)
	local num_frames = 0
	local full_frame_to_time_map = {}
	local max_time = 0

	for t, matrix_data in pairs(matrices_data) do
		if max_time < t then
			max_time = t
		end

		local frame_index = num_frames + 1

		for i = 1, num_frames do
			local time = full_frame_to_time_map[i]

			if t < time then
				frame_index = i

				break
			end
		end

		table.insert(full_frame_to_time_map, frame_index, t)

		num_frames = num_frames + 1
	end

	local start_frame, end_frame = _damage_window_frames(action_settings, full_frame_to_time_map, num_frames)
	local matrices = {}
	self._matrices = matrices
	local frame_to_time_map = {}
	self._frame_to_time_map = frame_to_time_map
	local num_hit_detection_frames = 0

	for frame = start_frame, end_frame do
		local t = full_frame_to_time_map[frame]
		local matrix_data = matrices_data[t]
		local matrix = _build_matrix(matrix_data)
		num_hit_detection_frames = num_hit_detection_frames + 1
		matrices[num_hit_detection_frames] = Matrix4x4Box(matrix)
		frame_to_time_map[num_hit_detection_frames] = t
	end

	self._num_frames = num_hit_detection_frames
end

function _find_frame(time, frame_to_time_map, num_frames)
	local prev_frame_time = 0

	for i = 1, num_frames do
		local frame_time = frame_to_time_map[i]

		if time < frame_time then
			local this_frame_time_diff = math.abs(frame_time - time)
			local prev_frame_time_diff = math.abs(frame_time - prev_frame_time)

			if this_frame_time_diff < prev_frame_time_diff then
				return i
			else
				return i - 1
			end
		end

		prev_frame_time = time
	end
end

function _apply_first_person_context(local_point, local_rotation, first_person, anchor_point_offset)
	local pos = first_person.position
	local rot = first_person.rotation

	if anchor_point_offset then
		local local_anchor_point_offset = Vector3(anchor_point_offset[1], anchor_point_offset[2], anchor_point_offset[3])
		local world_anchor_point_offset = Quaternion.rotate(rot, local_anchor_point_offset)
		pos = pos + world_anchor_point_offset
	end

	local world_offset = Quaternion.rotate(rot, local_point)
	local world_rotation = Quaternion.multiply(rot, local_rotation)

	return pos + world_offset, world_rotation
end

function _damage_window_frames(action_settings, frame_to_time_map, num_frames)
	local damage_window_start = action_settings.damage_window_start
	local damage_window_end = action_settings.damage_window_end
	local start_frame = _find_frame(damage_window_start, frame_to_time_map, num_frames)
	local end_frame = _find_frame(damage_window_end, frame_to_time_map, num_frames)

	return start_frame, end_frame
end

function _build_matrix(matrix_data)
	return Matrix4x4.from_elements(matrix_data[1], matrix_data[2], matrix_data[3], matrix_data[5], matrix_data[6], matrix_data[7], matrix_data[9], matrix_data[10], matrix_data[11], matrix_data[13], matrix_data[14], matrix_data[15])
end

return SweepSplineExported
