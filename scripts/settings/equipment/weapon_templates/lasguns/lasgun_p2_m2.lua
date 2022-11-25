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
local WeaponTraitsBespokeLasgunP2 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_lasgun_p2")
local WeaponTraitsRangedAimed = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_aimed")
local WeaponTraitsRangedCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_common")
local WeaponTraitsRangedMediumFireRate = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_medium_fire_rate")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_types = DamageSettings.damage_types
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local wounds_shapes = WoundsSettings.shapes
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
local charge_trait_templates = WeaponTraitTemplates[template_types.charge]
local weapon_template = {
	action_inputs = {
		shoot_pressed = {
			buffer_time = 0.53,
			max_queue = 1,
			input_sequence = {
				{
					value = true,
					input = "action_one_pressed"
				}
			}
		},
		shoot_release_charged = {
			buffer_time = 0.52,
			clear_input_queue = true,
			input_sequence = {
				{
					value = false,
					input = "action_one_hold",
					time_window = math.huge
				}
			}
		},
		zoom_shoot_hold = {
			buffer_time = 0.52,
			max_queue = 2,
			input_sequence = {
				{
					value = true,
					hold_input = "action_two_hold",
					input = "action_one_hold"
				}
			}
		},
		zoom_shoot_pressed = {
			buffer_time = 0.52,
			max_queue = 2,
			input_sequence = {
				{
					value = true,
					hold_input = "action_two_hold",
					input = "action_one_pressed"
				}
			}
		},
		zoom_shoot_release_charged = {
			buffer_time = 0.52,
			clear_input_queue = true,
			input_sequence = {
				{
					value = false,
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
		zoom = "base",
		wield = "base",
		grenade_ability = "base",
		special_action_hold = "base",
		reload = "base",
		combat_ability = "stay",
		shoot_release_charged = "base"
	},
	zoom = {
		wield = "base",
		zoom_release = "base",
		grenade_ability = "base",
		reload = "previous",
		combat_ability = "base",
		zoom_weapon_special = "stay",
		zoom_shoot_hold = {
			wield = "base",
			grenade_ability = "base",
			zoom_release = "base",
			zoom_shoot_release_charged = "previous",
			reload = "base",
			combat_ability = "stay",
			zoom_weapon_special = "stay"
		},
		zoom_shoot_pressed = {
			wield = "base",
			grenade_ability = "base",
			zoom_release = "base",
			zoom_shoot_release_charged = "previous",
			reload = "base",
			combat_ability = "stay",
			zoom_weapon_special = "stay"
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

local action_movement_curve_mark_modifier = 1
local RESET_CHARGE_ACTION_KINDS = {
	charge_ammo = true,
	unwield = true,
	windup = true,
	reload_state = true,
	unaim = true,
	sweep = true
}
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
				chain_time = 1.5,
				reset_combo = true,
				action_name = "action_shoot_hip_start"
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 1
			}
		}
	},
	action_shoot_hip_start = {
		anim_end_event = "attack_finished",
		start_input = "shoot_pressed",
		hold_combo = true,
		kind = "charge_ammo",
		charge_extra_hold_time = 0.3,
		allowed_during_sprint = false,
		charge_template = "lasgun_p2_m2_charge_up",
		spread_template = "hip_lasgun_killshot_p2_m1",
		abort_sprint = true,
		anim_event = "attack_charge",
		prevent_sprint = true,
		total_time = 1.2,
		action_movement_curve = {
			{
				t = 0.3,
				modifier = 0.7 * action_movement_curve_mark_modifier
			},
			{
				t = 1,
				modifier = 0.55 * action_movement_curve_mark_modifier
			},
			start_modifier = 0.8 * action_movement_curve_mark_modifier
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
				reset_combo = true
			},
			shoot_release_charged = {
				action_name = "action_shoot_hip_charged"
			},
			zoom = {
				chain_time = 0.15,
				reset_combo = true,
				action_name = "action_zoom"
			},
			special_action_hold = {
				action_name = "action_stab_start"
			}
		},
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "shoot_release_charged"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		reset_charge_action_kinds = RESET_CHARGE_ACTION_KINDS
	},
	action_shoot_hip_charged = {
		ammunition_usage_min = 2,
		ammunition_usage_max = 6,
		sprint_requires_press_to_interrupt = true,
		kind = "shoot_hit_scan",
		weapon_handling_template = "immediate_single_shot",
		sprint_ready_up_time = 0.25,
		allow_shots_with_less_than_required_ammo = true,
		allowed_during_sprint = true,
		ammunition_usage = 2,
		use_charge = true,
		abort_sprint = true,
		total_time = 1.5,
		action_movement_curve = {
			{
				t = 0.05,
				modifier = 0.4 * action_movement_curve_mark_modifier
			},
			{
				t = 0.15,
				modifier = 0.25 * action_movement_curve_mark_modifier
			},
			{
				t = 0.175,
				modifier = 0.275 * action_movement_curve_mark_modifier
			},
			{
				t = 0.2,
				modifier = 0.4 * action_movement_curve_mark_modifier
			},
			{
				t = 0.5,
				modifier = 1 * action_movement_curve_mark_modifier
			},
			{
				modifier = 1,
				t = 1.4
			},
			start_modifier = 0.5 * action_movement_curve_mark_modifier
		},
		fx = {
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_sfx_alias = "ranged_single_shot",
			spread_rotated_muzzle_flash = true,
			is_charge_dependant = true,
			shoot_tail_sfx_alias = "ranged_shot_tail",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			muzzle_flash_effect = {
				{
					charge_level = 0,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_muzzle"
				},
				{
					charge_level = 0.2,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_charged_muzzle"
				},
				{
					charge_level = 0.9,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_bfg_muzzle"
				}
			},
			muzzle_flash_crit_effect = {
				{
					charge_level = 0,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_muzzle_crit"
				},
				{
					charge_level = 0.2,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_charged_muzzle_crit"
				},
				{
					charge_level = 0.9,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_bfg_muzzle_crit"
				}
			},
			line_effect = {
				{
					charge_level = 0,
					line_effect = LineEffects.lasbeam_killshot
				},
				{
					charge_level = 0.2,
					line_effect = LineEffects.lasbeam_charged
				},
				{
					charge_level = 0.9,
					line_effect = LineEffects.lasbeam_bfg
				}
			}
		},
		fire_configuration = {
			use_charge = true,
			anim_event_3p = "attack_shoot",
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.lasgun_p2_m2_beam_charged,
			damage_type = {
				{
					charge_level = 0,
					damage_type = damage_types.laser
				},
				{
					charge_level = 0.2,
					damage_type = damage_types.laser_charged
				},
				{
					charge_level = 0.9,
					damage_type = damage_types.laser_bfg
				}
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
				action_name = "action_reload"
			},
			shoot_pressed = {
				action_name = "action_shoot_hip_start",
				chain_time = 0.3
			},
			zoom = {
				chain_time = 0.3,
				reset_combo = true,
				action_name = "action_zoom"
			},
			special_action_hold = {
				chain_time = 0.3,
				reset_combo = true,
				action_name = "action_stab_start"
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_shoot_zoomed_start = {
		sway_template = "lasgun_p2_m2_killshot",
		hold_combo = true,
		start_input = "zoom_shoot_pressed",
		kind = "charge_ammo",
		anim_end_event = "attack_finished",
		charge_extra_hold_time = 1,
		keep_charge = true,
		recoil_template = "lasgun_p2_m1_ads_killshot",
		crosshair_type = "charge_up_ads",
		allowed_during_sprint = true,
		charge_template = "lasgun_p2_m2_charge_up",
		spread_template = "default_lasgun_killshot",
		anim_event = "attack_charge",
		total_time = 1.2,
		fully_charged = {
			input_name = "zoom_shoot_release_charged"
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
			zoom_shoot_release_charged = {
				action_name = "action_zoom_shoot_charged"
			},
			zoom_release = {
				chain_time = 0.2,
				reset_combo = true,
				action_name = "action_unzoom"
			},
			special_action_hold = {
				action_name = "action_stab_start"
			}
		},
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "zoom_shoot_release_charged"
			}
		},
		running_action_state_to_action_input = {
			fully_charged = {
				input_name = "zoom_shoot_release_charged"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		reset_charge_action_kinds = RESET_CHARGE_ACTION_KINDS
	},
	action_zoom_shoot_charged = {
		use_charge = true,
		ammunition_usage_max = 6,
		weapon_handling_template = "immediate_single_shot",
		sprint_ready_up_time = 0.5,
		kind = "shoot_hit_scan",
		allow_shots_with_less_than_required_ammo = true,
		crosshair_type = "charge_up_ads",
		charge_template = "lasgun_p2_m2_charge_up",
		ammunition_usage = 2,
		ammunition_usage_min = 2,
		total_time = 1.5,
		action_movement_curve = {
			{
				t = 0.05,
				modifier = 0.6 * action_movement_curve_mark_modifier
			},
			{
				t = 0.15,
				modifier = 0.65 * action_movement_curve_mark_modifier
			},
			{
				t = 0.175,
				modifier = 0.575 * action_movement_curve_mark_modifier
			},
			{
				t = 0.3,
				modifier = 0.8 * action_movement_curve_mark_modifier
			},
			{
				t = 0.7,
				modifier = 0.9 * action_movement_curve_mark_modifier
			},
			start_modifier = 0.25 * action_movement_curve_mark_modifier
		},
		fx = {
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_sfx_alias = "ranged_single_shot",
			spread_rotated_muzzle_flash = true,
			is_charge_dependant = true,
			shoot_tail_sfx_alias = "ranged_shot_tail",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			muzzle_flash_effect = {
				{
					charge_level = 0,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_muzzle"
				},
				{
					charge_level = 0.2,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_charged_muzzle"
				},
				{
					charge_level = 0.9,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_bfg_muzzle"
				}
			},
			muzzle_flash_crit_effect = {
				{
					charge_level = 0,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_muzzle_crit"
				},
				{
					charge_level = 0.2,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_charged_muzzle_crit"
				},
				{
					charge_level = 0.9,
					effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_bfg_muzzle_crit"
				}
			},
			line_effect = {
				{
					charge_level = 0,
					line_effect = LineEffects.lasbeam_killshot
				},
				{
					charge_level = 0.2,
					line_effect = LineEffects.lasbeam_charged
				},
				{
					charge_level = 0.9,
					line_effect = LineEffects.lasbeam_bfg
				}
			}
		},
		fire_configuration = {
			use_charge = true,
			anim_event_3p = "attack_shoot",
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.lasgun_p2_m2_beam_charged,
			damage_type = {
				{
					charge_level = 0,
					damage_type = damage_types.laser
				},
				{
					charge_level = 0.2,
					damage_type = damage_types.laser_charged
				},
				{
					charge_level = 0.9,
					damage_type = damage_types.laser_bfg
				}
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
				action_name = "action_reload"
			},
			zoom_shoot_pressed = {
				action_name = "action_shoot_zoomed_start",
				chain_time = 0.3
			},
			zoom_release = {
				chain_time = 0.25,
				reset_combo = true,
				action_name = "action_unzoom"
			},
			special_action_hold = {
				chain_time = 0.3,
				reset_combo = true,
				action_name = "action_stab_start"
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_zoom = {
		hold_combo = false,
		crosshair_type = "charge_up_ads",
		start_input = "zoom",
		kind = "aim",
		increase_combo = false,
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
			reload = {
				action_name = "action_reload"
			},
			zoom_shoot_hold = {
				action_name = "action_shoot_zoomed_start",
				chain_time = 0.05
			}
		}
	},
	action_unzoom = {
		hold_combo = false,
		crosshair_type = "charge_up_ads",
		start_input = "zoom_release",
		kind = "unaim",
		increase_combo = false,
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
	action_reload = {
		kind = "reload_state",
		start_input = "reload",
		sprint_requires_press_to_interrupt = true,
		weapon_handling_template = "increased_reload_speed",
		stop_alternate_fire = true,
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
				chain_time = 3,
				reset_combo = true,
				action_name = "action_shoot_hip_start"
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 3
			},
			zoom_release = {
				action_name = "action_unzoom"
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.75
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed
		}
	},
	action_stab_start = {
		start_input = "special_action_hold",
		anim_end_event = "attack_finished",
		kind = "windup",
		allowed_during_sprint = true,
		anim_event = "attack_charge_stab",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 1.1,
				t = 0.1
			},
			{
				modifier = 1.2,
				t = 0.25
			},
			{
				modifier = 1,
				t = 1
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
				chain_time = 0.275,
				reset_combo = true,
				action_name = "action_shoot_hip_start"
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
	action_stab = {
		damage_window_start = 0.3,
		hit_armor_anim = "attack_hit_shield",
		allow_conditional_chain = true,
		range_mod = 1.15,
		kind = "sweep",
		first_person_hit_anim = "attack_hit",
		first_person_hit_stop_anim = "attack_hit",
		allowed_during_sprint = true,
		damage_window_end = 0.36666666666666664,
		uninterruptible = true,
		anim_event = "attack_stab",
		total_time = 1.1,
		action_movement_curve = {
			{
				t = 0.1,
				modifier = 1.3 * action_movement_curve_mark_modifier
			},
			{
				t = 0.25,
				modifier = 0.3 * action_movement_curve_mark_modifier
			},
			{
				t = 0.3,
				modifier = 0.5 * action_movement_curve_mark_modifier
			},
			{
				t = 0.35,
				modifier = 1.5 * action_movement_curve_mark_modifier
			},
			{
				t = 0.4,
				modifier = 1.5 * action_movement_curve_mark_modifier
			},
			{
				t = 0.6,
				modifier = 1.05 * action_movement_curve_mark_modifier
			},
			{
				t = 1,
				modifier = 0.75 * action_movement_curve_mark_modifier
			},
			start_modifier = 1.1 * action_movement_curve_mark_modifier
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
				chain_time = 0.575
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.575
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.575
			}
		},
		weapon_box = {
			0.08,
			1.3,
			0.08
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/lasgun_rifle_krieg/animations/attack_stab_01",
			anchor_point_offset = {
				0.1,
				1.2,
				-0.15
			}
		},
		damage_type = damage_types.knife,
		damage_profile = DamageProfileTemplates.bayonette_weapon_special_stab
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
				t = 0.1,
				modifier = 1.3 * action_movement_curve_mark_modifier
			},
			{
				t = 0.25,
				modifier = 0.3 * action_movement_curve_mark_modifier
			},
			{
				t = 0.3,
				modifier = 0.5 * action_movement_curve_mark_modifier
			},
			{
				t = 0.35,
				modifier = 1.5 * action_movement_curve_mark_modifier
			},
			{
				t = 0.4,
				modifier = 1.5 * action_movement_curve_mark_modifier
			},
			{
				t = 0.6,
				modifier = 1.05 * action_movement_curve_mark_modifier
			},
			{
				t = 1,
				modifier = 0.75 * action_movement_curve_mark_modifier
			},
			start_modifier = 1.1 * action_movement_curve_mark_modifier
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
				chain_time = 0.575,
				reset_combo = true,
				action_name = "action_shoot_hip_start"
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.575
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.575
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
		damage_type = damage_types.knife,
		damage_profile = DamageProfileTemplates.bayonette_weapon_special_stab,
		wounds_shape = wounds_shapes.default
	},
	action_stab_zoom = {
		damage_window_start = 0.13333333333333333,
		hit_armor_anim = "attack_hit_shield",
		start_input = "zoom_weapon_special",
		allow_conditional_chain = true,
		kind = "sweep",
		first_person_hit_anim = "attack_hit",
		range_mod = 1.6,
		first_person_hit_stop_anim = "attack_hit",
		crosshair_type = "charge_up_ads",
		allowed_during_sprint = true,
		damage_window_end = 0.23333333333333334,
		uninterruptible = true,
		anim_event = "attack_stab",
		total_time = 1.1,
		action_movement_curve = {
			{
				t = 0.1,
				modifier = 1.3 * action_movement_curve_mark_modifier
			},
			{
				t = 0.25,
				modifier = 0.3 * action_movement_curve_mark_modifier
			},
			{
				t = 0.3,
				modifier = 0.5 * action_movement_curve_mark_modifier
			},
			{
				t = 0.35,
				modifier = 1.5 * action_movement_curve_mark_modifier
			},
			{
				t = 0.4,
				modifier = 1.5 * action_movement_curve_mark_modifier
			},
			{
				t = 0.6,
				modifier = 1.05 * action_movement_curve_mark_modifier
			},
			{
				t = 1,
				modifier = 0.75 * action_movement_curve_mark_modifier
			},
			start_modifier = 1.1 * action_movement_curve_mark_modifier
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
			zoom_shoot_hold = {
				chain_time = 0.575,
				reset_combo = true,
				action_name = "action_shoot_zoomed_start"
			},
			zoom_weapon_special = {
				action_name = "action_stab_zoom",
				chain_time = 0.575
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
				0,
				0.8,
				0
			}
		},
		damage_type = damage_types.knife,
		damage_profile = DamageProfileTemplates.bayonette_weapon_special_stab,
		wounds_shape = wounds_shapes.default
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
	primary_action = "action_shoot_hip_charged",
	secondary_action = "action_zoom"
}
weapon_template.allow_sprinting_with_special = true
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/lasgun_rifle_krieg"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/lasgun_rifle_krieg"
weapon_template.reload_template = ReloadTemplates.lasgun
weapon_template.spread_template = "hip_lasgun_killshot_p2_m1"
weapon_template.recoil_template = "hip_lasgun_p2_killshot"
weapon_template.suppression_template = "hip_lasgun_killshot"
weapon_template.look_delta_template = "lasgun_rifle"
weapon_template.ammo_template = "lasgun_p2_m2"
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_ammo_and_started_reload_no_alternate_fire",
		input_name = "reload"
	},
	{
		conditional_state = "no_ammo_no_alternate_fire_with_delay",
		input_name = "reload"
	},
	{
		conditional_state = "no_ammo_and_started_reload_alternate_fire",
		input_name = "reload"
	},
	{
		conditional_state = "no_ammo_alternate_fire_with_delay",
		input_name = "reload"
	}
}
weapon_template.no_ammo_delay = 0.5
weapon_template.uses_ammunition = true
weapon_template.uses_overheat = false
weapon_template.keep_weapon_special_active_on_unwield = true
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {
	_muzzle = "fx_muzzle_01",
	_mag_well = "fx_reload"
}
weapon_template.crosshair_type = "bfg"
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	crosshair_type = "charge_up_ads",
	sway_template = "lasgun_p2_m2_killshot",
	recoil_template = "lasgun_p2_m1_ads_killshot",
	stop_anim_event = "to_unaim_ironsight",
	spread_template = "default_lasgun_killshot",
	suppression_template = "default_lasgun_killshot",
	toughness_template = "killshot_zoomed",
	start_anim_event = "to_ironsight",
	look_delta_template = "lasgun_holo_aiming",
	camera = {
		custom_vertical_fov = 45,
		vertical_fov = 45,
		near_range = 0.025
	},
	movement_speed_modifier = {
		{
			modifier = 0.575,
			t = 0.45
		},
		{
			modifier = 0.55,
			t = 0.47500000000000003
		},
		{
			modifier = 0.49,
			t = 0.65
		},
		{
			modifier = 0.5,
			t = 0.7
		},
		{
			modifier = 0.65,
			t = 0.8
		},
		{
			modifier = 0.7,
			t = 0.9
		},
		{
			modifier = 0.7999999999999999,
			t = 2
		}
	}
}
weapon_template.charge_effects = {
	sfx_parameter = "charge_level",
	looping_effect_alias = "ranged_charging",
	looping_sound_alias = "ranged_charging",
	vfx_source_name = "_muzzle",
	sfx_source_name = "_muzzle",
	charge_done_source_name = "_muzzle",
	charge_done_effect_alias = "ranged_charging_done"
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
	lasgun_p2_m2_dps_stat = {
		description = "loc_trait_description_lasgun_p2_m1_damage_stat",
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip_charged = {
				damage_trait_templates.default_dps_stat
			},
			action_zoom_shoot_charged = {
				damage_trait_templates.default_dps_stat
			},
			action_stab = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_stab_heavy = {
				damage_trait_templates.default_melee_dps_stat
			}
		}
	},
	lasgun_p2_m2_stability_stat = {
		description = "loc_trait_description_lasgun_p2_m2_stability_stat",
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
	lasgun_p2_m2_ammo_stat = {
		description = "loc_trait_description_lasgun_p2_m2_ammo_stat",
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_stat
			}
		}
	},
	lasgun_p2_m2_charge_speed_stat = {
		description = "loc_trait_description_lasgun_p2_m2_charge_speed_stat",
		display_name = "loc_stats_display_charge_speed",
		is_stat_trait = true,
		charge = {
			action_shoot_hip_start = {
				charge_trait_templates.plasmagun_charge_speed_stat
			},
			action_shoot_zoomed_start = {
				charge_trait_templates.plasmagun_charge_speed_stat
			}
		}
	},
	lasgun_p2_m2_power_stat = {
		description = "loc_trait_description_lasgun_p2_m2_power_stat",
		display_name = "loc_stats_display_power_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip_charged = {
				damage_trait_templates.default_power_stat
			},
			action_zoom_shoot_charged = {
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

local bespoke_lasgun_p2_traits = table.keys(WeaponTraitsBespokeLasgunP2)

table.append(weapon_template.traits, bespoke_lasgun_p2_traits)

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
		type = "charge"
	},
	secondary = {
		fire_mode = "semi_auto",
		display_name = "loc_ranged_attack_secondary_ads",
		type = "charge"
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
