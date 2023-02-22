local BuffSettings = require("scripts/settings/buff/buff_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local buff_keywords = BuffSettings.keywords
local special_rules = SpecialRulesSetting.special_rules
local wield_inputs = PlayerCharacterConstants.wield_inputs
local talent_settings = nil
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
		quick_target_self = {
			buffer_time = 0.3,
			max_queue = 1,
			input_sequence = {
				{
					value = false,
					input = "combat_ability_hold"
				}
			}
		},
		target_other = {
			buffer_time = 0.5,
			max_queue = 1,
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
			quick_target_self = "base",
			block_cancel = "base",
			target_other = "base"
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
			aim_ready_up_time = 0,
			start_input = "aim_pressed",
			kind = "target_ally",
			sprint_ready_up_time = 0,
			uninterruptible = true,
			abort_sprint = true,
			decal_unit_name = "content/fx/units/decal_dash",
			allowed_during_lunge = true,
			allowed_during_sprint = true,
			ability_type = "combat_ability",
			prevent_sprint = true,
			minimum_hold_time = 0.01,
			total_time = math.huge,
			smart_targeting_template = SmartTargetingTemplates.target_ally,
			allowed_chain_actions = {
				quick_target_self = {
					action_name = "action_buff_self",
					chain_time = 0
				},
				target_other = {
					action_name = "action_buff_target",
					chain_time = 0.1
				},
				block_cancel = {
					action_name = "action_unwield_to_previous"
				}
			}
		},
		action_buff_target = {
			coherency_buff_name = "zealot_preacher_shield_coherency",
			use_ability_charge = true,
			override_buff_name_two = "zealot_preacher_shield_melee_extends",
			gear_sound_alias = "zealot_preacher_cast_shield",
			kind = "buff_target",
			override_buff_name_one = "zealot_preacher_shield_long_duration",
			cast_time = 0.5,
			self_cast_anim_event = "cast_self",
			ability_type = "combat_ability",
			ally_anim_event = "cast_ally",
			use_charge_at_start = true,
			self_cast = false,
			vo_tag = "ability_banisher",
			buff_name = "zealot_preacher_shield",
			uninterruptible = true,
			prevent_sprint = true,
			total_time = 0.9,
			coherency_toughness = talent_settings and talent_settings.coop_1.toughness_percent_regenerated,
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
			coherency_buff_name = "zealot_preacher_shield_coherency",
			use_ability_charge = true,
			override_buff_name_two = "zealot_preacher_shield_melee_extends",
			gear_sound_alias = "zealot_preacher_cast_shield",
			kind = "buff_target",
			override_buff_name_one = "zealot_preacher_shield_long_duration",
			cast_time = 0,
			self_cast_anim_event = "cast_self",
			ability_type = "combat_ability",
			use_charge_at_start = true,
			self_cast = true,
			vo_tag = "ability_banisher",
			buff_name = "zealot_preacher_shield",
			uninterruptible = true,
			prevent_sprint = true,
			total_time = 0.9,
			coherency_toughness = talent_settings and talent_settings.coop_1.toughness_percent_regenerated,
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
			total_time = 0
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
	footstep_intervals = FootstepIntervalsTemplates.default
}

return weapon_template
