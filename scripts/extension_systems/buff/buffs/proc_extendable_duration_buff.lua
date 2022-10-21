require("scripts/extension_systems/buff/buffs/buff")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local PROC_EVENTS_STRIDE = BuffSettings.proc_events_stride
local ProcExtendableDurationBuff = class("ProcExtendableDurationBuff", "Buff")

ProcExtendableDurationBuff.init = function (self, context, template, start_time, instance_id, ...)
	ProcExtendableDurationBuff.super.init(self, context, template, start_time, instance_id, ...)
end

ProcExtendableDurationBuff.update_proc_events = function (self, t, proc_events, num_proc_events, portable_random, local_portable_random)
	local template = self._template
	local template_proc_events = template.proc_events

	for i = 1, num_proc_events, PROC_EVENTS_STRIDE do
		local proc_event_name = proc_events[i]
		local params = proc_events[i + 1]
		local proc_chance = template_proc_events[proc_event_name]
		local is_local_proc_event = params.is_local_proc_event

		if proc_chance then
			local portable_random_to_use = is_local_proc_event and local_portable_random or portable_random
			local random_value = portable_random_to_use:next_random()

			if random_value < proc_chance then
				local check_proc_func = template.check_proc_func

				if not check_proc_func or check_proc_func(params) then
					local buff_component = self._buff_component

					if buff_component then
						local component_keys = self._component_keys
						local proc_count_key = component_keys.proc_count_key
						local max_proc_stacks = template.max_proc_stacks
						local proc_count = buff_component[proc_count_key] + 1
						local new_proc_count = math.clamp(proc_count, 0, max_proc_stacks)
						buff_component[proc_count_key] = new_proc_count
					end
				end

				local specific_proc_func = template.specific_proc_func

				if specific_proc_func and specific_proc_func[proc_event_name] then
					local template_data = self._template_data
					local template_context = self._template_context
					local func = specific_proc_func[proc_event_name]

					func(params, template_data, template_context)
				end
			end
		end
	end
end

ProcExtendableDurationBuff.duration = function (self)
	local template = self._template
	local base_duration = template.duration
	local duration_per_proc_stack = template.duration_per_proc_stack
	local buff_component = self._buff_component
	local component_keys = self._component_keys
	local proc_count_key = component_keys.proc_count_key
	local proc_count = buff_component[proc_count_key]

	return base_duration + duration_per_proc_stack * proc_count
end

return ProcExtendableDurationBuff
