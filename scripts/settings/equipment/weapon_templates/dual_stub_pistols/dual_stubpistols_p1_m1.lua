-- chunkname: @scripts/settings/equipment/weapon_templates/dual_stub_pistols/dual_stubpistols_p1_m1.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local Ammo = require("scripts/utilities/ammo")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeStubrevolverP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_stubrevolver_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local MultiFireModes = require("scripts/settings/equipment/weapon_templates/multi_fire_modes")
local SpreadTemplates = require("scripts/settings/equipment/weapon_templates/dual_stub_pistols/settings_templates/dual_stub_pistols_spread_templates")
local damage_types = DamageSettings.damage_types
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local wield_inputs = PlayerCharacterConstants.wield_inputs
local template_types = WeaponTweakTemplateSettings.template_types
local armor_types = ArmorSettings.types
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local recoil_trait_templates = WeaponTraitTemplates[template_types.recoil]
local spread_trait_templates = WeaponTraitTemplates[template_types.spread]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local weapon_template = {}
local action_movement_curves = {
	wield = {
		{
			modifier = 0.7,
			t = 0.05,
		},
		{
			modifier = 0.95,
			t = 0.1,
		},
		{
			modifier = 1,
			t = 0.25,
		},
		{
			modifier = 1.15,
			t = 0.4,
		},
		{
			modifier = 1,
			t = 1,
		},
		start_modifier = 0.8,
	},
	brace = {
		{
			modifier = 0.75,
			t = 0.05,
		},
		{
			modifier = 0.75,
			t = 0.15,
		},
		{
			modifier = 0.725,
			t = 0.175,
		},
		{
			modifier = 0.85,
			t = 0.3,
		},
		start_modifier = 0.5,
	},
	shoot = {
		{
			modifier = 0.95,
			t = 0.1,
		},
		{
			modifier = 1.1,
			t = 0.15,
		},
		{
			modifier = 1.1,
			t = 0.175,
		},
		{
			modifier = 1.05,
			t = 0.3,
		},
		{
			modifier = 1,
			t = 0.5,
		},
		start_modifier = 1,
	},
	shoot_zoomed = {
		{
			modifier = 0.95,
			t = 0.1,
		},
		{
			modifier = 0.8,
			t = 0.15,
		},
		{
			modifier = 1.05,
			t = 0.3,
		},
		{
			modifier = 1,
			t = 0.5,
		},
		start_modifier = 0.5,
	},
	reload = {
		{
			modifier = 0.875,
			t = 0.05,
		},
		{
			modifier = 0.95,
			t = 0.075,
		},
		{
			modifier = 0.99,
			t = 0.25,
		},
		{
			modifier = 1,
			t = 0.3,
		},
		{
			modifier = 1.05,
			t = 0.8,
		},
		{
			modifier = 1.05,
			t = 0.9,
		},
		{
			modifier = 1,
			t = 2,
		},
		start_modifier = 1,
	},
	twirl = {
		{
			modifier = 1.2,
			t = 0.1,
		},
		{
			modifier = 1.35,
			t = 0.15,
		},
		{
			modifier = 1.15,
			t = 0.175,
		},
		{
			modifier = 1.05,
			t = 0.3,
		},
		{
			modifier = 1,
			t = 0.5,
		},
		start_modifier = 1,
	},
	twirl_shoot = {
		{
			modifier = 1.2,
			t = 0.1,
		},
		{
			modifier = 1.35,
			t = 0.15,
		},
		{
			modifier = 1.15,
			t = 0.175,
		},
		{
			modifier = 1.05,
			t = 0.3,
		},
		{
			modifier = 1,
			t = 0.5,
		},
		start_modifier = 1,
	},
}

