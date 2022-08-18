local BuffSettings = require("scripts/settings/buff/buff_settings")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local buff_keywords = BuffSettings.keywords
local special_rules = SpecialRulesSetting.special_rules
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {
	action_inputs = {
		aim_pressed = {
			buffer_time = 0.2,
			input_sequence = {
				{
					value = true,
					input = "combat_ability_pressed"
				}
			}
		},
		light_attack = {
			buffer_time = 0.3,
			max_queue = 1,
			input_sequence = {
				{
					value = false,
					time_window = 0.1,
					input = "combat_ability_hold"
				}
			}
		},
		heavy_attack = {
			buffer_time = 0.5,
			max_queue = 1,
			input_sequence = {
				{
					value = true,
					duration = 0.2,
					input = "combat_ability_hold"
				},
				{
					value = false,
					time_window = 1.5,
					input = "combat_ability_hold"
				}
			}
		},
		buff_target = {
			buffer_time = 0.6,
			input_sequence = {
				{
					value = true,
					input = "action_one_pressed"
				}
			}
		},
		wield = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					inputs = wield_inputs
				}
			}
		},
		unwield_to_previous = {
			buffer_time = 0
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
		block_cancel = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = true,
					hold_input = "combat_ability_hold",
					input = "action_two_pressed"
				}
			}
		}
	},
	action_input_hierarchy = {
		grenade_ability = "stay",
		wield = "stay",
		unwield_to_previous = "stay",
		aim_pressed = {
			heavy_attack = "base",
			block_cancel = "base",
			light_attack = "base"
		}
	},
	actions = {
		action_wield = {
			kind = "wield",
			uninterruptible = true,
			anim_event = "equip",
			total_time = 0.1,
			conditional_state_to_action_input = {
				auto_chain = {
					input_name = "aim_pressed"
				}
			},
			allowed_chain_actions = {
				aim_pressed = {
					action_name = "action_aim"
				}
			}
		},
		action_aim = {
			start_input = "aim_pressed",
			kind = "target_ally",
			sprint_ready_up_time = 0,
			uninterruptible = true,
			decal_unit_name = "content/fx/units/decal_dash",
			allowed_during_lunge = true,
			allowed_during_sprint = true,
			ability_type = "combat_ability",
			aim_ready_up_time = 0,
			minimum_hold_time = 0.01,
			total_time = math.huge,
			smart_targeting_template = SmartTargetingTemplates.target_ally,
			allowed_chain_actions = {
				light_attack = {
					action_name = "action_buff_self",
					chain_time = 0
				},
				heavy_attack = {
					action_name = "action_buff_target",
					chain_time = 0.1
				},
				block_cancel = {
					action_name = "action_unwield_to_previous"
				}
			}
		},
		action_buff_target = {
			self_cast = false,
			allowed_during_sprint = false,
			cast_time = 0.5,
			kind = "buff_target",
			override_buff_name = "zealot_preacher_shield_long_duration",
			buff_name = "zealot_preacher_shield",
			self_cast_anim_event = "cast_self",
			coherency_buff_name = "zealot_preacher_shield_coherency",
			use_ability_charge = true,
			uninterruptible = true,
			ability_type = "combat_ability",
			ally_anim_event = "cast_ally",
			total_time = 0.9,
			action_movement_curve = {
				{
					modifier = 0.4,
					t = 0.1
				},
				{
					modifier = 0.6,
					t = 0.2
				},
				{
					modifier = 0.8,
					t = 0.3
				},
				{
					modifier = 1,
					t = 0.4
				},
				start_modifier = 0.3
			},
			conditional_state_to_action_input = {
				auto_chain = {
					input_name = "unwield_to_previous"
				}
			},
			allowed_chain_actions = {
				unwield_to_previous = {
					action_name = "action_unwield_to_previous"
				}
			}
		},
		action_buff_self = {
			self_cast = true,
			allowed_during_sprint = false,
			cast_time = 0,
			kind = "buff_target",
			override_buff_name = "zealot_preacher_shield_long_duration",
			buff_name = "zealot_preacher_shield",
			self_cast_anim_event = "cast_self",
			coherency_buff_name = "zealot_preacher_shield_coherency",
			use_ability_charge = true,
			uninterruptible = true,
			ability_type = "combat_ability",
			total_time = 0.9,
			action_movement_curve = {
				{
					modifier = 0.4,
					t = 0.1
				},
				{
					modifier = 0.6,
					t = 0.2
				},
				{
					modifier = 0.8,
					t = 0.3
				},
				{
					modifier = 1,
					t = 0.4
				},
				start_modifier = 0.3
			},
			conditional_state_to_action_input = {
				auto_chain = {
					input_name = "unwield_to_previous"
				}
			},
			allowed_chain_actions = {
				unwield_to_previous = {
					action_name = "action_unwield_to_previous"
				}
			}
		},
		action_unwield_to_previous = {
			allowed_during_sprint = true,
			uninterruptible = true,
			kind = "unwield_to_previous",
			unwield_to_weapon = true,
			total_time = 0,
			allowed_chain_actions = {}
		}
	},
	keywords = {
		"psyker"
	},
	conditional_state_to_action_input = {
		{
			conditional_state = "no_running_action",
			input_name = "unwield_to_previous"
		}
	},
	anim_state_machine_3p = "content/characters/player/human/third_person/animations/chain_lightning",
	anim_state_machine_1p = "content/characters/player/human/first_person/animations/preacher_relic",
	spread_template = "no_spread",
	uses_ammunition = false,
	uses_overheat = false,
	sprint_ready_up_time = 0.1,
	max_first_person_anim_movement_speed = 5.8,
	crosshair_type = "cross",
	hit_marker_type = "center",
	fx_sources = {},
	dodge_template = "default",
	sprint_template = "default",
	stamina_template = "default",
	toughness_template = "default",
	footstep_intervals = {
		crouch_walking = 0.61,
		walking = 0.4,
		sprinting = 0.37
	}
}

return weapon_template
