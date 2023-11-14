local AimAssistTemplates = require("scripts/settings/equipment/aim_assist_templates")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
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
local WeaponTraitsBespokeAutogunP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_autogun_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local armor_types = ArmorSettings.types
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_types = DamageSettings.damage_types
local template_types = WeaponTweakTemplateSettings.template_types
local ammo_trait_templates = WeaponTraitTemplates[template_types.ammo]
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local recoil_trait_templates = WeaponTraitTemplates[template_types.recoil]
local spread_trait_templates = WeaponTraitTemplates[template_types.spread]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local sway_trait_templates = WeaponTraitTemplates[template_types.sway]
local toughness_trait_templates = WeaponTraitTemplates[template_types.toughness]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local wield_inputs = PlayerCharacterConstants.wield_inputs
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
			buffer_time = 0.26,
			input_sequence = {
				{
					value = false,
					input = "action_one_hold",
					time_window = math.huge
				}
			}
		},
		zoom_shoot = {
			buffer_time = 0.12,
			input_sequence = {
				{
					value = true,
					input = "action_one_hold"
				}
			}
		},
		zoom = {
			buffer_time = 0.25,
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
			buffer_time = 0.26,
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
		allowed_during_sprint = true,
		start_input = "wield",
		uninterruptible = true,
		kind = "unwield",
		total_time = 0,
		allowed_chain_actions = {}
	},
	action_wield = {
		wield_reload_anim_event = "equip_reload",
		allowed_during_sprint = true,
		wield_anim_event = "equip",
		uninterruptible = true,
		kind = "ranged_wield",
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
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
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
		kind = "shoot_hit_scan",
		weapon_handling_template = "autogun_full_auto_slow",
		start_input = "shoot",
		sprint_requires_press_to_interrupt = true,
		sprint_ready_up_time = 0.2,
		ammunition_usage = 1,
		uninterruptible = true,
		stop_input = "shoot_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 1.1,
				t = 0.25
			},
			{
				modifier = 1,
				t = 0.4
			},
			{
				modifier = 0.75,
				t = 1
			},
			start_modifier = 1.25
		},
		fx = {
			pre_loop_shoot_sfx_alias = "ranged_pre_loop_shot",
			crit_shoot_sfx_alias = "critical_shot_extra",
			looping_shoot_sfx_alias = "ranged_shooting",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/autogun/autogun_muzzle",
			num_pre_loop_events = 1,
			muzzle_flash_crit_effect = "content/fx/particles/weapons/rifles/autogun/autogun_muzzle_crit",
			auto_fire_time_parameter_name = "wpn_fire_interval",
			spread_rotated_muzzle_flash = false,
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_autogun_01",
			post_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			pre_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			line_effect = LineEffects.autogun_bullet
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.autogun_p1_m1_bullet,
			damage_type = damage_types.auto_bullet
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload"
			},
			zoom = {
				action_name = "action_zoom"
			},
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 0.45
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return false
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		},
		buff_keywords = {
			buff_keywords.allow_hipfire_during_sprint
		},
		aim_assist_ramp_template = AimAssistTemplates.killshot_fire
	},
	action_shoot_zoomed = {
		start_input = "zoom_shoot",
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0,
		hit_marker_type = "center",
		weapon_handling_template = "autogun_full_auto_slow",
		ammunition_usage = 1,
		stop_input = "shoot_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.85,
				t = 0.25
			},
			{
				modifier = 0.7,
				t = 0.45
			},
			{
				modifier = 0.5,
				t = 2
			},
			start_modifier = 0.75
		},
		fx = {
			pre_loop_shoot_sfx_alias = "ranged_pre_loop_shot",
			crit_shoot_sfx_alias = "critical_shot_extra",
			looping_shoot_sfx_alias = "ranged_shooting",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/autogun/autogun_muzzle",
			num_pre_loop_events = 1,
			muzzle_flash_crit_effect = "content/fx/particles/weapons/rifles/autogun/autogun_muzzle_crit",
			auto_fire_time_parameter_name = "wpn_fire_interval",
			spread_rotated_muzzle_flash = false,
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_autogun_01",
			post_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			pre_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			line_effect = LineEffects.autogun_bullet
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.autogun_p1_m1_bullet,
			damage_type = damage_types.auto_bullet
		},
		crosshair = {
			crosshair_type = "ironsight"
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.26
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.26
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
		},
		aim_assist_ramp_template = AimAssistTemplates.killshot_fire
	},
	action_zoom = {
		start_input = "zoom",
		kind = "aim",
		total_time = 0.3,
		crosshair = {
			crosshair_type = "ironsight"
		},
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_assault,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
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
		},
		aim_assist_ramp_template = AimAssistTemplates.killshot_aim
	},
	action_unzoom = {
		start_input = "zoom_release",
		kind = "unaim",
		total_time = 0.2,
		crosshair = {
			crosshair_type = "ironsight"
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
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
		},
		aim_assist_ramp_template = AimAssistTemplates.killshot_unaim
	},
	action_reload = {
		weapon_handling_template = "time_scale_1_2",
		start_input = "reload",
		sprint_requires_press_to_interrupt = true,
		kind = "reload_state",
		allowed_during_sprint = true,
		abort_sprint = true,
		stop_alternate_fire = true,
		total_time = 3.3,
		crosshair = {
			crosshair_type = "none"
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
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 3.1
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed
		}
	},
	action_toggle_flashlight = {
		kind = "toggle_special",
		anim_event = "toggle_flashlight",
		start_input = "weapon_special",
		allowed_during_sprint = true,
		activation_time = 0,
		skip_3p_anims = true,
		total_time = 0.2,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
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
		kind = "toggle_special",
		anim_event = "toggle_flashlight",
		start_input = "zoom_weapon_special",
		activation_time = 0,
		skip_3p_anims = true,
		total_time = 0.2,
		crosshair = {
			crosshair_type = "ironsight"
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
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
		anim_event = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect"
		}
	}
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.entry_actions = {
	primary_action = "action_shoot_hip",
	secondary_action = "action_zoom"
}
weapon_template.allow_sprinting_with_special = true
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/autogun_rifle"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/autogun_rifle"
weapon_template.reload_template = ReloadTemplates.autogun
weapon_template.spread_template = "autogun_assault_p1_m1"
weapon_template.recoil_template = "default_autogun_assault"
weapon_template.suppression_template = "default_autogun_assault"
weapon_template.look_delta_template = "autogun"
weapon_template.semi_auto_chain_factor = 0.9
weapon_template.ammo_template = "autogun_p1_m1"
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
weapon_template.fx_sources = {
	_eject = "fx_eject",
	_muzzle = "fx_muzzle_01",
	_mag_well = "fx_reload"
}
weapon_template.crosshair = {
	crosshair_type = "assault"
}
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	peeking_mechanics = true,
	sway_template = "fullauto_autogun_killshot",
	stop_anim_event = "to_unaim_ironsight",
	start_anim_event_3p = "to_ironsight",
	recoil_template = "autogun_p1_m1_killshot",
	spread_template = "default_autogun_alternate_fire_killshot",
	suppression_template = "fullauto_autogun_killshot",
	stop_anim_event_3p = "to_unaim_ironsight",
	start_anim_event = "to_ironsight",
	look_delta_template = "default_aiming",
	crosshair = {
		crosshair_type = "ironsight"
	},
	camera = {
		custom_vertical_fov = 40,
		vertical_fov = 54,
		near_range = 0.025
	},
	movement_speed_modifier = {
		{
			modifier = 0.775,
			t = 0.35
		},
		{
			modifier = 0.75,
			t = 0.375
		},
		{
			modifier = 0.59,
			t = 0.55
		},
		{
			modifier = 0.85,
			t = 2
		}
	}
}
weapon_template.keywords = {
	"ranged",
	"autogun",
	"p1"
}
weapon_template.can_use_while_vaulting = true
weapon_template.dodge_template = "killshot"
weapon_template.sprint_template = "killshot"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.assault
local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")
weapon_template.base_stats = {
	autogun_p1_m1_stability_stat = {
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
	autogun_p1_m1_ammo_stat = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		}
	},
	autogun_p1_m1_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_dps_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_dps_stat
			}
		}
	},
	autogun_p1_m1_power_stat = {
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
	autogun_p1_m1_mobility_stat = {
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
local bespoke_autogun_p1_traits = table.keys(WeaponTraitsBespokeAutogunP1)

table.append(weapon_template.traits, bespoke_autogun_p1_traits)

weapon_template.perks = {
	autogun_p1_m1_stability_perk = {
		display_name = "loc_trait_display_autogun_p1_m1_stability_perk",
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
	autogun_p1_m1_ammo_perk = {
		display_name = "loc_trait_display_autogun_p1_m1_ammo_perk",
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_perk
			}
		}
	},
	autogun_p1_m1_dps_perk = {
		display_name = "loc_trait_display_autogun_p1_m1_dps_perk",
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_dps_perk
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_dps_perk
			}
		}
	},
	autogun_p1_m1_power_perk = {
		display_name = "loc_trait_display_autogun_p1_m1_power_perk",
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_power_perk
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_power_perk
			}
		}
	},
	autogun_p1_m1_mobility_perk = {
		display_name = "loc_trait_display_autogun_p1_m1_mobility_perk",
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
				recoil_trait_templates.default_recoil_perk
			},
			alternate_fire = {
				recoil_trait_templates.default_recoil_perk
			}
		},
		spread = {
			base = {
				spread_trait_templates.default_mobility_spread_perk
			}
		}
	}
}
weapon_template.weapon_temperature_settings = {
	increase_rate = 0.1,
	decay_rate = 0.075,
	grace_time = 0.4,
	use_charge = false,
	barrel_threshold = 0.4
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_rapid_fire"
	},
	{
		display_name = "loc_weapon_keyword_accurate"
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
		desc = "loc_stats_special_action_flashlight_desc",
		display_name = "loc_weapon_special_flashlight",
		type = "flashlight"
	}
}

return weapon_template
