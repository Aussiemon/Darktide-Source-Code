-- chunkname: @scripts/settings/equipment/weapon_templates/phosphor_pistol/settings_templates/phosphor_pistol_explosion_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local explosion_templates = {}
local overrides = {}

table.make_unique(explosion_templates)
table.make_unique(overrides)

explosion_templates.phosphor_pistol_backblast = {
	collision_filter = "filter_player_character_explosion",
	damage_falloff = true,
	on_hit_buff_template_name = "phosphor_burn",
	radius = 1.1,
	scalable_radius = false,
	sfx = nil,
	static_power_level = 500,
	vfx_rotation = "attack_direction",
	damage_profile = DamageProfileTemplates.phosphor_pistol_backblast_explosion,
	close_damage_profile = DamageProfileTemplates.phosphor_pistol_backblast_explosion,
	damage_type = damage_types.phosphor,
	close_damage_type = damage_types.phosphor,
	broadphase_explosion_filter = {
		"villains",
	},
	vfx = {
		"content/fx/particles/weapons/pistols/phosphorpistol/phosphor_pistol_impact_blast",
	},
	explosion_area_suppression = {
		distance = 4,
		suppression_value = 5,
	},
}

return {
	base_templates = explosion_templates,
	overrides = overrides,
}
