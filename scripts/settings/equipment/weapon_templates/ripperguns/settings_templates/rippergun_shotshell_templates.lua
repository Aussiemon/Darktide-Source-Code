-- chunkname: @scripts/settings/equipment/weapon_templates/ripperguns/settings_templates/rippergun_shotshell_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local armor_types = ArmorSettings.types
local shotshell_templates = {}
local overrides = {}

table.make_unique(shotshell_templates)
table.make_unique(overrides)

shotshell_templates.default_rippergun_assault = {
	bullseye = true,
	num_pellets = 21,
	num_spread_circles = 3,
	pellets_per_frame = 10,
	range = 75,
	spread_pitch = 3.5,
	spread_yaw = 4,
	min_num_hits = {
		[armor_types.unarmored] = 5,
		[armor_types.armored] = 5,
		[armor_types.resistant] = 5,
		[armor_types.player] = 1,
		[armor_types.berserker] = 5,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 5,
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_rippergun_assault,
		},
	},
}
shotshell_templates.default_rippergun_snp = {
	bullseye = true,
	num_pellets = 21,
	num_spread_circles = 3,
	pellets_per_frame = 10,
	range = 75,
	spread_pitch = 3.5,
	spread_yaw = 4,
	min_num_hits = {
		[armor_types.unarmored] = 5,
		[armor_types.armored] = 5,
		[armor_types.resistant] = 4,
		[armor_types.player] = 1,
		[armor_types.berserker] = 5,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 5,
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_rippergun_snp,
		},
	},
}
shotshell_templates.rippergun_p1_m2_assault = {
	bullseye = true,
	num_pellets = 7,
	num_spread_circles = 2,
	pellets_per_frame = 10,
	range = 100,
	spread_pitch = 1.5,
	spread_yaw = 2,
	min_num_hits = {
		[armor_types.unarmored] = 5,
		[armor_types.armored] = 5,
		[armor_types.resistant] = 5,
		[armor_types.player] = 1,
		[armor_types.berserker] = 5,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 5,
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.rippergun_p1_m2_assault,
		},
	},
}
shotshell_templates.rippergun_p1_m2_snp = {
	bullseye = true,
	num_pellets = 7,
	num_spread_circles = 2,
	pellets_per_frame = 10,
	range = 100,
	spread_pitch = 1.5,
	spread_yaw = 2,
	min_num_hits = {
		[armor_types.unarmored] = 3,
		[armor_types.armored] = 3,
		[armor_types.resistant] = 2,
		[armor_types.player] = 1,
		[armor_types.berserker] = 3,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 3,
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.rippergun_p1_m2_assault,
		},
	},
}
shotshell_templates.rippergun_p1_m3_assault = {
	bullseye = true,
	num_pellets = 5,
	num_spread_circles = 1,
	pellets_per_frame = 10,
	range = 100,
	roll_offset = 0.125,
	spread_pitch = 1.5,
	spread_yaw = 3,
	min_num_hits = {
		[armor_types.unarmored] = 2,
		[armor_types.armored] = 2,
		[armor_types.resistant] = 2,
		[armor_types.player] = 1,
		[armor_types.berserker] = 2,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 2,
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.rippergun_p1_m2_assault,
		},
	},
}
shotshell_templates.rippergun_p1_m3_snp = {
	bullseye = true,
	no_random_roll = true,
	num_pellets = 5,
	num_spread_circles = 2,
	pellets_per_frame = 10,
	range = 100,
	roll_offset = 0.25,
	scatter_range = 0.075,
	spread_pitch = 3,
	spread_yaw = 3,
	min_num_hits = {
		[armor_types.unarmored] = 2,
		[armor_types.armored] = 2,
		[armor_types.resistant] = 2,
		[armor_types.player] = 1,
		[armor_types.berserker] = 2,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 2,
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.rippergun_p1_m2_assault,
		},
	},
}

return {
	base_templates = shotshell_templates,
	overrides = overrides,
}
