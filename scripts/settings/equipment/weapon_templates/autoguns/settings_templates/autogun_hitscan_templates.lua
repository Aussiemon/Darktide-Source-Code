local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local hitscan_templates = {}
local overrides = {}

table.make_unique(hitscan_templates)
table.make_unique(overrides)

hitscan_templates.default_autogun_bullet = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_autogun_assault
		}
	}
}
overrides.snp_autogun_bullet = {
	parent_template_name = "default_autogun_bullet",
	overrides = {
		{
			"damage",
			"impact",
			"damage_profile",
			DamageProfileTemplates.default_autogun_snp
		}
	}
}
overrides.killshot_autogun_bullet = {
	parent_template_name = "default_autogun_bullet",
	overrides = {
		{
			"damage",
			"impact",
			"damage_profile",
			DamageProfileTemplates.default_autogun_killshot
		}
	}
}

return {
	base_templates = hitscan_templates,
	overrides = overrides
}
