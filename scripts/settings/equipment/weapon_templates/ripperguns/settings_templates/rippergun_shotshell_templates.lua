-- chunkname: @scripts/settings/equipment/weapon_templates/ripperguns/settings_templates/rippergun_shotshell_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local armor_types = ArmorSettings.types
local shotshell_templates = {}
local overrides = {}

table.make_unique(shotshell_templates)
table.make_unique(overrides)

shotshell_templates.default_rippergun_assault = {
	spread_yaw = 4,
	range = 75,
	pellets_per_frame = 10,
	spread_pitch = 3.5,
	num_pellets = 21,
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
shotshell_templates.default_rippergun_snp = {
	spread_yaw = 4,
	range = 75,
	pellets_per_frame = 10,
	spread_pitch = 3.5,
	num_pellets = 21,
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
			damage_profile = DamageProfileTemplates.default_rippergun_snp
		}
	}
}
shotshell_templates.rippergun_p1_m2_assault = {
	spread_yaw = 2,
	range = 100,
	pellets_per_frame = 10,
	spread_pitch = 1.5,
	num_pellets = 7,
	bullseye = true,
	num_spread_circles = 2,
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
			damage_profile = DamageProfileTemplates.rippergun_p1_m2_assault
		}
	}
}
shotshell_templates.rippergun_p1_m2_snp = {
	spread_yaw = 2,
	range = 100,
	pellets_per_frame = 10,
	spread_pitch = 1.5,
	num_pellets = 7,
	bullseye = true,
	num_spread_circles = 2,
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
			damage_profile = DamageProfileTemplates.rippergun_p1_m2_assault
		}
	}
}
shotshell_templates.rippergun_p1_m3_assault = {
	spread_yaw = 3,
	range = 100,
	pellets_per_frame = 10,
	spread_pitch = 1.5,
	roll_offset = 0.125,
	num_pellets = 7,
	bullseye = true,
	num_spread_circles = 1,
	min_num_hits = {
		[armor_types.unarmored] = 3,
		[armor_types.armored] = 3,
		[armor_types.resistant] = 3,
		[armor_types.player] = 1,
		[armor_types.berserker] = 3,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 3
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.rippergun_p1_m3_assault
		}
	}
}
shotshell_templates.rippergun_p1_m3_snp = {
	spread_yaw = 2,
	range = 100,
	pellets_per_frame = 10,
	no_random_roll = true,
	scatter_range = 0.045,
	spread_pitch = 2,
	roll_offset = 0.25,
	num_pellets = 7,
	bullseye = true,
	num_spread_circles = 3,
	min_num_hits = {
		[armor_types.unarmored] = 3,
		[armor_types.armored] = 3,
		[armor_types.resistant] = 3,
		[armor_types.player] = 1,
		[armor_types.berserker] = 3,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 3
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.rippergun_p1_m3_assault
		}
	}
}

return {
	base_templates = shotshell_templates,
	overrides = overrides
}
