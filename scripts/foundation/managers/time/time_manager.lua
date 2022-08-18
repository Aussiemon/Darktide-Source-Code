local Timer = require("scripts/foundation/managers/time/timer")
local TimeManager = class("TimeManager")

TimeManager.init = function (self, dt)
	self._timers = {
		main = Timer:new("main", nil, 0, dt)
	}
	self._dt_stack = {}
	self._dt_stack_max_size = 10
	self._dt_stack_index = self._dt_stack_max_size
	self._mean_dt = 0
	self._dt = dt
end

TimeManager.register_timer = function (self, name, parent_name, start_time)
	local timers = self._timers

	fassert(timers[name] == nil, "[TimeManager] Tried to add already registered timer %q", name)
	fassert(timers[parent_name], "[TimeManager] Not allowed to add timer with unregistered parent %q", parent_name)

	local parent_timer = timers[parent_name]
	local new_timer = Timer:new(name, parent_timer, start_time, self._dt)

	parent_timer:add_child(new_timer)

	timers[name] = new_timer
end

TimeManager.unregister_timer = function (self, name)
	local timer = self._timers[name]

	fassert(timer, "[TimeManager] Tried to remove unregistered timer %q", name)
	fassert(table.size(timer:children()) == 0, "[TimeManager] Not allowed to remove timer %q with children", name)

	local parent = timer:parent()

	if parent then
		parent:remove_child(timer)
	end

	timer:destroy()

	self._timers[name] = nil
end

TimeManager.has_timer = function (self, name)
	return (self._timers[name] and true) or false
end

TimeManager.update = function (self, dt)
	self._dt = dt
	local main_timer = self._timers.main

	if main_timer:active() then
		main_timer:update(dt, 1)
	end

	self:_update_mean_dt(dt)
end

TimeManager._update_mean_dt = function (self, dt)
	self._dt_stack_index = self._dt_stack_index % self._dt_stack_max_size + 1
	local dt_stack = self._dt_stack
	dt_stack[self._dt_stack_index] = dt
	local dt_sum = 0
	local dt_stack_size = #dt_stack

	for i = 1, dt_stack_size, 1 do
		local dt_stack_entry = dt_stack[i]
		dt_sum = dt_sum + dt_stack_entry
	end

	self._mean_dt = dt_sum / dt_stack_size
end

TimeManager.mean_dt = function (self)
	return self._mean_dt
end

TimeManager.set_time = function (self, name, time)
	self._timers[name]:set_time(time)
end

TimeManager.time = function (self, name)
	return self._timers[name]:time()
end

TimeManager.delta_time = function (self, name)
	return self._timers[name]:delta_time()
end

TimeManager.active = function (self, name)
	return self._timers[name]:active()
end

TimeManager.set_active = function (self, name, active)
	self._timers[name]:set_active(active)
end

TimeManager.set_local_scale = function (self, name, scale)
	fassert(name ~= "main", "[TimeManager] Not allowed to set scale in main timer")
	self._timers[name]:set_local_scale(scale)
end

TimeManager.local_scale = function (self, name)
	return self._timers[name]:local_scale()
end

TimeManager.destroy = function (self)
	for name, timer in pairs(self._timers) do
		timer:destroy()
	end

	self._timers = nil
end

return TimeManager
