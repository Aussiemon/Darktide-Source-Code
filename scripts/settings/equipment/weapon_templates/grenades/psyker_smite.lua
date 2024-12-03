-- chunkname: @scripts/settings/equipment/weapon_templates/grenades/psyker_smite.lua

local ActionInputHierarchy = require("scripts/utilities/weapon/action_input_hierarchy")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {}

weapon_template.action_inputs = {
	charge_power = {
		buffer_time = 0.31,
		max_queue = 1,
		input_sequence = {
			{
				input = "action_two_hold",
				value = true,
			},
		},
	},
	charge_power_release = {
		buffer_time = 0.31,
		max_queue = 1,
		input_sequence = {
			{
				input = "action_two_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	charge_power_sticky = {
		buffer_time = 0.31,
		max_queue = 1,
		input_sequence = {
			{
				input = "action_one_hold",
				value = true,
			},
		},
	},
	charge_power_lock_on = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "action_one_hold",
				value = true,
			},
		},
	},
	charge_power_sticky_release = {
		buffer_time = 0.31,
		max_queue = 1,
		input_sequence = {
			{
				input = "action_one_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	use_power = {
		buffer_time = 0.7,
		input_sequence = {
			{
				input = "none",
				value = true,
			},
		},
	},
	charge = {
		buffer_time = 0,
		input_sequence = {
			{
				input = "action_two_hold",
				value = true,
			},
		},
	},
	wield = {
		buffer_time = 0.5,
		clear_input_queue = true,
		input_sequence = {
			{
				inputs = wield_inputs,
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
	inspect_start = {
		buffer_time = 0,
		input_sequence = {
			{
				input = "weapon_inspect_hold",
				value = true,
			},
			{
				duration = 0.2,
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

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		input = "charge_power",
		transition = {
			{
				input = "charge_power_release",
				transition = "base",
			},
			{
				input = "charge_power_lock_on",
				transition = {
					{
						input = "charge_power_sticky_release",
						transition = "base",
					},
					{
						input = "use_power",
						transition = "base",
					},
					{
						input = "wield",
						transition = "base",
					},
					{
						input = "combat_ability",
						transition = "base",
					},
				},
			},
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "combat_ability",
				transition = "base",
			},
		},
	},
	{
		input = "charge_power_sticky",
		transition = {
			{
				input = "charge_power_sticky_release",
				transition = "base",
			},
			{
				input = "use_power",
				transition = "base",
			},
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "combat_ability",
				transition = "base",
			},
		},
	},
	{
		input = "vent",
		transition = {
			{
				input = "vent_release",
				transition = "base",
			},
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "combat_ability",
				transition = "base",
			},
		},
	},
	{
		input = "wield",
		transition = "stay",
	},
	{
		input = "combat_ability",
		transition = "stay",
	},
	{
		input = "inspect_start",
		transition = {
			{
				input = "inspect_stop",
				transition = "base",
			},
		},
	},
}

ActionInputHierarchy.add_missing_ordered(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

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
		anim_event = "equip",
		kind = "wield",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			vent = {
				action_name = "action_vent",
			},
		},
	},
	action_vent = {
		abort_sprint = true,
		additional_vent_source_name = "fx_right_hand",
		additional_vent_vfx = "content/fx/particles/abilities/psyker_venting_2",
		allowed_during_sprint = true,
		anim_end_event = "vent_end",
		anim_event = "vent_start",
		kind = "vent_warp_charge",
		prevent_sprint = true,
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
				modifier = 0.3,
				t = 0.15,
			},
			{
				modifier = 0.2,
				t = 0.2,
			},
			{
				modifier = 0.01,
				t = 5,
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
	action_charge_target_sticky = {
		ability_type = "grenade_ability",
		allowed_during_sprint = true,
		anim_end_event = "attack_charge_cancel",
		anim_event = "attack_charge",
		attack_target = true,
		attack_target_time = 1,
		charge_template = "psyker_smite_lock_target",
		charge_time = 2,
		kill_charge = true,
		kind = "smite_targeting",
		minimum_hold_time = 0.3,
		overload_module_class_name = "warp_charge",
		sprint_ready_up_time = 0,
		start_input = "charge_power_sticky",
		sticky_targeting = true,
		stop_input = "charge_power_sticky_release",
		target_charge = true,
		target_finder_module_class_name = "psyker_smite_targeting",
		target_locked = true,
		uninterruptible = true,
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
		targeting_fx = {
			effect_name = "content/fx/particles/weapons/force_staff/force_staff_channel_charge",
			has_husk_events = true,
			husk_effect_name = "content/fx/particles/abilities/husk/husk_psyker_target_headpop",
			wwise_event_start = "wwise/events/weapon/play_force_staff_single_target",
			wwise_event_stop = "wwise/events/weapon/stop_force_staff_single_target",
			wwise_parameter_name = "charge_level",
		},
		charge_effects = {
			looping_effect_alias = "ranged_charging",
			looping_sound_alias = "ranged_charging",
			sfx_source_name = "_charge",
			vfx_source_name = "_charge",
		},
		smart_targeting_template = SmartTargetingTemplates.smite,
		running_action_state_to_action_input = {
			fully_charged = {
				input_name = "use_power",
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			wield = {
				action_name = "action_unwield",
			},
			use_power = {
				action_name = "action_use_power",
			},
		},
		attack_settings = {
			damage_profile = DamageProfileTemplates.psyker_smite_stagger,
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			if end_reason == "hold_input_released" or end_reason == "stunned" then
				return true
			end

			return false
		end,
	},
	action_charge_target = {
		ability_type = "grenade_ability",
		allowed_during_sprint = true,
		always_charge = true,
		anim_end_event = "attack_charge_cancel",
		anim_event = "attack_charge",
		charge_template = "psyker_smite_charge",
		kill_charge = true,
		kind = "smite_targeting",
		minimum_hold_time = 0.3,
		overload_module_class_name = "warp_charge",
		sprint_ready_up_time = 0,
		start_input = "charge_power",
		stop_input = "charge_power_release",
		target_charge = true,
		target_finder_module_class_name = "psyker_smite_targeting",
		uninterruptible = true,
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.6,
				t = 0.1,
			},
			{
				modifier = 0.6,
				t = 0.15,
			},
			{
				modifier = 0.8,
				t = 0.2,
			},
			{
				modifier = 0.6,
				t = 1,
			},
			start_modifier = 1,
		},
		targeting_fx = {
			effect_name = "content/fx/particles/weapons/force_staff/force_staff_channel_charge",
			has_husk_events = true,
			husk_effect_name = "content/fx/particles/abilities/husk/husk_psyker_target_headpop",
			wwise_event_start = "wwise/events/weapon/play_force_staff_single_target",
			wwise_event_stop = "wwise/events/weapon/stop_force_staff_single_target",
			wwise_parameter_name = "charge_level",
		},
		charge_effects = {
			looping_effect_alias = "ranged_charging",
			looping_sound_alias = "ranged_charging",
			sfx_source_name = "_charge",
			vfx_source_name = "_charge",
		},
		smart_targeting_template = SmartTargetingTemplates.smite,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			wield = {
				action_name = "action_unwield",
			},
			charge_power_lock_on = {
				action_name = "action_charge_target_lock_on",
			},
		},
		attack_settings = {
			damage_profile = DamageProfileTemplates.psyker_smite_stagger,
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			if end_reason == "hold_input_released" or end_reason == "stunned" then
				return true
			end

			return false
		end,
	},
	action_charge_target_lock_on = {
		ability_type = "grenade_ability",
		allowed_during_sprint = true,
		anim_end_event = "attack_charge_cancel",
		attack_target = true,
		attack_target_time = 0.25,
		charge_template = "psyker_smite_lock_target",
		dont_reset_charge = true,
		kill_charge = true,
		kind = "smite_targeting",
		only_allowed_with_smite_target = true,
		overload_module_class_name = "warp_charge",
		sprint_ready_up_time = 0,
		start_input = "charge_power_lock_on",
		sticky_targeting = true,
		stop_input = "charge_power_sticky_release",
		target_finder_module_class_name = "psyker_smite_targeting",
		target_locked = true,
		target_missing_anim_event = "attack_charge_cancel",
		uninterruptible = true,
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.6,
				t = 0.1,
			},
			{
				modifier = 0.6,
				t = 0.15,
			},
			{
				modifier = 0.8,
				t = 0.2,
			},
			{
				modifier = 0.6,
				t = 1,
			},
			start_modifier = 1,
		},
		targeting_fx = {
			effect_name = "content/fx/particles/weapons/force_staff/force_staff_channel_charge",
			has_husk_events = true,
			husk_effect_name = "content/fx/particles/abilities/husk/husk_psyker_target_headpop",
			wwise_event_start = "wwise/events/weapon/play_force_staff_single_target",
			wwise_event_stop = "wwise/events/weapon/stop_force_staff_single_target",
			wwise_parameter_name = "charge_level",
		},
		charge_effects = {
			looping_effect_alias = "ranged_charging",
			looping_sound_alias = "ranged_charging",
			sfx_source_name = "_charge",
			vfx_source_name = "_charge",
		},
		smart_targeting_template = SmartTargetingTemplates.smite,
		running_action_state_to_action_input = {
			fully_charged = {
				input_name = "use_power",
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			wield = {
				action_name = "action_unwield",
			},
			use_power = {
				action_name = "action_use_power",
			},
		},
		attack_settings = {
			damage_profile = DamageProfileTemplates.psyker_smite_stagger,
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			if end_reason == "hold_input_released" or end_reason == "stunned" then
				return true
			end

			return false
		end,
	},
	action_use_power = {
		allowed_during_sprint = true,
		anim_event = "attack_charge_shoot",
		charge_template = "psyker_smite_use_power",
		fire_time = 0.2,
		kind = "damage_target",
		sprint_ready_up_time = 0,
		total_time = 0.8,
		uninterruptible = true,
		use_charge = true,
		use_charge_level = true,
		action_movement_curve = {
			{
				modifier = 0.25,
				t = 0.2,
			},
			{
				modifier = 0.4,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.2,
		},
		damage_profile = DamageProfileTemplates.psyker_smite_kill,
		damage_type = damage_types.smite,
		suppression_settings = {
			distance = 5,
			instant_aggro = true,
			suppression_falloff = true,
			suppression_value = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.3,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.smite_attack_speed,
		},
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
	combat_ability = {
		kind = "unwield_to_specific",
		slot_to_wield = "slot_combat_ability",
		start_input = "combat_ability",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
	},
}
weapon_template.keywords = {
	"psyker",
}
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/psyker_smite",
	ogryn = "content/characters/player/ogryn/third_person/animations/unarmed",
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/psyker_smite",
	ogryn = "content/characters/player/ogryn/first_person/animations/unarmed",
}
weapon_template.alternate_fire_settings = {
	spread_template = "psyker_smite",
	start_anim_event = "attack_charge",
	stop_anim_event = "attack_charge_cancel",
	action_movement_curve = {
		{
			modifier = 0.3,
			t = 0.1,
		},
		{
			modifier = 0.3,
			t = 0.15,
		},
		{
			modifier = 0.6,
			t = 0.25,
		},
		{
			modifier = 0.6,
			t = 0.5,
		},
		{
			modifier = 0.4,
			t = 1,
		},
		{
			modifier = 0.3,
			t = 2,
		},
		start_modifier = 1,
	},
}
weapon_template.spread_template = "psyker_smite"
weapon_template.ammo_template = "no_ammo"
weapon_template.psyker_smite = true
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
	uses_weapon_special_charges = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.smart_targeting_template = SmartTargetingTemplates.smite
weapon_template.crosshair = {
	crosshair_type = "charge_up",
}
weapon_template.hit_marker_type = "center"
weapon_template.fx_sources = {
	_charge = "fx_charge",
	_muzzle = "fx_right",
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
