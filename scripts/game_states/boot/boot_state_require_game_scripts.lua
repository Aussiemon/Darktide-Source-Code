-- chunkname: @scripts/game_states/boot/boot_state_require_game_scripts.lua

require("scripts/game_states/boot/state_boot_sub_state_base")

local BootStateRequireGameScripts = class("BootStateRequireGameScripts", "StateBootSubStateBase")

BootStateRequireGameScripts._state_update = function (self, dt)
	require("scripts/game_states/state_game")

	return true
end

return BootStateRequireGameScripts
