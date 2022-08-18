local LagCompensation = {
	rewind_ms = function (is_server, is_local_unit, player)
		local do_lag_compensation = is_server and not is_local_unit
		local rewind_ms = 0

		if do_lag_compensation then
			rewind_ms = player:lag_compensation_rewind_ms()
		end

		return rewind_ms
	end
}

return LagCompensation
