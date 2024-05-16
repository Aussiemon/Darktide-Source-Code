-- chunkname: @scripts/settings/equipment/weapon_templates/thumpers/settings_templates/thumper_shotshell_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local armor_types = ArmorSettings.types
local shotshell_templates = {}
local overrides = {}

table.make_unique(shotshell_templates)
table.make_unique(overrides)

shotshell_templates.default_thumper_assault = {
	bullseye = true,
	num_pellets = 32,
	num_spread_circles = 3,
	pellets_per_frame = 10,
	range = 100,
	scatter_range = 0.15,
	spread_pitch = 4,
	spread_yaw = 8,
	min_num_hits = {
		[armor_types.unarmored] = 12,
		[armor_types.armored] = 10,
		[armor_types.resistant] = 10,
		[armor_types.player] = 1,
		[armor_types.berserker] = 12,
		[armor_types.super_armor] = 12,
		[armor_types.disgustingly_resilient] = 12,
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_ogryn_shotgun_assault,
		},
	},
}
shotshell_templates.default_thumper_assault_ads = {
	bullseye = true,
	num_pellets = 32,
	num_spread_circles = 3,
	pellets_per_frame = 10,
	range = 100,
	scatter_range = 0.15,
	spread_pitch = 2.5,
	spread_yaw = 5,
	min_num_hits = {
		[armor_types.unarmored] = 12,
		[armor_types.armored] = 10,
		[armor_types.resistant] = 10,
		[armor_types.player] = 1,
		[armor_types.berserker] = 12,
		[armor_types.super_armor] = 12,
		[armor_types.disgustingly_resilient] = 12,
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_ogryn_shotgun_assault,
		},
	},
}

return {
	base_templates = shotshell_templates,
	overrides = overrides,
}
