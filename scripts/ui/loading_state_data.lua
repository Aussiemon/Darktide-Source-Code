-- chunkname: @scripts/ui/loading_state_data.lua

local LoadingStateData = class("LoadingStateData")

LoadingStateData.WAIT_REASON = table.index_lookup_table("read_disk", "backend", "store", "other_player", "dedicated_server", "platform")

local REASON_LOOKUP = {
	backend = "loc_wait_reason_backend",
	dedicated_server = "loc_wait_reason_dedicated_server",
	other_player = "loc_wait_reason_other_player",
	read_disk = "loc_wait_reason_read_from_disk",
	store = "loc_wait_reason_store",
}

if IS_GDK then
	REASON_LOOKUP.platform = "loc_wait_reason_platform_xbox_live"
elseif IS_PLAYSTATION then
	REASON_LOOKUP.platform = "loc_wait_reason_platform_psn"
else
	REASON_LOOKUP.platform = "loc_wait_reason_platform_steam"
end

LoadingStateData.init = function (self)
	self._states = {}
	self._tracked_promises = {}
	self._min_prio = 1
	self._max_prio = #LoadingStateData.WAIT_REASON
	self._last_reason = false
	self._start_wait_time = 0

	Managers.event:register(self, "event_start_waiting", "_event_start_waiting")
	Managers.event:register(self, "event_set_waiting_state", "_event_set_waiting_state")
	Managers.event:register(self, "event_stop_waiting", "_event_stop_waiting")
end

LoadingStateData._event_start_waiting = function (self, promise, reason)
	if promise then
		table.insert(self._tracked_promises, {
			promise = promise,
			reason = reason,
		})
	end

	self._start_wait_time = Managers.time:time("main")
end

LoadingStateData._event_set_waiting_state = function (self, prio)
	self._states[prio] = true
	self._dirty = true
end

LoadingStateData._event_stop_waiting = function (self)
	self._start_wait_time = math.huge
end

LoadingStateData.update = function (self)
	local promises = self._tracked_promises
	local was_tracking = #promises > 0

	for i = #promises, 1, -1 do
		if promises[i].promise:is_pending() then
			self:_event_set_waiting_state(promises[i].reason)
		else
			table.swap_delete(self._tracked_promises, i)
		end
	end

	if was_tracking and #self._tracked_promises == 0 then
		self:_event_stop_waiting()
	end
end

LoadingStateData.post_update = function (self)
	if not self._dirty then
		self._last_reason = nil

		return
	end

	local states = self._states

	for ii = 1, self._max_prio do
		if states[ii] then
			self._last_reason = LoadingStateData.WAIT_REASON[ii]

			break
		end
	end

	table.clear(self._states)

	self._dirty = false
end

LoadingStateData.current_wait_info = function (self)
	local reason_text

	if self._last_reason then
		reason_text = Localize(REASON_LOOKUP[self._last_reason])
	end

	local wait_time = Managers.time:time("main") - self._start_wait_time

	if DevParameters.debug_load_wait_info then
		reason_text = string.format("(%.1fs) %s", wait_time, tostring(reason_text))

		return reason_text, wait_time, 255
	else
		local text_opacity = 255

		return reason_text, wait_time, text_opacity
	end
end

LoadingStateData.destroy = function (self)
	Managers.event:unregister(self, "event_start_waiting")
	Managers.event:unregister(self, "event_set_waiting_state")
	Managers.event:unregister(self, "event_stop_waiting")
end

return LoadingStateData
