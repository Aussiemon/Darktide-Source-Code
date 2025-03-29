-- chunkname: @scripts/settings/equipment/weapon_templates/ogryn_heavystubbers/ogryn_heavystubber_p1_m3.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsOgrynHeavystubbertP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_heavystubber_p1")
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
				input = "action_one_hold",
				value = true,
			},
		},
	},
	shoot_release = {
		buffer_time = 0.25,
		input_sequence = {
			{
				input = "action_one_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	zoom_shoot = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				input = "action_one_hold",
				value = true,
			},
		},
	},
	zoom = {
		buffer_time = 0.4,
		max_queue = 1,
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
		transition = {
			{
				input = "shoot_release",
				transition = "base",
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
			{
				input = "zoom",
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
				input = "zoom_shoot",
				transition = {
					{
						input = "reload",
						transition = "base",
					},
					{
						input = "zoom_release",
						transition = "base",
					},
					{
						input = "shoot_release",
						transition = "previous",
					},
					{
						input = "wield",
						transition = "base",
					},
				},
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
		input = "stab",
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
		total_time = 1,
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
				chain_time = 0.245,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.5,
			},
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 1,
			},
			stab = {
				action_name = "action_stab",
				chain_time = 0.63,
			},
		},
	},
	action_shoot_hip = {
		abort_sprint = false,
		allowed_during_sprint = false,
		ammunition_usage = 1,
		kind = "shoot_hit_scan",
		minimum_hold_time = 0.025,
		sprint_ready_up_time = 0.5,
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot",
		stop_input = "shoot_release",
		weapon_handling_template = "ogryn_heavystubber_p1_m3_hip_fire",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.95,
				t = 0.05,
			},
			{
				modifier = 0.96,
				t = 0.15,
			},
			{
				modifier = 0.97,
				t = 0.175,
			},
			{
				modifier = 0.98,
				t = 0.3,
			},
			{
				modifier = 0.99,
				t = 0.5,
			},
			start_modifier = 0.95,
		},
		fx = {
			alternate_muzzle_flashes = true,
			alternate_shell_casings = true,
			auto_fire_time_parameter_name = "wpn_fire_interval",
			crit_shoot_sfx_alias = "critical_shot_extra",
			looping_shoot_sfx_alias = "ranged_shooting",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/ogryn_heavystubber/ogryn_heavystubber_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			num_pre_loop_events = 1,
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			post_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			pre_loop_shoot_sfx_alias = "ranged_pre_loop_shot",
			pre_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_heavystubber_01",
			line_effect = LineEffects.heavy_stubber_bullet,
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.default_ogryn_heavystubber_full_auto_m3,
			damage_type = damage_types.heavy_stubber_bullet,
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
				chain_time = 0.5,
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
		anim_end_event = "attack_finished",
		kind = "shoot_hit_scan",
		minimum_hold_time = 0.1,
		sprint_ready_up_time = 0,
		start_input = "zoom_shoot",
		stop_input = "shoot_release",
		weapon_handling_template = "ogryn_heavystubber_p1_m3_full_auto",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.92,
				t = 0.05,
			},
			{
				modifier = 0.925,
				t = 0.15,
			},
			{
				modifier = 0.93,
				t = 0.175,
			},
			{
				modifier = 0.935,
				t = 0.3,
			},
			{
				modifier = 0.94,
				t = 0.5,
			},
			start_modifier = 0.91,
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.default_ogryn_heavystubber_full_auto_m3,
			damage_type = damage_types.heavy_stubber_bullet,
		},
		fx = {
			alternate_muzzle_flashes = true,
			alternate_shell_casings = true,
			auto_fire_time_parameter_name = "wpn_fire_interval",
			crit_shoot_sfx_alias = "critical_shot_extra",
			looping_shoot_sfx_alias = "ranged_braced_shooting",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/ogryn_heavystubber/ogryn_heavystubber_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			num_pre_loop_events = 1,
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			post_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			pre_loop_shoot_sfx_alias = "ranged_pre_loop_shot",
			pre_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_heavystubber_01",
			line_effect = LineEffects.heavy_stubber_bullet,
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
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.225,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0,
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
		start_input = "zoom",
		total_time = 0.65,
		uninterruptible = true,
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
			reload = {
				action_name = "action_reload",
				chain_time = 0.1,
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.3,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.1,
			},
		},
		action_keywords = {
			"braced",
		},
	},
	action_zoom_fast = {
		kind = "aim",
		total_time = 0.55,
		uninterruptible = true,
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
		start_input = "zoom_release",
		total_time = 0.25,
		weapon_handling_template = "time_scale_1_2",
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
				chain_time = 0.25,
			},
			zoom = {
				action_name = "action_zoom_fast",
			},
			stab = {
				action_name = "action_stab",
				chain_time = 0.1,
			},
		},
	},
	action_brace_reload = {
		abort_sprint = true,
		allowed_during_sprint = true,
		kind = "reload_state",
		sprint_requires_press_to_interrupt = true,
		start_input = "brace_reload",
		total_time = 7,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_3",
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
				modifier = 0.2,
				t = 0.3,
			},
			{
				modifier = 0.25,
				t = 0.8,
			},
			{
				modifier = 0.4,
				t = 0.9,
			},
			{
				modifier = 0.85,
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
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 5.6,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 2.6,
			},
			stab = {
				action_name = "action_stab",
				chain_time = 0.65,
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
		total_time = 6,
		weapon_handling_template = "time_scale_1_4",
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
				modifier = 0.2,
				t = 0.3,
			},
			{
				modifier = 0.25,
				t = 0.8,
			},
			{
				modifier = 0.4,
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
				chain_time = 5.6,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 5.6,
			},
			stab = {
				action_name = "action_stab",
				chain_time = 0.65,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_stab = {
		allowed_during_sprint = true,
		anim_event = "attack_bash_right",
		attack_direction_override = "right",
		damage_window_end = 0.5,
		damage_window_start = 0.3,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.15,
		start_input = "stab",
		total_time = 1.4,
		uninterruptible = true,
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			{
				modifier = 0.4,
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
			},
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 1.35,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 1.2,
			},
			stab = {
				action_name = "action_stab",
				chain_time = 1.2,
			},
		},
		weapon_box = {
			0.2,
			1.2,
			0.3,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/heavy_stubber_twin_linked/attack_special_right",
			anchor_point_offset = {
				0.2,
				0.8,
				0,
			},
		},
		damage_type = damage_types.blunt_heavy,
		damage_profile = DamageProfileTemplates.light_ogryn_shotgun_tank,
		herding_template = HerdingTemplates.thunder_hammer_right_heavy,
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
	primary_action = "action_shoot_hip",
	secondary_action = "action_zoom",
}
weapon_template.anim_state_machine_3p = "content/characters/player/ogryn/third_person/animations/heavy_stubber_twin_linked"
weapon_template.anim_state_machine_1p = "content/characters/player/ogryn/first_person/animations/heavy_stubber_twin_linked"
weapon_template.reload_template = ReloadTemplates.heavy_stubber_twin_linked
weapon_template.sway_template = "ogyn_heavy_stubber_sway"
weapon_template.spread_template = "ogryn_heavystubber_spread_spraynpray_hip_m3"
weapon_template.recoil_template = "default_ogryn_heavystubber_recoil_spraynpray_hip_m3"
weapon_template.look_delta_template = "default"
weapon_template.ammo_template = "ogryn_heavystubber_p1_m3"
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
weapon_template.no_ammo_delay = 0.4
weapon_template.hud_configuration = {
	uses_ammunition = true,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.smart_targeting_template = SmartTargetingTemplates.spray_n_pray
weapon_template.fx_sources = {
	_eject = "fx_eject_01",
	_eject_secondary = "fx_eject_02",
	_muzzle = "fx_01",
	_muzzle_secondary = "fx_02",
}
weapon_template.crosshair = {
	crosshair_type = "spray_n_pray",
}
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	look_delta_template = "lasgun_brace_light",
	recoil_template = "default_ogryn_heavystubber_recoil_spraynpray_brace_m3",
	spread_template = "ogryn_heavystubber_spread_spraynpray_braced_m3",
	start_anim_event = "to_braced",
	stop_anim_event = "to_unaim_braced",
	sway_template = "ogyn_heavy_stubber_sway",
	uninterruptible = true,
	crosshair = {
		crosshair_type = "spray_n_pray",
	},
	camera = {
		custom_vertical_fov = 55,
		near_range = 0.025,
		vertical_fov = 60,
	},
	movement_speed_modifier = {
		{
			modifier = 0.65,
			t = 0.05,
		},
		{
			modifier = 0.7,
			t = 0.075,
		},
		{
			modifier = 0.72,
			t = 0.25,
		},
		{
			modifier = 0.74,
			t = 0.3,
		},
		{
			modifier = 0.75,
			t = 2,
		},
	},
}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	ogryn_heavystubber_dps_stat = {
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
	ogryn_heavystubber_stability_stat = {
		display_name = "loc_stats_display_stability_stat",
		is_stat_trait = true,
		recoil = {
			base = {
				recoil_trait_templates.default_recoil_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("stability_recoil", "loc_weapon_stats_display_hip_fire"),
			},
			alternate_fire = {
				recoil_trait_templates.default_recoil_stat,
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
	ogryn_heavystubber_range_stat = {
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
	ogryn_heavystubber_ammo_stat = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	ogryn_heavystubber_control_stat = {
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
	"heavystubber",
	"p1",
}
weapon_template.dodge_template = "ogryn"
weapon_template.sprint_template = "ogryn"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.ogryn_heavy_stubber
weapon_template.haptic_trigger_template = HapticTriggerTemplates.ranged.heavy_stubber
weapon_template.traits = {}

local ogryn_heavystubbert_p1_traits = table.ukeys(WeaponTraitsOgrynHeavystubbertP1)

table.append(weapon_template.traits, ogryn_heavystubbert_p1_traits)

weapon_template.weapon_temperature_settings = {
	barrel_threshold = 0.4,
	decay_rate = 0.075,
	grace_time = 0.4,
	increase_rate = 0.055,
	use_charge = false,
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_high_ammo_count",
	},
	{
		display_name = "loc_weapon_keyword_spray_n_pray",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_ranged_attack_primary",
		fire_mode = "full_auto",
		type = "hipfire",
	},
	secondary = {
		display_name = "loc_ranged_attack_secondary_braced",
		fire_mode = "full_auto",
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
			sub_icon = "full_auto",
			value_func = "primary_attack",
		},
		{
			header = "brace",
			icon = "brace",
			sub_icon = "full_auto",
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
weapon_template.displayed_attack_ranges = {
	max = 0,
	min = 0,
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
