local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local WeaponTraitsBespokeStubrevolverP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_stubrevolver_p1")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local damage_types = DamageSettings.damage_types
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local wield_inputs = PlayerCharacterConstants.wield_inputs
local template_types = WeaponTweakTemplateSettings.template_types
local armor_types = ArmorSettings.types
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local recoil_trait_templates = WeaponTraitTemplates[template_types.recoil]
local spread_trait_templates = WeaponTraitTemplates[template_types.spread]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local sway_trait_templates = WeaponTraitTemplates[template_types.sway]
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
		zoom_shoot = {
			buffer_time = 0.25,
			max_queue = 2,
			input_sequence = {
				{
					value = true,
					input = "action_one_pressed"
				}
			}
		},
		zoom = {
			buffer_time = 0.4,
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
		special_action_pistol_whip = {
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
	reload = "stay",
	shoot_pressed = "stay",
	special_action_pistol_whip = "base",
	zoom = {
		zoom_shoot = "stay",
		wield = "base",
		zoom_release = "previous",
		grenade_ability = "base",
		reload = "base",
		combat_ability = "base",
		special_action_pistol_whip = "base"
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
		total_time = 0.4,
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
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.1
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.2
			},
			reload = {
				action_name = "action_start_reload",
				chain_time = 0.1
			},
			special_action_pistol_whip = {
				action_name = "action_pistol_whip",
				chain_time = 0.2
			}
		}
	},
	action_shoot_hip = {
		sprint_ready_up_time = 0.2,
		sprint_requires_press_to_interrupt = true,
		weapon_handling_template = "stubrevolver_single_shot",
		kind = "shoot_hit_scan",
		ammunition_usage = 1,
		start_input = "shoot_pressed",
		total_time = 0.56,
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
			muzzle_flash_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle",
			shoot_sfx_alias = "ranged_single_shot",
			muzzle_flash_crit_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle_crit",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			line_effect = LineEffects.autogun_bullet
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.stub_revolver_p1_m1,
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
				action_name = "action_start_reload"
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
	action_shoot_zoomed = {
		recoil_template = "default_stub_pistol_killshot",
		start_input = "zoom_shoot",
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0,
		weapon_handling_template = "stubrevolver_single_shot",
		spread_template = "default_stub_pistol_killshot",
		ammunition_usage = 1,
		allowed_during_sprint = true,
		total_time = 0.56,
		crosshair = {
			crosshair_type = "ironsight"
		},
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
				modifier = 0.725,
				t = 0.175
			},
			{
				modifier = 0.85,
				t = 0.3
			},
			start_modifier = 0.5
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			muzzle_flash_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle",
			shoot_sfx_alias = "ranged_single_shot",
			muzzle_flash_crit_effect = "content/fx/particles/weapons/pistols/stubrevolver/stubrevolver_muzzle_crit",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			line_effect = LineEffects.autogun_bullet
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			hit_scan_template = HitScanTemplates.stub_revolver_p1_m1,
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
				action_name = "action_start_reload"
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.5
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.225
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_zoom = {
		start_input = "zoom",
		kind = "aim",
		total_time = 0.3,
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_bfg,
		crosshair = {
			crosshair_type = "ironsight"
		},
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05
			},
			{
				modifier = 0.75,
				t = 0.15
			},
			{
				modifier = 0.725,
				t = 0.175
			},
			{
				modifier = 0.85,
				t = 0.3
			},
			{
				modifier = 0.8,
				t = 1
			},
			start_modifier = 0.5
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_start_reload"
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.2
			}
		}
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
			reload = {
				action_name = "action_start_reload"
			},
			wield = {
				action_name = "action_unwield"
			},
			zoom = {
				action_name = "action_zoom"
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.2
			}
		}
	},
	action_start_reload = {
		sprint_requires_press_to_interrupt = true,
		start_input = "reload",
		allowed_during_sprint = true,
		weapon_handling_template = "time_scale_1_1",
		kind = "reload_shotgun",
		stop_alternate_fire = true,
		anim_end_event = "reload_cancel",
		abort_sprint = true,
		uninterruptible = false,
		anim_event = "reload_start",
		total_time = 1.45,
		crosshair = {
			crosshair_type = "none"
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		anim_variables_func = function (action_settings, condition_func_params)
			local current_ammunition_clip = condition_func_params.inventory_slot_component.current_ammunition_clip

			return "current_clip", current_ammunition_clip
		end,
		reload_settings = {
			refill_at_time = 0,
			refill_amount = 0
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
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "reload"
			}
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			special_action_pistol_whip = {
				action_name = "action_pistol_whip",
				chain_time = 0.5
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
				action_name = "action_reload_loop",
				chain_time = 1.4
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed
		}
	},
	action_reload_loop = {
		kind = "reload_shotgun",
		anim_end_event = "reload_cancel",
		sprint_requires_press_to_interrupt = true,
		weapon_handling_template = "time_scale_1",
		allowed_during_sprint = true,
		abort_sprint = true,
		uninterruptible = false,
		anim_event = "reload_middle",
		total_time = 0.52,
		crosshair = {
			crosshair_type = "none"
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		anim_variables_func = function (action_settings, condition_func_params)
			local current_ammunition_clip = condition_func_params.inventory_slot_component.current_ammunition_clip

			return "current_clip", current_ammunition_clip
		end,
		reload_settings = {
			13,
			refill_at_time = 0,
			refill_amount = 1
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
		conditional_state_to_action_input = {
			auto_chain = {
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
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.5
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.5
			},
			reload = {
				action_name = "action_reload_loop",
				chain_time = 0.5
			},
			special_action_pistol_whip = {
				action_name = "action_pistol_whip",
				chain_time = 0.5
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed
		}
	},
	action_pistol_whip = {
		damage_window_start = 0.25,
		range_mod = 1,
		start_input = "special_action_pistol_whip",
		allow_conditional_chain = true,
		kind = "sweep",
		first_person_hit_anim = "attack_hit",
		sprint_requires_press_to_interrupt = true,
		first_person_hit_stop_anim = "attack_hit",
		allowed_during_sprint = true,
		damage_window_end = 0.31666666666666665,
		abort_sprint = true,
		unaim = true,
		anim_event = "attack_stab_01",
		power_level = 300,
		total_time = 1.2,
		crosshair = {
			crosshair_type = "dot"
		},
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
				action_name = "action_unwield",
				chain_time = 0.6
			},
			reload = {
				action_name = "action_start_reload",
				chain_time = 0.6
			},
			special_action_pistol_whip = {
				action_name = "action_pistol_whip_followup",
				chain_time = 0.55
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.8
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.95
			}
		},
		weapon_box = {
			0.1,
			1.1,
			0.2
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/stubgun_pistol/pistol_whip",
			anchor_point_offset = {
				0.2,
				0.8,
				0
			}
		},
		damage_type = damage_types.weapon_butt,
		damage_profile = DamageProfileTemplates.weapon_special_push
	},
	action_pistol_whip_followup = {
		damage_window_start = 0.25,
		first_person_hit_stop_anim = "attack_hit",
		sprint_requires_press_to_interrupt = true,
		range_mod = 1,
		kind = "sweep",
		first_person_hit_anim = "attack_hit",
		anim_event = "attack_stab_02",
		allowed_during_sprint = true,
		damage_window_end = 0.31666666666666665,
		abort_sprint = true,
		unaim = true,
		allow_conditional_chain = true,
		power_level = 300,
		total_time = 1.2,
		crosshair = {
			crosshair_type = "dot"
		},
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
				action_name = "action_unwield",
				chain_time = 0.6
			},
			reload = {
				action_name = "action_start_reload",
				chain_time = 0.6
			},
			special_action_pistol_whip = {
				action_name = "action_pistol_whip",
				chain_time = 0.6
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.8
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.75
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.4
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.85
			}
		},
		weapon_box = {
			0.1,
			1.1,
			0.2
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/stubgun_pistol/pistol_whip_02",
			anchor_point_offset = {
				0.2,
				0.8,
				0
			}
		},
		damage_type = damage_types.weapon_butt,
		damage_profile = DamageProfileTemplates.weapon_special_push
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

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/stubgun_pistol"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/stubgun_pistol"
weapon_template.reload_template = ReloadTemplates.laspistol
weapon_template.spread_template = "default_stub_pistol_assault"
weapon_template.recoil_template = "default_stub_pistol_bfg"
weapon_template.look_delta_template = "stub_pistol"
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
weapon_template.no_ammo_delay = 0.45
weapon_template.uses_ammunition = true
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.ammo_template = "stubrevolver_p1_m1"
weapon_template.fx_sources = {
	_muzzle = "fx_muzzle_01"
}
weapon_template.crosshair = {
	crosshair_type = "bfg"
}
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	peeking_mechanics = true,
	sway_template = "default_stubpistol_killshot",
	recoil_template = "default_stub_pistol_killshot",
	stop_anim_event = "to_unaim_ironsight",
	spread_template = "default_stub_pistol_killshot",
	suppression_template = "default_lasgun_killshot",
	start_anim_event = "to_ironsight",
	look_delta_template = "stub_pistol_aiming",
	crosshair = {
		crosshair_type = "ironsight"
	},
	camera = {
		custom_vertical_fov = 40,
		vertical_fov = 50,
		near_range = 0.025
	},
	action_movement_curve = {
		{
			modifier = 0.6,
			t = 0.05
		},
		{
			modifier = 0.75,
			t = 0.15
		},
		{
			modifier = 0.725,
			t = 0.175
		},
		{
			modifier = 0.85,
			t = 0.3
		},
		{
			modifier = 0.7,
			t = 1
		},
		start_modifier = 0.8
	}
}
local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")
weapon_template.base_stats = {
	stubrevolver_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.stubrevolver_dps_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			},
			action_shoot_zoomed = {
				damage_trait_templates.stubrevolver_dps_stat
			}
		}
	},
	stubrevolver_reload_speed_stat = {
		display_name = "loc_stats_display_reload_speed_stat",
		is_stat_trait = true,
		weapon_handling = {
			action_start_reload = {
				weapon_handling_trait_templates.default_reload_speed_modify,
				display_data = {
					display_stats = {
						time_scale = {
							normalize = false,
							store_for_late_resolve = true,
							stat_group_key = "reload_start"
						}
					}
				}
			},
			action_reload_loop = {
				weapon_handling_trait_templates.default_reload_speed_modify,
				display_data = {
					display_stats = {
						time_scale = {
							normalize = false,
							store_for_late_resolve = true,
							stat_group_key = "reload_loop"
						}
					},
					display_group_stats = {
						looped_reload = {
							resolve_late = true
						}
					}
				}
			}
		}
	},
	stubrevolver_mobility_stat = {
		display_name = "loc_stats_display_mobility_stat",
		is_stat_trait = true,
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_dodge")
			}
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_sprint")
			}
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_curve")
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
	stubrevolver_armor_piercing_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.stubrevolver_armor_piercing_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			},
			action_shoot_zoomed = {
				damage_trait_templates.stubrevolver_armor_piercing_stat
			}
		}
	},
	stubrevolver_crit_stat = {
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
	"stub_pistol",
	"p1"
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.killshot
weapon_template.dodge_template = "assault"
weapon_template.sprint_template = "assault"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "assault"
weapon_template.can_use_while_vaulting = true
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.hipfire_inputs = {
	shoot_pressed = true
}
weapon_template.traits = {}
local bespoke_stubrevolver_p1_traits = table.keys(WeaponTraitsBespokeStubrevolverP1)

table.append(weapon_template.traits, bespoke_stubrevolver_p1_traits)

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
		desc = "loc_stats_special_action_melee_weapon_bash_desc",
		display_name = "loc_weapon_special_weapon_bash",
		type = "melee"
	}
}
weapon_template.special_action_name = "action_pistol_whip"

return weapon_template
