local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FlashlightTemplates = require("scripts/settings/equipment/flashlight_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeLasgunP3 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_lasgun_p3")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local recoil_trait_templates = WeaponTraitTemplates[template_types.recoil]
local spread_trait_templates = WeaponTraitTemplates[template_types.spread]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local ammo_trait_templates = WeaponTraitTemplates[template_types.ammo]
local sway_trait_templates = WeaponTraitTemplates[template_types.sway]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local weapon_template = {
	action_inputs = {
		shoot = {
			buffer_time = 0.25,
			input_sequence = {
				{
					value = true,
					input = "action_one_hold"
				}
			}
		},
		shoot_release = {
			buffer_time = 0.3,
			input_sequence = {
				{
					value = false,
					input = "action_one_hold",
					time_window = math.huge
				}
			}
		},
		zoom_shoot = {
			buffer_time = 0.3,
			input_sequence = {
				{
					value = true,
					hold_input = "action_two_hold",
					input = "action_one_hold"
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
			buffer_time = 0.2,
			input_sequence = {
				{
					inputs = wield_inputs
				}
			}
		},
		weapon_special = {
			buffer_time = 0.4,
			input_sequence = {
				{
					value = true,
					input = "weapon_extra_pressed"
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
	reload = "stay",
	weapon_special = "stay",
	shoot = {
		zoom = "base",
		wield = "base",
		grenade_ability = "base",
		reload = "base",
		combat_ability = "base",
		shoot_release = "base"
	},
	zoom = {
		zoom_release = "base",
		wield = "base",
		grenade_ability = "base",
		reload = "base",
		combat_ability = "base",
		zoom_weapon_special = "stay",
		zoom_shoot = {
			grenade_ability = "base",
			wield = "base",
			zoom_release = "base",
			reload = "base",
			combat_ability = "base",
			shoot_release = "previous"
		}
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
		total_time = 1,
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
				chain_time = 0.5
			},
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 0.65
			}
		}
	},
	action_shoot_hip = {
		sprint_requires_press_to_interrupt = true,
		weapon_handling_template = "lasgun_p3_m2_full_auto",
		start_input = "shoot",
		minimum_hold_time = 0.15,
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0,
		allow_shots_with_less_than_required_ammo = true,
		allowed_during_sprint = true,
		ammunition_usage = 1,
		abort_sprint = true,
		uninterruptible = true,
		stop_input = "shoot_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05
			},
			{
				modifier = 0.6,
				t = 0.15
			},
			{
				modifier = 0.5,
				t = 0.175
			},
			{
				modifier = 0.3,
				t = 0.2
			},
			{
				modifier = 0.7,
				t = 0.3
			},
			{
				modifier = 0.6,
				t = 0.5
			},
			{
				modifier = 0.35,
				t = 0.9
			},
			start_modifier = 0.9
		},
		fx = {
			pre_loop_shoot_sfx_alias = "ranged_pre_loop_shot",
			crit_shoot_sfx_alias = "critical_shot_extra",
			looping_shoot_sfx_alias = "ranged_shooting",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_muzzle_elysian",
			num_pre_loop_events = 1,
			spread_rotated_muzzle_flash = true,
			auto_fire_time_parameter_name = "wpn_fire_interval",
			post_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			pre_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			line_effect = LineEffects.lasbeam_elysian
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.lasgun_spraynpray_p3_m2,
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
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.1
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_shoot_zoomed = {
		start_input = "zoom_shoot",
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0,
		weapon_handling_template = "lasgun_p3_m2_full_auto",
		allow_shots_with_less_than_required_ammo = true,
		crosshair_type = "ironsight",
		ammunition_usage = 1,
		stop_input = "shoot_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.65,
				t = 0.05
			},
			{
				modifier = 0.7,
				t = 0.15
			},
			{
				modifier = 0.75,
				t = 0.175
			},
			{
				modifier = 0.8,
				t = 0.3
			},
			{
				modifier = 0.85,
				t = 1
			},
			start_modifier = 0.75
		},
		fx = {
			pre_loop_shoot_sfx_alias = "ranged_pre_loop_shot",
			crit_shoot_sfx_alias = "critical_shot_extra",
			looping_shoot_sfx_alias = "ranged_shooting",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_muzzle",
			num_pre_loop_events = 1,
			spread_rotated_muzzle_flash = true,
			auto_fire_time_parameter_name = "wpn_fire_interval",
			post_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			pre_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			line_effect = LineEffects.lasbeam_elysian
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.lasgun_spraynpray_p3_m2,
			damage_type = damage_types.laser
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.25
			},
			zoom_release = {
				action_name = "action_unzoom"
			},
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload"
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_zoom = {
		crosshair_type = "none",
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
			reload = {
				action_name = "action_reload"
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.25
			}
		}
	},
	action_unzoom = {
		crosshair_type = "none",
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
			}
		}
	},
	action_reload = {
		kind = "reload_state",
		start_input = "reload",
		sprint_requires_press_to_interrupt = true,
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
	action_toggle_flashlight = {
		kind = "toogle_special",
		anim_event = "toggle_flashlight",
		start_input = "weapon_special",
		activation_time = 0,
		skip_3p_anims = true,
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
			reload = {
				action_name = "action_reload"
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed"
			}
		}
	},
	action_toggle_flashlight_zoom = {
		kind = "toogle_special",
		crosshair_type = "none",
		start_input = "zoom_weapon_special",
		activation_time = 0,
		anim_event = "toggle_flashlight",
		skip_3p_anims = true,
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
			reload = {
				action_name = "action_reload"
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed"
			}
		}
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
	primary_action = "action_shoot_hip",
	secondary_action = "action_zoom"
}
weapon_template.allow_sprinting_with_special = true
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/lasgun_rifle_elysian"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/lasgun_rifle_elysian"
weapon_template.reload_template = ReloadTemplates.lasgun_elysian
weapon_template.spread_template = "hip_lasgun_p3_m1"
weapon_template.recoil_template = "hip_lasgun_p3_m1_recoil"
weapon_template.suppression_template = "default_autogun_assault"
weapon_template.look_delta_template = "lasgun_p3_rifle"
weapon_template.semi_auto_chain_factor = 2
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_ammo_and_started_reload",
		input_name = "reload"
	},
	{
		conditional_state = "no_ammo_with_delay",
		input_name = "reload"
	}
}
weapon_template.no_ammo_delay = 0.25
weapon_template.uses_ammunition = true
weapon_template.uses_overheat = false
weapon_template.keep_weapon_special_active_on_unwield = true
weapon_template.flashlight_template = FlashlightTemplates.default
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.ammo_template = "lasgun_p3_m1"
weapon_template.fx_sources = {
	_muzzle = "fx_muzzle_01",
	_mag_well = "fx_reload"
}
weapon_template.crosshair_type = "assault"
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	crosshair_type = "ironsight",
	sway_template = "lasgun_p3_m1_sway",
	recoil_template = "lasgun_p3_m1_ads_killshot",
	stop_anim_event = "to_unaim_ironsight",
	spread_template = "default_lasgun_killshot",
	suppression_template = "default_lasgun_killshot",
	toughness_template = "killshot_zoomed",
	start_anim_event = "to_ironsight",
	look_delta_template = "lasgun_holo_aiming",
	camera = {
		custom_vertical_fov = 30,
		vertical_fov = 55,
		near_range = 0.025
	},
	movement_speed_modifier = {
		{
			modifier = 0.775,
			t = 0.45
		},
		{
			modifier = 0.75,
			t = 0.47500000000000003
		},
		{
			modifier = 0.69,
			t = 0.65
		},
		{
			modifier = 0.7,
			t = 0.7
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
			modifier = 0.8,
			t = 2
		}
	}
}
weapon_template.keywords = {
	"ranged",
	"lasgun",
	"p3"
}
weapon_template.can_use_while_vaulting = true
weapon_template.dodge_template = "assault"
weapon_template.sprint_template = "assault"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "assault"
weapon_template.movement_curve_modifier_template = "lasgun_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.assault
weapon_template.base_stats = {
	lasgun_p3_m2_dps_stat = {
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
	lasgun_p3_m2_ammo_stat = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_stat
			}
		}
	},
	lasgun_p3_m2_stability_stat = {
		display_name = "loc_stats_display_stability_stat",
		is_stat_trait = true,
		recoil = {
			base = {
				recoil_trait_templates.default_recoil_stat
			},
			alternate_fire = {
				recoil_trait_templates.default_recoil_stat
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
	lasgun_p3_m2_mobility_stat = {
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
	lasgun_p3_m2_control_stat = {
		display_name = "loc_stats_display_control_stat_ranged",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.shotgun_control_stat
			},
			action_shoot_zoomed = {
				damage_trait_templates.shotgun_control_stat
			}
		}
	}
}
weapon_template.traits = {}
local bespoke_lasgun_p3_traits = table.keys(WeaponTraitsBespokeLasgunP3)

table.append(weapon_template.traits, bespoke_lasgun_p3_traits)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_spray_n_pray"
	},
	{
		display_name = "loc_weapon_keyword_high_ammo_count"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		fire_mode = "full_auto",
		display_name = "loc_ranged_attack_primary",
		type = "hipfire"
	},
	secondary = {
		fire_mode = "full_auto",
		display_name = "loc_ranged_attack_secondary_ads",
		type = "ads"
	},
	special = {
		display_name = "loc_weapon_special_flashlight",
		type = "flashlight"
	}
}

return weapon_template
