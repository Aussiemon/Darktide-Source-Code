-- chunkname: @scripts/utilities/fixed_frame.lua

local FixedFrame = {}

FixedFrame.get_latest_fixed_time = function ()
	return Managers.state.extension:latest_fixed_t()
end

FixedFrame.get_latest_fixed_frame = function ()
	return Managers.state.extension:latest_fixed_frame()
end

FixedFrame.clamp_to_fixed_time = function (not_fixed_t)
	local fixed_time_step = Managers.state.game_session.fixed_time_step

	return math.round(not_fixed_t / fixed_time_step) * fixed_time_step
end

FixedFrame.to_fixed_frame = function (fixed_t)
	local fixed_time_step = Managers.state.game_session.fixed_time_step

	return math.round(fixed_t / fixed_time_step)
end

FixedFrame.approximate_latest_fixed_time = function ()
	local gameplay_time = Managers.time:time("gameplay")

	return FixedFrame.clamp_to_fixed_time(gameplay_time)
end

return FixedFrame
