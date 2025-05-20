-- chunkname: @scripts/settings/equipment/weapon_templates/laspistols/laspistol_p1_m1.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local HoloSightTemplates = require("scripts/settings/equipment/holo_sight_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeLaspistolP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_laspistol_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local armor_types = ArmorSettings.types
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local ammo_trait_templates = WeaponTraitTemplates[template_types.ammo]
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local recoil_trait_templates = WeaponTraitTemplates[template_types.recoil]
local spread_trait_templates = WeaponTraitTemplates[template_types.spread]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local sway_trait_templates = WeaponTraitTemplates[template_types.sway]
local weapon_template = {}

weapon_template.action_inputs = {
	shoot_pressed = {
		buffer_time = 0.225,
		max_queue = 2,
		input_sequence = {
			{
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	zoom_shoot = {
		buffer_time = 0.225,
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
		buffer_time = 0.25,
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
	special_action_push = {
		buffer_time = 0.2,
		input_sequence = {
			{
				input = "weapon_extra_pressed",
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
				input = "special_action_push",
				transition = "base",
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
		input = "special_action_push",
		transition = "base",
	},
	{
		input = "wield",
		transition = "stay",
	},
	{
		input = "reload",
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
		total_time = 0.33,
		uninterruptible = true,
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
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.2,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.2,
			},
			reload = {
				action_name = "action_reload",
			},
			special_action_push = {
				{
					action_name = "action_psyker_push",
					chain_time = 0.05,
				},
				{
					action_name = "action_normal_push",
					chain_time = 0.05,
				},
			},
		},
	},
	action_shoot_hip = {
		allow_shots_with_less_than_required_ammo = true,
		allowed_during_sprint = false,
		ammunition_usage = 2,
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0.05,
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot_pressed",
		total_time = 0.5,
		weapon_handling_template = "immediate_single_shot_pistol",
		action_movement_curve = {
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
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/laspistol/laspistol_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			spread_rotated_muzzle_flash = true,
			line_effect = LineEffects.lasbeam_pistol,
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.default_laspistol_beam,
			damage_type = damage_types.laser,
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
				action_name = "action_shoot_hip",
				chain_time = 0.225,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.2,
			},
			special_action_push = {
				{
					action_name = "action_psyker_push",
					chain_time = 0.2,
				},
				{
					action_name = "action_normal_push",
					chain_time = 0.2,
				},
			},
		},
		buff_keywords = {
			buff_keywords.allow_hipfire_during_sprint,
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_shoot_zoomed = {
		allow_shots_with_less_than_required_ammo = true,
		allowed_during_sprint = true,
		ammunition_usage = 2,
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0,
		start_input = "zoom_shoot",
		total_time = 0.3,
		weapon_handling_template = "immediate_single_shot_pistol",
		crosshair = {
			crosshair_type = "ironsight",
		},
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.05,
			},
			{
				modifier = 0.75,
				t = 0.15,
			},
			{
				modifier = 0.775,
				t = 0.175,
			},
			{
				modifier = 0.85,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1,
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/laspistol/laspistol_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			spread_rotated_muzzle_flash = true,
			line_effect = LineEffects.lasbeam_pistol_ads,
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.default_laspistol_beam,
			damage_type = damage_types.laser,
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
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.225,
			},
			special_action_push = {
				{
					action_name = "action_psyker_push",
					chain_time = 0.2,
				},
				{
					action_name = "action_normal_push",
					chain_time = 0.2,
				},
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
		total_time = 0.3,
		crosshair = {
			crosshair_type = "ironsight",
		},
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_killshot,
		action_movement_curve = {
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
			{
				modifier = 0.8,
				t = 1,
			},
			start_modifier = 0.5,
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.05,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
	},
	action_unzoom = {
		kind = "unaim",
		start_input = "zoom_release",
		total_time = 0.2,
		crosshair = {
			crosshair_type = "ironsight",
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
			special_action_push = {
				{
					action_name = "action_psyker_push",
				},
				{
					action_name = "action_normal_push",
				},
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
		crosshair = {
			crosshair_type = "none",
		},
		action_movement_curve = {
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
				chain_time = 2,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 2,
			},
			special_action_push = {
				{
					action_name = "action_psyker_push",
				},
				{
					action_name = "action_normal_push",
				},
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_normal_push = {
		abort_sprint = true,
		action_priority = 1,
		activate_special = true,
		activation_cooldown = 0.1,
		allowed_during_sprint = true,
		anim_event = "weapon_special",
		block_duration = 0.5,
		damage_time = 0.1,
		kind = "push",
		push_radius = 2.5,
		sprint_requires_press_to_interrupt = true,
		start_input = "special_action_push",
		stop_alternate_fire = true,
		total_time = 1,
		uninterruptible = true,
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.1,
			},
			{
				modifier = 0.8,
				t = 0.25,
			},
			{
				modifier = 0.5,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.4,
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
			},
			special_action_push = {
				action_name = "action_normal_push",
				chain_time = 0.8,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.25,
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.25,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.6,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.65,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
		inner_push_rad = math.pi * 0.04,
		outer_push_rad = math.pi * 0.1,
		inner_damage_profile = DamageProfileTemplates.default_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.physical,
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_psyker_push = {
		abort_sprint = true,
		action_priority = 2,
		activate_special = true,
		activation_cooldown = 0.1,
		allowed_during_sprint = true,
		anim_event = "weapon_special_psyker",
		block_duration = 0.5,
		charge_template = "handgun_push_charge",
		damage_time = 0.4,
		kind = "push",
		push_radius = 10,
		sprint_requires_press_to_interrupt = true,
		start_input = "special_action_push",
		stop_alternate_fire = true,
		total_time = 1,
		uninterruptible = true,
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.1,
			},
			{
				modifier = 0.8,
				t = 0.25,
			},
			{
				modifier = 0.5,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.4,
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
			},
			special_action_push = {
				action_name = "action_psyker_push",
				chain_time = 0.8,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.5,
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.5,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.9,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.65,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
		inner_push_rad = math.pi * 0.04,
		outer_push_rad = math.pi * 0.1,
		inner_damage_profile = DamageProfileTemplates.push_psyker,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.push_psyker_outer,
		outer_damage_type = damage_types.physical,
		fx = {
			fx_source = "fx_left_hand_offset_fwd",
			vfx_effect = "content/fx/particles/weapons/swords/forcesword/psyker_push",
		},
		action_condition_func = function (action_settings, condition_func_params, used_input)
			local unit_data_extension = condition_func_params.unit_data_extension
			local archetype = unit_data_extension:archetype()
			local is_psyker = archetype.name == "psyker"

			return is_psyker
		end,
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

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	laspistol_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_dps_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_dps_stat,
			},
		},
	},
	laspistol_mobility_stat = {
		display_name = "loc_stats_display_mobility_stat",
		is_stat_trait = true,
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
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
	laspistol_stability_stat = {
		display_name = "loc_stats_display_stability_stat",
		is_stat_trait = true,
		recoil = {
			base = {
				recoil_trait_templates.default_recoil_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("stability_recoil", "loc_weapon_stats_display_hip_fire"),
			},
			alternate_fire = {
				recoil_trait_templates.default_recoil_stat,
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
	laspistol_power_stat = {
		display_name = "loc_stats_display_power_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_power_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_power_stat,
			},
		},
	},
	laspistol_ammo_stat = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/lasgun_pistol"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/lasgun_pistol"
weapon_template.reload_template = ReloadTemplates.laspistol
weapon_template.spread_template = "default_laspistol_assault"
weapon_template.recoil_template = "default_laspistol_assault"
weapon_template.suppression_template = "hip_laspistol_killshot"
weapon_template.look_delta_template = "laspistol"
weapon_template.ammo_template = "laspistol_p1_m1"
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
weapon_template.no_ammo_delay = 0.25
weapon_template.hud_configuration = {
	uses_ammunition = true,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.02
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {
	_mag_well = "fx_reload",
	_muzzle = "fx_muzzle_01",
}
weapon_template.crosshair = {
	crosshair_type = "assault",
}
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	look_delta_template = "laspistol_holo_aiming",
	peeking_mechanics = true,
	recoil_template = "default_laspistol_killshot",
	spread_template = "default_laspistol_killshot",
	start_anim_event = "to_reflex",
	stop_anim_event = "to_unaim_reflex",
	suppression_template = "default_laspistol_killshot",
	sway_template = "default_laspistol_killshot",
	toughness_template = "killshot_zoomed",
	crosshair = {
		crosshair_type = "ironsight",
	},
	camera = {
		custom_vertical_fov = 30,
		near_range = 0.025,
		vertical_fov = 50,
	},
	action_movement_curve = {
		{
			modifier = 0.6,
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
		{
			modifier = 0.7,
			t = 1,
		},
		start_modifier = 0.8,
	},
}
weapon_template.keywords = {
	"ranged",
	"laspistol",
	"p1",
	"lasweapon",
}
weapon_template.can_use_while_vaulting = true
weapon_template.dodge_template = "assault"
weapon_template.sprint_template = "ninja_l"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "assault"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.killshot
weapon_template.holo_sight_template = HoloSightTemplates.laspistol
weapon_template.haptic_trigger_template = HapticTriggerTemplates.ranged.spray_n_pray
weapon_template.traits = {}

local bespoke_lasgun_p1_traits = table.ukeys(WeaponTraitsBespokeLaspistolP1)

table.append(weapon_template.traits, bespoke_lasgun_p1_traits)

weapon_template.hipfire_inputs = {
	shoot_pressed = true,
}
weapon_template.weapon_temperature_settings = {
	barrel_threshold = 0.4,
	decay_rate = 0.075,
	grace_time = 0.4,
	increase_rate = 0.07,
	use_charge = false,
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_mobile",
	},
	{
		display_name = "loc_weapon_keyword_high_ammo_count",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_ranged_attack_primary",
		fire_mode = "semi_auto",
		type = "hipfire",
	},
	secondary = {
		display_name = "loc_ranged_attack_secondary_ads",
		fire_mode = "semi_auto",
		type = "ads",
	},
	special = {
		desc = "loc_stats_special_action_melee_push_desc",
		display_name = "loc_pushing",
		type = "melee_hand",
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
			header = "ads",
			icon = "ads",
			sub_icon = "semi_auto",
			value_func = "secondary_attack",
		},
		{
			header = "ammo",
			value_func = "ammo",
		},
	},
	weapon_special = {
		header = "weapon_bash",
		icon = "melee_hand",
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
weapon_template.special_action_name = "action_normal_push"

return weapon_template
