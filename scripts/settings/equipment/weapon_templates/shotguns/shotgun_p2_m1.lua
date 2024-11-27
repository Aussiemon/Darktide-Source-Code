-- chunkname: @scripts/settings/equipment/weapon_templates/shotguns/shotgun_p2_m1.lua

local ActionInputHierarchyUtils = require("scripts/utilities/weapon/action_input_hierarchy")
local AimAssistTemplates = require("scripts/settings/equipment/aim_assist_templates")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local ShotshellTemplates = require("scripts/settings/projectile/shotshell_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeShotgunP2 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_shotgun_p2")
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
	wield = {
		buffer_time = 0.2,
		clear_input_queue = true,
		input_sequence = {
			{
				inputs = wield_inputs,
			},
		},
	},
	shoot_special_pressed = {
		buffer_time = 0.25,
		max_queue = 2,
		input_sequence = {
			{
				input = "weapon_extra_pressed",
				value = true,
			},
		},
	},
	zoom_shoot_special_pressed = {
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
				input = "zoom_shoot_special_pressed",
				transition = "base",
			},
			{
				input = "special_action_hold",
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
		input = "special_action_hold",
		transition = {
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "special_action_light",
				transition = "base",
			},
			{
				input = "special_action_heavy",
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
				input = "reload",
				transition = "base",
			},
		},
	},
}

