require("scripts/game_states/boot/state_boot_sub_state_base")

local StateBootLoadMods = class("StateBootLoadMods", "StateBootSubStateBase")

StateBootLoadMods.on_enter = function (self, parent, params)
	StateBootLoadMods.super.on_enter(self, parent, params)

	local ModManager = require("scripts/managers/mod/mod_manager")
	Managers.mod = ModManager:new(self._parent.gui)
end

StateBootLoadMods._state_update = function (self, dt)
	if Managers.mod:all_mods_loaded() then
		Managers.mod:remove_gui()

		return true, false
	end

	return false, false
end

return StateBootLoadMods
