require("scripts/extension_systems/buff/buffs/buff")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local PROC_EVENTS_STRIDE = BuffSettings.proc_events_stride
local VeteranRangerStanceBuff = class("VeteranRangerStanceBuff", "Buff")

VeteranRangerStanceBuff.init = function (self, context, template, start_time, instance_id, ...)
	VeteranRangerStanceBuff.super.init(self, context, template, start_time, instance_id, ...)
end

VeteranRangerStanceBuff.update_proc_events = function (self, t, proc_events, num_proc_events, portable_random, local_portable_random)
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

VeteranRangerStanceBuff.duration = function (self)
	local template_data = self._template_data
	local new_duration = template_data.end_t - self._start_time

	return new_duration
end

VeteranRangerStanceBuff.duration_progress = function (self)
	local template_data = self._template_data
	local end_t = template_data.end_t
	local start_t = template_data.new_start_time
	local duration = end_t - start_t
	local t = Managers.time:time("gameplay")
	local duration_progress = math.abs(t - end_t) / duration

	return duration_progress
end

return VeteranRangerStanceBuff
