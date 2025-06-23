-- chunkname: @scripts/settings/equipment/weapon_templates/shotguns/shotgun_p4_m1.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
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
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local WeaponTraitsBespokeShotgunP4 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_shotgun_p4")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local armor_types = ArmorSettings.types
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_types = DamageSettings.damage_types
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local special_rules = SpecialRulesSettings.special_rules
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
		buffer_time = 0.4,
		max_queue = 2,
		input_sequence = {
			{
				value = true,
				input = "action_one_pressed"
			}
		}
	},
	zoom_shoot = {
		buffer_time = 0.4,
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
		buffer_time = 0.35,
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
		buffer_time = 0.4,
		clear_input_queue = true,
		input_sequence = {
			{
				value = true,
				input = "weapon_reload"
			}
		}
	},
	wield = {
		buffer_time = 0.5,
		clear_input_queue = true,
		input_sequence = {
			{
				inputs = wield_inputs
			}
		}
	},
	special_action = {
		buffer_time = 0.3,
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
				input = "special_action"
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
		transition = "stay",
		input = "special_action"
	}
}

ActionInputHierarchy.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

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
		uninterruptible = true,
		kind = "ranged_wield",
		wield_anim_event = "equip_fast",
		wield_reload_anim_event = "equip_reload",
		weapon_handling_template = "time_scale_0_5",
		allowed_during_sprint = true,
		total_time = 0.6,
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
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_start_reload",
				chain_time = 0.25
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.25
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.2
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.25
			}
		}
	},
	action_shoot_hip = {
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot_pressed",
		kind = "shoot_pellets",
		weapon_handling_template = "immediate_single_shot",
		sprint_ready_up_time = 0.3,
		allowed_during_sprint = false,
		ammunition_usage = 1,
		spread_template = "default_spread_shotgun_p4_hip",
		abort_sprint = false,
		uninterruptible = true,
		total_time = 1.2,
		action_movement_curve = {
			{
				modifier = 0.7,
				t = 0.05
			},
			{
				modifier = 0.75,
				t = 0.15
			},
			{
				modifier = 0.775,
				t = 0.175
			},
			{
				modifier = 0.8,
				t = 0.3
			},
			{
				modifier = 1,
				t = 0.5
			},
			start_modifier = 0.7
		},
		fx = {
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_rifle_muzzle",
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_sfx_special_extra_alias = "ranged_single_shot_special_extra",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_shotgun_01",
			weapon_special_muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_p4/shotgun_p4_weapon_special_muzzle",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			line_effect = LineEffects.pellet_trail,
			weapon_special_line_effect = LineEffects.pellet_trail_shock
		},
		fire_configuration = {
			anim_event = "attack_shoot_semi",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.shotgun_p4_m1_hip,
			shotshell_special = ShotshellTemplates.shotgun_p4_m1_hip_special,
			damage_type = damage_types.pellet
		},
		conditional_state_to_action_input = {
			no_ammo = {
				input_name = "reload"
			}
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t)
			if not condition_func_params then
				return true
			end

			local weapon_extension = condition_func_params.weapon_extension
			local last_shoot_action_t = weapon_extension.last_shoot_action_t
			local next_allowed_shoot_action_t = last_shoot_action_t + 0.85

			if next_allowed_shoot_action_t <= t then
				return true
			end

			return false
		end,
		action_finish_func = function (reason, data, condition_func_params, t)
			if not condition_func_params then
				return
			end

			local weapon_extension = condition_func_params.weapon_extension
			local weapon_action_component = condition_func_params.weapon_action_component
			local start_t = weapon_action_component.start_t

			weapon_extension.last_shoot_action_t = start_t
		end,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0
			},
			reload = {
				action_name = "action_start_reload",
				chain_time = 0.45
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.45
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.85
			},
			zoom = {
				action_name = "action_zoom_from_shoot",
				chain_time = 0.55
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_shoot_hip_from_reload = {
		ammunition_usage = 1,
		kind = "shoot_pellets",
		spread_template = "default_spread_shotgun_p4_hip",
		weapon_handling_template = "immediate_single_shot",
		uninterruptible = true,
		total_time = 1.2,
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.05
			},
			{
				modifier = 0.85,
				t = 0.15
			},
			{
				modifier = 0.875,
				t = 0.175
			},
			{
				modifier = 1.1,
				t = 0.3
			},
			{
				modifier = 1,
				t = 0.5
			},
			start_modifier = 0.7
		},
		fx = {
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_rifle_muzzle",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_shotgun_01",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			shoot_sfx_alias = "ranged_single_shot",
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_sfx_special_extra_alias = "ranged_single_shot_special_extra",
			weapon_special_muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_p4/shotgun_p4_weapon_special_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			line_effect = LineEffects.pellet_trail,
			weapon_special_line_effect = LineEffects.pellet_trail_shock
		},
		fire_configuration = {
			anim_event = "attack_shoot_semi",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.shotgun_p4_m1_hip,
			shotshell_special = ShotshellTemplates.shotgun_p4_m1_hip_special,
			damage_type = damage_types.pellet
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
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_start_reload",
				chain_time = 0.75
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.75
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.95
			},
			zoom = {
				action_name = "action_zoom_from_shoot",
				chain_time = 0.6
			}
		},
		action_condition_func = function (action_settings, condition_func_params, used_input)
			local inventory_slot_component = condition_func_params.inventory_slot_component
			local current_clip_amount = inventory_slot_component.current_ammunition_clip

			return current_clip_amount > 0
		end,
		action_finish_func = function (reason, data, condition_func_params, t)
			if not condition_func_params then
				return
			end

			local weapon_extension = condition_func_params.weapon_extension
			local weapon_action_component = condition_func_params.weapon_action_component
			local start_t = weapon_action_component.start_t

			weapon_extension.last_shoot_action_t = start_t
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_shoot_zoomed = {
		ammunition_usage = 1,
		kind = "shoot_pellets",
		spread_template = "default_spread_shotgun_p4_ads",
		weapon_handling_template = "immediate_single_shot",
		uninterruptible = true,
		start_input = "zoom_shoot",
		total_time = 1.2,
		crosshair = {
			crosshair_type = "shotgun_wide"
		},
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
				modifier = 0.7,
				t = 0.3
			},
			{
				modifier = 1,
				t = 0.5
			},
			start_modifier = 0.7
		},
		fx = {
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_rifle_muzzle",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_shotgun_01",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			shoot_sfx_alias = "ranged_single_shot",
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_sfx_special_extra_alias = "ranged_single_shot_special_extra",
			weapon_special_muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_p4/shotgun_p4_weapon_special_muzzle",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			line_effect = LineEffects.pellet_trail,
			weapon_special_line_effect = LineEffects.pellet_trail_shock
		},
		fire_configuration = {
			anim_event = "attack_shoot_semi",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.shotgun_p4_m1_ads,
			shotshell_special = ShotshellTemplates.shotgun_p4_m1_ads_special,
			damage_type = damage_types.pellet
		},
		conditional_state_to_action_input = {
			no_ammo = {
				input_name = "reload"
			}
		},
		action_condition_func = function (action_settings, condition_func_params, used_input, t)
			if not condition_func_params then
				return true
			end

			local weapon_extension = condition_func_params.weapon_extension
			local last_shoot_action_t = weapon_extension.last_shoot_action_t
			local next_allowed_shoot_action_t = last_shoot_action_t + 0.85

			if next_allowed_shoot_action_t <= t then
				return true
			end

			return false
		end,
		action_finish_func = function (reason, data, condition_func_params, t)
			if not condition_func_params then
				return
			end

			local weapon_extension = condition_func_params.weapon_extension
			local weapon_action_component = condition_func_params.weapon_action_component
			local start_t = weapon_action_component.start_t

			weapon_extension.last_shoot_action_t = start_t
		end,
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
				chain_time = 0.85
			},
			zoom_release = {
				action_name = "action_unzoom_from_shoot",
				chain_time = 0.55
			},
			reload = {
				action_name = "action_start_reload",
				chain_time = 0.45
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.45
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_zoom = {
		start_input = "zoom",
		kind = "aim",
		total_time = 0.25,
		crosshair = {
			crosshair_type = "shotgun_wide"
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
				chain_time = 0.45
			},
			reload = {
				action_name = "action_start_reload"
			}
		},
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_assault
	},
	action_zoom_from_shoot = {
		start_input = "nil",
		kind = "aim",
		action_priority = 1,
		total_time = 0.46,
		crosshair = {
			crosshair_type = "shotgun_wide"
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
				chain_time = 0.3
			},
			reload = {
				action_name = "action_start_reload"
			}
		},
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_assault
	},
	action_unzoom = {
		start_input = "zoom_release",
		kind = "unaim",
		total_time = 0.1,
		crosshair = {
			crosshair_type = "shotgun_wide"
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
				action_name = "action_start_reload"
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.65
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.2
			}
		}
	},
	action_unzoom_from_shoot = {
		start_input = "nil",
		kind = "unaim",
		action_priority = 2,
		total_time = 0.5,
		crosshair = {
			crosshair_type = "shotgun_wide"
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
				action_name = "action_start_reload"
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.3
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.2
			}
		}
	},
	action_start_reload = {
		stop_alternate_fire = true,
		start_input = "reload",
		anim_end_event = "reload_end",
		kind = "reload_shotgun",
		abort_sprint = true,
		sprint_requires_press_to_interrupt = true,
		allowed_during_sprint = true,
		anim_event = "reload_start",
		total_time = 0.95,
		crosshair = {
			crosshair_type = "none"
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		reload_settings = {
			refill_at_time = 0.62,
			refill_amount = 1
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
		conditional_state_to_action_input = {
			auto_chain = {
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
			shoot_pressed = {
				action_name = "action_shoot_hip_from_reload",
				chain_time = 0.75
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.85
			},
			reload = {
				action_name = "action_reload_loop",
				chain_time = 0.75
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed
		}
	},
	action_weapon_special = {
		stop_alternate_fire = true,
		start_input = "special_action",
		kind = "ranged_load_special",
		sprint_requires_press_to_interrupt = true,
		weapon_handling_template = "time_scale_1",
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_event = "load_special",
		prevent_sprint = true,
		total_time = 1.5,
		crosshair = {
			crosshair_type = "none"
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed
		},
		reload_settings = {
			refill_at_time = 0.79,
			refill_amount = 1
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
				action_name = "action_shoot_hip_from_reload",
				chain_time = 0.9
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 1.1
			}
		}
	},
	action_reload_loop = {
		kind = "reload_shotgun",
		anim_end_event = "reload_end",
		weapon_handling_template = "time_scale_1",
		sprint_requires_press_to_interrupt = true,
		allowed_during_sprint = true,
		anim_event = "reload_middle",
		total_time = 0.55,
		crosshair = {
			crosshair_type = "none"
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		reload_settings = {
			refill_at_time = 0.25,
			refill_amount = 1
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
		conditional_state_to_action_input = {
			auto_chain = {
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
			shoot_pressed = {
				action_name = "action_shoot_hip_from_reload",
				chain_time = 0.44
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.25
			},
			reload = {
				action_name = "action_reload_loop",
				chain_time = 0.45
			},
			special_action = {
				action_name = "action_weapon_special",
				chain_time = 0.45
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed
		}
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
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/shotgun_assault"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/shotgun_assault"
weapon_template.spread_template = "default_spread_shotgun_p4_hip"
weapon_template.recoil_template = "shotgun_p4_m1_hip"
weapon_template.special_recoil_template = "special_recoil_shotgun_p4"
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_ammo_with_delay",
		input_name = "reload"
	}
}
weapon_template.no_ammo_delay = 0.3
weapon_template.ammo_template = "shotgun_p4_m1"
weapon_template.hud_configuration = {
	uses_overheat = false,
	uses_ammunition = true
}
weapon_template.weapon_special_class = "WeaponSpecialFakeSeparateAmmoPool"
weapon_template.weapon_special_tweak_data = {
	keep_active_until_shot_complete = true,
	keep_active_on_unwield = true,
	max_num_charges = 6,
	keep_active_on_sprint = true,
	keep_active_on_vault = true,
	keep_active_on_stun = true,
	set_inactive_func = function (inventory_slot_component, reason, tweak_data)
		local keep_special_active = reason == "started_sprint" or reason == "ledge_vaulting" or reason == "stunned" or reason == "unwield"

		if not keep_special_active then
			inventory_slot_component.special_active = false
		end

		return not keep_special_active
	end
}
weapon_template.special_rules = {
	special_rules.ammo_pickups_replenishes_num_special_charges
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {
	_muzzle = "fx_muzzle_01",
	_eject = "fx_eject"
}
weapon_template.crosshair = {
	crosshair_type = "shotgun_wide"
}
weapon_template.alternate_fire_settings = {
	peeking_mechanics = true,
	sway_template = "default_shotgun_killshot",
	recoil_template = "shotgun_p4_m1_ads",
	stop_anim_event = "to_unaim_ironsight",
	special_recoil_template = "special_recoil_shotgun_p4",
	spread_template = "default_spread_shotgun_p4_ads",
	start_anim_event = "to_ironsight",
	look_delta_template = "lasgun_holo_aiming",
	crosshair = {
		crosshair_type = "shotgun_wide"
	},
	camera = {
		custom_vertical_fov = 40,
		vertical_fov = 55,
		near_range = 0.025
	},
	movement_speed_modifier = {
		{
			modifier = 0.7,
			t = 0
		},
		{
			modifier = 0.75,
			t = 0.25
		},
		{
			modifier = 0.8,
			t = 0.35
		},
		{
			modifier = 0.9,
			t = 0.5
		}
	}
}
weapon_template.keywords = {
	"ranged",
	"shotgun",
	"p4"
}
weapon_template.hit_marker_type = "center"
weapon_template.dodge_template = "shotgun"
weapon_template.sprint_template = "killshot"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.movement_curve_modifier_template = "shotgun_p4"
weapon_template.smart_targeting_template = SmartTargetingTemplates.killshot
weapon_template.haptic_trigger_template = HapticTriggerTemplates.ranged.assault
weapon_template.combo_reset_duration = 0.2
weapon_template.overclocks = {
	stability_up_ammo_down = {
		shotgun_p1_m1_ammo_stat = -0.1,
		shotgun_p1_m1_stability_stat = 0.1
	},
	dps_up_ammo_down = {
		shotgun_p1_m1_ammo_stat = -0.2,
		shotgun_p1_m1_dps_stat = 0.2
	},
	ammo_up_dps_down = {
		shotgun_p1_m1_dps_stat = -0.1,
		shotgun_p1_m1_ammo_stat = 0.1
	},
	mobility_up_stability_down = {
		shotgun_p1_m1_stability_stat = -0.1,
		shotgun_p1_m1_mobility_stat = 0.1
	},
	power_up_mobility_down = {
		shotgun_p1_m1_power_stat = 0.1,
		shotgun_p1_m1_mobility_stat = -0.1
	}
}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	shotgun_p4_m1_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.shotgun_dps_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			},
			action_shoot_zoomed = {
				damage_trait_templates.shotgun_dps_stat
			},
			action_shoot_hip_from_reload = {
				damage_trait_templates.shotgun_dps_stat
			}
		}
	},
	shotgun_p4_m1_power_stat = {
		display_name = "loc_stats_display_power_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_power_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_power_stat
			},
			action_shoot_hip_from_reload = {
				damage_trait_templates.default_power_stat
			}
		}
	},
	shotgun_p4_m1_stability_stat = {
		display_name = "loc_stats_display_stability_stat",
		is_stat_trait = true,
		recoil = {
			base = {
				recoil_trait_templates.default_recoil_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("stability_recoil", "loc_weapon_stats_display_hip_fire")
			},
			alternate_fire = {
				recoil_trait_templates.default_recoil_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("stability_recoil", "loc_weapon_stats_display_ads")
			}
		},
		spread = {
			base = {
				spread_trait_templates.default_spread_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("stability_spread")
			}
		},
		sway = {
			alternate_fire = {
				sway_trait_templates.default_sway_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("stability_sway")
			}
		}
	},
	shotgun_p4_m1_ammo_stat = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		}
	},
	shotgun_p4_m1_mobility_stat = {
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
	}
}
weapon_template.traits = {}

