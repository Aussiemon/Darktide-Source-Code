-- chunkname: @scripts/game_states/boot/boot_state_last.lua

require("scripts/game_states/boot/state_boot_sub_state_base")

local BootStateLast = class("BootStateLast", "StateBootSubStateBase")

BootStateLast.on_enter = function (self, ...)
	BootStateLast.super.on_enter(self, ...)
end

BootStateLast._state_update = function (self, dt)
	return true
end

return BootStateLast
