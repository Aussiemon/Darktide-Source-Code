require("scripts/game_states/boot/state_boot_sub_state_base")

local StateLoadBootAssets = class("StateLoadBootAssets", "StateBootSubStateBase")

StateLoadBootAssets.on_enter = function (self, ...)
	StateLoadBootAssets.super.on_enter(self, ...)

	local state_params = self:_state_params()
	local pm = state_params.package_manager
	self._package_manager = pm
	self._localization_manager = state_params.localization_manager
	local boot_packages = {
		"packages/boot_assets",
		"packages/strings",
		"packages/game_scripts"
	}
	self._package_ids = {}

	for i = 1, #boot_packages, 1 do
		self._package_ids[boot_packages[i]] = pm:load(boot_packages[i], "StateBootSubStateBase", nil)
	end
end

StateLoadBootAssets._state_update = function (self, dt)
	local loading_done = self._package_manager:update()

	if loading_done then
		local strings_package_id = self._package_ids["packages/strings"]

		self._localization_manager:setup_localizers(strings_package_id)
	end

	return loading_done, false
end

return StateLoadBootAssets
