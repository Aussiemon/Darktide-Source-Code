local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {
	action_inputs = {
		fast_charge = {
			buffer_time = 0.5,
			input_sequence = {
				{
					value = true,
					input = "action_one_pressed"
				}
			}
		},
		fast_charge_cancel = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = true,
					hold_input = "action_one_hold",
					input = "action_two_pressed"
				}
			}
		},
		shoot_fast = {
			buffer_time = 0.5,
			input_sequence = {
				{
					value = false,
					input = "action_one_hold",
					time_window = math.huge
				}
			}
		},
		charge = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = true,
					input = "action_two_hold"
				}
			}
		},
		charge_cancel = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = false,
					input = "action_two_hold",
					time_window = math.huge
				}
			}
		},
		shoot_charged = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = true,
					hold_input = "action_two_hold",
					input = "action_one_pressed"
				}
			}
		},
		shoot_charged_release = {
			buffer_time = 0.2,
			input_sequence = {
				{
					value = true,
					input = "action_one_release"
				}
			}
		},
		vent = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					value = true,
					input = "weapon_reload_hold"
				}
			}
		},
		vent_release = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = false,
					input = "weapon_reload_hold",
					time_window = math.huge
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
		inspect_start = {
			buffer_time = 0,
			input_sequence = {
				{
					value = true,
					input = "weapon_inspect_hold"
				}
			}
		},
		inspect_stop = {
			buffer_time = 0.02,
			input_sequence = {
				{
					value = false,
					input = "weapon_inspect_hold",
					time_window = math.huge
				}
			}
		},
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
		wield = "stay",
		combat_ability = "base",
		fast_charge = {
			fast_charge_cancel = "base",
			wield = "base",
			combat_ability = "base",
			shoot_fast = "base"
		},
		charge = {
			wield = "base",
			charge_cancel = "base",
			combat_ability = "base",
			shoot_charged = {
				shoot_charged_release = "base",
				wield = "base",
				combat_ability = "base"
			}
		},
		vent = {
			wield = "base",
			vent_release = "base",
			combat_ability = "base"
		},
		inspect_start = {
			inspect_stop = "base"
		}
	},
	actions = {
		action_unwield = {
			continue_sprinting = true,
			allowed_during_sprint = true,
			start_input = "wield",
			uninterruptible = true,
			kind = "unwield",
			total_time = 0,
			allowed_chain_actions = {}
		},
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
				combat_ability = {
					action_name = "combat_ability"
				}
			}
		},
		action_charge_fast = {
			target_anim_event = "attack_charge_fast",
			start_input = "fast_charge",
			target_finder_module_class_name = "chain_lightning",
			overload_module_class_name = "warp_charge",
			kind = "overload_target_finder",
			sprint_ready_up_time = 0.4,
			anim_end_event = "attack_charge_cancel",
			allowed_during_sprint = true,
			ability_type = "grenade_ability",
			target_missing_anim_event = "attack_charge_cancel",
			charge_template = "chain_lightning_charge_fast",
			anim_event = "attack_charge_fast",
			stop_input = "fast_charge_cancel",
			total_time = math.huge,
			action_movement_curve = {
				{
					modifier = 0.5,
					t = 0.2
				},
				{
					modifier = 0.4,
					t = 0.3
				},
				{
					modifier = 1,
					t = 0.5
				},
				start_modifier = 0.8
			},
			charge_effects = {
				sfx_source_name = "_right",
				looping_sound_alias = "ranged_charging",
				looping_effect_alias = "ranged_charging",
				vfx_source_name = "_right"
			},
			allowed_chain_actions = {
				combat_ability = {
					action_name = "combat_ability"
				},
				wield = {
					action_name = "action_unwield"
				},
				shoot_fast = {
					action_name = "action_shoot_fast",
					chain_time = 0.4
				},
				vent = {
					action_name = "action_vent"
				}
			},
			conditional_state_to_action_input = {
				auto_chain = {
					input_name = "shoot_fast"
				}
			},
			fx = {
				fx_hand = "right"
			}
		},
		action_shoot_fast = {
			overload_module_class_name = "warp_charge",
			sprint_requires_press_to_interrupt = true,
			kind = "chain_lightning",
			charge_template = "chain_lightning_attack_fast",
			anim_event = "attack_shoot",
			ability_type = "grenade_ability",
			uninterruptible = true,
			target_finder_module_class_name = "chain_lightning",
			anim_time_scale = 1,
			total_time = 0.5,
			action_movement_curve = {
				{
					modifier = 0.5,
					t = 0.2
				},
				{
					modifier = 0.4,
					t = 0.3
				},
				{
					modifier = 1,
					t = 0.5
				},
				start_modifier = 0.8
			},
			allowed_chain_actions = {
				wield = {
					action_name = "action_unwield"
				}
			},
			fx = {
				looping_shoot_sfx_alias = "ranged_shooting",
				fx_hand = "right"
			},
			damage_profile = DamageProfileTemplates.psyker_protectorate_chain_lighting_fast,
			damage_type = damage_types.electrocution,
			chain_settings = {
				max_targets = 2,
				radius = 5,
				jump_time = 0.05,
				max_jumps = 1,
				max_angle = math.pi * 0.15
			}
		},
		action_charge = {
			target_anim_event = "attack_charge",
			target_finder_module_class_name = "chain_lightning",
			start_input = "charge",
			kind = "overload_target_finder",
			sprint_ready_up_time = 0.4,
			overload_module_class_name = "warp_charge",
			anim_end_event = "attack_charge_cancel",
			allowed_during_sprint = true,
			ability_type = "grenade_ability",
			target_missing_anim_event = "attack_charge_cancel",
			charge_template = "chain_lightning_charge",
			anim_event = "attack_charge",
			stop_input = "charge_cancel",
			total_time = math.huge,
			action_movement_curve = {
				{
					modifier = 0.5,
					t = 0.2
				},
				{
					modifier = 0.4,
					t = 0.3
				},
				{
					modifier = 1,
					t = 0.5
				},
				start_modifier = 0.8
			},
			charge_effects = {
				sfx_source_name = "_both",
				looping_sound_alias = "ranged_charging",
				looping_effect_alias = "ranged_charging",
				vfx_source_name = "_right"
			},
			finish_reason_to_action_input = {
				stunned = {
					input_name = "shoot_charged"
				}
			},
			allowed_chain_actions = {
				combat_ability = {
					action_name = "combat_ability"
				},
				wield = {
					action_name = "action_unwield"
				},
				shoot_charged = {
					action_name = "action_shoot_charged",
					chain_time = 0.5
				},
				vent = {
					action_name = "action_vent"
				}
			},
			fx = {
				fx_hand = "both"
			}
		},
		action_shoot_charged = {
			overload_module_class_name = "warp_charge",
			target_finder_module_class_name = "chain_lightning",
			stop_time = 2.1,
			sprint_requires_press_to_interrupt = true,
			shoot_at_time = 0.2,
			anim_event = "attack_charge_shoot",
			anim_end_event = "attack_finished",
			ability_type = "grenade_ability",
			kind = "chain_lightning",
			anim_time_scale = 1,
			charge_template = "chain_lightning_attack",
			uninterruptible = true,
			stop_input = "shoot_charged_release",
			total_time = math.huge,
			action_movement_curve = {
				{
					modifier = 0.5,
					t = 0.2
				},
				{
					modifier = 0.4,
					t = 0.3
				},
				{
					modifier = 1,
					t = 0.5
				},
				start_modifier = 0.8
			},
			running_action_state_to_action_input = {
				stop_time_reached = {
					input_name = "shoot_charged_release"
				}
			},
			allowed_chain_actions = {
				wield = {
					action_name = "action_unwield"
				}
			},
			fx = {
				looping_shoot_sfx_alias = "ranged_braced_shooting",
				fx_hand = "both"
			},
			damage_profile = DamageProfileTemplates.psyker_protectorate_chain_lighting,
			damage_type = damage_types.electrocution,
			chain_settings = {
				max_targets = 3,
				radius = 4,
				jump_time = 0.1,
				max_jumps = 3,
				max_angle = math.pi * 0.25
			}
		},
		action_vent = {
			priority = 0,
			start_input = "vent",
			anim_end_event = "vent_end",
			kind = "vent_warp_charge",
			vent_source_name = "fx_left_hand",
			vo_tag = "ability_venting",
			additional_vent_vfx = "content/fx/particles/abilities/psyker_venting_2",
			additional_vent_source_name = "fx_right_hand",
			vent_vfx = "content/fx/particles/abilities/psyker_venting",
			uninterruptible = true,
			anim_event = "vent_start",
			stop_input = "vent_release",
			total_time = math.huge,
			action_movement_curve = {
				{
					modifier = 0.4,
					t = 0.1
				},
				{
					modifier = 0.4,
					t = 0.15
				},
				{
					modifier = 0.6,
					t = 0.2
				},
				{
					modifier = 0.4,
					t = 1
				},
				start_modifier = 1
			},
			running_action_state_to_action_input = {
				fully_vented = {
					input_name = "vent_release"
				}
			},
			allowed_chain_actions = {
				combat_ability = {
					action_name = "combat_ability"
				},
				wield = {
					action_name = "action_unwield",
					chain_time = 0.15
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
	keywords = {
		"psyker"
	},
	anim_state_machine_3p = "content/characters/player/human/third_person/animations/chain_lightning",
	anim_state_machine_1p = "content/characters/player/human/first_person/animations/chain_lightning",
	alternate_fire_settings = {
		crosshair_type = "dot",
		stop_anim_event = "to_unaim_ironsight",
		start_anim_event = "to_ironsight",
		spread_template = "no_spread",
		action_movement_curve = {
			{
				modifier = 0.3,
				t = 0.1
			},
			{
				modifier = 0.3,
				t = 0.15
			},
			{
				modifier = 0.6,
				t = 0.25
			},
			{
				modifier = 0.6,
				t = 0.5
			},
			{
				modifier = 0.4,
				t = 1
			},
			{
				modifier = 0.3,
				t = 2
			},
			start_modifier = 1
		},
		camera = {
			custom_vertical_fov = 45,
			vertical_fov = 45,
			near_range = 0.025
		}
	},
	spread_template = "no_spread",
	ammo_template = "no_ammo",
	psyker_smite = true,
	uses_ammunition = false,
	uses_overheat = false,
	sprint_ready_up_time = 0.1,
	max_first_person_anim_movement_speed = 5.8,
	crosshair_type = "charge_up",
	hit_marker_type = "center",
	fx_sources = {
		_left = "fx_left",
		_charge = "fx_right",
		_both = "fx_both",
		_right = "fx_right"
	},
	chain_settings = {
		right_fx_source_name = "_right",
		left_fx_source_name = "_left",
		right_fx_source_name_is_base_unit = false,
		left_fx_source_name_is_base_unit = false
	},
	dodge_template = "default",
	sprint_template = "default",
	stamina_template = "default",
	toughness_template = "default",
	footstep_intervals = FootstepIntervalsTemplates.default,
	action_none_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
		return not current_action_name or current_action_name == "none"
	end
}

weapon_template.overheated_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	local player_unit = player.player_unit
	local unit_data_ext = ScriptUnit.extension(player_unit, "unit_data_system")
	local warp_charge = unit_data_ext:read_component("warp_charge")
	local has_warp_charge = warp_charge.current_percentage >= 0.1

	return has_warp_charge
end

weapon_template.action_one_charging_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_charge_fast"
end

weapon_template.action_two_charging_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_charge"
end

weapon_template.action_two_firing_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_shoot_charged"
end

return weapon_template
