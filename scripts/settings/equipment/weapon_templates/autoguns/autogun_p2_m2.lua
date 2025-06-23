-- chunkname: @scripts/settings/equipment/weapon_templates/autoguns/autogun_p2_m2.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeAutogunP2 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_autogun_p2")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
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
local weapon_template = {}

weapon_template.action_inputs = {
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
		buffer_time = 0.22,
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
		input_sequence = {
			{
				value = true,
				input = "action_one_hold"
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
		buffer_time = 0.2,
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
				input = "zoom_shoot",
				transition = {
					{
						transition = "previous",
						input = "shoot_release"
					},
					{
						transition = "base",
						input = "zoom_release"
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
						input = "special_action"
					}
				}
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
				input = "special_action"
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
		transition = "base",
		input = "special_action"
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
		wield_reload_anim_event = "equip_reload",
		allowed_during_sprint = true,
		wield_anim_event = "equip_ak",
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
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
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
		start_input = "shoot",
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0.2,
		weapon_handling_template = "autogun_p2_m2_hip",
		ammunition_usage = 1,
		sprint_requires_press_to_interrupt = true,
		stop_input = "shoot_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.1
			},
			{
				modifier = 0.9,
				t = 0.25
			},
			{
				modifier = 1,
				t = 0.4
			},
			start_modifier = 0.8
		},
		fx = {
			pre_loop_shoot_sfx_alias = "ranged_pre_loop_shot",
			crit_shoot_sfx_alias = "critical_shot_extra",
			looping_shoot_sfx_alias = "ranged_shooting",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/autogun/autogun_muzzle_02",
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
			hit_scan_template = HitScanTemplates.autogun_p2_m2_bullet,
			damage_type = damage_types.auto_bullet
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
		}
	},
	action_shoot_zoomed = {
		minimum_hold_time = 0,
		start_input = "zoom_shoot",
		kind = "shoot_hit_scan",
		sprint_ready_up_time = 0,
		weapon_handling_template = "autogun_p2_m2",
		ammunition_usage = 1,
		uninterruptible = true,
		stop_input = "shoot_release",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "spray_n_pray"
		},
		action_movement_curve = {
			{
				modifier = 0.95,
				t = 0.2
			},
			{
				modifier = 0.9,
				t = 0.4
			},
			{
				modifier = 0.8,
				t = 1
			},
			start_modifier = 0.95
		},
		fx = {
			pre_loop_shoot_sfx_alias = "ranged_pre_loop_shot",
			crit_shoot_sfx_alias = "critical_shot_extra",
			looping_shoot_sfx_alias = "ranged_shooting",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/autogun/autogun_muzzle_02",
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
			hit_scan_template = HitScanTemplates.autogun_p2_m2_bullet,
			damage_type = damage_types.auto_bullet
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
		total_time = 0.5,
		crosshair = {
			crosshair_type = "spray_n_pray"
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
				chain_time = 0.5
			}
		}
	},
	action_unzoom = {
		start_input = "zoom_release",
		kind = "unaim",
		total_time = 0.2,
		crosshair = {
			crosshair_type = "spray_n_pray"
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			zoom = {
				action_name = "action_zoom"
			}
		}
	},
	action_reload = {
		start_input = "reload",
		kind = "reload_state",
		stop_alternate_fire = true,
		total_time = 3.2,
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
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield"
			},
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 2.8
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 2.95
			},
			special_action = {
				chain_time = 0.2,
				action_name = "action_push",
				chain_until = 0.4
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none
	},
	action_push = {
		damage_window_start = 0.13333333333333333,
		hit_armor_anim = "attack_hit",
		start_input = "special_action",
		sprint_requires_press_to_interrupt = true,
		kind = "sweep",
		first_person_hit_anim = "hit_left_shake",
		range_mod = 1.15,
		anim_event_3p = "attack_left_diagonal_up",
		first_person_hit_stop_anim = "attack_hit",
		stop_alternate_fire = true,
		weapon_handling_template = "time_scale_1_1",
		allowed_during_sprint = true,
		damage_window_end = 0.3,
		abort_sprint = true,
		uninterruptible = true,
		anim_event = "attack_push",
		total_time = 1.1,
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
				chain_time = 0.5
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.5
			},
			special_action = {
				action_name = "action_push",
				chain_time = 0.8
			}
		},
		weapon_box = {
			0.25,
			1,
			0.7
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/shotgun_rifle/attack_left_diagonal_up_bash",
			anchor_point_offset = {
				0,
				1.4,
				-0.1
			}
		},
		damage_type = damage_types.weapon_butt,
		damage_profile = DamageProfileTemplates.autogun_weapon_special_bash,
		herding_template = HerdingTemplates.stab,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none
	},
	action_inspect = {
		skip_3p_anims = false,
		start_input = "inspect_start",
		anim_end_event = "inspect_end",
		kind = "inspect",
		lock_view = true,
		anim_event = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
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
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/autogun_rifle"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/autogun_rifle"
weapon_template.reload_template = ReloadTemplates.autogun_ak
weapon_template.spread_template = "autogun_p2_m2_hip"
weapon_template.recoil_template = "default_autogun_spraynpray"
weapon_template.suppression_template = "default_autogun_assault"
weapon_template.look_delta_template = "autogun"
weapon_template.semi_auto_chain_factor = 0.9
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
weapon_template.no_ammo_delay = 0.15
weapon_template.hud_configuration = {
	uses_overheat = false,
	uses_ammunition = true
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.ammo_template = "autogun_p2_m2"
weapon_template.fx_sources = {
	_eject = "fx_eject",
	_muzzle = "fx_muzzle_01",
	_mag_well = "fx_reload"
}
weapon_template.crosshair = {
	crosshair_type = "assault"
}
weapon_template.hit_marker_type = "multiple"
weapon_template.alternate_fire_settings = {
	peeking_mechanics = true,
	stop_anim_event = "to_unaim_braced",
	recoil_template = "ads_autogun_p2_m2_spraynpray",
	spread_template = "autogun_p2_m2_ads",
	start_anim_event_3p = "to_ironsight",
	stop_anim_event_3p = "to_unaim_braced",
	start_anim_event = "to_braced",
	look_delta_template = "autogun",
	crosshair = {
		crosshair_type = "spray_n_pray"
	},
	movement_speed_modifier = {
		{
			modifier = 0.95,
			t = 0.35
		},
		{
			modifier = 0.9,
			t = 0.375
		},
		{
			modifier = 0.875,
			t = 0.55
		},
		{
			modifier = 0.85,
			t = 0.6
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
	"p2"
}
weapon_template.dodge_template = "support"
weapon_template.sprint_template = "killshot"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.killshot
weapon_template.haptic_trigger_template = HapticTriggerTemplates.ranged.spray_n_pray

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	autogun_p2_m2_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_dps_stat,
				display_data = {
					display_stats = {
						armor_damage_modifier_ranged = {
							near = {
								attack = {
									[armor_types.unarmored] = {},
									[armor_types.disgustingly_resilient] = {}
								}
							},
							far = {
								attack = {
									[armor_types.unarmored] = {},
									[armor_types.disgustingly_resilient] = {}
								}
							}
						},
						power_distribution = {
							attack = {}
						}
					}
				}
			},
			action_shoot_zoomed = {
				damage_trait_templates.default_dps_stat
			},
			action_push = {
				damage_trait_templates.default_melee_dps_stat
			}
		}
	},
	autogun_p2_m2_ammo_stat = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_stat,
				display_data = {
					display_stats = {
						ammunition_clip = {},
						ammunition_reserve = {}
					}
				}
			}
		}
	},
	autogun_p2_m2_stability_stat = {
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
		}
	},
	autogun_p2_m2_control_stat = {
		display_name = "loc_stats_display_control_stat_ranged",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.autopistol_control_stat,
				display_data = {
					display_stats = {
						armor_damage_modifier_ranged = {
							near = {
								impact = {
									[armor_types.unarmored] = {},
									[armor_types.disgustingly_resilient] = {},
									[armor_types.resistant] = {},
									[armor_types.berserker] = {}
								}
							},
							far = {
								impact = {
									[armor_types.unarmored] = {},
									[armor_types.disgustingly_resilient] = {},
									[armor_types.resistant] = {},
									[armor_types.berserker] = {}
								}
							}
						},
						power_distribution = {
							impact = {}
						},
						suppression_value = {},
						on_kill_area_suppression = {
							suppression_value = {},
							distance = {}
						}
					}
				}
			},
			action_shoot_zoomed = {
				damage_trait_templates.autopistol_control_stat
			}
		}
	},
	autogun_p2_m2_mobility_stat = {
		display_name = "loc_stats_display_mobility_stat",
		is_stat_trait = true,
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat,
				display_data = {
					display_stats = {
						diminishing_return_start = {},
						distance_scale = {},
						speed_modifier = {}
					}
				}
			}
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_stat,
				display_data = {
					display_stats = {
						sprint_speed_mod = {}
					}
				}
			}
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_stat,
				display_data = {
					display_stats = {
						modifier = {}
					}
				}
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

local bespoke_autogun_p2_traits = table.ukeys(WeaponTraitsBespokeAutogunP2)

table.append(weapon_template.traits, bespoke_autogun_p2_traits)

weapon_template.weapon_temperature_settings = {
	increase_rate = 0.075,
	decay_rate = 0.075,
	grace_time = 0.4,
	use_charge = false,
	barrel_threshold = 0.4
}
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
		display_name = "loc_ranged_attack_secondary_braced",
		type = "brace"
	},
	special = {
		desc = "loc_stats_special_action_melee_weapon_bash_desc",
		display_name = "loc_weapon_special_weapon_bash",
		type = "melee_hand"
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
			sub_icon = "full_auto",
			header = "brace"
		},
		{
			value_func = "ammo",
			header = "ammo"
		}
	},
	weapon_special = {
		icon = "melee_hand",
		header = "weapon_bash"
	}
}
weapon_template.explicit_combo = {
	{
		"action_shoot_hip"
	},
	{
		"action_shoot_zoomed"
	}
}
weapon_template.special_action_name = "action_push"

weapon_template.action_inspect_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return false
end

weapon_template.action_alt_inspect_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return false
end

return weapon_template
