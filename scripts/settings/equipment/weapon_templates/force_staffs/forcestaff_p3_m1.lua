-- chunkname: @scripts/settings/equipment/weapon_templates/force_staffs/forcestaff_p3_m1.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeForcestaffP3 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_forcestaff_p3")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local template_types = WeaponTweakTemplateSettings.template_types
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local charge_trait_templates = WeaponTraitTemplates[template_types.charge]
local warp_charge_trait_templates = WeaponTraitTemplates[template_types.warp_charge]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local weapon_template = {}
local chain_settings_charged = {
	jump_time = 0.1,
	max_jumps = 1,
	max_jumps_stat_buff = "chain_lightning_staff_max_jumps",
	max_targets = 1,
	radius = 8,
	staff = true,
	max_targets_at_depth = {
		{
			num_targets = 1,
		},
	},
	max_angle = math.pi * 0.75,
}
local chain_settings_charged_targeting = table.clone(chain_settings_charged)

chain_settings_charged_targeting.radius = 20
chain_settings_charged_targeting.max_angle = math.pi * 0.25
chain_settings_charged_targeting.close_max_angle = math.pi * 0.5
weapon_template.action_inputs = {
	shoot_pressed = {
		buffer_time = 0.15,
		max_queue = 2,
		input_sequence = {
			{
				input = "action_one_pressed",
				value = true,
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
	charge_release = {
		buffer_time = 0.41,
		input_sequence = {
			{
				input = "action_two_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	keep_charging = {
		buffer_time = 0,
		input_sequence = {
			{
				input = "action_two_hold",
				value = true,
			},
		},
	},
	shoot_charged = {
		buffer_time = 0.5,
		input_sequence = {
			{
				hold_input = "action_two_hold",
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	shoot_charged_release = {
		buffer_time = 0.41,
		input_sequence = false,
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
		buffer_time = 0.261,
		input_sequence = {
			{
				input = "weapon_reload_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	special_action = {
		buffer_time = 0.2,
		input_sequence = {
			{
				input = "weapon_extra_pressed",
				value = true,
			},
		},
	},
	special_action_hold = {
		buffer_time = 0.2,
		input_sequence = {
			{
				hold_input = "weapon_extra_hold",
				input = "weapon_extra_hold",
				value = true,
			},
		},
	},
	special_action_light = {
		buffer_time = 0.3,
		max_queue = 1,
		input_sequence = {
			{
				input = "weapon_extra_hold",
				time_window = 0.25,
				value = false,
			},
		},
	},
	special_action_heavy = {
		buffer_time = 0.5,
		max_queue = 1,
		input_sequence = {
			{
				duration = 0.25,
				input = "weapon_extra_hold",
				value = true,
			},
			{
				auto_complete = false,
				input = "weapon_extra_hold",
				time_window = 1.5,
				value = false,
			},
		},
	},
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		input = "wield",
		transition = "stay",
	},
	{
		input = "shoot_pressed",
		transition = "stay",
	},
	{
		input = "charge",
		transition = {
			{
				input = "charge_release",
				transition = "base",
			},
			{
				input = "shoot_charged",
				transition = {
					{
						input = "shoot_charged_release",
						transition = "base",
					},
					{
						input = "keep_charging",
						transition = "previous",
					},
					{
						input = "wield",
						transition = "base",
					},
					{
						input = "combat_ability",
						transition = "base",
					},
					{
						input = "grenade_ability",
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
			{
				input = "grenade_ability",
				transition = "base",
			},
			{
				input = "vent",
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
			{
				input = "grenade_ability",
				transition = "base",
			},
		},
	},
	{
		input = "special_action_hold",
		transition = {
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "special_action",
				transition = "base",
			},
			{
				input = "special_action_light",
				transition = "base",
			},
			{
				input = "special_action_heavy",
				transition = "base",
			},
			{
				input = "combat_ability",
				transition = "base",
			},
			{
				input = "grenade_ability",
				transition = "base",
			},
		},
	},
}

ActionInputHierarchy.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
	action_unwield = {
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
		total_time = 0.2,
		uninterruptible = true,
		allowed_chain_actions = {
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.4,
				reset_combo = true,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			shoot_pressed = {
				action_name = "rapid_left",
				chain_time = 0.2,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0,
			},
		},
	},
	rapid_left = {
		anim_event = "orb_shoot",
		charge_template = "forcestaff_p3_m1_projectile",
		fire_time = 0.1,
		kind = "spawn_projectile",
		projectile_item = "content/items/weapons/player/ranged/bullets/force_staff_projectile_01",
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot_pressed",
		total_time = 1,
		uninterruptible = true,
		weapon_handling_template = "forcestaff_p3_m1_single_shot",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2,
			},
			{
				modifier = 1.1,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.8,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			shoot_pressed = {
				action_name = "rapid_left",
				chain_time = 0.5,
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.3,
				reset_combo = true,
			},
			charge = {
				action_name = "action_charge",
				chain_time = 0.3,
				reset_combo = true,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.29,
			},
		},
		fx = {
			shoot_sfx_alias = "ranged_single_shot",
		},
		projectile_template = ProjectileTemplates.force_staff_ball,
		buff_keywords = {
			buff_keywords.allow_hipfire_during_sprint,
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_charge = {
		allowed_during_sprint = true,
		anim_end_event = "attack_cancel",
		anim_event = "attack_charge_lightning",
		anim_event_3p = "attack_charge_lightning",
		charge_template = "forcestaff_p3_m1_charge",
		check_crit = true,
		hold_combo = true,
		kind = "overload_charge_target_finder",
		minimum_hold_time = 0.4,
		overload_module_class_name = "warp_charge",
		sprint_ready_up_time = 0,
		sprint_requires_press_to_interrupt = false,
		start_input = "charge",
		stop_input = "charge_release",
		target_anim_event = "target_start",
		target_finder_module_class_name = "psyker_smite_targeting",
		target_missing_anim_event = "target_end",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "charge_up",
		},
		action_movement_curve = {
			{
				modifier = 0.85,
				t = 0.25,
			},
			{
				modifier = 0.6,
				t = 0.5,
			},
			{
				modifier = 0.7,
				t = 1,
			},
			{
				modifier = 0.9,
				t = 2,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			shoot_charged = {
				action_name = "action_shoot_charged",
				chain_time = 0.5,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.3,
			},
		},
		fx = {
			fx_hand = "left",
		},
		charge_effects = {
			looping_sound_alias = "ranged_charging",
			sfx_parameter = "charge_level",
			sfx_source_name = "_both",
		},
		targeting_fx = {
			attach_node_name = "j_spine",
			effect_name = "content/fx/particles/enemies/buff_chainlightning",
			material_emission = true,
			max_targets = 2,
			orphaned_policy = "destroy",
		},
		chain_settings_targeting = chain_settings_charged_targeting,
		anim_end_event_condition_func = function (unit, data, end_reason)
			if end_reason == "hold_input_released" or end_reason == "stunned" then
				return true
			end

			return false
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.charge_up_time,
		},
	},
	action_shoot_charged = {
		anim_end_event = "attack_cancel",
		anim_event = "attack_charge_shoot_lightning",
		anim_event_3p = "attack_charge_shoot_lightning",
		anim_time_scale = 1.3,
		can_crit = true,
		charge_template = "forcestaff_p3_m1_chain_lightning",
		delay_explosion_to_finish = true,
		fire_time = 0,
		increase_combo = true,
		kind = "chain_lightning",
		minimum_hold_time = 0.05,
		no_chain_lightning_procs = true,
		prevent_sprint = true,
		stop_input = "shoot_charged_release",
		stop_time_critical_strike = 0.6,
		target_buff = "chain_lightning_interval",
		target_finder_module_class_name = "psyker_smite_targeting",
		uninterruptible = true,
		weapon_handling_template = "forcestaff_p3_m1_chain_lightning",
		total_time = math.huge,
		stop_time = {
			0.6,
			0.6,
		},
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			{
				modifier = 0.5,
				t = 0.2,
			},
			{
				modifier = 0.7,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.8,
		},
		running_action_state_to_action_input = {
			charge_depleted = {
				input_name = "shoot_charged_release",
			},
			stop_time_reached = {
				input_name = "shoot_charged_release",
			},
		},
		chain_lightning_link_effects = {
			charge_level_to_power = {
				{
					charge_level = 0,
					power = "low",
				},
				{
					charge_level = 0.33,
					power = "mid",
				},
				{
					charge_level = 0.86,
					power = "high",
				},
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			keep_charging = {
				action_name = "action_charge",
				running_action_state_requirement = {
					charge_depleted = true,
					stop_time_reached = true,
				},
			},
		},
		fx = {
			fx_hand = "left",
			fx_hand_critical_strike = "both",
			looping_shoot_critical_strike_sfx_alias = "ranged_braced_shooting",
			looping_shoot_sfx_alias = "ranged_shooting",
			use_charge = true,
		},
		damage_profile = DamageProfileTemplates.default_chain_lighting_attack,
		damage_type = damage_types.electrocution,
		chain_settings = chain_settings_charged,
		chain_settings_targeting = chain_settings_charged_targeting,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_stab_start = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_special_charge",
		kind = "windup",
		start_input = "special_action_hold",
		total_time = 1.1,
		crosshair = {
			crosshair_type = "dot",
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.9,
			},
			shoot_pressed = {
				action_name = "rapid_left",
				chain_time = 1,
				reset_combo = true,
			},
			charge = {
				action_name = "action_charge",
				chain_time = 0.5,
				reset_combo = true,
			},
			vent = {
				action_name = "action_vent",
			},
			special_action_light = {
				action_name = "action_stab",
				chain_time = 0.2,
			},
			special_action_heavy = {
				action_name = "action_stab_heavy",
				chain_time = 0.4,
			},
		},
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "special_action_heavy",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_swipe_start = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_special_swipe_charge",
		kind = "windup",
		total_time = 1.1,
		crosshair = {
			crosshair_type = "dot",
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			shoot_pressed = {
				action_name = "rapid_left",
				chain_time = 1,
				reset_combo = true,
			},
			charge = {
				action_name = "action_charge",
				chain_time = 1,
				reset_combo = true,
			},
			vent = {
				action_name = "action_vent",
			},
			special_action_light = {
				action_name = "action_swipe",
				chain_time = 0.1,
			},
			special_action_heavy = {
				action_name = "action_swipe_heavy",
				chain_time = 0.6,
			},
		},
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "special_action_heavy",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_stab = {
		allowed_during_sprint = true,
		anim_event = "attack_special",
		damage_window_end = 0.26666666666666666,
		damage_window_start = 0.11666666666666667,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.15,
		total_time = 0.6,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_3",
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.1,
			},
			{
				modifier = 1.75,
				t = 0.25,
			},
			{
				modifier = 1.35,
				t = 0.3,
			},
			{
				modifier = 1.2,
				t = 0.35,
			},
			{
				modifier = 1.1,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 0.6,
			},
			{
				modifier = 0.95,
				t = 1,
			},
			start_modifier = 0.8,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			shoot_pressed = {
				action_name = "rapid_left",
				chain_time = 0.1,
				reset_combo = true,
			},
			charge = {
				action_name = "action_charge",
				chain_time = 0.45,
				reset_combo = true,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.45,
			},
			special_action_hold = {
				action_name = "action_swipe_start",
				chain_time = 0.4,
			},
		},
		weapon_box = {
			0.08,
			2.4,
			0.08,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/force_staff/attack_special_stab_sweep_bake",
			anchor_point_offset = {
				0.1,
				1.1,
				0,
			},
		},
		damage_type = damage_types.blunt_light,
		damage_profile = DamageProfileTemplates.force_staff_bash,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_stab_heavy = {
		allowed_during_sprint = true,
		anim_event = "attack_special",
		damage_window_end = 0.21666666666666667,
		damage_window_start = 0.13333333333333333,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		power_level = 800,
		range_mod = 1.15,
		total_time = 0.75,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_2",
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.1,
			},
			{
				modifier = 1.75,
				t = 0.25,
			},
			{
				modifier = 1.35,
				t = 0.3,
			},
			{
				modifier = 1.2,
				t = 0.35,
			},
			{
				modifier = 1.1,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 0.6,
			},
			{
				modifier = 0.95,
				t = 1,
			},
			start_modifier = 0.8,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			shoot_pressed = {
				action_name = "rapid_left",
				chain_time = 0.1,
				reset_combo = true,
			},
			charge = {
				action_name = "action_charge",
				chain_time = 0.4,
				reset_combo = true,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.4,
			},
			special_action_hold = {
				action_name = "action_swipe_start",
				chain_time = 0.4,
			},
		},
		weapon_box = {
			0.08,
			2.75,
			0.08,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/force_staff/attack_special_stab_sweep_bake",
			anchor_point_offset = {
				0.1,
				1.1,
				0,
			},
		},
		damage_type = damage_types.blunt_heavy,
		damage_profile = DamageProfileTemplates.force_staff_bash_stab_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_swipe = {
		allowed_during_sprint = true,
		anim_event = "attack_special_swipe",
		attack_direction_override = "left",
		damage_window_end = 0.7,
		damage_window_start = 0.6333333333333333,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		power_level = 650,
		range_mod = 1.15,
		total_time = 0.75,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_2",
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			{
				modifier = 0.3,
				t = 0.1,
			},
			{
				modifier = 0.5,
				t = 0.25,
			},
			{
				modifier = 0.5,
				t = 0.3,
			},
			{
				modifier = 1.5,
				t = 0.35,
			},
			{
				modifier = 1.5,
				t = 0.4,
			},
			{
				modifier = 1.05,
				t = 0.6,
			},
			{
				modifier = 0.75,
				t = 1,
			},
			start_modifier = 0.8,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.7,
			},
			shoot_pressed = {
				action_name = "rapid_left",
				chain_time = 1,
				reset_combo = true,
			},
			charge = {
				action_name = "action_charge",
				chain_time = 1,
				reset_combo = true,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.6,
			},
		},
		weapon_box = {
			0.15,
			0.15,
			1.2,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/force_staff/attack_special_swipe_sweep_bake",
			anchor_point_offset = {
				0,
				-0.2,
				0,
			},
		},
		damage_type = damage_types.blunt_light,
		damage_profile = DamageProfileTemplates.force_staff_bash,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_swipe_heavy = {
		allowed_during_sprint = true,
		anim_event = "attack_special_swipe_heavy",
		attack_direction_override = "left",
		damage_window_end = 0.35,
		damage_window_start = 0.31666666666666665,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		power_level = 800,
		range_mod = 1.15,
		total_time = 1.1,
		uninterruptible = true,
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			{
				modifier = 0.3,
				t = 0.1,
			},
			{
				modifier = 0.5,
				t = 0.25,
			},
			{
				modifier = 0.5,
				t = 0.3,
			},
			{
				modifier = 1.5,
				t = 0.35,
			},
			{
				modifier = 1.5,
				t = 0.4,
			},
			{
				modifier = 1.05,
				t = 0.6,
			},
			{
				modifier = 0.75,
				t = 1,
			},
			start_modifier = 0.8,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.6,
			},
			shoot_pressed = {
				action_name = "rapid_left",
				chain_time = 0.7,
				reset_combo = true,
			},
			charge = {
				action_name = "action_charge",
				chain_time = 0.7,
				reset_combo = true,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.6,
			},
		},
		weapon_box = {
			0.15,
			0.15,
			1.2,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/force_staff/attack_special_swipe_heavy_sweep_bake",
			anchor_point_offset = {
				0,
				-0.2,
				0,
			},
		},
		damage_type = damage_types.blunt_heavy,
		damage_profile = DamageProfileTemplates.heavy_force_staff_bash,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_vent = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_end_event = "vent_end",
		anim_event = "vent_start",
		kind = "vent_warp_charge",
		minimum_hold_time = 0.26,
		prevent_sprint = true,
		start_input = "vent",
		stop_input = "vent_release",
		uninterruptible = true,
		vent_source_name = "fx_left_hand",
		vent_vfx = "content/fx/particles/abilities/psyker_venting",
		vo_tag = "ability_venting",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "none",
		},
		action_movement_curve = {
			{
				modifier = 0.5,
				t = 0.1,
			},
			{
				modifier = 0.6,
				t = 0.15,
			},
			{
				modifier = 0.7,
				t = 0.4,
			},
			{
				modifier = 0.85,
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
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			special_action_hold = {
				action_name = "rapid_left",
				chain_time = 0.4,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.vent_warp_charge_multiplier,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_inspect = {
		anim_end_event = "inspect_end",
		anim_event = "inspect_start",
		kind = "inspect",
		lock_view = true,
		skip_3p_anims = false,
		start_input = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect",
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/force_staff"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/force_staff"
weapon_template.spread_template = "default_force_staff_killshot"
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_both = "j_leftweaponattach",
	_charge = "j_leftweaponattach",
	_left = "j_leftweaponattach",
	_muzzle = "j_leftweaponattach",
	_overheat = "fx_overheat",
	_right = "fx_overheat",
}
weapon_template.chain_settings = {
	left_fx_source_name_base_unit = "fx_left_hand",
	right_fx_source_name = "_right",
}
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"ranged",
	"force_staff",
	"p3",
}
weapon_template.dodge_template = "killshot"
weapon_template.sprint_template = "support"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.warp_charge_template = "forcestaff_p3_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.force_staff_p1_single_target
weapon_template.haptic_trigger_template = HapticTriggerTemplates.ranged.forcestaff
weapon_template.charge_effects = {
	sfx_parameter = "charge_level",
	sfx_source_name = "_left",
}
weapon_template.overclocks = {}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	forcestaff_p3_m1_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			rapid_left = {
				damage_trait_templates.forcestaff_p3_m1_dps_stat,
				display_data = {
					prefix = "loc_ingame_action_one",
					display_stats = {
						power_distribution = {
							attack = {
								display_name = "loc_weapon_stats_display_base_damage",
							},
						},
						targets = {
							{
								power_distribution = {
									attack = {
										display_name = "loc_weapon_stats_display_base_damage",
									},
								},
							},
						},
					},
				},
			},
			action_shoot_charged = {
				damage_trait_templates.forcestaff_p3_m1_dps_stat,
				display_data = {
					prefix = "loc_ingame_action_two",
					display_stats = {
						power_distribution = {
							attack = {
								display_name = "loc_weapon_stats_display_base_damage",
							},
						},
						targets = {
							{
								power_distribution = {
									attack = {
										display_name = "loc_weapon_stats_display_base_damage",
									},
								},
							},
						},
					},
				},
			},
		},
	},
	forcestaff_p3_m1_vent_speed_stat = {
		display_name = "loc_stats_display_vent_speed",
		is_stat_trait = true,
		warp_charge = {
			base = {
				warp_charge_trait_templates.forcestaff_p3_m1_vent_speed_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	forcestaff_p3_m1_charge_speed_stat = {
		display_name = "loc_stats_display_charge_speed",
		is_stat_trait = true,
		charge = {
			rapid_left = {
				charge_trait_templates.forcestaff_p3_m1_charge_speed_stat,
			},
			action_charge = {
				charge_trait_templates.forcestaff_p3_m1_charge_speed_stat,
				display_data = {
					prefix = "loc_ingame_action_two",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_shoot_charged = {
				charge_trait_templates.forcestaff_p3_m1_charge_speed_stat,
			},
		},
	},
	forcestaff_p3_m1_warp_charge_cost_stat = {
		display_name = "loc_stats_display_warp_resist_stat",
		is_stat_trait = true,
		charge = {
			rapid_left = {
				charge_trait_templates.forcestaff_p3_m1_warp_charge_cost_stat,
				display_data = {
					prefix = "loc_ingame_action_one",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_charge = {
				charge_trait_templates.forcestaff_p3_m1_warp_charge_cost_stat,
				display_data = {
					prefix = "loc_glossary_term_charge",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_shoot_charged = {
				charge_trait_templates.forcestaff_p3_m1_warp_charge_cost_stat,
				display_data = {
					prefix = "loc_ingame_action_two",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
		},
	},
	forcestaff_p3_m1_crit_stat = {
		display_name = "loc_stats_display_crit_stat",
		is_stat_trait = true,
		weapon_handling = {
			rapid_left = {
				weapon_handling_trait_templates.forcestaff_p3_m1_crit_stat,
				display_data = {
					prefix = "loc_ingame_action_one",
					display_stats = {
						__all_basic_stats = true,
						critical_strike = {
							chance_modifier = {
								display_name = "loc_weapon_stats_display_crit_chance_ranged",
							},
						},
					},
				},
			},
			action_shoot_charged = {
				weapon_handling_trait_templates.forcestaff_p3_m1_crit_stat,
				display_data = {
					prefix = "loc_ingame_action_two",
					display_stats = {
						__all_basic_stats = true,
						critical_strike = {
							chance_modifier = {
								display_name = "loc_weapon_stats_display_crit_chance_ranged",
							},
						},
					},
				},
			},
		},
		damage = {
			rapid_left = {
				damage_trait_templates.forcestaff_p3_m1_crit_stat,
				display_data = {
					prefix = "loc_ingame_action_one",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_shoot_charged = {
				damage_trait_templates.forcestaff_p3_m1_crit_stat,
				display_data = {
					prefix = "loc_ingame_action_two",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
		},
	},
}
weapon_template.traits = {}

local bespoke_forcestaff_p3_traits = table.ukeys(WeaponTraitsBespokeForcestaffP3)

table.append(weapon_template.traits, bespoke_forcestaff_p3_traits)

weapon_template.hipfire_inputs = {
	shoot_pressed = true,
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_warp_weapon",
	},
	{
		display_name = "loc_weapon_keyword_charged_attack",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_forcestaff_p1_m1_attack_primary",
		fire_mode = "projectile",
		type = "hipfire",
	},
	secondary = {
		display_name = "loc_forcestaff_p3_m1_attack_secondary",
		type = "charge",
	},
	special = {
		desc = "loc_stats_special_action_melee_weapon_bash_forcestaff_desc",
		display_name = "loc_forcestaff_p1_m1_attack_special",
		type = "melee_hand",
	},
}
weapon_template.weapon_card_data = {
	main = {
		{
			header = "primary_attack",
			icon = "charge",
			sub_icon = "projectile",
			value_func = "primary_attack",
		},
		{
			header = "secondary_attack",
			icon = "charge",
			value_func = "secondary_attack",
		},
	},
	weapon_special = {
		header = "weapon_bash",
		icon = "melee_hand",
	},
}
weapon_template.special_action_name = "action_stab"

return weapon_template
