-- chunkname: @scripts/settings/toughness/minion_toughness_templates.lua

local EffectTemplates = require("scripts/settings/fx/effect_templates")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local ToughnessSettings = require("scripts/settings/toughness/toughness_settings")
local template_types = ToughnessSettings.template_types
local toughness_templates = {}

toughness_templates.renegade_captain = {
	break_shield_when_depleted = true,
	linked_actor = "c_captain_void_shield",
	regeneration_delay = 6,
	regeneration_speed = 100,
	stagger_immune_while_active = true,
	template_type = template_types.minion,
	max = {
		6500,
		6500,
		8500,
		11000,
		13500,
	},
	regenerate_full_delay = {
		25,
		20,
		18,
		15,
		15,
	},
	max_hit_percent = {
		0.1,
		0.1,
		0.07,
		0.07,
		0.06,
	},
	effect_template = EffectTemplates.renegade_captain_void_shield,
	depleted_settings = {
		explosion_power_level = 500,
		stagger_strength_multiplier = 10,
		stagger_duration = {
			7,
			7,
			6,
			5,
			4,
		},
		stagger_type = StaggerSettings.stagger_types.shield_broken,
		max_health_loss_percent = {
			0.3,
			0.3,
			0.28,
			0.25,
			0.2,
		},
		explosion_template = ExplosionTemplates.renegade_captain_toughness_depleted,
	},
	reactivated_settings = {
		sfx = "wwise/events/minions/play_traitor_captain_shield_reactivate",
		vfx = "content/fx/particles/enemies/renegade_captain/renegade_captain_shield_regen",
	},
}
toughness_templates.cultist_captain = table.clone(toughness_templates.renegade_captain)
toughness_templates.twin_captain_one = {
	clamp_toughness_until_condition = "remove_toughness_clamp",
	ignore_flickering_on_depleted = true,
	ignore_stagger_on_damage = true,
	linked_actor = "c_captain_void_shield",
	regeneration_delay = 6,
	regeneration_speed = 0,
	stagger_immune_while_active = true,
	start_depleted = true,
	template_type = template_types.minion,
	max = {
		5000,
		6000,
		8000,
		10000,
		12000,
	},
	regenerate_full_delay = {
		30000,
		30000,
		30000,
		30000,
		30000,
	},
	max_hit_percent = {
		0.5,
		0.5,
		0.5,
		0.5,
		0.5,
	},
	effect_template = EffectTemplates.renegade_captain_void_shield,
	depleted_settings = {
		explosion_power_level = 500,
		set_toughness_broke_behavior = true,
		stagger_strength_multiplier = 10,
		stagger_duration = {
			7,
			7,
			6,
			5,
			4,
		},
		stagger_type = StaggerSettings.stagger_types.shield_broken,
		explosion_template = ExplosionTemplates.renegade_captain_toughness_depleted,
	},
	reactivated_settings = {
		sfx = "wwise/events/minions/play_traitor_captain_shield_reactivate",
		vfx = "content/fx/particles/enemies/renegade_captain/renegade_captain_shield_regen",
	},
}

return settings("MinionToughnessTemplates", toughness_templates)
