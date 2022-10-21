local Lunge = {
	find_speed_settings_index = function (time_in_lunge, start_index, lunge_speed_at_times)
		local speed_settings_index = #lunge_speed_at_times

		for index = start_index, #lunge_speed_at_times do
			if time_in_lunge <= lunge_speed_at_times[index].time_in_lunge then
				speed_settings_index = index - 1

				break
			end
		end

		return speed_settings_index
	end,
	find_current_lunge_speed = function (time_in_lunge, speed_settings_index, lunge_speed_at_times)
		local speed = nil
		local next_speed_setting_index = speed_settings_index + 1

		if next_speed_setting_index <= #lunge_speed_at_times then
			local time_between_settings = lunge_speed_at_times[next_speed_setting_index].time_in_lunge - lunge_speed_at_times[speed_settings_index].time_in_lunge
			local time_in_setting = time_in_lunge - lunge_speed_at_times[speed_settings_index].time_in_lunge
			local percentage_in_between = time_in_setting / time_between_settings
			speed = math.lerp(lunge_speed_at_times[speed_settings_index].speed, lunge_speed_at_times[next_speed_setting_index].speed, percentage_in_between)
		else
			speed = lunge_speed_at_times[speed_settings_index].speed
		end

		return speed
	end
}

Lunge.calculate_lunge_total_time = function (distance, lunge_speed_at_times)
	local time_step = GameParameters.fixed_time_step
	local hit_end = false
	local time_in_lunge = 0
	local distance_travelled = 0

	while not hit_end do
		time_in_lunge = time_in_lunge + time_step
		local start_point = 1
		local current_speed_setting_index = Lunge.find_speed_settings_index(time_in_lunge, start_point, lunge_speed_at_times)
		local speed = Lunge.find_current_lunge_speed(time_in_lunge, current_speed_setting_index, lunge_speed_at_times)
		distance_travelled = distance_travelled + speed * time_step

		if distance < distance_travelled then
			hit_end = true
		end
	end

	return time_in_lunge
end

Lunge.distance = function (lunge_template, has_target)
	local distance = has_target and lunge_template.has_target_distance or lunge_template.distance

	return distance
end

return Lunge
