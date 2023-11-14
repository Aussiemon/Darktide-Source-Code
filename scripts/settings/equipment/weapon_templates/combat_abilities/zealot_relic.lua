local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
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
		},
		combat_ability = {
			buffer_time = 0
		},
		channel = {
			buffer_time = 0.2,
			input_sequence = {
				{
					value = true,
					input = "combat_ability_pressed"
				}
			}
		},
		wield_previous = {
			buffer_time = 1,
			clear_input_queue = true,
			input_sequence = {
				{
					value = true,
					input = "combat_ability_pressed"
				}
			}
		},
		grenade_ability = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					value = true,
					input = "grenade_ability_pressed"
				}
			}
		},
		cancel_channeling = {
			buffer_time = 0.2,
			input_sequence = {
				{
					value = true,
					input = "action_two_pressed"
				}
			}
		}
	},
	action_input_hierarchy = {
		wield = "stay",
		wield_previous = "stay",
		channel = {
			cancel_channeling = "base",
			wield = "base",
			wield_previous = "base",
			grenade_ability = {
				wield_previous = "base"
			}
		}
	},
	actions = {
		action_unwield = {
			allowed_during_sprint = true,
			start_input = "wield",
			uninterruptible = true,
			kind = "unwield",
			total_time = 0,
			allowed_chain_actions = {}
		},
		action_wield = {
			sprint_requires_press_to_interrupt = true,
			allowed_during_sprint = true,
			kind = "wield",
			abort_sprint = true,
			uninterruptible = true,
			anim_event = "equip_relic",
			total_time = 0.5,
			allowed_chain_actions = {
				channel = {
					action_name = "action_zealot_channel"
				},
				grenade_ability = {
					{
						action_name = "grenade_ability"
					},
					{
						action_name = "grenade_ability_quick_throw"
					}
				}
			},
			conditional_state_to_action_input = {
				auto_chain = {
					input_name = "channel"
				}
			}
		},
		action_zealot_channel = {
			kind = "zealot_channel",
			radius = 10,
			start_input = "channel",
			force_stagger_duration = 2,
			sprint_requires_press_to_interrupt = true,
			power_level_time_in_action_multiplier = 0.25,
			offensive_buff = "zealot_channel_damage",
			defensive_buff = "zealot_channel_toughness_damage_reduction",
			force_stagger_radius = 4,
			toughness_bonus_buff = "zealot_channel_toughness_bonus",
			radius_time_in_action_multiplier = 0.1,
			allowed_during_sprint = true,
			ability_type = "combat_ability",
			add_buff_time = 4,
			vo_tag = "ability_litany",
			abort_sprint = true,
			uninterruptible = true,
			power_level = 500,
			stop_input = "cancel_channeling",
			total_time = 5.5,
			damage_profile = DamageProfileTemplates.zealot_channel_stagger,
			allowed_chain_actions = {
				wield = {
					action_name = "action_unwield",
					chain_time = 0.5
				},
				cancel_channeling = {
					action_name = "action_unwield_to_previous",
					chain_time = 0.5
				},
				wield_previous = {
					action_name = "action_unwield_to_previous"
				},
				grenade_ability = {
					{
						action_name = "grenade_ability"
					},
					{
						action_name = "grenade_ability_quick_throw"
					}
				}
			},
			conditional_state_to_action_input = {
				auto_chain = {
					input_name = "wield_previous"
				}
			}
		},
		action_unwield_to_previous = {
			allowed_during_sprint = true,
			start_input = "wield_previous",
			uninterruptible = true,
			kind = "unwield_to_previous",
			unwield_to_weapon = true,
			total_time = 0,
			allowed_chain_actions = {}
		}
	}
}
weapon_template.actions.grenade_ability_quick_throw = table.clone_instance(BaseTemplateSettings.actions.grenade_ability_quick_throw)
weapon_template.actions.grenade_ability_quick_throw.conditional_state_to_action_input = {
	auto_chain = {
		input_name = "wield_previous"
	}
}
weapon_template.actions.grenade_ability_quick_throw.allowed_chain_actions = {
	wield_previous = {
		action_name = "action_unwield_to_previous"
	}
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.keywords = {}
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "combat_ability_charges_left",
		input_name = "channel"
	},
	{
		conditional_state = "no_combat_ability_charges_left",
		input_name = "wield_previous"
	},
	{
		conditional_state = "no_running_action",
		input_name = "wield_previous"
	}
}
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/pocketables"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/preacher_relic"
weapon_template.spread_template = "no_spread"
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.crosshair = {
	crosshair_type = "dot"
}
weapon_template.hit_marker_type = "center"
weapon_template.fx_sources = {
	_emit = "fx_emit"
}
weapon_template.vfx = {
	name = "content/fx/particles/abilities/zealot_relic_pulse_activate"
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default

return weapon_template
