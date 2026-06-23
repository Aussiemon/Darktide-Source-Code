-- chunkname: @scripts/game_states/boot/boot_state_init_managers.lua

require("scripts/game_states/boot/state_boot_sub_state_base")

local BootStateInitManagers = class("BootStateInitManagers", "StateBootSubStateBase")

BootStateInitManagers._state_update = function (self, dt)
	require("scripts/foundation/managers/managers")

	local LocalizationManager = require("scripts/managers/localization/localization_manager")
	local PackageManager = require("scripts/foundation/managers/package/package_manager")
	local PackageManagerEditor = require("scripts/foundation/managers/package/package_manager_editor")

	Managers.package = LEVEL_EDITOR_TEST and PackageManagerEditor:new() or PackageManager:new()
	Managers.localization = LocalizationManager:new()

	return true
end

BootStateInitManagers._state_cleanup = function (self, on_shutdown)
	if on_shutdown then
		Managers:destroy()
	end
end

return BootStateInitManagers
