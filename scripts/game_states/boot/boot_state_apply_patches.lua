-- chunkname: @scripts/game_states/boot/boot_state_apply_patches.lua

require("scripts/game_states/boot/state_boot_sub_state_base")

local BootStateApplyPatches = class("BootStateApplyPatches", "StateBootSubStateBase")

BootStateApplyPatches._state_update = function (self, dt)
	local patches_paths = {
		"scripts/foundation/patches/ban_mixing_require_and_dofile",
		"scripts/foundation/patches/ban_popen",
		"scripts/foundation/patches/extended_unit_info",
		"scripts/foundation/patches/import_imgui_generated",
		"scripts/foundation/patches/merge_math_modules",
		"scripts/foundation/patches/network_init",
		"scripts/foundation/patches/profile_table_clone",
		"scripts/foundation/patches/register_gui_worlds",
		"scripts/foundation/patches/reset_profiler_depth_on_pcall",
		"scripts/foundation/patches/scrub_dangerous_functions",
		"scripts/foundation/patches/table_new_builtin",
		"scripts/foundation/patches/user_settings_for_consoles",
	}

	for _, path in ipairs(patches_paths) do
		local apply_patch = require(path)

		Log.debug("BootStateApplyPatches", "Applying patch: %s", path)
		apply_patch()
	end

	return true
end

return BootStateApplyPatches
