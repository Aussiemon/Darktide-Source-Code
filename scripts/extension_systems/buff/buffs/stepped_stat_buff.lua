-- chunkname: @scripts/extension_systems/buff/buffs/stepped_stat_buff.lua

require("scripts/extension_systems/buff/buffs/buff")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local SteppedStatBuff = class("SteppedStatBuff", "Buff")
local stat_buff_types = BuffSettings.stat_buff_types
local EMPTY_TABLE = {}

SteppedStatBuff.update_stat_buffs = function (self, current_stat_buffs, t)
	SteppedStatBuff.super.update_stat_buffs(self, current_stat_buffs, t)

	local step_stat_buffs = self:_get_step_stat_buffs()

	for key, value in pairs(step_stat_buffs) do
		local stat_buff_type = stat_buff_types[key]
		local current_value = current_stat_buffs[key]

		if stat_buff_type == "multiplicative_multiplier" then
			current_value = current_value * value
		elseif stat_buff_type == "max_value" then
			current_value = math.max(current_value, value)
		else
			current_value = current_value + value
		end

		current_stat_buffs[key] = current_value
		current_stat_buffs._modified_stats[key] = current_value
	end
end

SteppedStatBuff.stat_buff_stacking_count = function (self)
	local stack_count = SteppedStatBuff.super.stat_buff_stacking_count(self)
	local template_data = self._template_data
	local template_context = self._template_context
	local template = self._template
	local bonus_step_func = template.bonus_step_func
	local bonus_step = bonus_step_func and bonus_step_func(template_data, template_context) or 0
	local min, max
	local min_max_step_func = template.min_max_step_func

	if min_max_step_func then
		min, max = min_max_step_func(template_data, template_context)
	end

	min = min or 0
	max = max or self:max_stacks()

	local step = math.clamp(stack_count + bonus_step, min, max)

	return step
end

SteppedStatBuff.visual_stack_count = function (self)
	local steps = self:stat_buff_stacking_count()

	return steps
end

SteppedStatBuff._get_step_stat_buffs = function (self)
	local template = self._template
	local conditional_stepped_stat_buffs_func = template.conditional_stepped_stat_buffs_func

	if conditional_stepped_stat_buffs_func and not conditional_stepped_stat_buffs_func(self._template_data, self._template_context) then
		return EMPTY_TABLE
	end

	local steps = self:stat_buff_stacking_count()

	if steps <= 0 then
		return EMPTY_TABLE
	end

	local template_override_data = self._template_override_data
	local override_stepped_stat_buffs = template_override_data and template_override_data.stepped_stat_buffs
	local stepped_stat_buffs = override_stepped_stat_buffs or template.stepped_stat_buffs or EMPTY_TABLE
	local stat_buffs = stepped_stat_buffs[steps] or EMPTY_TABLE

	return stat_buffs
end

return SteppedStatBuff
