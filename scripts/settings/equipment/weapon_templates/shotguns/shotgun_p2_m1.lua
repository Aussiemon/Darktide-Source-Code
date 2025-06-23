-- chunkname: @scripts/settings/equipment/weapon_templates/shotguns/shotgun_p2_m1.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local AimAssistTemplates = require("scripts/settings/equipment/aim_assist_templates")
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
local DOUBLE_SHOT_AMMO_USAGE = 2
local weapon_template = {}

weapon_template.action_inputs = {
	shoot_pressed = {
		buffer_time = 0.25,
		max_queue = 2,
		input_sequence = {
			{
				value = true,
				input = "action_one_pressed"
			}
		}
	},
	zoom_shoot = {
		buffer_time = 0.26,
		max_queue = 2,
		input_sequence = {
			{
				value = true,
				input = "action_one_pressed"
			}
		}
	},
	zoom = {
		buffer_time = 0.4,
		input_sequence = {
			{
				value = true,
				input = "action_two_hold",
				input_setting = {
					value = true,
					input = "action_two_pressed",
					setting_value = true,
					setting = "toggle_ads"
				}
			}
		}
	},
	zoom_release = {
		buffer_time = 0.3,
		input_sequence = {
			{
				value = false,
				input = "action_two_hold",
				time_window = math.huge,
				input_setting = {
					setting_value = true,
					setting = "toggle_ads",
					value = true,
					input = "action_two_pressed",
					time_window = math.huge
				}
			}
		}
	},
	reload = {
		buffer_time = 0.2,
		clear_input_queue = true,
		input_sequence = {
			{
				value = true,
				input = "weapon_reload"
			}
		}
	},
	wield = {
		buffer_time = 0.2,
		clear_input_queue = true,
		input_sequence = {
			{
				inputs = wield_inputs
			}
		}
	},
	shoot_special_pressed = {
		buffer_time = 0.25,
		max_queue = 2,
		input_sequence = {
			{
				value = true,
				input = "weapon_extra_pressed"
			}
		}
	},
	zoom_shoot_special_pressed = {
		buffer_time = 0.25,
		max_queue = 2,
		input_sequence = {
			{
				value = true,
				input = "weapon_extra_pressed"
			}
		}
	},
	special_action = {
		buffer_time = 0.2,
		input_sequence = {
			{
				value = true,
				input = "weapon_extra_pressed"
			}
		}
	},
	special_action_hold = {
		buffer_time = 0.2,
		input_sequence = {
			{
				value = true,
				hold_input = "weapon_extra_hold",
				input = "weapon_extra_hold"
			}
		}
	},
	special_action_release = {
		buffer_time = 0.2,
		input_sequence = {
			{
				value = true,
				hold_input = "weapon_extra_release",
				input = "weapon_extra_release"
			}
		}
	},
	special_action_light = {
		buffer_time = 0.3,
		max_queue = 1,
		input_sequence = {
			{
				value = false,
				time_window = 0.25,
				input = "weapon_extra_hold"
			}
		}
	},
	special_action_heavy = {
		buffer_time = 0.5,
		max_queue = 1,
		input_sequence = {
			{
				value = true,
				duration = 0.25,
				input = "weapon_extra_hold"
			},
			{
				value = false,
				time_window = 1.5,
				auto_complete = false,
				input = "weapon_extra_hold"
			}
		}
	}
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		transition = "stay",
		input = "shoot_pressed"
	},
	{
		input = "zoom",
		transition = {
			{
				transition = "base",
				input = "zoom_release"
			},
			{
				transition = "stay",
				input = "zoom_shoot"
			},
			{
				transition = "base",
				input = "reload"
			},
			{
				transition = "base",
				input = "wield"
			},
			{
				transition = "base",
				input = "combat_ability"
			},
			{
				transition = "base",
				input = "grenade_ability"
			},
			{
				transition = "base",
				input = "zoom_shoot_special_pressed"
			},
			{
				transition = "base",
				input = "special_action_hold"
			}
		}
	},
	{
		transition = "stay",
		input = "wield"
	},
	{
		transition = "stay",
		input = "reload"
	},
	{
		input = "special_action_hold",
		transition = {
			{
				transition = "base",
				input = "wield"
			},
			{
				transition = "base",
				input = "special_action_light"
			},
			{
				transition = "base",
				input = "special_action_heavy"
			},
			{
				transition = "base",
				input = "combat_ability"
			},
			{
				transition = "base",
				input = "grenade_ability"
			},
			{
				transition = "base",
				input = "reload"
			}
		}
	}
}

