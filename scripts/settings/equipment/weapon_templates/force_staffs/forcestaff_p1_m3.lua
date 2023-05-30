local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local template_types = WeaponTweakTemplateSettings.template_types
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local explosion_trait_templates = WeaponTraitTemplates[template_types.explosion]
local charge_trait_templates = WeaponTraitTemplates[template_types.charge]
local warp_charge_trait_templates = WeaponTraitTemplates[template_types.warp_charge]
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {
	smart_targeting_template = SmartTargetingTemplates.force_staff_single_target,
	action_inputs = {
		shoot_pressed = {
			buffer_time = 0.15,
			max_queue = 2,
			input_sequence = {
				{
					value = true,
					input = "action_one_pressed"
				}
			}
		},
		charge_explosion = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = true,
					input = "action_two_hold"
				}
			}
		},
		charge_explosion_release = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = false,
					input = "action_two_hold",
					time_window = math.huge
				}
			}
		},
		trigger_explosion = {
			buffer_time = 0.5,
			input_sequence = {
				{
					value = true,
					hold_input = "action_two_hold",
					input = "action_one_pressed"
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
		vent = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					value = true,
					input = "weapon_reload_hold"
				}
			}
		},
		vent_release = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = false,
					input = "weapon_reload_hold",
					time_window = math.huge
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
	bash = "stay",
	shoot_pressed = "stay",
	charge_explosion = {
		grenade_ability = "base",
		wield = "base",
		trigger_explosion = "base",
		charge_explosion_release = "base",
		combat_ability = "base"
	},
	vent = {
		wield = "base",
		vent_release = "base",
		combat_ability = "base",
		grenade_ability = "base"
	}
}

