local function _init_and_run_tests(PackageManager)
	local pm = PackageManager

	pm:init()
	pm:destroy()
end

return _init_and_run_tests
