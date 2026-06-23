-- chunkname: @scripts/game_states/boot/boot_state_startup_tests.lua

require("scripts/game_states/boot/state_boot_sub_state_base")

local BootStateStartupTests = class("BootStateStartupTests", "StateBootSubStateBase")
local StartupTestDefinitions = {
	check_plugins = function ()
		if not IS_WINDOWS then
			return
		end

		local WANTED_PLUGINS = {
			CrashMonitor = true,
			cjson = true,
			gRPC = true,
			navigation = true,
			["rule database"] = true,
			wwise_plugin = true,
		}

		for _, plugin_name in ipairs(Application.all_plugin_names()) do
			local is_required = WANTED_PLUGINS[plugin_name]

			if is_required == nil then
				return string.format("Plugin %q was not registered as a required or optional plugin.", plugin_name)
			end

			WANTED_PLUGINS[plugin_name] = nil
		end

		for plugin_name, is_required in pairs(WANTED_PLUGINS) do
			if is_required then
				local fix_hint = ""

				if HAS_STEAM then
					fix_hint = " Make sure that your game files are not corrupt by <VERIFY INTEGRITY OF GAME FILES...> in Steam."
				end

				return string.format("Plugin %q is required but was not loaded.%s", plugin_name, fix_hint)
			end
		end
	end,
}

BootStateStartupTests._run_test = function (self, test_name)
	local test_function = StartupTestDefinitions[test_name]
	local error_string = test_function()

	if error_string then
		local message = string.format("Startup test %q failed.\n%s", test_name, error_string)

		Application.quit_with_message(message)
		error(message)
	end
end

BootStateStartupTests._state_update = function (self, dt)
	self:_run_test("check_plugins")

	return true
end

return BootStateStartupTests
