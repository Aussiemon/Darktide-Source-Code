local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local ShotshellTemplates = require("scripts/settings/projectile/shotshell_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeThumperP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_thumper_p1")
local WeaponTraitsRangedCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_common")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local template_types = WeaponTweakTemplateSettings.template_types
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local recoil_trait_templates = WeaponTraitTemplates[template_types.recoil]
local spread_trait_templates = WeaponTraitTemplates[template_types.spread]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local weapon_template = {
	action_inputs = {
		wield = {
			buffer_time = 0.2,
			input_sequence = {
				{
					inputs = wield_inputs
				}
			}
		},
		shoot_pressed = {
			buffer_time = 0.4,
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
			buffer_time = 0.2,
			input_sequence = {
				{
					value = true,
					input = "weapon_reload"
				}
			}
		},
		bash = {
			buffer_time = 0.4,
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
	bash = "base",
	shoot_pressed = "stay",
	zoom = {
		zoom_release = "base",
		wield = "base",
		zoom_shoot = "stay",
		grenade_ability = "base",
		bash = "base",
		reload = "base",
		combat_ability = "base"
	}
}

table.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
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
			},
			no_ammo = {
				input_name = "reload"
			}
		},
		allowed_chain_actions = {
			bash = {
				action_name = "action_bash",
				chain_time = 0.6
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.85
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.4
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.4
			}
		}
	},
	action_unwield = {
		continue_sprinting = true,
		allowed_during_sprint = true,
		start_input = "wield",
		uninterruptible = true,
		kind = "unwield",
		total_time = 0,
		allowed_chain_actions = {}
	},
	action_shoot_hip = {
		start_input = "shoot_pressed",
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0.4,
		weapon_handling_template = "stubrevolver_single_shot",
		ammunition_usage = 1,
		sprint_requires_press_to_interrupt = true,
		allowed_during_sprint = true,
		total_time = 1,
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.1
			},
			{
				modifier = 1.35,
				t = 0.15
			},
			{
				modifier = 1.15,
				t = 0.175
			},
			{
				modifier = 1.05,
				t = 0.3
			},
			{
				modifier = 1,
				t = 0.5
			},
			start_modifier = 0.75
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/combat_shotgun_ogryn_muzzle",
			shoot_sfx_alias = "ranged_single_shot",
			muzzle_flash_crit_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle_crit",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			line_effect = LineEffects.boltshell
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.ogryn_thumper_p1_m3_bfg,
			damage_type = damage_types.pellet_heavy
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
				chain_time = 0.5
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.1
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		},
		buff_keywords = {
			buff_keywords.allow_hipfire_during_sprint
		}
	},
	action_zoom = {
		crosshair_type = "bfg",
		start_input = "zoom",
		kind = "aim",
		total_time = 0.3,
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
				chain_time = 0.1
			}
		},
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_assault,
		action_keywords = {
			"braced"
		}
	},
	action_unzoom = {
		crosshair_type = "bfg",
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
			reload = {
				action_name = "action_reload"
			},
			zoom = {
				action_name = "action_zoom"
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.4
			}
		}
	},
	action_shoot_zoomed = {
		start_input = "zoom_shoot",
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0.4,
		weapon_handling_template = "stubrevolver_single_shot",
		ammunition_usage = 1,
		sprint_requires_press_to_interrupt = true,
		allowed_during_sprint = true,
		total_time = 1,
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.1
			},
			{
				modifier = 1.35,
				t = 0.15
			},
			{
				modifier = 1.15,
				t = 0.175
			},
			{
				modifier = 1.05,
				t = 0.3
			},
			{
				modifier = 1,
				t = 0.5
			},
			start_modifier = 0.75
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/combat_shotgun_ogryn_muzzle",
			shoot_sfx_alias = "ranged_single_shot",
			muzzle_flash_crit_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle_crit",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			line_effect = LineEffects.boltshell
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.ogryn_thumper_p1_m3_bfg,
			damage_type = damage_types.pellet_heavy
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
				chain_time = 0.5
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.1
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		},
		buff_keywords = {
			buff_keywords.allow_hipfire_during_sprint
		}
	},
	action_reload = {
		kind = "reload_state",
		hold_combo = true,
		weapon_handling_template = "time_scale_1",
		stop_alternate_fire = true,
		start_input = "reload",
		crosshair_type = "ironsight",
		uninterruptible = true,
		total_time = 2.333,
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
			wield = {
				action_name = "action_unwield"
			},
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 2.25
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 2.25
			},
			bash = {
				chain_time = 1.6,
				reset_combo = true,
				action_name = "action_bash",
				chain_until = 0.3
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed
		}
	},
	action_bash = {
		damage_window_start = 0.5666666666666667,
		hit_armor_anim = "attack_hit_shield",
		start_input = "bash",
		allow_conditional_chain = true,
		kind = "sweep",
		range_mod = 1.15,
		first_person_hit_stop_anim = "attack_hit",
		attack_direction_override = "left",
		damage_window_end = 0.7,
		unaim = true,
		uninterruptible = true,
		anim_event = "attack_bash",
		total_time = 1.75,
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
			wield = {
				action_name = "action_unwield"
			},
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			reload = {
				action_name = "action_reload",
				reset_combo = true
			},
			shoot_pressed = {
				chain_time = 1.1,
				reset_combo = true,
				action_name = "action_shoot_hip"
			},
			bash = {
				action_name = "action_bash_right",
				chain_time = 0.8
			},
			zoom = {
				chain_time = 0.8,
				reset_combo = true,
				action_name = "action_zoom"
			}
		},
		weapon_box = {
			0.2,
			1.5,
			0.1
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/shotgun_grenade/bash_left",
			anchor_point_offset = {
				0,
				0,
				-0.15
			}
		},
		damage_type = damage_types.blunt,
		damage_profile = DamageProfileTemplates.light_ogryn_shotgun_tank,
		herding_template = HerdingTemplates.thunder_hammer_left_heavy
	},
	action_bash_right = {
		damage_window_start = 0.6333333333333333,
		hit_armor_anim = "attack_hit_shield",
		first_person_hit_stop_anim = "attack_hit",
		kind = "sweep",
		anim_event = "attack_bash_right",
		range_mod = 1.15,
		attack_direction_override = "right",
		damage_window_end = 0.7333333333333333,
		uninterruptible = true,
		total_time = 1.75,
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
			wield = {
				action_name = "action_unwield"
			},
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			reload = {
				action_name = "action_reload",
				reset_combo = true
			},
			shoot_pressed = {
				chain_time = 1.1,
				reset_combo = true,
				action_name = "action_shoot_hip"
			},
			bash = {
				action_name = "action_bash",
				chain_time = 1
			},
			zoom = {
				chain_time = 0.8,
				reset_combo = true,
				action_name = "action_zoom"
			}
		},
		weapon_box = {
			0.2,
			1.5,
			0.1
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/shotgun_grenade/bash_right",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_type = damage_types.ogryn_bullet_bounce,
		damage_profile = DamageProfileTemplates.light_ogryn_shotgun_tank,
		herding_template = HerdingTemplates.thunder_hammer_right_heavy
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
weapon_template.base_stats = {
	ogryn_thumper_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.stubrevolver_dps_stat
			},
			action_shoot_zoomed = {
				damage_trait_templates.stubrevolver_dps_stat
			}
		}
	},
	ogryn_thumper_reload_speed_stat = {
		display_name = "loc_stats_display_reload_speed_stat",
		is_stat_trait = true,
		weapon_handling = {
			action_reload = {
				weapon_handling_trait_templates.max_reload_speed_modify
			}
		}
	},
	ogryn_thumper_mobility_stat = {
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
		}
	},
	ogryn_thumper_default_range_stat = {
		display_name = "loc_stats_display_range_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.shotgun_default_range_stat
			},
			action_shoot_zoomed = {
				damage_trait_templates.shotgun_default_range_stat
			}
		}
	},
	ogryn_thumper_power_stat = {
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

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/ogryn/third_person/animations/shotgun_grenade"
weapon_template.anim_state_machine_1p = "content/characters/player/ogryn/first_person/animations/shotgun_grenade"
weapon_template.alternate_fire_settings = {
	crosshair_type = "bfg",
	toughness_template = "killshot_zoomed",
	stop_anim_event = "to_unaim_braced",
	start_anim_event = "to_braced",
	spread_template = "default_bolter_spraynpray",
	camera = {
		custom_vertical_fov = 55,
		vertical_fov = 50,
		near_range = 0.025
	},
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
	},
	projectile_aim_effect_settings = {}
}
weapon_template.spread_template = "default_autogun_assault"
weapon_template.recoil_template = "default_thumper_assault"
weapon_template.reload_template = ReloadTemplates.ogryn_thumper
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_ammo_with_delay",
		input_name = "reload"
	}
}
weapon_template.no_ammo_delay = 0.3
weapon_template.sprint_ready_up_time = 0.3
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.uses_ammunition = true
weapon_template.uses_overheat = false
weapon_template.movement_curve_modifier_template = "default"
weapon_template.ammo_template = "ogryn_thumper_p1_m1"
weapon_template.fx_sources = {
	_muzzle = "ap_bullet_02",
	_sweep = "fx_sweep"
}
weapon_template.crosshair_type = "bfg"
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"ranged",
	"shotgun_grenade",
	"p1"
}
weapon_template.dodge_template = "ogryn"
weapon_template.sprint_template = "ogryn"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.ogryn_thumper
weapon_template.traits = {}
local ranged_common_traits = table.keys(WeaponTraitsRangedCommon)

table.append(weapon_template.traits, ranged_common_traits)

local bespoke_traits = table.keys(WeaponTraitsBespokeThumperP1)

table.append(weapon_template.traits, bespoke_traits)

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
		fire_mode = "projectile",
		display_name = "loc_ranged_attack_primary",
		type = "hipfire"
	},
	secondary = {
		fire_mode = "projectile",
		display_name = "loc_ranged_attack_secondary_braced",
		type = "brace"
	},
	special = {
		display_name = "loc_weapon_special_weapon_bash",
		type = "melee"
	}
}

return weapon_template
