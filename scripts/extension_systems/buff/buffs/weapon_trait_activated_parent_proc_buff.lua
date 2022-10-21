require("scripts/extension_systems/buff/buffs/proc_buff")

local BuffTemplates = require("scripts/settings/buff/buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local PROC_EVENTS_STRIDE = BuffSettings.proc_events_stride
local WeaponTraitActivatedParentProcBuff = class("WeaponTraitActivatedParentProcBuff", "WeaponTraitParentProcBuff")

WeaponTraitActivatedParentProcBuff.init = function (self, context, template, start_time, instance_id, ...)
	WeaponTraitActivatedParentProcBuff.super.init(self, context, template, start_time, instance_id, ...)

	self._active = false
end

WeaponTraitActivatedParentProcBuff.update_proc_events = function (self, t, proc_events, num_proc_events, portable_random, local_portable_random)
	local template = self._template
	local template_proc_events = template.proc_events
	local template_add_child_proc_events = template.add_child_proc_events
	local active = self._active
	local child_template = BuffTemplates[self._child_buff_template]

	for ii = 1, num_proc_events * PROC_EVENTS_STRIDE, PROC_EVENTS_STRIDE do
		local proc_event_name = proc_events[ii]
		local params = proc_events[ii + 1]
		local proc_chance = template_proc_events[proc_event_name]
		local is_local_proc_event = params.is_local_proc_event
		local template_data = self._template_data
		local template_context = self._template_context

		if proc_chance then
			local portable_random_to_use = is_local_proc_event and local_portable_random or portable_random
			local random_value = portable_random_to_use:next_random()

			if random_value < proc_chance then
				local check_proc_func = template.check_proc_func
				local is_check_ok = not check_proc_func or check_proc_func(params, template_data, template_context)
				local conditional_proc_func = template.conditional_proc_func
				local condition_ok = not conditional_proc_func or conditional_proc_func(template_data, template_context)

				if is_check_ok and condition_ok then
					local active_proc_func = template.active_proc_func[proc_event_name]

					if active_proc_func then
						active = active_proc_func(params, template_data, template_context)
					end

					if active then
						local num_wanted_stacks_to_add = template_add_child_proc_events[proc_event_name]

						if num_wanted_stacks_to_add then
							local max_child_stacks = child_template.max_stacks or 1
							local stacks_to_max = max_child_stacks - self._num_child_stacks
							local num_stacks_to_add = math.min(num_wanted_stacks_to_add, stacks_to_max)

							self:_add_child_buff_stack(t, num_stacks_to_add)
						end
					else
						self:_remove_child_buff_stack(self._num_child_stacks - 1)
					end
				end
			end
		end
	end

	self._active = active
end

return WeaponTraitActivatedParentProcBuff
