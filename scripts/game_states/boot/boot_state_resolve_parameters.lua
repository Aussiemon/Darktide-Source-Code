-- chunkname: @scripts/game_states/boot/boot_state_resolve_parameters.lua

require("scripts/game_states/boot/state_boot_sub_state_base")

local BootStateResolveParameters = class("BootStateResolveParameters", "StateBootSubStateBase")

BootStateResolveParameters._state_update = function (self, dt)
	local ParameterResolver = require("scripts/foundation/utilities/parameters/parameter_resolver")

	ParameterResolver.resolve_command_line()
	ParameterResolver.resolve_game_parameters()
	ParameterResolver.resolve_dev_parameters()
	Log.load_config_from_parameters(GameParameters, DevParameters)

	local fps = DEDICATED_SERVER and GameParameters.tick_rate or 30

	Application.set_time_step_policy("throttle", fps)
	Script.configure_garbage_collection(Script.ACCEPTABLE_GARBAGE, DevParameters.gc_acceptable_garbage, Script.MAXIMUM_GARBAGE, DevParameters.gc_maximum_garbage, Script.FORCE_FULL_COLLECT_GARBAGE_LEVEL, DevParameters.gc_force_full_collect_garbage_level, Script.MINIMUM_COLLECT_TIME_MS, DevParameters.gc_minimum_collect_time_ms, Script.MAXIMUM_COLLECT_TIME_MS, DevParameters.gc_maximum_collect_time_ms)

	if rawget(_G, "Window") then
		local grab_mouse = true

		if grab_mouse then
			Window.set_focus()
			Window.set_mouse_focus(true)
			Window.set_clip_cursor(true)
			Window.set_cursor("content/ui/textures/cursors/mouse_cursor_idle")
		end
	end

	return true
end

return BootStateResolveParameters
