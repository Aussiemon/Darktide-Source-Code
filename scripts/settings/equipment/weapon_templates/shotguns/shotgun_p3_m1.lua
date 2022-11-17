local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ShotshellTemplates = require("scripts/settings/projectile/shotshell_templates")
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
	special_action = "stay",
	wield = "stay",
	reload = "stay",
	shoot_pressed = "stay",
	zoom = {
		zoom_release = "base",
		wield = "base",
		zoom_shoot = "stay",
		grenade_ability = "base",
		reload = "base",
		combat_ability = "base"
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
		wield_anim_event = "equip_fast",
		wield_reload_anim_event = "equip_reload",
		kind = "ranged_wield",
		continue_sprinting = true,
		uninterruptible = true,
		total_time = 0.75,
		conditional_state_to_action_input = {
			no_ammo = {
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
				action_name = "action_start_reload",
				chain_time = 0.275
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.5
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.35
			}
		}
	},
	action_shoot_hip = {
		kind = "shoot_pellets",
		start_input = "shoot_pressed",
		sprint_requires_press_to_interrupt = true,
		sprint_ready_up_time = 0.3,
		spread_template = "shotgun_hip_assault",
		weapon_handling_template = "immediate_single_shot",
		uninterruptible = true,
		ammunition_usage = 1,
		total_time = 1.5,
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.05
			},
			{
				modifier = 0.85,
				t = 0.15
			},
			{
				modifier = 0.875,
				t = 0.175
			},
			{
				modifier = 1.1,
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
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_rifle_muzzle",
			shoot_sfx_alias = "ranged_single_shot",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_shotgun_01",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			line_effect = LineEffects.pellet_trail
		},
		fire_configuration = {
			anim_event = "attack_shoot_semi",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.default_shotgun_assault,
			damage_type = damage_types.pellet
		},
		conditional_state_to_action_input = {
			no_ammo = {
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
				action_name = "action_start_reload",
				chain_time = 0.45
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 0.37
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.75
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_shoot_hip_from_reload = {
		ammunition_usage = 1,
		kind = "shoot_pellets",
		weapon_handling_template = "shotgun_from_reload",
		spread_template = "shotgun_hip_assault",
		uninterruptible = true,
		total_time = 1.5,
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.05
			},
			{
				modifier = 0.85,
				t = 0.15
			},
			{
				modifier = 0.875,
				t = 0.175
			},
			{
				modifier = 1.1,
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
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_rifle_muzzle",
			shoot_sfx_alias = "ranged_single_shot",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_shotgun_01",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			line_effect = LineEffects.pellet_trail
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.default_shotgun_assault,
			damage_type = damage_types.pellet
		},
		conditional_state_to_action_input = {
			no_ammo = {
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
				action_name = "action_start_reload"
			},
			shoot_pressed = {
				action_name = "action_shoot_hip",
				chain_time = 1.3
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 1.05
			}
		},
		condition_func = function (action_settings, condition_func_params, used_input)
			local inventory_slot_component = condition_func_params.inventory_slot_component
			local current_clip_amount = inventory_slot_component.current_ammunition_clip

			return current_clip_amount > 0
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_shoot_zoomed = {
		start_input = "zoom_shoot",
		kind = "shoot_pellets",
		weapon_handling_template = "immediate_single_shot",
		spread_template = "default_shotgun_killshot",
		ammunition_usage = 1,
		crosshair_type = "none",
		uninterruptible = true,
		total_time = 1,
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
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/shotgun/shotgun_rifle_muzzle",
			shoot_sfx_alias = "ranged_single_shot",
			shell_casing_effect = "content/fx/particles/weapons/shells/shell_casing_shotgun_01",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			line_effect = LineEffects.pellet_trail
		},
		fire_configuration = {
			anim_event = "attack_shoot_semi",
			same_side_suppression_enabled = false,
			shotshell = ShotshellTemplates.shotgun_killshot,
			damage_type = damage_types.pellet
		},
		conditional_state_to_action_input = {
			no_ammo = {
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
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.37
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.4
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed
		}
	},
	action_zoom = {
		crosshair_type = "none",
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
			zoom_shoot = {
				action_name = "action_shoot_zoomed",
				chain_time = 0.25
			}
		}
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
			}
		}
	},
	action_load_special = {
		anim_event = "load_special",
		crosshair_type = "none",
		start_input = "special_action",
		kind = "dummy",
		total_time = 1.3,
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
				action_name = "action_zoom",
				chain_time = 1.1
			}
		}
	},
	action_start_reload = {
		kind = "reload_shotgun",
		start_input = "reload",
		anim_end_event = "reload_end",
		sprint_requires_press_to_interrupt = true,
		abort_sprint = true,
		crosshair_type = "none",
		allowed_during_sprint = true,
		anim_event = "reload_start",
		stop_alternate_fire = true,
		total_time = 0.95,
		anim_variables_func = function (action_settings, condition_func_params)
			local current_ammunition_clip = condition_func_params.inventory_slot_component.current_ammunition_clip
			local max_ammunition_clip = condition_func_params.inventory_slot_component.max_ammunition_clip

			return "current_clip", current_ammunition_clip, "remaining_clip", max_ammunition_clip - current_ammunition_clip
		end,
		reload_settings = {
			refill_at_time = 0.62,
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
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			shoot_pressed = {
				action_name = "action_shoot_hip_from_reload",
				chain_time = 0.25
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.85
			},
			reload = {
				action_name = "action_reload_loop",
				chain_time = 0.9
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed
		}
	},
	action_reload_loop = {
		anim_end_event = "reload_end",
		kind = "reload_shotgun",
		crosshair_type = "none",
		anim_event = "reload_middle",
		total_time = 0.65,
		anim_variables_func = function (action_settings, condition_func_params)
			local current_ammunition_clip = condition_func_params.inventory_slot_component.current_ammunition_clip
			local max_ammunition_clip = condition_func_params.inventory_slot_component.max_ammunition_clip

			return "current_clip", current_ammunition_clip, "remaining_clip", max_ammunition_clip - current_ammunition_clip
		end,
		reload_settings = {
			refill_at_time = 0.32,
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
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			shoot_pressed = {
				action_name = "action_shoot_hip_from_reload",
				chain_time = 0.25
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0
			},
			reload = {
				action_name = "action_reload_loop",
				chain_time = 0.6
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed
		}
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

weapon_template.entry_actions = {
	primary_action = "action_shoot_hip",
	secondary_action = "action_zoom"
}
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/shotgun_rifle"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/shotgun_rifle"
weapon_template.spread_template = "default_shotgun_assault"
weapon_template.recoil_template = "default_shotgun_assault"
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_ammo",
		input_name = "reload"
	}
}
weapon_template.ammo_template = "shotgun_p1_m1"
weapon_template.uses_ammunition = true
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {
	_muzzle = "fx_muzzle_01",
	_eject = "fx_eject"
}
weapon_template.crosshair_type = "cross"
weapon_template.alternate_fire_settings = {
	recoil_template = "default_shotgun_killshot",
	sway_template = "default_shotgun_killshot",
	stop_anim_event = "to_unaim_ironsight",
	crosshair_type = "none",
	start_anim_event = "to_ironsight",
	spread_template = "default_shotgun_killshot",
	camera = {
		custom_vertical_fov = 35,
		vertical_fov = 55,
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
	"shotgun",
	"p3"
}
weapon_template.crosshair_type = "cross"
weapon_template.hit_marker_type = "center"
weapon_template.dodge_template = "killshot"
weapon_template.sprint_template = "killshot"
weapon_template.stamina_template = "lasrifle"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.killshot

return weapon_template
