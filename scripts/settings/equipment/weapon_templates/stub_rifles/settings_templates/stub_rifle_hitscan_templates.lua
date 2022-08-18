local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local hitscan_templates = {}
local overrides = {}

table.make_unique(hitscan_templates)
table.make_unique(overrides)

hitscan_templates.default_stub_rifle_killshot = {
	range = 75,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_stub_pistol_killshot
		}
	}
}

return {
	base_templates = hitscan_templates,
	overrides = overrides
}
