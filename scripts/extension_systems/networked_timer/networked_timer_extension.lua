local NetworkedTimerExtension = class("NetworkedTimerExtension")

NetworkedTimerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._is_server = extension_init_context.is_server
	self._unit = unit
	self._duration = 0
	self._hud_description = "loc_description"
	self._max_speed_modifier = 1
	self._active = false
	self._counting = false
	self._total_timer = 0
	self._speed_modifier = 1
end

NetworkedTimerExtension.setup_from_component = function (self, duration, hud_description, max_speed_modifier)
	if duration ~= nil then
		self._duration = duration
	end

	if hud_description ~= nil then
		self._hud_description = hud_description
	end

	if max_speed_modifier ~= nil then
		self._max_speed_modifier = max_speed_modifier
	end
end

NetworkedTimerExtension.update = function (self, unit, dt, t)
	if self._active then
		if self._total_timer < self._duration then
			if self._counting then
				self._total_timer = math.min(self._total_timer + dt * self._speed_modifier, self._duration)
			end
		elseif self._is_server then
			self:finished()
		end
	end
end

NetworkedTimerExtension.hot_join_sync = function (self, unit, sender, channel)
	fassert(self._is_server, "Server only method.")

	local unit_id = Managers.state.unit_spawner:level_index(self._unit)
	local active = self._active
	local counting = self._counting
	local total_timer = self._total_timer
	local speed_modifier = self._speed_modifier

	Managers.state.game_session:send_rpc_clients("rpc_networked_timer_sync_state", unit_id, active, counting, total_timer, speed_modifier)
end

NetworkedTimerExtension.sync_state = function (self, active, counting, total_timer, speed_modifier)
	self._active = active
	self._counting = counting
	self._total_timer = total_timer
	self._speed_modifier = speed_modifier
end

NetworkedTimerExtension.start = function (self)
	self._active = true
	self._counting = true
	self._speed_modifier = 1

	if self._is_server then
		local unit_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_networked_timer_start", unit_id)
	end
end

NetworkedTimerExtension.pause = function (self)
	self._counting = false
	self._speed_modifier = 1

	if self._is_server then
		local unit_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_networked_timer_pause", unit_id)
	end
end

NetworkedTimerExtension.stop = function (self)
	self._active = false
	self._counting = false
	self._total_timer = 0
	self._speed_modifier = 1

	if self._is_server then
		local unit_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_networked_timer_stop", unit_id)
	end
end

NetworkedTimerExtension.fast_forward = function (self)
	if self._speed_modifier < 1 then
		self._speed_modifier = 1
	end

	self._speed_modifier = self._speed_modifier + 1
	self._speed_modifier = math.min(self._speed_modifier, self._max_speed_modifier)

	if self._is_server then
		local unit_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_networked_timer_fast_forward", unit_id)
	end
end

NetworkedTimerExtension.rewind = function (self)
	return
end

NetworkedTimerExtension.finished = function (self)
	self._active = false
	self._counting = false
	self._total_timer = 0

	Unit.flow_event(self._unit, "lua_timer_finished")

	if self._is_server then
		local unit_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_networked_timer_finished", unit_id)
	end
end

NetworkedTimerExtension.is_active = function (self)
	return self._active
end

NetworkedTimerExtension.is_counting = function (self)
	return self._counting
end

NetworkedTimerExtension.get_timer = function (self)
	return self._total_timer
end

NetworkedTimerExtension.get_remaining_time = function (self)
	return self._duration - self._total_timer
end

NetworkedTimerExtension.progression = function (self)
	local progression = 0

	if self._duration > 0 then
		progression = self._total_timer / self._duration
	end

	progression = math.clamp(progression, 0, 1)

	return progression
end

return NetworkedTimerExtension
