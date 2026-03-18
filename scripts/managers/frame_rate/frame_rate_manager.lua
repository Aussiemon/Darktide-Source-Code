-- chunkname: @scripts/managers/frame_rate/frame_rate_manager.lua

local NO_THROTTLE = 0
local FrameRateManager = class("FrameRateManager")

FrameRateManager.init = function (self)
	Application.set_time_step_policy(unpack(GameParameters.time_step_policy))

	self._reasons = {}

	self:refresh()
end

FrameRateManager._get_top_reason = function (self)
	local current_name, current_priority, current_throttled = "default", 0, true

	for reason_name, reason_data in pairs(self._reasons) do
		local reason_priority, reason_throttled = reason_data.priority, reason_data.throttled

		if current_priority < reason_priority or reason_priority == current_priority and reason_throttled then
			current_name, current_priority, current_throttled = reason_name, reason_priority, reason_throttled
		end
	end

	return current_name, current_priority, current_throttled
end

FrameRateManager._set_target_fps = function (self, is_throttled)
	local target_fps

	if not Application.rendering_enabled() then
		target_fps = GameParameters.tick_rate
	elseif is_throttled then
		target_fps = 60
	else
		target_fps = NO_THROTTLE

		if not Application.render_caps("reflex_supported") then
			target_fps = Application.render_config("settings", "nv_framerate_cap")
		end
	end

	Application.set_time_step_policy("throttle", target_fps)
end

FrameRateManager.refresh = function (self)
	local name, priority, throttled = self:_get_top_reason()

	Log.debug("FrameRateManager", "Setting throttle to '%s' due to reason '%s' with priority '%s'.", throttled, name, priority)
	self:_set_target_fps(throttled)
end

FrameRateManager.relinquish_request = function (self, reason)
	self._reasons[reason] = nil

	self:refresh()
end

FrameRateManager._add_reason = function (self, reason, priority, throttled)
	Log.debug("FrameRateManager", "Adding reason '%s' with priority '%s' and throttle '%s'.", reason, priority, throttled)

	self._reasons[reason] = {
		priority = priority,
		throttled = throttled,
	}

	self:refresh()
end

FrameRateManager.request_throttled_frame_rate = function (self, reason, priority)
	priority = priority or 1

	self:_add_reason(reason, priority, true)
end

FrameRateManager.request_full_frame_rate = function (self, reason, priority)
	priority = priority or 1

	self:_add_reason(reason, priority, false)
end

return FrameRateManager
