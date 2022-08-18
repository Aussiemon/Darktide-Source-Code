require("scripts/extension_systems/buff/buffs/buff")

local SpecialRulesBasedLerpedStatBuff = class("SpecialRulesBasedLerpedStatBuff", "Buff")

SpecialRulesBasedLerpedStatBuff.init = function (self, context, template, start_time, instance_id, ...)
	SpecialRulesBasedLerpedStatBuff.super.init(self, context, template, start_time, instance_id, ...)

	self._specialization_extension = ScriptUnit.extension(context.unit, "specialization_system")
	self._stat_buff_return_table = {}
end

SpecialRulesBasedLerpedStatBuff.update_stat_buffs = function (self, current_stat_buffs)
	SpecialRulesBasedLerpedStatBuff.super.update_stat_buffs(self, current_stat_buffs)

	local start_time = self._start_time
	local template = self._template
	local template_data = self._template_data
	local duration = template.duration
	local specialization_extension = self._specialization_extension
	local t = Managers.time:time("gameplay")
	local lerp_t = template.lerp_t_func(t, start_time, duration, template_data, self._template_context)

	table.clear(self._stat_buff_return_table)

	local talent_stat_buffs = template.special_rules_lerped_stat_buffs

	for special_rule, stat_buffs in pairs(talent_stat_buffs) do
		if specialization_extension:has_special_rule(special_rule) then
			for key, values in pairs(stat_buffs) do
				local min = values.min
				local max = values.max
				local lerped_value = math.lerp(min, max, lerp_t)
				self._stat_buff_return_table[key] = lerped_value
			end
		end
	end

	local missing_talent_stat_buffs = template.missing_special_rules_lerped_stat_buffs

	for special_rule, stat_buffs in pairs(missing_talent_stat_buffs) do
		if not specialization_extension:has_special_rule(special_rule) then
			for key, values in pairs(stat_buffs) do
				local min = values.min
				local max = values.max
				local lerped_value = math.lerp(min, max, lerp_t)
				self._stat_buff_return_table[key] = lerped_value
			end
		end
	end

	self:_calculate_stat_buffs(current_stat_buffs, self._stat_buff_return_table)
end

return SpecialRulesBasedLerpedStatBuff
