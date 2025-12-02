-- chunkname: @scripts/settings/equipment/weapon_templates/needlepistols/settings_templates/needlepistol_explosion_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local explosion_templates = {}
local overrides = {}

table.make_unique(explosion_templates)
table.make_unique(overrides)

explosion_templates.needlepistol_explosion = {
	close_radius = 0.55,
	collision_filter = "filter_player_character_explosion",
	damage_falloff = true,
	min_close_radius = 0.5,
	min_radius = 0.5,
	radius = 0.825,
	scalable_radius = false,
	sfx = nil,
	static_power_level = 500,
	vfx = nil,
	explosion_area_suppression = {
		distance = 0.01,
		suppression_value = 0.01,
	},
	close_damage_profile = DamageProfileTemplates.needlepistol_explosion_parent,
	close_damage_type = damage_types.boltshell,
	damage_profile = DamageProfileTemplates.needlepistol_explosion_parent,
	damage_type = damage_types.boltshell,
	broadphase_explosion_filter = {
		"heroes",
		"villains",
		"destructibles",
	},
}
overrides.needlepistol_explosion_1 = {
	parent_template_name = "needlepistol_explosion",
	overrides = {
		{
			"close_damage_profile",
			DamageProfileTemplates.needlepistol_explosion_1,
		},
		{
			"damage_profile",
			DamageProfileTemplates.needlepistol_explosion_1,
		},
		{
			"vfx",
			{
				"content/fx/particles/impacts/weapons/needlepistol/needlepistol_impact_primary_m2",
			},
		},
	},
}

return {
	base_templates = explosion_templates,
	overrides = overrides,
}
