-- chunkname: @scripts/extension_systems/buff/buffs/weapon_trait_target_number_parent_proc_buff.lua

require("scripts/extension_systems/buff/buffs/proc_buff")

local BuffTemplates = require("scripts/settings/buff/buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local PROC_EVENTS_STRIDE = BuffSettings.proc_events_stride
local WeaponTraitTargetNumberParentProcBuff = class("WeaponTraitTargetNumberParentProcBuff", "WeaponTraitParentProcBuff")

WeaponTraitTargetNumberParentProcBuff.init = function (self, context, template, start_time, instance_id, ...)
	WeaponTraitTargetNumberParentProcBuff.super.init(self, context, template, start_time, instance_id, ...)

	self._active = false
end

WeaponTraitTargetNumberParentProcBuff.update = function (self, dt, t, ...)
	WeaponTraitTargetNumberParentProcBuff.super.super.update(self, dt, t, ...)

	local template = self._template

	if self._is_server then
		self:update_number_of_children(t)

		local template_override_data = self._template_override_data
		local duration = template_override_data and template_override_data.child_duration or template.child_duration
		local num_child_stacks = self._num_child_stacks
		local start_t = self._template_data.last_hit_time

		if num_child_stacks > 1 and duration and start_t ~= 0 then
			local remove_t = start_t + duration

			if remove_t < t then
				local template_data = self._template_data

				template_data.attacked_unit = nil
				template_data.number_of_hits = 0
				template_data.target_number_of_stacks = 0

				local num_stacks_to_remove = num_child_stacks - 1

				self:_remove_child_buff_stack(t, num_stacks_to_remove)

				self._duration_progress = 0
			else
				local time_until_remove = remove_t - t
				local remove_progress = time_until_remove / duration

				self._duration_progress = 1 - remove_progress
			end
		end
	end
end

WeaponTraitTargetNumberParentProcBuff.update_proc_events = function (self, t, proc_events, num_proc_events, portable_random, local_portable_random)
	local activated_proc, procced_proc_events = WeaponTraitTargetNumberParentProcBuff.super.super.update_proc_events(self, t, proc_events, num_proc_events, portable_random, local_portable_random)

	self:update_number_of_children(t)

	return activated_proc, procced_proc_events
end

WeaponTraitTargetNumberParentProcBuff.update_number_of_children = function (self, t)
	local target_number_of_child_buffs = 1 + (self._template_data.target_number_of_stacks or 0)
	local current_num_child_stacks = self._num_child_stacks

	if current_num_child_stacks < target_number_of_child_buffs then
		local num_stacks_to_add = target_number_of_child_buffs - current_num_child_stacks

		self:_add_child_buff_stack(t, num_stacks_to_add)

		self._duration_progress = 0
	elseif target_number_of_child_buffs < current_num_child_stacks then
		local num_stacks_to_remove = current_num_child_stacks - target_number_of_child_buffs

		self:_remove_child_buff_stack(t, num_stacks_to_remove)

		self._duration_progress = 0
	end
end

return WeaponTraitTargetNumberParentProcBuff
