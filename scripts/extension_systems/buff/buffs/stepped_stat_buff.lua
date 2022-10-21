require("scripts/extension_systems/buff/buffs/buff")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local SteppedStatBuff = class("SteppedStatBuff", "Buff")
local stat_buff_types = BuffSettings.stat_buff_types
local EMPTY_TABLE = {}

SteppedStatBuff.update_stat_buffs = function (self, current_stat_buffs, t)
	SteppedStatBuff.super.update_stat_buffs(self, current_stat_buffs)

	local stack_count = self:stack_count()
	local template_data = self._template_data
	local template_context = self._template_contex
	local template = self._template
	local bonus_step_func = template.bonus_step_func
	local bonus_step = bonus_step_func and bonus_step_func(template_data, template_context) or 0
	local min, max = nil
	local min_max_step_func = template.min_max_step_func

	if min_max_step_func then
		min, max = min_max_step_func(template_data, template_context)
	end

	min = min or 0
	max = max or template.max_stacks
	local step = math.clamp(stack_count + bonus_step, min, max)
	local stepped_stat_buffs = template.stepped_stat_buffs or EMPTY_TABLE
	local stat_buffs = stepped_stat_buffs[step] or EMPTY_TABLE

	for key, value in pairs(stat_buffs) do
		local stat_buff_type = stat_buff_types[key]
		local current_value = current_stat_buffs[key]

		if stat_buff_type == "multiplicative_multiplier" then
			current_value = current_value * value
		else
			current_value = current_value + value
		end

		current_stat_buffs[key] = current_value
	end
end

return SteppedStatBuff
