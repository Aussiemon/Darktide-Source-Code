require("scripts/extension_systems/buff/buffs/proc_buff")

local BuffTemplates = require("scripts/settings/buff/buff_templates")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local FixedFrame = require("scripts/utilities/fixed_frame")
local WeaponTraitParentProcBuff = class("WeaponTraitParentProcBuff", "ProcBuff")

WeaponTraitParentProcBuff.init = function (self, context, template, start_time, ...)
	WeaponTraitParentProcBuff.super.init(self, context, template, start_time, ...)

	local template_context = self._template_context
	local is_server = template_context.is_server
	self._is_server = is_server

	if is_server then
		local item_slot_name = template_context.item_slot_name
		self._item_slot_name = item_slot_name
		local child_buff_template = template.child_buff_template
		self._child_buff_template = child_buff_template
		local child_template = BuffTemplates[child_buff_template]
		self._buff_extension = template_context.buff_extension
		local max_child_stacks = (self._template_override_data.max_stacks or child_template.max_stacks or 1 or 1) + math.abs(child_template.stack_offset or 0)
		self._num_child_stacks = 0
		self._child_buff_indicies = Script.new_array(max_child_stacks)
		self._remove_child_stack_start_t = 0
		self._remove_child_stack_duration = 0

		self:_add_child_buff_stack(start_time, 1)
	end
end

WeaponTraitParentProcBuff.destroy = function (self)
	if self._is_server then
		local buff_extension = self._buff_extension
		local num_child_stacks = self._num_child_stacks
		local child_buff_indicies = self._child_buff_indicies

		for i = num_child_stacks, 1, -1 do
			buff_extension:remove_externally_controlled_buff(child_buff_indicies[i])
		end
	end

	WeaponTraitParentProcBuff.super.destroy(self)
end

WeaponTraitParentProcBuff.update_proc_events = function (self, t, proc_events, num_proc_events, portable_random, local_portable_random)
	local activated_proc, procced_proc_events = WeaponTraitParentProcBuff.super.update_proc_events(self, t, proc_events, num_proc_events, portable_random, local_portable_random)

	if activated_proc and self._is_server then
		local template = self._template
		local child_template = BuffTemplates[self._child_buff_template]

		for add_child_event, num_wanted_stacks_to_add_per_proc in pairs(template.add_child_proc_events) do
			local number_of_times_proced = procced_proc_events[add_child_event]

			if number_of_times_proced and number_of_times_proced > 0 then
				local max_child_stacks = (self._template_override_data.max_stacks or child_template.max_stacks or 1 or 1) + math.abs(child_template.stack_offset or 0)
				local stacks_to_max = max_child_stacks - self._num_child_stacks
				local num_wanted_stacks_to_add = num_wanted_stacks_to_add_per_proc * number_of_times_proced
				local num_stacks_to_add = math.min(num_wanted_stacks_to_add, stacks_to_max)

				self:_add_child_buff_stack(t, num_stacks_to_add)
			end
		end

		local clear_child_stacks_proc_events = template.clear_child_stacks_proc_events

		if clear_child_stacks_proc_events then
			for clear_child_event, _ in pairs(template.clear_child_stacks_proc_events) do
				if procced_proc_events[clear_child_event] then
					self:_remove_child_buff_stack(t, self._num_child_stacks - 1)

					break
				end
			end
		end
	end

	return activated_proc, procced_proc_events
end

