local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local hitscan_templates = {}
local overrides = {}

table.make_unique(hitscan_templates)
table.make_unique(overrides)

hitscan_templates.default_laspistol_beam = {
	range = 75,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_laspistol_killshot
		}
	}
}
hitscan_templates.bgf_laspistol_beam = {
	range = 75,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_laspistol_bfg
		}
	}
}

return {
	base_templates = hitscan_templates,
	overrides = overrides
}
