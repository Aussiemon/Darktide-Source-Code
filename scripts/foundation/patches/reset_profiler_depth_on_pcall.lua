-- chunkname: @scripts/foundation/patches/reset_profiler_depth_on_pcall.lua

return function ()
	local function pack_pcall(status, ...)
		return status, {
			...,
		}, select("#", ...)
	end

	local lua_pcall = pcall

	if Script.pcall then
		pcall = Script.pcall
	else
		function pcall(...)
			local stack_depth = Profiler.stack_depth()
			local status, returns, num_returns = pack_pcall(lua_pcall(...))

			if not status then
				Profiler.reset_stack_depth(stack_depth)
			end

			return status, unpack(returns, 1, num_returns)
		end
	end

	rawset(_G, "_pcall", lua_pcall)

	local lua_xpcall = xpcall

	if Script.xpcall then
		xpcall = Script.xpcall
	else
		function xpcall(...)
			local stack_depth = Profiler.stack_depth()
			local status, returns, num_returns = pack_pcall(lua_xpcall(...))

			if not status then
				Profiler.reset_stack_depth(stack_depth)
			end

			return status, unpack(returns, 1, num_returns)
		end
	end

	rawset(_G, "_xpcall", lua_xpcall)
end