WeaponTraitParentProcBuff.update = function (self, dt, t, ...)
	WeaponTraitParentProcBuff.super.update(self, dt, t, ...)

	if self._is_server then
		local template = self._template
		local template_overrides = self._template_override_data
		local num_child_stacks = self._num_child_stacks
		local start_t = self._remove_child_stack_start_t

		if num_child_stacks > 1 and start_t ~= 0 then
			local duration = self._remove_child_stack_duration
			local remove_t = start_t + duration

			if t > remove_t then
				local leftover_time = t - remove_t
				local leftover_through_child_duration = leftover_time / duration
				local stacks_to_remove = template.stacks_to_remove or 1
				local num_stacks_to_remove = math.min(math.ceil(leftover_through_child_duration) * stacks_to_remove, num_child_stacks - 1)

				self:_remove_child_buff_stack(t, num_stacks_to_remove)

				local child_duration = template_overrides.child_duration or template.child_duration
				local child_duration_after_remove = template_overrides.child_duration_after_remove or template.child_duration_after_remove or child_duration

				if child_duration_after_remove then
					self._remove_child_stack_start_t = t
					self._remove_child_stack_duration = child_duration_after_remove
				else
					self._remove_child_stack_start_t = 0
					self._remove_child_stack_duration = 0
				end
			end
		end

		local reset_update_func = template.reset_update_func

		if reset_update_func and reset_update_func(self._template_data, self._template_context) then
			self:_remove_child_buff_stack(t, self._num_child_stacks - 1)
		end
	end
end

WeaponTraitParentProcBuff._add_child_buff_stack = function (self, t, num_children_to_add)
	local buff_extension = self._buff_extension
	local child_buff_template = self._child_buff_template
	local item_slot_name = self._item_slot_name
	local template = self._template
	local template_name = template.name
	local template_overrides = self._template_override_data
	local num_child_stacks = self._num_child_stacks
	local child_buff_indicies = self._child_buff_indicies

	for i = 1, num_children_to_add do
		num_child_stacks = num_child_stacks + 1
		local _, index = buff_extension:add_externally_controlled_buff(child_buff_template, t, "item_slot_name", item_slot_name, "parent_buff_template", template_name)
		child_buff_indicies[num_child_stacks] = index
	end

	self._num_child_stacks = num_child_stacks
	local child_duration = template_overrides.child_duration or template.child_duration

	if child_duration then
		self._remove_child_stack_start_t = t
		self._remove_child_stack_duration = child_duration
	end

	self:set_start_time(t)

	self._need_to_sync_start_time = true
end

WeaponTraitParentProcBuff._remove_child_buff_stack = function (self, t, num_children_to_remove)
	local buff_extension = self._buff_extension
	local child_buff_indicies = self._child_buff_indicies
	local num_child_stacks = self._num_child_stacks

	for i = 1, num_children_to_remove do
		local buff_index = child_buff_indicies[num_child_stacks]

		buff_extension:remove_externally_controlled_buff(buff_index)

		num_child_stacks = num_child_stacks - 1
	end

	self._num_child_stacks = num_child_stacks

	self:set_start_time(t)

	self._need_to_sync_start_time = true
end

WeaponTraitParentProcBuff.duration_progress = function (self)
	local template = self._template
	local template_overrides = self._template_override_data
	local child_duration = template_overrides.child_duration or template.child_duration

	if not child_duration then
		return 0
	end

	local active_start_time = self._start_time
	local t = FixedFrame.get_latest_fixed_time()
	local time_since_proc = t - active_start_time
	local duration_progress = 1 - time_since_proc / child_duration
	duration_progress = duration_progress > 0 and duration_progress or 0.01

	return duration_progress
end

WeaponTraitParentProcBuff.has_hud = function (self)
	return WeaponTraitParentProcBuff.super.super.has_hud(self)
end

WeaponTraitParentProcBuff.visual_stack_count = function (self)
	local template_context = self._template_context
	local buff_extension = template_context.buff_extension
	local template = template_context.template
	local child_template_name = template.child_buff_template
	local number_of_buffs = child_template_name and buff_extension:current_stacks(child_template_name) or 1

	return number_of_buffs - 1
end

WeaponTraitParentProcBuff._show_in_hud = function (self)
	local template = self._template
	local template_context = self._template_context
	local template_data = self._template_data
	local show_in_hud_if_slot_is_wielded = template.show_in_hud_if_slot_is_wielded

	if show_in_hud_if_slot_is_wielded and not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
		return false
	end

	local visual_stack_count = self:visual_stack_count()
	local show_in_hud = visual_stack_count > 0
	local is_hud_active = self:_is_hud_active()

	return show_in_hud and is_hud_active
end

WeaponTraitParentProcBuff._hud_show_stack_count = function (self)
	return true
end

return WeaponTraitParentProcBuff
