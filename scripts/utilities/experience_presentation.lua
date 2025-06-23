-- chunkname: @scripts/utilities/experience_presentation.lua

local Experience = require("scripts/utilities/experience")
local ExperiencePresentation = {}

ExperiencePresentation.get_experience_animation_progress = function (progress)
	return math.easeOutCubic(progress)
end

ExperiencePresentation.get_experience_reverse_animation_progress = function (progress)
	return 1 - (1 - progress)^0.3333333333333333
end

ExperiencePresentation.start_presentation = function (data)
	data.presentation_started = true
end

ExperiencePresentation.presentation_started = function (data)
	return data and data.presentation_started
end

ExperiencePresentation.presentation_completed = function (data)
	return data and data.presentation_completed
end

ExperiencePresentation.update_presentation = function (data, dt, t)
	if data.presentation_paused_timer then
		data.presentation_paused_timer = data.presentation_paused_timer - dt

		if data.presentation_paused_timer <= 0 then
			data.presentation_paused_timer = nil
		end

		return
	end

	local duration = data.duration
	local time = data.time
	local starting_experience = data.starting_experience

	data.time = math.min(time + dt, duration)

	local time_progress = time / duration

	data.time_progress = time_progress

	local progress = ExperiencePresentation.get_experience_animation_progress(time_progress)
	local total_bar_progress = data.total_bar_progress
	local start_bar_progress = data.start_bar_progress
	local current_total_bar_progress = total_bar_progress * progress
	local presentation_progress = start_bar_progress + current_total_bar_progress
	local total_anim_progress = math.ease_pulse(ExperiencePresentation.get_experience_reverse_animation_progress(progress))
	local start_level = data.start_level
	local current_level = start_level + math.floor(presentation_progress)
	local previous_level = data.current_level

	data.current_level = current_level

	local level_up = false

	if current_level ~= previous_level then
		level_up = true
	end

	local experience_settings = data.experience_settings
	local next_level = math.min(current_level + 1, experience_settings.max_level)
	local current_level_presentation_progress = presentation_progress / 1 - (current_level - start_level)
	local bar_presentation_progress = level_up and 0 or current_level_presentation_progress
	local current_level_experience_needed, current_level_total_experience_needed = Experience.required_experience_for_level(experience_settings, current_level)
	local next_level_experience_needed, next_level_total_experience_needed = Experience.required_experience_for_level(experience_settings, next_level)
	local presentation_experience = math.floor(current_level_total_experience_needed + next_level_experience_needed * bar_presentation_progress - starting_experience)

	if level_up and not data.presentation_paused_timer then
		data.presentation_paused_timer = data.level_up_delay
	end

	if time_progress == 1 then
		data.presentation_completed = true
	end

	return current_level, next_level, bar_presentation_progress, presentation_experience, level_up, total_anim_progress
end

ExperiencePresentation.skip_to_next_timestamp = function (data)
	local experience_settings = data.experience_settings
	local start_level = data.start_level
	local experience_gained = data.experience_gained
	local time_progress = data.time_progress
	local progress = ExperiencePresentation.get_experience_animation_progress(time_progress)
	local starting_experience = data.starting_experience
	local total_bar_progress = data.total_bar_progress
	local start_bar_progress = data.start_bar_progress
	local current_total_bar_progress = total_bar_progress * progress
	local duration = data.duration
	local current_level, current_level_progress = Experience.get_level(experience_settings, starting_experience + experience_gained * progress)

	if data.presentation_paused_timer then
		data.presentation_paused_timer = nil
	elseif total_bar_progress - current_total_bar_progress >= 1 - current_level_progress then
		local level_difference = math.max(current_level - start_level, 0)
		local progress_passed = level_difference + current_level_progress - start_bar_progress + (1 - current_level_progress)
		local relative_progress_left = ExperiencePresentation.get_experience_reverse_animation_progress(math.min(progress_passed / total_bar_progress, 1))
		local new_time = relative_progress_left * duration

		data.time = new_time
	else
		data.time = duration
	end
end

ExperiencePresentation.setup_presentation_data = function (experience_settings, starting_experience, experience_gained, presentation_duration, level_up_delay)
	level_up_delay = level_up_delay or 0

	local max_level_experience = experience_settings.max_level_experience

	experience_gained = math.min(experience_gained, max_level_experience - starting_experience)

	local start_level, start_bar_progress = Experience.get_level(experience_settings, starting_experience)
	local end_level, end_bar_progress = Experience.get_level(experience_settings, starting_experience + experience_gained)
	local total_bar_progress = end_level - start_level + end_bar_progress - start_bar_progress
	local times_leveling_up = end_level - start_level
	local total_level_up_delay = times_leveling_up * level_up_delay
	local duration_per_level = (presentation_duration - total_level_up_delay) / (times_leveling_up + 1)
	local spare_time = presentation_duration - total_level_up_delay - duration_per_level * total_bar_progress

	return {
		time = 0,
		time_progress = 0,
		presentation_completed = false,
		presentation_started = false,
		experience_settings = experience_settings,
		start_level = start_level,
		end_level = end_level,
		current_level = start_level,
		start_bar_progress = start_bar_progress,
		end_bar_progress = end_bar_progress,
		total_bar_progress = total_bar_progress,
		experience_gained = experience_gained,
		starting_experience = starting_experience,
		duration = presentation_duration,
		spare_time = spare_time,
		level_up_delay = level_up_delay
	}
end

return ExperiencePresentation
