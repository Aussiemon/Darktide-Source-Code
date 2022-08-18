local GameplayInitTimeSlice = {
	MAX_DT_IN_MSEC = 33.333333333333336,
	MAX_DT_IN_SEC = GameplayInitTimeSlice.MAX_DT_IN_MSEC / 1000,
	pre_loop = function ()
		local performance_counter_handle = Application.query_performance_counter()
		local duration_ms = 0

		return performance_counter_handle, duration_ms
	end,
	pre_process = function (performance_counter_handle, duration_ms)
		if duration_ms < GameplayInitTimeSlice.MAX_DT_IN_MSEC then
			local start_timer = Application.time_since_query(performance_counter_handle)

			return start_timer
		end

		return nil
	end,
	post_process = function (performance_counter_handle, start_timer, duration_ms)
		local finish_timer = Application.time_since_query(performance_counter_handle)
		local delta_ms = finish_timer - start_timer
		duration_ms = duration_ms + delta_ms

		return duration_ms
	end,
	set_finished = function (data)
		table.clear(data)

		data.ready = true
	end
}

return GameplayInitTimeSlice
