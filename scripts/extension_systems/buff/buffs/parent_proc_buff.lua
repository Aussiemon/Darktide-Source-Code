require("scripts/extension_systems/buff/buffs/proc_buff")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local buff_proc_events = BuffSettings.proc_events
local ParentProcBuff = class("ParentProcBuff", "ProcBuff")

ParentProcBuff.init = function (self, context, template, start_time, instance_id, ...)
	ParentProcBuff.super.init(self, context, template, start_time, instance_id, ...)

	local template_context = self._template_context
	local is_server = template_context.is_server
	self._is_server = is_server
	self._buff_extension = template_context.buff_extension
	local unit_data_extension = ScriptUnit.has_extension(self._unit, "unit_data_system")
	self._character_state_component = unit_data_extension:read_component("character_state")
	local child_buff_template = template.child_buff_template
	self._child_buff_template = child_buff_template
	local child_template = BuffTemplates[child_buff_template]
	local max_child_stacks = (self._template_override_data.max_stacks or child_template.max_stacks or 1 or 1) + math.abs(child_template.stack_offset or 0)
	self._max_child_stacks = max_child_stacks
	self._restore_child_duration = template.restore_child_duration

	if is_server then
		self._num_child_stacks = 0
		self._child_buff_indicies = Script.new_array(max_child_stacks)
		self._remove_child_stack_t = 0
		self._add_child_stack_t = 0

		if template.start_at_max then
			self:_add_child_buff_stack(start_time, max_child_stacks)
		else
			self:_add_child_buff_stack(start_time, 1)
		end
	end
end

ParentProcBuff.destroy = function (self)
	if self._is_server then
		local buff_extension = self._buff_extension
		local num_child_stacks = self._num_child_stacks
		local child_buff_indicies = self._child_buff_indicies

		for i = num_child_stacks, 1, -1 do
			buff_extension:remove_externally_controlled_buff(child_buff_indicies[i])
		end
	end

	ParentProcBuff.super.destroy(self)
end

ParentProcBuff.update = function (self, dt, t, portable_random)
	ParentProcBuff.super.update(self, dt, t, portable_random)

	if not self._is_server then
		return
	end

	local num_child_stacks = self._num_child_stacks
	local character_state_component = self._character_state_component
	local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_component)

	if is_knocked_down then
		if num_child_stacks > 1 then
			self:_remove_child_buff_stack(t, num_child_stacks - 1)
		end

		self._remove_child_stack_t = t

		return
	end

	local max_child_stacks = self._max_child_stacks
	local last_remove_time = self._remove_child_stack_t
	local last_add_time = self._add_child_stack_t
	local time_since_remove = t - last_remove_time
	local time_since_add = t - last_add_time
	local restore_child_duration = self._restore_child_duration

	if restore_child_duration and num_child_stacks < max_child_stacks and restore_child_duration <= time_since_remove and restore_child_duration < time_since_add then
		self:_add_child_buff_stack(t, 1)

		num_child_stacks = self._num_child_stacks
	end

	local template = self._template
	local restore_child_update = template.restore_child_update

	if restore_child_update then
		local number_of_childs_to_restore = restore_child_update(self._template_data, self._template_context, dt, t)

		if number_of_childs_to_restore > 0 and num_child_stacks < max_child_stacks then
			self:_add_child_buff_stack(t, math.clamp(number_of_childs_to_restore, 0, max_child_stacks - num_child_stacks))
		end
	end
end

ParentProcBuff.update_proc_events = function (self, t, proc_events, num_proc_events, portable_random, local_portable_random)
	local activated_proc, procced_proc_events = ParentProcBuff.super.update_proc_events(self, t, proc_events, num_proc_events, portable_random, local_portable_random)
	local num_child_stacks = self._num_child_stacks

	if activated_proc and self._is_server then
		local template = self._template
		local remove_child_proc_events = template.remove_child_proc_events

		if remove_child_proc_events then
			for remove_child_proc_event, number_of_stacks_to_remove in pairs(template.remove_child_proc_events) do
				if procced_proc_events[remove_child_proc_event] and num_child_stacks > 1 then
					self:_remove_child_buff_stack(t, math.clamp(number_of_stacks_to_remove, 0, num_child_stacks - 1))

					num_child_stacks = self._num_child_stacks
				end
			end
		end

		local max_child_stacks = self._max_child_stacks
		local add_child_proc_events = template.add_child_proc_events

		if add_child_proc_events then
			for add_child_event, number_of_stacks_to_add in pairs(template.add_child_proc_events) do
				if procced_proc_events[add_child_event] and num_child_stacks < max_child_stacks then
					self:_add_child_buff_stack(t, math.clamp(number_of_stacks_to_add, 0, max_child_stacks - num_child_stacks))

					num_child_stacks = self._num_child_stacks
				end
			end
		end
	end

	return activated_proc, procced_proc_events
