local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local FlamerGasTemplates = require("scripts/settings/projectile/flamer_gas_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local WeaponTraitsBespokeFlamerP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_flamer_p1")
local WeaponTraitsRangedCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_common")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local template_types = WeaponTweakTemplateSettings.template_types
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local buff_stat_buffs = BuffSettings.stat_buffs
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
			buffer_time = 0.1,
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
			buffer_time = 0.41,
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
			special_action = "previous",
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
		wield_reload_anim_event = "equip_reload",
		allowed_during_sprint = true,
		wield_anim_event = "equip",
		uninterruptible = true,
		kind = "ranged_wield",
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
			reload = {
				action_name = "action_reload",
				chain_time = 0.8
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
		kind = "flamer_gas_burst",
		start_input = "shoot_pressed",
		sprint_requires_press_to_interrupt = true,
		weapon_handling_template = "flamer_burst",
		sprint_ready_up_time = 0.25,
		ignore_shooting_look_delta_anim_control = true,
		allowed_during_sprint = true,
		ammunition_usage = 1,
		first_shot_only_sound_reflection = true,
		sensitivity_modifier = 0.5,
		abort_sprint = true,
		anim_event = "attack_shoot_start",
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
				speed = 35,
				name = "content/fx/particles/weapons/rifles/player_flamer/flamer_code_control_burst",
				name_3p = "content/fx/particles/weapons/rifles/player_flamer/flamer_code_control_3p"
			}
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			flamer_gas_template = FlamerGasTemplates.burst,
			damage_type = damage_types.burning
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
				chain_time = 0.5
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return false
		end
	},
	action_shoot_braced = {
		kind = "flamer_gas",
		start_input = "shoot_braced",
		ignore_shooting_look_delta_anim_control = true,
		weapon_handling_template = "flamer_auto",
		sprint_ready_up_time = 0,
		minimum_hold_time = 0.4,
		first_shot_only_sound_reflection = true,
		anim_end_event = "attack_finished",
		allowed_during_sprint = true,
		ammunition_usage = 1,
		action_prevents_jump = true,
		anim_event = "attack_shoot",
		stop_input = "shoot_braced_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.1,
				t = 0.35
			},
			{
				modifier = 0.2,
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
			start_modifier = 0.5
		},
		fx = {
			pre_shoot_sfx_alias = "ranged_pre_shoot",
			stop_looping_3d_sound_effect = "wwise/events/weapon/stop_flamethrower_fire_loop_3d",
			looping_shoot_sfx_alias = "ranged_shooting",
			impact_effect = "content/fx/particles/weapons/rifles/zealot_flamer/zealot_flamer_impact_delay",
			pre_shoot_abort_sfx_alias = "ranged_abort",
			looping_3d_sound_effect = "wwise/events/weapon/play_flamethrower_fire_loop_3d",
			stream_effect = {
				speed = 45,
				name = "content/fx/particles/weapons/rifles/player_flamer/flamer_code_control",
				name_3p = "content/fx/particles/weapons/rifles/player_flamer/flamer_code_control_3p"
			}
		},
		fire_configuration = {
			flamer_gas_template = FlamerGasTemplates.auto,
			damage_type = damage_types.burning
		},
		running_action_state_to_action_input = {
			clip_empty = {
				input_name = "reload"
			},
			reserve_empty = {
				input_name = "shoot_braced_release"
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
				chain_time = 0.4
			}
		},
		action_keywords = {
			"braced",
			"braced_shooting"
		}
	},
	action_brace = {
		action_prevents_jump = true,
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
				chain_time = 0.2
			},
			shoot_braced = {
				action_name = "action_shoot_braced",
				chain_time = 0.6
			},
			brace_release = {
				action_name = "action_unbrace",
				chain_time = 0.5
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
		total_time = 0.5,
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
				chain_time = 0.45
			},
			special_action = {
				action_name = "push",
				chain_time = 0.25
			}
		}
	},
	action_reload = {
		kind = "reload_state",
		start_input = "reload",
		sprint_requires_press_to_interrupt = true,
		stop_alternate_fire = true,
		abort_sprint = true,
		crosshair_type = "none",
		allowed_during_sprint = true,
		total_time = 4,
		action_movement_curve = {
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
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed
		}
	},
	push = {
		crosshair_type = "dot",
		push_radius = 1.5,
		start_input = "special_action",
		block_duration = 0.5,
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
				chain_time = 0.6
			},
			brace_release = {
				action_name = "action_unbrace",
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
		inner_damage_type = damage_types.weapon_butt,
		outer_damage_profile = DamageProfileTemplates.weapon_special_push_outer,
		outer_damage_type = damage_types.weapon_butt
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
		conditional_state = "no_ammo_with_delay",
		input_name = "reload"
	}
}
weapon_template.no_ammo_delay = 0.4
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
			modifier = 0.85,
			t = 0.05
		},
		{
			modifier = 0.75,
			t = 0.075
		},
		{
			modifier = 0.6,
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
local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")
weapon_template.base_stats = {
	flamer_p1_m1_ammo_stat = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.flamer_p1_m1_ammo_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		}
	},
	flamer_p1_m1_mobility_stat = {
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
		}
	},
	flamer_p1_m1_burninating_stat = {
		display_name = "loc_stats_display_burn_stat",
		is_stat_trait = true,
		burninating = {
			base = {
				burninating_trait_templates.flamer_p1_m1_burninating_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		}
	},
	flamer_p1_m1_damage_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		weapon_handling = {
			action_shoot = {
				weapon_handling_trait_templates.flamer_p1_m1_ramp_up_stat,
				display_data = {
					prefix = "loc_ingame_action_one",
					display_stats = {
						__all_basic_stats = true
					},
					display_group_stats = {
						flamer_ramp_up_times = {}
					}
				}
			},
			action_shoot_braced = {
				weapon_handling_trait_templates.flamer_p1_m1_ramp_up_stat,
				display_data = {
					prefix = "loc_weapon_stats_display_braced",
					display_stats = {
						__all_basic_stats = true
					},
					display_group_stats = {
						flamer_ramp_up_times = {}
					}
				}
			}
		},
		damage = {
			action_shoot = {
				damage_trait_templates.flamer_p1_m1_braced_dps_stat,
				display_data = {
					display_stats = {
						targets = {
							{
								power_distribution = {
									attack = {
										display_name = "loc_weapon_stats_display_hip_fire"
									}
								}
							}
						}
					}
				}
			},
			action_shoot_braced = {
				damage_trait_templates.flamer_p1_m1_braced_dps_stat,
				display_data = {
					display_stats = {
						targets = {
							{
								power_distribution = {
									attack = {
										display_name = "loc_weapon_stats_display_braced_damage"
									}
								}
							}
						}
					}
				}
			}
		}
	},
	flamer_p1_m1_size_of_flame_stat = {
		display_name = "loc_stats_display_flame_size_stat",
		is_stat_trait = true,
		size_of_flame = {
			base = {
				size_of_flame_trait_templates.flamer_p1_m1_size_of_flame_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		}
	}
}
weapon_template.traits = {}
local ranged_common_traits = table.keys(WeaponTraitsRangedCommon)

