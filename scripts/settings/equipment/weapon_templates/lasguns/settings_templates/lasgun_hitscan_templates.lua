local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local hitscan_templates = {}
local overrides = {}

table.make_unique(hitscan_templates)
table.make_unique(overrides)

hitscan_templates.default_lasgun_beam = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_lasgun_killshot
		}
	}
}
hitscan_templates.lasgun_p1_m1_beam = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.lasgun_p1_m1_killshot
		}
	}
}
hitscan_templates.lasgun_p1_m2_lasgun_beam = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.lasgun_p1_m2_killshot
		}
	}
}
hitscan_templates.lasgun_p1_m3_lasgun_beam = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.lasgun_p1_m3_killshot
		}
	}
}
hitscan_templates.bfg_lasgun_beam = {
	range = 75,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_lasgun_bfg
		},
		penetration = {
			target_index_increase = 10,
			depth = 2
		}
	}
}
hitscan_templates.bfg_spray_lasgun_beam = {
	range = 75,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.spray_lasgun_bfg
		},
		penetration = {
			target_index_increase = 10,
			depth = 1
		}
	}
}
hitscan_templates.snp_lasgun_beam = {
	range = 75,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.light_lasgun_snp
		}
	}
}
hitscan_templates.snp_heavy_lasgun_beam = {
	range = 75,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.light_lasgun_snp
		}
	}
}
hitscan_templates.lasgun_p2_m1_beam_charged = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.lasgun_p2_m1_charge_killshot
		}
	}
}
hitscan_templates.lasgun_p2_m2_beam_charged = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.lasgun_p2_m2_charge_killshot
		}
	}
}
hitscan_templates.lasgun_p2_m3_beam_charged = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.lasgun_p2_m3_charge_killshot
		}
	}
}
hitscan_templates.lasgun_spraynpray_p3_m1 = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_lasgun_snp
		}
	}
}
hitscan_templates.lasgun_spraynpray_p3_m2 = {
	power_level = 500,
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.light_lasgun_snp
		}
	}
}
hitscan_templates.lasgun_spraynpray_p3_m3 = {
	power_level = 900,
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.heavy_lasgun_snp
		}
	}
}

return {
	base_templates = hitscan_templates,
	overrides = overrides
}
