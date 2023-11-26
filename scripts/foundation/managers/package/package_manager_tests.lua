-- chunkname: @scripts/foundation/managers/package/package_manager_tests.lua

local function _init_and_run_tests(PackageManager)
	local pm = PackageManager

	pm:init()
	pm:destroy()
end

return _init_and_run_tests
