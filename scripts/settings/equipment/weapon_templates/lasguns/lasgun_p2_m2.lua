-- chunkname: @scripts/settings/equipment/weapon_templates/lasguns/lasgun_p2_m2.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeLasgunP2 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_lasgun_p2")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_types = DamageSettings.damage_types
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local wounds_shapes = WoundsSettings.shapes
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local recoil_trait_templates = WeaponTraitTemplates[template_types.recoil]
local spread_trait_templates = WeaponTraitTemplates[template_types.spread]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local ammo_trait_templates = WeaponTraitTemplates[template_types.ammo]
local sway_trait_templates = WeaponTraitTemplates[template_types.sway]
local toughness_trait_templates = WeaponTraitTemplates[template_types.toughness]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local charge_trait_templates = WeaponTraitTemplates[template_types.charge]
local weapon_template = {}

weapon_template.action_inputs = {
	shoot_pressed = {
		buffer_time = 0.1,
		max_queue = 1,
		input_sequence = {
			{
				input = "action_one_hold",
				value = true,
			},
		},
	},
	shoot_release_charged = {
		buffer_time = 0.5,
		clear_input_queue = true,
		input_sequence = {
			{
				input = "action_one_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	zoom_shoot_hold = {
		buffer_time = 0.5,
		max_queue = 2,
		input_sequence = {
			{
				input = "action_one_hold",
				value = true,
			},
		},
	},
	zoom_shoot_release_charged = {
		buffer_time = 0.5,
		clear_input_queue = true,
		input_sequence = {
			{
				input = "action_one_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	zoom = {
		buffer_time = 0.4,
		input_sequence = {
			{
				input = "action_two_hold",
				value = true,
				input_setting = {
					input = "action_two_pressed",
					setting = "toggle_ads",
					setting_value = true,
					value = true,
				},
			},
		},
	},
	zoom_release = {
		buffer_time = 0.3,
		input_sequence = {
			{
				input = "action_two_hold",
				value = false,
				time_window = math.huge,
				input_setting = {
					input = "action_two_pressed",
					setting = "toggle_ads",
					setting_value = true,
					value = true,
					time_window = math.huge,
				},
			},
		},
	},
	reload = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				input = "weapon_reload",
				value = true,
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
		buffer_time = 0.4,
		input_sequence = {
			{
				hold_input = "weapon_extra_hold",
				input = "weapon_extra_hold",
				value = true,
			},
		},
	},
	special_action_release = {
		buffer_time = 0.2,
		input_sequence = {
			{
				hold_input = "weapon_extra_release",
				input = "weapon_extra_release",
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
		input = "shoot_pressed",
		transition = {
			{
				input = "shoot_release_charged",
				transition = "base",
			},
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "combat_ability",
				transition = "stay",
			},
			{
				input = "grenade_ability",
				transition = "base",
			},
			{
				input = "reload",
				transition = "base",
			},
			{
				input = "zoom",
				transition = "base",
			},
			{
				input = "special_action_hold",
				transition = "base",
			},
		},
	},
	{
		input = "zoom",
		transition = {
			{
				input = "zoom_release",
				transition = "base",
			},
			{
				input = "zoom_shoot_hold",
				transition = {
					{
						input = "zoom_shoot_release_charged",
						transition = "previous",
					},
					{
						input = "zoom_release",
						transition = "base",
					},
					{
						input = "combat_ability",
						transition = "stay",
					},
					{
						input = "grenade_ability",
						transition = "base",
					},
					{
						input = "wield",
						transition = "base",
					},
					{
						input = "reload",
						transition = "base",
					},
				},
			},
			{
				input = "reload",
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
			{
				input = "special_action",
				transition = "base",
			},
			{
				input = "special_action_hold",
				transition = "base",
			},
		},
	},
	{
		input = "wield",
		transition = "stay",
	},
	{
		input = "reload",
		transition = "stay",
	},
	{
		input = "special_action",
		transition = "stay",
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
			{
				input = "reload",
				transition = "base",
			},
		},
	},
}

ActionInputHierarchy.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

local action_movement_curve_mark_modifier = 1
local RESET_CHARGE_ACTION_KINDS = {
	charge_ammo = true,
	reload_state = true,
	sweep = true,
	unaim = true,
	unwield = true,
	unwield_to_specific = true,
	windup = true,
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
		kind = "ranged_wield",
		total_time = 1.8,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_5",
		wield_anim_event = "equip",
		wield_reload_anim_event = "equip_reload",
		conditional_state_to_action_input = {
			started_reload = {
				input_name = "reload",
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.275,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 1.25,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip_start",
				chain_time = 1.5,
				reset_combo = true,
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 1,
			},
		},
	},
	action_shoot_hip_start = {
		abort_sprint = true,
		allowed_during_sprint = false,
		anim_end_event = "attack_finished",
		anim_event = "attack_charge",
		charge_extra_hold_time = 2.5,
		charge_template = "lasgun_p2_m2_charge_up",
		dont_clear_num_shots = true,
		hold_combo = true,
		kind = "charge_ammo",
		prevent_sprint = true,
		spread_template = "hip_lasgun_killshot_p2_m1",
		start_input = "shoot_pressed",
		total_time = 3.7,
		action_movement_curve = {
			start_modifier = 0.8 * action_movement_curve_mark_modifier,
			{
				t = 0.3,
				modifier = 0.7 * action_movement_curve_mark_modifier,
			},
			{
				t = 1,
				modifier = 0.55 * action_movement_curve_mark_modifier,
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
				reset_combo = true,
			},
			shoot_release_charged = {
				action_name = "action_shoot_hip_charged",
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.15,
				reset_combo = true,
			},
			special_action_hold = {
				action_name = "action_stab_start",
			},
		},
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "shoot_release_charged",
			},
		},
		finish_reason_to_action_input = {
			stunned = {
				input_name = "shoot_release_charged",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		reset_charge_action_kinds = RESET_CHARGE_ACTION_KINDS,
	},
	action_shoot_hip_charged = {
		abort_sprint = false,
		allow_shots_with_less_than_required_ammo = true,
		allowed_during_sprint = false,
		ammunition_usage = 2,
		ammunition_usage_max = 4,
		ammunition_usage_min = 2,
		dont_clear_num_shots = true,
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0.25,
		sprint_requires_press_to_interrupt = true,
		total_time = 0.65,
		use_charge = true,
		weapon_handling_template = "immediate_single_shot",
		action_movement_curve = {
			start_modifier = 0.5 * action_movement_curve_mark_modifier,
			{
				t = 0.05,
				modifier = 0.4 * action_movement_curve_mark_modifier,
			},
			{
				t = 0.15,
				modifier = 0.25 * action_movement_curve_mark_modifier,
			},
			{
				t = 0.175,
				modifier = 0.275 * action_movement_curve_mark_modifier,
			},
			{
				t = 0.2,
				modifier = 0.4 * action_movement_curve_mark_modifier,
			},
			{
				t = 0.5,
				modifier = 1 * action_movement_curve_mark_modifier,
			},
			{
				modifier = 1,
				t = 1.4,
			},
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			is_charge_dependant = true,
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			spread_rotated_muzzle_flash = true,
			muzzle_flash_effect = {
				{
					charge_level = 0,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_muzzle",
				},
				{
					charge_level = 0.2,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_charged_muzzle",
				},
				{
					charge_level = 0.9,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_bfg_muzzle",
				},
			},
			muzzle_flash_crit_effect = {
				{
					charge_level = 0,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_muzzle_crit",
				},
				{
					charge_level = 0.2,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_charged_muzzle_crit",
				},
				{
					charge_level = 0.9,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_bfg_muzzle_crit",
				},
			},
			line_effect = {
				{
					charge_level = 0,
					line_effect = LineEffects.lasbeam_killshot,
				},
				{
					charge_level = 0.2,
					line_effect = LineEffects.lasbeam_charged,
				},
				{
					charge_level = 0.9,
					line_effect = LineEffects.lasbeam_bfg,
				},
			},
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			anim_event_3p = "attack_shoot",
			same_side_suppression_enabled = false,
			use_charge = true,
			hit_scan_template = HitScanTemplates.lasgun_p2_m2_beam_charged,
			damage_type = {
				{
					charge_level = 0,
					damage_type = damage_types.laser,
				},
				{
					charge_level = 0.2,
					damage_type = damage_types.laser_charged,
				},
				{
					charge_level = 0.9,
					damage_type = damage_types.laser_bfg,
				},
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
			},
			shoot_pressed = {
				action_name = "action_shoot_hip_start",
				chain_time = 0.3,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.3,
				reset_combo = true,
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.3,
				reset_combo = true,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_shoot_zoomed_start = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_charge",
		charge_extra_hold_time = 2.5,
		charge_template = "lasgun_p2_m2_charge_up",
		dont_clear_num_shots = true,
		hold_combo = true,
		keep_charge = true,
		kind = "charge_ammo",
		recoil_template = "lasgun_p2_m1_ads_killshot",
		spread_template = "default_lasgun_killshot",
		start_input = "zoom_shoot_hold",
		sway_template = "lasgun_p2_m1_killshot",
		total_time = 3.7,
		crosshair = {
			crosshair_type = "charge_up_ads",
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
			},
			zoom_shoot_release_charged = {
				action_name = "action_zoom_shoot_charged",
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.2,
				reset_combo = true,
			},
			special_action_hold = {
				action_name = "action_stab_start",
			},
		},
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "zoom_shoot_release_charged",
			},
		},
		running_action_state_to_action_input = {
			fully_charged = {
				input_name = "zoom_shoot_release_charged",
			},
		},
		finish_reason_to_action_input = {
			stunned = {
				input_name = "zoom_shoot_release_charged",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		reset_charge_action_kinds = RESET_CHARGE_ACTION_KINDS,
	},
	action_zoom_shoot_charged = {
		allow_shots_with_less_than_required_ammo = true,
		ammunition_usage = 2,
		ammunition_usage_max = 4,
		ammunition_usage_min = 2,
		charge_template = "lasgun_p2_m2_charge_up",
		dont_clear_num_shots = true,
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0.5,
		total_time = 0.65,
		use_charge = true,
		weapon_handling_template = "immediate_single_shot",
		crosshair = {
			crosshair_type = "charge_up_ads",
		},
		action_movement_curve = {
			start_modifier = 0.25 * action_movement_curve_mark_modifier,
			{
				t = 0.05,
				modifier = 0.6 * action_movement_curve_mark_modifier,
			},
			{
				t = 0.15,
				modifier = 0.65 * action_movement_curve_mark_modifier,
			},
			{
				t = 0.175,
				modifier = 0.575 * action_movement_curve_mark_modifier,
			},
			{
				t = 0.3,
				modifier = 0.8 * action_movement_curve_mark_modifier,
			},
			{
				t = 0.7,
				modifier = 0.9 * action_movement_curve_mark_modifier,
			},
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			is_charge_dependant = true,
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			spread_rotated_muzzle_flash = true,
			muzzle_flash_effect = {
				{
					charge_level = 0,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_muzzle",
				},
				{
					charge_level = 0.2,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_charged_muzzle",
				},
				{
					charge_level = 0.9,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_bfg_muzzle",
				},
			},
			muzzle_flash_crit_effect = {
				{
					charge_level = 0,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_muzzle_crit",
				},
				{
					charge_level = 0.2,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_charged_muzzle_crit",
				},
				{
					charge_level = 0.9,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_bfg_muzzle_crit",
				},
			},
			line_effect = {
				{
					charge_level = 0,
					line_effect = LineEffects.lasbeam_killshot,
				},
				{
					charge_level = 0.2,
					line_effect = LineEffects.lasbeam_charged,
				},
				{
					charge_level = 0.9,
					line_effect = LineEffects.lasbeam_bfg,
				},
			},
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			anim_event_3p = "attack_shoot",
			same_side_suppression_enabled = false,
			use_charge = true,
			hit_scan_template = HitScanTemplates.lasgun_p2_m2_beam_charged,
			damage_type = {
				{
					charge_level = 0,
					damage_type = damage_types.laser,
				},
				{
					charge_level = 0.2,
					damage_type = damage_types.laser_charged,
				},
				{
					charge_level = 0.9,
					damage_type = damage_types.laser_bfg,
				},
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
			},
			zoom_shoot_hold = {
				action_name = "action_shoot_zoomed_start",
				chain_time = 0.3,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.25,
				reset_combo = true,
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.2,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_zoom = {
		hold_combo = false,
		increase_combo = false,
		kind = "aim",
		start_input = "zoom",
		total_time = 0.3,
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_killshot,
		crosshair = {
			crosshair_type = "charge_up_ads",
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
			},
			zoom_shoot_hold = {
				action_name = "action_shoot_zoomed_start",
				chain_time = 0.05,
			},
		},
		running_action_state_to_action_input = {
			has_charge = {
				input_name = "zoom_shoot_hold",
			},
		},
	},
	action_unzoom = {
		hold_combo = false,
		increase_combo = false,
		kind = "unaim",
		start_input = "zoom_release",
		total_time = 0.2,
		crosshair = {
			crosshair_type = "charge_up_ads",
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			zoom = {
				action_name = "action_zoom",
			},
			reload = {
				action_name = "action_reload",
			},
		},
	},
	action_reload = {
		abort_sprint = true,
		allowed_during_sprint = true,
		kind = "reload_state",
		sprint_requires_press_to_interrupt = true,
		start_input = "reload",
		stop_alternate_fire = true,
		total_time = 3,
		weapon_handling_template = "increased_reload_speed",
		crosshair = {
			crosshair_type = "none",
		},
		action_movement_curve = {
			{
				modifier = 0.775,
				t = 0.05,
			},
			{
				modifier = 0.75,
				t = 0.075,
			},
			{
				modifier = 0.59,
				t = 0.25,
			},
			{
				modifier = 0.6,
				t = 0.3,
			},
			{
				modifier = 0.85,
				t = 0.8,
			},
			{
				modifier = 0.9,
				t = 0.9,
			},
			{
				modifier = 1,
				t = 2,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			shoot_pressed = {
				action_name = "action_shoot_hip_start",
				chain_time = 3,
				reset_combo = true,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 3,
			},
			zoom_release = {
				action_name = "action_unzoom",
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.75,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_stab_start = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_charge_stab",
		kind = "windup",
		sprint_requires_press_to_interrupt = true,
		start_input = "special_action_hold",
		stop_alternate_fire = true,
		uninterruptible = true,
		total_time = math.huge,
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			{
				modifier = 1.1,
				t = 0.1,
			},
			{
				modifier = 1.3,
				t = 0.25,
			},
			{
				modifier = 1,
				t = 3,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
			},
			special_action_light = {
				action_name = "action_stab",
				chain_time = 0.1,
			},
			special_action_heavy = {
				action_name = "action_stab_heavy",
				chain_time = 0.65,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip_start",
				chain_time = 0.275,
				reset_combo = true,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.15,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_stab = {
		allowed_during_sprint = true,
		anim_event = "attack_stab",
		damage_window_end = 0.36666666666666664,
		damage_window_start = 0.3,
		first_person_hit_anim = "attack_hit",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.15,
		sprint_requires_press_to_interrupt = true,
		stop_alternate_fire = true,
		total_time = 1.6,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_3",
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			start_modifier = 1.1 * action_movement_curve_mark_modifier,
			{
				t = 0.1,
				modifier = 1.3 * action_movement_curve_mark_modifier,
			},
			{
				t = 0.25,
				modifier = 0.3 * action_movement_curve_mark_modifier,
			},
			{
				t = 0.3,
				modifier = 0.5 * action_movement_curve_mark_modifier,
			},
			{
				t = 0.35,
				modifier = 1.5 * action_movement_curve_mark_modifier,
			},
			{
				t = 0.4,
				modifier = 1.5 * action_movement_curve_mark_modifier,
			},
			{
				t = 0.6,
				modifier = 1.05 * action_movement_curve_mark_modifier,
			},
			{
				t = 1,
				modifier = 0.75 * action_movement_curve_mark_modifier,
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
			},
			shoot_pressed = {
				action_name = "action_shoot_hip_start",
				chain_time = 0.475,
				reset_combo = true,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.575,
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.645,
			},
		},
		weapon_box = {
			0.4,
			2,
			0.2,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/lasgun_rifle_krieg/animations/attack_stab_01",
			anchor_point_offset = {
				0.1,
				1.2,
				-0.15,
			},
		},
		damage_type = damage_types.knife,
		damage_profile = DamageProfileTemplates.bayonette_weapon_special_stab,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_stab_heavy = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_event = "attack_stab_heavy",
		damage_window_end = 0.23333333333333334,
		damage_window_start = 0.1,
		first_person_hit_anim = "attack_hit",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		prevent_sprint = true,
		range_mod = 1.15,
		sprint_requires_press_to_interrupt = true,
		stop_alternate_fire = true,
		total_time = 1.1,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_3",
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			start_modifier = 1.1 * action_movement_curve_mark_modifier,
			{
				t = 0.1,
				modifier = 1.3 * action_movement_curve_mark_modifier,
			},
			{
				t = 0.25,
				modifier = 0.3 * action_movement_curve_mark_modifier,
			},
			{
				t = 0.3,
				modifier = 0.5 * action_movement_curve_mark_modifier,
			},
			{
				t = 0.35,
				modifier = 1.5 * action_movement_curve_mark_modifier,
			},
			{
				t = 0.4,
				modifier = 1.5 * action_movement_curve_mark_modifier,
			},
			{
				t = 0.6,
				modifier = 1.05 * action_movement_curve_mark_modifier,
			},
			{
				t = 1,
				modifier = 0.75 * action_movement_curve_mark_modifier,
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
			},
			shoot_pressed = {
				action_name = "action_shoot_hip_start",
				chain_time = 0.475,
				reset_combo = true,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.575,
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.575,
			},
		},
		weapon_box = {
			0.4,
			2.4,
			0.2,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/lasgun_rifle_krieg/animations/attack_heavy_stab_01",
			anchor_point_offset = {
				0.1,
				0.8,
				0,
			},
		},
		damage_type = damage_types.knife,
		damage_profile = DamageProfileTemplates.bayonette_weapon_special_stab_heavy,
		wounds_shape = wounds_shapes.default,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
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

weapon_template.entry_actions = {
	primary_action = "action_shoot_hip_charged",
	secondary_action = "action_zoom",
}
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/lasgun_rifle_krieg"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/lasgun_rifle_krieg"
weapon_template.reload_template = ReloadTemplates.lasgun
weapon_template.spread_template = "hip_lasgun_killshot_p2_m1"
weapon_template.recoil_template = "hip_lasgun_p2_killshot"
weapon_template.suppression_template = "krieg_lasgun_killshot"
weapon_template.look_delta_template = "lasgun_rifle"
weapon_template.ammo_template = "lasgun_p2_m2"
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_ammo_and_started_reload_no_alternate_fire",
		input_name = "reload",
	},
	{
		conditional_state = "no_ammo_no_alternate_fire_with_delay",
		input_name = "reload",
	},
	{
		conditional_state = "no_ammo_and_started_reload_alternate_fire",
		input_name = "reload",
	},
	{
		conditional_state = "no_ammo_alternate_fire_with_delay",
		input_name = "reload",
	},
}
weapon_template.no_ammo_delay = 0.5
weapon_template.hud_configuration = {
	uses_ammunition = true,
	uses_overheat = false,
}
weapon_template.weapon_special_tweak_data = {
	keep_active_on_sprint = true,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {
	_mag_well = "fx_reload",
	_muzzle = "fx_muzzle_01",
}
weapon_template.crosshair = {
	crosshair_type = "bfg",
}
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	look_delta_template = "lasgun_holo_aiming",
	peeking_mechanics = true,
	recoil_template = "lasgun_p2_m1_ads_killshot",
	spread_template = "default_lasgun_killshot",
	start_anim_event = "to_ironsight",
	stop_anim_event = "to_unaim_ironsight",
	suppression_template = "krieg_lasgun_killshot",
	sway_template = "lasgun_p2_m1_killshot",
	toughness_template = "killshot_zoomed",
	crosshair = {
		crosshair_type = "charge_up_ads",
	},
	camera = {
		custom_vertical_fov = 55,
		near_range = 0.025,
		vertical_fov = 45,
	},
	movement_speed_modifier = {
		{
			modifier = 0.575,
			t = 0.45,
		},
		{
			modifier = 0.55,
			t = 0.47500000000000003,
		},
		{
			modifier = 0.49,
			t = 0.65,
		},
		{
			modifier = 0.5,
			t = 0.7,
		},
		{
			modifier = 0.65,
			t = 0.8,
		},
		{
			modifier = 0.7,
			t = 0.9,
		},
		{
			modifier = 0.7999999999999999,
			t = 2,
		},
	},
}
weapon_template.charge_effects = {
	charge_done_effect_alias = "ranged_charging_done",
	charge_done_source_name = "_muzzle",
	looping_effect_alias = "ranged_charging",
	looping_sound_alias = "ranged_charging",
	sfx_parameter = "charge_level",
	sfx_source_name = "_muzzle",
	vfx_source_name = "_muzzle",
}
weapon_template.weapon_temperature_settings = {
	barrel_threshold = 0.4,
	charge_increase_rate = 0.025,
	decay_rate = 0.025,
	grace_time = 0.4,
	increase_rate = 0.025,
	use_charge = true,
}
weapon_template.keywords = {
	"ranged",
	"lasgun",
	"p2",
	"lasweapon",
}
weapon_template.can_use_while_vaulting = true
weapon_template.dodge_template = "killshot"
weapon_template.sprint_template = "killshot"
weapon_template.stamina_template = "lasrifle"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "lasgun_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.killshot
weapon_template.haptic_trigger_template = HapticTriggerTemplates.ranged.lasgun_p2

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	lasgun_p2_m2_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip_charged = {
				damage_trait_templates.default_dps_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_zoom_shoot_charged = {
				damage_trait_templates.default_dps_stat,
			},
			action_stab = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_stab_heavy = {
				damage_trait_templates.default_melee_dps_stat,
			},
		},
	},
	lasgun_p2_m2_stability_stat = {
		display_name = "loc_stats_display_stability_stat",
		is_stat_trait = true,
		recoil = {
			base = {
				recoil_trait_templates.lasgun_p1_m1_recoil_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("stability_recoil", "loc_weapon_stats_display_hip_fire"),
			},
			alternate_fire = {
				recoil_trait_templates.lasgun_p1_m1_recoil_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("stability_recoil", "loc_weapon_stats_display_ads"),
			},
		},
		spread = {
			base = {
				spread_trait_templates.default_spread_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("stability_spread"),
			},
		},
		sway = {
			alternate_fire = {
				sway_trait_templates.default_sway_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("stability_sway"),
			},
		},
	},
	lasgun_p2_m2_ammo_stat = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	lasgun_p2_m2_charge_speed_stat = {
		display_name = "loc_stats_display_charge_speed",
		is_stat_trait = true,
		charge = {
			action_shoot_hip_start = {
				charge_trait_templates.plasmagun_charge_speed_stat,
				display_data = {
					prefix = "loc_ranged_attack_primary",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_shoot_zoomed_start = {
				charge_trait_templates.plasmagun_charge_speed_stat,
				display_data = {
					prefix = "loc_ranged_attack_secondary_ads",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
		},
	},
	lasgun_p2_m2_power_stat = {
		display_name = "loc_stats_display_power_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip_charged = {
				damage_trait_templates.default_power_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_zoom_shoot_charged = {
				damage_trait_templates.default_power_stat,
			},
		},
	},
}
weapon_template.traits = {}

local bespoke_lasgun_p2_traits = table.ukeys(WeaponTraitsBespokeLasgunP2)

table.append(weapon_template.traits, bespoke_lasgun_p2_traits)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_accurate",
	},
	{
		display_name = "loc_weapon_keyword_charged_attack",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		desc = "loc_stats_fire_mode_hip_fire_desc",
		display_name = "loc_ranged_attack_primary",
		fire_mode = "semi_auto",
		type = "charge",
	},
	secondary = {
		display_name = "loc_weapon_keyword_charged_attack",
		fire_mode = "semi_auto",
		type = "charge",
	},
	special = {
		desc = "loc_stats_special_action_melee_bayonette_desc",
		display_name = "loc_weapon_special_bayonet",
		type = "melee",
	},
}
weapon_template.weapon_card_data = {
	main = {
		{
			header = "hipfire",
			icon = "charge",
			sub_icon = "semi_auto",
			value_func = "primary_attack",
		},
		{
			header = "ads",
			icon = "charge",
			sub_icon = "semi_auto",
			value_func = "secondary_attack",
		},
		{
			header = "ammo",
			value_func = "ammo",
		},
	},
	weapon_special = {
		header = "bayonet",
		icon = "melee",
	},
}
weapon_template.displayed_weapon_stats = "lasgun_p2"

return weapon_template
