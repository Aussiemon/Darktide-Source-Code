local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local damage_types = DamageSettings.damage_types
local weapon_template = {
	action_inputs = {
		combat_ability = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					value = true,
					input = "combat_ability_pressed"
				}
			}
		}
	},
	action_input_hierarchy = {
		combat_ability = "base"
	},
	actions = {
		action_wield = {
			kind = "wield",
			allowed_during_sprint = true,
			uninterruptible = true,
			anim_event = "equip",
			total_time = 0.5,
			allowed_chain_actions = {
				combat_ability = {
					action_name = "combat_ability"
				}
			}
		},
		action_warp_charge_explode = {
			anim_event = "explode_warp_start",
			overload_type = "warp_charge",
			anim_end_event = "explode_finished",
			kind = "overload_explosion",
			death_on_explosion = true,
			total_time = 3,
			timeline_anims = {
				[0.933] = {
					anim_event_3p = "explode_warp_end",
					anim_event_1p = "explode_warp_end"
				}
			},
			explosion_template = ExplosionTemplates.warp_charge_overload,
			death_damage_profile = DamageProfileTemplates.warp_charge_exploding_tick,
			death_damage_type = damage_types.warp_overload,
			dot_settings = {
				power_level = 1000,
				damage_frequency = 0.8,
				damage_profile = DamageProfileTemplates.warp_charge_exploding_tick,
				damage_type = damage_types.warp_overload
			},
			allowed_chain_actions = {
				combat_ability = {
					action_name = "combat_ability"
				}
			}
		},
		combat_ability = {
			slot_to_wield = "slot_combat_ability",
			start_input = "combat_ability",
			uninterruptible = true,
			kind = "unwield_to_specific",
			total_time = 0,
			allowed_chain_actions = {}
		}
	},
	breed_anim_state_machine_3p = {
		human = "content/characters/player/human/third_person/animations/unarmed",
		ogryn = "content/characters/player/ogryn/third_person/animations/unarmed"
	},
	breed_anim_state_machine_1p = {
		human = "content/characters/player/human/first_person/animations/unarmed",
		ogryn = "content/characters/player/ogryn/first_person/animations/unarmed"
	},
	keywords = {
		"unarmed"
	},
	uses_ammunition = false,
	uses_overheat = false,
	crosshair = {
		crosshair_type = "ironsight"
	},
	sprint_ready_up_time = 0.1,
	max_first_person_anim_movement_speed = 5.8,
	fx_sources = {},
	dodge_template = "default",
	sprint_template = "default",
	stamina_template = "default",
	toughness_template = "default",
	breed_footstep_intervals = {
		human = FootstepIntervalsTemplates.unarmed_human,
		ogryn = FootstepIntervalsTemplates.unarmed_ogryn
	},
	archetype_warp_explode_action_override = "action_warp_charge_explode"
}

return weapon_template
