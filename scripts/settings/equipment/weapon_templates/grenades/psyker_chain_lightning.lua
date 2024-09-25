-- chunkname: @scripts/settings/equipment/weapon_templates/grenades/psyker_chain_lightning.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {}
local chain_settings_spread = {
	extra_angle_stat_buff = "chain_lightning_max_angle",
	jump_time = 0.3,
	jump_time_multiplier_stat_buff = "chain_lightning_jump_time_multiplier",
	max_jumps = 1,
	max_jumps_stat_buff = "chain_lightning_max_jumps",
	max_radius_stat_buff = "chain_lightning_max_radius",
	max_z_diff_stat_buff = "chain_lightning_max_z_diff",
	radius = 5,
	staff = false,
	max_targets_at_time = {
		{
			num_targets = 1,
			t = 0,
		},
		{
			num_targets = 2,
			t = 1,
		},
		{
			num_targets = 3,
			t = 2,
		},
	},
	max_jumps_at_time = {
		{
			num_jumps = 0,
			t = 0,
		},
		{
			num_jumps = 1,
			t = 1.2,
		},
		{
			num_jumps = 2,
			t = 1.8,
		},
		{
			num_jumps = 3,
			t = 2.7,
		},
	},
	max_angle = math.pi * 0.35,
}
local chain_settings_spread_targeting = {
	extra_angle_stat_buff = "chain_lightning_max_angle",
	jump_time = 0.3,
	jump_time_multiplier_stat_buff = "chain_lightning_jump_time_multiplier",
	max_jumps = 0,
	max_jumps_stat_buff = "chain_lightning_max_jumps",
	max_radius_stat_buff = "chain_lightning_max_radius",
	max_z_diff_stat_buff = "chain_lightning_max_z_diff",
	radius = 15,
	staff = false,
	max_targets_at_time = {
		{
			num_targets = 1,
			t = 0,
		},
		{
			num_targets = 2,
			t = 1,
		},
		{
			num_targets = 3,
			t = 2,
		},
	},
	max_angle = math.pi * 0.05,
}
local chain_settings_spread_charge = {
	extra_angle_stat_buff = "chain_lightning_max_angle",
	jump_time = 0.3,
	jump_time_multiplier_stat_buff = "chain_lightning_jump_time_multiplier",
	max_jumps = 1,
	max_jumps_stat_buff = "chain_lightning_max_jumps",
	max_radius_stat_buff = "chain_lightning_max_radius",
	max_z_diff_stat_buff = "chain_lightning_max_z_diff",
	radius = 5,
	staff = false,
	max_targets_at_time = {
		{
			num_targets = 1,
			t = 0,
		},
		{
			num_targets = 2,
			t = 0.15,
		},
		{
			num_targets = 3,
			t = 0.3,
		},
	},
	max_jumps_at_time = {
		{
			num_jumps = 0,
			t = 0,
		},
		{
			num_jumps = 1,
			t = 0.4,
		},
		{
			num_jumps = 2,
			t = 0.6,
		},
		{
			num_jumps = 3,
			t = 0.9,
		},
	},
	max_angle = math.pi * 0.35,
}
local chain_settings_spread_charge_targeting = {
	extra_angle_stat_buff = "chain_lightning_max_angle",
	jump_time = 0.3,
	jump_time_multiplier_stat_buff = "chain_lightning_jump_time_multiplier",
	max_jumps = 0,
	max_jumps_stat_buff = "chain_lightning_max_jumps",
	max_radius_stat_buff = "chain_lightning_max_radius",
	max_z_diff_stat_buff = "chain_lightning_max_z_diff",
	radius = 15,
	staff = false,
	max_targets_at_time = {
		{
			num_targets = 1,
			t = 0,
		},
		{
			num_targets = 2,
			t = 0.3,
		},
		{
			num_targets = 3,
			t = 0.6,
		},
	},
	max_angle = math.pi * 0.25,
}

