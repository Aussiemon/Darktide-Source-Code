-- chunkname: @scripts/extension_systems/buff/buffs/conditional_switch_stat_buff.lua

require("scripts/extension_systems/buff/buffs/buff")

local ConditionalSwitchStatBuff = class("ConditionalSwitchStatBuff", "Buff")

ConditionalSwitchStatBuff.update_stat_buffs = function (self, current_stat_buffs, t)
	ConditionalSwitchStatBuff.super.update_stat_buffs(self, current_stat_buffs, t)

	local template = self._template
	local conditional_switch_stat_buffs_func = template.conditional_switch_stat_buffs_func
	local index = conditional_switch_stat_buffs_func(self._template_data, self._template_context)

	if index then
		local conditional_stat_buffs = template.conditional_switch_stat_buffs[index]

		self:_calculate_stat_buffs(current_stat_buffs, conditional_stat_buffs)
	end
end

return ConditionalSwitchStatBuff
