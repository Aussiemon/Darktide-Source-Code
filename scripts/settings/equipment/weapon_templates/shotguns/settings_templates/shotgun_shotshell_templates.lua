local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local armor_types = ArmorSettings.types
local shotshell_templates = {}
local overrides = {}

table.make_unique(shotshell_templates)
table.make_unique(overrides)

shotshell_templates.default_shotgun_assault = {
	spread_yaw = 2.5,
	range = 100,
	pellets_per_frame = 6,
	scatter_range = 0.2,
	spread_pitch = 2.5,
	num_pellets = 13,
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
shotshell_templates.shotgun_cleaving_special = {
	spread_yaw = 6.5,
	range = 100,
	pellets_per_frame = 5,
	no_random_roll = true,
	scatter_range = 0.02,
	spread_pitch = 6.5,
	roll_offset = 0.25,
	num_pellets = 13,
	bullseye = true,
	num_spread_circles = 6,
	min_num_hits = {
		[armor_types.unarmored] = 8,
		[armor_types.armored] = 5,
		[armor_types.resistant] = 6,
		[armor_types.player] = 1,
		[armor_types.berserker] = 5,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 8
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.shotgun_cleaving_special
		}
	}
}
shotshell_templates.default_shotgun_killshot = {
	spread_yaw = 1,
	range = 100,
	pellets_per_frame = 6,
	spread_pitch = 1,
	num_pellets = 13,
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

return {
	base_templates = shotshell_templates,
	overrides = overrides
}
