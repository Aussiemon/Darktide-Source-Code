-- chunkname: @scripts/game_states/boot/state_startup_tests.lua

require("scripts/game_states/boot/state_boot_sub_state_base")

local StateStartupTests = class("StateStartupTests", "StateBootSubStateBase")
local StartupTestDefinitions = {
	test_plugins = function ()
		if not IS_WINDOWS then
			return
		end

		local WANTED_PLUGINS = {
			CrashMonitor = true,
			cjson = true,
			gRPC = false,
			navigation = true,
			["rule database"] = true,
			texture = false,
			wwise_plugin = true,
		}

		for _, plugin_name in ipairs(Application.all_plugin_names()) do
			local is_required = WANTED_PLUGINS[plugin_name]

			if is_required == nil then
				return string.format("Plugin %q was neither registered as a required or optional plugin.", plugin_name)
			end

			WANTED_PLUGINS[plugin_name] = nil
		end

		for plugin_name, is_required in pairs(WANTED_PLUGINS) do
			if is_required then
				local hint = ""

				if HAS_STEAM then
					hint = "Make sure that your game files are not corrupt by <VERIFY INTEGRITY OF GAME FILES...> in Steam."
				end

				return string.format("Plugin %q is required but was not loaded.%s", plugin_name, hint)
			end
		end
	end,
}

StateStartupTests.on_enter = function (self, ...)
	StateStartupTests.super.on_enter(self, ...)
	self:_run_test("test_plugins")
end

StateStartupTests._run_test = function (self, test_name)
	local test_function = StartupTestDefinitions[test_name]
	local error_string = test_function()

	if error_string then
		local message = string.format("Startup test %q failed.\n%s", test_name, error_string)

		Application.quit_with_message(message)
		error(message)
	end
end

StateStartupTests._state_update = function (self, dt)
	return true, false
end

return StateStartupTests
