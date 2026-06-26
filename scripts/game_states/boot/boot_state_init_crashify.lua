-- chunkname: @scripts/game_states/boot/boot_state_init_crashify.lua

require("scripts/game_states/boot/state_boot_sub_state_base")

local BootStateInitCrashify = class("BootStateInitCrashify", "StateBootSubStateBase")

BootStateInitCrashify._state_update = function (self, dt)
	local settings = require("scripts/settings/crashify/crashify")
	local launcher_verification_passed = GameParameters.launcher_verification_passed_crashify_property

	Crashify.print_property("project", settings.project)
	Crashify.print_property("project_branch", settings.branch)
	Crashify.print_property("build", BUILD)
	Crashify.print_property("content_revision", APPLICATION_SETTINGS.content_revision or LOCAL_CONTENT_REVISION)
	Crashify.print_property("engine_revision", BUILD_IDENTIFIER)
	Crashify.print_property("rendering_backend", Renderer.render_device_string())
	Crashify.print_property("teamcity_build_id", APPLICATION_SETTINGS.teamcity_build_id)
	Crashify.print_property("server", DEDICATED_SERVER)
	Crashify.print_property("is_modded", IS_MODDED)
	Crashify.print_property("launcher_verification_passed", launcher_verification_passed)
	Crashify.print_property("game_version", APPLICATION_SETTINGS.game_version)
	Crashify.print_property("game_resume_count", 0)

	if Application.machine_id then
		Crashify.print_property("machine_id", Application.machine_id())
	end

	if IS_WINDOWS then
		if IS_MODDED then
			Script.disable_low_memory_lua_state_dumps()
		end

		if HAS_STEAM then
			Crashify.print_property("steam", true)
			Crashify.print_property("steam_id", Steam.user_id())
			Crashify.print_property("steam_user_name", Steam.user_name())
			Crashify.print_property("steam_app_id", Steam.app_id())

			local beta_branch = Steam.beta_branch()

			if beta_branch then
				Crashify.print_property("steam_beta_branch", beta_branch)
			end
		elseif IS_GDK then
			Crashify.print_property("ms_store", true)
			Crashify.print_property("device_type", XboxLive.get_device_type())
		end
	elseif IS_PLAYSTATION then
		Crashify.print_property("device_type", Playstation.device_type())
		Crashify.print_property("ps5_online_id", Playstation.online_id())

		if Playstation.signed_in() then
			Crashify.print_property("ps5_account_id", Playstation.account_id())
		else
			Crashify.print_property("ps5_account_id", "psn_not_signed_in")
		end
	elseif PLATFORM == "xb1" then
		Crashify.print_property("console_type", "unknown")
	elseif IS_XBS then
		local device_type = XboxLive.get_device_type()

		Crashify.print_property("device_type", device_type)
	end

	if GameParameters.testify then
		Crashify.print_property("testify", true)
		Crashify.print_property("testify_test_suite_id", DevParameters.testify_test_suite_id)
	end

	Log.info("Crashify", "Ready!")
	Log.set_has_crashify(true)

	return true
end

BootStateInitCrashify._state_cleanup = function (self, on_shutdown)
	if on_shutdown then
		Crashify.print_property("shutdown", true)
	end
end

return BootStateInitCrashify
