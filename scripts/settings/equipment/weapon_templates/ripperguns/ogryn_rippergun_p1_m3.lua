-- chunkname: @scripts/settings/equipment/weapon_templates/ripperguns/ogryn_rippergun_p1_m3.lua

local ActionInputHierarchyUtils = require("scripts/utilities/weapon/action_input_hierarchy")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local ShotshellTemplates = require("scripts/settings/projectile/shotshell_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeRippergunP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_rippergun_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local template_types = WeaponTweakTemplateSettings.template_types
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local recoil_trait_templates = WeaponTraitTemplates[template_types.recoil]
local spread_trait_templates = WeaponTraitTemplates[template_types.spread]
local ammo_trait_templates = WeaponTraitTemplates[template_types.ammo]
local sway_trait_templates = WeaponTraitTemplates[template_types.sway]
local weapon_template = {}

weapon_template.action_inputs = {
	shoot = {
		buffer_time = 0.25,
		input_sequence = {
			{
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	shoot_release = {
		buffer_time = 0.52,
		input_sequence = {
			{
				input = "action_one_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	zoom_shoot = {
		buffer_time = 0.26,
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
		buffer_time = 0.2,
		clear_input_queue = true,
		input_sequence = {
			{
				input = "weapon_reload",
				value = true,
			},
		},
	},
	brace_reload = {
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
		buffer_time = 0.2,
		input_sequence = {
			{
				inputs = wield_inputs,
			},
		},
	},
	stab = {
		buffer_time = 0,
		clear_input_queue = true,
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
		input = "shoot",
		transition = "stay",
	},
	{
		input = "zoom",
		transition = {
			{
				input = "zoom_release",
				transition = "base",
			},
			{
				input = "zoom_shoot",
				transition = "stay",
			},
			{
				input = "brace_reload",
				transition = "stay",
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
		input = "stab",
		transition = "stay",
	},
}

ActionInputHierarchyUtils.add_missing_ordered(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

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
		total_time = 1.15,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_3",
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
			reload = {
				action_name = "action_reload",
				chain_time = 0.275,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.5,
			},
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 0.65,
			},
			stab = {
				action_name = "action_stab",
				chain_time = 0.65,
			},
		},
	},
	action_shoot_hip = {
		abort_sprint = false,
		allowed_during_sprint = false,
		ammunition_usage = 1,
		kind = "shoot_pellets",
		minimum_hold_time = 0.5,
		sprint_ready_up_time = 0.5,
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot",
		total_time = 1,
		weapon_handling_template = "rippergun_semi",
		action_movement_curve = {
			{
				modifier = 0.6,
				t = 0.05,
			},
			{
				modifier = 0.8,
				t = 0.15,
			},
			{
				modifier = 0.875,
				t = 0.175,
			},
			{
				modifier = 0.9,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.7,
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_muzzle_flash_01",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_rippergun_01",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.rippergun_p1_m3_assault,
			damage_type = damage_types.rippergun_pellet,
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
			reload = {
				action_name = "action_reload",
			},
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 0.55,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.6,
			},
			stab = {
				action_name = "action_stab",
				chain_time = 0.65,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_shoot_zoomed = {
		ammunition_usage = 1,
		kind = "shoot_pellets",
		minimum_hold_time = 0.5,
		sprint_ready_up_time = 0,
		start_input = "zoom_shoot",
		total_time = 1,
		weapon_handling_template = "rippergun_burst",
		crosshair = {
			crosshair_type = "spray_n_pray",
		},
		action_movement_curve = {
			{
				modifier = 0.35,
				t = 0.15,
			},
			{
				modifier = 0.55,
				t = 0.3,
			},
			{
				modifier = 0.75,
				t = 1,
			},
			start_modifier = 0.25,
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.rippergun_p1_m3_snp,
			damage_type = damage_types.rippergun_pellet,
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_muzzle_flash_01",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_rippergun_01",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
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
			brace_reload = {
				action_name = "action_brace_reload",
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.65,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.65,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
		action_keywords = {
			"braced",
			"braced_shooting",
		},
	},
	action_zoom = {
		kind = "aim",
		spread_template = "default_rippergun_braced",
		start_input = "zoom",
		total_time = 1.25,
		uninterruptible = true,
		crosshair = {
			crosshair_type = "spray_n_pray",
		},
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_snp,
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
			brace_reload = {
				action_name = "action_brace_reload",
				chain_time = 0.5,
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 1,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.5,
			},
		},
		action_keywords = {
			"braced",
		},
	},
	action_zoom_fast = {
		kind = "aim",
		spread_template = "default_rippergun_braced",
		total_time = 0.55,
		uninterruptible = true,
		crosshair = {
			crosshair_type = "spray_n_pray",
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
			brace_reload = {
				action_name = "action_brace_reload",
				chain_time = 0.25,
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.5,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.25,
			},
		},
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_snp,
		action_keywords = {
			"braced",
		},
	},
	action_unzoom = {
		kind = "unaim",
		spread_template = "default_rippergun_braced",
		start_input = "zoom_release",
		total_time = 0.5,
		crosshair = {
			crosshair_type = "spray_n_pray",
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
			reload = {
				action_name = "action_brace_reload",
				chain_time = 0.25,
			},
			zoom = {
				action_name = "action_zoom_fast",
			},
		},
	},
	action_brace_reload = {
		abort_sprint = true,
		allowed_during_sprint = true,
		kind = "reload_state",
		sprint_requires_press_to_interrupt = true,
		start_input = "brace_reload",
		total_time = 3,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_2",
		crosshair = {
			crosshair_type = "none",
		},
		action_movement_curve = {
			{
				modifier = 0.475,
				t = 0.05,
			},
			{
				modifier = 0.45,
				t = 0.075,
			},
			{
				modifier = 0.39,
				t = 0.25,
			},
			{
				modifier = 0.5,
				t = 0.3,
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
				modifier = 0.75,
				t = 2,
			},
			start_modifier = 0.65,
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
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 3,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 3,
			},
			stab = {
				action_name = "action_stab",
				chain_time = 0.65,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
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
		weapon_handling_template = "time_scale_1_2",
		crosshair = {
			crosshair_type = "none",
		},
		action_movement_curve = {
			{
				modifier = 0.475,
				t = 0.05,
			},
			{
				modifier = 0.45,
				t = 0.075,
			},
			{
				modifier = 0.29,
				t = 0.25,
			},
			{
				modifier = 0.5,
				t = 0.3,
			},
			{
				modifier = 0.75,
				t = 0.8,
			},
			{
				modifier = 0.8,
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
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 3,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 3,
			},
			stab = {
				action_name = "action_stab",
				chain_time = 0.65,
				chain_until = 0.2,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
		},
	},
	action_stab = {
		allowed_during_sprint = true,
		anim_event = "stab",
		damage_window_end = 0.43333333333333335,
		damage_window_start = 0.36666666666666664,
		first_person_hit_anim = "hit_stop",
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "hit_stop",
		hold_combo = false,
		increase_combo = false,
		kind = "sweep",
		range_mod = 1.15,
		start_input = "stab",
		total_time = 1.25,
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
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.6,
			},
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 0.5,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.6,
			},
			stab = {
				action_name = "action_stab",
				chain_time = 0.85,
			},
		},
		conditional_state_to_action_input = {
			started_reload = {
				input_name = "reload",
			},
		},
		weapon_box = {
			0.2,
			1.2,
			0.3,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/rippergun_rifle/stab",
			anchor_point_offset = {
				0.2,
				0.8,
				0,
			},
		},
		damage_type = damage_types.combat_blade,
		damage_profile = DamageProfileTemplates.rippergun_weapon_special,
		herding_template = HerdingTemplates.stab,
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
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.entry_actions = {
	primary_action = "action_shoot_hip",
	secondary_action = "action_zoom",
}
weapon_template.anim_state_machine_3p = "content/characters/player/ogryn/third_person/animations/rippergun"
weapon_template.anim_state_machine_1p = "content/characters/player/ogryn/first_person/animations/rippergun"
weapon_template.reload_template = ReloadTemplates.rippergun
weapon_template.spread_template = "rippergun_p1_m3_assault"
weapon_template.recoil_template = "default_rippergun_assault"
weapon_template.look_delta_template = "default"
weapon_template.ammo_template = "ogryn_rippergun_p1_m1"
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
		input_name = "brace_reload",
	},
	{
		conditional_state = "no_ammo_alternate_fire_with_delay",
		input_name = "brace_reload",
	},
}
weapon_template.no_ammo_delay = 0.5
weapon_template.hud_configuration = {
	uses_ammunition = true,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {
	_eject = "fx_eject",
	_muzzle = "fx_01",
	_special_active = "rp_bayonet_01",
}
weapon_template.crosshair = {
	crosshair_type = "shotgun",
}
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	look_delta_template = "lasgun_brace_light",
	recoil_template = "default_rippergun_spraynpray",
	spread_template = "default_rippergun_braced",
	start_anim_event = "to_braced",
	stop_anim_event = "to_unaim_braced",
	sway_template = "default_rippergun_braced",
	uninterruptible = true,
	crosshair = {
		crosshair_type = "spray_n_pray",
	},
	movement_speed_modifier = {
		{
			modifier = 0.475,
			t = 0.05,
		},
		{
			modifier = 0.45,
			t = 0.075,
		},
		{
			modifier = 0.39,
			t = 0.25,
		},
		{
			modifier = 0.4,
			t = 0.3,
		},
		{
			modifier = 0.6,
			t = 0.4,
		},
		{
			modifier = 0.7,
			t = 0.5,
		},
		{
			modifier = 0.75,
			t = 2,
		},
	},
}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	rippergun_p1_m1_dps_stat = {
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
	rippergun_p1_m1_stability_stat = {
		display_name = "loc_stats_display_stability_stat",
		is_stat_trait = true,
		recoil = {
			base = {
				recoil_trait_templates.rippergun_p1_m1_recoil_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("stability_recoil", "loc_weapon_stats_display_hip_fire"),
			},
			alternate_fire = {
				recoil_trait_templates.rippergun_p1_m1_recoil_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("stability_recoil", "loc_weapon_stats_display_braced"),
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
	shotgun_default_range_stat = {
		display_name = "loc_stats_display_range_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.shotgun_default_range_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_shoot_zoomed = {
				damage_trait_templates.shotgun_default_range_stat,
			},
		},
	},
	shotgun_p1_m1_ammo_stat = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	shotgun_p1_m1_control_stat = {
		display_name = "loc_stats_display_control_stat_ranged",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.shotgun_control_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_shoot_zoomed = {
				damage_trait_templates.shotgun_control_stat,
			},
		},
	},
}
weapon_template.keywords = {
	"ranged",
	"rippergun",
	"p1",
}
weapon_template.dodge_template = "ogryn"
weapon_template.sprint_template = "ogryn"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.ogryn_rippergun
weapon_template.smart_targeting_template = SmartTargetingTemplates.spray_n_pray
weapon_template.traits = {}

local bespoke_traits = table.ukeys(WeaponTraitsBespokeRippergunP1)

table.append(weapon_template.traits, bespoke_traits)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_spread_shot",
	},
	{
		display_name = "loc_weapon_keyword_spray_n_pray",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_ranged_attack_primary",
		fire_mode = "burst",
		type = "hipfire",
	},
	secondary = {
		display_name = "loc_ranged_attack_secondary_braced",
		fire_mode = "burst",
		type = "brace",
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
			icon = "hipfire",
			sub_icon = "burst",
			value_func = "primary_attack",
		},
		{
			header = "brace",
			icon = "brace",
			sub_icon = "burst",
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
weapon_template.explicit_combo = {
	{
		"action_shoot_hip",
	},
	{
		"action_shoot_zoomed",
	},
}
weapon_template.special_action_name = "action_stab"

return weapon_template