ActionInputHierarchy.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

local function _can_shoot_due_to_reload(action_settings, condition_func_params, used_input)
	local inventory_slot_component = condition_func_params.inventory_slot_component
	local should_cock = inventory_slot_component.reload_state == "cock_weapon"

	return not should_cock
end

weapon_template.actions = {
	action_unwield = {
		allowed_during_sprint = true,
		start_input = "wield",
		uninterruptible = true,
		kind = "unwield",
		total_time = 0,
		allowed_chain_actions = {}
	},
	action_wield = {
		allowed_during_sprint = true,
		wield_anim_event = "equip_double_barrel",
		wield_reload_anim_event = "equip_reload",
		kind = "ranged_wield",
		uninterruptible = true,
		total_time = 1,
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
				input_name = "reload"
			},
			has_cocked_weapon = {
				input_name = "reload"
			}
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.225
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.25
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.25
			},
			special_action_hold = {
				action_name = "action_bash_start",
				chain_time = 0.25
			}
		}
	},
	action_shoot_hip = {
		sprint_requires_press_to_interrupt = true,
		uninterruptible = true,
		start_input = "shoot_pressed",
		kind = "shoot_pellets",
		weapon_handling_template = "immediate_single_shot",
		sprint_ready_up_time = 0.2,
		allowed_during_sprint = false,
		ammunition_usage = 1,
		spread_template = "default_spread_shotgun_p2",
		abort_sprint = false,
		total_time = 0.65,
		action_movement_curve = {
			{
				modifier = 0.84,
				t = 0.05
			},
			{
				modifier = 0.89,
				t = 0.15
			},
			{
				modifier = 0.92,
				t = 0.175
			},
			{
				modifier = 1.11,
				t = 0.3
			},
			{
				modifier = 1,
				t = 0.5
			},
			start_modifier = 0.45
		},
		fx = {
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_p2_m1/shotgun_p2_m1_muzzle_single",
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			shoot_sfx_alias = "ranged_single_shot",
			double_barrel_shotgun_muzzle_flashes = true,
			shoot_sfx_special_extra_alias = "ranged_single_shot_special_extra",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			line_effect = LineEffects.pellet_trail
		},
		fire_configuration = {
			anim_event_3p = "attack_shoot_semi",
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.default_shotgun_shotshell_p2,
			damage_type = damage_types.pellet
		},
		reload_state_transitions = {
			fit_new_mag = "eject_mag_restart"
		},
		conditional_state_to_action_input = {
			no_ammo = {
				input_name = "reload"
			}
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.1
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.4
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.4
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.4
			},
			special_action_hold = {
				action_name = "action_bash_start",
				chain_time = 0.4
			}
		},
		buff_keywords = {
			buff_keywords.allow_hipfire_during_sprint
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		},
		action_condition_func = _can_shoot_due_to_reload
	},
	action_shoot_zoomed = {
		uninterruptible = true,
		activate_special_on_required_ammo = true,
		start_input = "zoom_shoot",
		kind = "shoot_pellets",
		sprint_requires_press_to_interrupt = true,
		allow_shots_with_less_than_required_ammo = true,
		minimum_hold_time = 0.6,
		spread_template = "special_spread_shotgun_p2",
		total_time = 1.1,
		crosshair = {
			crosshair_type = "shotgun"
		},
		ammunition_usage = DOUBLE_SHOT_AMMO_USAGE,
		action_movement_curve = {
			{
				modifier = 0.6,
				t = 0.05
			},
			{
				modifier = 0.65,
				t = 0.15
			},
			{
				modifier = 0.675,
				t = 0.175
			},
			{
				modifier = 0.8,
				t = 0.3
			},
			{
				modifier = 0.9,
				t = 0.5
			},
			start_modifier = 0.35
		},
		fx = {
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_p2_m1/shotgun_p2_m1_muzzle_single",
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_sfx_special_extra_alias = "ranged_single_shot_special_extra",
			double_barrel_shotgun_muzzle_flashes = true,
			weapon_special_muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_p2_m1/shotgun_p2_m1_muzzle_double",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			line_effect = LineEffects.pellet_trail
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
			damage_type = damage_types.pellet
		},
		reload_state_transitions = {
			fit_new_mag = "eject_mag_restart"
		},
		conditional_state_to_action_input = {
			no_ammo = {
				input_name = "reload"
			}
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.45
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 1
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 1
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.575
			},
			special_action_hold = {
				action_name = "action_bash_start",
				chain_time = 0.56
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		},
		action_condition_func = _can_shoot_due_to_reload,
		haptic_trigger_template_condition_func = function (condition_func_params)
			local current_ammo_in_clip = condition_func_params.inventory_slot_component.current_ammunition_clip

			if current_ammo_in_clip >= DOUBLE_SHOT_AMMO_USAGE then
				return HapticTriggerTemplates.ranged.shotgun_p2_double_shot
			end

			return HapticTriggerTemplates.ranged.shotgun_p2_single_shot
		end
	},
	action_zoom = {
		start_input = "zoom",
		kind = "aim",
		total_time = 0.25,
		crosshair = {
			crosshair_type = "shotgun"
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.14
			},
			reload = {
				action_name = "action_reload"
			}
		},
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_assault,
		haptic_trigger_template_condition_func = function (condition_func_params)
			local current_ammo_in_clip = condition_func_params.inventory_slot_component.current_ammunition_clip

			if current_ammo_in_clip >= DOUBLE_SHOT_AMMO_USAGE then
				return HapticTriggerTemplates.ranged.shotgun_p2_double_shot
			end

			return HapticTriggerTemplates.ranged.shotgun_p2_single_shot
		end
	},
	action_unzoom = {
		start_input = "zoom_release",
		kind = "unaim",
		total_time = 0.17,
		crosshair = {
			crosshair_type = "shotgun"
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			zoom = {
				action_name = "action_zoom"
			},
			reload = {
				action_name = "action_reload"
			}
		}
	},
	action_reload = {
		kind = "reload_state",
		start_input = "reload",
		sprint_requires_press_to_interrupt = true,
		reload_policy = "always_with_clip",
		weapon_handling_template = "time_scale_1",
		abort_sprint = true,
		stop_alternate_fire = true,
		allowed_during_sprint = true,
		total_time = 2.8,
		crosshair = {
			crosshair_type = "none"
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		reload_settings = {
			refill_at_time = 1.4,
			refill_amount = 2
		},
		action_movement_curve = {
			{
				modifier = 0.775,
				t = 0.05
			},
			{
				modifier = 0.75,
				t = 0.075
			},
			{
				modifier = 0.59,
				t = 0.25
			},
			{
				modifier = 0.6,
				t = 0.3
			},
			{
				modifier = 0.85,
				t = 0.8
			},
			{
				modifier = 0.9,
				t = 0.9
			},
			{
				modifier = 1,
				t = 2
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 2.2
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 1.9
			},
			special_action_hold = {
				action_name = "action_bash_start",
				chain_time = 0.9
			}
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
			buff_stat_buffs.reload_speed
		}
	},
	action_bash_start = {
		uninterruptible = true,
		sprint_requires_press_to_interrupt = true,
		start_input = "special_action_hold",
		kind = "windup",
		stop_alternate_fire = true,
		anim_end_event = "attack_finished",
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_event = "attack_charge_stab",
		prevent_sprint = true,
		total_time = math.huge,
		crosshair = {
			crosshair_type = "dot"
		},
		action_movement_curve = {
			{
				modifier = 0.3,
				t = 0.1
			},
			{
				modifier = 0.5,
				t = 0.25
			},
			{
				modifier = 0.5,
				t = 0.3
			},
			{
				modifier = 1.5,
				t = 0.35
			},
			{
				modifier = 1.5,
				t = 0.4
			},
			{
				modifier = 1.05,
				t = 0.6
			},
			{
				modifier = 0.75,
				t = 1
			},
			start_modifier = 0.8
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			special_action_light = {
				action_name = "action_bash",
				chain_time = 0
			},
			special_action_heavy = {
				action_name = "action_bash_heavy",
				chain_time = 0.35
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.275
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.15
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		haptic_trigger_template = HapticTriggerTemplates.ranged.none
	},
	action_bash = {
		damage_window_start = 0.13333333333333333,
		hit_armor_anim = "attack_hit",
		allowed_during_sprint = true,
		sprint_requires_press_to_interrupt = true,
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "attack_hit",
		weapon_handling_template = "time_scale_1_2",
		stop_alternate_fire = true,
		range_mod = 1.15,
		damage_window_end = 0.3,
		attack_direction_override = "left",
		kind = "sweep",
		abort_sprint = true,
		uninterruptible = true,
		anim_event = "attack_left_diagonal_up",
		total_time = 1.1,
		crosshair = {
			crosshair_type = "dot"
		},
		action_movement_curve = {
			{
				modifier = 0.3,
				t = 0.1
			},
			{
				modifier = 0.5,
				t = 0.25
			},
			{
				modifier = 0.5,
				t = 0.3
			},
			{
				modifier = 1.5,
				t = 0.35
			},
			{
				modifier = 1.5,
				t = 0.4
			},
			{
				modifier = 1.05,
				t = 0.6
			},
			{
				modifier = 0.75,
				t = 1
			},
			start_modifier = 0.8
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload"
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.4
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.5
			}
		},
		weapon_box = {
			0.25,
			1,
			0.7
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/double_barrel/attack_left_diagonal_up_bash",
			anchor_point_offset = {
				0,
				1.25,
				-0.1
			}
		},
		damage_type = damage_types.weapon_butt,
		damage_profile = DamageProfileTemplates.shotgun_weapon_special_bash_light,
		herding_template = HerdingTemplates.linesman_left_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none
	},
	action_bash_heavy = {
		damage_window_start = 0.2,
		hit_armor_anim = "attack_hit",
		weapon_handling_template = "time_scale_1_3",
		kind = "sweep",
		attack_direction_override = "push",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.15,
		allowed_during_sprint = true,
		stop_alternate_fire = true,
		damage_window_end = 0.3,
		sprint_requires_press_to_interrupt = true,
		abort_sprint = true,
		uninterruptible = true,
		anim_event = "attack_stab",
		total_time = 1.1,
		crosshair = {
			crosshair_type = "dot"
		},
		action_movement_curve = {
			{
				modifier = 0.4,
				t = 0.1
			},
			{
				modifier = 0.5,
				t = 0.25
			},
			{
				modifier = 0.8,
				t = 0.3
			},
			{
				modifier = 1.75,
				t = 0.35
			},
			{
				modifier = 1.5,
				t = 0.4
			},
			{
				modifier = 1.05,
				t = 0.6
			},
			{
				modifier = 0.85,
				t = 1
			},
			start_modifier = 0.8
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.6
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.9
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.8
			},
			special_action_hold = {
				action_name = "action_bash_start",
				chain_time = 0.49
			}
		},
		weapon_box = {
			0.25,
			1.2,
			0.25
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/double_barrel/attack_stab_bash",
			anchor_point_offset = {
				0,
				1.4,
				0.1
			}
		},
		damage_type = damage_types.weapon_butt,
		damage_profile = DamageProfileTemplates.autogun_weapon_special_bash_heavy,
		herding_template = HerdingTemplates.stab,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none
	},
	action_inspect = {
		lock_view = true,
		start_input = "inspect_start",
		anim_end_event = "inspect_end",
		kind = "inspect",
		anim_event = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect"
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none
	}
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.entry_actions = {
	primary_action = "action_shoot_hip",
	secondary_action = "action_zoom"
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
		input_name = "reload"
	},
	{
		conditional_state = "has_cocked_weapon",
		input_name = "reload"
	}
}
weapon_template.no_ammo_delay = 0.3
weapon_template.ammo_template = "shotgun_p2_m1"
weapon_template.hud_configuration = {
	uses_overheat = false,
	uses_ammunition = true
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {
	_muzzle = "fx_muzzle_02",
	_muzzle_secondary = "fx_muzzle_01"
}
weapon_template.crosshair = {
	crosshair_type = "shotgun"
}
weapon_template.alternate_fire_settings = {
	peeking_mechanics = true,
	sway_template = "default_shotgun_killshot",
	recoil_template = "assault_recoil_shotgun_p2_ads",
	stop_anim_event = "to_unaim_braced",
	special_recoil_template = "special_recoil_shotgun_p2",
	spread_template = "special_spread_shotgun_p2",
	start_anim_event = "to_braced",
	look_delta_template = "lasgun_holo_aiming",
	crosshair = {
		crosshair_type = "shotgun"
	},
	camera = {
		custom_vertical_fov = 50,
		vertical_fov = 58,
		near_range = 0.025
	},
	movement_speed_modifier = {
		{
			modifier = 0.75,
			t = 0
		},
		{
			modifier = 0.6,
			t = 0.25
		},
		{
			modifier = 0.6,
			t = 0.35
		},
		{
			modifier = 0.8,
			t = 0.6
		}
	}
}
weapon_template.keywords = {
	"ranged",
	"shotgun",
	"p2"
}
weapon_template.hit_marker_type = "center"
weapon_template.dodge_template = "shotgun"
weapon_template.sprint_template = "assault"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "assault"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.movement_curve_modifier_template = "shotgun_p2"
weapon_template.smart_targeting_template = SmartTargetingTemplates.killshot

weapon_template.haptic_trigger_template_condition_func = function (condition_func_params)
	local special_active = condition_func_params.inventory_slot_component.special_active

	if special_active then
		return HapticTriggerTemplates.ranged.shotgun_p2_double_shot
	end

	return HapticTriggerTemplates.ranged.shotgun_p2_single_shot
end

weapon_template.overclocks = {
	stability_up_ammo_down = {
		shotgun_p2_m1_ammo_stat = -0.1,
		shotgun_p2_m1_stability_stat = 0.1
	},
	dps_up_ammo_down = {
		shotgun_p2_m1_dps_stat = 0.2,
		shotgun_p2_m1_ammo_stat = -0.2
	},
	ammo_up_dps_down = {
		shotgun_p2_m1_ammo_stat = 0.1,
		shotgun_p2_m1_dps_stat = -0.1
	},
	mobility_up_stability_down = {
		shotgun_p2_m1_stability_stat = -0.1,
		shotgun_p2_m1_mobility_stat = 0.1
	},
	power_up_mobility_down = {
		shotgun_p2_m1_power_stat = 0.1,
		shotgun_p2_m1_mobility_stat = -0.1
	}
}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	shotgun_p2_m1_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.shotgun_dps_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			},
			action_shoot_zoomed = {
				damage_trait_templates.shotgun_dps_stat
			}
		}
	},
	shotgun_p2_m1_power_stat = {
		display_name = "loc_stats_display_power_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_power_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_power_stat
			}
		}
	},
	shotgun_p2_m1_mobility_stat = {
		display_name = "loc_stats_display_mobility_stat",
		is_stat_trait = true,
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		},
		spread = {
			base = {
				spread_trait_templates.mobility_spread_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_spread")
			}
		}
	},
	shotgun_p2_m1_range_stat = {
		display_name = "loc_stats_display_range_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.shotgun_default_range_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			},
			action_shoot_zoomed = {
				damage_trait_templates.shotgun_default_range_stat
			}
		}
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
							display_name = "loc_weapon_stats_display_reload_speed"
						}
					}
				}
			}
		}
	}
}
weapon_template.traits = {}

