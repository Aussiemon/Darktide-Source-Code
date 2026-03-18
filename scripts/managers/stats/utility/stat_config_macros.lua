-- chunkname: @scripts/managers/stats/utility/stat_config_macros.lua

local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local StatConfigMacros = {}

StatConfigMacros.circumstance_has_stat_override = function (config, stat_override)
	local circumstance_name = config.circumstance_name

	return (circumstance_name and table.nested_get(CircumstanceTemplates, circumstance_name, "mission_overrides", "stat_settings", stat_override)) == true
end

StatConfigMacros.has_circumstance = function (config)
	local circumstance_name = config.circumstance_name

	return CircumstanceTemplates[circumstance_name] ~= nil and not StatConfigMacros.circumstance_has_stat_override(config, "default")
end

StatConfigMacros.is_story = function (config)
	local circumstance_name = config.circumstance_name

	return CircumstanceTemplates[circumstance_name] ~= nil and StatConfigMacros.circumstance_has_stat_override(config, "story")
end

StatConfigMacros.has_mutator = function (config, mutator_name)
	if Managers.state.mutator:mutator(mutator_name) then
		return true
	end

	return false
end

return StatConfigMacros
