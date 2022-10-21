local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {
	action_inputs = {
		wield = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					inputs = wield_inputs
				}
			}
		}
	}
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	wield = "stay"
}

table.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
	action_wield = {
		continue_sprinting = true,
		allowed_during_sprint = true,
		kind = "wield",
		uninterruptible = true,
		anim_event = "equip",
		total_time = 0.5,
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			}
		}
	},
	action_unwield = {
		continue_sprinting = true,
		allowed_during_sprint = true,
		start_input = "wield",
		uninterruptible = true,
		kind = "unwield",
		total_time = 0,
		allowed_chain_actions = {}
	},
	action_warp_charge_explode = {
		death_on_explosion = true,
		anim_end_event = "explode_finished",
		kind = "overload_explosion",
		anim_event = "explode_warp_start",
		total_time = 3,
		timeline_anims = {
			[0.933] = {
				anim_event_3p = "explode_warp_end",
				anim_event_1p = "explode_warp_end"
			}
		},
		explosion_template = ExplosionTemplates.plasma_rifle_overheat,
		death_damage_profile = DamageProfileTemplates.overheat_exploding_tick,
		death_damage_type = damage_types.laser,
		dot_settings = {
			power_level = 1000,
			damage_frequency = 0.8,
			damage_profile = DamageProfileTemplates.overheat_exploding_tick,
			damage_type = damage_types.laser
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			}
		}
	}
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/unarmed",
	ogryn = "content/characters/player/ogryn/third_person/animations/unarmed"
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/unarmed",
	ogryn = "content/characters/player/ogryn/first_person/animations/unarmed"
}
weapon_template.keywords = {
	"unarmed"
}
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {}
weapon_template.archetype_warp_explode_action_override = "action_warp_charge_explode"
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.breed_footstep_intervals = {
	human = FootstepIntervalsTemplates.unarmed_human,
	ogryn = FootstepIntervalsTemplates.unarmed_ogryn
}
weapon_template.hide_slot = true

return weapon_template
