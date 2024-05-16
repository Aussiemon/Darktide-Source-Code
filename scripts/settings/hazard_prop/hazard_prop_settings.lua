-- chunkname: @scripts/settings/hazard_prop/hazard_prop_settings.lua

local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local hazard_prop_settings = {}

hazard_prop_settings.explosion_settings = {
	charge_level = 1,
	power_level = 500,
	explosion_template = ExplosionTemplates.explosive_barrel,
	attack_type = AttackSettings.attack_types.ranged,
}
hazard_prop_settings.fire_settings = {
	charge_level = 1,
	power_level = 500,
	raycast_distance = 5,
	explosion_template = ExplosionTemplates.fire_barrel,
	liquid_area_template = LiquidAreaTemplates.prop_fire,
	attack_type = AttackSettings.attack_types.ranged,
}
hazard_prop_settings.hazard_state = table.enum("idle", "triggered", "exploding", "broken")
hazard_prop_settings.hazard_content = table.enum("undefined", "none", "fire", "explosion", "gas")
hazard_prop_settings.material = {
	empty_il = "content/environment/gameplay/hazard_prop/materials/hazard_il_intact",
	empty_paint = "content/environment/gameplay/hazard_prop/materials/hazard_metal_intact",
	explosion_il = "content/environment/gameplay/hazard_prop/materials/hazard_il_explosion",
	explosion_paint = "content/environment/gameplay/hazard_prop/materials/hazard_metal_explosion",
	fire_il = "content/environment/gameplay/hazard_prop/materials/hazard_il_fire",
	fire_paint = "content/environment/gameplay/hazard_prop/materials/hazard_metal_fire",
	gas_il = "content/environment/gameplay/hazard_prop/materials/hazard_il_gas",
	gas_paint = "content/environment/gameplay/hazard_prop/materials/hazard_metal_gas",
}
hazard_prop_settings.intact_colliders = {
	barrel = {
		"c_intact",
		"c_intact_destructible",
	},
	sphere = {
		"c_intact",
		"c_dynamic_cable_01_static_intact",
		"c_dynamic_cable_02_intact",
		"c_dynamic_cable_03_intact",
		"c_intact_destructible",
	},
}
hazard_prop_settings.broken_colliders = {
	barrel = {
		"c_broken",
		"c_broken_destructible",
	},
	sphere = {
		"c_broken",
	},
}

return settings("HazardPropSettings", hazard_prop_settings)
