local BuffSettings = require("scripts/settings/buff/buff_settings")
local proc_events = BuffSettings.proc_events
local Stamina = {
	set_regeneration_paused = function (stamina_write_component, is_paused)
		if stamina_write_component.regeneration_paused ~= is_paused then
			stamina_write_component.regeneration_paused = is_paused
		end
	end,
	drain = function (unit, amount, t)
		local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")
		local stamina_write_component = unit_data_ext:write_component("stamina")
		local archetype = unit_data_ext:archetype()
		local archetype_stamina_template = archetype.stamina
		local current_value, max_value = Stamina.current_and_max_value(unit, stamina_write_component, archetype_stamina_template)
		local stamina_depleted = current_value <= amount
		local new_value = math.max(0, current_value - amount)
		local new_fraction = new_value / max_value
		stamina_write_component.last_drain_time = t
		stamina_write_component.current_fraction = new_fraction
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

		if buff_extension and stamina_depleted then
			local param_table = buff_extension:request_proc_event_param_table()

			buff_extension:add_proc_event(proc_events.on_stamina_depleted, param_table)
		end

		return max_value * new_fraction, stamina_depleted
	end,
	update = function (t, dt, stamina_write_component, archetype_stamina_template, unit, fixed_frame)
		if stamina_write_component.regeneration_paused then
			return
		end

		if t < stamina_write_component.last_drain_time + archetype_stamina_template.regeneration_delay then
			return
		end

		local current_value, max_value = Stamina.current_and_max_value(unit, stamina_write_component, archetype_stamina_template)
		local regeneration_per_second = archetype_stamina_template.regeneration_per_second
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
	end,
	current_and_max_value = function (unit, stamina_read_component, archetype_stamina_template)
		local max_value = archetype_stamina_template.base_stamina
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

		if buff_extension then
			local stat_buffs = buff_extension:stat_buffs()
			local stamina_modifier = stat_buffs.stamina_modifier or 0
			max_value = max_value + stamina_modifier
		end

		local current_fraction = stamina_read_component.current_fraction
		local current_value = max_value * current_fraction

		return current_value, max_value
	end
}

return Stamina
