local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {
	action_inputs = {
		charge_power = {
			buffer_time = 0.31,
			max_queue = 1,
			input_sequence = {
				{
					value = true,
					input = "action_two_hold"
				}
			}
		},
		charge_power_release = {
			buffer_time = 0.31,
			max_queue = 1,
			input_sequence = {
				{
					value = false,
					input = "action_two_hold",
					time_window = math.huge
				}
			}
		},
		charge_power_sticky = {
			buffer_time = 0.31,
			max_queue = 1,
			input_sequence = {
				{
					value = true,
					input = "action_one_hold"
				}
			}
		},
		charge_power_lock_on = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = true,
					input = "action_one_hold"
				}
			}
		},
		charge_power_sticky_release = {
			buffer_time = 0.31,
			max_queue = 1,
			input_sequence = {
				{
					value = false,
					input = "action_one_hold",
					time_window = math.huge
				}
			}
		},
		use_power = {
			buffer_time = 0.7,
			input_sequence = {
				{
					value = true,
					input = "none"
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
		},
		charge = {
			buffer_time = 0,
			input_sequence = {
				{
					value = true,
					input = "action_two_hold"
				}
			}
		},
		wield = {
			buffer_time = 0.5,
			clear_input_queue = true,
			input_sequence = {
				{
					inputs = wield_inputs
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
		inspect_start = {
			buffer_time = 0,
			input_sequence = {
				{
					value = true,
					input = "weapon_inspect_hold"
				},
				{
					value = true,
					duration = 0.2,
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
		}
	}
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	wield = "stay",
	combat_ability = "stay",
	charge_power = {
		wield = "base",
		charge_power_release = "base",
		combat_ability = "base",
		charge_power_lock_on = {
			wield = "base",
			use_power = "base",
			combat_ability = "base",
			charge_power_sticky_release = "base"
		}
	},
	charge_power_sticky = {
		wield = "base",
		use_power = "base",
		combat_ability = "base",
		charge_power_sticky_release = "base"
	},
	vent = {
		wield = "base",
		vent_release = "base",
		combat_ability = "base"
	},
	inspect_start = {
		inspect_stop = "base"
	}
}

table.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
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
	action_vent = {
		allowed_during_sprint = true,
		start_input = "vent",
		vent_source_name = "fx_left_hand",
		kind = "vent_warp_charge",
		prevent_sprint = true,
		vent_vfx = "content/fx/particles/abilities/psyker_venting",
		additional_vent_vfx = "content/fx/particles/abilities/psyker_venting_2",
		additional_vent_source_name = "fx_right_hand",
		anim_end_event = "vent_end",
		vo_tag = "ability_venting",
		abort_sprint = true,
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
				modifier = 0.3,
				t = 0.15
			},
			{
				modifier = 0.2,
				t = 0.2
			},
			{
				modifier = 0.01,
				t = 5
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
	},
	action_charge_target_sticky = {
		start_input = "charge_power_sticky",
		target_finder_module_class_name = "psyker_smite_targeting",
		kind = "smite_targeting",
		sprint_ready_up_time = 0.25,
		kill_charge = true,
		sticky_targeting = true,
		allowed_during_sprint = false,
		ability_type = "grenade_ability",
		target_charge = true,
		minimum_hold_time = 0.3,
		target_locked = true,
		anim_end_event = "attack_charge_cancel",
		attack_target_time = 1,
		charge_template = "psyker_smite_lock_target",
		overload_module_class_name = "warp_charge",
		charge_time = 2,
		attack_target = true,
		uninterruptible = true,
		anim_event = "attack_charge",
		stop_input = "charge_power_sticky_release",
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
		targeting_fx = {
			wwise_parameter_name = "charge_level",
			wwise_event_stop = "wwise/events/weapon/stop_force_staff_single_target",
			has_husk_events = true,
			wwise_event_start = "wwise/events/weapon/play_force_staff_single_target",
			husk_effect_name = "content/fx/particles/weapons/force_staff/force_staff_channel_charge",
			effect_name = "content/fx/particles/weapons/force_staff/force_staff_channel_charge"
		},
		charge_effects = {
			sfx_source_name = "_charge",
			looping_sound_alias = "ranged_charging",
			looping_effect_alias = "ranged_charging",
			vfx_source_name = "_charge"
		},
		smart_targeting_template = SmartTargetingTemplates.smite,
		running_action_state_to_action_input = {
			fully_charged = {
				input_name = "use_power"
			}
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			use_power = {
				action_name = "action_use_power"
			}
		},
		attack_settings = {
			damage_profile = DamageProfileTemplates.psyker_smite_stagger
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			if end_reason == "hold_input_released" or end_reason == "stunned" then
				return true
			end

			return false
		end
	},
	action_charge_target = {
		overload_module_class_name = "warp_charge",
		charge_template = "psyker_smite_charge",
		target_finder_module_class_name = "psyker_smite_targeting",
		start_input = "charge_power",
		kind = "smite_targeting",
		sprint_ready_up_time = 0.25,
		kill_charge = true,
		allowed_during_sprint = false,
		ability_type = "grenade_ability",
		anim_end_event = "attack_charge_cancel",
		target_charge = true,
		minimum_hold_time = 0.3,
		anim_event = "attack_charge",
		uninterruptible = true,
		always_charge = true,
		stop_input = "charge_power_release",
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
		targeting_fx = {
			wwise_parameter_name = "charge_level",
			wwise_event_stop = "wwise/events/weapon/stop_force_staff_single_target",
			has_husk_events = true,
			wwise_event_start = "wwise/events/weapon/play_force_staff_single_target",
			husk_effect_name = "content/fx/particles/weapons/force_staff/force_staff_channel_charge",
			effect_name = "content/fx/particles/weapons/force_staff/force_staff_channel_charge"
		},
		charge_effects = {
			sfx_source_name = "_charge",
			looping_sound_alias = "ranged_charging",
			looping_effect_alias = "ranged_charging",
			vfx_source_name = "_charge"
		},
		smart_targeting_template = SmartTargetingTemplates.smite,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			charge_power_lock_on = {
				action_name = "action_charge_target_lock_on"
			}
		},
		attack_settings = {
			damage_profile = DamageProfileTemplates.psyker_smite_stagger
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			if end_reason == "hold_input_released" or end_reason == "stunned" then
				return true
			end

			return false
		end
	},
	action_charge_target_lock_on = {
		charge_template = "psyker_smite_lock_target",
		target_finder_module_class_name = "psyker_smite_targeting",
		start_input = "charge_power_lock_on",
		kind = "smite_targeting",
		sprint_ready_up_time = 0.25,
		kill_charge = true,
		only_allowed_with_smite_target = true,
		allowed_during_sprint = false,
		ability_type = "grenade_ability",
		overload_module_class_name = "warp_charge",
		target_missing_anim_event = "attack_charge_cancel",
		target_locked = true,
		anim_end_event = "attack_charge_cancel",
		attack_target_time = 0.25,
		sticky_targeting = true,
		attack_target = true,
		uninterruptible = true,
		dont_reset_charge = true,
		stop_input = "charge_power_sticky_release",
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
		targeting_fx = {
			wwise_parameter_name = "charge_level",
			wwise_event_stop = "wwise/events/weapon/stop_force_staff_single_target",
			has_husk_events = true,
			wwise_event_start = "wwise/events/weapon/play_force_staff_single_target",
			husk_effect_name = "content/fx/particles/weapons/force_staff/force_staff_channel_charge",
			effect_name = "content/fx/particles/weapons/force_staff/force_staff_channel_charge"
		},
		charge_effects = {
			sfx_source_name = "_charge",
			looping_sound_alias = "ranged_charging",
			looping_effect_alias = "ranged_charging",
			vfx_source_name = "_charge"
		},
		smart_targeting_template = SmartTargetingTemplates.smite,
		running_action_state_to_action_input = {
			fully_charged = {
				input_name = "use_power"
			}
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			use_power = {
				action_name = "action_use_power"
			}
		},
		attack_settings = {
			damage_profile = DamageProfileTemplates.psyker_smite_stagger
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			if end_reason == "hold_input_released" or end_reason == "stunned" then
				return true
			end

			return false
		end
	},
	action_use_power = {
		use_charge = true,
		uninterruptible = true,
		kind = "damage_target",
		sprint_ready_up_time = 0.25,
		use_charge_level = true,
		fire_time = 0.2,
		charge_template = "psyker_smite_use_power",
		allowed_during_sprint = false,
		anim_event = "attack_charge_shoot",
		total_time = 1,
		action_movement_curve = {
			{
				modifier = 0.25,
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
			start_modifier = 0.2
		},
		damage_profile = DamageProfileTemplates.psyker_smite_kill,
		damage_type = damage_types.smite,
		suppression_settings = {
			suppression_falloff = true,
			instant_aggro = true,
			distance = 5,
			suppression_value = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			wield = {
				action_name = "action_unwield"
			}
		}
	},
	action_inspect = {
		skip_3p_anims = true,
		lock_view = true,
		start_input = "inspect_start",
		anim_end_event = "inspect_end",
		kind = "inspect",
		crosshair_type = "none",
		anim_event = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge
	}
}
weapon_template.keywords = {
	"psyker"
}
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/psyker_smite",
	ogryn = "content/characters/player/ogryn/third_person/animations/unarmed"
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/psyker_smite",
	ogryn = "content/characters/player/ogryn/first_person/animations/unarmed"
}
weapon_template.alternate_fire_settings = {
	start_anim_event = "attack_charge",
	stop_anim_event = "attack_charge_cancel",
	spread_template = "psyker_smite",
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
	}
}
weapon_template.spread_template = "psyker_smite"
weapon_template.ammo_template = "no_ammo"
weapon_template.psyker_smite = true
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
weapon_template.smart_targeting_template = SmartTargetingTemplates.smite
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.crosshair_type = "charge_up"
weapon_template.hit_marker_type = "center"
weapon_template.fx_sources = {
	_muzzle = "fx_right",
	_charge = "fx_charge"
}
weapon_template.dodge_template = "default_ranged"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.warp_charge_template = "psyker_smite"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.hud_icon = "content/ui/materials/icons/throwables/hud/smite"

weapon_template.action_none_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not current_action_name or current_action_name == "none"
end

weapon_template.overheated_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	local player_unit = player.player_unit
	local unit_data_ext = ScriptUnit.extension(player_unit, "unit_data_system")
	local warp_charge = unit_data_ext:read_component("warp_charge")
	local has_warp_charge = warp_charge.current_percentage >= 0.1

	return has_warp_charge
end

weapon_template.action_two_charging_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_charge_target"
end

weapon_template.action_two_charged_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	local player_unit = player.player_unit
	local unit_data_ext = ScriptUnit.extension(player_unit, "unit_data_system")
	local action_module_charge_component = unit_data_ext:read_component("action_module_charge")
	local fully_charged = action_module_charge_component.charge_level >= 0.95

	return current_action and current_action_name == "action_charge_target" and fully_charged
end

weapon_template.action_one_charging_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_charge_target_sticky" or current_action_name == "action_charge_target_lock_on"
end

return weapon_template
