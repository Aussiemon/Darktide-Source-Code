local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local FlamerGasTemplates = require("scripts/settings/projectile/flamer_gas_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local WeaponTraitsRangedCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_common")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local template_types = WeaponTweakTemplateSettings.template_types
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local ammo_trait_templates = WeaponTraitTemplates[template_types.ammo]
local burninating_trait_templates = WeaponTraitTemplates[template_types.burninating]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local size_of_flame_trait_templates = WeaponTraitTemplates[template_types.size_of_flame]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
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
		brace_pressed = {
			buffer_time = 0,
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
		shoot_braced = {
			buffer_time = 0.25,
			input_sequence = {
				{
					value = true,
					input = "action_one_hold"
				}
			}
		},
		shoot_braced_release = {
			buffer_time = 0.26,
			input_sequence = {
				{
					value = false,
					input = "action_one_hold",
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
	special_action = "base",
	wield = "stay",
	shoot_pressed = "stay",
	reload = "base",
	brace_pressed = {
		special_action = "stay",
		brace_release = "base",
		grenade_ability = "base",
		wield = "base",
		reload = "base",
		combat_ability = "base",
		shoot_braced = {
			shoot_braced_release = "previous",
			wield = "base",
			brace_release = "base",
			special_action = "base",
			reload = "base"
		}
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
		total_time = 1.7,
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
			brace_pressed = {
				action_name = "action_brace",
				chain_time = 1.35
			},
			shoot_pressed = {
				action_name = "action_shoot",
				chain_time = 1.35
			}
		}
	},
	action_shoot = {
		ammunition_usage = 1,
		weapon_handling_template = "flamer_burst",
		first_shot_only_sound_reflection = true,
		kind = "flamer_gas_burst",
		sprint_ready_up_time = 0.25,
		abort_sprint = true,
		start_input = "shoot_pressed",
		allowed_during_sprint = true,
		sprint_requires_press_to_interrupt = true,
		ignore_shooting_look_delta_anim_control = true,
		total_time = 0.75,
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2
			},
			{
				modifier = 0.9,
				t = 0.3
			},
			{
				modifier = 1,
				t = 0.5
			},
			start_modifier = 0.5
		},
		fx = {
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			stop_looping_3d_sound_effect = "wwise/events/weapon/stop_flamethrower_fire_loop_3d",
			looping_shoot_sfx_alias = "ranged_shooting",
			pre_shoot_abort_sfx_alias = "ranged_abort",
			pre_shoot_sfx_alias = "ranged_pre_shoot",
			impact_effect = "content/fx/particles/weapons/rifles/zealot_flamer/zealot_flamer_impact_delay",
			looping_3d_sound_effect = "wwise/events/weapon/play_flamethrower_fire_loop_3d",
			duration = 0.3,
			stream_effect = {
				speed = 23,
				name = "content/fx/particles/weapons/rifles/zealot_flamer/zealot_flamer_code_control",
				name_3p = "content/fx/particles/weapons/rifles/zealot_flamer/zealot_flamer_code_control_3p"
			}
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			flamer_gas_template = FlamerGasTemplates.burst,
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
			brace_pressed = {
				action_name = "action_brace"
			},
			reload = {
				action_name = "action_reload"
			},
			special_action = {
				action_name = "push",
				chain_time = 0.8
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return false
		end
	},
	action_shoot_braced = {
		kind = "flamer_gas",
		start_input = "shoot_braced",
		first_shot_only_sound_reflection = true,
		weapon_handling_template = "flamer_auto",
		sprint_ready_up_time = 0,
		ammunition_usage = 1,
		anim_end_event = "attack_finished",
		allowed_during_sprint = true,
		ignore_shooting_look_delta_anim_control = true,
		anim_event = "attack_shoot",
		stop_input = "shoot_braced_release",
		total_time = math.huge,
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
				modifier = 0.25,
				t = 0.75
			},
			{
				modifier = 0.5,
				t = 5
			},
			start_modifier = 0.1
		},
		fx = {
			pre_shoot_sfx_alias = "ranged_pre_shoot",
			stop_looping_3d_sound_effect = "wwise/events/weapon/stop_flamethrower_fire_loop_3d",
			looping_shoot_sfx_alias = "ranged_shooting",
			impact_effect = "content/fx/particles/weapons/rifles/zealot_flamer/zealot_flamer_impact_delay",
			pre_shoot_abort_sfx_alias = "ranged_abort",
			looping_3d_sound_effect = "wwise/events/weapon/play_flamethrower_fire_loop_3d",
			stream_effect = {
				speed = 15,
				name = "content/fx/particles/weapons/rifles/zealot_flamer/zealot_flamer_code_control",
				name_3p = "content/fx/particles/weapons/rifles/zealot_flamer/zealot_flamer_code_control_3p"
			}
		},
		fire_configuration = {
			flamer_gas_template = FlamerGasTemplates.auto,
			damage_type = damage_types.plasma
		},
		running_action_state_to_action_input = {
			clip_empty = {
				input_name = "reload"
			},
			reserve_empty = {
				input_name = "brace_release"
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
			brace_release = {
				action_name = "action_unbrace",
				chain_time = 0
			},
			special_action = {
				action_name = "push",
				chain_time = 0.8
			}
		},
		action_keywords = {
			"braced",
			"braced_shooting"
		}
	},
	action_brace = {
		start_input = "brace_pressed",
		kind = "aim",
		total_time = 1.35,
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_slow_brace,
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
			shoot_braced = {
				action_name = "action_shoot_braced",
				chain_time = 0.6
			},
			brace_release = {
				action_name = "action_unbrace",
				chain_time = 0
			},
			special_action = {
				action_name = "push",
				chain_time = 0.4
			}
		},
		action_keywords = {
			"braced"
		}
	},
	action_unbrace = {
		kind = "unaim",
		start_input = "brace_release",
		total_time = 0.35,
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
				chain_time = 0.25
			},
			brace_pressed = {
				action_name = "action_brace",
				chain_time = 1
			}
		}
	},
	action_reload = {
		kind = "reload_state",
		stop_alternate_fire = true,
		start_input = "reload",
		sprint_requires_press_to_interrupt = true,
		abort_sprint = true,
		crosshair_type = "dot",
		allowed_during_sprint = true,
		total_time = 4,
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
	push = {
		block_duration = 0.5,
		push_radius = 1.5,
		start_input = "special_action",
		kind = "push",
		damage_time = 0.2,
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
			special_action = {
				action_name = "push",
				chain_time = 0.9
			},
			brace_pressed = {
				action_name = "action_brace",
				chain_time = 0.4
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.4
			},
			shoot_pressed = {
				action_name = "action_shoot",
				chain_time = 0.6
			}
		},
		inner_push_rad = math.pi * 0.1,
		outer_push_rad = math.pi * 0.2,
		inner_damage_profile = DamageProfileTemplates.weapon_special_push,
		inner_damage_type = damage_types.blunt_heavy,
		outer_damage_profile = DamageProfileTemplates.weapon_special_push_outer,
		outer_damage_type = damage_types.blunt_heavy
	},
	action_inspect = {
		skip_3p_anims = true,
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

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/flamer_rifle"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/flamer_rifle"
weapon_template.reload_template = ReloadTemplates.flamer_rifle
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
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.ammo_template = "flamer_p1_m1"
weapon_template.burninating_template = "flamer_p1_m1"
weapon_template.size_of_flame_template = "flamer_p1_m1"
weapon_template.fx_sources = {
	_muzzle = "fx_muzzle_02",
	_pilot = "fx_pilot"
}
weapon_template.crosshair_type = "spray_n_pray"
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	crosshair_type = "spray_n_pray",
	sway_template = "default_lasgun_killshot",
	stop_anim_event = "to_unaim_braced",
	uninterruptible = false,
	start_anim_event = "to_braced",
	look_delta_template = "lasgun_brace_light",
	movement_speed_modifier = {
		{
			modifier = 0.175,
			t = 0.05
		},
		{
			modifier = 0.25,
			t = 0.075
		},
		{
			modifier = 0.29,
			t = 0.25
		},
		{
			modifier = 0.3,
			t = 0.3
		},
		{
			modifier = 0.4,
			t = 0.4
		},
		{
			modifier = 0.5,
			t = 0.5
		},
		{
			modifier = 0.55,
			t = 2
		}
	}
}
weapon_template.keywords = {
	"ranged",
	"flamer",
	"p1"
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.dodge_template = "plasma_rifle"
weapon_template.sprint_template = "support"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.overclocks = {
	ammo_up_size_of_flame_down = {
		flamer_p1_m1_size_of_flame_stat = -0.1,
		flamer_p1_m1_ammo_stat = 0.1
	},
	mobility_up_ammo_down = {
		flamer_p1_m1_mobility_stat = 0.2,
		flamer_p1_m1_ammo_stat = -0.2
	},
	damage_up_size_of_flame_down = {
		flamer_p1_m1_damage_stat = 0.1,
		flamer_p1_m1_size_of_flame_stat = -0.2
	},
	burninating_up_damage_down = {
		flamer_p1_m1_burninating_stat = 0.2,
		flamer_p1_m1_damage_stat = -0.1
	},
	size_of_flame_up_mobility_down = {
		flamer_p1_m1_size_of_flame_stat = 0.1,
		flamer_p1_m1_mobility_stat = -0.1
	}
}
weapon_template.base_stats = {
	flamer_p1_m1_ammo_stat = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.flamer_p1_m1_ammo_stat
			}
		}
	},
	flamer_p1_m1_mobility_stat = {
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
	flamer_p1_m1_burninating_stat = {
		display_name = "loc_stats_display_burn_stat",
		is_stat_trait = true,
		burninating = {
			base = {
				burninating_trait_templates.flamer_p1_m1_burninating_stat
			}
		}
	},
	flamer_p1_m1_damage_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		weapon_handling = {
			action_shoot_braced = {
				weapon_handling_trait_templates.flamer_p1_m1_ramp_up_stat
			}
		},
		damage = {
			action_shoot_braced = {
				damage_trait_templates.flamer_p1_m1_braced_dps_stat
			}
		}
	},
	flamer_p1_m1_size_of_flame_stat = {
		display_name = "loc_stats_display_flame_size_stat",
		is_stat_trait = true,
		size_of_flame = {
			base = {
				size_of_flame_trait_templates.flamer_p1_m1_size_of_flame_stat
			}
		}
	}
}
weapon_template.traits = {}
weapon_template.perks = {
	flamer_p1_m1_ammo_perk = {
		description = "loc_trait_description_flamer_p1_m1_ammo_perk",
		display_name = "loc_trait_display_flamer_p1_m1_ammo_perk",
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_perk
			}
		}
	},
	flamer_p1_m1_mobility_perk = {
		description = "loc_trait_description_flamer_p1_m1_mobility_perk",
		display_name = "loc_trait_display_flamer_p1_m1_mobility_perk",
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
		}
	},
	flamer_p1_m1_burninating_perk = {
		description = "loc_trait_description_flamer_p1_m1_burninating_perk",
		display_name = "loc_trait_display_flamer_p1_m1_burninating_perk",
		burninating = {
			base = {
				burninating_trait_templates.flamer_p1_m1_burninating_perk
			}
		}
	},
	flamer_p1_m1_damage_perk = {
		description = "loc_trait_description_flamer_p1_m1_damage_perk",
		display_name = "loc_trait_display_flamer_p1_m1_damage_perk",
		weapon_handling = {
			action_shoot_braced = {
				weapon_handling_trait_templates.flamer_p1_m1_ramp_up_perk
			}
		},
		damage = {
			action_shoot_braced = {
				damage_trait_templates.flamer_p1_m1_braced_dps_perk
			}
		}
	},
	flamer_p1_m1_range_perk = {
		description = "loc_trait_description_flamer_p1_m1_range_perk",
		display_name = "loc_trait_display_flamer_p1_m1_range_perk",
		size_of_flame = {
			base = {
				size_of_flame_trait_templates.flamer_p1_m1_range_perk
			}
		}
	},
	flamer_p1_m1_spread_angle_perk = {
		description = "loc_trait_description_flamer_p1_m1_spread_angle_perk",
		display_name = "loc_trait_display_flamer_p1_m1_spread_angle_perk",
		size_of_flame = {
			base = {
				size_of_flame_trait_templates.flamer_p1_m1_spread_angle_perk
			}
		}
	}
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_crowd_control"
	},
	{
		display_name = "loc_weapon_keyword_close_combat"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		fire_mode = "semi_auto",
		display_name = "loc_ranged_attack_primary",
		type = "hipfire"
	},
	secondary = {
		fire_mode = "full_auto",
		display_name = "loc_ranged_attack_secondary_braced",
		type = "brace"
	},
	special = {
		display_name = "loc_weapon_special_weapon_bash",
		type = "melee"
	}
}
weapon_template.displayed_attack_ranges = {
	max = 20,
	min = 5
}
weapon_template.traits = {}
local ranged_common_traits = table.keys(WeaponTraitsRangedCommon)

table.append(weapon_template.traits, ranged_common_traits)

return weapon_template
