local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local armor_types = ArmorSettings.types
local shotshell_templates = {}
local overrides = {}

table.make_unique(shotshell_templates)
table.make_unique(overrides)

shotshell_templates.default_thumper_assault = {
	spread_yaw = 8,
	range = 100,
	pellets_per_frame = 10,
	scatter_range = 0.15,
	spread_pitch = 4,
	num_pellets = 32,
	bullseye = true,
	num_spread_circles = 3,
	min_num_hits = {
		[armor_types.unarmored] = 10,
		[armor_types.armored] = 10,
		[armor_types.resistant] = 10,
		[armor_types.player] = 1,
		[armor_types.berserker] = 10,
		[armor_types.super_armor] = 10,
		[armor_types.disgustingly_resilient] = 10
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_ogryn_shotgun_assault
		}
	}
}

return {
	base_templates = shotshell_templates,
	overrides = overrides
}
