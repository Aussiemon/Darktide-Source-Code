-- chunkname: @scripts/settings/equipment/weapon_templates/lasguns/lasgun_p1_m1.lua

local ActionInputHierarchyUtils = require("scripts/utilities/weapon/action_input_hierarchy")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FlashlightTemplates = require("scripts/settings/equipment/flashlight_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local HoloSightTemplates = require("scripts/settings/equipment/holo_sight_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeLasgunP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_lasgun_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_types = DamageSettings.damage_types
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local armor_types = ArmorSettings.types
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
local weapon_template = {}

weapon_template.action_inputs = {
	shoot_pressed = {
		buffer_time = 0.5,
		max_queue = 2,
		input_sequence = {
			{
				input = "action_one_pressed",
				value = true,
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
	weapon_special = {
		buffer_time = 0.4,
		input_sequence = {
			{
				input = "weapon_extra_pressed",
				value = true,
			},
		},
	},
	zoom_weapon_special = {
		buffer_time = 0.26,
		max_queue = 2,
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
				transition = "base",
			},
			{
				input = "zoom_shoot",
				transition = "stay",
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
				input = "zoom_weapon_special",
				transition = "stay",
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
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.65,
			},
		},
	},
	action_shoot_hip = {
		abort_sprint = false,
		allow_shots_with_less_than_required_ammo = true,
		allowed_during_sprint = false,
		ammunition_usage = 3,
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0.25,
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot_pressed",
		total_time = 0.5,
		weapon_handling_template = "immediate_single_shot",
		action_movement_curve = {
			{
				modifier = 0.9,
				t = 0.05,
			},
			{
				modifier = 1.05,
				t = 0.15,
			},
			{
				modifier = 0.975,
				t = 0.175,
			},
			{
				modifier = 0.9,
				t = 0.2,
			},
			{
				modifier = 0.65,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.95,
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_crit_effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_muzzle_crit",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			spread_rotated_muzzle_flash = true,
			line_effect = LineEffects.lasbeam_killshot,
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.lasgun_p1_m1_beam,
			damage_type = damage_types.laser,
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
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.275,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.15,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_shoot_zoomed = {
		allow_shots_with_less_than_required_ammo = true,
		ammunition_usage = 3,
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0.5,
		start_input = "zoom_shoot",
		total_time = 0.4,
		weapon_handling_template = "immediate_single_shot",
		crosshair = {
			crosshair_type = "ironsight",
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
				modifier = 0.675,
				t = 0.175,
			},
			{
				modifier = 0.5,
				t = 0.3,
			},
			{
				modifier = 0.7,
				t = 1,
			},
			start_modifier = 0.6,
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			spread_rotated_muzzle_flash = true,
			line_effect = LineEffects.lasbeam_killshot,
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.lasgun_p1_m1_beam,
			damage_type = damage_types.laser,
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
				chain_time = 0.275,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.2,
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
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_killshot,
		crosshair = {
			crosshair_type = "ironsight",
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
				chain_time = 0.05,
			},
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
				action_name = "action_shoot_hip",
				chain_time = 3,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 3,
			},
			zoom_release = {
				action_name = "action_unzoom",
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
		},
	},
	action_toggle_flashlight = {
		activation_time = 0,
		allowed_during_sprint = true,
		anim_event = "toggle_flashlight",
		kind = "toggle_special",
		skip_3p_anims = true,
		start_input = "weapon_special",
		total_time = 0.2,
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
			},
		},
	},
	action_toggle_flashlight_zoom = {
		activation_time = 0,
		anim_event = "toggle_flashlight",
		kind = "toggle_special",
		skip_3p_anims = true,
		start_input = "zoom_weapon_special",
		total_time = 0.2,
		crosshair = {
			crosshair_type = "ironsight",
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
			},
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
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.entry_actions = {
	primary_action = "action_shoot_hip",
	secondary_action = "action_zoom",
}
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/lasgun_rifle"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/lasgun_rifle"
weapon_template.reload_template = ReloadTemplates.lasgun
weapon_template.spread_template = "hip_lasgun_killshot"
weapon_template.recoil_template = "hip_lasgun_killshot"
weapon_template.suppression_template = "hip_lasgun_killshot"
weapon_template.look_delta_template = "lasgun_rifle"
weapon_template.ammo_template = "lasgun_p1_m1"
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
weapon_template.no_ammo_delay = 0.3
weapon_template.hud_configuration = {
	uses_ammunition = true,
	uses_overheat = false,
}
weapon_template.weapon_special_tweak_data = {
	manual_toggle_only = true,
}
weapon_template.flashlight_template = FlashlightTemplates.lasgun_p1
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {
	_mag_well = "fx_reload",
	_muzzle = "fx_muzzle_01",
}
weapon_template.crosshair = {
	crosshair_type = "cross",
}
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	look_delta_template = "lasgun_holo_aiming",
	peeking_mechanics = true,
	recoil_template = "lasgun_p1_m1_ads_killshot",
	spread_template = "default_lasgun_killshot",
	start_anim_event = "to_reflex",
	stop_anim_event = "to_unaim_reflex",
	suppression_template = "default_lasgun_killshot",
	sway_template = "lasgun_p1_m1_killshot",
	toughness_template = "killshot_zoomed",
	crosshair = {
		crosshair_type = "ironsight",
	},
	camera = {
		custom_vertical_fov = 45,
		near_range = 0.025,
		vertical_fov = 45,
	},
	movement_speed_modifier = {
		{
			modifier = 0.475,
			t = 0.45,
		},
		{
			modifier = 0.45,
			t = 0.47500000000000003,
		},
		{
			modifier = 0.39,
			t = 0.65,
		},
		{
			modifier = 0.4,
			t = 0.7,
		},
		{
			modifier = 0.55,
			t = 0.8,
		},
		{
			modifier = 0.6,
			t = 0.9,
		},
		{
			modifier = 0.7,
			t = 2,
		},
	},
}
weapon_template.keywords = {
	"ranged",
	"lasgun",
	"p1",
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
weapon_template.holo_sight_template = HoloSightTemplates.lasgun

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	lasgun_p1_m1_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_dps_stat,
				display_data = {
					display_stats = {
						power_distribution = {
							attack = {},
						},
						armor_damage_modifier_ranged = {
							near = {
								attack = {
									[armor_types.unarmored] = {
										display_name = "loc_weapon_stats_display_dmg_vs_unarmored",
									},
									[armor_types.disgustingly_resilient] = {
										display_name = "loc_weapon_stats_display_dmg_vs_disgustingly_resilient",
									},
								},
							},
						},
					},
				},
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_dps_stat,
			},
		},
	},
	lasgun_p1_m1_ammo_stat = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	lasgun_p1_m1_stability_stat = {
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
	lasgun_p1_m1_mobility_stat = {
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
	lasgun_p1_m1_power_stat = {
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
}
weapon_template.traits = {}

local bespoke_lasgun_p1_traits = table.ukeys(WeaponTraitsBespokeLasgunP1)

table.append(weapon_template.traits, bespoke_lasgun_p1_traits)

weapon_template.perks = {
	lasgun_p1_m1_stability_perk = {
		display_name = "loc_trait_display_lasgun_p1_m1_stability_perk",
		recoil = {
			base = {
				recoil_trait_templates.default_recoil_perk,
			},
			alternate_fire = {
				recoil_trait_templates.default_recoil_perk,
			},
		},
		spread = {
			base = {
				spread_trait_templates.default_spread_perk,
			},
		},
		sway = {
			alternate_fire = {
				sway_trait_templates.default_sway_perk,
			},
		},
	},
	lasgun_p1_m1_ammo_perk = {
		display_name = "loc_trait_display_lasgun_p1_m1_ammo_perk",
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_perk,
			},
		},
	},
	lasgun_p1_m1_dps_perk = {
		display_name = "loc_trait_display_lasgun_p1_m1_dps_perk",
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_dps_perk,
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_dps_perk,
			},
		},
	},
	lasgun_p1_m1_power_perk = {
		display_name = "loc_trait_display_lasgun_p1_m1_power_perk",
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_power_perk,
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_power_perk,
			},
		},
	},
	lasgun_p1_m1_mobility_perk = {
		display_name = "loc_trait_display_lasgun_p1_m1_mobility_perk",
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_perk,
			},
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_perk,
			},
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_perk,
			},
		},
		recoil = {
			base = {
				recoil_trait_templates.default_mobility_recoil_perk,
			},
			alternate_fire = {
				recoil_trait_templates.default_mobility_recoil_perk,
			},
		},
		spread = {
			base = {
				spread_trait_templates.default_mobility_spread_perk,
			},
		},
	},
}
weapon_template.weapon_temperature_settings = {
	barrel_threshold = 0.4,
	decay_rate = 0.075,
	grace_time = 0.4,
	increase_rate = 0.065,
	use_charge = false,
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_versatile",
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
		desc = "loc_stats_special_action_flashlight_desc",
		display_name = "loc_weapon_special_flashlight",
		type = "flashlight",
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
		header = "flashlight",
		icon = "flashlight",
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
