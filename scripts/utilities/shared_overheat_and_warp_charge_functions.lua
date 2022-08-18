local SharedOverheatAndWarpChargeFunctions = {
	add_immediate = function (charge_level, use_charge, add_percentage, current_percentage, prevent_explosion)
		fassert(not use_charge or (use_charge and charge_level), "[SharedOverheatAndWarpChargeFunctions][add_immediate] use_charge parameter specified without a charge_level!")

		local added_percentage = (use_charge and add_percentage * charge_level) or add_percentage
		local new_percentage = current_percentage + added_percentage
		local clamped_percentage = math.clamp(new_percentage, 0, 1)
		local new_state = nil

		if not prevent_explosion and current_percentage >= 1 and new_percentage > 1 then
			new_state = "exploding"
		end

		return clamped_percentage, new_state
	end,
	remove_immediate = function (remove_percentage, current_percentage)
		local new_percentage = current_percentage - remove_percentage
		local clamped_percentage = math.clamp(new_percentage, 0, 1)
		local new_state = "idle"

		return clamped_percentage, new_state
	end,
	increase_over_time = function (dt, charge_level, add_percentage, extra_add_percentage, duration, current_percentage)
		local total_percentage, charge_duration = nil

		if charge_level < 1 then
			total_percentage = add_percentage
			charge_duration = duration
		else
			total_percentage = extra_add_percentage
			charge_duration = 1
		end

		local increase = total_percentage / charge_duration * dt
		local new_percentage = math.clamp(current_percentage + increase, 0, 1)

		return new_percentage
	end,
	update = function (dt, current_percentage, auto_vent_duration, low_threshold, high_threshold, critical_threshold, low_threshold_decay_rate_modifier, high_threshold_decay_rate_modifier, critical_threshold_decay_rate_modifier, default_threshold_decay_rate_modifier)
		local rate_modifier = nil
		rate_modifier = (low_threshold < current_percentage and current_percentage <= high_threshold and low_threshold_decay_rate_modifier) or (high_threshold < current_percentage and current_percentage <= critical_threshold and high_threshold_decay_rate_modifier) or (critical_threshold < current_percentage and critical_threshold_decay_rate_modifier) or default_threshold_decay_rate_modifier or 1
		local percentage_decrease = 1 / auto_vent_duration * dt * rate_modifier
		local new_percentage = math.clamp(current_percentage - percentage_decrease, 0, 1)

		return new_percentage
	end,
	update_venting = function (t, current_percentage, starting_percentage, vent_interval, vent_duration, multiplier)
		local next_remove_t = t + vent_interval
		multiplier = multiplier or 1
		local heat_decrease = starting_percentage / vent_duration * vent_interval * multiplier
		local new_percentage = math.clamp(current_percentage - heat_decrease, 0, 1)

		return next_remove_t, new_percentage
	end
}

return SharedOverheatAndWarpChargeFunctions
