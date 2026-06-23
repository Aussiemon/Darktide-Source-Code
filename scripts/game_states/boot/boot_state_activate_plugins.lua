-- chunkname: @scripts/game_states/boot/boot_state_activate_plugins.lua

require("scripts/game_states/boot/state_boot_sub_state_base")

local BootStateActivatePlugins = class("BootStateActivatePlugins", "StateBootSubStateBase")

BootStateActivatePlugins._state_update = function (self, dt)
	return true
end

return BootStateActivatePlugins
