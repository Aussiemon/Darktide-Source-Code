-- chunkname: @scripts/utilities/companion_spawn_conditions.lua

local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local CompanionSpawnConditions = {}

CompanionSpawnConditions.adamant_companion_spawn_conditions = function (player_unit)
	local talent_extension = ScriptUnit.has_extension(player_unit, "talent_system")
	local companion_is_disabled = talent_extension and talent_extension:has_special_rule(SpecialRulesSettings.special_rules.disable_companion)

	return not companion_is_disabled
end

return CompanionSpawnConditions
