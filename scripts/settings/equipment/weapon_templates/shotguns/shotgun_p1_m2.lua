-- chunkname: @scripts/settings/equipment/weapon_templates/shotguns/shotgun_p1_m2.lua

local ActionInputHierarchy = require("scripts/utilities/weapon/action_input_hierarchy")
local AimAssistTemplates = require("scripts/settings/equipment/aim_assist_templates")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ShotshellTemplates = require("scripts/settings/projectile/shotshell_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeShotgunP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_shotgun_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local armor_types = ArmorSettings.types
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_types = DamageSettings.damage_types
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
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
		buffer_time = 0.35,
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
	special_action = {
		buffer_time = 0.3,
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
	special_action_release = {
		buffer_time = 0.2,
		input_sequence = {
			{
				hold_input = "weapon_extra_release",
				input = "weapon_extra_release",
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
		transition = "stay",
	},
}

ActionInputHierarchy.add_missing_ordered(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

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
		wield_anim_event = "equip_fast",
		wield_reload_anim_event = "equip_reload",
		conditional_state_to_action_input = {
			no_ammo = {
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
				action_name = "action_start_reload",
				chain_time = 0.275,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.275,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.35,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.35,
			},
		},
	},
	action_shoot_hip = {
		abort_sprint = false,
		allowed_during_sprint = false,
		ammunition_usage = 1,
		kind = "shoot_pellets",
		spread_template = "shotgun_p1_m2_assault",
		sprint_ready_up_time = 0.3,
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot_pressed",
		total_time = 1.5,
		uninterruptible = true,
		weapon_handling_template = "immediate_single_shot",
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.05,
			},
			{
				modifier = 0.85,
				t = 0.15,
			},
			{
				modifier = 0.875,
				t = 0.175,
			},
			{
				modifier = 1.1,
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
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_rifle_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_shotgun_01",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_sfx_special_extra_alias = "ranged_single_shot_special_extra",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			weapon_special_muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_muzzle_slug",
			weapon_special_line_effect = LineEffects.shotgun_slug_trail,
		},
		fire_configuration = {
			anim_event = "attack_shoot_semi",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.shotgun_p1_m2_assault,
			shotshell_special = ShotshellTemplates.shotgun_slug_special,
			damage_type = damage_types.pellet,
		},
		conditional_state_to_action_input = {
			no_ammo = {
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
				action_name = "action_start_reload",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.45,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.35,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.45,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_shoot_hip_from_reload = {
		ammunition_usage = 1,
		kind = "shoot_pellets",
		spread_template = "shotgun_p1_m2_assault",
		total_time = 1.5,
		uninterruptible = true,
		weapon_handling_template = "shotgun_from_reload",
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.05,
			},
			{
				modifier = 0.85,
				t = 0.15,
			},
			{
				modifier = 0.875,
				t = 0.175,
			},
			{
				modifier = 1.1,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.5,
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_rifle_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_shotgun_01",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_sfx_special_extra_alias = "ranged_single_shot_special_extra",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			weapon_special_muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_muzzle_slug",
			weapon_special_line_effect = LineEffects.shotgun_slug_trail,
		},
		fire_configuration = {
			anim_event = "attack_shoot_semi",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.shotgun_p1_m2_assault,
			shotshell_special = ShotshellTemplates.shotgun_slug_special,
			damage_type = damage_types.pellet,
		},
		conditional_state_to_action_input = {
			no_ammo = {
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
				action_name = "action_start_reload",
				chain_time = 0.75,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.75,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.75,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.6,
			},
		},
		condition_func = function (action_settings, condition_func_params, used_input)
			local inventory_slot_component = condition_func_params.inventory_slot_component
			local current_clip_amount = inventory_slot_component.current_ammunition_clip

			return current_clip_amount > 0
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_shoot_zoomed = {
		ammunition_usage = 1,
		kind = "shoot_pellets",
		spread_template = "default_shotgun_killshot",
		start_input = "zoom_shoot",
		total_time = 1,
		uninterruptible = true,
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
				modifier = 0.7,
				t = 0.3,
			},
			{
				modifier = 0.8,
				t = 0.5,
			},
			start_modifier = 0.5,
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_rifle_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_shotgun_01",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_sfx_special_extra_alias = "ranged_single_shot_special_extra",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			weapon_special_muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_muzzle_slug",
			weapon_special_line_effect = LineEffects.shotgun_slug_trail,
		},
		fire_configuration = {
			anim_event = "attack_shoot_semi",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.shotgun_p1_m2_killshot,
			shotshell_special = ShotshellTemplates.shotgun_slug_special,
			damage_type = damage_types.pellet,
		},
		conditional_state_to_action_input = {
			no_ammo = {
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
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.35,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.3,
			},
			reload = {
				action_name = "action_start_reload",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.45,
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
				chain_time = 0.25,
			},
			reload = {
				action_name = "action_start_reload",
			},
		},
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_assault,
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
			reload = {
				action_name = "action_start_reload",
			},
		},
	},
	action_start_reload = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_end_event = "reload_end",
		anim_event = "reload_start",
		kind = "reload_shotgun",
		sprint_requires_press_to_interrupt = true,
		start_input = "reload",
		stop_alternate_fire = true,
		total_time = 0.95,
		crosshair = {
			crosshair_type = "none",
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		reload_settings = {
			refill_amount = 1,
			refill_at_time = 0.62,
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
				action_name = "action_shoot_hip_from_reload",
				chain_time = 0.25,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.85,
			},
			reload = {
				action_name = "action_reload_loop",
				chain_time = 0.9,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
		},
	},
	action_reload_loop = {
		allowed_during_sprint = true,
		anim_end_event = "reload_end",
		anim_event = "reload_middle",
		kind = "reload_shotgun",
		sprint_requires_press_to_interrupt = true,
		total_time = 0.5,
		weapon_handling_template = "time_scale_1",
		crosshair = {
			crosshair_type = "none",
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		reload_settings = {
			refill_amount = 1,
			refill_at_time = 0.1,
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
				action_name = "action_shoot_hip_from_reload",
				chain_time = 0.25,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0,
			},
			reload = {
				action_name = "action_reload_loop",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
		},
	},
	action_weapon_special = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_event = "load_special_var_01",
		anim_event_3p = "load_special",
		kind = "ranged_load_special",
		prevent_sprint = true,
		sprint_requires_press_to_interrupt = true,
		start_input = "special_action",
		stop_alternate_fire = true,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1",
		crosshair = {
			crosshair_type = "none",
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
		},
		reload_settings = {
			cost = 1,
			refill_amount = 1,
			refill_at_time = 0.62,
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
				action_name = "action_shoot_hip_from_reload",
				chain_time = 1.1,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 1.1,
			},
		},
	},
	action_inspect = {
		anim_end_event = "inspect_end",
		anim_event = "inspect_start",
		kind = "inspect",
		lock_view = true,
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
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/shotgun_rifle"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/shotgun_rifle"
weapon_template.spread_template = "shotgun_p1_m2_assault"
weapon_template.recoil_template = "default_shotgun_assault"
weapon_template.special_recoil_template = "shotgun_killshot_m2_special"
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_ammo_with_delay",
		input_name = "reload",
	},
}
weapon_template.no_ammo_delay = 0.3
weapon_template.ammo_template = "shotgun_p1_m2"
weapon_template.hud_configuration = {
	uses_ammunition = true,
	uses_overheat = false,
	uses_weapon_special_charges = false,
}
weapon_template.weapon_special_tweak_data = {
	keep_active_until_shot_complete = true,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {
	_eject = "fx_eject",
	_muzzle = "fx_muzzle_01",
}
weapon_template.crosshair = {
	crosshair_type = "shotgun",
	crosshair_type_special_active = "bfg",
}
weapon_template.alternate_fire_settings = {
	look_delta_template = "lasgun_holo_aiming",
	peeking_mechanics = true,
	recoil_template = "shotgun_killshot_m2",
	special_recoil_template = "shotgun_killshot_m2_special",
	spread_template = "default_lasgun_killshot",
	start_anim_event = "to_ironsight",
	stop_anim_event = "to_unaim_ironsight",
	sway_template = "default_shotgun_killshot",
	crosshair = {
		crosshair_type = "ironsight",
	},
	camera = {
		custom_vertical_fov = 30,
		near_range = 0.025,
		vertical_fov = 45,
	},
	movement_speed_modifier = {
		{
			modifier = 0.675,
			t = 0.45,
		},
		{
			modifier = 0.65,
			t = 0.47500000000000003,
		},
		{
			modifier = 0.69,
			t = 0.65,
		},
		{
			modifier = 0.6,
			t = 0.7,
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
			modifier = 0.825,
			t = 2,
		},
	},
}
weapon_template.keywords = {
	"ranged",
	"shotgun",
	"p1",
}
weapon_template.hit_marker_type = "center"
weapon_template.dodge_template = "shotgun"
weapon_template.sprint_template = "killshot"
weapon_template.stamina_template = "lasrifle"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.movement_curve_modifier_template = "default"
weapon_template.smart_targeting_template = SmartTargetingTemplates.assault
weapon_template.haptic_trigger_template = HapticTriggerTemplates.ranged.assault
weapon_template.buffs = {
	on_equip = {
		"shotgun_p1_m2_special_shell_reduced_spread",
	},
}
weapon_template.overclocks = {
	stability_up_ammo_down = {
		shotgun_p1_m1_ammo_stat = -0.1,
		shotgun_p1_m1_stability_stat = 0.1,
	},
	dps_up_ammo_down = {
		shotgun_p1_m1_ammo_stat = -0.2,
		shotgun_p1_m1_dps_stat = 0.2,
	},
	ammo_up_dps_down = {
		shotgun_p1_m1_ammo_stat = 0.1,
		shotgun_p1_m1_dps_stat = -0.1,
	},
	mobility_up_stability_down = {
		shotgun_p1_m1_mobility_stat = 0.1,
		shotgun_p1_m1_stability_stat = -0.1,
	},
	power_up_mobility_down = {
		shotgun_p1_m1_mobility_stat = -0.1,
		shotgun_p1_m1_power_stat = 0.1,
	},
}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	shotgun_p1_m2_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.shotgun_dps_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_shoot_zoomed = {
				damage_trait_templates.shotgun_dps_stat,
			},
			action_shoot_hip_from_reload = {
				damage_trait_templates.shotgun_dps_stat,
			},
		},
	},
	shotgun_p1_m2_power_stat = {
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
			action_shoot_hip_from_reload = {
				damage_trait_templates.default_power_stat,
			},
		},
	},
	shotgun_p1_m2_stability_stat = {
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
	shotgun_p1_m2_ammo_stat = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	shotgun_p1_m2_mobility_stat = {
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

local bespoke_shotgun_p1_traits = table.ukeys(WeaponTraitsBespokeShotgunP1)

table.append(weapon_template.traits, bespoke_shotgun_p1_traits)

weapon_template.perks = {
	shotgun_p1_m1_stability_perk = {
		display_name = "loc_trait_display_shotgun_p1_m1_stability_perk",
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
	shotgun_p1_m1_ammo_perk = {
		display_name = "loc_trait_display_shotgun_p1_m1_ammo_perk",
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_perk,
			},
		},
	},
	shotgun_p1_m1_dps_perk = {
		display_name = "loc_trait_display_shotgun_p1_m1_dps_perk",
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_dps_perk,
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_dps_perk,
			},
		},
	},
	shotgun_p1_m1_power_perk = {
		display_name = "loc_trait_display_shotgun_p1_m1_power_perk",
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_power_perk,
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_power_perk,
			},
		},
	},
	shotgun_p1_m1_mobility_perk = {
		display_name = "loc_trait_display_shotgun_p1_m1_mobility_perk",
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
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_accurate",
	},
	{
		display_name = "loc_weapon_keyword_high_damage",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_ranged_attack_primary",
		fire_mode = "shotgun",
		type = "hipfire",
	},
	secondary = {
		display_name = "loc_ranged_attack_secondary_ads",
		fire_mode = "shotgun",
		type = "ads",
	},
	special = {
		desc = "loc_stats_special_action_special_bullet_shotgun_p1m2_desc",
		display_name = "loc_weapon_special_special_ammo",
		type = "special_bullet",
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
			header = "ads",
			icon = "ads",
			sub_icon = "shotgun",
			value_func = "secondary_attack",
		},
		{
			header = "ammo",
			value_func = "ammo",
		},
	},
	weapon_special = {
		header = "special_ammo",
		icon = "special_ammo",
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
weapon_template.special_actions = {
	{
		action_name = "action_shoot_hip",
		use_special_damage = true,
	},
}

return weapon_template
