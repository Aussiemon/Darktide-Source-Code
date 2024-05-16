-- chunkname: @scripts/utilities/taskbar_flash.lua

local TaskbarFlash = {}
local DEFAULT_NUM_FLASHES = 3

TaskbarFlash.flash_window = function (override_num_flashes)
	if DEDICATED_SERVER or not IS_WINDOWS then
		return
	end

	if Window.has_focus() then
		return
	end

	local save_manager = Managers.save
	local flash_taskbar = true

	if save_manager then
		local account_data = save_manager:account_data()

		flash_taskbar = account_data and account_data.interface_settings.flash_taskbar_enabled
	end

	if not flash_taskbar then
		return
	end

	Window.flash_window(nil, "start", override_num_flashes or DEFAULT_NUM_FLASHES)
end

return TaskbarFlash
