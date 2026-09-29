-- chunkname: @scripts/utilities/lag_compensation.lua

local LagCompensation = {}

LagCompensation.rewind_miliseconds = function (is_server, is_local_unit, player)
	local do_lag_compensation = is_server and not is_local_unit
	local rewind_ms = 0

	if do_lag_compensation then
		rewind_ms = player:lag_compensation_rewind_ms()
	end

	return rewind_ms
end

local MILLISECONDS_TO_SECONDS = 0.001

LagCompensation.rewind_seconds = function (is_server, is_local_unit, player)
	local rewind_seconds = LagCompensation.rewind_miliseconds(is_server, is_local_unit, player) * MILLISECONDS_TO_SECONDS

	return rewind_seconds
end

return LagCompensation
