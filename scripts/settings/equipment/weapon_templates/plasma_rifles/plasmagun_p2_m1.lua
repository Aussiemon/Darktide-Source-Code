local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {
	action_inputs = {
		shoot_charge = {
			buffer_time = 0.5,
			input_sequence = {
				{
					value = true,
					input = "action_one_pressed"
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
		shoot_cancel = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = true,
					hold_input = "action_one_hold",
					input = "action_two_pressed"
				}
			}
		},
		zoom = {
			buffer_time = 0,
			input_sequence = {
				{
					value = true,
					input = "action_two_hold"
				}
			}
		},
		zoom_release = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = false,
					input = "action_two_hold",
					time_window = math.huge
				}
			}
		},
		zoom_charge = {
			buffer_time = 0,
			input_sequence = {
				{
					value = true,
					hold_input = "action_two_hold",
					input = "action_one_hold"
				}
			}
		},
		zoom_charge_release = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = false,
					hold_input = "action_two_hold",
					input = "action_one_hold",
					time_window = math.huge
				}
			}
		},
		shoot_zoomed = {
			buffer_time = 0.1,
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
			input_sequence = {
				{
					value = true,
					input = "weapon_reload"
				}
			}
		},
		vent = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					value = true,
					input = "weapon_extra_hold"
				}
			}
		},
		vent_release = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = false,
					input = "weapon_extra_hold",
					time_window = math.huge
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
		}
	}
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	wield = "stay",
	reload = "base",
	shoot_charge = {
		shoot_cancel = "base",
		wield = "base",
		grenade_ability = "base",
		reload = "base",
		combat_ability = "base",
		shoot_release = "base"
	},
	zoom = {
		wield = "base",
		zoom_release = "base",
		combat_ability = "base",
		grenade_ability = "base",
		reload = "base",
		shoot_zoomed = "base",
		zoom_charge = {
			zoom_charge_release = "previous",
			zoom_release = "base"
		}
	},
	vent = {
		wield = "base",
		vent_release = "base",
		combat_ability = "base",
		grenade_ability = "base"
	}
}
weapon_template.actions = {
	action_unwield = {
		start_input = "wield",
		uninterruptible = true,
		kind = "unwield",
		total_time = 0,
		allowed_chain_actions = {}
	},
	action_wield = {
		kind = "wield",
		allowed_during_sprint = true,
		uninterruptible = true,
		anim_event = "equip",
		total_time = 0.5,
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
			}
		}
	},
	action_charge_direct = {
		allowed_during_sprint = true,
		start_input = "zoom_charge",
		kind = "overload_charge",
		sprint_ready_up_time = 0.25,
		charge_template = "plasmagun_p2_m1_charge_direct",
		crosshair_type = "none",
		anim_end_event = "attack_charge_cancel",
		overload_module_class_name = "overheat",
		anim_event = "attack_charge",
		stop_input = "shoot_cancel",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.4,
				t = 0.1
			},
			{
				modifier = 0.4,
				t = 0.15
			},
			{
				modifier = 0.6,
				t = 0.2
			},
			{
				modifier = 0.4,
				t = 1
			},
			start_modifier = 1
		},
		charge_effects = {
			sfx_parameter = "lasgun_charge",
			looping_sound_alias = "ranged_charging"
		},
		finish_reason_to_action_input = {
			stunned = {
				input_name = "shoot_release"
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
			zoom_charge_release = {
				action_name = "action_shoot",
				chain_time = 0.1
			},
			vent = {
				action_name = "action_vent"
			},
			zoom_release = {
				action_name = "action_unzoom"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			if end_reason == "hold_input_released" or end_reason == "stunned" then
				return true
			end

			return false
		end
	},
	action_shoot = {
		ammunition_usage_max = 3,
		charge_template = "plasmagun_p1_m1_shoot",
		kind = "shoot_hit_scan",
		weapon_handling_template = "immediate_single_shot",
		sprint_ready_up_time = 0.25,
		recoil_template = "default_plasma_rifle_bfg",
		crosshair_type = "none",
		ammunition_usage_min = 1,
		allowed_during_sprint = true,
		use_charge = true,
		spread_template = "default_plasma_rifle_bfg",
		total_time = 0.5,
		action_movement_curve = {
			{
				modifier = 0.25,
				t = 0.2
			},
			{
				modifier = 0.4,
				t = 0.3
			},
			{
				modifier = 1,
				t = 0.5
			},
			start_modifier = 0.15
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			shoot_sfx_alias = "ranged_single_shot",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/plasma_gun/plasma_muzzle_ks",
			line_effect = LineEffects.plasma_beam
		},
		fire_configuration = {
			anim_event = "attack_charge_shoot",
			use_charge = true,
			hit_scan_template = HitScanTemplates.default_plasma_killshot,
			damage_type = damage_types.plasma
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
			vent = {
				action_name = "action_vent"
			},
			zoom = {
				action_name = "action_zoom"
			},
			reload = {
				action_name = "action_reload"
			},
			shoot_charge = {
				action_name = "action_charge_direct",
				chain_time = 0.5
			},
			zoom_release = {
				action_name = "action_unzoom"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return false
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_charge = {
		allowed_during_sprint = true,
		recoil_template = "default_plasma_rifle_demolitions",
		start_input = "shoot_charge",
		kind = "overload_charge",
		sprint_ready_up_time = 0.25,
		spread_template = "default_plasma_rifle_demolitions",
		charge_template = "plasmagun_p2_m1_charge",
		anim_end_event = "attack_charge_cancel",
		overload_module_class_name = "overheat",
		anim_event = "heavy_charge",
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
			looping_sound_alias = "ranged_charging"
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
			vent = {
				action_name = "action_vent"
			},
			reload = {
				action_name = "action_reload"
			},
			shoot_release = {
				action_name = "action_shoot_charged",
				chain_time = 0.5
			}
		},
		finish_reason_to_action_input = {
			stunned = {
				input_name = "shoot_zoomed"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			if end_reason == "hold_input_released" or end_reason == "stunned" then
				return true
			end

			return false
		end
	},
	action_shoot_charged = {
		use_charge = true,
		ammunition_usage_max = 10,
		weapon_handling_template = "immediate_single_shot",
		sprint_ready_up_time = 0,
		recoil_template = "default_plasma_rifle_demolitions",
		spread_template = "default_plasma_rifle_demolitions",
		kind = "shoot_hit_scan",
		ammunition_usage_min = 5,
		allowed_during_sprint = true,
		charge_template = "plasmagun_p1_m1_shoot_charged",
		total_time = 0.75,
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
			shoot_tail_sfx_alias = "ranged_shot_tail",
			shoot_sfx_alias = "ranged_single_shot",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/plasma_gun/plasma_muzzle_bfg",
			line_effect = LineEffects.plasma_beam
		},
		fire_configuration = {
			anim_event = "heavy_charge_shoot",
			use_charge = true,
			hit_scan_template = HitScanTemplates.default_plasma_rifle_demolition,
			damage_type = damage_types.plasma
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
			vent = {
				action_name = "action_vent"
			},
			reload = {
				action_name = "action_reload"
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.6
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_vent = {
		start_input = "vent",
		anim_end_event = "vent_end",
		kind = "vent_overheat",
		uninterruptible = true,
		anim_event = "vent",
		stop_input = "vent_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.4,
				t = 0.1
			},
			{
				modifier = 0.4,
				t = 0.15
			},
			{
				modifier = 0.6,
				t = 0.2
			},
			{
				modifier = 0.4,
				t = 1
			},
			start_modifier = 1
		},
		venting_fx = {
			looping_vfx_alias = "plasma_venting",
			looping_sound_alias = "ranged_plasma_venting"
		},
		running_action_state_to_action_input = {
			fully_vented = {
				input_name = "vent_release"
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
				action_name = "action_unwield",
				chain_time = 0.15
			}
		}
	},
	action_reload = {
		crosshair_type = "none",
		start_input = "reload",
		stop_alternate_fire = true,
		kind = "reload_state",
		total_time = 9.4,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed
		}
	},
	action_zoom = {
		use_charge = true,
		recoil_template = "default_lasgun_bfg",
		start_input = "zoom",
		kind = "aim",
		sprint_ready_up_time = 0.25,
		spread_template = "default_lasgun_bfg",
		anim_end_event = "to_unaim_ironsight",
		crosshair_type = "none",
		allowed_during_sprint = true,
		anim_event = "to_ironsight",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.1
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload"
			},
			zoom_charge = {
				action_name = "action_charge_direct",
				chain_time = 0.5
			},
			zoom_release = {
				action_name = "action_unzoom"
			},
			shoot_release = {
				action_name = "action_shoot"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			if end_reason == "hold_input_released" or end_reason == "stunned" then
				return true
			end

			return false
		end
	},
	action_unzoom = {
		crosshair_type = "none",
		start_input = "zoom_release",
		kind = "unaim",
		total_time = 0.333,
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
weapon_template.alternate_fire_settings = {
	recoil_template = "default_bolter_killshot",
	sway_template = "default_bolter_killshot",
	stop_anim_event = "to_unaim_ironsight",
	crosshair_type = "none",
	start_anim_event = "to_ironsight",
	spread_template = "default_bolter_killshot",
	camera = {
		custom_vertical_fov = 60,
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

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/plasma_rifle"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/plasma_rifle"
weapon_template.reload_template = ReloadTemplates.plasma_rifle
weapon_template.spread_template = "default_plasma_rifle_bfg"
weapon_template.ammo_template = "plasmagun_p1_m1"
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
weapon_template.uses_overheat = true
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {
	_overheat = "fx_overheat",
	_vent = "fx_stock_01",
	_muzzle = "fx_muzzle",
	_mag_well = "fx_reload"
}
weapon_template.crosshair_type = "cross"
weapon_template.hit_marker_type = "center"
weapon_template.overheat_configuration = {
	vent_duration = 2,
	explode_at_high_overheat = true,
	low_threshold_decay_rate_modifier = 1.5,
	vent_interval = 0.25,
	auto_vent_delay = 1,
	explode_action = "action_overheat_explode",
	high_threshold_decay_rate_modifier = 0.5,
	auto_vent_duration = 10,
	critical_threshold_decay_rate_modifier = 0.1,
	thresholds = {
		high = 0.7,
		critical = 0.9,
		low = 0.3
	},
	vent_power_level = {
		50,
		100
	},
	vent_damage_profile = DamageProfileTemplates.plasma_vent_damage,
	vent_damage_type = damage_types.overheat,
	explosion_template = ExplosionTemplates.plasma_rifle_overheat,
	fx = {
		on_screen_effect = "content/fx/particles/screenspace/screen_plasma_rifle_warning",
		sfx_source_name = "_overheat",
		on_screen_cloud_name = "plasma",
		vfx_source_name = "_overheat",
		looping_sound_parameter_name = "overheat_plasma_gun",
		on_screen_variable_name = "plasma_radius",
		material_name = "coil_emissive_01",
		material_variable_name = "external_overheat_glow"
	}
}
weapon_template.keywords = {
	"ranged",
	"plasma_rifle",
	"p2"
}
weapon_template.can_use_while_vaulting = true
weapon_template.dodge_template = "plasma_rifle"
weapon_template.sprint_template = "support"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.killshot

return weapon_template
