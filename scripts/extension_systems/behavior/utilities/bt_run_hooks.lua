-- chunkname: @scripts/extension_systems/behavior/utilities/bt_run_hooks.lua

local CompanionFollowUtility = require("scripts/utilities/companion_follow_utility")
local BtRunHooks = {
	store_owner_velocities = function (unit, breed, blackboard, scratchpad, action_data, dt, t, node_data, args)
		CompanionFollowUtility.store_velocity(unit, blackboard, scratchpad, action_data)
	end,
}

return BtRunHooks
