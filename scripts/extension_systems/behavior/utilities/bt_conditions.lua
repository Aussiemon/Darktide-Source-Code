-- chunkname: @scripts/extension_systems/behavior/utilities/bt_conditions.lua

local BtConditions = {}

local function _add_conditions(path)
	local conditions = require(path)

	for condition_name, condition_func in pairs(conditions) do
		BtConditions[condition_name] = condition_func
	end
end

_add_conditions("scripts/extension_systems/behavior/utilities/conditions/bt_bot_conditions")
_add_conditions("scripts/extension_systems/behavior/utilities/conditions/bt_common_conditions")
_add_conditions("scripts/extension_systems/behavior/utilities/conditions/bt_minion_conditions")

return BtConditions
