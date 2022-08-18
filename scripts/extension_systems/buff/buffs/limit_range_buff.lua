require("scripts/extension_systems/buff/buffs/buff")

local LimitRangeBuff = class("LimitRangeBuff", "Buff")

LimitRangeBuff.init = function (self, context, template, start_time, instance_id, ...)
	LimitRangeBuff.super.init(self, context, template, start_time, instance_id, ...)

	local lerp_value = self._template_context.buff_lerp_value
	local stat_buffs = {}

	for key, range in pairs(template.stat_buffs) do
		local min = range.min
		local max = range.max
		local value = math.lerp(min, max, lerp_value)
		local final_value = math.round_down_with_precision(value, 2)
		stat_buffs[key] = final_value
	end

	self._lerp_value = lerp_value
	self._stat_buffs = stat_buffs
end

LimitRangeBuff.debug_get_stat_buffs = function (self)
	return self._stat_buffs
end

LimitRangeBuff.update_stat_buffs = function (self, current_stat_buffs, t)
	local template = self._template
	local conditional_func = template.conditional_limit_range_stat_buffs_func

	if conditional_func then
		local condition_passed = conditional_func(self._template_data, self._template_context)

		if condition_passed then
			self:_calculate_stat_buffs(current_stat_buffs, self._stat_buffs)
		end
	else
		self:_calculate_stat_buffs(current_stat_buffs, self._stat_buffs)
	end
end

return LimitRangeBuff
