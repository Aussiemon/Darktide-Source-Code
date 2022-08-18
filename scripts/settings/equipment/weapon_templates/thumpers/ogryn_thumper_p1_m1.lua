local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ShotshellTemplates = require("scripts/settings/projectile/shotshell_templates")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
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
		kind = "shoot_pellets",
		start_input = "shoot_pressed",
		weapon_handling_template = "immediate_single_shot",
		ammunition_usage = 1,
		uninterruptible = true,
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
				modifier = 0.7,
				t = 0.3
			},
			{
				modifier = 0.8,
				t = 0.5
			},
			start_modifier = 0.3
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/combat_shotgun_ogryn_muzzle",
			shoot_sfx_alias = "ranged_single_shot",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo"
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.default_thumper_assault,
			damage_type = damage_types.rippergun_pellet
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
				action_name = "action_reload"
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.4
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.4
			},
			bash = {
				action_name = "action_bash",
				chain_time = 0.1
			}
		},
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_zoom = {
		crosshair_type = "shotgun",
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
		crosshair_type = "shotgun",
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
		allowed_during_sprint = false,
		kind = "shoot_pellets",
		weapon_handling_template = "immediate_single_shot",
		ammunition_usage = 1,
		crosshair_type = "shotgun",
		uninterruptible = true,
		total_time = 0.75,
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
				chain_time = 0.4
			},
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 1.05
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.2
			},
			bash = {
				action_name = "action_bash",
				chain_time = 0.1
			}
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/combat_shotgun_ogryn_muzzle",
			shoot_sfx_alias = "ranged_single_shot",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo"
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.default_thumper_assault,
			damage_type = damage_types.rippergun_pellet
		},
		conditional_state_to_action_input = {
			no_ammo = {
				input_name = "reload"
			}
		},
		action_keywords = {
			"braced",
			"braced_shooting"
		},
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_reload = {
		stop_alternate_fire = true,
		start_input = "reload",
		uninterruptible = true,
		kind = "reload_state",
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
				action_name = "action_bash",
				chain_until = 0.3
			}
		},
		stat_buff_keywords = {
			buff_stat_buffs.reload_speed
		}
	},
	action_bash = {
		damage_window_start = 0.5666666666666667,
		allow_conditional_chain = true,
		start_input = "bash",
		range_mod = 1.15,
		kind = "sweep",
		attack_direction_override = "left",
		anim_event = "attack_bash",
		damage_window_end = 0.7,
		unaim = true,
		uninterruptible = true,
		power_level = 500,
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
				action_name = "action_reload"
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 1.1
			},
			bash = {
				action_name = "action_bash_right",
				chain_time = 0.8
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.8
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
		range_mod = 1.15,
		kind = "sweep",
		attack_direction_override = "right",
		damage_window_end = 0.7333333333333333,
		uninterruptible = true,
		anim_event = "attack_bash_right",
		power_level = 500,
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
				action_name = "action_reload"
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 1.1
			},
			bash = {
				action_name = "action_bash",
				chain_time = 1
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.8
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

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/ogryn/third_person/animations/shotgun_grenade"
weapon_template.anim_state_machine_1p = "content/characters/player/ogryn/first_person/animations/shotgun_grenade"
weapon_template.alternate_fire_settings = {
	crosshair_type = "shotgun",
	toughness_template = "killshot_zoomed",
	stop_anim_event = "to_unaim_braced",
	start_anim_event = "to_braced",
	spread_template = "thumper_shotgun_aim",
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
weapon_template.spread_template = "thumper_shotgun_hip_assault"
weapon_template.recoil_template = "default_thumper_assault"
weapon_template.reload_template = ReloadTemplates.ogryn_thumper
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_ammo",
		input_name = "reload"
	}
}
weapon_template.sprint_ready_up_time = 0.3
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.uses_ammunition = true
weapon_template.uses_overheat = false
weapon_template.ammo_template = "ogryn_thumper_p1_m1"
weapon_template.fx_sources = {
	_muzzle = "ap_bullet_02",
	_sweep = "fx_sweep"
}
weapon_template.crosshair_type = "shotgun"
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"ranged",
	"shotgun_grenade",
	"p1"
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = {
	crouch_walking = 0.73,
	walking = 0.58,
	sprinting = 0.53
}

return weapon_template