table.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

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
		allowed_chain_actions = {
			bash = {
				action_name = "action_bash",
				chain_time = 0.6
			},
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
	rapid_left = {
		projectile_item = "content/items/weapons/player/grenade_krak",
		start_input = "shoot_pressed",
		sprint_requires_press_to_interrupt = true,
		charge_template = "forcestaff_p1_m1_projectile",
		vfx_effect_name = "content/fx/particles/weapons/force_staff/force_staff_projectile_cast_01",
		anim_event = "orb_shoot",
		fire_time = 0.2,
		uninterruptible = true,
		vfx_effect_source_name = "fx_left_forearm",
		kind = "spawn_projectile",
		anim_time_scale = 1.5,
		total_time = 1,
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2
			},
			{
				modifier = 1.1,
				t = 0.3
			},
			{
				modifier = 1,
				t = 0.5
			},
			start_modifier = 0.8
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			shoot_pressed = {
				action_name = "rapid_left",
				chain_time = 0.45
			},
			charge_explosion = {
				action_name = "action_charge_explosion"
			}
		},
		fx = {
			shoot_sfx_alias = "ranged_single_shot"
		},
		projectile_template = ProjectileTemplates.force_staff_ball
	},
	action_charge_explosion = {
		position_finder_module_class_name = "ballistic_raycast_position_finder",
		sprint_requires_press_to_interrupt = true,
		start_input = "charge_explosion",
		allowed_during_sprint = false,
		kind = "overload_charge_position_finder",
		sprint_ready_up_time = 0.25,
		min_scale = 0,
		anim_end_event = "attack_finished",
		overload_module_class_name = "warp_charge",
		max_scale = 5,
		charge_template = "forcestaff_p1_m1_charge_aoe",
		anim_event = "explosion_start",
		stop_input = "charge_explosion_release",
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
		position_finder_fx = {
			decal_unit_name = "content/fx/units/weapons/decal_force_staff_explosion_marker",
			wwise_event_stop = "wwise/events/weapon/stop_force_staff_charge_loop",
			scale_variable_name = "radius",
			has_husk_events = true,
			scaling_effect_name_3p = "content/fx/particles/weapons/force_staff/3p_force_staff_explosion_indicator",
			wwise_parameter_name = "charge_level",
			wwise_event_start = "wwise/events/weapon/play_force_staff_charge_loop",
			decal_unit_name_3p = "content/fx/units/weapons/decal_force_staff_explosion_marker_3p",
			scaling_effect_name = "content/fx/particles/weapons/force_staff/force_staff_explosion_indicator"
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
			trigger_explosion = {
				action_name = "action_trigger_explosion",
				chain_time = 0.5
			},
			bash = {
				action_name = "action_bash",
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
	action_trigger_explosion = {
		use_charge = true,
		charge_template = "forcestaff_p1_m1_use_aoe",
		kind = "explosion",
		sprint_ready_up_time = 0,
		allowed_during_sprint = true,
		anim_event = "explosion_explode",
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
		explosion_template = ExplosionTemplates.default_force_staff_demolition,
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
				action_name = "rapid_left",
				chain_time = 0.6
			},
			charge_explosion = {
				action_name = "action_charge_explosion",
				chain_time = 0.6
			},
			bash = {
				action_name = "action_bash",
				chain_time = 0.2
			}
		}
	},
	action_bash = {
		damage_window_start = 0.16666666666666666,
		hit_armor_anim = "hit_stop",
		start_input = "bash",
		range_mod = 1.15,
		kind = "sweep",
		first_person_hit_stop_anim = "hit_stop",
		allow_conditional_chain = true,
		damage_window_end = 0.3,
		uninterruptible = true,
		anim_event = "attack_special",
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
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15
			},
			bash = {
				action_name = "action_bash",
				chain_time = 0.9
			},
			shoot_pressed = {
				action_name = "rapid_left",
				chain_time = 1
			}
		},
		weapon_box = {
			0.2,
			1.5,
			0.1
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/force_staff/special_melee",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_type = damage_types.blunt_light,
		damage_profile = DamageProfileTemplates.force_staff_bash,
		herding_template = HerdingTemplates.smiter_down
	},
	action_vent = {
		allowed_during_sprint = true,
		start_input = "vent",
		anim_end_event = "vent_end",
		kind = "vent_warp_charge",
		vent_vfx = "content/fx/particles/abilities/psyker_venting",
		vo_tag = "ability_venting",
		vent_source_name = "fx_left_hand",
		abort_sprint = true,
		prevent_sprint = true,
		uninterruptible = true,
		anim_event = "vent_start",
		stop_input = "vent_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.4,
				t = 0.1
			},
			{
				modifier = 0.3,
				t = 0.15
			},
			{
				modifier = 0.2,
				t = 0.2
			},
			{
				modifier = 0.01,
				t = 5
			},
			start_modifier = 1
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
			},
			bash = {
				action_name = "action_bash",
				chain_time = 0.4
			},
			shoot_pressed = {
				action_name = "rapid_left",
				chain_time = 0.4
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

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/force_staff"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/force_staff"
weapon_template.spread_template = "default_force_staff_killshot"
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_overheat = "fx_overheat",
	_muzzle = "fx_overheat"
}
weapon_template.crosshair_type = "dot"
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"ranged",
	"force_staff",
	"p1"
}
weapon_template.dodge_template = "killshot"
weapon_template.sprint_template = "support"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.warp_charge_template = "forcestaff_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.overclocks = {}
weapon_template.base_stats = {
	forcestaff_p1_m1_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			rapid_left = {
				damage_trait_templates.forcestaff_p1_m1_dps_stat,
				display_data = {
					display_stats = {
						power_distribution = {
							attack = {}
						}
					}
				}
			}
		}
	},
	forcestaff_p1_m1_explosion_size_stat = {
		display_name = "loc_stats_display_explosion_stat",
		is_stat_trait = true,
		explosion = {
			action_trigger_explosion = {
				explosion_trait_templates.forcestaff_p1_m1_explosion_size_stat,
				display_data = {
					display_stats = {
						radius = {},
						close_radius = {}
					}
				}
			}
		}
	},
	forcestaff_p1_m1_vent_speed_stat = {
		display_name = "loc_stats_display_vent_speed",
		is_stat_trait = true,
		warp_charge = {
			base = {
				warp_charge_trait_templates.forcestaff_p1_m1_vent_speed_stat,
				display_data = {
					display_stats = {
						vent_duration_modifier = {},
						auto_vent_duration_modifier = {}
					}
				}
			}
		}
	},
	forcestaff_p1_m1_charge_speed_stat = {
		display_name = "loc_stats_display_charge_speed",
		is_stat_trait = true,
		charge = {
			rapid_left = {
				charge_trait_templates.forcestaff_p1_m1_charge_speed_stat,
				display_data = {
					prefix = "loc_ingame_action_one",
					display_stats = {
						charge_duration = {}
					}
				}
			},
			action_charge_explosion = {
				charge_trait_templates.forcestaff_p1_m1_charge_speed_stat,
				display_data = {
					prefix = "loc_ingame_action_two",
					display_stats = {
						charge_duration = {}
					}
				}
			}
		}
	},
	forcestaff_p1_m1_warp_charge_cost_stat = {
		display_name = "loc_stats_display_warp_resist_stat",
		is_stat_trait = true,
		charge = {
			rapid_left = {
				charge_trait_templates.forcestaff_p1_m1_warp_charge_cost_stat,
				display_data = {
					prefix = "loc_ingame_action_one",
					display_stats = {
						warp_charge_percent = {}
					}
				}
			},
			action_charge_explosion = {
				charge_trait_templates.forcestaff_p1_m1_warp_charge_cost_stat,
				display_data = {
					prefix = "loc_ingame_action_two",
					display_stats = {
						warp_charge_percent = {}
					}
				}
			}
		}
	}
}
weapon_template.traits = {}
weapon_template.perks = {
	forcestaff_p1_m1_dps_perk = {
		display_name = "loc_trait_display_forcestaff_p1_m1_dps_perk",
		damage = {
			rapid_left = {
				damage_trait_templates.forcestaff_p1_m1_dps_perk
			}
		}
	},
	forcestaff_p1_m1_explosion_size_perk = {
		display_name = "loc_trait_display_forcestaff_p1_m1_explosion_size_perk",
		explosion = {
			action_trigger_explosion = {
				explosion_trait_templates.forcestaff_p1_m1_explosion_size_perk
			}
		}
	},
	forcestaff_p1_m1_vent_speed_perk = {
		warp_charge = {
			base = {
				warp_charge_trait_templates.forcestaff_p1_m1_vent_speed_perk
			}
		}
	},
	forcestaff_p1_m1_charge_speed_perk = {
		display_name = "loc_trait_display_forcestaff_p1_m1_charge_speed_perk",
		charge = {
			rapid_left = {
				charge_trait_templates.forcestaff_p1_m1_charge_speed_perk
			},
			action_charge_explosion = {
				charge_trait_templates.forcestaff_p1_m1_charge_speed_perk
			}
		}
	},
	forcestaff_p1_m1_warp_charge_cost_perk = {
		display_name = "loc_trait_display_forcestaff_p1_m1_warp_charge_cost_perk",
		charge = {
			rapid_left = {
				charge_trait_templates.forcestaff_p1_m1_warp_charge_cost_perk
			},
			action_charge_explosion = {
				charge_trait_templates.forcestaff_p1_m1_warp_charge_cost_perk
			}
		}
	}
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_warp_weapon"
	},
	{
		display_name = "loc_weapon_keyword_charged_attack"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		fire_mode = "projectile",
		display_name = "loc_forcestaff_p1_m1_attack_primary",
		type = "hipfire"
	},
	secondary = {
		display_name = "loc_forcestaff_p1_m1_attack_secondary",
		type = "charge"
	},
	special = {
		desc = "loc_stats_special_action_melee_weapon_bash_forcestaff_desc",
		display_name = "loc_forcestaff_p1_m1_attack_special",
		type = "melee_hand"
	}
}

return weapon_template
