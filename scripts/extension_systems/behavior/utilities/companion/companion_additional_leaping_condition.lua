-- chunkname: @scripts/extension_systems/behavior/utilities/companion/companion_additional_leaping_condition.lua

local CompanionAdditionalLeapingCondition = {}

CompanionAdditionalLeapingCondition.is_target_leaping = function (unit, scratchpad, action_data)
	local target_unit = scratchpad.perception_component.target_unit
	local target_blackboard = BLACKBOARDS[target_unit]
	local started_leap = target_blackboard.pounce.started_leap

	return started_leap
end

return CompanionAdditionalLeapingCondition
