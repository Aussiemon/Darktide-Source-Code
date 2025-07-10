-- chunkname: @scripts/settings/damage/explosion_templates/companion_explosion_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local explosion_templates = {
	companion_dog_pounced_explosion = {
		close_radius = 1,
		collision_filter = "filter_minion_explosion",
		damage_falloff = false,
		min_close_radius = 0.5,
		min_radius = 1,
		radius = 2,
		scalable_radius = true,
		close_damage_profile = DamageProfileTemplates.cyber_mastiff_push_close,
		damage_profile = DamageProfileTemplates.cyber_mastiff_push_aoe,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles",
		},
	},
}

return explosion_templates
