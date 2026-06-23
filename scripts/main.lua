-- chunkname: @scripts/main.lua

Main = Main or {}

require("scripts/boot_init")
require("scripts/foundation/strict_environment")
require("scripts/foundation/utilities/error")
require("scripts/foundation/utilities/class")
require("scripts/foundation/utilities/log")
require("scripts/foundation/utilities/settings")
require("scripts/foundation/utilities/table")

GAME_RESUME_COUNT = GAME_RESUME_COUNT or 0
FRAME_INDEX = FRAME_INDEX or -1

Main.init = function (self)
	local GameStateDebug = require("scripts/utilities/game_state_debug")
	local GameStateMachine = require("scripts/foundation/utilities/game_state_machine")
	local StateBoot = require("scripts/game_states/state_boot")
	local start_params = {
		next_state_class_name = "StateGame",
		boot_state_paths = {
			"scripts/game_states/boot/boot_state_set_globals",
			"scripts/game_states/boot/boot_state_apply_patches",
			"scripts/game_states/boot/boot_state_resolve_parameters",
			"scripts/game_states/boot/boot_state_create_boot_ui",
			"scripts/game_states/boot/boot_state_load_render_settings",
			"scripts/game_states/boot/boot_state_init_managers",
			"scripts/game_states/boot/boot_state_load_boot_assets",
			"scripts/game_states/boot/boot_state_require_foundation_scripts",
			"scripts/game_states/boot/boot_state_init_crashify",
			"scripts/game_states/boot/boot_state_init_testify",
			"scripts/game_states/boot/boot_state_require_game_scripts",
			"scripts/game_states/boot/boot_state_load_audio_settings",
			"scripts/game_states/boot/boot_state_activate_plugins",
			"scripts/game_states/boot/boot_state_startup_tests",
			"scripts/game_states/boot/boot_state_last",
		},
	}

	rawset(_G, "GameStateDebugInfo", GameStateDebug:new())

	self._sm = GameStateMachine:new(nil, StateBoot, start_params, nil, nil, "", "Main", true)
end

Main.update = function (self, dt)
	FRAME_INDEX = FRAME_INDEX + 1

	if self._in_update then
		Log.info("Main", "Detected crash during update. Executing on_recover.")
		self._sm:on_recover()
	end

	self._in_update = true

	self._sm:update(dt)

	self._in_update = false
end

Main.render = function (self)
	self._sm:render()
end

Main.shutdown = function (self)
	local exit_param = {
		on_shutdown = true,
	}

	self._sm:destroy(exit_param)
end

Main.on_reload = function (self, refreshed_resources)
	self._sm:on_reload(refreshed_resources)
end

Main.on_activate = function (self, is_active)
	Log.info("Main", "LUA window => " .. (is_active and "ACTIVATED" or "DEACTIVATED"))
	self._sm:on_activate(is_active)
end

Main.on_close = function (self)
	local should_close = self._sm:on_close()

	if should_close then
		Application.force_silent_exit_policy()
	end

	return should_close
end

Main.on_suspend = function (self)
	self._sm:on_suspend()
end

Main.on_resume = function (self)
	GAME_RESUME_COUNT = GAME_RESUME_COUNT + 1

	local Crashify = rawget(_G, "Crashify")

	if Crashify then
		Crashify.print_property("game_resume_count", GAME_RESUME_COUNT)
		Crashify.print_breadcrumb(string.format("on_resume: %s", GAME_RESUME_COUNT))
	end

	self._sm:on_resume()
end

Main.on_constrained = function (self, is_constrained)
	return self._sm:on_constrained(is_constrained)
end

local Main = Main

function init()
	return Main:init()
end

function update(dt)
	return Main:update(dt)
end

function render()
	return Main:render()
end

function shutdown()
	return Main:shutdown()
end

function on_reload(refreshed_resources)
	return Main:on_reload(refreshed_resources)
end

function on_activate(is_active)
	return Main:on_activate(is_active)
end

function on_close()
	return Main:on_close()
end

function on_suspend()
	return Main:on_suspend()
end

function on_resume()
	return Main:on_resume()
end

function on_constrained(is_constrained)
	return Main:on_constrained(is_constrained)
end

function on_low_memory_state_dump(global_path, registry_path, total_allocated, total_used)
	Log.exception("Memory", "Low on Lua memory. Allocated: '%d', Used: '%d'\n\t\t_G dump: %s\n\t\tRegistry dump: %s\n\t", total_allocated, total_used, global_path, registry_path)
end