weapon_template.action_inputs = {
	shoot_pressed = {
		buffer_time = 0.45,
		max_queue = 2,
		input_sequence = {
			{
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	zoom_shoot = {
		buffer_time = 0.25,
		max_queue = 2,
		input_sequence = {
			{
				input = "action_one_pressed",
				value = true,
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
				input = "weapon_reload_pressed",
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
	weapon_special = {
		buffer_time = 0.4,
		input_sequence = {
			{
				input = "weapon_extra_hold",
				value = true,
			},
		},
	},
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		input = "shoot_pressed",
		transition = "stay",
	},
	{
		input = "zoom",
		transition = {
			{
				input = "zoom_release",
				transition = "previous",
			},
			{
				input = "zoom_shoot",
				transition = "stay",
			},
			{
				input = "reload",
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
		input = "wield",
		transition = "stay",
	},
	{
		input = "reload",
		transition = "stay",
	},
	{
		input = "weapon_special",
		transition = "stay",
	},
}

ActionInputHierarchy.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

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
		total_time = 0.4,
		uninterruptible = true,
		wield_anim_event = "equip",
		wield_reload_anim_event = "equip_reload",
		action_movement_curve = {
			{
				modifier = 0.7,
				t = 0.05,
			},
			{
				modifier = 0.95,
				t = 0.1,
			},
			{
				modifier = 1,
				t = 0.25,
			},
			{
				modifier = 1.15,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 0.8,
		},
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
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.175,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.35,
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.175,
			},
		},
	},
	action_shoot_hip = {
		ammunition_usage = 1,
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0.2,
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot_pressed",
		total_time = 0.35,
		weapon_handling_template = "dual_stubpistols_single_shot",
		action_movement_curve = {
			{
				modifier = 0.95,
				t = 0.1,
			},
			{
				modifier = 0.9,
				t = 0.15,
			},
			{
				modifier = 0.85,
				t = 0.175,
			},
			{
				modifier = 1.05,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 1,
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_crit_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle_crit",
			muzzle_flash_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			line_effect = LineEffects.autogun_bullet,
		},
		multi_fire_mode = MultiFireModes.alternating,
		fire_configurations = {
			{
				anim_event = "attack_shoot_right",
				anim_event_3p = "attack_shoot_right",
				reference_attachment_id = "right",
				same_side_suppression_enabled = false,
				hit_scan_template = HitScanTemplates.dual_stub_pistols_base,
				damage_type = damage_types.auto_bullet,
				haptic_trigger_template = HapticTriggerTemplates.ranged.dual_stubpistol_right,
			},
			{
				anim_event = "attack_shoot_left",
				anim_event_3p = "attack_shoot_left",
				reference_attachment_id = "left",
				same_side_suppression_enabled = false,
				hit_scan_template = HitScanTemplates.dual_stub_pistols_base,
				damage_type = damage_types.auto_bullet,
				haptic_trigger_template = HapticTriggerTemplates.ranged.dual_stubpistol_left,
			},
		},
		haptic_trigger_template_condition_func = function (action_settings, condition_func_params)
			local action_shoot_component = condition_func_params.action_shoot_component
			local current_fire_config = action_shoot_component.current_fire_config
			local fire_configurations = action_settings.fire_configurations
			local fire_config = fire_configurations[current_fire_config]

			if fire_config then
				local haptic_trigger_template = fire_config.haptic_trigger_template

				return haptic_trigger_template
			end
		end,
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
				action_name = "action_shoot_hip",
				chain_time = 0.18,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.085,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
		buff_keywords = {
			buff_keywords.allow_hipfire_during_sprint,
		},
	},
	action_shoot_zoomed = {
		ammunition_usage = 1,
		anim_event = nil,
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0.2,
		sprint_requires_press_to_interrupt = true,
		start_input = "zoom_shoot",
		total_time = 0.31,
		weapon_handling_template = "dual_stubpistols_single_shot",
		action_keywords = {
			"braced",
			"braced_shooting",
		},
		action_movement_curve = {
			{
				modifier = 0.95,
				t = 0.1,
			},
			{
				modifier = 0.85,
				t = 0.15,
			},
			{
				modifier = 0.95,
				t = 0.175,
			},
			{
				modifier = 1.05,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.85,
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_crit_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle_crit",
			muzzle_flash_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			line_effect = LineEffects.autogun_bullet,
		},
		multi_fire_mode = MultiFireModes.alternating,
		fire_configurations = {
			{
				anim_event = "attack_shoot_right",
				anim_event_3p = "attack_shoot_right",
				reference_attachment_id = "right",
				same_side_suppression_enabled = false,
				hit_scan_template = HitScanTemplates.dual_stub_pistols_base,
				damage_type = damage_types.auto_bullet,
				haptic_trigger_template = HapticTriggerTemplates.ranged.dual_stubpistol_right,
			},
			{
				anim_event = "attack_shoot_left",
				anim_event_3p = "attack_shoot_left",
				reference_attachment_id = "left",
				same_side_suppression_enabled = false,
				hit_scan_template = HitScanTemplates.dual_stub_pistols_base,
				damage_type = damage_types.auto_bullet,
				haptic_trigger_template = HapticTriggerTemplates.ranged.dual_stubpistol_left,
			},
		},
		haptic_trigger_template_condition_func = function (action_settings, condition_func_params)
			local action_shoot_component = condition_func_params.action_shoot_component
			local current_fire_config = action_shoot_component.current_fire_config
			local fire_configurations = action_settings.fire_configurations
			local fire_config = fire_configurations[current_fire_config]

			if fire_config then
				local haptic_trigger_template = fire_config.haptic_trigger_template

				return haptic_trigger_template
			end
		end,
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
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.18,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.085,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_zoom = {
		kind = "aim",
		start_input = "zoom",
		total_time = 0.35,
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_bfg,
		action_keywords = {
			"braced",
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
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.225,
			},
		},
	},
	action_unzoom = {
		kind = "unaim",
		start_input = "zoom_release",
		total_time = 0.2,
		action_movement_curve = {
			{
				modifier = 0.85,
				t = 0.15,
			},
			start_modifier = 0.8,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			reload = {
				action_name = "action_reload",
			},
			wield = {
				action_name = "action_unwield",
			},
			zoom = {
				action_name = "action_zoom",
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.2,
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
		total_time = 2.2,
		uninterruptible = false,
		crosshair = {
			crosshair_type = "none",
		},
		action_movement_curve = action_movement_curves.reload,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 2.2,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 2.2,
			},
			zoom_release = {
				action_name = "action_unzoom",
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_special_twirl_right = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_event = "special_twirl_right",
		anim_event_3p = "special_twirl_right",
		kind = "windup",
		spread_template = "dual_stub_pistols_spin",
		sprint_requires_press_to_interrupt = true,
		start_input = "weapon_special",
		total_time = 1.16,
		uninterruptible = false,
		weapon_handling_template = "time_scale_1_1",
		action_movement_curve = {
			{
				modifier = 0.95,
				t = 0.05,
			},
			{
				modifier = 0.95,
				t = 0.15,
			},
			{
				modifier = 0.925,
				t = 0.175,
			},
			{
				modifier = 0.95,
				t = 0.3,
			},
			start_modifier = 0.9,
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.6,
			},
			shoot_pressed = {
				action_name = "action_special_shoot_right",
				chain_time = 0.75,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.6,
			},
			weapon_special = {
				action_name = "action_special_twirl_left",
				chain_time = 0.9,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_special_twirl_left = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_event = "special_twirl_left",
		anim_event_3p = "special_twirl_left",
		kind = "windup",
		spread_template = "dual_stub_pistols_spin",
		sprint_requires_press_to_interrupt = true,
		start_input = nil,
		total_time = 1.16,
		uninterruptible = false,
		weapon_handling_template = "time_scale_1_1",
		action_movement_curve = {
			{
				modifier = 0.95,
				t = 0.05,
			},
			{
				modifier = 0.95,
				t = 0.15,
			},
			{
				modifier = 0.925,
				t = 0.175,
			},
			{
				modifier = 0.95,
				t = 0.3,
			},
			start_modifier = 0.9,
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.6,
			},
			shoot_pressed = {
				action_name = "action_special_shoot_left",
				chain_time = 0.75,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.6,
			},
			weapon_special = {
				action_name = "action_special_twirl_right",
				chain_time = 0.9,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_special_shoot_right = {
		ammunition_usage = 1,
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0.2,
		sprint_requires_press_to_interrupt = true,
		start_input = nil,
		total_time = 0.7,
		weapon_handling_template = "dual_stubpistols_spin_shot",
		action_movement_curve = action_movement_curves.twirl_shoot,
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_crit_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle_crit",
			muzzle_flash_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			shoot_sfx_alias = "ranged_single_shot_special_extra",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			line_effect = LineEffects.autogun_bullet,
		},
		multi_fire_mode = MultiFireModes.single,
		fire_configurations = {
			{
				anim_event = "attack_twirl_shoot_right",
				anim_event_3p = "attack_shoot",
				reference_attachment_id = "right",
				same_side_suppression_enabled = false,
				hit_scan_template = HitScanTemplates.dual_stub_pistols_special,
				damage_type = damage_types.auto_bullet,
				haptic_trigger_template = HapticTriggerTemplates.ranged.dual_stubpistol_right,
			},
			{
				anim_event = "attack_twirl_shoot_right",
				anim_event_3p = "attack_shoot",
				reference_attachment_id = "right",
				same_side_suppression_enabled = false,
				hit_scan_template = HitScanTemplates.dual_stub_pistols_special,
				damage_type = damage_types.auto_bullet,
				haptic_trigger_template = HapticTriggerTemplates.ranged.dual_stubpistol_right,
			},
		},
		haptic_trigger_template_condition_func = function (action_settings, condition_func_params)
			local action_shoot_component = condition_func_params.action_shoot_component
			local current_fire_config = action_shoot_component.current_fire_config
			local fire_configurations = action_settings.fire_configurations
			local fire_config = fire_configurations[current_fire_config]

			if fire_config then
				local haptic_trigger_template = fire_config.haptic_trigger_template

				return haptic_trigger_template
			end
		end,
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.3,
			},
			reload = {
				action_name = "action_reload",
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.45,
			},
			weapon_special = {
				action_name = "action_special_twirl_left",
				chain_time = 0.35,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_special_shoot_left = {
		ammunition_usage = 1,
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0.2,
		sprint_requires_press_to_interrupt = true,
		start_input = nil,
		total_time = 0.7,
		weapon_handling_template = "dual_stubpistols_spin_shot",
		action_movement_curve = action_movement_curves.twirl_shoot,
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_crit_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle_crit",
			muzzle_flash_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			shoot_sfx_alias = "ranged_single_shot_special_extra",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			line_effect = LineEffects.autogun_bullet,
		},
		multi_fire_mode = MultiFireModes.single,
		fire_configurations = {
			{
				anim_event = "attack_twirl_shoot_left",
				anim_event_3p = "attack_shoot_left",
				reference_attachment_id = "left",
				same_side_suppression_enabled = false,
				hit_scan_template = HitScanTemplates.dual_stub_pistols_special,
				damage_type = damage_types.auto_bullet,
				haptic_trigger_template = HapticTriggerTemplates.ranged.dual_stubpistol_left,
			},
			{
				anim_event = "attack_twirl_shoot_left",
				anim_event_3p = "attack_shoot_right",
				reference_attachment_id = "left",
				same_side_suppression_enabled = false,
				hit_scan_template = HitScanTemplates.dual_stub_pistols_special,
				damage_type = damage_types.auto_bullet,
				haptic_trigger_template = HapticTriggerTemplates.ranged.dual_stubpistol_left,
			},
		},
		haptic_trigger_template_condition_func = function (action_settings, condition_func_params)
			local action_shoot_component = condition_func_params.action_shoot_component
			local current_fire_config = action_shoot_component.current_fire_config
			local fire_configurations = action_settings.fire_configurations
			local fire_config = fire_configurations[current_fire_config]

			if fire_config then
				local haptic_trigger_template = fire_config.haptic_trigger_template

				return haptic_trigger_template
			end
		end,
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.3,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.45,
			},
			weapon_special = {
				action_name = "action_special_twirl_right",
				chain_time = 0.35,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
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

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/dual_stubgun_pistol"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/dual_stubgun_pistol"
weapon_template.reload_template = ReloadTemplates.dual_stubpistols
weapon_template.spread_template = "dual_stub_pistols_hip"
weapon_template.recoil_template = "dual_stub_pistols_hip"
weapon_template.suppression_template = "dual_stub_pistols"
weapon_template.look_delta_template = "stub_pistol"
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_ammo_and_started_reload",
		input_name = "reload",
	},
	{
		conditional_state = "no_ammo_with_delay",
		input_name = "reload",
	},
}
weapon_template.no_ammo_delay = 0.45
weapon_template.hud_configuration = {
	uses_ammunition = true,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.ammo_template = "dual_stubpistols_p1_m1"
weapon_template.fx_sources = {
	_muzzle = "fx_muzzle_01",
}
weapon_template.crosshair = {
	crosshair_type = "assault",
}
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	look_delta_template = "laspistol",
	peeking_mechanics = true,
	recoil_template = "dual_stub_pistols_braced",
	spread_template = "dual_stub_pistols_braced",
	start_anim_event = "to_braced",
	stop_anim_event = "to_unaim_braced",
	suppression_template = "dual_stub_pistols",
	crosshair = {
		crosshair_type = "assault",
	},
	camera = {
		custom_vertical_fov = 55,
		near_range = 0.025,
		vertical_fov = 60,
	},
	movement_speed_modifier = {
		{
			modifier = 0.99,
			t = 0,
		},
		{
			modifier = 1.07,
			t = 0.25,
		},
		{
			modifier = 1.07,
			t = 0.35,
		},
		{
			modifier = 1.2,
			t = 0.5,
		},
		{
			modifier = 1.2,
			t = 1,
		},
		start_modifier = 1,
	},
}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	dual_stubpistols_p1_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.stubrevolver_dps_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_shoot_zoomed = {
				damage_trait_templates.stubrevolver_dps_stat,
			},
			action_special_shoot_right = {
				damage_trait_templates.stubrevolver_dps_stat,
			},
			action_special_shoot_left = {
				damage_trait_templates.stubrevolver_dps_stat,
			},
		},
	},
	dual_stubpistols_p1_control_stat = {
		display_name = "loc_stats_display_control_stat_ranged",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.autopistol_control_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_shoot_zoomed = {
				damage_trait_templates.autopistol_control_stat,
			},
			action_special_shoot_right = {
				damage_trait_templates.autopistol_control_stat,
			},
			action_special_shoot_left = {
				damage_trait_templates.autopistol_control_stat,
			},
		},
	},
	dual_stubpistols_p1_mobility_stat = {
		display_name = "loc_stats_display_mobility_stat",
		is_stat_trait = true,
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_dodge"),
			},
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_sprint"),
			},
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_curve"),
			},
		},
		recoil = {
			base = {
				recoil_trait_templates.default_mobility_recoil_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_recoil", "loc_weapon_stats_display_hip_fire"),
			},
			alternate_fire = {
				recoil_trait_templates.default_mobility_recoil_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_recoil", "loc_weapon_stats_display_ads"),
			},
		},
		spread = {
			base = {
				spread_trait_templates.default_mobility_spread_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_spread"),
			},
		},
	},
	dual_stubpistols_p1_piercing_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.stubrevolver_armor_piercing_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_shoot_zoomed = {
				damage_trait_templates.stubrevolver_armor_piercing_stat,
			},
			action_special_shoot_right = {
				damage_trait_templates.stubrevolver_armor_piercing_stat,
			},
			action_special_shoot_left = {
				damage_trait_templates.stubrevolver_armor_piercing_stat,
			},
		},
	},
	dual_stubpistols_p1_crit_stat = {
		display_name = "loc_stats_display_crit_stat",
		is_stat_trait = true,
		weapon_handling = {
			action_shoot_hip = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
				display_data = {
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
			action_shoot_zoomed = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_special_shoot_right = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_special_shoot_left = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
		},
		damage = {
			action_shoot_hip = {
				damage_trait_templates.stubrevolver_crit_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_shoot_zoomed = {
				damage_trait_templates.stubrevolver_crit_stat,
			},
			action_special_shoot_right = {
				damage_trait_templates.stubrevolver_crit_stat,
			},
			action_special_shoot_left = {
				damage_trait_templates.stubrevolver_crit_stat,
			},
		},
	},
}
weapon_template.keywords = {
	"ranged",
	"stub_pistol",
	"p1",
}
weapon_template.can_use_while_vaulting = true
weapon_template.dodge_template = "assault"
weapon_template.sprint_template = "assault"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "assault"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.movement_curve_modifier_template = "default"
weapon_template.smart_targeting_template = SmartTargetingTemplates.killshot
weapon_template.haptic_trigger_template = HapticTriggerTemplates.ranged.dual_stubpistol_right
weapon_template.hipfire_inputs = {
	shoot_pressed = true,
}
weapon_template.traits = {}

local bespoke_stubrevolver_p1_traits = table.ukeys(WeaponTraitsBespokeStubrevolverP1)

table.append(weapon_template.traits, bespoke_stubrevolver_p1_traits)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_high_damage",
	},
	{
		display_name = "loc_weapon_keyword_accurate",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_ranged_attack_primary",
		fire_mode = "semi_auto",
		type = "hipfire",
	},
	secondary = {
		display_name = "loc_ranged_attack_secondary_braced",
		fire_mode = "semi_auto",
		type = "brace",
	},
	special = {
		desc = "loc_stats_special_action_weapon_powerup_dual_stubpistols_p1_desc",
		display_name = "loc_weapon_special_weapon_powerup_dual_stubpistols_p1",
		type = "activate",
	},
}
weapon_template.weapon_card_data = {
	main = {
		{
			header = "hipfire",
			icon = "hipfire",
			sub_icon = "semi_auto",
			value_func = "primary_attack",
		},
		{
			header = "brace",
			icon = "brace",
			sub_icon = "semi_auto",
			value_func = "secondary_attack",
		},
		{
			header = "ammo",
			value_func = "ammo",
		},
	},
	weapon_special = {
		header = "special_attack",
		icon = "activate",
	},
}
weapon_template.explicit_combo = {
	{
		"action_shoot_hip",
	},
	{
		"action_shoot_zoomed",
	},
}

return weapon_template
