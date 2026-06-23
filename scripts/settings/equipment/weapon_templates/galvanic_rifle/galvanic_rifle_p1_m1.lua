-- chunkname: @scripts/settings/equipment/weapon_templates/galvanic_rifle/galvanic_rifle_p1_m1.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local AimAssistTemplates = require("scripts/settings/equipment/aim_assist_templates")
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
local WeaponTraitsBespokeGalvanicRifleP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_galvanic_rifle_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
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
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local weapon_template = {}

weapon_template.action_inputs = {
	shoot = {
		buffer_time = 0.35,
		max_queue = 1,
		input_sequence = {
			{
				input = "action_one_pressed",
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
		buffer_time = 0.35,
		max_queue = 1,
		input_sequence = {
			{
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	zoom = {
		buffer_time = 0.25,
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
		buffer_time = 0.25,
		clear_input_queue = true,
		input_sequence = {
			{
				input = "weapon_reload_pressed",
				value = true,
			},
		},
	},
	wield = {
		buffer_time = 0.25,
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
		buffer_time = 0.25,
		max_queue = 2,
		input_sequence = {
			{
				input = "weapon_extra_pressed",
				value = true,
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
		buffer_time = 0.2,
		input_sequence = {
			{
				hold_input = "weapon_extra_hold",
				input = "weapon_extra_hold",
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

local firerate = 0.38

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
				chain_time = 0.5,
			},
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 0.55,
			},
			special_action = {
				action_name = "action_bash",
				chain_time = 0.45,
			},
		},
	},
	action_shoot_hip = {
		abort_sprint = false,
		allowed_during_sprint = false,
		ammunition_usage = 1,
		anim_end_event = nil,
		anim_event = nil,
		kind = "shoot_hit_scan",
		minimum_hold_time = 0.25,
		sprint_ready_up_time = 0.235,
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot",
		total_time = 0.65,
		weapon_handling_template = "galvanic_rifle_p1_m1",
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
				modifier = 0.93,
				t = 0.2,
			},
			{
				modifier = 0.85,
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
			muzzle_flash_crit_effect = "content/fx/particles/weapons/rifles/galvanic/galvanic_rifle_muzzle",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/galvanic/galvanic_rifle_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			spread_rotated_muzzle_flash = false,
			line_effect = LineEffects.galvanic_beam,
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.galvanic_rifle_p1_m1_bullet,
			damage_type = damage_types.galvanic,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = firerate,
			},
			reload = {
				action_name = "action_reload",
			},
			zoom = {
				action_name = "action_zoom",
			},
			special_action = {
				action_name = "action_bash",
				chain_time = 0.2,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return false
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
		aim_assist_ramp_template = AimAssistTemplates.killshot_fire,
	},
	action_shoot_zoomed = {
		allowed_during_sprint = true,
		ammunition_usage = 1,
		hit_marker_type = "center",
		kind = "shoot_hit_scan",
		minimum_hold_time = 0.25,
		sprint_ready_up_time = 0,
		start_input = "zoom_shoot",
		total_time = 0.655,
		weapon_handling_template = "galvanic_rifle_p1_m1",
		action_movement_curve = {
			{
				modifier = 0.85,
				t = 0.25,
			},
			{
				modifier = 0.7,
				t = 0.45,
			},
			{
				modifier = 0.85,
				t = 0.8,
			},
			start_modifier = 0.75,
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_crit_effect = "content/fx/particles/weapons/rifles/galvanic/galvanic_rifle_muzzle",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/galvanic/galvanic_rifle_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			spread_rotated_muzzle_flash = false,
			line_effect = LineEffects.galvanic_beam,
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.galvanic_rifle_p1_m1_bullet,
			damage_type = damage_types.galvanic,
		},
		crosshair = {
			crosshair_type = "ironsight",
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = firerate,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.26,
			},
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
		aim_assist_ramp_template = AimAssistTemplates.killshot_fire,
	},
	action_zoom = {
		kind = "aim",
		start_input = "zoom",
		total_time = 0.3,
		crosshair = {
			crosshair_type = "ironsight",
		},
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_assault,
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
				chain_time = 0.25,
			},
		},
		aim_assist_ramp_template = AimAssistTemplates.killshot_aim,
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
				chain_time = 0.15,
			},
			reload = {
				action_name = "action_reload",
			},
		},
		aim_assist_ramp_template = AimAssistTemplates.killshot_unaim,
	},
	action_reload = {
		abort_sprint = true,
		allowed_during_sprint = true,
		kind = "reload_state",
		sprint_requires_press_to_interrupt = true,
		start_input = "reload",
		stop_alternate_fire = true,
		total_time = 3.85,
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
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 3.45,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 3.45,
			},
			special_action = {
				action_name = "action_bash",
				chain_time = 0.2,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_toggle_flashlight = {
		activation_time = 0,
		kind = "toggle_special",
		start_input = "weapon_special",
		total_time = 0.2,
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
			},
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_toggle_flashlight_zoom = {
		activation_time = 0,
		kind = "toggle_special",
		start_input = "zoom_weapon_special",
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
			reload = {
				action_name = "action_reload",
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
			},
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_bash = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_event = "attack_stab",
		damage_window_end = 0.23333333333333334,
		damage_window_start = 0.16666666666666666,
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit",
		hit_stop_anim = nil,
		kind = "sweep",
		range_mod = 1.15,
		sprint_requires_press_to_interrupt = true,
		start_input = "special_action",
		stop_alternate_fire = true,
		total_time = 1.1,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_2",
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
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
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
				action_name = "action_bash",
				chain_time = 0.8,
			},
		},
		weapon_box = {
			0.12,
			1.25,
			0.12,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/galvanic_rifle/attack_stab",
				anchor_point_offset = {
					0,
					1.75,
					0,
				},
			},
		},
		damage_type = damage_types.weapon_butt,
		damage_profile = DamageProfileTemplates.galvanic_rifle_weapon_special_push,
		herding_template = HerdingTemplates.stab,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_inspect_3p = {
		action_prevents_jump = true,
		block_first_person_rotation = true,
		can_crouch = false,
		can_jump = false,
		force_look = true,
		kind = "inspect_3p",
		lock_view = false,
		skip_3p_anims = false,
		stop_input = "inspect_stop",
		total_time = math.huge,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		crosshair = {
			crosshair_type = "inspect",
		},
		allowed_chain_actions = {
			inspect_3p_stop = {
				action_name = "action_inspect",
				chain_time = 1.1,
			},
		},
		action_movement_curve = {
			{
				modifier = 0,
				t = 0,
			},
			start_modifier = 0,
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
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		crosshair = {
			crosshair_type = "inspect",
		},
		allowed_chain_actions = {
			inspect_3p_start = {
				action_name = "action_inspect_3p",
				chain_time = 0.75,
			},
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.entry_actions = {
	primary_action = "action_shoot_hip",
	secondary_action = "action_zoom",
}
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/galvanic_rifle"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/galvanic_rifle"
weapon_template.reload_template = ReloadTemplates.galvanic_rifle
weapon_template.spread_template = "galvanic_rifle_p1_spread_hip"
weapon_template.recoil_template = "galvanic_rifle_p1_m1_recoil_hip"
weapon_template.suppression_template = "galvanic_p1_m1_suppression_assault"
weapon_template.look_delta_template = "autogun"
weapon_template.sway_template = "default_autogun_killshot"
weapon_template.ammo_template = "galvanic_rifle_p1"
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
weapon_template.weapon_special_tweak_data = {}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {
	_eject = "fx_eject",
	_mag_well = "fx_reload",
	_muzzle = "fx_muzzle",
	_wielded_idling = "fx_engine",
}
weapon_template.crosshair = {
	crosshair_type = "cross",
}
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	look_delta_template = "lasgun_holo_aiming",
	peeking_mechanics = true,
	recoil_template = "galvanic_rifle_p1_m1_recoil_ads",
	spread_template = "galvanic_rifle_p1_m1_ads_spread",
	start_anim_event = "to_ironsight",
	start_anim_event_3p = "to_ironsight",
	stop_anim_event = "to_unaim_ironsight",
	stop_anim_event_3p = "to_unaim_ironsight",
	suppression_template = "galvanic_p1_m1_suppression_assault",
	sway_template = "fullauto_galvanic_killshot",
	crosshair = {
		crosshair_type = "ironsight",
	},
	camera = {
		custom_vertical_fov = 45,
		near_range = 0.025,
		vertical_fov = 40,
	},
	movement_speed_modifier = {
		{
			modifier = 0.85,
			t = 0.35,
		},
		{
			modifier = 1.05,
			t = 0.375,
		},
		{
			modifier = 1.15,
			t = 0.55,
		},
		{
			modifier = 0.7,
			t = 0.6,
		},
		{
			modifier = 1,
			t = 1.2,
		},
	},
}
weapon_template.keywords = {
	"ranged",
	"galvanic_rifle",
	"p1",
}
weapon_template.can_use_while_vaulting = true
weapon_template.dodge_template = "killshot"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.killshot
weapon_template.haptic_trigger_template = HapticTriggerTemplates.ranged.killshot_semiauto

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	galvanic_rifle_p1_m1_dps_stat = {
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
			action_bash = {
				damage_trait_templates.default_melee_dps_stat,
			},
		},
	},
	galvanic_rifle_p1_m1_ammo_stat = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	galvanic_rifle_p1_m1_power_stat = {
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
	galvanic_rifle_p1_m1_finesse_stat = {
		display_name = "loc_stats_display_finesse_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.galvanic_rifle_p1_m1_finesse_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_shoot_zoomed = {
				damage_trait_templates.galvanic_rifle_p1_m1_finesse_stat,
			},
		},
	},
	galvanic_rifle_p1_m1_mobility_stat = {
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
}
weapon_template.traits = {}

local bespoke_galvanic_rifle_p1_traits = table.ukeys(WeaponTraitsBespokeGalvanicRifleP1)

table.append(weapon_template.traits, bespoke_galvanic_rifle_p1_traits)

weapon_template.perks = {
	autogun_p1_m1_stability_perk = {
		display_name = "loc_trait_display_autogun_p1_m1_stability_perk",
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
	autogun_p1_m1_ammo_perk = {
		display_name = "loc_trait_display_autogun_p1_m1_ammo_perk",
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_perk,
			},
		},
	},
	autogun_p1_m1_dps_perk = {
		display_name = "loc_trait_display_autogun_p1_m1_dps_perk",
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_dps_perk,
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_dps_perk,
			},
		},
	},
	autogun_p1_m1_power_perk = {
		display_name = "loc_trait_display_autogun_p1_m1_power_perk",
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_power_perk,
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_power_perk,
			},
		},
	},
	autogun_p1_m1_mobility_perk = {
		display_name = "loc_trait_display_autogun_p1_m1_mobility_perk",
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
				recoil_trait_templates.default_recoil_perk,
			},
			alternate_fire = {
				recoil_trait_templates.default_recoil_perk,
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
	increase_rate = 0.075,
	use_charge = false,
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_versatile",
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
weapon_template.special_action_name = "action_bash"

weapon_template.action_inspect_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return false
end

weapon_template.action_alt_inspect_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return false
end

weapon_template.action_inspect_3p_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_inspect_3p"
end

weapon_template.action_inspect_3p_base_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_inspect"
end

return weapon_template
