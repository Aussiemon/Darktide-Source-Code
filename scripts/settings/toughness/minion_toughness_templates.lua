local EffectTemplates = require("scripts/settings/fx/effect_templates")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local ToughnessSettings = require("scripts/settings/toughness/toughness_settings")
local template_types = ToughnessSettings.template_types
local toughness_templates = {
	renegade_captain = {
		regeneration_delay = 8,
		regeneration_speed = 100,
		linked_actor = "c_captain_void_shield",
		regenerate_full_delay = 17.5,
		max_hit_percent = 0.075,
		template_type = template_types.minion,
		max = {
			2000,
			3000,
			4500,
			6000,
			7500
		},
		effect_template = EffectTemplates.renegade_captain_void_shield,
		depleted_settings = {
			stagger_strength_multiplier = 10,
			explosion_power_level = 500,
			stagger_duration = 4,
			max_health_loss_percent = 0.35,
			stagger_type = StaggerSettings.stagger_types.shield_broken,
			explosion_template = ExplosionTemplates.renegade_captain_toughness_depleted
		},
		reactivated_settings = {
			sfx = "wwise/events/minions/play_traitor_captain_shield_reactivate",
			vfx = "content/fx/particles/enemies/renegade_captain/renegade_captain_shield_regen"
		}
	}
}

return settings("MinionToughnessTemplates", toughness_templates)
