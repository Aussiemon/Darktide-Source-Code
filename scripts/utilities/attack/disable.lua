-- chunkname: @scripts/utilities/attack/disable.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BLACKBOARDS = BLACKBOARDS
local Disable = {}

Disable.disable_minion = function (unit, disabling_type, attacker_unit)
	local bb = BLACKBOARDS[unit]
	local target_disable_component = Blackboard.write_component(bb, "disable")

	target_disable_component.type = disabling_type
	target_disable_component.is_disabled = true
	target_disable_component.attacker_unit = attacker_unit

	local behavior_extension = ScriptUnit.has_extension(unit, "behavior_system")

	if behavior_extension then
		behavior_extension:behavior_state_event("disabled")
	end
end

return Disable
