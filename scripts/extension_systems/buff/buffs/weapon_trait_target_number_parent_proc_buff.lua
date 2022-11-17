require("scripts/extension_systems/buff/buffs/proc_buff")

local BuffTemplates = require("scripts/settings/buff/buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local PROC_EVENTS_STRIDE = BuffSettings.proc_events_stride
local WeaponTraitTargetNumberParentProcBuff = class("WeaponTraitTargetNumberParentProcBuff", "WeaponTraitParentProcBuff")

WeaponTraitTargetNumberParentProcBuff.init = function (self, context, template, start_time, instance_id, ...)
	WeaponTraitTargetNumberParentProcBuff.super.init(self, context, template, start_time, instance_id, ...)

	self._active = false
end

WeaponTraitTargetNumberParentProcBuff.update_proc_events = function (self, t, proc_events, num_proc_events, portable_random, local_portable_random)
	WeaponTraitTargetNumberParentProcBuff.super.super.update_proc_events(self, t, proc_events, num_proc_events, portable_random, local_portable_random)

	local target_number_of_child_buffs = 1 + (self._template_data.target_number_of_stacks or 0)
	local current_num_child_stacks = self._num_child_stacks

	if current_num_child_stacks < target_number_of_child_buffs then
		local num_stacks_to_add = target_number_of_child_buffs - current_num_child_stacks

		self:_add_child_buff_stack(t, num_stacks_to_add)
	elseif target_number_of_child_buffs < current_num_child_stacks then
		local num_stacks_to_remove = current_num_child_stacks - target_number_of_child_buffs

		self:_remove_child_buff_stack(num_stacks_to_remove)
	end
end

return WeaponTraitTargetNumberParentProcBuff
