local WarpCharge = require("scripts/utilities/warp_charge")
local shared_functions = {}

shared_functions.regain_toughness_proc_func = function (params, template_data, template_context)
	local toughness_extension = template_data.toughness_extension

	if not toughness_extension then
		local unit = template_context.unit
		toughness_extension = ScriptUnit.extension(unit, "toughness_system")
		template_data.toughness_extension = toughness_extension
	end

	local buff_template = template_context.template
	local override_data = template_context.template_override_data
	local multiplier = template_data.toughness_regain_multiplier or 1
	local fixed_percentage = (override_data.toughness_fixed_percentage or buff_template.toughness_fixed_percentage) * multiplier
	local ignore_stat_buffs = true

	toughness_extension:recover_percentage_toughness(fixed_percentage, ignore_stat_buffs)
end

shared_functions.vent_warp_charge_start_func = function (template_data, template_context)
	local unit = template_context.unit
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local warp_charge_component = unit_data_extension:write_component("warp_charge")
	template_data.warp_charge_component = warp_charge_component
	template_data.counter = 0
end

shared_functions.vent_warp_charge_proc_func = function (params, template_data, template_context)
	template_data.proc = true
end

shared_functions.vent_warp_charge_update_func = function (template_data, template_context, dt, t)
	if template_data.proc then
		local warp_charge_component = template_data.warp_charge_component
		local buff_template = template_context.template
		local override_data = template_context.template_override_data
		local remove_percentage = override_data.vent_percentage or buff_template.vent_percentage

		WarpCharge.decrease_immediate(remove_percentage, warp_charge_component, template_context.unit)

		template_data.proc = nil
	end
end

return shared_functions
