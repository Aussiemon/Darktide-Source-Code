-- chunkname: @scripts/settings/equipment/weapon_templates/bolt_pistols/boltpistol_p1_m1.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local Ammo = require("scripts/utilities/ammo")
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
local WeaponTraitsBespokeBoltpistolP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_boltpistol_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_keywords = BuffSettings.keywords
local damage_types = DamageSettings.damage_types
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local recoil_trait_templates = WeaponTraitTemplates[template_types.recoil]
local spread_trait_templates = WeaponTraitTemplates[template_types.spread]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local sway_trait_templates = WeaponTraitTemplates[template_types.sway]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local weapon_template = {}

weapon_template.action_inputs = {
	shoot_pressed = {
		buffer_time = 0.2,
		input_sequence = {
			{
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	shoot_release = {
		buffer_time = 0.2,
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
		input = "shoot_pressed",
		transition = "stay",
	},
	{
		input = "zoom",
		transition = {
			{
				input = "special_action",
				transition = "base",
			},
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
		input = "special_action",
		transition = "base",
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
		total_time = 0.65,
		uninterruptible = true,
		wield_anim_event = "equip",
		wield_reload_anim_event = "equip_reload",
		wield_reload_anim_event_func = function (inventory_slot_component)
			local ignore_state = inventory_slot_component.reload_state == "fit_new_mag"
			local ammo_empty = Ammo.current_ammo_in_clips(inventory_slot_component) == 0

			if ignore_state and not ammo_empty then
				return "equip"
			end

			return "equip_reload"
		end,
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
				chain_time = 0.4,
			},
			special_action = {
				action_name = "action_push",
				chain_time = 0.25,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.35,
			},
		},
	},
	action_shoot_hip = {
		ammunition_usage = 1,
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0.3,
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot_pressed",
		total_time = 1.2,
		weapon_handling_template = "immediate_single_shot",
		action_movement_curve = {
			{
				modifier = 0.4,
				t = 0.05,
			},
			{
				modifier = 0.25,
				t = 0.15,
			},
			{
				modifier = 0.25,
				t = 0.175,
			},
			{
				modifier = 0.7,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.3,
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/boltpistol/boltpistol_muzzle_01",
			muzzle_flash_effect_secondary = "content/fx/particles/weapons/rifles/bolter/bolter_muzzle_secondary",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_bolter_01",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			line_effect = LineEffects.boltshell,
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.default_boltpistol_hitscan,
			damage_type_explode = damage_types.boltshell_small,
			damage_type = damage_types.boltshell_non_armed,
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
				chain_time = 0.5,
			},
			special_action = {
				action_name = "action_push",
				chain_time = 0.45,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.6,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.6,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
		buff_keywords = {
			buff_keywords.allow_hipfire_during_sprint,
		},
		conditional_state_to_action_input = {
			no_ammo = {
				input_name = "reload",
			},
		},
	},
	action_shoot_zoomed = {
		ammunition_usage = 1,
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0,
		start_input = "zoom_shoot",
		total_time = 1,
		weapon_handling_template = "immediate_single_shot",
		crosshair = {
			crosshair_type = "ironsight",
		},
		action_movement_curve = {
			{
				modifier = 0.3,
				t = 0.05,
			},
			{
				modifier = 0.35,
				t = 0.15,
			},
			{
				modifier = 0.375,
				t = 0.175,
			},
			{
				modifier = 0.5,
				t = 0.3,
			},
			{
				modifier = 0.6,
				t = 1,
			},
			start_modifier = 0.3,
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/boltpistol/boltpistol_muzzle_01",
			muzzle_flash_effect_secondary = "content/fx/particles/weapons/rifles/bolter/bolter_muzzle_secondary",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_bolter_01",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			line_effect = LineEffects.boltshell,
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.default_boltpistol_hitscan,
			damage_type_explode = damage_types.boltshell_small,
			damage_type = damage_types.boltshell_non_armed,
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
				chain_time = 0.5,
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.45,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.2,
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
		conditional_state_to_action_input = {
			no_ammo = {
				input_name = "reload",
			},
		},
	},
	action_zoom = {
		kind = "aim",
		start_input = "zoom",
		total_time = 0.5,
		weapon_handling_template = "time_scale_2_5",
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_killshot,
		crosshair = {
			crosshair_type = "ironsight",
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
				chain_time = 0.45,
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
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
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
		total_time = 2.6,
		weapon_handling_template = "time_scale_1",
		crosshair = {
			crosshair_type = "none",
		},
		action_movement_curve = {
			{
				modifier = 0.6,
				t = 0.3,
			},
			{
				modifier = 0.75,
				t = 0.5,
			},
			{
				modifier = 0.95,
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
				chain_time = 2.4,
			},
			special_action = {
				action_name = "action_push",
				chain_time = 2.4,
				chain_until = 0.4,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
		},
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "reload",
			},
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_push = {
		allowed_during_sprint = true,
		anim_event = "attack_push",
		damage_window_end = 0.23333333333333334,
		damage_window_start = 0.2,
		first_person_hit_anim = "attack_hit",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.15,
		sprint_requires_press_to_interrupt = true,
		start_input = "special_action",
		stop_alternate_fire = true,
		total_time = 1.1,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1",
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.1,
			},
			{
				modifier = 0.3,
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
			start_modifier = 1.1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.4,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.4,
			},
			special_action = {
				action_name = "action_push",
				chain_time = 0.75,
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.6,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.5,
			},
		},
		weapon_box = {
			0.15,
			1,
			0.15,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/bolt_pistol/push",
				anchor_point_offset = {
					0.1,
					1.2,
					-0.15,
				},
			},
		},
		damage_type = damage_types.weapon_butt,
		damage_profile = DamageProfileTemplates.boltpistol_weapon_special,
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

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	boltpistol_p1_m1_dps_stat = {
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
	boltpistol_p1_m1_stability_stat = {
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
	boltpistol_p1_m1_mobility_stat = {
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
	boltpistol_p1_m1_reload_speed_stat = {
		display_name = "loc_stats_display_reload_speed_stat",
		is_stat_trait = true,
		weapon_handling = {
			action_reload = {
				weapon_handling_trait_templates.max_reload_speed_modify,
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
	boltpistol_p1_m1_control_stat = {
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
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.entry_actions = {
	primary_action = "action_shoot_hip",
	secondary_action = "action_zoom",
}
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/bolt_pistol"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/bolt_pistol"
weapon_template.reload_template = ReloadTemplates.boltpistol
weapon_template.spread_template = "boltpistol_p1_m1_spread_assault"
weapon_template.recoil_template = "default_boltpistol_hip"
weapon_template.suppression_template = "boltpistol_p1_m1_suppression_assault"
weapon_template.look_delta_template = "bolter"
weapon_template.ammo_template = "boltpistol_p1_m1"
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
weapon_template.sprint_ready_up_time = 0.051
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {
	_eject = "fx_eject",
	_muzzle = "fx_muzzle_01",
	_muzzle_secondary = "fx_muzzle_02",
}
weapon_template.crosshair = {
	crosshair_type = "bfg",
}
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	look_delta_template = "bolter",
	peeking_mechanics = true,
	recoil_template = "default_boltpistol_ads",
	spread_template = "default_bolter_killshot",
	start_anim_event = "to_ironsight",
	stop_anim_event = "to_unaim_ironsight",
	suppression_template = "boltpistol_p1_m1_suppression_killshot",
	sway_template = "default_boltpistol_killshot",
	toughness_template = "killshot_zoomed",
	crosshair = {
		crosshair_type = "ironsight",
	},
	camera = {
		custom_vertical_fov = 45,
		near_range = 0.025,
		vertical_fov = 55,
	},
	movement_speed_modifier = {
		{
			modifier = 0.475,
			t = 0.25,
		},
		{
			modifier = 0.45,
			t = 0.275,
		},
		{
			modifier = 0.49,
			t = 0.45,
		},
		{
			modifier = 0.5,
			t = 0.5,
		},
		{
			modifier = 0.65,
			t = 0.6000000000000001,
		},
		{
			modifier = 0.7,
			t = 0.7,
		},
		{
			modifier = 0.8,
			t = 2,
		},
	},
}
weapon_template.keywords = {
	"ranged",
	"boltpistol",
	"p1",
}
weapon_template.can_use_while_vaulting = true
weapon_template.dodge_template = "assault"
weapon_template.sprint_template = "assault"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "assault"
weapon_template.movement_curve_modifier_template = "boltpistol_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.killshot
weapon_template.haptic_trigger_template = HapticTriggerTemplates.ranged.bolter
weapon_template.traits = {}

local bespoke_boltpistol_p1_traits = table.ukeys(WeaponTraitsBespokeBoltpistolP1)

table.append(weapon_template.traits, bespoke_boltpistol_p1_traits)

weapon_template.hipfire_inputs = {
	shoot_pressed = true,
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_high_damage",
	},
	{
		display_name = "loc_weapon_keyword_mobile",
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
weapon_template.special_action_name = "action_push"

return weapon_template
