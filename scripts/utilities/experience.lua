local Experience = {}

Experience.required_experience_for_level = function (experience_settings, level)
	assert(level >= 0, "[Experience] - Trying to get required experience for a too low level")
	assert(level <= experience_settings.max_level, "[Experience] - Trying to get required experience for a too high level")

	local max_level = experience_settings.max_level
	local experience_per_level_array = experience_settings.experience_per_level_array
	local total_required_experience = 0

	for i = 1, max_level do
		total_required_experience = total_required_experience + experience_per_level_array[i]

		if i == level then
			return experience_per_level_array[i], total_required_experience
		end
	end

	return 0
end

Experience.get_level = function (experience_settings, experience)
	experience = experience or 0

	assert(experience >= 0, "[Experience] - Trying to get level with a negative experience value.")

	local exp_total = 0
	local level = 0
	local progress = 0
	local experience_into_level = 0
	local max_level = experience_settings.max_level
	local max_level_experience = experience_settings.max_level_experience
	local experience_per_level_array = experience_settings.experience_per_level_array

	if max_level_experience <= experience then
		return max_level, progress, experience_into_level
	end

	for i = 1, max_level do
		local previous_exp_total = exp_total
		exp_total = exp_total + experience_per_level_array[i]

		if experience == exp_total then
			level = i
			experience_into_level = 0
			progress = 0

			break
		elseif experience < exp_total then
			level = i - 1
			experience_into_level = experience - previous_exp_total
			progress = experience_into_level / experience_per_level_array[i]

			break
		end
	end

	return level, progress, experience_into_level
end

return Experience