table.append(weapon_template.traits, ranged_common_traits)

local bespoke_forcestaff_p1_traits = table.keys(WeaponTraitsBespokeFlamerP1)

table.append(weapon_template.traits, bespoke_forcestaff_p1_traits)

weapon_template.perks = {
	flamer_p1_m1_ammo_perk = {
		display_name = "loc_trait_display_flamer_p1_m1_ammo_perk",
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_perk
			}
		}
	},
	flamer_p1_m1_mobility_perk = {
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
		display_name = "loc_trait_display_flamer_p1_m1_burninating_perk",
		burninating = {
			base = {
				burninating_trait_templates.flamer_p1_m1_burninating_perk
			}
		}
	},
	flamer_p1_m1_damage_perk = {
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
		display_name = "loc_trait_display_flamer_p1_m1_range_perk",
		size_of_flame = {
			base = {
				size_of_flame_trait_templates.flamer_p1_m1_range_perk
			}
		}
	},
	flamer_p1_m1_spread_angle_perk = {
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
		display_name = "loc_weapon_keyword_spray_n_pray"
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
		desc = "loc_stats_special_action_melee_weapon_bash_desc",
		display_name = "loc_weapon_special_weapon_bash",
		type = "melee"
	}
}
weapon_template.special_action_name = "push"

return weapon_template
