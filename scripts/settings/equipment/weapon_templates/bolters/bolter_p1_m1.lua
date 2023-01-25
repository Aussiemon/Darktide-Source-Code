local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeBolterP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_bolter_p1")
local WeaponTraitsRangedCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_common")
local WeaponTraitsRangedAimed = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_aimed")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local template_types = WeaponTweakTemplateSettings.template_types
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_types = ArmorSettings.types
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local recoil_trait_templates = WeaponTraitTemplates[template_types.recoil]
local spread_trait_templates = WeaponTraitTemplates[template_types.spread]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local sway_trait_templates = WeaponTraitTemplates[template_types.sway]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local weapon_template = {
	action_inputs = {
		shoot_pressed = {
			buffer_time = 0.5,
			input_sequence = {
				{
					value = true,
					input = "action_one_hold"
				}
			}
		},
		shoot_release = {
			buffer_time = 0.2,
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
		}
	}
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	wield = "stay",
	special_action = "base",
	reload = "stay",
	shoot_pressed = {
		zoom = "base",
		wield = "base",
		grenade_ability = "base",
		reload = "base",
		combat_ability = "base",
		shoot_release = "base"
	},
	zoom = {
		special_action = "base",
		wield = "base",
		zoom_shoot = "stay",
		zoom_release = "base",
		grenade_ability = "base",
		reload = "base",
		combat_ability = "base"
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
		total_time = 1.9,
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
				chain_time = 1.5
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 1.75
			}
		}
	},
	action_shoot_hip = {
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot_pressed",
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0.3,
		weapon_handling_template = "bolter_full_auto",
		ammunition_usage = 1,
		minimum_hold_time = 0.19,
		stop_input = "shoot_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.3,
				t = 0.05
			},
			{
				modifier = 0.15,
				t = 0.15
			},
			{
				modifier = 0.15,
				t = 0.175
			},
			{
				modifier = 0.4,
				t = 0.3
			},
			{
				modifier = 0.5,
				t = 0.5
			},
			start_modifier = 0.3
		},
		fx = {
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/bolter/bolter_muzzle_ignite",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_bolter_01",
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			muzzle_flash_effect_secondary = "content/fx/particles/weapons/rifles/bolter/bolter_muzzle_secondary",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			line_effect = LineEffects.boltshell
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.default_bolter_boltshell,
			damage_type = damage_types.boltshell
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
				chain_time = 0.45
			},
			special_action = {
				action_name = "action_push",
				chain_time = 0.45
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.45
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
		sprint_ready_up_time = 0,
		kind = "shoot_hit_scan",
		weapon_handling_template = "immediate_single_shot",
		ammunition_usage = 1,
		crosshair_type = "ironsight",
		start_input = "zoom_shoot",
		total_time = 1,
		action_movement_curve = {
			{
				modifier = 0.3,
				t = 0.05
			},
			{
				modifier = 0.35,
				t = 0.15
			},
			{
				modifier = 0.375,
				t = 0.175
			},
			{
				modifier = 0.5,
				t = 0.3
			},
			{
				modifier = 0.6,
				t = 1
			},
			start_modifier = 0.3
		},
		fx = {
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/bolter/bolter_muzzle_secondary",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_bolter_01",
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			muzzle_flash_effect_secondary = "content/fx/particles/weapons/rifles/bolter/bolter_muzzle_ignite",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			line_effect = LineEffects.boltshell
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.default_bolter_boltshell,
			damage_type = damage_types.boltshell
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
				chain_time = 0.5
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.5
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.2
			},
			special_action = {
				action_name = "action_push",
				chain_time = 0.8
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_zoom = {
		weapon_handling_template = "time_scale_2_5",
		crosshair_type = "none",
		start_input = "zoom",
		kind = "aim",
		total_time = 0.5,
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
				chain_time = 0.45
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
		weapon_handling_template = "time_scale_1",
		stop_alternate_fire = true,
		abort_sprint = true,
		crosshair_type = "none",
		allowed_during_sprint = true,
		total_time = 6,
		action_movement_curve = {
			{
				modifier = 0.6,
				t = 0.3
			},
			{
				modifier = 0.75,
				t = 0.5
			},
			{
				modifier = 0.95,
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
				action_name = "action_shoot_hip",
				chain_time = 5
			},
			special_action = {
				chain_time = 2.5,
				action_name = "action_push",
				chain_until = 0.4
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed
		}
	},
	action_push = {
		allowed_during_sprint = true,
		push_radius = 2.4,
		start_input = "special_action",
		block_duration = 0.5,
		kind = "push",
		crosshair_type = "dot",
		continue_sprinting = true,
		damage_time = 0.122,
		unaim = true,
		anim_event = "attack_push",
		total_time = 1,
		action_movement_curve = {
			{
				modifier = 1.4,
				t = 0.1
			},
			{
				modifier = 0.5,
				t = 0.25
			},
			{
				modifier = 0.5,
				t = 0.4
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.4
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
				action_name = "action_shoot_hip",
				chain_time = 0.4
			},
			special_action = {
				action_name = "action_push",
				chain_time = 0.9
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.6
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.5
			}
		},
		inner_push_rad = math.pi * 0.1,
		outer_push_rad = math.pi * 0.2,
		inner_damage_profile = DamageProfileTemplates.weapon_special_push,
		inner_damage_type = damage_types.weapon_butt,
		outer_damage_profile = DamageProfileTemplates.weapon_special_push_outer,
		outer_damage_type = damage_types.weapon_butt
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
local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")
weapon_template.base_stats = {
	bolter_p1_m1_dps_stat = {
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
	bolter_p1_m1_stability_stat = {
		display_name = "loc_stats_display_stability_stat",
		is_stat_trait = true,
		recoil = {
			base = {
				recoil_trait_templates.lasgun_p1_m1_recoil_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("stability_recoil", "loc_weapon_stats_display_hip_fire")
			},
			alternate_fire = {
				recoil_trait_templates.lasgun_p1_m1_recoil_stat,
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
	bolter_p1_m1_mobility_stat = {
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
		recoil = {
			base = {
				recoil_trait_templates.default_mobility_recoil_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_recoil", "loc_weapon_stats_display_hip_fire")
			},
			alternate_fire = {
				recoil_trait_templates.default_mobility_recoil_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_recoil", "loc_weapon_stats_display_ads")
			}
		},
		spread = {
			base = {
				spread_trait_templates.default_mobility_spread_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_spread")
			}
		}
	},
	bolter_p1_m1_reload_speed_stat = {
		display_name = "loc_stats_display_reload_speed_stat",
		is_stat_trait = true,
		weapon_handling = {
			action_reload = {
				weapon_handling_trait_templates.max_reload_speed_modify,
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
	},
	bolter_p1_m1_control_stat = {
		display_name = "loc_stats_display_power_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.autopistol_control_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			},
			action_shoot_zoomed = {
				damage_trait_templates.autopistol_control_stat
			}
		}
	}
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.entry_actions = {
	primary_action = "action_shoot_hip",
	secondary_action = "action_zoom"
}
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/bolt_gun"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/bolt_gun"
weapon_template.reload_template = ReloadTemplates.bolter
weapon_template.spread_template = "default_bolter_spraynpray"
weapon_template.recoil_template = "default_bolter_spraynpray"
weapon_template.suppression_template = "hip_lasgun_killshot"
weapon_template.look_delta_template = "bolter"
weapon_template.ammo_template = "bolter_p1_m1"
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
weapon_template.no_ammo_delay = 0.55
weapon_template.uses_ammunition = true
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.2
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {
	_eject = "fx_eject",
	_muzzle_secondary = "fx_muzzle_02",
	_muzzle = "fx_muzzle_01"
}
weapon_template.crosshair_type = "spray_n_pray"
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	toughness_template = "killshot_zoomed",
	sway_template = "default_bolter_killshot",
	recoil_template = "default_bolter_killshot",
	stop_anim_event = "to_unaim_ironsight",
	spread_template = "default_bolter_killshot",
	suppression_template = "default_lasgun_killshot",
	crosshair_type = "ironsight",
	start_anim_event = "to_ironsight",
	look_delta_template = "bolter",
	camera = {
		custom_vertical_fov = 45,
		vertical_fov = 55,
		near_range = 0.025
	},
	movement_speed_modifier = {
		{
			modifier = 0.475,
			t = 0.25
		},
		{
			modifier = 0.45,
			t = 0.275
		},
		{
			modifier = 0.49,
			t = 0.45
		},
		{
			modifier = 0.5,
			t = 0.5
		},
		{
			modifier = 0.65,
			t = 0.6000000000000001
		},
		{
			modifier = 0.7,
			t = 0.7
		},
		{
			modifier = 0.8,
			t = 2
		}
	}
}
weapon_template.keywords = {
	"ranged",
	"bolter",
	"p1"
}
weapon_template.dodge_template = "killshot"
weapon_template.sprint_template = "killshot"
weapon_template.stamina_template = "lasrifle"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.bolter
weapon_template.smart_targeting_template = SmartTargetingTemplates.killshot
weapon_template.traits = {}
local ranged_common_traits = table.keys(WeaponTraitsRangedCommon)

table.append(weapon_template.traits, ranged_common_traits)

local ranged_aimed_traits = table.keys(WeaponTraitsRangedAimed)

table.append(weapon_template.traits, ranged_aimed_traits)

local bespoke_autogun_p1_traits = table.keys(WeaponTraitsBespokeBolterP1)

table.append(weapon_template.traits, bespoke_autogun_p1_traits)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_high_damage"
	},
	{
		display_name = "loc_weapon_keyword_piercing_shots"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		fire_mode = "burst",
		display_name = "loc_ranged_attack_primary",
		type = "hipfire"
	},
	secondary = {
		fire_mode = "semi_auto",
		display_name = "loc_ranged_attack_secondary_ads",
		type = "ads"
	},
	special = {
		desc = "loc_stats_special_action_melee_weapon_bash_desc",
		display_name = "loc_weapon_special_weapon_bash",
		type = "melee"
	}
}
weapon_template.special_action_name = "action_push"

return weapon_template
