local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local WeaponTraitsOgrynGauntletP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_gauntlet_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_types = ArmorSettings.types
local template_types = WeaponTweakTemplateSettings.template_types
local ammo_trait_templates = WeaponTraitTemplates[template_types.ammo]
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local explosion_trait_templates = WeaponTraitTemplates[template_types.explosion]
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {}
local wounds_shapes = WoundsSettings.shapes
weapon_template.action_inputs = {
	start_attack = {
		buffer_time = 0.75,
		max_queue = 1,
		input_sequence = {
			{
				value = true,
				input = "action_one_pressed"
			}
		}
	},
	attack_cancel = {
		buffer_time = 0.1,
		input_sequence = {
			{
				value = true,
				hold_input = "action_one_hold",
				input = "action_two_pressed"
			}
		}
	},
	light_attack = {
		buffer_time = 0.3,
		max_queue = 1,
		input_sequence = {
			{
				value = false,
				time_window = 0.25,
				input = "action_one_hold"
			}
		}
	},
	heavy_attack = {
		buffer_time = 0.5,
		max_queue = 1,
		input_sequence = {
			{
				value = true,
				duration = 0.25,
				input = "action_one_hold"
			},
			{
				value = false,
				time_window = 1.5,
				auto_complete = true,
				input = "action_one_hold"
			}
		}
	},
	special_action_start = {
		buffer_time = 0.2,
		input_sequence = {
			{
				value = true,
				input = "weapon_extra_pressed"
			}
		}
	},
	special_action_execute = {
		buffer_time = 0.2,
		input_sequence = {
			{
				value = true,
				duration = 0,
				input = "weapon_extra_hold"
			},
			{
				value = false,
				time_window = 2.8,
				auto_complete = true,
				input = "weapon_extra_hold"
			}
		}
	},
	zoom_shoot = {
		buffer_time = 0.46,
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
		buffer_time = 0.2,
		input_sequence = {
			{
				inputs = wield_inputs
			}
		}
	}
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	wield = "stay",
	reload = "stay",
	zoom = {
		zoom_release = "base",
		wield = "base",
		zoom_shoot = "stay",
		grenade_ability = "base",
		reload = "base",
		combat_ability = "base"
	},
	start_attack = {
		attack_cancel = "base",
		wield = "base",
		heavy_attack = "base",
		grenade_ability = "base",
		combat_ability = "base",
		light_attack = "base"
	},
	special_action_start = {
		attack_cancel = "base",
		wield = "base",
		special_action_execute = "base"
	}
}