local bespoke_shotgun_p2_traits = table.ukeys(WeaponTraitsBespokeShotgunP2)

table.append(weapon_template.traits, bespoke_shotgun_p2_traits)

weapon_template.hipfire_inputs = {
	shoot_pressed = true
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_close_combat"
	},
	{
		display_name = "loc_weapon_keyword_high_damage"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		fire_mode = "shotgun",
		display_name = "loc_ranged_attack_primary",
		type = "hipfire"
	},
	secondary = {
		fire_mode = "shotgun",
		display_name = "loc_ranged_attack_secondary_braced",
		type = "brace"
	},
	special = {
		desc = "loc_stats_special_action_melee_weapon_bash_desc",
		display_name = "loc_weapon_special_weapon_bash",
		type = "melee_hand"
	}
}
weapon_template.weapon_card_data = {
	main = {
		{
			value_func = "primary_attack",
			icon = "hipfire",
			sub_icon = "shotgun",
			header = "hipfire"
		},
		{
			value_func = "secondary_attack_double_barrel",
			icon = "brace",
			sub_icon = "shotgun",
			header = "brace"
		},
		{
			value_func = "ammo",
			header = "ammo"
		}
	},
	weapon_special = {
		icon = "melee_hand",
		header = "weapon_bash"
	}
}
weapon_template.explicit_combo = {
	{
		"action_shoot_hip"
	},
	{
		"action_shoot_zoomed"
	}
}
weapon_template.special_action_name = "action_bash"

return weapon_template
