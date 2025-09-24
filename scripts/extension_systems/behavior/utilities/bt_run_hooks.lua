-- chunkname: @scripts/extension_systems/behavior/utilities/bt_run_hooks.lua

local CompanionFollow = require("scripts/utilities/companion_follow")
local BtRunHooks = {
	store_owner_velocities = function (unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, args)
		CompanionFollow.store_velocity(unit, blackboard, scratchpad, action_data)
	end,
}

return BtRunHooks
