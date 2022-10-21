local RecoilTemplate = {}
local lerp = math.lerp or MathUtils.lerp

RecoilTemplate.generate_offset_range = function (num_shots, offset_pitch, offset_yaw, lerp_distance, scale_values)
	local offset_range = {}
	local scale_values_pitch = scale_values.pitch
	local scale_values_yaw = scale_values.yaw

	for ii = 1, num_shots do
		local this_pitch = offset_pitch * scale_values_pitch[ii]
		local this_yaw = offset_yaw * scale_values_yaw[ii]
		offset_range[ii] = {
			pitch = {
				lerp_basic = this_pitch * (1 + lerp_distance),
				lerp_perfect = this_pitch * (1 - lerp_distance)
			},
			yaw = {
				lerp_basic = this_yaw * (1 + lerp_distance),
				lerp_perfect = this_yaw * (1 - lerp_distance)
			}
		}
	end

	return offset_range
end

RecoilTemplate.create_scale = function (scale_values)
	local scale_list = {
		pitch = {},
		yaw = {}
	}
	local current_index = 0
	local current_pitch = 0
	local current_yaw = 0

	for ii = 1, #scale_values do
		local scale_value = scale_values[ii]
		local index = scale_value[1]
		local values = scale_value[2]
		local steps = index - current_index

		for jj = 1, steps do
			current_index = current_index + 1
			local this_pitch = lerp(current_pitch, values[1], jj / steps)
			local this_yaw = lerp(current_yaw, values[2], jj / steps)
			scale_list.pitch[current_index] = this_pitch
			scale_list.yaw[current_index] = this_yaw
		end

		current_pitch = values[1]
		current_yaw = values[2]
	end

	return scale_list
end

RecoilTemplate.AIM_ASSIST_MULTIPLIER_FUNCTIONS = {
	flat_reduction_per_shot = function (self, recoil_control_component, recoil_component)
		return math.max(1 - self.reduction_per_shot * recoil_control_component.num_shots, 0)
	end,
	unmodified_inverted_unsteadiness = function (self, recoil_control_component, recoil_component)
		return 1 - recoil_component.unsteadiness
	end
}

return RecoilTemplate
