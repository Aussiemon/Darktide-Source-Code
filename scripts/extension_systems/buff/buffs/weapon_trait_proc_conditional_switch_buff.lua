require("scripts/extension_systems/buff/buffs/proc_buff")

local WeaponTraitProcConditionalSwitchBuff = class("WeaponTraitProcConditionalSwitchBuff", "ProcBuff")

WeaponTraitProcConditionalSwitchBuff.update_stat_buffs = function (self, current_stat_buffs, t)
	WeaponTraitProcConditionalSwitchBuff.super.update_stat_buffs(self, current_stat_buffs, t)

	local template = self._template
	local conditional_stat_buffs_func = template.conditional_stat_buffs_func

	if conditional_stat_buffs_func and conditional_stat_buffs_func(self._template_data, self._template_context) then
		local conditional_switch_stat_buffs_func = template.conditional_switch_stat_buffs_func
		local index = conditional_switch_stat_buffs_func(self._template_data, self._template_context)

		if index then
			local template_override_data = self._template_override_data
			local conditional_stat_buffs_groups = template_override_data and template_override_data.conditional_switch_stat_buffs or template.conditional_switch_stat_buffs
			local conditional_stat_buffs = conditional_stat_buffs_groups[index]

			self:_calculate_stat_buffs(current_stat_buffs, conditional_stat_buffs)
		end
	end
end

WeaponTraitProcConditionalSwitchBuff._get_active_conditional_hud_data = function (self)
	local template = self._template
	local conditional_switch_stat_buffs_func = template.conditional_switch_stat_buffs_func
	local index = conditional_switch_stat_buffs_func(self._template_data, self._template_context)
	local conditional_hud_data = template.conditional_hud_data

	if index and conditional_hud_data then
		local active_conditional_hud_data = conditional_hud_data[index]

		if active_conditional_hud_data then
			return active_conditional_hud_data
		end
	end

	return nil
end

WeaponTraitProcConditionalSwitchBuff._is_hud_active = function (self)
	local active_conditional_hud_data = self:_get_active_conditional_hud_data()

	return active_conditional_hud_data and active_conditional_hud_data.is_active
end

WeaponTraitProcConditionalSwitchBuff._force_negative_frame = function (self)
	local active_conditional_hud_data = self:_get_active_conditional_hud_data()

	if active_conditional_hud_data then
		return active_conditional_hud_data.force_negative_frame
	end

	return false
end

return WeaponTraitProcConditionalSwitchBuff
