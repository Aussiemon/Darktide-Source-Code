-- chunkname: @scripts/settings/equipment/weapon_templates/stub_pistols/stubrevolver_p1_m2.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
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
local WeaponTraitsBespokeStubrevolverP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_stubrevolver_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local recoil_trait_templates = WeaponTraitTemplates[template_types.recoil]
local spread_trait_templates = WeaponTraitTemplates[template_types.spread]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local weapon_template = {}

weapon_template.action_inputs = {
	shoot_pressed = {
		buffer_time = 0.25,
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
		buffer_time = 0,
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
	special_action_pistol_whip = {
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
				input = "special_action_pistol_whip",
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
		input = "special_action_pistol_whip",
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
		total_time = 0.4,
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
				chain_time = 0.1,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.2,
			},
			reload = {
				action_name = "action_start_reload",
				chain_time = 0.1,
			},
			special_action_pistol_whip = {
				action_name = "action_pistol_whip",
				chain_time = 0.2,
			},
		},
	},
	action_shoot_hip = {
		allowed_during_sprint = false,
		ammunition_usage = 1,
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0.2,
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot_pressed",
		total_time = 0.56,
		weapon_handling_template = "stubrevolver_single_shot",
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
			start_modifier = 0.75,
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
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.stub_revolver_p1_m2_hip,
			damage_type = damage_types.auto_bullet,
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
				action_name = "action_start_reload",
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.4,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.1,
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
		allowed_during_sprint = true,
		ammunition_usage = 1,
		kind = "shoot_hit_scan",
		recoil_template = "stub_pistol_p1_m2_ads",
		spread_template = "stub_pistol_p1_m2_ads",
		sprint_ready_up_time = 0,
		start_input = "zoom_shoot",
		total_time = 0.56,
		weapon_handling_template = "stubrevolver_single_shot",
		haptic_trigger_template = HapticTriggerTemplates.ranged.stubrevolver_p1_m2_special_shoot,
		crosshair = {
			crosshair_type = "bfg",
		},
		action_movement_curve = {
			{
				modifier = 0.6,
				t = 0.05,
			},
			{
				modifier = 0.65,
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
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_crit_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle_crit",
			muzzle_flash_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			line_effect = LineEffects.autogun_bullet,
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.stub_revolver_p1_m2,
			damage_type = damage_types.auto_bullet,
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
				action_name = "action_start_reload",
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.21,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.225,
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
			crosshair_type = "bfg",
		},
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_bfg,
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
				action_name = "action_start_reload",
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.2,
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
			crosshair_type = "bfg",
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			reload = {
				action_name = "action_start_reload",
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
	action_start_reload = {
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
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "reload",
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			special_action_pistol_whip = {
				action_name = "action_pistol_whip",
				chain_time = 0.4,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 3,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 3,
			},
			wield = {
				action_name = "action_unwield",
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_pistol_whip = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_event = "attack_stab_01",
		damage_window_end = 0.31666666666666665,
		damage_window_start = 0.25,
		first_person_hit_anim = "attack_hit",
		first_person_hit_stop_anim = "attack_hit",
		kind = "sweep",
		power_level = 300,
		range_mod = 1,
		sprint_requires_press_to_interrupt = true,
		start_input = "special_action_pistol_whip",
		stop_alternate_fire = true,
		total_time = 0.9,
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
			wield = {
				action_name = "action_unwield",
				chain_time = 0.6,
			},
			reload = {
				action_name = "action_start_reload",
				chain_time = 0.6,
			},
			special_action_pistol_whip = {
				action_name = "action_pistol_whip_followup",
				chain_time = 0.55,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.6,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.9,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
		weapon_box = {
			0.1,
			1.1,
			0.2,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/stubgun_pistol/pistol_whip",
				anchor_point_offset = {
					0.2,
					0.8,
					0,
				},
			},
		},
		damage_type = damage_types.weapon_butt,
		damage_profile = DamageProfileTemplates.weapon_special_push,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_pistol_whip_followup = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_event = "attack_stab_02",
		damage_window_end = 0.31666666666666665,
		damage_window_start = 0.25,
		first_person_hit_anim = "attack_hit",
		first_person_hit_stop_anim = "attack_hit",
		kind = "sweep",
		power_level = 300,
		range_mod = 1,
		sprint_requires_press_to_interrupt = true,
		stop_alternate_fire = true,
		total_time = 0.85,
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
			wield = {
				action_name = "action_unwield",
				chain_time = 0.6,
			},
			reload = {
				action_name = "action_start_reload",
				chain_time = 0.6,
			},
			special_action_pistol_whip = {
				action_name = "action_pistol_whip",
				chain_time = 0.6,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.8,
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.75,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.4,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.85,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
		weapon_box = {
			0.1,
			1.1,
			0.2,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/stubgun_pistol/pistol_whip_02",
				anchor_point_offset = {
					0.2,
					0.8,
					0,
				},
			},
		},
		damage_type = damage_types.weapon_butt,
		damage_profile = DamageProfileTemplates.weapon_special_push,
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

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/stubgun_pistol"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/stubgun_pistol"
weapon_template.reload_template = ReloadTemplates.stubrevolver
weapon_template.spread_template = "stub_pistol_p1_m2_hip"
weapon_template.recoil_template = "stub_pistol_p1_m2_hip"
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
weapon_template.no_ammo_delay = 0.35
weapon_template.hud_configuration = {
	uses_ammunition = true,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.ammo_template = "stubrevolver_p1_m2"
weapon_template.fx_sources = {
	_muzzle = "fx_muzzle_01",
}
weapon_template.crosshair = {
	crosshair_type = "bfg",
}
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	look_delta_template = "stub_pistol_aiming",
	peeking_mechanics = true,
	recoil_template = "stub_pistol_p1_m2_ads",
	spread_template = "stub_pistol_p1_m2_ads",
	start_anim_event = "to_braced",
	stop_anim_event = "to_unaim_braced",
	suppression_template = "stub_pistol_p1_m1_suppression_killshot",
	sway_template = "default_stubpistol_killshot",
	crosshair = {
		crosshair_type = "bfg",
	},
	camera = {
		custom_vertical_fov = 65,
		near_range = 0.025,
		vertical_fov = 65,
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
	movement_speed_modifier = {
		{
			modifier = 0.52,
			t = 0.25,
		},
		{
			modifier = 0.73,
			t = 0.6,
		},
	},
}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	stubrevolver_dps_stat = {
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
		},
	},
	stubrevolver_reload_speed_stat = {
		display_name = "loc_stats_display_reload_speed_stat",
		is_stat_trait = true,
		weapon_handling = {
			action_start_reload = {
				weapon_handling_trait_templates.default_reload_speed_modify,
				display_data = {
					display_stats = {
						__all_basic_stats = true,
						time_scale = {
							display_name = "loc_weapon_stats_display_reload_speed",
						},
					},
				},
			},
		},
	},
	stubrevolver_mobility_stat = {
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
	stubrevolver_armor_piercing_stat = {
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
		},
	},
	stubrevolver_crit_stat = {
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
		},
		damage = {
			action_shoot_hip = {
				damage_trait_templates.stubrevolver_crit_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_shoot_zoomed = {
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
weapon_template.haptic_trigger_template = HapticTriggerTemplates.ranged.killshot_semiauto
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
		desc = "loc_stats_special_action_melee_weapon_bash_desc",
		display_name = "loc_weapon_special_weapon_bash",
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
weapon_template.special_action_name = "action_pistol_whip"

return weapon_template
