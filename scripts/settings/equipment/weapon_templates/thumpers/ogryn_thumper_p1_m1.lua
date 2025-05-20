-- chunkname: @scripts/settings/equipment/weapon_templates/thumpers/ogryn_thumper_p1_m1.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local ShotshellTemplates = require("scripts/settings/projectile/shotshell_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeThumperP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_thumper_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local armor_types = ArmorSettings.types
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local template_types = WeaponTweakTemplateSettings.template_types
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local recoil_trait_templates = WeaponTraitTemplates[template_types.recoil]
local spread_trait_templates = WeaponTraitTemplates[template_types.spread]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local weapon_template = {}

weapon_template.action_inputs = {
	wield = {
		buffer_time = 0.2,
		input_sequence = {
			{
				inputs = wield_inputs,
			},
		},
	},
	shoot_pressed = {
		buffer_time = 0.4,
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
		buffer_time = 0.2,
		input_sequence = {
			{
				input = "weapon_reload",
				value = true,
			},
		},
	},
	bash = {
		buffer_time = 0.4,
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
		input = "wield",
		transition = "stay",
	},
	{
		input = "shoot_pressed",
		transition = "stay",
	},
	{
		input = "reload",
		transition = "stay",
	},
	{
		input = "zoom",
		transition = {
			{
				input = "bash",
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
		input = "bash",
		transition = "base",
	},
}

ActionInputHierarchy.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
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
			no_ammo = {
				input_name = "reload",
			},
		},
		allowed_chain_actions = {
			bash = {
				action_name = "action_bash",
				chain_time = 0.6,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.85,
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.2,
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.4,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
	},
	action_unwield = {
		allowed_during_sprint = true,
		kind = "unwield",
		start_input = "wield",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
	},
	action_shoot_hip = {
		ammunition_usage = 1,
		keep_combo_on_start = true,
		kind = "shoot_pellets",
		sprint_ready_up_time = 0.2,
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot_pressed",
		total_time = 0.2,
		uninterruptible = true,
		weapon_handling_template = "immediate_single_shot",
		action_movement_curve = {
			{
				modifier = 0.5,
				t = 0.05,
			},
			{
				modifier = 0.55,
				t = 0.15,
			},
			{
				modifier = 0.575,
				t = 0.175,
			},
			{
				modifier = 0.7,
				t = 0.3,
			},
			{
				modifier = 0.8,
				t = 0.5,
			},
			start_modifier = 0.3,
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/combat_shotgun_ogryn_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.default_thumper_assault,
			damage_type = damage_types.rippergun_pellet,
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			reload = {
				action_name = "action_reload",
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.4,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.4,
			},
			bash = {
				action_name = "action_bash",
				chain_time = 0.1,
				reset_combo = true,
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
	action_zoom = {
		hold_combo = true,
		kind = "aim",
		start_input = "zoom",
		total_time = 0.3,
		crosshair = {
			crosshair_type = "shotgun",
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
				chain_time = 0.1,
			},
		},
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_assault,
		action_keywords = {
			"braced",
		},
	},
	action_unzoom = {
		kind = "unaim",
		start_input = "zoom_release",
		total_time = 0.2,
		crosshair = {
			crosshair_type = "shotgun",
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
			zoom = {
				action_name = "action_zoom",
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.4,
			},
		},
	},
	action_shoot_zoomed = {
		allowed_during_sprint = false,
		ammunition_usage = 1,
		keep_combo_on_start = true,
		kind = "shoot_pellets",
		start_input = "zoom_shoot",
		total_time = 0.2,
		uninterruptible = true,
		weapon_handling_template = "immediate_single_shot",
		crosshair = {
			crosshair_type = "shotgun",
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.4,
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 1.05,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.1,
			},
			bash = {
				action_name = "action_bash",
				chain_time = 0.1,
				reset_combo = true,
			},
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/combat_shotgun_ogryn_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.default_thumper_assault_ads,
			damage_type = damage_types.rippergun_pellet,
		},
		conditional_state_to_action_input = {
			no_ammo = {
				input_name = "reload",
			},
		},
		action_keywords = {
			"braced",
			"braced_shooting",
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_reload = {
		allowed_during_sprint = true,
		hold_combo = true,
		kind = "reload_state",
		start_input = "reload",
		stop_alternate_fire = true,
		total_time = 2.333,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_1",
		crosshair = {
			crosshair_type = "shotgun",
		},
		action_movement_curve = {
			{
				modifier = 0.85,
				t = 0.05,
			},
			{
				modifier = 0.9,
				t = 0.075,
			},
			{
				modifier = 0.85,
				t = 0.25,
			},
			{
				modifier = 0.75,
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
			wield = {
				action_name = "action_unwield",
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			zoom = {
				action_name = "action_zoom",
				chain_time = 2.25,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 2.25,
			},
			bash = {
				action_name = "action_bash",
				reset_combo = true,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_bash = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_event = "attack_bash",
		attack_direction_override = "left",
		damage_window_end = 0.7333333333333333,
		damage_window_start = 0.5333333333333333,
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		prevent_sprint = true,
		range_mod = 1.15,
		sprint_requires_press_to_interrupt = true,
		start_input = "bash",
		stop_alternate_fire = true,
		total_time = 1.2,
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
			{
				modifier = 1,
				t = 1.75,
			},
			start_modifier = 0.8,
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			reload = {
				action_name = "action_reload",
				chain_time = 0.8,
				reset_combo = true,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 1.1,
				reset_combo = true,
			},
			bash = {
				action_name = "action_bash_right",
				chain_time = 0.8,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 1.2,
				reset_combo = true,
			},
		},
		conditional_state_to_action_input = {
			started_reload = {
				input_name = "reload",
			},
			no_ammo = {
				input_name = "reload",
			},
		},
		weapon_box = {
			0.2,
			1.5,
			0.1,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/shotgun_grenade/bash_left",
			anchor_point_offset = {
				0,
				0.3,
				-0.15,
			},
		},
		damage_type = damage_types.blunt,
		damage_profile = DamageProfileTemplates.light_ogryn_shotgun_tank,
		herding_template = HerdingTemplates.thunder_hammer_left_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_bash_right = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_event = "attack_bash_right",
		attack_direction_override = "right",
		damage_window_end = 0.8,
		damage_window_start = 0.6,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		prevent_sprint = true,
		range_mod = 1.15,
		sprint_requires_press_to_interrupt = true,
		total_time = 1.2,
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
			{
				modifier = 1,
				t = 1.75,
			},
			start_modifier = 0.8,
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			reload = {
				action_name = "action_reload",
				chain_time = 0.8,
				reset_combo = true,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 1.1,
				reset_combo = true,
			},
			bash = {
				action_name = "action_bash",
				chain_time = 0.8,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 1,
				reset_combo = true,
			},
		},
		conditional_state_to_action_input = {
			started_reload = {
				input_name = "reload",
			},
			no_ammo = {
				input_name = "reload",
			},
		},
		weapon_box = {
			0.2,
			1.5,
			0.1,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/shotgun_grenade/bash_right",
			anchor_point_offset = {
				0,
				0.3,
				0,
			},
		},
		damage_type = damage_types.ogryn_bullet_bounce,
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

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	ogryn_thumper_dps_stat = {
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
	ogryn_thumper_reload_speed_stat = {
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
	ogryn_thumper_mobility_stat = {
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
	},
	ogryn_thumper_default_range_stat = {
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
	ogryn_thumper_power_stat = {
		display_name = "loc_stats_display_power_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.thumper_shotgun_power_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_shoot_zoomed = {
				damage_trait_templates.thumper_shotgun_power_stat,
			},
		},
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/ogryn/third_person/animations/shotgun_grenade"
weapon_template.anim_state_machine_1p = "content/characters/player/ogryn/first_person/animations/shotgun_grenade"
weapon_template.alternate_fire_settings = {
	spread_template = "thumper_shotgun_aim",
	start_anim_event = "to_braced",
	stop_anim_event = "to_unaim_braced",
	sway_template = "default_thumper_assault",
	toughness_template = "killshot_zoomed",
	crosshair = {
		crosshair_type = "shotgun",
	},
	camera = {
		custom_vertical_fov = 55,
		near_range = 0.025,
		vertical_fov = 50,
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
	projectile_aim_effect_settings = {},
}
weapon_template.spread_template = "thumper_shotgun_hip_assault"
weapon_template.recoil_template = "default_thumper_assault"
weapon_template.reload_template = ReloadTemplates.ogryn_thumper
weapon_template.combo_reset_duration = 0.5
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_ammo_with_delay",
		input_name = "reload",
	},
}
weapon_template.no_ammo_delay = 0.1
weapon_template.sprint_ready_up_time = 0.3
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.hud_configuration = {
	uses_ammunition = true,
	uses_overheat = false,
}
weapon_template.movement_curve_modifier_template = "default"
weapon_template.ammo_template = "ogryn_thumper_p1_m1"
weapon_template.fx_sources = {
	_muzzle = "ap_bullet_02",
	_sweep = "fx_sweep",
}
weapon_template.crosshair = {
	crosshair_type = "shotgun",
}
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"ranged",
	"shotgun_grenade",
	"p1",
}
weapon_template.dodge_template = "ogryn"
weapon_template.sprint_template = "ogryn"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.ogryn_thumper_shotgun
weapon_template.smart_targeting_template = SmartTargetingTemplates.assault
weapon_template.haptic_trigger_template = HapticTriggerTemplates.ranged.thumper_p1_m1
weapon_template.traits = {}

local bespoke_traits = table.ukeys(WeaponTraitsBespokeThumperP1)

table.append(weapon_template.traits, bespoke_traits)

weapon_template.hipfire_inputs = {
	shoot_pressed = true,
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_spread_shot",
	},
	{
		display_name = "loc_weapon_keyword_close_combat",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_ranged_attack_primary",
		fire_mode = "shotgun",
		type = "hipfire",
	},
	secondary = {
		display_name = "loc_ranged_attack_secondary_braced",
		fire_mode = "shotgun",
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
			sub_icon = "shotgun",
			value_func = "primary_attack",
		},
		{
			header = "brace",
			icon = "brace",
			sub_icon = "shotgun",
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
weapon_template.special_action_name = "action_bash"

return weapon_template
