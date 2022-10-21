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
