-- chunkname: @scripts/extension_systems/buff/buffs/interval_buff.lua

require("scripts/extension_systems/buff/buffs/buff")

local IntervalBuff = class("IntervalBuff", "Buff")

local function _next_interval_t(template, context)
	local interval = context and context.interval_override or template.interval

	if type(interval) == "table" then
		interval = interval[1] + math.random() * (interval[2] - interval[1])
	end

	return interval
end

IntervalBuff.init = function (self, context, template, start_time, instance_id, ...)
	self._duration_bonus_multiplier = 1

	IntervalBuff.super.init(self, context, template, start_time, instance_id, ...)

	self._duration_bonus_multiplier = self:_calculate_duration_bonus_multiplier(self._template_context, template)

	local random_offset = template.start_with_frame_offset and context.fixed_time_step * (1 + math.floor(math.random() * 9)) or 0
	local first_interval = template.start_interval_on_apply and 0 or _next_interval_t(template)

	self._next_interval_t = start_time + first_interval + random_offset
end

IntervalBuff.update = function (self, dt, t, portable_random)
	IntervalBuff.super.update(self, dt, t, portable_random)

	local next_interval_t = self._next_interval_t

	if next_interval_t < t then
		local template = self._template
		local interval_func = template.interval_func
		local time_since_start = t - self:start_time()

		interval_func(self._template_data, self._template_context, template, time_since_start, t, dt)

		if self._finished and template.interval_stack_removal then
			self._should_remove_stack = true
		end

		self._next_interval_t = t + _next_interval_t(template, self._template_context)
	end
end

IntervalBuff.duration = function (self)
	local base_duration = IntervalBuff.super.duration(self)

	return base_duration and base_duration * self._duration_bonus_multiplier or nil
end

IntervalBuff.finished = function (self)
	local template = self._template

	if not template.interval_stack_removal then
		return self._finished
	end

	return false
end

IntervalBuff._calculate_duration_bonus_multiplier = function (self, context, template)
	local burning_duration_bonus_multiplier = self:_calculate_burning_duration_bonus_multiplier(context.unit, context, template)

	return burning_duration_bonus_multiplier
end

IntervalBuff._calculate_burning_duration_bonus_multiplier = function (self, unit, context, template)
	local attacker_unit = self:owner_unit()

	if not attacker_unit then
		return 1
	end

	local side_system = Managers.state.extension:system("side_system")
	local unit_side = side_system.side_by_unit[unit]
	local side_name = unit_side and unit_side:name() or nil

	if side_name == nil or side_name == "heroes" then
		return 1
	end

	local num_constant_keywords = template.keywords and #template.keywords
	local has_burning_keyword = false

	if num_constant_keywords then
		local keywords = template.keywords

		for i = 1, num_constant_keywords do
			local keyword = keywords[i]

			if keyword == "burning" then
				has_burning_keyword = true

				break
			end
		end
	end

	if not has_burning_keyword then
		return 1
	end

	local total_duration_multiplier = 1
	local buff_extension = ScriptUnit.has_extension(attacker_unit, "buff_system")

	if buff_extension then
		local attacker_stat_buffs = buff_extension:stat_buffs()

		total_duration_multiplier = total_duration_multiplier + ((attacker_stat_buffs.burning_duration or 1) - 1)
	end

	return total_duration_multiplier
end

return IntervalBuff
