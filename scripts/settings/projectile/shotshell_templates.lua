-- chunkname: @scripts/settings/projectile/shotshell_templates.lua

local WeaponTweaks = require("scripts/utilities/weapon_tweaks")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local armor_types = ArmorSettings.types
local shotshell_templates = {}
local loaded_template_files = {}

WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/ripperguns/settings_templates/rippergun_shotshell_templates", shotshell_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/thumpers/settings_templates/thumper_shotshell_templates", shotshell_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/shotguns/settings_templates/shotgun_shotshell_templates", shotshell_templates, loaded_template_files)

shotshell_templates.default_ogryn_shotgun = {
	spread_yaw = 20,
	range = 100,
	pellets_per_frame = 10,
	spread_pitch = 8,
	num_pellets = 25,
	bullseye = true,
	num_spread_circles = 4,
	min_num_hits = {
		[armor_types.unarmored] = 5,
		[armor_types.armored] = 6,
		[armor_types.resistant] = 15,
		[armor_types.player] = 1,
		[armor_types.berserker] = 5,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 5
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_ogryn_shotgun_assault
		}
	}
}
shotshell_templates.shotgun_assault = {
	spread_yaw = 2.5,
	range = 100,
	pellets_per_frame = 6,
	spread_pitch = 2.5,
	num_pellets = 12,
	bullseye = true,
	num_spread_circles = 2,
	min_num_hits = {
		[armor_types.unarmored] = 4,
		[armor_types.armored] = 4,
		[armor_types.resistant] = 6,
		[armor_types.player] = 1,
		[armor_types.berserker] = 5,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 8
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_shotgun_assault
		}
	}
}
shotshell_templates.shotgun_killshot = {
	spread_yaw = 0.75,
	range = 100,
	pellets_per_frame = 6,
	spread_pitch = 0.75,
	num_pellets = 12,
	bullseye = true,
	num_spread_circles = 2,
	min_num_hits = {
		[armor_types.unarmored] = 5,
		[armor_types.armored] = 6,
		[armor_types.resistant] = 15,
		[armor_types.player] = 1,
		[armor_types.berserker] = 5,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 5
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_shotgun_killshot
		}
	}
}
shotshell_templates.shotgun_p1_m2_assault = {
	spread_yaw = 0.75,
	range = 100,
	pellets_per_frame = 7,
	no_random_roll = true,
	scatter_range = 0.075,
	spread_pitch = 1.5,
	roll_offset = 0.25,
	num_pellets = 7,
	bullseye = true,
	num_spread_circles = 1,
	min_num_hits = {
		[armor_types.unarmored] = 3,
		[armor_types.armored] = 3,
		[armor_types.resistant] = 4,
		[armor_types.player] = 1,
		[armor_types.berserker] = 3,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 4
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.shotgun_p1_m2_assault
		}
	}
}
shotshell_templates.shotgun_p1_m3_assault = {
	spread_yaw = 3.5,
	range = 100,
	pellets_per_frame = 6,
	spread_pitch = 2.5,
	num_pellets = 18,
	bullseye = false,
	num_spread_circles = 2,
	min_num_hits = {
		[armor_types.unarmored] = 6,
		[armor_types.armored] = 6,
		[armor_types.resistant] = 8,
		[armor_types.player] = 1,
		[armor_types.berserker] = 7,
		[armor_types.super_armor] = 3,
		[armor_types.disgustingly_resilient] = 9
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.shotgun_p1_m3_assault
		}
	}
}
shotshell_templates.shotgun_p1_m2_killshot = {
	spread_yaw = 0.4,
	range = 100,
	pellets_per_frame = 7,
	no_random_roll = true,
	scatter_range = 0.075,
	spread_pitch = 0.6,
	num_pellets = 7,
	bullseye = true,
	num_spread_circles = 1,
	min_num_hits = {
		[armor_types.unarmored] = 3,
		[armor_types.armored] = 3,
		[armor_types.resistant] = 4,
		[armor_types.player] = 1,
		[armor_types.berserker] = 3,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 4
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.shotgun_p1_m2_killshot
		}
	}
}
shotshell_templates.shotgun_p1_m3_killshot = {
	spread_yaw = 1.5,
	range = 100,
	pellets_per_frame = 6,
	spread_pitch = 1.5,
	num_pellets = 18,
	bullseye = false,
	num_spread_circles = 2,
	min_num_hits = {
		[armor_types.unarmored] = 9,
		[armor_types.armored] = 9,
		[armor_types.resistant] = 15,
		[armor_types.player] = 1,
		[armor_types.berserker] = 9,
		[armor_types.super_armor] = 6,
		[armor_types.disgustingly_resilient] = 9
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.shotgun_p1_m3_killshot
		}
	}
}
shotshell_templates.shotgun_p4_m1_hip = {
	spread_yaw = 5.2,
	range = 100,
	pellets_per_frame = 5,
	no_random_roll = true,
	scatter_range = 0.035,
	spread_pitch = 5.2,
	roll_offset = 0.25,
	num_pellets = 13,
	bullseye = true,
	num_spread_circles = 6,
	min_num_hits = {
		[armor_types.unarmored] = 7,
		[armor_types.armored] = 7,
		[armor_types.resistant] = 7,
		[armor_types.player] = 1,
		[armor_types.berserker] = 7,
		[armor_types.super_armor] = 4,
		[armor_types.disgustingly_resilient] = 6
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.shotgun_p4_m1
		}
	}
}
shotshell_templates.shotgun_p4_m1_ads = {
	spread_yaw = 2.3,
	range = 100,
	pellets_per_frame = 5,
	no_random_roll = true,
	scatter_range = 0.03,
	spread_pitch = 2.3,
	roll_offset = 0.25,
	num_pellets = 13,
	bullseye = true,
	num_spread_circles = 6,
	min_num_hits = {
		[armor_types.unarmored] = 8,
		[armor_types.armored] = 8,
		[armor_types.resistant] = 8,
		[armor_types.player] = 1,
		[armor_types.berserker] = 8,
		[armor_types.super_armor] = 5,
		[armor_types.disgustingly_resilient] = 8
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.shotgun_p4_m1
		}
	}
}
shotshell_templates.shotgun_p4_m2_hip = {
	spread_yaw = 2.3,
	range = 100,
	pellets_per_frame = 12,
	scatter_range = 0.15,
	spread_pitch = 2.3,
	num_pellets = 21,
	bullseye = false,
	num_spread_circles = 2,
	min_num_hits = {
		[armor_types.unarmored] = 7,
		[armor_types.armored] = 7,
		[armor_types.resistant] = 10,
		[armor_types.player] = 1,
		[armor_types.berserker] = 7,
		[armor_types.super_armor] = 8,
		[armor_types.disgustingly_resilient] = 7
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.shotgun_p4_m2
		}
	}
}
shotshell_templates.shotgun_p4_m2_ads = {
	spread_yaw = 1.5,
	range = 100,
	pellets_per_frame = 6,
	spread_pitch = 1.5,
	num_pellets = 18,
	bullseye = false,
	num_spread_circles = 2,
	min_num_hits = {
		[armor_types.unarmored] = 9,
		[armor_types.armored] = 9,
		[armor_types.resistant] = 9,
		[armor_types.player] = 1,
		[armor_types.berserker] = 9,
		[armor_types.super_armor] = 8,
		[armor_types.disgustingly_resilient] = 9
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.shotgun_p4_m2
		}
	}
}
shotshell_templates.shotgun_p4_m3_hip = {
	spread_yaw = 5,
	range = 100,
	pellets_per_frame = 5,
	no_random_roll = true,
	scatter_range = 0.035,
	spread_pitch = 5,
	roll_offset = 0.25,
	num_pellets = 13,
	bullseye = true,
	num_spread_circles = 6,
	min_num_hits = {
		[armor_types.unarmored] = 4,
		[armor_types.armored] = 4,
		[armor_types.resistant] = 8,
		[armor_types.player] = 1,
		[armor_types.berserker] = 4,
		[armor_types.super_armor] = 5,
		[armor_types.disgustingly_resilient] = 8
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.shotgun_p4_m3
		}
	}
}
shotshell_templates.shotgun_p4_m3_ads = {
	spread_yaw = 4.5,
	range = 100,
	pellets_per_frame = 5,
	no_random_roll = true,
	scatter_range = 0.035,
	spread_pitch = 4.5,
	roll_offset = 0.25,
	num_pellets = 13,
	bullseye = true,
	num_spread_circles = 6,
	min_num_hits = {
		[armor_types.unarmored] = 4,
		[armor_types.armored] = 4,
		[armor_types.resistant] = 8,
		[armor_types.player] = 1,
		[armor_types.berserker] = 4,
		[armor_types.super_armor] = 5,
		[armor_types.disgustingly_resilient] = 8
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.shotgun_p4_m3
		}
	}
}
shotshell_templates.shotpistol_shield = {
	spread_yaw = 1.6,
	range = 80,
	pellets_per_frame = 6,
	scatter_range = 0.13,
	spread_pitch = 2.1,
	roll_offset = 0.14,
	num_pellets = 16,
	bullseye = true,
	num_spread_circles = 2,
	min_num_hits = {
		[armor_types.unarmored] = 6,
		[armor_types.armored] = 6,
		[armor_types.resistant] = 7,
		[armor_types.player] = 1,
		[armor_types.berserker] = 7,
		[armor_types.super_armor] = 5,
		[armor_types.disgustingly_resilient] = 8
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.damage_shotpistol_shield_p1
		}
	}
}
shotshell_templates.rippergun_assault = {
	spread_yaw = 6,
	range = 75,
	pellets_per_frame = 10,
	spread_pitch = 5,
	num_pellets = 20,
	bullseye = true,
	num_spread_circles = 3,
	min_num_hits = {
		[armor_types.unarmored] = 5,
		[armor_types.armored] = 5,
		[armor_types.resistant] = 5,
		[armor_types.player] = 1,
		[armor_types.berserker] = 5,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 5
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_rippergun_assault
		}
	}
}
shotshell_templates.rippergun_spraynpray = {
	spread_yaw = 6,
	range = 75,
	pellets_per_frame = 10,
	spread_pitch = 5,
	num_pellets = 20,
	bullseye = true,
	num_spread_circles = 3,
	min_num_hits = {
		[armor_types.unarmored] = 5,
		[armor_types.armored] = 5,
		[armor_types.resistant] = 3,
		[armor_types.player] = 1,
		[armor_types.berserker] = 5,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 5
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_rippergun_snp
		}
	}
}

for name, template in pairs(shotshell_templates) do
	template.name = name
	template.same_side_suppression_enabled = false

	if template.damage.penetration then
		-- Nothing
	end
end

return settings("ShotshellTemplates", shotshell_templates)
