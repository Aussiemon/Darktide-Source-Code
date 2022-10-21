local SweepStickyness = {}

SweepStickyness.is_sticking_to_unit = function (action_sweep_component)
	local is_sticky = action_sweep_component.is_sticky

	if not is_sticky then
		return false
	end

	local stick_to_unit = action_sweep_component.sweep_aborted_unit

	if not ALIVE[stick_to_unit] then
		return false
	end

	local actor_index = action_sweep_component.sweep_aborted_actor_index
	local stick_to_actor = actor_index and Unit.actor(stick_to_unit, actor_index)

	return stick_to_actor ~= nil
end

SweepStickyness.stick_to_position = function (action_sweep_component)
	local stick_to_unit = action_sweep_component.sweep_aborted_unit

	if not ALIVE[stick_to_unit] then
		return nil
	end

	local actor_index = action_sweep_component.sweep_aborted_actor_index
	local stick_to_actor = actor_index and Unit.actor(stick_to_unit, actor_index)

	if not stick_to_actor then
		return nil
	end

	return Unit.world_position(stick_to_unit, Actor.node(stick_to_actor))
end

SweepStickyness.num_damage_instances_this_frame = function (hit_stickyness_settings, start_t, t)
	local num_damage_instances = 0
	local damage = hit_stickyness_settings.damage

	if not damage then
		return num_damage_instances, false
	end

	local fixed_time_step = GameParameters.fixed_time_step
	local duration = hit_stickyness_settings.duration
	local end_t = start_t + duration
	local next_t = math.min(t + fixed_time_step, end_t)
	local damage_instances = damage.instances or 1
	local time_between_instances = 0.9 * duration / damage_instances
	local damage_timing_override = hit_stickyness_settings.damage_timing_override

	if damage_timing_override and damage_instances == 1 then
		time_between_instances = damage_timing_override
	end

	local last_instance = false
	local first_instance = false
	local interval_start = t - start_t
	local interval_end = next_t - start_t

	for i = 1, damage_instances do
		local damage_instance_t = time_between_instances * i

		if interval_start < damage_instance_t and damage_instance_t <= interval_end then
			num_damage_instances = num_damage_instances + 1

			if i == damage_instances then
				last_instance = true
			end
		elseif interval_end < damage_instance_t then
			break
		end

		if i == 1 and start_t < t and t < start_t + time_between_instances then
			first_instance = true
		end
	end

	return num_damage_instances, last_instance, first_instance
end

SweepStickyness.unit_which_aborted_sweep = function (action_sweep_component)
	local unit = action_sweep_component.sweep_aborted_unit
	local actor_index = ALIVE[unit] and action_sweep_component.sweep_aborted_actor_index

	if not unit or not actor_index then
		return nil, nil
	end

	local actor = Unit.actor(unit, actor_index)

	return unit, actor
end

return SweepStickyness
