require("scripts/extension_systems/buff/buffs/proc_buff")

local WeaponTraitProcConditionalSwitchBuff = class("WeaponTraitProcConditionalSwitchBuff", "ProcBuff")

WeaponTraitProcConditionalSwitchBuff.update_stat_buffs = function (self, current_stat_buffs, t)
	WeaponTraitProcConditionalSwitchBuff.super.update_stat_buffs(self, current_stat_buffs, t)

	local template = self._template
	local conditional_switch_stat_buffs_func = template.conditional_switch_stat_buffs_func
	local index = conditional_switch_stat_buffs_func(self._template_data, self._template_context)

	if index then
		local template_override_data = self._template_override_data
		local conditional_stat_buffs_groups = template_override_data and template_override_data.conditional_stat_buffs or template.conditional_stat_buffs
		local conditional_stat_buffs = conditional_stat_buffs_groups[index]

		self:_calculate_stat_buffs(current_stat_buffs, conditional_stat_buffs)
	end
end

return WeaponTraitProcConditionalSwitchBuff
