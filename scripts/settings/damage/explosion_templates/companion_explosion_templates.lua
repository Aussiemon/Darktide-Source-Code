-- chunkname: @scripts/settings/damage/explosion_templates/companion_explosion_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local explosion_templates = {
	companion_dog_pounced_explosion = {
		damage_falloff = false,
		radius = 2,
		min_radius = 1,
		scalable_radius = true,
		close_radius = 1,
		collision_filter = "filter_minion_explosion",
		min_close_radius = 0.5,
		close_damage_profile = DamageProfileTemplates.cyber_mastiff_push_close,
		damage_profile = DamageProfileTemplates.cyber_mastiff_push,
		broadphase_explosion_filter = {
			"heroes",
			"villains",
			"destructibles"
		}
	}
}

return explosion_templates
