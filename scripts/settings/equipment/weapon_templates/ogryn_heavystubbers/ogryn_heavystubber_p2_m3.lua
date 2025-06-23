-- chunkname: @scripts/settings/equipment/weapon_templates/ogryn_heavystubbers/ogryn_heavystubber_p2_m3.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FlashlightTemplates = require("scripts/settings/equipment/flashlight_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsOgrynHeavystubbertP2 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_heavystubber_p2")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local template_types = WeaponTweakTemplateSettings.template_types
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local recoil_trait_templates = WeaponTraitTemplates[template_types.recoil]
local spread_trait_templates = WeaponTraitTemplates[template_types.spread]
local sway_trait_templates = WeaponTraitTemplates[template_types.sway]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local weapon_template = {}

weapon_template.action_inputs = {
	shoot = {
		buffer_time = 0.25,
		max_queue = 1,
		input_sequence = {
			{
				value = true,
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
		buffer_time = 0.3,
		input_sequence = {
			{
				value = true,
				input = "action_one_pressed"
			}
		}
	},
	zoom = {
		buffer_time = 0.4,
		max_queue = 1,
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

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		input = "shoot",
		transition = {
			{
				transition = "base",
				input = "shoot_release"
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
				input = "zoom"
			}
		}
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
				transition = "stay",
				input = "weapon_special"
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
		input = "weapon_special"
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
		kind = "ranged_wield",
		allowed_during_sprint = true,
		wield_anim_event = "equip",
		wield_reload_anim_event = "equip_reload",
		weapon_handling_template = "time_scale_1_1",
		uninterruptible = true,
		total_time = 1.9,
		conditional_state_to_action_input = {
			started_reload = {
				input_name = "reload"
			},
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
				action_name = "action_reload",
				chain_time = 0.2
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 1
			},
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 1.4
			},
			weapon_special = {
				action_name = "action_toggle_flashlight",
				chain_time = 1.24
			}
		}
	},
	action_shoot_hip = {
		sprint_requires_press_to_interrupt = true,
		kind = "shoot_hit_scan",
		start_input = "shoot",
		anim_end_event = "attack_finished",
		weapon_handling_template = "ogryn_heavystubber_p2_m3_full_auto",
		sprint_ready_up_time = 0.6,
		ammunition_usage = 1,
		allowed_during_sprint = false,
		minimum_hold_time = 0.3,
		abort_sprint = false,
		uninterruptible = true,
		stop_input = "shoot_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.4,
				t = 0.05
			},
			{
				modifier = 0.6,
				t = 0.15
			},
			{
				modifier = 0.675,
				t = 0.175
			},
			{
				modifier = 0.75,
				t = 0.5
			},
			{
				modifier = 0.9,
				t = 1.5
			},
			start_modifier = 0.5
		},
		fx = {
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			crit_shoot_sfx_alias = "critical_shot_extra",
			looping_shoot_sfx_alias = "ranged_shooting",
			shoot_sfx_alias = "ranged_single_shot",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_heavystubber_01",
			alternate_shell_casings = false,
			auto_fire_time_parameter_name = "wpn_fire_interval",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			alternate_muzzle_flashes = false,
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/ogryn_heavystubber/heavystubber_p2/ogryn_heavystubber_p2m2_muzzle",
			line_effect = LineEffects.heavy_stubber_bullet
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.ogryn_heavystubber_p2_m3,
			damage_type = damage_types.heavy_stubber_bullet
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
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 0.29
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.66
			},
			weapon_special = {
				action_name = "action_toggle_flashlight",
				chain_time = 0.3
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_shoot_zoomed = {
		ignore_shooting_look_delta_anim_control = true,
		start_input = "zoom_shoot",
		anim_end_event = "attack_finished",
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0,
		weapon_handling_template = "ogryn_heavystubber_p2_m3_aim",
		ammunition_usage = 1,
		minimum_hold_time = 0.5,
		total_time = 0.7,
		action_movement_curve = {
			{
				modifier = 0.2,
				t = 0.15
			},
			{
				modifier = 0.25,
				t = 0.3
			},
			{
				modifier = 0.5,
				t = 1
			},
			start_modifier = 0.05
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.ogryn_heavystubber_p2_m3_braced,
			damage_type = damage_types.heavy_stubber_bullet
		},
		smart_targeting_template = SmartTargetingTemplates.ogryn_heavystubber_p2_braced,
		fx = {
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/ogryn_heavystubber/heavystubber_p2/ogryn_heavystubber_p2m2_muzzle",
			crit_shoot_sfx_alias = "critical_shot_extra",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_heavystubber_01",
			shoot_sfx_alias = "ranged_single_shot",
			alternate_shell_casings = false,
			shoot_tail_sfx_alias = "ranged_shot_tail",
			alternate_muzzle_flashes = false,
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			line_effect = LineEffects.heavy_stubber_bullet
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
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.53
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0
			},
			weapon_special = {
				action_name = "action_toggle_flashlight",
				chain_time = 0.3
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		},
		action_keywords = {
			"braced",
			"braced_shooting"
		}
	},
	action_zoom = {
		uninterruptible = true,
		start_input = "zoom",
		kind = "aim",
		total_time = 1,
		smart_targeting_template = SmartTargetingTemplates.ogryn_heavystubber_p2_braced,
		haptic_trigger_template = HapticTriggerTemplates.ranged.heavy_stubber_braced,
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
				chain_time = 0.1
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.45
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.1
			},
			weapon_special = {
				action_name = "action_toggle_flashlight",
				chain_time = 0.1
			}
		},
		action_keywords = {
			"braced"
		}
	},
	action_unzoom = {
		kind = "unaim",
		start_input = "zoom_release",
		total_time = 0.5,
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
				chain_time = 0.25
			},
			zoom = {
				action_name = "action_zoom"
			},
			weapon_special = {
				action_name = "action_toggle_flashlight",
				chain_time = 0.1
			}
		}
	},
	action_brace_reload = {
		uninterruptible = true,
		sprint_requires_press_to_interrupt = true,
		start_input = "brace_reload",
		kind = "reload_state",
		abort_sprint = true,
		allowed_during_sprint = true,
		total_time = 7,
		crosshair = {
			crosshair_type = "none"
		},
		action_movement_curve = {
			{
				modifier = 0.375,
				t = 0.05
			},
			{
				modifier = 0.35,
				t = 0.075
			},
			{
				modifier = 0.29,
				t = 0.25
			},
			{
				modifier = 0.2,
				t = 0.3
			},
			{
				modifier = 0.25,
				t = 0.8
			},
			{
				modifier = 0.4,
				t = 0.9
			},
			{
				modifier = 0.75,
				t = 2
			},
			start_modifier = 0.5
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
				chain_time = 5.6
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 2.6
			}
		}
	},
	action_reload = {
		stop_alternate_fire = true,
		start_input = "reload",
		kind = "reload_state",
		weapon_handling_template = "time_scale_1_2",
		sprint_requires_press_to_interrupt = true,
		abort_sprint = true,
		allowed_during_sprint = true,
		total_time = 7,
		crosshair = {
			crosshair_type = "none"
		},
		action_movement_curve = {
			{
				modifier = 0.475,
				t = 0.05
			},
			{
				modifier = 0.45,
				t = 0.075
			},
			{
				modifier = 0.29,
				t = 0.25
			},
			{
				modifier = 0.2,
				t = 0.3
			},
			{
				modifier = 0.25,
				t = 0.8
			},
			{
				modifier = 0.4,
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
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 5.3
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 5.6
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none
	},
	action_toggle_flashlight = {
		kind = "toggle_special",
		anim_event = "toggle_flashlight",
		start_input = "weapon_special",
		allowed_during_sprint = true,
		activation_time = 0.17,
		skip_3p_anims = true,
		total_time = 1,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
				chain_time = 0.6
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions({
				chain_time = 0.6
			}),
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.6
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.6
			},
			weapon_special = {
				action_name = "action_toggle_flashlight",
				chain_time = 0.9
			},
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 0.4
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.4
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.2
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
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none
	}
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.entry_actions = {
	primary_action = "action_shoot_hip",
	secondary_action = "action_zoom"
}
weapon_template.anim_state_machine_3p = "content/characters/player/ogryn/third_person/animations/heavy_stubber"
weapon_template.anim_state_machine_1p = "content/characters/player/ogryn/first_person/animations/heavy_stubber"
weapon_template.reload_template = ReloadTemplates.heavy_stubber
weapon_template.sway_template = "ogyn_heavy_stubber_sway"
weapon_template.spread_template = "ogryn_heavystubber_p2_m3_spread_hip"
weapon_template.recoil_template = "ogryn_heavystubber_p2_m3_recoil_hip"
weapon_template.look_delta_template = "default"
weapon_template.ammo_template = "ogryn_heavystubber_p2_m3"
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
weapon_template.no_ammo_delay = 0.4
weapon_template.hud_configuration = {
	uses_overheat = false,
	uses_ammunition = true
}
weapon_template.weapon_special_tweak_data = {
	manual_toggle_only = true
}
weapon_template.flashlight_template = FlashlightTemplates.ogryn_heavy_stubber_p2
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {
	_muzzle = "fx_01",
	_eject = "fx_eject_01"
}
weapon_template.crosshair = {
	crosshair_type = "assault"
}
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	recoil_template = "recoil_ogryn_heavystubber_p2_m3_braced",
	sway_template = "ogyn_heavy_stubber_sway",
	stop_anim_event = "to_unaim_braced",
	spread_template = "ogryn_heavystubber_p2_m3_spread_aim",
	uninterruptible = true,
	start_anim_event = "to_braced",
	look_delta_template = "lasgun_brace_light",
	crosshair = {
		crosshair_type = "cross"
	},
	camera = {
		custom_vertical_fov = 50,
		vertical_fov = 40,
		near_range = 0.025
	},
	movement_speed_modifier = {
		{
			modifier = 0.175,
			t = 0.05
		},
		{
			modifier = 0.24,
			t = 0.075
		},
		{
			modifier = 0.19,
			t = 0.25
		},
		{
			modifier = 0.2,
			t = 0.3
		},
		{
			modifier = 0.4,
			t = 0.4
		},
		{
			modifier = 0.6,
			t = 0.5
		},
		{
			modifier = 0.68,
			t = 2
		}
	}
}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	ogryn_heavystubber_p2_m3_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.ogryn_heavystubber_p2_dps_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			},
			action_shoot_zoomed = {
				damage_trait_templates.ogryn_heavystubber_p2_dps_stat
			}
		}
	},
	ogryn_heavystubber_p2_m3_stability_stat = {
		display_name = "loc_stats_display_stability_stat",
		is_stat_trait = true,
		recoil = {
			base = {
				recoil_trait_templates.default_recoil_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("stability_recoil", "loc_weapon_stats_display_hip_fire")
			},
			alternate_fire = {
				recoil_trait_templates.default_recoil_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("stability_recoil", "loc_weapon_stats_display_braced")
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
	ogryn_heavystubber_p2_m3_range_stat = {
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
	ogryn_heavystubber_p2_m3_control_stat = {
		display_name = "loc_stats_display_control_stat_ranged",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.shotgun_control_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			},
			action_shoot_zoomed = {
				damage_trait_templates.shotgun_control_stat
			}
		}
	},
	ogryn_heavystubber_p2_m3_crit_stat = {
		display_name = "loc_stats_display_crit_stat",
		is_stat_trait = true,
		weapon_handling = {
			action_shoot_hip = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
				display_data = {
					display_stats = {
						__all_basic_stats = true,
						critical_strike = {
							chance_modifier = {
								display_name = "loc_weapon_stats_display_crit_chance_ranged"
							}
						}
					}
				}
			},
			action_shoot_zoomed = {
				weapon_handling_trait_templates.stubrevolver_crit_stat
			}
		},
		damage = {
			action_shoot_hip = {
				damage_trait_templates.stubrevolver_crit_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			},
			action_shoot_zoomed = {
				damage_trait_templates.stubrevolver_crit_stat
			}
		}
	}
}
weapon_template.keywords = {
	"ranged",
	"heavystubber",
	"p2"
}
weapon_template.dodge_template = "ogryn"
weapon_template.sprint_template = "ogryn"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.ogryn_heavy_stubber
weapon_template.smart_targeting_template = SmartTargetingTemplates.ogryn_heavystubber_p2_hipfire
weapon_template.haptic_trigger_template = HapticTriggerTemplates.ranged.heavy_stubber
weapon_template.traits = {}

local ogryn_heavystubbert_p2_traits = table.ukeys(WeaponTraitsOgrynHeavystubbertP2)

table.append(weapon_template.traits, ogryn_heavystubbert_p2_traits)

weapon_template.weapon_temperature_settings = {
	increase_rate = 0.09,
	decay_rate = 0.08,
	grace_time = 0.4,
	use_charge = false,
	barrel_threshold = 0.3
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_high_damage"
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
		fire_mode = "semi_auto",
		display_name = "loc_ranged_attack_secondary_braced",
		type = "brace"
	},
	special = {
		desc = "loc_stats_special_action_flashlight_desc",
		display_name = "loc_weapon_special_flashlight",
		type = "flashlight"
	}
}
weapon_template.weapon_card_data = {
	main = {
		{
			value_func = "primary_attack",
			icon = "hipfire",
			sub_icon = "full_auto",
			header = "hipfire"
		},
		{
			value_func = "secondary_attack",
			icon = "brace",
			sub_icon = "semi_auto",
			header = "brace"
		},
		{
			value_func = "ammo",
			header = "ammo"
		}
	},
	weapon_special = {
		icon = "flashlight",
		header = "flashlight"
	}
}
weapon_template.special_action_name = "action_toggle_flashlight"

return weapon_template
