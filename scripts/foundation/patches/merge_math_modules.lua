-- chunkname: @scripts/foundation/patches/merge_math_modules.lua

return function ()
	rawset(_G, "lua_math", table.shallow_copy(math))

	local function err()
		error("Use 'math' instead of 'Math'")
	end

	for name, func in pairs(Math) do
		math[name] = func
		Math[name] = err
	end
end
