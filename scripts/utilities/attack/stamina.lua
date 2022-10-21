local BuffSettings = require("scripts/settings/buff/buff_settings")
local proc_events = BuffSettings.proc_events
local Stamina = {
	set_regeneration_paused = function (stamina_write_component, is_paused)
		if stamina_write_component.regeneration_paused ~= is_paused then
			stamina_write_component.regeneration_paused = is_paused
		end
	end
}

Stamina.drain = function (unit, amount, t)
	local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")
	local stamina_write_component = unit_data_ext:write_component("stamina")
	local specialization = unit_data_ext:specialization()
	local specialization_stamina_template = specialization.stamina
	local current_value, max_value = Stamina.current_and_max_value(unit, stamina_write_component, specialization_stamina_template)
	local stamina_depleted = current_value <= amount
	local new_value = math.clamp(math.max(0, current_value - amount), 0, max_value)
	local new_fraction = new_value / max_value
	stamina_write_component.last_drain_time = t
	stamina_write_component.current_fraction = new_fraction
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if buff_extension and stamina_depleted then
		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			buff_extension:add_proc_event(proc_events.on_stamina_depleted, param_table)
		end
	end

	return max_value * new_fraction, stamina_depleted
end

Stamina.add_stamina = function (unit, amount)
	local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")
	local stamina_write_component = unit_data_ext:write_component("stamina")
	local specialization = unit_data_ext:specialization()
	local specialization_stamina_template = specialization.stamina
	local current_value, max_value = Stamina.current_and_max_value(unit, stamina_write_component, specialization_stamina_template)
	local new_value = math.clamp(math.max(0, current_value + amount), 0, max_value)
	local new_fraction = new_value / max_value
	stamina_write_component.current_fraction = new_fraction
end

Stamina.add_stamina_percent = function (unit, percent_amount)
	local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")
	local stamina_write_component = unit_data_ext:write_component("stamina")
	local specialization = unit_data_ext:specialization()
	local specialization_stamina_template = specialization.stamina
	local current_value, max_value = Stamina.current_and_max_value(unit, stamina_write_component, specialization_stamina_template)
	local amount = math.ceil(percent_amount * max_value)
	local new_value = math.clamp(math.max(0, current_value + amount), 0, max_value)
	local new_fraction = new_value / max_value
	stamina_write_component.current_fraction = new_fraction
end

Stamina.update = function (t, dt, stamina_write_component, specialization_stamina_template, unit, fixed_frame)
	if stamina_write_component.regeneration_paused then
		return
	end

	if t < stamina_write_component.last_drain_time + specialization_stamina_template.regeneration_delay then
		return
	end

	local current_value, max_value = Stamina.current_and_max_value(unit, stamina_write_component, specialization_stamina_template)
	local regeneration_per_second = specialization_stamina_template.regeneration_per_second
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if buff_extension then
		local stat_buffs = buff_extension:stat_buffs()
		local stamina_regeneration_modifier = stat_buffs.stamina_regeneration_modifier
		local stamina_regeneration_multiplier = stat_buffs.stamina_regeneration_multiplier
		regeneration_per_second = regeneration_per_second * stamina_regeneration_modifier * stamina_regeneration_multiplier
	end

	local new_value = math.min(current_value + regeneration_per_second * dt, max_value)
	local new_fraction = new_value / max_value
	stamina_write_component.current_fraction = new_fraction
end

Stamina.current_and_max_value = function (unit, stamina_read_component, specialization_stamina_template)
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	local weapon_extension = ScriptUnit.has_extension(unit, "weapon_system")
	local weapon_modifier = 0

	if weapon_extension then
		local weapon_stamina_template = weapon_extension:stamina_template()
		weapon_modifier = weapon_stamina_template and weapon_stamina_template.stamina_modifier or 0
	end

	local max_value = specialization_stamina_template.base_stamina + weapon_modifier

	if buff_extension then
		local stat_buffs = buff_extension:stat_buffs()
		local stamina_modifier = stat_buffs.stamina_modifier or 0
		max_value = max_value + stamina_modifier
	end

	local current_fraction = stamina_read_component.current_fraction
	local current_value = max_value * current_fraction

	return current_value, max_value
end

return Stamina