weapon_template.action_inputs = {
	shoot_light_pressed = {
		buffer_time = 0.2,
		input_sequence = {
			{
				input = "action_one_pressed",
				value = true,
			},
			{
				input = "action_one_hold",
				value = true,
			},
		},
	},
	shoot_light_hold_release = {
		buffer_time = 0.76,
		input_sequence = {
			{
				input = "action_one_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	charge_heavy = {
		buffer_time = 0.5,
		input_sequence = {
			{
				input = "action_two_hold",
				value = true,
			},
		},
	},
	charge_heavy_cancel = {
		buffer_time = 0.4,
		input_sequence = {
			{
				input = "action_two_hold",
				value = false,
			},
		},
	},
	shoot_heavy_hold = {
		buffer_time = 0.5,
		input_sequence = {
			{
				input = "action_one_pressed",
				value = true,
				time_window = math.huge,
			},
			{
				input = "action_one_hold",
				value = true,
				time_window = math.huge,
			},
		},
	},
	shoot_heavy_hold_release = {
		buffer_time = 0.76,
		input_sequence = {
			{
				inputs = {
					{
						input = "action_two_hold",
						value = false,
					},
					{
						input = "action_one_hold",
						value = false,
					},
				},
				time_window = math.huge,
			},
		},
	},
	charge = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "action_two_hold",
				value = true,
			},
		},
	},
	vent = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				input = "weapon_reload_hold",
				value = true,
			},
		},
	},
	vent_release = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "weapon_reload_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	force_vent = {
		buffer_time = 0,
		clear_input_queue = true,
	},
	force_vent_release = {
		buffer_time = 0.8,
		input_sequence = {
			{
				input = "weapon_reload_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	wield = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				inputs = wield_inputs,
			},
		},
	},
	inspect_start = {
		buffer_time = 0,
		input_sequence = {
			{
				input = "weapon_inspect_hold",
				value = true,
			},
		},
	},
	inspect_stop = {
		buffer_time = 0.02,
		input_sequence = {
			{
				input = "weapon_inspect_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	combat_ability = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				input = "combat_ability_pressed",
				value = true,
			},
		},
	},
}
weapon_template.action_input_hierarchy = {
	combat_ability = "base",
	wield = "stay",
	charge_heavy = {
		charge_heavy_cancel = "base",
		combat_ability = "base",
		wield = "base",
		shoot_heavy_hold = {
			combat_ability = "base",
			force_vent = "base",
			shoot_heavy_hold_release = "base",
			wield = "base",
		},
	},
	shoot_light_pressed = {
		combat_ability = "base",
		force_vent = "base",
		shoot_light_hold_release = "base",
		wield = "base",
	},
	vent = {
		combat_ability = "base",
		vent_release = "base",
		wield = "base",
	},
	force_vent = {
		combat_ability = "base",
		force_vent_release = "base",
		wield = "base",
	},
	inspect_start = {
		inspect_stop = "base",
	},
}
weapon_template.actions = {
	action_unwield = {
		allowed_during_sprint = true,
		kind = "unwield",
		start_input = "wield",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
	},
	action_wield = {
		allowed_during_sprint = true,
		anim_event = "equip_chainlightning",
		kind = "wield",
		total_time = 0.5,
		uninterruptible = true,
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			shoot_light_pressed = {
				action_name = "action_spread",
				chain_time = 0.01,
			},
			charge_heavy = {
				action_name = "action_charge",
				chain_time = 0.01,
			},
			vent = {
				action_name = "action_vent",
			},
		},
	},
	action_spread = {
		ability_type = "grenade_ability",
		allowed_during_sprint = false,
		anim_end_event = "attack_spread_damage",
		anim_end_event_3p = "attack_shoot_right",
		anim_event = "attack_spread",
		charge_template = "chain_lightning_ability_spread",
		fire_time = 0.2,
		improved_target_buff = "psyker_protectorate_spread_chain_lightning_interval_improved",
		keep_chain_data_to_next_action = false,
		kind = "chain_lightning",
		minimum_hold_time = 0.35,
		no_damage_on_cleanup_on_chain_action_kind = "vent_warp_charge",
		overload_module_class_name = "warp_charge",
		sprint_ready_up_time = 0.4,
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot_light_pressed",
		stop_input = "shoot_light_hold_release",
		target_buff = "psyker_protectorate_spread_chain_lightning_interval",
		target_finder_module_class_name = "chain_lightning",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.6,
				t = 0.2,
			},
			{
				modifier = 0.5,
				t = 0.3,
			},
			{
				modifier = 0.3,
				t = 0.6,
			},
			start_modifier = 0.8,
		},
		chain_lightning_link_effects = {
			power = "low",
		},
		running_action_state_to_action_input = {
			force_vent = {
				input_name = "force_vent",
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			wield = {
				action_name = "action_unwield",
			},
			vent = {
				action_name = "action_vent",
			},
			force_vent = {
				action_name = "action_force_vent",
			},
		},
		fx = {
			fx_hand = "left",
			jump_sfx_alias = "ranged_single_shot_special_extra",
			looping_shoot_sfx_alias = "ranged_shooting",
		},
		charge_effects = {
			sfx_parameter = "charge_level",
			sfx_source_name = "_left",
			use_chain_jumping_as_charge = true,
		},
		damage_profile = DamageProfileTemplates.psyker_protectorate_channel_chain_lightning_activated,
		damage_type = damage_types.electrocution,
		chain_settings = chain_settings_spread,
		chain_settings_targeting = chain_settings_spread_targeting,
	},
	action_charge = {
		ability_type = "grenade_ability",
		allowed_during_sprint = true,
		anim_end_event = "attack_charge_cancel",
		anim_event = "attack_charge_fast",
		charge_template = "chain_lightning_charge_heavy",
		kind = "overload_charge_target_finder",
		minimum_hold_time = 0.2,
		overload_module_class_name = "warp_charge",
		sprint_ready_up_time = 0,
		sprint_requires_press_to_interrupt = false,
		start_input = "charge_heavy",
		stop_input = "charge_heavy_cancel",
		target_anim_event = "attack_charge_fast",
		target_finder_module_class_name = "psyker_chain_lightning_single_targeting",
		target_missing_anim_event = "attack_charge_cancel",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "charge_up",
		},
		action_movement_curve = {
			{
				modifier = 0.85,
				t = 0.2,
			},
			{
				modifier = 0.84,
				t = 0.3,
			},
			{
				modifier = 0.86,
				t = 0.5,
			},
			{
				modifier = 0.87,
				t = 1.5,
			},
			start_modifier = 0.8,
		},
		smart_targeting_template = SmartTargetingTemplates.chain_lightning_single_target,
		charge_effects = {
			charge_done_effect_alias = "ranged_charging_done",
			charge_done_source_name = "_charge",
			looping_effect_alias = "ranged_charging",
			looping_sound_alias = "ranged_charging",
			sfx_parameter = "charge_level",
			sfx_source_name = "_charge",
			vfx_source_name = "_charge",
		},
		targeting_fx = {
			effect_name = "content/fx/particles/abilities/chainlightning/protectorate_chainlightning_single_targeting",
			has_husk_events = true,
			husk_effect_name = "content/fx/particles/abilities/husk/husk_psyker_target_headpop",
			show_on_full_charge = true,
			target_node = "j_spine",
			wwise_event_start = "wwise/events/weapon/play_psyker_lightning_bolt_target",
			wwise_event_stop = "wwise/events/weapon/stop_psyker_lightning_bolt_target",
			wwise_parameter_name = "charge_level",
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			wield = {
				action_name = "action_unwield",
			},
			shoot_heavy_hold = {
				action_name = "action_spread_charged",
				chain_time = 0.75,
			},
			vent = {
				action_name = "action_vent",
			},
		},
		fx = {
			fx_hand = "right",
		},
		chain_settings_targeting = chain_settings_spread_charge_targeting,
	},
	action_spread_charged = {
		ability_type = "grenade_ability",
		allowed_during_sprint = false,
		anim_end_event = "attack_spread_damage",
		anim_end_event_3p = "attack_shoot_right",
		anim_event = "attack_charge_shoot",
		anim_event_3p = "attack_shoot",
		charge_template = "chain_lightning_ability_spread",
		fire_time = 0.2,
		improved_target_buff = "psyker_protectorate_spread_charged_chain_lightning_interval_improved",
		keep_chain_data_to_next_action = false,
		kind = "chain_lightning",
		minimum_hold_time = 0.75,
		no_damage_on_cleanup_on_chain_action_kind = "vent_warp_charge",
		overload_module_class_name = "warp_charge",
		sprint_ready_up_time = 0.4,
		sprint_requires_press_to_interrupt = true,
		stop_input = "shoot_heavy_hold_release",
		target_buff = "psyker_protectorate_spread_charged_chain_lightning_interval",
		target_finder_module_class_name = "chain_lightning",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.6,
				t = 0.2,
			},
			{
				modifier = 0.5,
				t = 0.3,
			},
			{
				modifier = 0.3,
				t = 0.6,
			},
			start_modifier = 0.8,
		},
		chain_lightning_link_effects = {
			power = "high",
		},
		running_action_state_to_action_input = {
			force_vent = {
				input_name = "force_vent",
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			wield = {
				action_name = "action_unwield",
			},
			vent = {
				action_name = "action_vent",
			},
			force_vent = {
				action_name = "action_force_vent",
			},
		},
		fx = {
			fx_hand = "right",
			jump_sfx_alias = "ranged_single_shot_special_extra",
			looping_shoot_sfx_alias = "ranged_braced_shooting",
		},
		charge_effects = {
			sfx_parameter = "charge_level",
			sfx_source_name = "_right",
			use_chain_jumping_as_charge = true,
		},
		damage_profile = DamageProfileTemplates.psyker_protectorate_channel_chain_lightning_activated,
		damage_type = damage_types.electrocution,
		chain_settings = chain_settings_spread_charge,
		chain_settings_targeting = chain_settings_spread_charge_targeting,
	},
	action_force_vent = {
		additional_vent_source_name = "fx_right_hand",
		additional_vent_vfx = "content/fx/particles/abilities/psyker_venting_2",
		anim_end_event = "vent_end",
		anim_event = "vent_force_start",
		anim_event_3p = "vent_start",
		kind = "vent_warp_charge",
		minimum_hold_time = 0.5,
		stop_input = "force_vent_release",
		uninterruptible = true,
		vent_source_name = "fx_left_hand",
		vent_vfx = "content/fx/particles/abilities/psyker_venting",
		vo_tag = "ability_venting",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.4,
				t = 0.1,
			},
			{
				modifier = 0.4,
				t = 0.15,
			},
			{
				modifier = 0.6,
				t = 0.2,
			},
			{
				modifier = 0.4,
				t = 1,
			},
			start_modifier = 1,
		},
		running_action_state_to_action_input = {
			fully_vented = {
				input_name = "vent_release",
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
		},
	},
	action_vent = {
		additional_vent_source_name = "fx_right_hand",
		additional_vent_vfx = "content/fx/particles/abilities/psyker_venting_2",
		anim_end_event = "vent_end",
		anim_event = "vent_start",
		kind = "vent_warp_charge",
		start_input = "vent",
		stop_input = "vent_release",
		uninterruptible = true,
		vent_source_name = "fx_left_hand",
		vent_vfx = "content/fx/particles/abilities/psyker_venting",
		vo_tag = "ability_venting",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.4,
				t = 0.1,
			},
			{
				modifier = 0.4,
				t = 0.15,
			},
			{
				modifier = 0.6,
				t = 0.2,
			},
			{
				modifier = 0.4,
				t = 1,
			},
			start_modifier = 1,
		},
		running_action_state_to_action_input = {
			fully_vented = {
				input_name = "vent_release",
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
		},
	},
	combat_ability = {
		kind = "unwield_to_specific",
		slot_to_wield = "slot_combat_ability",
		start_input = "combat_ability",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
	},
	action_inspect = {
		anim_end_event = "inspect_end",
		anim_event = "inspect_start",
		kind = "inspect",
		lock_view = true,
		skip_3p_anims = true,
		start_input = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect",
		},
	},
}
weapon_template.keywords = {
	"psyker",
}
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/psyker_smite"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/chain_lightning"
weapon_template.spread_template = "no_spread"
weapon_template.ammo_template = "no_ammo"
weapon_template.psyker_smite = true
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.fx_sources = {
	_both = "fx_both",
	_charge = "fx_charge",
	_left = "fx_left",
	_right = "fx_right",
}
weapon_template.chain_settings = {
	left_fx_source_name = "_left",
	right_fx_source_name = "_right",
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
