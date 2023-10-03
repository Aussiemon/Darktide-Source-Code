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
	IntervalBuff.super.init(self, context, template, start_time, instance_id, ...)

	local random_offset = template.start_with_frame_offset and context.fixed_time_step * (1 + math.floor(math.random() * 9)) or 0
	local first_inteval = template.start_interval_on_apply and 0 or _next_interval_t(template)
	self._next_interval_t = start_time + first_inteval + random_offset
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

IntervalBuff.finished = function (self)
	local template = self._template

	if not template.interval_stack_removal then
		return self._finished
	end

	return false
end

return IntervalBuff
