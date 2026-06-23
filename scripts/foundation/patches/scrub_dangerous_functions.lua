-- chunkname: @scripts/foundation/patches/scrub_dangerous_functions.lua

return function ()
	if BUILD ~= "dev" and BUILD ~= "debug" then
		local function scrub_library(lib)
			rawset(_G, lib, nil)

			package.loaded[lib] = nil
			package.preload[lib] = nil
		end

		scrub_library("ffi")
		scrub_library("io")

		os = {
			clock = os.clock,
			date = os.date,
			difftime = os.difftime,
			time = os.time,
			getenv = os.getenv,
		}
		package.loadlib = nil
		package.loaders[3] = nil
		package.loaders[4] = nil
		loadfile = nil
		loadstring = nil
		load = nil
	end
end
