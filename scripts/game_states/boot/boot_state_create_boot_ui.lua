-- chunkname: @scripts/game_states/boot/boot_state_create_boot_ui.lua

require("scripts/game_states/boot/state_boot_sub_state_base")

local BootStateCreateBootUI = class("BootStateCreateBootUI", "StateBootSubStateBase")

BootStateCreateBootUI._state_update = function (self, dt)
	if not Application.is_dedicated_server() then
		local BootUI = require("scripts/ui/boot_ui")
		local boot_ui = BootUI:new()

		self._boot_ui = boot_ui

		self._parent:set_boot_ui(boot_ui)
	end

	return true
end

BootStateCreateBootUI._state_cleanup = function (self, on_shutdown)
	if self._boot_ui then
		self._boot_ui:delete()

		self._boot_ui = nil
	end
end

return BootStateCreateBootUI
