﻿-- chunkname: @scripts/settings/equipment/weapon_templates/grenades/psyker_chain_lightning.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {}
local chain_settings_spread = {
	radius = 5,
	max_jumps = 1,
	max_radius_stat_buff = "chain_lightning_max_radius",
	max_z_diff_stat_buff = "chain_lightning_max_z_diff",
	jump_time_multiplier_stat_buff = "chain_lightning_jump_time_multiplier",
	max_jumps_stat_buff = "chain_lightning_max_jumps",
	extra_angle_stat_buff = "chain_lightning_max_angle",
	jump_time = 0.3,
	staff = false,
	max_targets_at_time = {
		{
			num_targets = 1,
			t = 0
		},
		{
			num_targets = 2,
			t = 1
		},
		{
			num_targets = 3,
			t = 2
		}
	},
	max_jumps_at_time = {
		{
			num_jumps = 0,
			t = 0
		},
		{
			num_jumps = 1,
			t = 1.2
		},
		{
			num_jumps = 2,
			t = 1.8
		},
		{
			num_jumps = 3,
			t = 2.7
		}
	},
	max_angle = math.pi * 0.35
}
local chain_settings_spread_targeting = {
	radius = 15,
	staff = false,
	max_jumps = 0,
	max_radius_stat_buff = "chain_lightning_max_radius",
	jump_time_multiplier_stat_buff = "chain_lightning_jump_time_multiplier",
	max_jumps_stat_buff = "chain_lightning_max_jumps",
	extra_angle_stat_buff = "chain_lightning_max_angle",
	jump_time = 0.3,
	max_z_diff_stat_buff = "chain_lightning_max_z_diff",
	max_targets_at_time = {
		{
			num_targets = 1,
			t = 0
		},
		{
			num_targets = 2,
			t = 1
		},
		{
			num_targets = 3,
			t = 2
		}
	},
	max_angle = math.pi * 0.05
}
local chain_settings_spread_charge = {
	radius = 5,
	max_jumps = 1,
	max_radius_stat_buff = "chain_lightning_max_radius",
	max_z_diff_stat_buff = "chain_lightning_max_z_diff",
	jump_time_multiplier_stat_buff = "chain_lightning_jump_time_multiplier",
	max_jumps_stat_buff = "chain_lightning_max_jumps",
	extra_angle_stat_buff = "chain_lightning_max_angle",
	jump_time = 0.3,
	staff = false,
	max_targets_at_time = {
		{
			num_targets = 1,
			t = 0
		},
		{
			num_targets = 2,
			t = 0.15
		},
		{
			num_targets = 3,
			t = 0.3
		}
	},
	max_jumps_at_time = {
		{
			num_jumps = 0,
			t = 0
		},
		{
			num_jumps = 1,
			t = 0.4
		},
		{
			num_jumps = 2,
			t = 0.6
		},
		{
			num_jumps = 3,
			t = 0.9
		}
	},
	max_angle = math.pi * 0.35
}
local chain_settings_spread_charge_targeting = {
	radius = 15,
	staff = false,
	max_jumps = 0,
	max_radius_stat_buff = "chain_lightning_max_radius",
	jump_time_multiplier_stat_buff = "chain_lightning_jump_time_multiplier",
	max_jumps_stat_buff = "chain_lightning_max_jumps",
	extra_angle_stat_buff = "chain_lightning_max_angle",
	jump_time = 0.3,
	max_z_diff_stat_buff = "chain_lightning_max_z_diff",
	max_targets_at_time = {
		{
			num_targets = 1,
			t = 0
		},
		{
			num_targets = 2,
			t = 0.3
		},
		{
			num_targets = 3,
			t = 0.6
		}
	},
	max_angle = math.pi * 0.25
}

