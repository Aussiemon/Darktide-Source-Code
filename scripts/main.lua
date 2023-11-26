-- chunkname: @scripts/main.lua

Main = Main or {}

require("scripts/boot_init")
require("scripts/foundation/utilities/class")
require("scripts/foundation/utilities/patches")
require("scripts/foundation/utilities/settings")
require("scripts/foundation/utilities/table")

local GameStateMachine = require("scripts/foundation/utilities/game_state_machine")
local LocalizationManager = require("scripts/managers/localization/localization_manager")
local PackageManager = require("scripts/foundation/managers/package/package_manager")
local PackageManagerEditor = require("scripts/foundation/managers/package/package_manager_editor")
local ParameterResolver = require("scripts/foundation/utilities/parameters/parameter_resolver")
local StateBoot = require("scripts/game_states/state_boot")
local StateLoadAudioSettings = require("scripts/game_states/boot/state_load_audio_settings")
local StateLoadBootAssets = require("scripts/game_states/boot/state_load_boot_assets")
local StateLoadRenderSettings = require("scripts/game_states/boot/state_load_render_settings")
local StateRequireScripts = require("scripts/game_states/boot/state_require_scripts")

Main.init = function (self)
	Script.configure_garbage_collection(Script.ACCEPTABLE_GARBAGE, 0.1, Script.MAXIMUM_GARBAGE, 0.5, Script.FORCE_FULL_COLLECT_GARBAGE_LEVEL, 1, Script.MINIMUM_COLLECT_TIME_MS, 0.5, Script.MAXIMUM_COLLECT_TIME_MS, 1)
	ParameterResolver.resolve_command_line()
	ParameterResolver.resolve_game_parameters()
	ParameterResolver.resolve_dev_parameters()

	local fps = DEDICATED_SERVER and GameParameters.tick_rate or 30

	Application.set_time_step_policy("throttle", fps)

	if type(GameParameters.window_title) == "string" and GameParameters.window_title ~= "" then
		Window.set_title(GameParameters.window_title)
	end

	local package_manager = LEVEL_EDITOR_TEST and PackageManagerEditor:new() or PackageManager:new()
	local localization_manager = LocalizationManager:new()
	local params = {
		next_state = "StateGame",
		index_offset = 1,
		states = {
			{
				StateLoadBootAssets,
				{
					package_manager = package_manager,
					localization_manager = localization_manager
				}
			},
			{
				StateRequireScripts,
				{
					package_manager = package_manager
				}
			},
			{
				StateLoadAudioSettings,
				{}
			}
		},
		package_manager = package_manager,
		localization_manager = localization_manager
	}

	if PLATFORM == "win32" and not LEVEL_EDITOR_TEST then
		table.insert(params.states, 1, {
			StateLoadRenderSettings,
			{}
		})
	end

	if LEVEL_EDITOR_TEST then
		Wwise.load_bank("wwise/world_sound_fx")
	end

	self._package_manager = package_manager
	self._sm = GameStateMachine:new(nil, StateBoot, params, nil, nil, "Main")
end

Main.update = function (self, dt)
	self._sm:update(dt)
end

Main.render = function (self)
	self._sm:render()
end

Main.on_reload = function (self, refreshed_resources)
	self._sm:on_reload(refreshed_resources)
end

Main.on_close = function (self)
	local should_close = self._sm:on_close()

	return should_close
end

Main.shutdown = function (self)
	Application.force_silent_exit_policy()

	if rawget(_G, "Crashify") then
		Crashify.print_property("shutdown", true)
	end

	local owns_package_manager = true

	if rawget(_G, "Managers") and Managers.package then
		Managers.package:shutdown_has_started()

		owns_package_manager = false
	end

	local on_shutdown = true

	self._sm:destroy(on_shutdown)

	if owns_package_manager then
		self._package_manager:delete()
	end
end

function init()
	Main:init()
end

function update(dt)
	Main:update(dt)
end

function render()
	Main:render()
end

function on_reload(refreshed_resources)
	Main:on_reload(refreshed_resources)
end

function on_activate(active)
	print("LUA window => " .. (active and "ACTIVATED" or "DEACTIVATED"))

	if active and rawget(_G, "Managers") then
		if Managers.dlc then
			Managers.dlc:evaluate_consumables()
		end

		if Managers.account then
			Managers.account:refresh_communication_restrictions()
		end
	end
end

function on_close()
	local should_close = Main:on_close()

	if should_close then
		Application.force_silent_exit_policy()

		if rawget(_G, "Crashify") then
			Crashify.print_property("shutdown", true)
		end
	end

	return should_close
end

function on_suspend()
	if Managers then
		local update_grpc = false

		if Managers.party_immaterium then
			Managers.party_immaterium:reset()

			update_grpc = true
		end

		if Managers.presence then
			Managers.presence:reset()

			update_grpc = true
		end

		if update_grpc and Managers.grpc then
			Managers.grpc:update(0)
		end
	end
end

function on_resume()
	if Managers and Managers.backend then
		Managers.backend:time_sync_restart()
	end
end

function shutdown()
	Main:shutdown()
end
