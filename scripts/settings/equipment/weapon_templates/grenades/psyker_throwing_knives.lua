local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local buff_keywords = BuffSettings.keywords
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {}

local function _projectile_template_func(unit, action_settings)
	return ProjectileTemplates.psyker_gunslinger_throwing_knives
end

local function _select_throw_anim(action_settings, condition_func_params)
	local ability_extension = condition_func_params.ability_extension
	local ability_type = action_settings.ability_type
	local charges_left = ability_extension:remaining_ability_charges(ability_type)
	local have_charges_left = charges_left <= 1
	local anim_option_1 = action_settings.anim_event_non_last
	local anim_option_2 = action_settings.anim_event_last

	return (have_charges_left and anim_option_2) or anim_option_1
end

weapon_template.action_inputs = {
	aim_pressed = {
		buffer_time = 0.1,
		input_sequence = {
			{
				value = true,
				input = "action_one_pressed"
			}
		}
	},
	combat_ability = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				value = true,
				input = "combat_ability_pressed"
			}
		}
	},
	shoot = {
		buffer_time = 0.15,
		max_queue = 2,
		input_sequence = {
			{
				value = true,
				input = "action_one_hold"
			}
		}
	},
	charge = {
		buffer_time = 0,
		input_sequence = {
			{
				value = true,
				input = "action_two_hold"
			}
		}
	},
	shoot_charge = {
		buffer_time = 0.1,
		input_sequence = {
			{
				value = true,
				hold_input = "action_two_hold",
				input = "action_one_pressed"
			}
		}
	},
	charge_release = {
		buffer_time = 0.1,
		input_sequence = {
			{
				value = false,
				input = "action_two_hold",
				time_window = math.huge
			}
		}
	},
	aim_released = {
		buffer_time = 0.5,
		input_sequence = {
			{
				value = false,
				input = "action_one_release",
				time_window = math.huge
			}
		}
	},
	block_cancel = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				value = true,
				hold_input = "combat_ability_hold",
				input = "action_two_pressed"
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
	recall = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				value = true,
				input = "weapon_reload_hold"
			}
		}
	},
	recall_release = {
		buffer_time = 0.1,
		input_sequence = {
			{
				value = false,
				input = "weapon_reload_hold",
				time_window = math.huge
			}
		}
	},
	recall_one = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				value = true,
				input = "none"
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
	zoom_release_no_anim = {
		buffer_time = 0.3,
		input_sequence = {
			{
				value = false,
				input = "none",
				time_window = math.huge
			}
		}
	}
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	wield = "stay",
	block_cancel = "base",
	combat_ability = "stay",
	recall_one = "stay",
	shoot = {
		combat_ability = "base",
		wield = "base"
	},
	recall = {
		combat_ability = "base",
		wield = "base",
		recall_release = "base"
	},
	zoom = {
		zoom_release_no_anim = "base",
		wield = "base",
		zoom_release = "base",
		zoom_shoot = "stay",
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
		kind = "wield",
		continue_sprinting = true,
		uninterruptible = true,
		total_time = 0.5,
		anim_event_func = function (action_settings, condition_func_params)
			local ability_extension = condition_func_params.ability_extension
			local ability_type = "grenade_ability"
			local anim_event = "to_noammo"
			local anim_event_3p = "to_noammo"

			if ability_type and ability_extension:can_use_ability(ability_type) then
				anim_event = "to_ammo"
				anim_event_3p = "to_ammo"
			end

			return anim_event, anim_event_3p
		end,
		timeline_anims = {
			[0.05] = "equip"
		},
		conditional_state_to_action_input = {
			no_grenade_ability_charge = {
				input_name = "recall_one"
			}
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			combat_ability = {
				action_name = "combat_ability"
			},
			recall_one = {
				action_name = "action_recall_one"
			}
		}
	},
	rapid_right = {
		projectile_item = "content/items/weapons/player/melee/blades/combat_knife_blade_01",
		anim_noammo_event = "to_noammo",
		sprint_requires_press_to_interrupt = true,
		kind = "spawn_projectile",
		shoot_at_time = 0.2,
		start_input = "shoot",
		use_target = true,
		use_target_position = true,
		ability_type = "grenade_ability",
		target_position_distance = 50,
		anim_time_scale = 1.5,
		target_finder_module_class_name = "smart_target_targeting",
		use_ability_charge = true,
		anim_event_last = "attack_shoot_last",
		fire_time = 0.1,
		charge_template = "psyker_throwing_knives",
		anim_event_non_last = "attack_shoot_right",
		uninterruptible = true,
		total_time = 1,
		action_movement_curve = {
			{
				modifier = 0.5,
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
			start_modifier = 0.8
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			shoot = {
				action_name = "rapid_left",
				chain_time = 0.6
			}
		},
		fx = {
			shoot_sfx_alias = "ranged_single_shot"
		},
		anim_event_func = _select_throw_anim,
		projectile_template = ProjectileTemplates.psyker_gunslinger_throwing_knives,
		projectile_template_func = _projectile_template_func,
		smart_targeting_template = SmartTargetingTemplates.throwing_knifes_single_target
	},
	rapid_left = {
		projectile_item = "content/items/weapons/player/melee/blades/combat_knife_blade_01",
		anim_noammo_event = "to_noammo",
		sprint_requires_press_to_interrupt = true,
		kind = "spawn_projectile",
		shoot_at_time = 0.2,
		use_target_position = true,
		use_target = true,
		use_ability_charge = true,
		ability_type = "grenade_ability",
		target_finder_module_class_name = "smart_target_targeting",
		anim_time_scale = 1.5,
		target_position_distance = 50,
		anim_event_last = "attack_shoot_last",
		fire_time = 0.1,
		charge_template = "psyker_throwing_knives",
		anim_event_non_last = "attack_shoot_left",
		uninterruptible = true,
		total_time = 1,
		action_movement_curve = {
			{
				modifier = 0.5,
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
			start_modifier = 0.8
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			shoot = {
				action_name = "rapid_right",
				chain_time = 0.8
			}
		},
		fx = {
			shoot_sfx_alias = "ranged_single_shot"
		},
		anim_event_func = _select_throw_anim,
		projectile_template = ProjectileTemplates.psyker_gunslinger_throwing_knives,
		projectile_template_func = _projectile_template_func,
		smart_targeting_template = SmartTargetingTemplates.throwing_knifes_single_target
	},
	rapid_zoomed = {
		projectile_item = "content/items/weapons/player/melee/blades/combat_knife_blade_01",
		anim_noammo_event = "to_noammo",
		sprint_requires_press_to_interrupt = true,
		kind = "spawn_projectile",
		shoot_at_time = 0.2,
		start_input = "zoom_shoot",
		use_target = true,
		ability_type = "grenade_ability",
		use_ability_charge = true,
		anim_time_scale = 1.5,
		target_position_distance = 50,
		target_finder_module_class_name = "smart_target_targeting",
		use_target_position = true,
		anim_event_last = "attack_shoot_last",
		fire_time = 0.1,
		charge_template = "psyker_throwing_knives",
		anim_event_non_last = "attack_shoot_zoomed",
		uninterruptible = true,
		total_time = 1,
		action_movement_curve = {
			{
				modifier = 0.5,
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
			start_modifier = 0.8
		},
		running_action_state_to_action_input = {
			out_of_charges = {
				input_name = "zoom_release_no_anim"
			}
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			shoot = {
				action_name = "rapid_zoomed",
				chain_time = 0.6
			},
			zoom_release_no_anim = {
				action_name = "action_unzoom_no_anim",
				chain_time = 0.3
			}
		},
		fx = {
			shoot_sfx_alias = "ranged_single_shot"
		},
		anim_event_func = _select_throw_anim,
		projectile_template = ProjectileTemplates.psyker_gunslinger_throwing_knives,
		projectile_template_func = _projectile_template_func,
		smart_targeting_template = SmartTargetingTemplates.throwing_knifes_single_target
	},
	action_zoom = {
		must_have_ammo_or_charge = true,
		crosshair_type = "dot",
		start_input = "zoom",
		kind = "aim",
		ability_type = "grenade_ability",
		total_time = 0.3,
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_killshot,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			recall = {
				action_name = "action_recall"
			},
			zoom_shoot = {
				action_name = "rapid_zoomed",
				chain_time = 0.1
			}
		}
	},
	action_unzoom = {
		kind = "unaim",
		start_input = "zoom_release",
		total_time = 0.2,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			zoom = {
				action_name = "action_zoom"
			},
			recall = {
				action_name = "action_recall"
			}
		}
	},
	action_unzoom_no_anim = {
		start_input = "zoom_release_no_anim",
		kind = "unaim",
		skipp_unaim_anim = true,
		total_time = 0.2,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			zoom = {
				action_name = "action_zoom"
			},
			recall = {
				action_name = "action_recall"
			}
		}
	},
	action_recall_one = {
		anim_to_ammo_event = "to_ammo",
		uninterruptible = false,
		anim_catch_event = "catch",
		kind = "recall",
		charge_template = "psyker_throwing_knives_recall",
		num_charges_restored = 1,
		ability_type = "grenade_ability",
		continue_sprinting = false,
		first_recall_time = 0.65,
		allowed_during_sprint = false,
		anim_event = "recall",
		total_time = 0.7,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15
			}
		}
	},
	action_recall = {
		anim_to_ammo_event = "to_ammo",
		subsequent_recall_time = 0.25,
		start_input = "recall",
		num_charges_restored = 1,
		kind = "recall",
		continue_sprinting = false,
		first_recall_time = 0.65,
		allowed_during_sprint = false,
		ability_type = "grenade_ability",
		anim_catch_event = "catch",
		priority = 1,
		charge_template = "psyker_throwing_knives_recall",
		uninterruptible = false,
		anim_event = "recall",
		stop_input = "recall_release",
		total_time = math.huge,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15
			}
		},
		running_action_state_to_action_input = {
			fully_recalled = {
				input_name = "recall_release"
			}
		}
	},
	action_vent = {
		priority = 0,
		start_input = "recall",
		anim_end_event = "vent_end",
		kind = "vent_warp_charge",
		vo_tag = "ability_venting",
		uninterruptible = true,
		anim_event = "vent_start",
		stop_input = "recall_release",
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
		running_action_state_to_action_input = {
			fully_vented = {
				input_name = "recall_release"
			}
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15
			}
		}
	},
	combat_ability = {
		slot_to_wield = "slot_combat_ability",
		start_input = "combat_ability",
		uninterruptible = true,
		kind = "unwield_to_specific",
		total_time = 0,
		allowed_chain_actions = {}
	}
}
weapon_template.keywords = {
	"psyker"
}
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/throwing_knives",
	ogryn = "content/characters/player/ogryn/third_person/animations/unarmed"
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/throwing_knives",
	ogryn = "content/characters/player/ogryn/first_person/animations/unarmed"
}
weapon_template.alternate_fire_settings = {
	crosshair_type = "dot",
	stop_anim_event = "to_unaim_ironsight",
	start_anim_event = "to_ironsight",
	spread_template = "no_spread",
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
	camera = {
		custom_vertical_fov = 45,
		vertical_fov = 45,
		near_range = 0.025
	}
}
weapon_template.spread_template = "no_spread"
weapon_template.ammo_template = "no_ammo"
weapon_template.psyker_smite = true
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.crosshair_type = "cross"
weapon_template.hit_marker_type = "center"
weapon_template.fx_sources = {
	_muzzle = "fx_right"
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = {
	crouch_walking = 0.61,
	walking = 0.4,
	sprinting = 0.37
}

return weapon_template
