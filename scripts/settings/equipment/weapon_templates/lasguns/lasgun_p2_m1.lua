local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsRangedAimed = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_aimed")
local WeaponTraitsRangedCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_common")
local WeaponTraitsRangedMediumFireRate = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_medium_fire_rate")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events
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
local weapon_template = {
	action_inputs = {
		shoot_pressed = {
			buffer_time = 0.5,
			max_queue = 2,
			input_sequence = {
				{
					value = true,
					input = "action_one_pressed"
				}
			}
		},
		shoot_hold = {
			buffer_time = 0.1,
			max_queue = 2,
			input_sequence = {
				{
					value = true,
					hold_input = "action_one_hold",
					input = "action_one_hold"
				}
			}
		},
		shoot_release = {
			buffer_time = 0.52,
			input_sequence = {
				{
					value = false,
					input = "action_one_hold",
					time_window = math.huge
				}
			}
		},
		zoom_shoot = {
			buffer_time = 0.26,
			max_queue = 2,
			input_sequence = {
				{
					value = true,
					hold_input = "action_two_hold",
					input = "action_one_pressed"
				}
			}
		},
		zoom_shoot_hold = {
			buffer_time = 0.1,
			max_queue = 2,
			input_sequence = {
				{
					value = true,
					hold_input = "action_two_hold",
					input = "action_one_hold"
				}
			}
		},
		zoom_shoot_release = {
			buffer_time = 0.52,
			input_sequence = {
				{
					value = false,
					hold_input = "action_two_hold",
					input = "action_one_hold",
					time_window = math.huge
				}
			}
		},
		zoom = {
			buffer_time = 0.4,
			input_sequence = {
				{
					value = true,
					input = "action_two_hold"
				}
			}
		},
		zoom_release = {
			buffer_time = 0.3,
			input_sequence = {
				{
					value = false,
					input = "action_two_hold",
					time_window = math.huge
				}
			}
		},
		reload = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					value = true,
					input = "weapon_reload"
				}
			}
		},
		brace_reload = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					value = true,
					input = "weapon_reload"
				}
			}
		},
		wield = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					inputs = wield_inputs
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
		},
		zoom_weapon_special = {
			buffer_time = 0.26,
			max_queue = 2,
			input_sequence = {
				{
					value = true,
					hold_input = "action_two_hold",
					input = "weapon_extra_pressed"
				}
			}
		}
	}
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	wield = "stay",
	special_action = "stay",
	reload = "stay",
	shoot_pressed = {
		combat_ability = "stay",
		wield = "base",
		grenade_ability = "base",
		zoom_weapon_special = "stay",
		reload = "base",
		shoot_hold = "stay",
		shoot_release = "base"
	},
	zoom = {
		zoom_release = "base",
		wield = "base",
		grenade_ability = "base",
		reload = "previous",
		combat_ability = "base",
		zoom_weapon_special = "stay",
		zoom_shoot = {
			zoom_shoot_hold = "stay",
			grenade_ability = "base",
			zoom_shoot_release = "previous",
			zoom_release = "base",
			wield = "base",
			reload = "base",
			combat_ability = "stay"
		}
	},
	special_action_hold = {
		special_action = "base",
		special_action_light = "base",
		special_action_heavy = "base",
		zoom = "base",
		wield = "base",
		reload = "base",
		combat_ability = "base",
		grenade_ability = "base"
	}
}

