-- chunkname: @scripts/settings/equipment/weapon_templates/needlepistols/settings_templates/needlepistol_hitscan_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local hitscan_templates = {}
local overrides = {}

table.make_unique(hitscan_templates)
table.make_unique(overrides)

hitscan_templates.default_needlepistol_dart = {
	range = 75,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_needlepistol_dart,
		},
	},
}
hitscan_templates.alternate_needlepistol_dart = {
	range = 75,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.alternate_needlepistol_dart,
		},
	},
}
hitscan_templates.flame_needlepistol_dart = {
	range = 75,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.flamer_needlepistol_dart,
		},
	},
}
hitscan_templates.stun_needlepistol_dart = {
	range = 75,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.stun_needlepistol_dart,
		},
	},
}
hitscan_templates.needlepistol_dart_aoe = {
	range = 75,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_needlepistol_dart,
			hitmass_consumed_explosion = {
				kill_explosion_template = ExplosionTemplates.needlepistol_explosion_1,
				stop_explosion_template = ExplosionTemplates.needlepistol_explosion_1,
			},
		},
		penetration = {
			depth = 0.001,
			target_index_increase = 1,
			stop_explosion_template = ExplosionTemplates.needlepistol_explosion_1,
		},
	},
}

return {
	base_templates = hitscan_templates,
	overrides = overrides,
}
