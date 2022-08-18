local ForceTranslation = {}

ForceTranslation.start = function (locomotion_force_translation_component, locomotion_steering_component, force_translation, start_translation, start_time, duration)
	locomotion_force_translation_component.use_force_translation = true
	locomotion_steering_component.target_translation = force_translation
	locomotion_force_translation_component.start_translation = start_translation
	locomotion_force_translation_component.start_time = start_time
	locomotion_force_translation_component.end_time = start_time + duration
end

ForceTranslation.get_translation = function (locomotion_force_translation_component, locomotion_steering_component, t)
	local start_translation = locomotion_force_translation_component.start_translation
	local force_translation = locomotion_steering_component.target_translation
	local start_time = locomotion_force_translation_component.start_time
	local end_time = locomotion_force_translation_component.end_time
	local duration = end_time - start_time
	local time_spent = t - start_time
	local lerp_t = time_spent / duration
	local translation = Vector3.lerp(start_translation, force_translation, lerp_t)

	return translation, lerp_t
end

ForceTranslation.stop = function (locomotion_force_translation_component)
	locomotion_force_translation_component.use_force_translation = false
end

return ForceTranslation
