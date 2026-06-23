-- chunkname: @scripts/game_states/boot/boot_state_require_foundation_scripts.lua

require("scripts/game_states/boot/state_boot_sub_state_base")

local BootStateRequireFoundationScripts = class("BootStateRequireFoundationScripts", "StateBootSubStateBase")

BootStateRequireFoundationScripts._state_update = function (self, dt)
	require("scripts/foundation/utilities/vector3")
	require("scripts/foundation/utilities/quaternion")
	require("scripts/foundation/utilities/utf8")
	require("scripts/foundation/utilities/color")
	require("scripts/foundation/utilities/math")
	require("scripts/foundation/utilities/table")
	require("scripts/foundation/utilities/string")
	require("scripts/foundation/utilities/callback")
	require("scripts/foundation/utilities/crashify")
	require("scripts/foundation/utilities/testify")
	require("scripts/foundation/utilities/reportify")

	return true
end

return BootStateRequireFoundationScripts
