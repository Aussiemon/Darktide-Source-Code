-- chunkname: @scripts/settings/equipment/weapon_templates/autoguns/autogun_p2_m1.lua

local ActionInputHierarchyUtils = require("scripts/utilities/weapon/action_input_hierarchy")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeAutogunP2 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_autogun_p2")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local template_types = WeaponTweakTemplateSettings.template_types
local ammo_trait_templates = WeaponTraitTemplates[template_types.ammo]
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local recoil_trait_templates = WeaponTraitTemplates[template_types.recoil]
local spread_trait_templates = WeaponTraitTemplates[template_types.spread]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local sway_trait_templates = WeaponTraitTemplates[template_types.sway]
local toughness_trait_templates = WeaponTraitTemplates[template_types.toughness]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local wield_inputs = PlayerCharacterConstants.wield_inputs
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
		buffer_time = 0.22,
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
		input_sequence = {
			{
				input = "action_one_hold",
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
	special_action = {
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
						input = "zoom_release",
						transition = "base",
					},
					{
						input = "shoot_release",
						transition = "previous",
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
						input = "special_action",
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
			{
				input = "special_action",
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
		transition = "base",
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
		total_time = 1,
		uninterruptible = true,
		wield_anim_event = "equip_ak",
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
			special_action = {
				action_name = "action_push",
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
		},
	},
	action_shoot_hip = {
		ammunition_usage = 1,
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0.2,
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot",
		stop_input = "shoot_release",
		weapon_handling_template = "autogun_p2_m1",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.1,
			},
			{
				modifier = 0.9,
				t = 0.25,
			},
			{
				modifier = 1,
				t = 0.4,
			},
			start_modifier = 0.8,
		},
		fx = {
			auto_fire_time_parameter_name = "wpn_fire_interval",
			crit_shoot_sfx_alias = "critical_shot_extra",
			looping_shoot_sfx_alias = "ranged_shooting",
			muzzle_flash_crit_effect = "content/fx/particles/weapons/rifles/autogun/autogun_muzzle_crit",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/autogun/autogun_muzzle_02",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			num_pre_loop_events = 1,
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			post_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			pre_loop_shoot_sfx_alias = "ranged_pre_loop_shot",
			pre_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_autogun_01",
			spread_rotated_muzzle_flash = false,
			line_effect = LineEffects.autogun_bullet,
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.autogun_p2_m1_bullet,
			damage_type = damage_types.auto_bullet,
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
			zoom = {
				action_name = "action_zoom",
			},
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 0.45,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return false
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_shoot_zoomed = {
		ammunition_usage = 1,
		kind = "shoot_hit_scan",
		minimum_hold_time = 0,
		sprint_ready_up_time = 0.2,
		start_input = "zoom_shoot",
		stop_input = "shoot_release",
		uninterruptible = true,
		weapon_handling_template = "autogun_p2_m1",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "spray_n_pray",
		},
		action_movement_curve = {
			{
				modifier = 0.1,
				t = 0.1,
			},
			{
				modifier = 0.7,
				t = 0.2,
			},
			{
				modifier = 0.4,
				t = 0.4,
			},
			{
				modifier = 0.5,
				t = 1,
			},
			start_modifier = 0.75,
		},
		fx = {
			auto_fire_time_parameter_name = "wpn_fire_interval",
			crit_shoot_sfx_alias = "critical_shot_extra",
			looping_shoot_sfx_alias = "ranged_shooting",
			muzzle_flash_crit_effect = "content/fx/particles/weapons/rifles/autogun/autogun_muzzle_crit",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/autogun/autogun_muzzle_02",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			num_pre_loop_events = 1,
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			post_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			pre_loop_shoot_sfx_alias = "ranged_pre_loop_shot",
			pre_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_autogun_01",
			spread_rotated_muzzle_flash = false,
			line_effect = LineEffects.autogun_bullet,
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.autogun_p2_m1_bullet,
			damage_type = damage_types.auto_bullet,
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
			special_action = {
				action_name = "action_push",
				chain_time = 0.8,
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
				action_name = "action_reload",
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.5,
			},
		},
		action_keywords = {
			"braced",
		},
	},
	action_unzoom = {
		kind = "unaim",
		start_input = "zoom_release",
		total_time = 0.2,
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
			zoom = {
				action_name = "action_zoom",
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
		total_time = 3.2,
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
				chain_time = 2.8,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 2.95,
			},
			special_action = {
				action_name = "action_push",
				chain_time = 0.2,
				chain_until = 0.4,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
		},
	},
	action_push = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_event = "attack_push",
		anim_event_3p = "attack_left_diagonal_up",
		damage_window_end = 0.3,
		damage_window_start = 0.13333333333333333,
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.15,
		sprint_requires_press_to_interrupt = true,
		start_input = "special_action",
		stop_alternate_fire = true,
		total_time = 1.1,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_1",
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
			},
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 0.5,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.5,
			},
			special_action = {
				action_name = "action_push",
				chain_time = 0.8,
			},
		},
		weapon_box = {
			0.25,
			1,
			0.7,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/shotgun_rifle/attack_left_diagonal_up_bash",
			anchor_point_offset = {
				0,
				1.4,
				-0.1,
			},
		},
		damage_type = damage_types.weapon_butt,
		damage_profile = DamageProfileTemplates.autogun_weapon_special_bash,
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
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
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
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/autogun_rifle"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/autogun_rifle"
weapon_template.reload_template = ReloadTemplates.autogun_ak
weapon_template.spread_template = "autogun_p2_m1_hip"
weapon_template.recoil_template = "default_autogun_spraynpray"
weapon_template.suppression_template = "default_autogun_assault"
weapon_template.look_delta_template = "autogun"
weapon_template.semi_auto_chain_factor = 0.9
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
weapon_template.no_ammo_delay = 0.15
weapon_template.hud_configuration = {
	uses_ammunition = true,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.ammo_template = "autogun_p2_m1"
weapon_template.fx_sources = {
	_eject = "fx_eject",
	_mag_well = "fx_reload",
	_muzzle = "fx_muzzle_01",
}
weapon_template.crosshair = {
	crosshair_type = "assault",
}
weapon_template.hit_marker_type = "multiple"
weapon_template.alternate_fire_settings = {
	look_delta_template = "autogun",
	peeking_mechanics = true,
	recoil_template = "ads_autogun_spraynpray",
	spread_template = "autogun_p2_m3_ads",
	start_anim_event = "to_braced",
	start_anim_event_3p = "to_ironsight",
	stop_anim_event = "to_unaim_braced",
	stop_anim_event_3p = "to_unaim_braced",
	crosshair = {
		crosshair_type = "spray_n_pray",
	},
	movement_speed_modifier = {
		{
			modifier = 0.775,
			t = 0.35,
		},
		{
			modifier = 0.75,
			t = 0.375,
		},
		{
			modifier = 0.59,
			t = 0.55,
		},
		{
			modifier = 0.7,
			t = 0.6,
		},
		{
			modifier = 0.8,
			t = 2,
		},
	},
}
weapon_template.keywords = {
	"ranged",
	"autogun",
	"p2",
}
weapon_template.dodge_template = "support"
weapon_template.sprint_template = "killshot"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.killshot

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	autogun_p2_m1_dps_stat = {
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
			action_push = {
				damage_trait_templates.default_melee_dps_stat,
			},
		},
	},
	autogun_p2_m1_ammo_stat = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	autogun_p2_m1_stability_stat = {
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
	},
	autogun_p2_m1_control_stat = {
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
		},
	},
	autogun_p2_m1_mobility_stat = {
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
		spread = {
			base = {
				spread_trait_templates.mobility_spread_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_spread"),
			},
		},
	},
}
weapon_template.traits = {}

local bespoke_autogun_p2_traits = table.ukeys(WeaponTraitsBespokeAutogunP2)

table.append(weapon_template.traits, bespoke_autogun_p2_traits)

weapon_template.weapon_temperature_settings = {
	barrel_threshold = 0.4,
	decay_rate = 0.075,
	grace_time = 0.4,
	increase_rate = 0.075,
	use_charge = false,
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_spray_n_pray",
	},
	{
		display_name = "loc_weapon_keyword_high_ammo_count",
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
weapon_template.explicit_combo = {
	{
		"action_shoot_hip",
	},
	{
		"action_shoot_zoomed",
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
weapon_template.special_action_name = "action_push"

weapon_template.action_inspect_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return false
end

weapon_template.action_alt_inspect_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return false
end

return weapon_template
