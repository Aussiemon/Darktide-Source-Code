-- chunkname: @scripts/game_states/boot/state_startup_tests.lua

require("scripts/game_states/boot/state_boot_sub_state_base")

local StateStartupTests = class("StateStartupTests", "StateBootSubStateBase")

StateStartupTests.on_enter = function (self, ...)
	StateStartupTests.super.on_enter(self, ...)

	local state_params = self:_state_params()
	local tests = state_params.tests

	self:_run_tests(tests)
end

StateStartupTests._run_tests = function (self, tests)
	for i = 1, #tests do
		local test_path = tests[i]
		local test_func = require(test_path)
		local success, error_msg = test_func()

		print(string.format("[StateStartupTests] Startup test %q success", test_path))
	end
end

StateStartupTests._state_update = function (self, dt)
	return true, false
end

return StateStartupTests
