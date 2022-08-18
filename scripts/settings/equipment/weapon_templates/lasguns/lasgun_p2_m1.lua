local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsRangedCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_common")
local WeaponTraitsRangedMediumFireRate = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_medium_fire_rate")
local WeaponTraitsRangedAimed = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_aimed")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTraitsRangedOverheat = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_overheat")
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
local ammo_trait_templates = WeaponTraitTemplates[template_types.ammo]
local sway_trait_templates = WeaponTraitTemplates[template_types.sway]
local toughness_trait_templates = WeaponTraitTemplates[template_types.toughness]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local weapon_template = {
	action_inputs = {
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
		brace = {
			buffer_time = 0.2,
			max_queue = 2,
			input_sequence = {
				{
					value = true,
					input = "action_two_hold"
				}
			}
		},
		brace_release = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = false,
					input = "action_two_hold",
					time_window = math.huge
				}
			}
		},
		brace_shoot = {
			buffer_time = 0.25,
			input_sequence = {
				{
					value = true,
					hold_input = "action_two_hold",
					input = "action_one_pressed"
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
	shoot_pressed = "stay",
	reload = "stay",
	weapon_special = "stay",
	brace = {
		wield = "base",
		brace_release = "base",
		grenade_ability = "base",
		reload = "stay",
		combat_ability = "base",
		zoom_weapon_special = "stay",
		brace_shoot = {
			wield = "base"
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
			brace = {
				action_name = "action_charge",
				chain_time = 0.5
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.65
			}
		}
	},
	action_shoot_hip = {
		sprint_ready_up_time = 0.3,
		start_input = "shoot_pressed",
		sprint_requires_press_to_interrupt = true,
		weapon_handling_template = "immediate_single_shot",
		kind = "shoot_hit_scan",
		ammunition_usage = 1,
		total_time = 0.5,
		action_movement_curve = {
			{
				modifier = 0.5,
				t = 0.05
			},
			{
				modifier = 0.55,
				t = 0.15
			},
			{
				modifier = 0.575,
				t = 0.175
			},
			{
				modifier = 0.6,
				t = 0.2
			},
			{
				modifier = 0.8,
				t = 0.3
			},
			{
				modifier = 1,
				t = 0.5
			},
			start_modifier = 0.3
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
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.default_lasgun_beam,
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
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.25
			},
			brace = {
				action_name = "action_charge",
				chain_time = 0.1
			}
		},
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_shoot_charged = {
		ammunition_usage_max = 5,
		weapon_handling_template = "immediate_single_shot",
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0,
		ammunition_shoot_anyways = true,
		ammunition_usage_min = 2,
		allowed_during_sprint = true,
		ammunition_usage = 1,
		use_charge = true,
		recoil_template = "default_lasgun_bfg",
		charge_template = "lasgungun_p2_m1_shoot",
		spread_template = "default_lasgun_bfg",
		total_time = 1.2,
		action_movement_curve = {
			{
				modifier = 0.1,
				t = 0.35
			},
			{
				modifier = 0.1,
				t = 0.55
			},
			{
				modifier = 1,
				t = 0.75
			},
			start_modifier = 0.1
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_bfg_muzzle",
			shoot_sfx_alias = "ranged_single_shot",
			spread_rotated_muzzle_flash = true,
			num_shots_for_muzzle_smoke = 1,
			muzzle_flash_size_variable_name = "lasgun_muzzle_flash_size",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			muzzle_smoke_effect = "content/fx/particles/weapons/rifles/lasgun/lasgun_bfg_aftermath",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			muzzle_flash_variable_size = {
				max = 0.55,
				min = 0.1
			},
			line_effect = LineEffects.lasbeam_bfg
		},
		fire_configuration = {
			anim_event = "attack_charge_shoot",
			use_charge = true,
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.bfg_lasgun_beam
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			brace = {
				action_name = "action_charge",
				chain_time = 0.7
			}
		},
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_charge = {
		overload_module_class_name = "overheat",
		start_input = "brace",
		kind = "overload_charge",
		sprint_ready_up_time = 0.25,
		allowed_during_sprint = true,
		use_charge = true,
		recoil_template = "default_lasgun_bfg",
		anim_end_event = "attack_charge_cancel",
		charge_template = "lasgun_p2_m1_charge_up",
		spread_template = "default_lasgun_bfg",
		anim_event = "attack_charge",
		stop_input = "brace_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.3,
				t = 0.1
			},
			{
				modifier = 0.3,
				t = 0.15
			},
			{
				modifier = 0.6,
				t = 0.25
			},
			{
				modifier = 0.6,
				t = 0.5
			},
			{
				modifier = 0.4,
				t = 1
			},
			{
				modifier = 0.3,
				t = 2
			},
			start_modifier = 1
		},
		charge_effects = {
			sfx_parameter = "lasgun_charge",
			sfx_source_name = "_muzzle",
			charge_done_sound_alias = "ranged_charging_done"
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload"
			},
			brace_shoot = {
				action_name = "action_shoot_charged",
				chain_time = 0.2
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			if end_reason == "hold_input_released" or end_reason == "stunned" then
				return true
			end

			return false
		end
	},
	action_overheat_explode = {
		death_on_explosion = true,
		anim_end_event = "charge_explode_finished",
		kind = "overload_explosion",
		anim_event = "charge_explode",
		total_time = 3,
		timeline_anims = {
			[0.933] = {
				anim_event_3p = "explode_end",
				anim_event_1p = "explode_end"
			}
		},
		explosion_template = ExplosionTemplates.plasma_rifle_overheat,
		death_damage_profile = DamageProfileTemplates.overheat_exploding_tick,
		death_damage_type = damage_types.laser,
		dot_settings = {
			power_level = 1000,
			damage_frequency = 0.8,
			damage_profile = DamageProfileTemplates.overheat_exploding_tick,
			damage_type = damage_types.laser
		},
		sfx = {
			on_start = "weapon_about_to_explode"
		}
	},
	action_reload = {
		kind = "reload_state",
		stop_alternate_fire = true,
		start_input = "reload",
		sprint_requires_press_to_interrupt = true,
		weapon_handling_template = "increased_reload_speed",
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
				action_name = "action_shoot_hip",
				chain_time = 2.5
			},
			brace = {
				action_name = "action_charge",
				chain_time = 0.2
			}
		},
		stat_buff_keywords = {
			buff_stat_buffs.reload_speed
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
	secondary_action = "action_charge"
}
weapon_template.allow_sprinting_with_special = true
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/lasgun_rifle"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/lasgun_rifle_krieg"
weapon_template.reload_template = ReloadTemplates.lasgun
weapon_template.spread_template = "hip_lasgun_assault"
weapon_template.recoil_template = "default_lasgun_bfg"
weapon_template.suppression_template = "hip_lasgun_killshot"
weapon_template.look_delta_template = "lasgun_rifle"
weapon_template.ammo_template = "lasgun_p1_m1"
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_ammo_and_started_reload",
		input_name = "reload"
	},
	{
		conditional_state = "no_ammo",
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
weapon_template.crosshair_type = "cross"
weapon_template.hit_marker_type = "center"
weapon_template.overheat_configuration = {
	critical_threshold = 0.9,
	explode_at_high_overheat = true,
	low_threshold_decay_rate_modifier = 0.1,
	vent_interval = 0.8,
	critical_threshold_decay_rate_modifier = 0.25,
	auto_vent_duration = 20,
	auto_vent_delay = 1,
	explode_action = "action_overheat_explode",
	high_threshold_decay_rate_modifier = 0.5,
	high_threshold = 0.7,
	low_threshold = 0.2,
	vent_duration = 4,
	explosion_template = ExplosionTemplates.plasma_rifle_overheat,
	fx = {
		looping_sound_critical_start_event = "wwise/events/weapon/play_plasmagun_overheat_intensity_03",
		critical_threshold_sound_event = "wwise/events/weapon/play_plasmagun_overheat_intensity_02",
		looping_sound_critical_stop_event = "wwise/events/weapon/stop_plasmagun_overheat_intensity_03",
		on_screen_cloud_name = "plasma",
		looping_sound_parameter_name = "overheat_plasma_gun",
		on_screen_variable_name = "plasma_radius",
		material_variable_name = "external_overheat_glow",
		on_screen_effect = "content/fx/particles/screenspace/screen_plasma_rifle_warning",
		has_husk_events = true,
		looping_sound_start_event = "wwise/events/weapon/play_plasmagun_overheat",
		sfx_source_name = "_overheat",
		high_threshold_sound_event = "wwise/events/weapon/play_plasmagun_overheat_intensity_01",
		looping_low_threshold_vfx = "content/fx/particles/weapons/rifles/plasma_gun/plasma_overcharge_level01",
		looping_high_threshold_vfx = "content/fx/particles/weapons/rifles/plasma_gun/plasma_overcharge_level02",
		vfx_source_name = "_overheat",
		looping_critical_threshold_vfx = "content/fx/particles/weapons/rifles/plasma_gun/plasma_overcharge_level03",
		looping_sound_stop_event = "wwise/events/weapon/stop_plasmagun_overheat",
		material_name = "coil_emissive_01"
	}
}
weapon_template.alternate_fire_settings = {
	crosshair_type = "none",
	sway_template = "default_lasgun_killshot",
	recoil_template = "default_lasgun_bfg",
	stop_anim_event = "to_unaim_reflex",
	spread_template = "default_lasgun_killshot",
	suppression_template = "default_lasgun_killshot",
	toughness_template = "killshot_zoomed",
	start_anim_event = "to_reflex",
	look_delta_template = "lasgun_holo_aiming",
	camera = {
		custom_vertical_fov = 45,
		vertical_fov = 45,
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
	}
}
weapon_template.keywords = {
	"ranged",
	"lasgun",
	"p2"
}
weapon_template.can_use_while_vaulting = true
weapon_template.dodge_template = "killshot"
weapon_template.sprint_template = "killshot"
weapon_template.stamina_template = "lasrifle"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "lasgun_p1_m1"
weapon_template.footstep_intervals = {
	crouch_walking = 0.61,
	walking = 0.4,
	sprinting = 0.37
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.killshot
weapon_template.base_stats = {
	lasgun_p1_m1_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_dps_stat
			},
			action_shoot_charged = {
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
		recoil = {
			base = {
				recoil_trait_templates.default_mobility_recoil_stat
			},
			alternate_fire = {
				recoil_trait_templates.default_mobility_recoil_stat
			}
		},
		spread = {
			base = {
				spread_trait_templates.default_mobility_spread_stat
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
			action_shoot_charged = {
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
			action_shoot_charged = {
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
			action_shoot_charged = {
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
		display_name = "loc_weapon_keyword_lasgun_p1_m1_description_1",
		icon_type = "crosshair"
	},
	{
		display_name = "loc_weapon_keyword_lasgun_p1_m1_description_2",
		icon_type = "shield"
	},
	{
		display_name = "loc_weapon_keyword_lasgun_p1_m1_description_3",
		icon_type = "shield"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_lasgun_p1_m1_attack_primary",
		type = "ninja_fencer"
	},
	secondary = {
		display_name = "loc_lasgun_p1_m1_attack_secondary",
		type = "ninja_fencer"
	},
	special = {
		display_name = "loc_lasgun_p1_m1_attack_special",
		type = "ninja_fencer"
	}
}

return weapon_template
