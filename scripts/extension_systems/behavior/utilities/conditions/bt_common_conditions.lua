-- chunkname: @scripts/extension_systems/behavior/utilities/conditions/bt_common_conditions.lua

local conditions = {}

conditions.always_true = function (unit, blackboard, scratchpad, condition_args, action_data, is_running)
	return true
end

return conditions
