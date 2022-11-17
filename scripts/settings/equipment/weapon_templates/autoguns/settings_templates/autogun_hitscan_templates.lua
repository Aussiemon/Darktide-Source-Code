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
hitscan_templates.autogun_p1_m2_bullet = {
	power_level = 350,
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_autogun_assault
		}
	}
}
hitscan_templates.autogun_p1_m1_bullet = {
	power_level = 700,
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
overrides.burst_autogun_bullet = {
	parent_template_name = "default_autogun_bullet",
	overrides = {
		{
			"damage",
			"impact",
			"damage_profile",
			DamageProfileTemplates.autogun_burst_shot
		}
	}
}
hitscan_templates.autogun_p2_m1_bullet = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.autogun_p2_m1
		}
	}
}
hitscan_templates.autogun_p2_m2_bullet = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.autogun_p2_m2
		}
	}
}
hitscan_templates.autogun_p2_m3_bullet = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.autogun_p2_m3
		}
	}
}
hitscan_templates.autogun_p3_m1_bullet = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.autogun_p3_m1
		}
	}
}
hitscan_templates.autogun_p3_m2_bullet = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.autogun_p3_m2
		}
	}
}
hitscan_templates.autogun_p3_m3_bullet = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.autogun_p3_m3
		}
	}
}

return {
	base_templates = hitscan_templates,
	overrides = overrides
}