local bespoke_shotgun_p4_traits = table.ukeys(WeaponTraitsBespokeShotgunP4)

table.append(weapon_template.traits, bespoke_shotgun_p4_traits)

weapon_template.perks = {
	shotgun_p4_m1_stability_perk = {
		display_name = "loc_trait_display_shotgun_p4_m1_stability_perk",
		recoil = {
			base = {
				recoil_trait_templates.default_recoil_perk
			},
			alternate_fire = {
				recoil_trait_templates.default_recoil_perk
			}
		},
		spread = {
			base = {
				spread_trait_templates.default_spread_perk
			}
		},
		sway = {
			alternate_fire = {
				sway_trait_templates.default_sway_perk
			}
		}
	},
	shotgun_p4_m1_ammo_perk = {
		display_name = "loc_trait_display_shotgun_p4_m1_ammo_perk",
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_perk
			}
		}
	},
	shotgun_p4_m1_dps_perk = {
		display_name = "loc_trait_display_shotgun_p4_m1_dps_perk",
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_dps_perk
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_dps_perk
			}
		}
	},
	shotgun_p4_m1_power_perk = {
		display_name = "loc_trait_display_shotgun_p4_m1_power_perk",
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_power_perk
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_power_perk
			}
		}
	},
	shotgun_p4_m1_mobility_perk = {
		display_name = "loc_trait_display_shotgun_p4_m1_mobility_perk",
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_perk
			}
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_perk
			}
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_perk
			}
		},
		recoil = {
			base = {
				recoil_trait_templates.default_mobility_recoil_perk
			},
			alternate_fire = {
				recoil_trait_templates.default_mobility_recoil_perk
			}
		},
		spread = {
			base = {
				spread_trait_templates.default_mobility_spread_perk
			}
		}
	}
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
		display_name = "loc_ranged_attack_secondary_ads",
		type = "ads"
	},
	special = {
		desc = "loc_stats_special_action_special_bullet_shotgun_p4m1_desc",
		display_name = "loc_weapon_special_special_ammo",
		type = "special_bullet"
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
			value_func = "secondary_attack",
			icon = "ads",
			sub_icon = "shotgun",
			header = "ads"
		},
		{
			value_func = "ammo",
			header = "ammo"
		}
	},
	weapon_special = {
		icon = "special_ammo",
		header = "special_ammo"
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
weapon_template.special_actions = {
	{
		action_name = "action_shoot_hip",
		use_special_damage = true
	}
}

return weapon_template
