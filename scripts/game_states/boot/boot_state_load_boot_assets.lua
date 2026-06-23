-- chunkname: @scripts/game_states/boot/boot_state_load_boot_assets.lua

require("scripts/game_states/boot/state_boot_sub_state_base")

local BootStateLoadBootAssets = class("BootStateLoadBootAssets", "StateBootSubStateBase")

BootStateLoadBootAssets.on_enter = function (self, ...)
	BootStateLoadBootAssets.super.on_enter(self, ...)

	local boot_packages = {
		"packages/boot_assets",
		"packages/strings",
		"packages/game_scripts",
	}

	self._package_ids = {}

	for i = 1, #boot_packages do
		local package_name = boot_packages[i]

		self._package_ids[package_name] = Managers.package:load(package_name, "StateBootSubStateBase", nil)
	end
end

BootStateLoadBootAssets._state_update = function (self, dt)
	local loading_done = Managers.package:update()

	if loading_done then
		local strings_package_id = self._package_ids["packages/strings"]

		Managers.localization:setup_localizers(strings_package_id)

		return true
	end
end

BootStateLoadBootAssets._state_cleanup = function (self, on_shutdown)
	if on_shutdown then
		for _, id in pairs(self._package_ids) do
			Managers.package:release(id)
		end
	end
end

return BootStateLoadBootAssets