table.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
	action_unwield = {
		continue_sprinting = true,
		allowed_during_sprint = true,
		start_input = "wield",
		uninterruptible = true,
		kind = "unwield",
		total_time = 0,
		allowed_chain_actions = {}
	},
	action_wield = {
		allowed_during_sprint = true,
		wield_anim_event = "equip",
		wield_reload_anim_event = "equip_reload",
		kind = "ranged_wield",
		continue_sprinting = true,
		uninterruptible = true,
		total_time = 1.8,
		conditional_state_to_action_input = {
			started_reload = {
				input_name = "reload"
			}
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.275
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 1.25
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 1.5
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 1
			}
		}
	},
	action_shoot_hip_start = {
		anim_event = "attack_charge",
		start_input = "shoot_pressed",
		allowed_during_sprint = true,
		kind = "windup",
		anim_end_event = "attack_finished",
		total_time = math.huge,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload"
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 1
			},
			shoot_release = {
				action_name = "action_shoot_hip",
				chain_time = 0.5
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.15
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_shoot_hip = {
		kind = "shoot_hit_scan",
		ammunition_usage_max = 7,
		sprint_requires_press_to_interrupt = true,
		weapon_handling_template = "immediate_single_shot",
		sprint_ready_up_time = 0.25,
		allow_shots_with_less_than_required_ammo = true,
		allowed_during_sprint = true,
		ammunition_usage = 3,
		use_charge = true,
		charge_template = "lasgun_p2_m1_charge_up",
		abort_sprint = true,
		total_time = 0.5,
		action_movement_curve = {
			{
				modifier = 0.9,
				t = 0.05
			},
			{
				modifier = 1.05,
				t = 0.15
			},
			{
				modifier = 0.975,
				t = 0.175
			},
			{
				modifier = 0.9,
				t = 0.2
			},
			{
				modifier = 0.65,
				t = 0.3
			},
			{
				modifier = 1,
				t = 0.5
			},
			start_modifier = 0.95
		},
		fx = {
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_muzzle",
			shoot_sfx_alias = "ranged_single_shot",
			spread_rotated_muzzle_flash = true,
			shoot_tail_sfx_alias = "ranged_shot_tail",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			muzzle_flash_crit_effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_muzzle_crit",
			line_effect = LineEffects.lasbeam_killshot
		},
		fire_configuration = {
			anim_event_3p = "attack_shoot",
			anim_event = "attack_charge_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.lasgun_p2_m1_beam,
			damage_type = damage_types.laser
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload"
			},
			shoot_hold = {
				action_name = "action_shoot_hip_start",
				chain_time = 0.275
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.15
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_shoot_zoomed_start = {
		start_input = "zoom_shoot",
		anim_end_event = "attack_finished",
		kind = "windup",
		crosshair_type = "none",
		allowed_during_sprint = true,
		anim_event = "attack_charge",
		total_time = math.huge,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload"
			},
			zoom_shoot_release = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.5
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.2
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_shoot_zoomed = {
		use_charge = true,
		ammunition_usage_max = 7,
		weapon_handling_template = "immediate_single_shot",
		sprint_ready_up_time = 0.5,
		charge_template = "lasgun_p2_m1_charge_up",
		allow_shots_with_less_than_required_ammo = true,
		crosshair_type = "ironsight",
		ammunition_usage = 3,
		kind = "shoot_hit_scan",
		total_time = 0.4,
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
				modifier = 0.5,
				t = 0.3
			},
			{
				modifier = 0.7,
				t = 1
			},
			start_modifier = 0.6
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_muzzle",
			shoot_sfx_alias = "ranged_single_shot",
			spread_rotated_muzzle_flash = true,
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			line_effect = LineEffects.lasbeam_killshot
		},
		fire_configuration = {
			anim_event_3p = "attack_shoot",
			anim_event = "attack_charge_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.lasgun_p2_m1_beam,
			damage_type = damage_types.laser
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload"
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed_start",
				chain_time = 0.275
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.25
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_zoom = {
		crosshair_type = "ironsight",
		start_input = "zoom",
		kind = "aim",
		total_time = 0.3,
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_killshot,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			brace_reload = {
				action_name = "action_brace_reload"
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed_start",
				chain_time = 0.05
			}
		}
	},
	action_unzoom = {
		crosshair_type = "ironsight",
		start_input = "zoom_release",
		kind = "unaim",
		total_time = 0.2,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
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
	action_brace_reload = {
		kind = "reload_state",
		start_input = "brace_reload",
		sprint_requires_press_to_interrupt = true,
		weapon_handling_template = "increased_reload_speed",
		uninterruptible = true,
		abort_sprint = true,
		crosshair_type = "none",
		allowed_during_sprint = true,
		total_time = 3,
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
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			shoot_pressed = {
				action_name = "action_shoot_hip_start",
				chain_time = 3
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 3
			},
			zoom_release = {
				action_name = "action_unzoom"
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed
		}
	},
	action_reload = {
		kind = "reload_state",
		start_input = "reload",
		sprint_requires_press_to_interrupt = true,
		weapon_handling_template = "increased_reload_speed",
		stop_alternate_fire = true,
		abort_sprint = true,
		crosshair_type = "dot",
		allowed_during_sprint = true,
		total_time = 3,
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
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			shoot_pressed = {
				action_name = "action_shoot_hip_start",
				chain_time = 3
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 3
			},
			zoom_release = {
				action_name = "action_unzoom"
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed
		}
	},
	action_stab_start = {
		anim_event = "attack_charge_stab",
		start_input = "special_action_hold",
		allowed_during_sprint = true,
		kind = "windup",
		anim_end_event = "attack_finished",
		total_time = math.huge,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload"
			},
			special_action_light = {
				action_name = "action_stab",
				chain_time = 0
			},
			special_action_heavy = {
				action_name = "action_stab_heavy",
				chain_time = 0.5
			},
			shoot_pressed = {
				action_name = "action_shoot_hip_start",
				chain_time = 0.275
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.15
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_slash_start = {
		allowed_during_sprint = true,
		anim_event = "attack_charge_slash",
		anim_end_event = "attack_finished",
		kind = "windup",
		total_time = 0.75,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload"
			},
			special_action_light = {
				action_name = "action_slash",
				chain_time = 0.4
			},
			special_action_heavy = {
				action_name = "action_slash",
				chain_time = 0.4
			},
			shoot_pressed = {
				action_name = "action_shoot_hip_start",
				chain_time = 0.275
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.15
			}
		},
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "special_action_light"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_stab = {
		damage_window_start = 0.26666666666666666,
		hit_armor_anim = "attack_hit_shield",
		allow_conditional_chain = true,
		range_mod = 1.15,
		kind = "sweep",
		first_person_hit_anim = "attack_hit",
		first_person_hit_stop_anim = "attack_hit",
		allowed_during_sprint = true,
		damage_window_end = 0.4,
		uninterruptible = true,
		anim_event = "attack_stab",
		total_time = 1.1,
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
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload"
			},
			shoot_pressed = {
				action_name = "action_shoot_hip_start",
				chain_time = 0.275
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.15
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.8
			},
			special_action_hold = {
				action_name = "action_slash_start",
				chain_time = 0.4
			}
		},
		weapon_box = {
			0.08,
			1.2,
			0.08
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/lasgun_rifle_krieg/animations/attack_stab_01",
			anchor_point_offset = {
				0.1,
				0.8,
				0
			}
		},
		damage_type = damage_types.combat_blade,
		damage_profile = DamageProfileTemplates.bayonette_weapon_special
	},
	action_stab_heavy = {
		damage_window_start = 0.1,
		hit_armor_anim = "attack_hit_shield",
		allow_conditional_chain = true,
		range_mod = 1.15,
		kind = "sweep",
		first_person_hit_anim = "attack_hit",
		first_person_hit_stop_anim = "attack_hit",
		allowed_during_sprint = true,
		damage_window_end = 0.23333333333333334,
		uninterruptible = true,
		anim_event = "attack_stab_heavy",
		total_time = 1.1,
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
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload"
			},
			shoot_pressed = {
				action_name = "action_shoot_hip_start",
				chain_time = 0.275
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.15
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.8
			},
			special_action_hold = {
				action_name = "action_slash_start",
				chain_time = 0.4
			}
		},
		weapon_box = {
			0.08,
			1.2,
			0.08
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/lasgun_rifle_krieg/animations/attack_heavy_stab_01",
			anchor_point_offset = {
				0.1,
				0.8,
				0
			}
		},
		damage_type = damage_types.combat_blade,
		damage_profile = DamageProfileTemplates.bayonette_weapon_special
	},
	action_stab_zoom = {
		damage_window_start = 0.13333333333333333,
		hit_armor_anim = "attack_hit_shield",
		start_input = "zoom_weapon_special",
		range_mod = 1.15,
		kind = "sweep",
		first_person_hit_anim = "attack_hit",
		anim_event = "attack_stab",
		first_person_hit_stop_anim = "attack_hit",
		allowed_during_sprint = true,
		damage_window_end = 0.23333333333333334,
		uninterruptible = true,
		allow_conditional_chain = true,
		total_time = 1.1,
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
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload"
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed_start",
				chain_time = 0.275
			}
		},
		weapon_box = {
			0.08,
			1.2,
			0.08
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/lasgun_rifle_krieg/animations/ironsight_attack_stab_01",
			anchor_point_offset = {
				0.1,
				0.8,
				0
			}
		},
		damage_type = damage_types.combat_blade,
		damage_profile = DamageProfileTemplates.rippergun_weapon_special
	},
	action_slash = {
		damage_window_start = 0.1,
		hit_armor_anim = "attack_hit_shield",
		allow_conditional_chain = true,
		range_mod = 1.15,
		kind = "sweep",
		first_person_hit_anim = "attack_hit",
		first_person_hit_stop_anim = "attack_hit",
		allowed_during_sprint = true,
		damage_window_end = 0.23333333333333334,
		uninterruptible = true,
		anim_event = "attack_slash",
		total_time = 1.1,
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
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload"
			},
			shoot_pressed = {
				action_name = "action_shoot_hip_start",
				chain_time = 0.275
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.15
			}
		},
		weapon_box = {
			0.08,
			1.2,
			0.08
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/lasgun_rifle_krieg/animations/attack_slash_01",
			anchor_point_offset = {
				0.1,
				0.8,
				0
			}
		},
		damage_type = damage_types.combat_blade,
		damage_profile = DamageProfileTemplates.rippergun_weapon_special
	},
	action_inspect = {
		skip_3p_anims = false,
		lock_view = true,
		start_input = "inspect_start",
		anim_end_event = "inspect_end",
		kind = "inspect",
		crosshair_type = "none",
		anim_event = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge
	}
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.entry_actions = {
	primary_action = "action_shoot_hip_start",
	secondary_action = "action_zoom"
}
weapon_template.allow_sprinting_with_special = true
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/lasgun_rifle_krieg"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/lasgun_rifle_krieg"
weapon_template.reload_template = ReloadTemplates.lasgun
weapon_template.spread_template = "hip_lasgun_killshot_p2_m1"
weapon_template.recoil_template = "hip_lasgun_killshot"
weapon_template.suppression_template = "hip_lasgun_killshot"
weapon_template.look_delta_template = "lasgun_rifle"
weapon_template.ammo_template = "lasgun_p2_m1"
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_ammo_and_started_reload_no_alternate_fire",
		input_name = "reload"
	},
	{
		conditional_state = "no_ammo_no_alternate_fire",
		input_name = "reload"
	}
}
weapon_template.uses_ammunition = true
weapon_template.uses_overheat = false
weapon_template.keep_weapon_special_active_on_unwield = true
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {
	_muzzle = "fx_muzzle_01",
	_mag_well = "fx_reload"
}
weapon_template.crosshair_type = "charge_up"
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	crosshair_type = "ironsight",
	sway_template = "lasgun_p1_m1_killshot",
	recoil_template = "lasgun_p1_m1_ads_killshot",
	stop_anim_event = "to_unaim_ironsight",
	spread_template = "ads_lasgun_killshot_p2_m1",
	suppression_template = "default_lasgun_killshot",
	toughness_template = "killshot_zoomed",
	start_anim_event = "to_ironsight",
	look_delta_template = "lasgun_holo_aiming",
	movement_speed_modifier = {
		{
			modifier = 0.475,
			t = 0.45
		},
		{
			modifier = 0.45,
			t = 0.47500000000000003
		},
		{
			modifier = 0.39,
			t = 0.65
		},
		{
			modifier = 0.4,
			t = 0.7
		},
		{
			modifier = 0.55,
			t = 0.8
		},
		{
			modifier = 0.6,
			t = 0.9
		},
		{
			modifier = 0.7,
			t = 2
		}
	}
}
weapon_template.keywords = {
	"ranged",
	"lasgun",
	"p1"
}
weapon_template.can_use_while_vaulting = true
weapon_template.dodge_template = "killshot"
weapon_template.sprint_template = "killshot"
weapon_template.stamina_template = "lasrifle"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "lasgun_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.killshot
weapon_template.base_stats = {
	lasgun_p1_m1_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_dps_stat
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_dps_stat
			}
		}
	},
	lasgun_p1_m1_ammo_stat = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_stat
			}
		}
	},
	lasgun_p1_m1_stability_stat = {
		display_name = "loc_stats_display_stability_stat",
		is_stat_trait = true,
		recoil = {
			base = {
				recoil_trait_templates.lasgun_p1_m1_recoil_stat
			},
			alternate_fire = {
				recoil_trait_templates.lasgun_p1_m1_recoil_stat
			}
		},
		spread = {
			base = {
				spread_trait_templates.default_spread_stat
			}
		},
		sway = {
			alternate_fire = {
				sway_trait_templates.default_sway_stat
			}
		}
	},
	lasgun_p1_m1_mobility_stat = {
		display_name = "loc_stats_display_mobility_stat",
		is_stat_trait = true,
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat
			}
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_stat
			}
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_stat
			}
		},
		spread = {
			base = {
				spread_trait_templates.mobility_spread_stat
			}
		}
	},
	lasgun_p1_m1_power_stat = {
		description = "loc_trait_description_lasgun_p1_m1_power_stat",
		display_name = "loc_stats_display_power_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_power_stat
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_power_stat
			}
		}
	}
}
weapon_template.traits = {}
local ranged_common_traits = table.keys(WeaponTraitsRangedCommon)

