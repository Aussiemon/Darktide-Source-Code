-- chunkname: @scripts/game_states/boot/boot_state_init_testify.lua

require("scripts/game_states/boot/state_boot_sub_state_base")

local BootStateInitTestify = class("BootStateInitTestify", "StateBootSubStateBase")

BootStateInitTestify._state_update = function (self, dt)
	Testify:ready()
	require("scripts/tests/test_cases/audio_test_cases")
	require("scripts/tests/test_cases/combat_test_cases")
	require("scripts/tests/test_cases/companion_test_cases")
	require("scripts/tests/test_cases/misc_test_cases")
	require("scripts/tests/test_cases/networked_test_cases")
	require("scripts/tests/test_cases/performance_test_cases")
	require("scripts/tests/test_cases/ui_test_cases")
	require("scripts/tests/test_cases/world_test_cases")

	return true
end

return BootStateInitTestify