table.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
	action_wield = {
		wield_reload_anim_event = "equip_reload",
		allowed_during_sprint = true,
		wield_anim_event = "equip",
		kind = "ranged_wield",
		continue_sprinting = true,
		uninterruptible = true,
		total_time = 1,
		allowed_chain_actions = {
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.9
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.2
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.55
			},
			wield = {
				action_name = "action_unwield"
			}
		},
		conditional_state_to_action_input = {
			started_reload = {
				input_name = "reload"
			},
			no_ammo = {
				input_name = "reload"
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
	action_zoom = {
		crosshair_type = "projectile_drop",
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
				chain_time = 0.45
			}
		},
		action_keywords = {
			"braced"
		}
	},
	action_unzoom = {
		crosshair_type = "dot",
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
			}
		}
	},
	action_shoot_zoomed = {
		ammunition_usage = 1,
		hide_arc = true,
		start_input = "zoom_shoot",
		kind = "shoot_projectile",
		throw_type = "shoot",
		allowed_during_sprint = false,
		spawn_at_time = 0.1,
		uninterruptible = true,
		total_time = 1.25,
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
				chain_time = 1.25
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.75
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 1.25
			}
		},
		fire_configuration = {
			inventory_item_name = "content/items/weapons/player/ranged/bullets/grenade_thumper_frag",
			anim_event = "attack_shoot",
			skip_aiming = true,
			projectile = ProjectileTemplates.ogryn_gauntlet_grenade
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_tail_sfx_alias = "ranged_shot_tail",
			muzzle_flash_effect = "content/fx/particles/weapons/rifles/ogryn_gauntlet/ogryn_gauntlet_muzzle_flash",
			shoot_sfx_alias = "ranged_single_shot",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo"
		},
		action_keywords = {
			"braced",
			"braced_shooting"
		}
	},
	action_reload = {
		kind = "reload_state",
		uninterruptible = true,
		start_input = "reload",
		sprint_requires_press_to_interrupt = true,
		stop_alternate_fire = true,
		abort_sprint = true,
		crosshair_type = "none",
		allowed_during_sprint = true,
		total_time = 4.1666,
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
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.25
			},
			grenade_ability = {
				action_name = "grenade_ability",
				chain_time = 0.25
			},
			special_action_start = {
				action_name = "action_start_special",
				chain_time = 0.25
			}
		}
	},
	action_melee_start_left = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		start_input = "start_attack",
		kind = "windup",
		uninterruptible = true,
		anim_event = "attack_swing_charge_down",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.05
			},
			{
				modifier = 0.25,
				t = 0.1
			},
			{
				modifier = 0.2,
				t = 0.25
			},
			{
				modifier = 0.35,
				t = 0.4
			},
			{
				modifier = 0.8,
				t = 1
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_swing"
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.6
			},
			special_action_start = {
				action_name = "action_start_special",
				chain_time = 0.8
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.8
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_melee_start_right = {
		first_person_hit_stop_anim = "attack_hit",
		anim_end_event = "attack_finished",
		kind = "windup",
		first_person_hit_anim = "attack_hit",
		uninterruptible = true,
		anim_event = "charge_loop_right_diagonal_up",
		hit_stop_anim = "attack_hit",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.05
			},
			{
				modifier = 0.25,
				t = 0.1
			},
			{
				modifier = 0.2,
				t = 0.25
			},
			{
				modifier = 0.35,
				t = 0.4
			},
			{
				modifier = 0.8,
				t = 1
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_swing_right"
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.6
			},
			special_action_start = {
				action_name = "action_start_special",
				chain_time = 0.8
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.8
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_melee_start_left_2 = {
		first_person_hit_stop_anim = "attack_hit",
		anim_end_event = "attack_finished",
		kind = "windup",
		first_person_hit_anim = "attack_hit",
		uninterruptible = true,
		anim_event = "attack_swing_charge_stab",
		hit_stop_anim = "attack_hit",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.05
			},
			{
				modifier = 0.25,
				t = 0.1
			},
			{
				modifier = 0.2,
				t = 0.25
			},
			{
				modifier = 0.35,
				t = 0.4
			},
			{
				modifier = 0.8,
				t = 1
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_swing_up"
			},
			heavy_attack = {
				action_name = "action_left_heavy_2",
				chain_time = 0.6
			},
			special_action_start = {
				action_name = "action_start_special",
				chain_time = 0.7
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.7
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_swing = {
		damage_window_start = 0.23333333333333334,
		kind = "sweep",
		start_input = "light_attack",
		anim_end_event = "attack_finished",
		weapon_handling_template = "time_scale_1_05",
		attack_direction_override = "left",
		continue_sprinting = false,
		allowed_during_sprint = true,
		range_mod = 1.15,
		damage_window_end = 0.36666666666666664,
		uninterruptible = true,
		anim_event = "attack_swing_right",
		total_time = 1.25,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
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
				modifier = 0.75,
				t = 0.6
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 0.4
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.6
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.85
			},
			special_action_start = {
				action_name = "action_start_special",
				chain_time = 0.6
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.6
			}
		},
		weapon_box = {
			0.3,
			1.5,
			0.3
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/gauntlet/swing_right",
			anchor_point_offset = {
				0,
				0.5,
				0
			}
		},
		herding_template = HerdingTemplates.linesman_left_heavy,
		damage_profile = DamageProfileTemplates.light_grenadier_gauntlet_tank,
		damage_type = damage_types.blunt,
		wounds_shape = wounds_shapes.horizontal_slash_coarse
	},
	action_swing_right = {
		damage_window_start = 0.2,
		hit_armor_anim = "attack_hit",
		weapon_handling_template = "time_scale_1_1",
		attack_direction_override = "right",
		attack_direction = "right",
		range_mod = 1.15,
		kind = "sweep",
		allowed_during_sprint = true,
		damage_window_end = 0.3333333333333333,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_swing_left",
		hit_stop_anim = "attack_hit",
		total_time = 1.25,
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
				modifier = 0.75,
				t = 0.6
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 0.4
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.6
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.7
			},
			special_action_start = {
				action_name = "action_start_special",
				chain_time = 0.6
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.6
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.3,
			0.9,
			0.3
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/gauntlet/swing_left",
			anchor_point_offset = {
				0,
				0.5,
				0
			}
		},
		herding_template = HerdingTemplates.linesman_right_heavy,
		damage_profile = DamageProfileTemplates.light_grenadier_gauntlet_tank,
		damage_type = damage_types.blunt,
		wounds_shape = wounds_shapes.horizontal_slash_coarse
	},
	action_swing_up = {
		damage_window_start = 0.23333333333333334,
		hit_armor_anim = "attack_hit",
		weapon_handling_template = "time_scale_1_1",
		attack_direction_override = "push",
		range_mod = 1.15,
		kind = "sweep",
		allowed_during_sprint = true,
		damage_window_end = 0.4,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_swing_up",
		hit_stop_anim = "attack_hit",
		total_time = 1.28,
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
				modifier = 0.75,
				t = 0.6
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 0.4
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.8
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.85
			},
			special_action_start = {
				action_name = "action_start_special",
				chain_time = 0.8
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.8
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.3,
			0.9,
			0.3
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/gauntlet/swing_uppercut",
			anchor_point_offset = {
				0,
				0.5,
				0
			}
		},
		damage_profile = DamageProfileTemplates.light_grenadier_gauntlet_tank,
		herding_template = HerdingTemplates.uppercut,
		damage_type = damage_types.blunt,
		wounds_shape = wounds_shapes.vertical_slash_coarse
	},
	action_left_heavy = {
		damage_window_start = 0.5,
		hit_armor_anim = "attack_hit",
		range_mod = 1.25,
		weapon_handling_template = "time_scale_1_5",
		kind = "sweep",
		first_person_hit_stop_anim = "attack_hit",
		allowed_during_sprint = true,
		damage_window_end = 0.6,
		anim_end_event = "attack_finished",
		uninterruptible = true,
		anim_event = "attack_swing_heavy_down",
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15
			},
			{
				modifier = 1.25,
				t = 0.4
			},
			{
				modifier = 0.5,
				t = 0.6
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.5
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 1.15
			},
			special_action_start = {
				action_name = "action_start_special",
				chain_time = 0.8
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.8
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.3,
			0.9,
			0.3
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/gauntlet/heavy_swing_down",
			anchor_point_offset = {
				0,
				1.1,
				0
			}
		},
		herding_template = HerdingTemplates.linesman_left_heavy,
		damage_profile = DamageProfileTemplates.heavy_grenadier_gauntlet_tank,
		damage_type = damage_types.blunt,
		wounds_shape = wounds_shapes.vertical_slash_coarse
	},
	action_right_heavy = {
		damage_window_start = 0.2,
		hit_armor_anim = "attack_hit",
		anim_end_event = "attack_finished",
		kind = "sweep",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.25,
		weapon_handling_template = "time_scale_1_2",
		damage_window_end = 0.3333333333333333,
		uninterruptible = true,
		anim_event = "attack_heavy_right_diagonal_up",
		total_time = 1.5,
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15
			},
			{
				modifier = 1.25,
				t = 0.4
			},
			{
				modifier = 0.5,
				t = 0.6
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.5
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
				chain_time = 0.3
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 1
			},
			special_action_start = {
				action_name = "action_start_special",
				chain_time = 0.8
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.8
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.3,
			0.9,
			0.3
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/gauntlet/heavy_swing_right_diagonal_up",
			anchor_point_offset = {
				0,
				0.3,
				0
			}
		},
		herding_template = HerdingTemplates.linesman_right_heavy,
		damage_profile = DamageProfileTemplates.light_grenadier_gauntlet_tank,
		damage_type = damage_types.blunt,
		wounds_shape = wounds_shapes.vertical_slash_coarse
	},
	action_left_heavy_2 = {
		damage_window_start = 0.3,
		hit_armor_anim = "attack_hit",
		anim_end_event = "attack_finished",
		kind = "sweep",
		first_person_hit_stop_anim = "attack_hit",
		range_mod = 1.25,
		weapon_handling_template = "time_scale_1_2",
		damage_window_end = 0.4,
		uninterruptible = true,
		anim_event = "attack_swing_heavy_stab",
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15
			},
			{
				modifier = 1.25,
				t = 0.4
			},
			{
				modifier = 0.5,
				t = 0.6
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.5
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
				chain_time = 0.3
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 1.05
			},
			special_action_start = {
				action_name = "action_start_special",
				chain_time = 0.8
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.8
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = {
			0.3,
			1.25,
			0.3
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/gauntlet/heavy_swing_stab",
			anchor_point_offset = {
				0.8,
				1,
				0.3
			}
		},
		herding_template = HerdingTemplates.ogryn_punch,
		damage_profile = DamageProfileTemplates.heavy_grenadier_gauntlet_tank,
		damage_type = damage_types.blunt,
		wounds_shape = wounds_shapes.default
	},
	action_start_special = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		start_input = "special_action_start",
		kind = "windup",
		uninterruptible = false,
		anim_event = "attack_swing_charge_special",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.05
			},
			{
				modifier = 0.25,
				t = 0.1
			},
			{
				modifier = 0.2,
				t = 0.25
			},
			{
				modifier = 0.35,
				t = 0.4
			},
			{
				modifier = 0.8,
				t = 1
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			special_action_execute = {
				action_name = "action_execute_special",
				chain_time = 0.5
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_execute_special = {
		damage_window_start = 0.2,
		hit_armor_anim = "attack_hit",
		anim_end_event = "attack_finished",
		kind = "melee_explosive",
		range_mod = 1.15,
		hit_explosion_anim = "attack_hit_special",
		allowed_during_sprint = true,
		exploding_movement_speed_buff = "heavy_stun_movement_slow",
		ammunition_usage = 1,
		damage_window_end = 0.3,
		allow_even_if_out_of_ammo = true,
		explosion_delay = 0.3,
		uninterruptible = true,
		anim_event = "attack_swing_special",
		hit_stop_anim = "attack_hit",
		total_time = 1.28,
		action_movement_curve = {
			{
				modifier = 0.3,
				t = 0.1
			},
			{
				modifier = 0.1,
				t = 0.25
			},
			{
				modifier = 0.1,
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
				modifier = 0.75,
				t = 0.6
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 0.4
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
				chain_time = 0.3
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 1.05
			},
			special_action_start = {
				action_name = "action_start_special",
				chain_time = 1.1
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.8
			}
		},
		weapon_box = {
			0.3,
			1,
			0.3
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/ogryn/first_person/animations/gauntlet/heavy_swing_stab_special",
			anchor_point_offset = {
				0.3,
				1.1,
				0.25
			}
		},
		herding_template = HerdingTemplates.ogryn_punch,
		damage_profile = DamageProfileTemplates.special_grenadier_gauntlet_tank,
		damage_type = damage_types.ogryn_punch,
		explosion_template = ExplosionTemplates.special_gauntlet_grenade,
		explosion_offset = Vector3Box(0, 2.25, 0)
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

weapon_template.anim_state_machine_3p = "content/characters/player/ogryn/third_person/animations/gauntlet"
weapon_template.anim_state_machine_1p = "content/characters/player/ogryn/first_person/animations/gauntlet"
weapon_template.alternate_fire_settings = {
	crosshair_type = "projectile_drop",
	toughness_template = "killshot_zoomed",
	stop_anim_event = "to_unaim_braced",
	start_anim_event = "to_braced",
	spread_template = "no_spread",
	camera = {
		custom_vertical_fov = 65,
		vertical_fov = 65,
		near_range = 0.025
	},
	movement_speed_modifier = {
		{
			modifier = 0.875,
			t = 0.45
		},
		{
			modifier = 0.85,
			t = 0.47500000000000003
		},
		{
			modifier = 0.79,
			t = 0.65
		},
		{
			modifier = 0.8,
			t = 0.7
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
		}
	}
}
weapon_template.traits = {}
local bespoke_ogryn_gauntlet_p1_traits = table.keys(WeaponTraitsOgrynGauntletP1)

table.append(weapon_template.traits, bespoke_ogryn_gauntlet_p1_traits)

weapon_template.spread_template = "shotgun"
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_ammo_with_delay",
		input_name = "reload"
	}
}
weapon_template.no_ammo_delay = 0.4
weapon_template.sprint_ready_up_time = 0.3
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.uses_ammunition = true
weapon_template.uses_overheat = false
weapon_template.ammo_template = "ogryn_gauntlet_p1_m1"
weapon_template.fx_sources = {
	_muzzle = "fx_muzzle",
	_sweep = "fx_sweep"
}
weapon_template.crosshair_type = "dot"
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"ranged",
	"grenadier_gauntlet",
	"p1"
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.reload_template = ReloadTemplates.ogryn_gauntlet
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.ogryn_gauntlet
weapon_template.overclocks = {}
local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")
weapon_template.base_stats = {
	ogryn_gauntlet_p1_m1_ammo = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.default_explosive_ammo_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		}
	},
	ogryn_gauntlet_p1_m1_explosion_damage = {
		display_name = "loc_stats_display_explosion_damage_stat",
		is_stat_trait = true,
		explosion = {
			action_shoot_zoomed = {
				explosion_trait_templates.default_explosion_damage_stat
			},
			action_execute_special = {
				explosion_trait_templates.default_explosion_damage_stat
			}
		},
		damage = {
			action_shoot_zoomed = {
				damage_trait_templates.ogryn_gauntlet_p1_m1_explosion_damage_stat,
				display_data = {
					display_stats = {
						__all_basic_stats = true,
						power_distribution = {
							attack = {
								display_name = "loc_weapon_stats_display_base_damage"
							}
						}
					}
				}
			},
			action_execute_special = {
				damage_trait_templates.ogryn_gauntlet_p1_m1_explosion_damage_stat
			}
		}
	},
	ogryn_gauntlet_p1_m1_explosion_size = {
		display_name = "loc_stats_display_explosion_stat",
		is_stat_trait = true,
		explosion = {
			action_shoot_zoomed = {
				explosion_trait_templates.default_explosion_size_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		}
	},
	ogryn_gauntlet_p1_m1_dps_stat = {
		description = "loc_stats_display_damage_stat_desc",
		display_name = "loc_glossary_term_melee_damage",
		is_stat_trait = true,
		damage = {
			action_swing = {
				damage_trait_templates.default_melee_dps_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						targets = {
							{
								power_distribution = {
									attack = {
										display_name = "loc_weapon_stats_display_melee_damage"
									}
								}
							}
						}
					}
				}
			},
			action_swing_right = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_swing_up = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_left_heavy = {
				damage_trait_templates.default_melee_dps_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								power_distribution = {
									attack = {
										display_name = "loc_weapon_stats_display_base_damage"
									}
								}
							}
						}
					}
				}
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_left_heavy_2 = {
				damage_trait_templates.default_melee_dps_stat
			}
		}
	},
	ogryn_gauntlet_p1_m1_explosion_antiarmor = {
		display_name = "loc_stats_display_explosion_ap_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_zoomed = {
				damage_trait_templates.ogryn_gauntlet_p1_m1_explosion_antiarmor_stat,
				display_data = {
					display_stats = {
						armor_damage_modifier_ranged = {
							near = {
								attack = {
									[armor_types.armored] = {},
									[armor_types.super_armor] = {},
									[armor_types.resistant] = {}
								}
							}
						}
					}
				}
			},
			action_execute_special = {
				damage_trait_templates.ogryn_gauntlet_p1_m1_explosion_antiarmor_stat
			}
		}
	}
}
weapon_template.perks = {
	ogryn_gauntlet_p1_m1_ammo_perk = {
		display_name = "loc_trait_display_ogryn_gauntlet_p1_m1_ammo_perk",
		ammo = {
			base = {
				ammo_trait_templates.default_explosive_ammo_perk
			}
		}
	},
	ogryn_gauntlet_p1_m1_explosion_damage_perk = {
		display_name = "loc_trait_display_ogryn_gauntlet_p1_m1_explosion_damage_perk",
		explosion = {
			action_shoot_zoomed = {
				explosion_trait_templates.dafault_explosion_damage_perk
			}
		},
		damage = {
			action_shoot_zoomed = {
				damage_trait_templates.ogryn_gauntlet_p1_m1_explosion_damage_perk
			}
		}
	},
	ogryn_gauntlet_p1_m1_explosion_size_perk = {
		display_name = "loc_trait_display_ogryn_gauntlet_p1_m1_explosion_size_perk",
		explosion = {
			action_shoot_zoomed = {
				explosion_trait_templates.default_explosion_size_perk
			}
		}
	},
	ogryn_gauntlet_p1_m1_dps_perk = {
		display_name = "loc_trait_display_ogryn_gauntlet_p1_m1_dps_perk",
		damage = {
			action_swing = {
				damage_trait_templates.default_melee_dps_perk
			},
			action_swing_right = {
				damage_trait_templates.default_melee_dps_perk
			},
			action_swing_up = {
				damage_trait_templates.default_melee_dps_perk
			},
			action_left_heavy = {
				damage_trait_templates.default_melee_dps_perk
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_dps_perk
			},
			action_left_heavy_2 = {
				damage_trait_templates.default_melee_dps_perk
			}
		}
	},
	ogryn_gauntlet_p1_m1_explosion_antiarmor_perk = {
		display_name = "loc_trait_display_ogryn_gauntlet_p1_m1_explosion_antiarmor_perk",
		damage = {
			action_shoot_zoomed = {
				damage_trait_templates.ogryn_gauntlet_p1_m1_explosion_antiarmor_perk
			}
		}
	}
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_explosive"
	},
	{
		display_name = "loc_weapon_keyword_multi_purpose"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_weapon_action_title_light",
		type = "melee",
		attack_chain = {
			"tank",
			"tank",
			"tank"
		}
	},
	secondary = {
		display_name = "loc_weapon_action_title_heavy",
		type = "melee",
		attack_chain = {
			"tank",
			"tank"
		}
	},
	extra = {
		fire_mode = "projectile",
		display_name = "loc_ranged_attack_secondary_braced",
		type = "brace"
	},
	special = {
		desc = "loc_stats_special_action_special_attack_ogryn_gauntlet_p1m1_desc",
		display_name = "loc_weapon_special_fist_attack_gauntlet",
		type = "special_attack"
	}
}
weapon_template.displayed_weapon_stats = "ogryn_gauntlet"

return weapon_template
