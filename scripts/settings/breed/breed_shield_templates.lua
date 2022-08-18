local breed_shield_templates = {}

local function _create_breed_shield_entry(path)
	local shield_templates = require(path)

	for name, template in pairs(shield_templates) do
		breed_shield_templates[name] = template
	end
end

_create_breed_shield_entry("scripts/settings/breed/breed_shield_templates/chaos/chaos_ogryn_bulwark_shield_template")

return settings("BreedShieldTemplates", breed_shield_templates)
