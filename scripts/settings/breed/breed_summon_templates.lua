-- chunkname: @scripts/settings/breed/breed_summon_templates.lua

local breed_summon_templates = {}

local function _create_breed_summon_entry(path)
	local summon_templates = require(path)

	for name, template in pairs(summon_templates) do
		breed_summon_templates[name] = template
	end
end

_create_breed_summon_entry("scripts/settings/breed/breed_summon_templates/renegade/renegade_radio_operator_summon_template")

return settings("BreedSummonTemplates", breed_summon_templates)
