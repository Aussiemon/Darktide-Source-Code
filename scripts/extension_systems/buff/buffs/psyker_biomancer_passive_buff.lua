require("scripts/extension_systems/buff/buffs/buff")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local PROC_EVENTS_STRIDE = BuffSettings.proc_events_stride
local PsykerBiomancerPassiveBuff = class("PsykerBiomancerPassiveBuff", "ProcBuff")

PsykerBiomancerPassiveBuff.update_proc_events = function (self, t, proc_events, num_proc_events, portable_random, local_portable_random)
	local template = self._template
	local template_proc_events = template.proc_events

	for i = 1, num_proc_events * 2, PROC_EVENTS_STRIDE do
		local proc_event_name = proc_events[i]
		local params = proc_events[i + 1]
		local proc_chance = template_proc_events[proc_event_name]
		local is_local_proc_event = params.is_local_proc_event
		local template_data = self._template_data
		local template_context = self._template_context
		local portable_random_to_use = is_local_proc_event and local_portable_random or portable_random
		local random_value = portable_random_to_use:next_random()

		if proc_chance and random_value < proc_chance then
			local check_proc_func = template.check_proc_func

			if not check_proc_func or check_proc_func(params, template_data, template_context) then
				local proc_func = template.proc_func

				if proc_func then
					proc_func(params, template_data, template_context)
				end
			end

			local specific_proc_func = template.specific_proc_func

			if specific_proc_func and specific_proc_func[proc_event_name] then
				local func = specific_proc_func[proc_event_name]

				func(params, template_data, template_context)
			end
		end
	end
end

PsykerBiomancerPassiveBuff.visual_stack_count = function (self)
	local template_data = self._template_data
	local stack_count = template_data.specialization_resource_component.current_resource

	return stack_count
end

return PsykerBiomancerPassiveBuff