ActionInputHierarchyUtils.add_missing_ordered(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

local function _can_shoot_due_to_reload(action_settings, condition_func_params, used_input)
	local inventory_slot_component = condition_func_params.inventory_slot_component
	local should_cock = inventory_slot_component.reload_state == "cock_weapon"

	return not should_cock
end

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
		wield_anim_event = "equip_double_barrel",
		wield_reload_anim_event = "equip_reload",
		wield_reload_anim_event_func = function (inventory_slot_component)
			local ignore_state = inventory_slot_component.reload_state == "fit_new_mag"
			local ammo_empty = inventory_slot_component.current_ammunition_clip == 0

			if ignore_state and not ammo_empty then
				return "equip_double_barrel"
			end

			return "equip_reload"
		end,
		conditional_state_to_action_input = {
			no_ammo = {
				input_name = "reload",
			},
			has_cocked_weapon = {
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
				chain_time = 0.225,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.25,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.25,
			},
			special_action_hold = {
				action_name = "action_bash_start",
				chain_time = 0.25,
			},
		},
	},
	action_shoot_hip = {
		abort_sprint = false,
		allowed_during_sprint = false,
		ammunition_usage = 1,
		kind = "shoot_pellets",
		spread_template = "default_spread_shotgun_p2",
		sprint_ready_up_time = 0.2,
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot_pressed",
		total_time = 0.65,
		uninterruptible = true,
		weapon_handling_template = "immediate_single_shot",
		action_movement_curve = {
			{
				modifier = 0.84,
				t = 0.05,
			},
			{
				modifier = 0.89,
				t = 0.15,
			},
			{
				modifier = 0.92,
				t = 0.175,
			},
			{
				modifier = 1.11,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.45,
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			double_barrel_shotgun_muzzle_flashes = true,
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_p2_m1/shotgun_p2_m1_muzzle_single",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_sfx_special_extra_alias = "ranged_single_shot_special_extra",
			shoot_tail_sfx_alias = "ranged_shot_tail",
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			anim_event_3p = "attack_shoot_semi",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.default_shotgun_shotshell_p2,
			damage_type = damage_types.pellet,
		},
		reload_state_transitions = {
			fit_new_mag = "eject_mag_restart",
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
				chain_time = 0.1,
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.4,
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.4,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.4,
			},
			special_action_hold = {
				action_name = "action_bash_start",
				chain_time = 0.4,
			},
		},
		buff_keywords = {
			buff_keywords.allow_hipfire_during_sprint,
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
		action_condition_func = _can_shoot_due_to_reload,
	},
	action_shoot_zoomed = {
		activate_special_on_required_ammo = true,
		allow_shots_with_less_than_required_ammo = true,
		ammunition_usage = 2,
		kind = "shoot_pellets",
		minimum_hold_time = 0.6,
		spread_template = "special_spread_shotgun_p2",
		sprint_requires_press_to_interrupt = true,
		start_input = "zoom_shoot",
		total_time = 1.1,
		uninterruptible = true,
		crosshair = {
			crosshair_type = "shotgun",
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
				modifier = 0.8,
				t = 0.3,
			},
			{
				modifier = 0.9,
				t = 0.5,
			},
			start_modifier = 0.35,
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			double_barrel_shotgun_muzzle_flashes = true,
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_p2_m1/shotgun_p2_m1_muzzle_single",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_sfx_special_extra_alias = "ranged_single_shot_special_extra",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			weapon_special_muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_p2_m1/shotgun_p2_m1_muzzle_double",
		},
		fire_configuration = {
			same_side_suppression_enabled = false,
			anim_event_func = function (inventory_slot_component)
				local current_clip_amount = inventory_slot_component.current_ammunition_clip
				local max_clip_amount = inventory_slot_component.max_ammunition_clip
				local full_ammo = current_clip_amount == max_clip_amount
				local anim_1p = full_ammo and "attack_shoot_special" or "attack_shoot_semi"
				local anim_3p = "attack_shoot_semi"

				return anim_1p
			end,
			shotshell = ShotshellTemplates.default_shotgun_shotshell_p2,
			shotshell_special = ShotshellTemplates.special_shotgun_shotshell_p2,
			damage_type = damage_types.pellet,
		},
		reload_state_transitions = {
			fit_new_mag = "eject_mag_restart",
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
				chain_time = 0.45,
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 1,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 1,
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.575,
			},
			special_action_hold = {
				action_name = "action_bash_start",
				chain_time = 0.56,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
		action_condition_func = _can_shoot_due_to_reload,
	},
	action_zoom = {
		kind = "aim",
		start_input = "zoom",
		total_time = 0.25,
		crosshair = {
			crosshair_type = "shotgun",
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
				chain_time = 0.14,
			},
			reload = {
				action_name = "action_reload",
			},
		},
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_assault,
	},
	action_unzoom = {
		kind = "unaim",
		start_input = "zoom_release",
		total_time = 0.17,
		crosshair = {
			crosshair_type = "shotgun",
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
		reload_policy = "always_with_clip",
		sprint_requires_press_to_interrupt = true,
		start_input = "reload",
		stop_alternate_fire = true,
		total_time = 2.8,
		weapon_handling_template = "time_scale_1",
		crosshair = {
			crosshair_type = "none",
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		reload_settings = {
			refill_amount = 2,
			refill_at_time = 1.4,
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
				chain_time = 2.2,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 1.9,
			},
			special_action_hold = {
				action_name = "action_bash_start",
				chain_time = 0.9,
			},
		},
		action_condition_func = function (action_settings, condition_func_params, used_input)
			local inventory_slot_component = condition_func_params.inventory_slot_component
			local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
			local max_ammunition_clip = inventory_slot_component.max_ammunition_clip
			local can_reload = current_ammunition_clip < max_ammunition_clip
			local should_cock = inventory_slot_component.reload_state == "cock_weapon"

			return should_cock or can_reload
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
		},
	},
	action_bash_start = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_charge_stab",
		kind = "windup",
		prevent_sprint = true,
		sprint_requires_press_to_interrupt = true,
		start_input = "special_action_hold",
		stop_alternate_fire = true,
		uninterruptible = true,
		total_time = math.huge,
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
			special_action_light = {
				action_name = "action_bash",
				chain_time = 0,
			},
			special_action_heavy = {
				action_name = "action_bash_heavy",
				chain_time = 0.35,
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
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_bash = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_event = "attack_left_diagonal_up",
		attack_direction_override = "left",
		damage_window_end = 0.3,
		damage_window_start = 0.13333333333333333,
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.15,
		sprint_requires_press_to_interrupt = true,
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
				chain_time = 0.5,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.5,
			},
		},
		weapon_box = {
			0.25,
			1,
			0.7,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/double_barrel/attack_left_diagonal_up_bash",
			anchor_point_offset = {
				0,
				1.25,
				-0.1,
			},
		},
		damage_type = damage_types.weapon_butt,
		damage_profile = DamageProfileTemplates.shotgun_weapon_special_bash_light,
		herding_template = HerdingTemplates.linesman_left_heavy,
	},
	action_bash_heavy = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_event = "attack_stab",
		attack_direction_override = "push",
		damage_window_end = 0.3,
		damage_window_start = 0.2,
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.15,
		sprint_requires_press_to_interrupt = true,
		stop_alternate_fire = true,
		total_time = 1.1,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_3",
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
				modifier = 0.8,
				t = 0.3,
			},
			{
				modifier = 1.75,
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
				modifier = 0.85,
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
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.9,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.8,
			},
			special_action_hold = {
				action_name = "action_bash_start",
				chain_time = 0.49,
			},
		},
		weapon_box = {
			0.25,
			1.2,
			0.25,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/double_barrel/attack_stab_bash",
			anchor_point_offset = {
				0,
				1.4,
				0.1,
			},
		},
		damage_type = damage_types.weapon_butt,
		damage_profile = DamageProfileTemplates.autogun_weapon_special_bash_heavy,
		herding_template = HerdingTemplates.stab,
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
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.entry_actions = {
	primary_action = "action_shoot_hip",
	secondary_action = "action_zoom",
}
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/shotgun_rifle"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/double_barrel"
weapon_template.reload_template = ReloadTemplates.double_barrel
weapon_template.spread_template = "default_spread_shotgun_p2"
weapon_template.recoil_template = "assault_recoil_shotgun_p2"
weapon_template.special_recoil_template = "special_recoil_shotgun_p2"
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_ammo_with_delay",
		input_name = "reload",
	},
	{
		conditional_state = "has_cocked_weapon",
		input_name = "reload",
	},
}
weapon_template.no_ammo_delay = 0.3
weapon_template.ammo_template = "shotgun_p2_m1"
weapon_template.hud_configuration = {
	uses_ammunition = true,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {
	_muzzle = "fx_muzzle_02",
	_muzzle_secondary = "fx_muzzle_01",
}
weapon_template.crosshair = {
	crosshair_type = "shotgun",
}
weapon_template.alternate_fire_settings = {
	look_delta_template = "lasgun_holo_aiming",
	peeking_mechanics = true,
	recoil_template = "assault_recoil_shotgun_p2_ads",
	special_recoil_template = "special_recoil_shotgun_p2",
	spread_template = "special_spread_shotgun_p2",
	start_anim_event = "to_braced",
	stop_anim_event = "to_unaim_braced",
	sway_template = "default_shotgun_killshot",
	crosshair = {
		crosshair_type = "shotgun",
	},
	camera = {
		custom_vertical_fov = 50,
		near_range = 0.025,
		vertical_fov = 58,
	},
	movement_speed_modifier = {
		{
			modifier = 0.75,
			t = 0,
		},
		{
			modifier = 0.6,
			t = 0.25,
		},
		{
			modifier = 0.6,
			t = 0.35,
		},
		{
			modifier = 0.8,
			t = 0.6,
		},
	},
}
weapon_template.keywords = {
	"ranged",
	"shotgun",
	"p2",
}
weapon_template.hit_marker_type = "center"
weapon_template.dodge_template = "shotgun"
weapon_template.sprint_template = "assault"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "assault"
weapon_template.movement_curve_modifier_template = "shotgun_p2"
weapon_template.smart_targeting_template = SmartTargetingTemplates.killshot
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.overclocks = {
	stability_up_ammo_down = {
		shotgun_p2_m1_ammo_stat = -0.1,
		shotgun_p2_m1_stability_stat = 0.1,
	},
	dps_up_ammo_down = {
		shotgun_p2_m1_ammo_stat = -0.2,
		shotgun_p2_m1_dps_stat = 0.2,
	},
	ammo_up_dps_down = {
		shotgun_p2_m1_ammo_stat = 0.1,
		shotgun_p2_m1_dps_stat = -0.1,
	},
	mobility_up_stability_down = {
		shotgun_p2_m1_mobility_stat = 0.1,
		shotgun_p2_m1_stability_stat = -0.1,
	},
	power_up_mobility_down = {
		shotgun_p2_m1_mobility_stat = -0.1,
		shotgun_p2_m1_power_stat = 0.1,
	},
}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	shotgun_p2_m1_dps_stat = {
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
		},
	},
	shotgun_p2_m1_power_stat = {
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
	shotgun_p2_m1_mobility_stat = {
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
	shotgun_p2_m1_range_stat = {
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
	shotgun_p2_m1_reload_speed_stat = {
		display_name = "loc_stats_display_reload_speed_stat",
		is_stat_trait = true,
		weapon_handling = {
			action_reload = {
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
}
weapon_template.traits = {}

local bespoke_shotgun_p2_traits = table.ukeys(WeaponTraitsBespokeShotgunP2)

table.append(weapon_template.traits, bespoke_shotgun_p2_traits)

weapon_template.hipfire_inputs = {
	shoot_pressed = true,
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_close_combat",
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
			value_func = "secondary_attack_double_barrel",
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