weapon_template.action_inputs = {
	shoot_light_pressed = {
		buffer_time = 0.2,
		input_sequence = {
			{
				value = true,
				input = "action_one_pressed"
			},
			{
				value = true,
				input = "action_one_hold"
			}
		}
	},
	shoot_light_hold_release = {
		buffer_time = 0.76,
		input_sequence = {
			{
				value = false,
				input = "action_one_hold",
				time_window = math.huge
			}
		}
	},
	charge_heavy = {
		buffer_time = 0.5,
		input_sequence = {
			{
				value = true,
				input = "action_two_hold"
			}
		}
	},
	charge_heavy_cancel = {
		buffer_time = 0.4,
		input_sequence = {
			{
				value = false,
				input = "action_two_hold"
			}
		}
	},
	shoot_heavy_hold = {
		buffer_time = 0.5,
		input_sequence = {
			{
				value = true,
				input = "action_one_pressed",
				time_window = math.huge
			},
			{
				value = true,
				input = "action_one_hold",
				time_window = math.huge
			}
		}
	},
	shoot_heavy_hold_release = {
		buffer_time = 0.76,
		input_sequence = {
			{
				inputs = {
					{
						value = false,
						input = "action_two_hold"
					},
					{
						value = false,
						input = "action_one_hold"
					}
				},
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
	force_vent = {
		clear_input_queue = true,
		buffer_time = 0
	},
	force_vent_release = {
		buffer_time = 0.8,
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
}
weapon_template.action_input_hierarchy = {
	{
		input = "charge_heavy",
		transition = {
			{
				input = "shoot_heavy_hold",
				transition = {
					{
						transition = "base",
						input = "shoot_heavy_hold_release"
					},
					{
						transition = "base",
						input = "wield"
					},
					{
						transition = "base",
						input = "combat_ability"
					},
					{
						transition = "base",
						input = "force_vent"
					}
				}
			},
			{
				transition = "base",
				input = "charge_heavy_cancel"
			},
			{
				transition = "base",
				input = "wield"
			},
			{
				transition = "base",
				input = "combat_ability"
			}
		}
	},
	{
		input = "shoot_light_pressed",
		transition = {
			{
				transition = "base",
				input = "shoot_light_hold_release"
			},
			{
				transition = "base",
				input = "wield"
			},
			{
				transition = "base",
				input = "combat_ability"
			},
			{
				transition = "base",
				input = "force_vent"
			}
		}
	},
	{
		input = "vent",
		transition = {
			{
				transition = "base",
				input = "vent_release"
			},
			{
				transition = "base",
				input = "wield"
			},
			{
				transition = "base",
				input = "combat_ability"
			}
		}
	},
	{
		input = "force_vent",
		transition = {
			{
				transition = "base",
				input = "force_vent_release"
			},
			{
				transition = "base",
				input = "wield"
			},
			{
				transition = "base",
				input = "combat_ability"
			}
		}
	},
	{
		input = "inspect_start",
		transition = {
			{
				transition = "base",
				input = "inspect_stop"
			}
		}
	},
	{
		transition = "stay",
		input = "wield"
	},
	{
		transition = "base",
		input = "combat_ability"
	}
}
weapon_template.actions = {
	action_unwield = {
		allowed_during_sprint = true,
		start_input = "wield",
		uninterruptible = true,
		kind = "unwield",
		total_time = 0,
		allowed_chain_actions = {}
	},
	action_wield = {
		kind = "wield",
		allowed_during_sprint = true,
		uninterruptible = true,
		anim_event = "equip_chainlightning",
		total_time = 0.5,
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			combat_ability = {
				action_name = "combat_ability"
			},
			shoot_light_pressed = {
				action_name = "action_spread",
				chain_time = 0.01
			},
			charge_heavy = {
				action_name = "action_charge",
				chain_time = 0.01
			},
			vent = {
				action_name = "action_vent"
			}
		}
	},
	action_spread = {
		kind = "chain_lightning",
		target_finder_module_class_name = "chain_lightning",
		start_input = "shoot_light_pressed",
		sprint_requires_press_to_interrupt = true,
		sprint_ready_up_time = 0.4,
		overload_module_class_name = "warp_charge",
		allowed_during_sprint = false,
		ability_type = "grenade_ability",
		minimum_hold_time = 0.35,
		target_buff = "psyker_protectorate_spread_chain_lightning_interval",
		improved_target_buff = "psyker_protectorate_spread_chain_lightning_interval_improved",
		anim_end_event = "attack_spread_damage",
		fire_time = 0.2,
		charge_template = "chain_lightning_ability_spread",
		anim_end_event_3p = "attack_shoot_right",
		no_damage_on_cleanup_on_chain_action_kind = "vent_warp_charge",
		keep_chain_data_to_next_action = false,
		anim_event = "attack_spread",
		stop_input = "shoot_light_hold_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.6,
				t = 0.2
			},
			{
				modifier = 0.5,
				t = 0.3
			},
			{
				modifier = 0.3,
				t = 0.6
			},
			start_modifier = 0.8
		},
		chain_lightning_link_effects = {
			power = "low"
		},
		running_action_state_to_action_input = {
			force_vent = {
				input_name = "force_vent"
			}
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			vent = {
				action_name = "action_vent"
			},
			force_vent = {
				action_name = "action_force_vent"
			}
		},
		fx = {
			fx_hand = "left",
			jump_sfx_alias = "ranged_single_shot_special_extra",
			looping_shoot_sfx_alias = "ranged_shooting"
		},
		charge_effects = {
			sfx_source_name = "_left",
			sfx_parameter = "charge_level",
			use_chain_jumping_as_charge = true
		},
		damage_profile = DamageProfileTemplates.psyker_protectorate_channel_chain_lightning_activated,
		damage_type = damage_types.electrocution,
		chain_settings = chain_settings_spread,
		chain_settings_targeting = chain_settings_spread_targeting
	},
	action_charge = {
		overload_module_class_name = "warp_charge",
		target_finder_module_class_name = "psyker_chain_lightning_single_targeting",
		charge_template = "chain_lightning_charge_heavy",
		kind = "overload_charge_target_finder",
		sprint_ready_up_time = 0,
		start_input = "charge_heavy",
		sprint_requires_press_to_interrupt = false,
		allowed_during_sprint = true,
		ability_type = "grenade_ability",
		target_missing_anim_event = "attack_charge_cancel",
		minimum_hold_time = 0.2,
		anim_end_event = "attack_charge_cancel",
		target_anim_event = "attack_charge_fast",
		anim_event = "attack_charge_fast",
		stop_input = "charge_heavy_cancel",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "charge_up"
		},
		action_movement_curve = {
			{
				modifier = 0.85,
				t = 0.2
			},
			{
				modifier = 0.84,
				t = 0.3
			},
			{
				modifier = 0.86,
				t = 0.5
			},
			{
				modifier = 0.87,
				t = 1.5
			},
			start_modifier = 0.8
		},
		smart_targeting_template = SmartTargetingTemplates.chain_lightning_single_target,
		charge_effects = {
			sfx_parameter = "charge_level",
			looping_effect_alias = "ranged_charging",
			looping_sound_alias = "ranged_charging",
			vfx_source_name = "_charge",
			sfx_source_name = "_charge",
			charge_done_source_name = "_charge",
			charge_done_effect_alias = "ranged_charging_done"
		},
		targeting_fx = {
			wwise_parameter_name = "charge_level",
			wwise_event_stop = "wwise/events/weapon/stop_psyker_lightning_bolt_target",
			has_husk_events = true,
			wwise_event_start = "wwise/events/weapon/play_psyker_lightning_bolt_target",
			husk_effect_name = "content/fx/particles/abilities/husk/husk_psyker_target_headpop",
			show_on_full_charge = true,
			target_node = "j_spine",
			effect_name = "content/fx/particles/abilities/chainlightning/protectorate_chainlightning_single_targeting"
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			shoot_heavy_hold = {
				action_name = "action_spread_charged",
				chain_time = 0.75
			},
			vent = {
				action_name = "action_vent"
			}
		},
		fx = {
			fx_hand = "right"
		},
		chain_settings_targeting = chain_settings_spread_charge_targeting
	},
	action_spread_charged = {
		sprint_requires_press_to_interrupt = true,
		target_finder_module_class_name = "chain_lightning",
		kind = "chain_lightning",
		sprint_ready_up_time = 0.4,
		allowed_during_sprint = false,
		overload_module_class_name = "warp_charge",
		ability_type = "grenade_ability",
		target_buff = "psyker_protectorate_spread_charged_chain_lightning_interval",
		minimum_hold_time = 0.75,
		improved_target_buff = "psyker_protectorate_spread_charged_chain_lightning_interval_improved",
		anim_end_event = "attack_spread_damage",
		fire_time = 0.2,
		charge_template = "chain_lightning_ability_spread",
		anim_end_event_3p = "attack_shoot_right",
		no_damage_on_cleanup_on_chain_action_kind = "vent_warp_charge",
		keep_chain_data_to_next_action = false,
		anim_event_3p = "attack_shoot",
		anim_event = "attack_charge_shoot",
		stop_input = "shoot_heavy_hold_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.6,
				t = 0.2
			},
			{
				modifier = 0.5,
				t = 0.3
			},
			{
				modifier = 0.3,
				t = 0.6
			},
			start_modifier = 0.8
		},
		chain_lightning_link_effects = {
			power = "high"
		},
		running_action_state_to_action_input = {
			force_vent = {
				input_name = "force_vent"
			}
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			vent = {
				action_name = "action_vent"
			},
			force_vent = {
				action_name = "action_force_vent"
			}
		},
		fx = {
			fx_hand = "right",
			jump_sfx_alias = "ranged_single_shot_special_extra",
			looping_shoot_sfx_alias = "ranged_braced_shooting"
		},
		charge_effects = {
			sfx_source_name = "_right",
			sfx_parameter = "charge_level",
			use_chain_jumping_as_charge = true
		},
		damage_profile = DamageProfileTemplates.psyker_protectorate_channel_chain_lightning_activated,
		damage_type = damage_types.electrocution,
		chain_settings = chain_settings_spread_charge,
		chain_settings_targeting = chain_settings_spread_charge_targeting
	},
	action_force_vent = {
		minimum_hold_time = 0.5,
		vent_vfx = "content/fx/particles/abilities/psyker_venting",
		anim_end_event = "vent_end",
		kind = "vent_warp_charge",
		vent_source_name = "fx_left_hand",
		vo_tag = "ability_venting",
		additional_vent_vfx = "content/fx/particles/abilities/psyker_venting_2",
		additional_vent_source_name = "fx_right_hand",
		anim_event_3p = "vent_start",
		uninterruptible = true,
		anim_event = "vent_force_start",
		stop_input = "force_vent_release",
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
	action_vent = {
		vent_source_name = "fx_left_hand",
		start_input = "vent",
		anim_end_event = "vent_end",
		kind = "vent_warp_charge",
		additional_vent_vfx = "content/fx/particles/abilities/psyker_venting_2",
		vo_tag = "ability_venting",
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
	},
	action_inspect = {
		skip_3p_anims = true,
		lock_view = true,
		start_input = "inspect_start",
		anim_end_event = "inspect_end",
		kind = "inspect",
		anim_event = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect"
		}
	}
}
weapon_template.keywords = {
	"psyker"
}
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/psyker_smite"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/chain_lightning"
weapon_template.spread_template = "no_spread"
weapon_template.ammo_template = "no_ammo"
weapon_template.psyker_smite = true
weapon_template.hud_configuration = {
	uses_overheat = false,
	uses_ammunition = false
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.crosshair = {
	crosshair_type = "dot"
}
weapon_template.hit_marker_type = "center"
weapon_template.fx_sources = {
	_left = "fx_left",
	_charge = "fx_charge",
	_both = "fx_both",
	_right = "fx_right"
}
weapon_template.chain_settings = {
	right_fx_source_name = "_right",
	left_fx_source_name = "_left"
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.hud_icon = "content/ui/materials/icons/throwables/hud/chain_lightning"

weapon_template.action_none_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not current_action_name or current_action_name == "none"
end

weapon_template.overheated_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	local player_unit = player.player_unit
	local unit_data_ext = ScriptUnit.extension(player_unit, "unit_data_system")
	local warp_charge = unit_data_ext:read_component("warp_charge")
	local has_warp_charge = warp_charge.current_percentage >= 0.1

	return has_warp_charge and weapon_template.action_none_screen_ui_validation(wielded_slot_id, item, current_action, current_action_name, player)
end

weapon_template.action_two_charging_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_charge"
end

weapon_template.action_one_charging_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_spread"
end

weapon_template.action_two_firing_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_spread_charged"
end

return weapon_template
