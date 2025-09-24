-- chunkname: @scripts/settings/equipment/weapon_templates/shotguns/settings_templates/shotgun_shotshell_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local armor_types = ArmorSettings.types
local damage_types = DamageSettings.damage_types
local shotshell_templates = {}
local overrides = {}

table.make_unique(shotshell_templates)
table.make_unique(overrides)

shotshell_templates.default_shotgun_assault = {
	bullseye = true,
	num_pellets = 13,
	num_spread_circles = 2,
	pellets_per_frame = 6,
	range = 100,
	scatter_range = 0.2,
	spread_pitch = 2.5,
	spread_yaw = 2.5,
	min_num_hits = {
		[armor_types.unarmored] = 4,
		[armor_types.armored] = 4,
		[armor_types.resistant] = 6,
		[armor_types.player] = 1,
		[armor_types.berserker] = 5,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 8,
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_shotgun_assault,
		},
	},
}
shotshell_templates.default_shotgun_killshot = {
	bullseye = true,
	num_pellets = 13,
	num_spread_circles = 2,
	pellets_per_frame = 6,
	range = 100,
	spread_pitch = 1,
	spread_yaw = 1,
	min_num_hits = {
		[armor_types.unarmored] = 5,
		[armor_types.armored] = 6,
		[armor_types.resistant] = 15,
		[armor_types.player] = 1,
		[armor_types.berserker] = 5,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 5,
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_shotgun_killshot,
		},
	},
}
shotshell_templates.shotgun_cleaving_special = {
	bullseye = true,
	no_random_roll = true,
	num_pellets = 13,
	num_spread_circles = 6,
	pellets_per_frame = 5,
	range = 100,
	roll_offset = 0.25,
	scatter_range = 0.02,
	spread_pitch = 6.5,
	spread_yaw = 6.5,
	min_num_hits = {
		[armor_types.unarmored] = 8,
		[armor_types.armored] = 5,
		[armor_types.resistant] = 6,
		[armor_types.player] = 1,
		[armor_types.berserker] = 5,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 8,
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.shotgun_cleaving_special,
		},
	},
}
shotshell_templates.shotgun_slug_special = {
	bullseye = true,
	no_random_roll = true,
	num_pellets = 1,
	num_spread_circles = 1,
	pellets_per_frame = 6,
	range = 100,
	roll_offset = 0.1,
	scatter_range = 0.1,
	spread_pitch = 0.5,
	spread_yaw = 0.5,
	min_num_hits = {
		[armor_types.unarmored] = 1,
		[armor_types.armored] = 1,
		[armor_types.resistant] = 1,
		[armor_types.player] = 1,
		[armor_types.berserker] = 1,
		[armor_types.super_armor] = 1,
		[armor_types.disgustingly_resilient] = 1,
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.shotgun_slug_special,
			damage_type = damage_types.heavy_stubber_bullet,
		},
		penetration = {
			depth = 0.4,
			target_index_increase = 10,
		},
	},
}
shotshell_templates.shotgun_burninating_special = {
	bullseye = false,
	num_pellets = 18,
	num_spread_circles = 2,
	pellets_per_frame = 6,
	range = 100,
	spread_pitch = 3,
	spread_yaw = 6,
	min_num_hits = {
		[armor_types.unarmored] = 6,
		[armor_types.armored] = 6,
		[armor_types.resistant] = 6,
		[armor_types.player] = 1,
		[armor_types.berserker] = 6,
		[armor_types.super_armor] = 6,
		[armor_types.disgustingly_resilient] = 6,
	},
	damage = {
		impact = {
			buff_to_add = "flamer_assault",
			max_stack_per_attack = 6,
			max_stacks = 10,
			stacks_per_pellet = 0.45,
			damage_profile = DamageProfileTemplates.shotgun_assault_burninating,
			damage_type = damage_types.pellet_incendiary,
		},
	},
}
shotshell_templates.shotgun_burninating_special_killshot = {
	bullseye = false,
	num_pellets = 18,
	num_spread_circles = 2,
	pellets_per_frame = 6,
	range = 100,
	spread_pitch = 1.5,
	spread_yaw = 3,
	min_num_hits = {
		[armor_types.unarmored] = 6,
		[armor_types.armored] = 6,
		[armor_types.resistant] = 6,
		[armor_types.player] = 1,
		[armor_types.berserker] = 6,
		[armor_types.super_armor] = 6,
		[armor_types.disgustingly_resilient] = 6,
	},
	damage = {
		impact = {
			buff_to_add = "flamer_assault",
			max_stack_per_attack = 6,
			max_stacks = 10,
			stacks_per_pellet = 0.45,
			damage_profile = DamageProfileTemplates.shotgun_assault_burninating,
			damage_type = damage_types.pellet_incendiary,
		},
	},
}
shotshell_templates.default_shotgun_shotshell_p2 = {
	bullseye = true,
	num_pellets = 16,
	num_spread_circles = 8,
	pellets_per_frame = 4,
	range = 75,
	scatter_range = 0.5,
	spread_pitch = 3,
	spread_yaw = 7,
	min_num_hits = {
		[armor_types.unarmored] = 7,
		[armor_types.armored] = 6,
		[armor_types.resistant] = 8,
		[armor_types.player] = 1,
		[armor_types.berserker] = 7,
		[armor_types.super_armor] = 4,
		[armor_types.disgustingly_resilient] = 9,
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.shotgun_assault_p2,
		},
	},
}
shotshell_templates.special_shotgun_shotshell_p2 = {
	bullseye = true,
	num_pellets = 32,
	num_spread_circles = 8,
	pellets_per_frame = 8,
	range = 75,
	scatter_range = 2,
	spread_pitch = 5,
	spread_yaw = 10,
	min_num_hits = {
		[armor_types.unarmored] = 5,
		[armor_types.armored] = 3,
		[armor_types.resistant] = 5,
		[armor_types.player] = 1,
		[armor_types.berserker] = 4,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 10,
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.shotgun_assault_p2_special,
			{
				pellets_threshold = 0.5,
				damage_profile = DamageProfileTemplates.shotgun_assault_p2_special_high_gibbing,
			},
		},
	},
}
shotshell_templates.shotgun_p4_m2_hip_special = {
	bullseye = false,
	num_pellets = 24,
	num_spread_circles = 2,
	pellets_per_frame = 12,
	range = 100,
	scatter_range = 0.15,
	spread_pitch = 2.3,
	spread_yaw = 2.3,
	min_num_hits = {
		[armor_types.unarmored] = 9,
		[armor_types.armored] = 9,
		[armor_types.resistant] = 8,
		[armor_types.player] = 1,
		[armor_types.berserker] = 9,
		[armor_types.super_armor] = 6,
		[armor_types.disgustingly_resilient] = 9,
	},
	damage = {
		impact = {
			buff_to_add = "shotgun_special_rending_debuff",
			max_stack_per_attack = 1,
			max_stacks = 1,
			stacks_per_pellet = 0.5,
			damage_profile = DamageProfileTemplates.shotgun_p4_m2,
			damage_type = damage_types.pellet_shock,
		},
	},
}
shotshell_templates.shotgun_p4_m2_ads_special = {
	bullseye = false,
	num_pellets = 18,
	num_spread_circles = 2,
	pellets_per_frame = 6,
	range = 100,
	spread_pitch = 1.5,
	spread_yaw = 1.5,
	min_num_hits = {
		[armor_types.unarmored] = 9,
		[armor_types.armored] = 9,
		[armor_types.resistant] = 8,
		[armor_types.player] = 1,
		[armor_types.berserker] = 9,
		[armor_types.super_armor] = 6,
		[armor_types.disgustingly_resilient] = 9,
	},
	damage = {
		impact = {
			buff_to_add = "shotgun_special_rending_debuff",
			max_stack_per_attack = 1,
			max_stacks = 1,
			stacks_per_pellet = 0.5,
			damage_profile = DamageProfileTemplates.shotgun_p4_m2,
			damage_type = damage_types.pellet_shock,
		},
	},
}
shotshell_templates.shotgun_p4_m1_hip_special = {
	bullseye = true,
	no_random_roll = true,
	num_pellets = 13,
	num_spread_circles = 6,
	pellets_per_frame = 5,
	range = 100,
	roll_offset = 0.25,
	scatter_range = 0.035,
	spread_pitch = 6,
	spread_yaw = 6,
	min_num_hits = {
		[armor_types.unarmored] = 5,
		[armor_types.armored] = 6,
		[armor_types.resistant] = 8,
		[armor_types.player] = 1,
		[armor_types.berserker] = 4,
		[armor_types.super_armor] = 4,
		[armor_types.disgustingly_resilient] = 4,
	},
	damage = {
		impact = {
			buff_to_add = "shotgun_special_stun",
			max_stack_per_attack = 5,
			max_stacks = 5,
			stacks_per_pellet = 0.5,
			damage_profile = DamageProfileTemplates.shotgun_p4_m1,
			damage_type = damage_types.pellet_shock,
		},
	},
}
shotshell_templates.shotgun_p4_m1_ads_special = {
	bullseye = true,
	no_random_roll = true,
	num_pellets = 13,
	num_spread_circles = 6,
	pellets_per_frame = 5,
	range = 100,
	roll_offset = 0.25,
	scatter_range = 0.03,
	spread_pitch = 6,
	spread_yaw = 6,
	min_num_hits = {
		[armor_types.unarmored] = 9,
		[armor_types.armored] = 9,
		[armor_types.resistant] = 9,
		[armor_types.player] = 1,
		[armor_types.berserker] = 9,
		[armor_types.super_armor] = 6,
		[armor_types.disgustingly_resilient] = 9,
	},
	damage = {
		impact = {
			buff_to_add = "shotgun_special_stun",
			max_stack_per_attack = 32,
			max_stacks = 1,
			stacks_per_pellet = 0.5,
			damage_profile = DamageProfileTemplates.shotgun_p4_m1,
			damage_type = damage_types.pellet_shock,
		},
	},
}
shotshell_templates.default_shotpistol_shield_hip = {
	bullseye = true,
	no_random_roll = true,
	num_pellets = 11,
	num_spread_circles = 6,
	pellets_per_frame = 3,
	range = 40,
	roll_offset = 0.25,
	scatter_range = 0.2,
	spread_pitch = 3,
	spread_yaw = 7.5,
	min_num_hits = {
		[armor_types.unarmored] = 4,
		[armor_types.armored] = 4,
		[armor_types.resistant] = 6,
		[armor_types.player] = 1,
		[armor_types.berserker] = 5,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 8,
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.damage_shotpistol_shield_p1,
		},
	},
}
shotshell_templates.default_shotpistol_shield_ads = {
	bullseye = true,
	no_random_roll = true,
	num_pellets = 11,
	num_spread_circles = 6,
	pellets_per_frame = 3,
	range = 50,
	roll_offset = 0.25,
	scatter_range = 0.2,
	spread_pitch = 2.5,
	spread_yaw = 5.5,
	min_num_hits = {
		[armor_types.unarmored] = 5,
		[armor_types.armored] = 6,
		[armor_types.resistant] = 15,
		[armor_types.player] = 1,
		[armor_types.berserker] = 5,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 5,
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.damage_shotpistol_shield_p1,
		},
	},
}

return {
	base_templates = shotshell_templates,
	overrides = overrides,
}
