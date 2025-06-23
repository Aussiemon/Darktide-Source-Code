-- chunkname: @scripts/utilities/attack/stamina.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local proc_events = BuffSettings.proc_events
local Stamina = {}

Stamina.set_regeneration_paused = function (stamina_write_component, is_paused)
	if stamina_write_component.regeneration_paused ~= is_paused then
		stamina_write_component.regeneration_paused = is_paused
	end
end

Stamina.drain = function (unit, amount, t)
	local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")
	local stamina_write_component = unit_data_ext:write_component("stamina")
	local archetype = unit_data_ext:archetype()
	local base_stamina_template = archetype.stamina
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	local stat_buffs = buff_extension and buff_extension:stat_buffs()
	local stamina_cost_multiplier = stat_buffs and stat_buffs.stamina_cost_multiplier or 1

	amount = amount * stamina_cost_multiplier

	local current_value, max_value = Stamina.current_and_max_value(unit, stamina_write_component, base_stamina_template)
	local stamina_depleted = current_value <= amount
	local new_value = math.clamp(math.max(0, current_value - amount), 0, max_value)
	local new_fraction = new_value / max_value

	stamina_write_component.last_drain_time = t
	stamina_write_component.current_fraction = new_fraction

	if buff_extension and stamina_depleted then
		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			buff_extension:add_proc_event(proc_events.on_stamina_depleted, param_table)
		end
	end

	return max_value * new_fraction, stamina_depleted
end

Stamina.drain_pecentage = function (unit, amount_percentage, t)
	local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")
	local stamina_write_component = unit_data_ext:write_component("stamina")
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	local stat_buffs = buff_extension and buff_extension:stat_buffs()
	local stamina_cost_multiplier = stat_buffs and stat_buffs.stamina_cost_multiplier or 1

	amount_percentage = amount_percentage * stamina_cost_multiplier

	local current_fraction = stamina_write_component.current_fraction
	local stamina_depleted = current_fraction <= amount_percentage
	local new_fraction = math.clamp01(math.max(0, current_fraction - amount_percentage))

	stamina_write_component.last_drain_time = t
	stamina_write_component.current_fraction = new_fraction

	if buff_extension and stamina_depleted then
		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			buff_extension:add_proc_event(proc_events.on_stamina_depleted, param_table)
		end
	end

	return new_fraction, stamina_depleted
end

Stamina.drain_pecentage_of_base_stamina = function (unit, amount_percentage, t)
	local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")
	local archetype = unit_data_ext:archetype()
	local base_stamina_template = archetype.stamina
	local weapon_extension = ScriptUnit.has_extension(unit, "weapon_system")
	local weapon_modifier = 0

	if weapon_extension then
		local weapon_stamina_template = weapon_extension:stamina_template()

		weapon_modifier = weapon_stamina_template and weapon_stamina_template.stamina_modifier or 0
	end

	local base_max_value = base_stamina_template.base_stamina + weapon_modifier
	local ammount = base_max_value * amount_percentage

	return Stamina.drain(unit, ammount, t)
end

Stamina.add_stamina = function (unit, amount)
	local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")
	local stamina_write_component = unit_data_ext:write_component("stamina")
	local archetype = unit_data_ext:archetype()
	local base_stamina_template = archetype.stamina
	local current_value, max_value = Stamina.current_and_max_value(unit, stamina_write_component, base_stamina_template)
	local new_value = math.clamp(math.max(0, current_value + amount), 0, max_value)
	local new_fraction = new_value / max_value

	stamina_write_component.current_fraction = new_fraction
end

Stamina.add_stamina_percent = function (unit, percent_amount)
	local unit_data_ext = ScriptUnit.has_extension(unit, "unit_data_system")

	if not unit_data_ext then
		return
	end

	local stamina_write_component = unit_data_ext:write_component("stamina")
	local archetype = unit_data_ext:archetype()
	local base_stamina_template = archetype.stamina
	local current_value, max_value = Stamina.current_and_max_value(unit, stamina_write_component, base_stamina_template)
	local amount = percent_amount * max_value
	local new_value = math.clamp(math.max(0, current_value + amount), 0, max_value)
	local new_fraction = new_value / max_value

	stamina_write_component.current_fraction = new_fraction
end

Stamina.update = function (t, dt, stamina_write_component, archetype_stamina_template, unit, fixed_frame)
	if stamina_write_component.regeneration_paused then
		return
	end

	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	local stat_buffs = buff_extension and buff_extension:stat_buffs()
	local regen_stat = stat_buffs and stat_buffs.stamina_regeneration_delay or 0
	local stamina_regen_delay = archetype_stamina_template.regeneration_delay + regen_stat

	if t < stamina_write_component.last_drain_time + stamina_regen_delay then
		return
	end

	local current_value, max_value = Stamina.current_and_max_value(unit, stamina_write_component, archetype_stamina_template)
	local regeneration_per_second = archetype_stamina_template.regeneration_per_second

	if stat_buffs then
		local stamina_regeneration_modifier = stat_buffs.stamina_regeneration_modifier
		local stamina_regeneration_multiplier = stat_buffs.stamina_regeneration_multiplier

		regeneration_per_second = regeneration_per_second * stamina_regeneration_modifier * stamina_regeneration_multiplier
	end

	local new_value = math.min(current_value + regeneration_per_second * dt, max_value)
	local new_fraction = new_value / max_value

	stamina_write_component.current_fraction = new_fraction
end

Stamina.current_and_max_value = function (unit, stamina_read_component, archetype_stamina_template)
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	local weapon_extension = ScriptUnit.has_extension(unit, "weapon_system")
	local weapon_modifier = 0

	if weapon_extension then
		local weapon_stamina_template = weapon_extension:stamina_template()

		weapon_modifier = weapon_stamina_template and weapon_stamina_template.stamina_modifier or 0
	end

	local max_value = archetype_stamina_template.base_stamina + weapon_modifier

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