end

ParentProcBuff._add_child_buff_stack = function (self, t, num_children_to_add)
	local buff_extension = self._buff_extension
	local child_buff_template = self._child_buff_template
	local template = self._template
	local template_name = template.name
	local num_child_stacks = self._num_child_stacks
	local child_buff_indicies = self._child_buff_indicies

	for i = 1, num_children_to_add do
		num_child_stacks = num_child_stacks + 1
		local _, index = buff_extension:add_externally_controlled_buff(child_buff_template, t, "parent_buff_template", template_name)
		child_buff_indicies[num_child_stacks] = index
	end

	self._num_child_stacks = num_child_stacks
	self._add_child_stack_t = t
	local on_stacks_added_func = template.on_stacks_added_func

	if on_stacks_added_func then
		on_stacks_added_func(num_child_stacks, t, self._template_data, self._template_context)
	end
end

ParentProcBuff._remove_child_buff_stack = function (self, t, num_children_to_remove)
	local buff_extension = self._buff_extension
	local child_buff_indicies = self._child_buff_indicies
	local num_child_stacks = self._num_child_stacks

	for i = 1, num_children_to_remove do
		local buff_index = child_buff_indicies[num_child_stacks]

		buff_extension:remove_externally_controlled_buff(buff_index)

		num_child_stacks = num_child_stacks - 1
	end

	self._num_child_stacks = num_child_stacks
	self._remove_child_stack_t = t
	local template = self._template
	local on_stacks_removed_func = template.on_stacks_removed_func

	if on_stacks_removed_func then
		on_stacks_removed_func(num_child_stacks, num_children_to_remove, t, self._template_data, self._template_context)
	end
end

ParentProcBuff.has_hud = function (self)
	return ParentProcBuff.super.super.has_hud(self)
end

ParentProcBuff.visual_stack_count = function (self)
	local template_context = self._template_context
	local buff_extension = template_context.buff_extension
	local template = template_context.template
	local child_template_name = template.child_buff_template
	local number_of_buffs = child_template_name and buff_extension:current_stacks(child_template_name) or 1

	return number_of_buffs - 1
end

ParentProcBuff._show_in_hud = function (self)
	local template = self._template
	local always_show_in_hud = template.always_show_in_hud

	if always_show_in_hud then
		return true
	end

	local visual_stack_count = self:visual_stack_count()
	local show_in_hud = visual_stack_count > 0
	local is_hud_active = self:_is_hud_active()

	return show_in_hud and is_hud_active
end

ParentProcBuff._hud_show_stack_count = function (self)
	return true
end

ParentProcBuff.duration_progress = function (self)
	local character_state_component = self._character_state_component
	local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_component)

	if is_knocked_down then
		return 0.01
	end

	local template_context = self._template_context
	local buff_extension = self._buff_extension
	local template = template_context.template
	local child_template_name = template.child_buff_template
	local number_of_buffs = child_template_name and buff_extension:current_stacks(child_template_name)

	if self._max_child_stacks <= number_of_buffs then
		return 1
	end

	local child_start_time = child_template_name and buff_extension:buff_start_time(child_template_name) or 0
	local last_proc_time = self._active_start_time
	local t = FixedFrame.get_latest_fixed_time()
	local time_since_remove = t - last_proc_time
	local time_since_add = t - child_start_time
	local restore_child_duration = self._restore_child_duration

	if restore_child_duration then
		local time_until_restore = math.min(time_since_remove, time_since_add)
		local percentage_until_restore = math.clamp01(time_until_restore / restore_child_duration)

		return percentage_until_restore
	end

	return 1
end

return ParentProcBuff
