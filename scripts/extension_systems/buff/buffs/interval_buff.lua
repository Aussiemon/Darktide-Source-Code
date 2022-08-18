require("scripts/extension_systems/buff/buffs/buff")

local IntervalBuff = class("IntervalBuff", "Buff")

local function _next_interval_t(template)
	local interval = template.interval

	if type(interval) == "table" then
		interval = interval[1] + math.random() * (interval[2] - interval[1])
	end

	return interval
end

IntervalBuff.init = function (self, context, template, start_time, instance_id, ...)
	IntervalBuff.super.init(self, context, template, start_time, instance_id, ...)

	self._next_interval_t = start_time + (template.start_interval_on_apply and 0 or _next_interval_t(template))
end

IntervalBuff.update = function (self, dt, t, portable_random)
	IntervalBuff.super.update(self, dt, t, portable_random)

	local next_interval_t = self._next_interval_t

	if next_interval_t < t then
		local template = self._template
		local interval_function = template.interval_function

		interval_function(self._template_data, self._template_context, template)

		self._next_interval_t = t + _next_interval_t(template)
	end
end

return IntervalBuff
