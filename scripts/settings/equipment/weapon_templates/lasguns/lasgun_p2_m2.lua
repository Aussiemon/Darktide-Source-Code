local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
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
		aim_hold = {
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
		}
	}
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	shoot_pressed = "stay",
	wield = "stay",
	reload = "stay",
	zoom = {
		zoom_release = "base",
		wield = "base",
		grenade_ability = "base",
		reload = "previous",
		combat_ability = "base",
		zoom_shoot = {
			aim_hold = "previous",
			zoom_release = "base"
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
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.65
			}
		}
	},
	action_shoot_hip = {
		sprint_ready_up_time = 0.3,
		sprint_requires_press_to_interrupt = true,
		weapon_handling_template = "immediate_single_shot",
		kind = "shoot_hit_scan",
		allow_shots_with_less_than_required_ammo = true,
		ammunition_usage = 3,
		start_input = "shoot_pressed",
		total_time = 0.5,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05
			},
			{
				modifier = 0.8,
				t = 0.15
			},
			{
				modifier = 0.875,
				t = 0.175
			},
			{
				modifier = 0.9,
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
			start_modifier = 0.95
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
		charge_template = "lasgun_p2_m2_charge_up",
		ammunition_usage_max = 15,
		start_input = "zoom_shoot",
		recoil_template = "default_lasgun_bfg",
		weapon_handling_template = "immediate_single_shot",
		sprint_ready_up_time = 0,
		continous_charge = true,
		allow_shots_with_less_than_required_ammo = true,
		crosshair_type = "none",
		ammunition_usage_min = 6,
		kind = "shoot_hit_scan",
		ammunition_usage = 3,
		use_charge = true,
		spread_template = "default_lasgun_bfg",
		total_time = math.huge,
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
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.bfg_lasgun_beam,
			damage_type = damage_types.laser
		},
		charge_effects = {
			sfx_parameter = "lasgun_charge",
			looping_effect_alias = "ranged_charging",
			looping_sound_alias = "ranged_charging",
			charge_done_sound_alias = "ranged_charging_done",
			sfx_source_name = "_muzzle"
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.2
			},
			aim_hold = {
				action_name = "action_charge",
				chain_time = 0.2
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_charge = {
		charge_template = "lasgun_p2_m2_charge_up",
		recoil_template = "default_lasgun_bfg",
		kind = "charge",
		sprint_ready_up_time = 0,
		spread_template = "default_lasgun_bfg",
		total_time = math.huge,
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
		charge_effects = {
			sfx_parameter = "lasgun_charge",
			looping_effect_alias = "ranged_charging",
			looping_sound_alias = "ranged_charging",
			charge_done_sound_alias = "ranged_charging_done",
			sfx_source_name = "_muzzle"
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload"
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.2
			},
			zoom_release = {
				action_name = "action_unzoom"
			}
		}
	},
	action_zoom = {
		use_charge = true,
		start_input = "zoom",
		recoil_template = "default_lasgun_bfg",
		kind = "charge_aim",
		sprint_ready_up_time = 0.25,
		spread_template = "default_lasgun_bfg",
		charge_template = "lasgun_p2_m2_charge_up",
		anim_end_event = "attack_charge_cancel",
		allowed_during_sprint = true,
		anim_event = "attack_charge",
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
			looping_effect_alias = "ranged_charging",
			looping_sound_alias = "ranged_charging",
			charge_done_sound_alias = "ranged_charging_done",
			sfx_source_name = "_muzzle"
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload"
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.2
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
				action_name = "action_shoot_hip",
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
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/lasgun_rifle"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/lasgun_rifle_krieg"
weapon_template.reload_template = ReloadTemplates.lasgun
weapon_template.spread_template = "hip_lasgun_assault"
weapon_template.recoil_template = "hip_lasgun_assault"
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
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.ammo_template = "lasgun_p2_m2"
weapon_template.fx_sources = {
	_muzzle = "fx_muzzle_01",
	_mag_well = "fx_reload"
}
weapon_template.crosshair_type = "cross"
weapon_template.hit_marker_type = "none"
weapon_template.alternate_fire_settings = {
	sway_template = "default_lasgun_killshot",
	stop_anim_event = "to_unaim_reflex",
	crosshair_type = "none",
	recoil_template = "default_lasgun_killshot",
	spread_template = "default_lasgun_killshot",
	toughness_template = "killshot_zoomed",
	start_anim_event = "to_reflex",
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
weapon_template.dodge_template = "killshot"
weapon_template.sprint_template = "killshot"
weapon_template.stamina_template = "lasrifle"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.killshot

return weapon_template