table.append(weapon_template.traits, ranged_common_traits)

local ranged_medium_fire_rate_traits = table.keys(WeaponTraitsRangedMediumFireRate)

table.append(weapon_template.traits, ranged_medium_fire_rate_traits)

local ranged_aimed_traits = table.keys(WeaponTraitsRangedAimed)

table.append(weapon_template.traits, ranged_aimed_traits)

weapon_template.perks = {
	lasgun_p1_m1_stability_perk = {
		description = "loc_trait_description_lasgun_p1_m1_stability_perk",
		display_name = "loc_trait_display_lasgun_p1_m1_stability_perk",
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
	lasgun_p1_m1_ammo_perk = {
		description = "loc_trait_description_lasgun_p1_m1_ammo_perk",
		display_name = "loc_trait_display_lasgun_p1_m1_ammo_perk",
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_perk
			}
		}
	},
	lasgun_p1_m1_dps_perk = {
		description = "loc_trait_description_lasgun_p1_m1_dps_perk",
		display_name = "loc_trait_display_lasgun_p1_m1_dps_perk",
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_dps_perk
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_dps_perk
			}
		}
	},
	lasgun_p1_m1_power_perk = {
		description = "loc_trait_description_lasgun_p1_m1_power_perk",
		display_name = "loc_trait_display_lasgun_p1_m1_power_perk",
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_power_perk
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_power_perk
			}
		}
	},
	lasgun_p1_m1_mobility_perk = {
		description = "loc_trait_description_lasgun_p1_m1_mobility_perk",
		display_name = "loc_trait_display_lasgun_p1_m1_mobility_perk",
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
		display_name = "loc_weapon_keyword_accurate"
	},
	{
		display_name = "loc_weapon_keyword_charged_attack"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		fire_mode = "semi_auto",
		display_name = "loc_ranged_attack_primary",
		type = "hipfire"
	},
	secondary = {
		fire_mode = "semi_auto",
		display_name = "loc_ranged_attack_secondary_ads",
		type = "ads"
	},
	special = {
		display_name = "loc_weapon_special_bayonet",
		type = "melee"
	}
}
weapon_template.displayed_attack_ranges = {
	max = 100,
	min = 7
}

return weapon_template
