-- chunkname: @scripts/settings/equipment/weapon_templates/grenades/psyker_throwing_knives.lua

local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {}

local function _projectile_template_func(unit, action_settings)
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if buff_extension and buff_extension:has_keyword(buff_keywords.psyker_empowered_grenade) then
		return ProjectileTemplates.psyker_throwing_knives_piercing
	end

	return ProjectileTemplates.psyker_throwing_knives
end

local function _aimed_projectile_template_func(unit, action_settings)
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if buff_extension and buff_extension:has_keyword(buff_keywords.psyker_empowered_grenade) then
		return ProjectileTemplates.psyker_throwing_knives_aimed_piercing
	end

	return ProjectileTemplates.psyker_throwing_knives_aimed
end

local function _select_throw_anim(action_settings, condition_func_params)
	local ability_extension = condition_func_params.ability_extension
	local ability_type = action_settings.ability_type
	local charges_left = ability_extension:remaining_ability_charges(ability_type)
	local has_charges_left = charges_left > 1
	local anim_option_1 = action_settings.anim_event_non_last
	local anim_option_2 = action_settings.anim_event_last

	return has_charges_left and anim_option_1 or anim_option_2
end

weapon_template.action_inputs = {
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
		buffer_time = 0.2,
		max_queue = 1,
		input_sequence = {
			{
				value = true,
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
	rewield = {
		clear_input_queue = true,
		buffer_time = 0
	},
	force_vent = {
		clear_input_queue = true,
		buffer_time = 0
	},
	force_vent_release = {
		buffer_time = 2,
		input_sequence = {
			{
				value = false,
				input = "weapon_reload_hold",
				time_window = math.huge
			}
		}
	},
	vent = {
		buffer_time = 0,
		input_sequence = {
			{
				value = true,
				input = "weapon_reload_hold"
			}
		}
	},
	vent_release = {
		buffer_time = 0.2,
		input_sequence = {
			{
				value = false,
				input = "weapon_reload_hold",
				time_window = math.huge
			}
		}
	},
	zoom_shoot = {
		buffer_time = 0.51,
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
	inspect_start = {
		buffer_time = 0,
		input_sequence = {
			{
				value = true,
				input = "weapon_inspect_hold"
			},
			{
				value = true,
				duration = 0.2,
				input = "weapon_inspect_hold"
			}
		}
	},
	inspect_stop = {
		buffer_time = 0.02,
		input_sequence = {
			{
				value = false,
				input = "weapon_inspect_hold",
				time_window = math.huge
			}
		}
	}
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	shoot = "stay",
	wield = "stay",
	rewield = "stay",
	combat_ability = "stay",
	vent = {
		wield = "base",
		vent_release = "base",
		combat_ability = "base"
	},
	force_vent = {
		wield = "base",
		combat_ability = "base",
		force_vent_release = "base"
	},
	zoom = {
		zoom_release = "base",
		wield = "base",
		zoom_shoot = "base",
		force_vent = "base",
		combat_ability = "base"
	},
	inspect_start = {
		inspect_stop = "base"
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
	action_rewield = {
		allowed_during_sprint = true,
		start_input = "rewield",
		uninterruptible = true,
		kind = "wield",
		total_time = 0.5,
		anim_event_func = function (action_settings, condition_func_params)
			local ability_extension = condition_func_params.ability_extension
			local ability_type = "grenade_ability"
			local anim_event = "toggle_flashlight"
			local anim_event_3p = "to_noammo"

			if ability_type and ability_extension:can_use_ability(ability_type) then
				anim_event = "to_ammo"
				anim_event_3p = "to_ammo"
			end

			return anim_event, anim_event_3p
		end,
		timeline_anims = {
			[0.05] = {
				anim_event_3p = "equip_shard",
				anim_event_1p = "equip"
			}
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			combat_ability = {
				action_name = "combat_ability"
			},
			shoot = {
				action_name = "action_rapid_right"
			}
		}
	},
	action_wield = {
		allowed_during_sprint = true,
		uninterruptible = true,
		kind = "wield",
		total_time = 0.5,
		anim_event_func = function (action_settings, condition_func_params)
			local ability_extension = condition_func_params.ability_extension
			local ability_type = "grenade_ability"
			local anim_event = "to_noammo"
			local anim_event_3p = "to_noammo"

			if ability_type and ability_extension:can_use_ability(ability_type) then
				anim_event = "equip"
				anim_event_3p = "to_ammo"
			end

			return anim_event, anim_event_3p
		end,
		timeline_anims = {
			[0.05] = {
				anim_event_3p = "equip_shard",
				anim_event_1p = "equip"
			}
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			combat_ability = {
				action_name = "combat_ability"
			},
			shoot = {
				action_name = "action_rapid_right"
			},
			vent = {
				action_name = "action_vent"
			}
		}
	},
	action_rapid_right = {
		weapon_handling_template = "time_scale_1_5",
		start_input = "shoot",
		psyker_smite = true,
		sprint_requires_press_to_interrupt = true,
		kind = "spawn_projectile",
		should_crit = true,
		use_target = true,
		ability_type = "grenade_ability",
		use_ability_charge = true,
		target_position_distance = 50,
		target_finder_module_class_name = "smart_target_targeting",
		anim_event_last = "attack_shoot_last",
		fire_time = 0.25,
		charge_template = "psyker_throwing_knives",
		vo_tag = "ability_gunslinger",
		use_target_position = false,
		anim_event_non_last = "attack_shoot",
		uninterruptible = true,
		extra_projectile_on_crit = true,
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
			start_modifier = 0.6
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			shoot = {
				action_name = "action_rapid_left",
				chain_time = 0.5
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.5
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.3
			},
			force_vent = {
				action_name = "action_force_vent"
			}
		},
		spawn_offset = Vector3Box(0.1, -0.2, -0.22),
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_sfx_alias = "ranged_single_shot"
		},
		anim_event_func = _select_throw_anim,
		projectile_template = ProjectileTemplates.psyker_throwing_knives,
		projectile_template_func = _projectile_template_func,
		smart_targeting_template = SmartTargetingTemplates.throwing_knives_default,
		time_scale_stat_buffs = {
			buff_stat_buffs.psyker_throwing_knife_speed_modifier
		}
	},
	action_rapid_left = {
		target_finder_module_class_name = "smart_target_targeting",
		psyker_smite = true,
		sprint_requires_press_to_interrupt = true,
		weapon_handling_template = "time_scale_1_5",
		should_crit = true,
		use_target = true,
		use_target_position = false,
		ability_type = "grenade_ability",
		target_position_distance = 50,
		kind = "spawn_projectile",
		use_ability_charge = true,
		anim_event_last = "attack_shoot_last",
		fire_time = 0.25,
		charge_template = "psyker_throwing_knives",
		vo_tag = "ability_gunslinger",
		anim_event_non_last = "attack_shoot",
		uninterruptible = true,
		extra_projectile_on_crit = true,
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
			start_modifier = 0.6
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			shoot = {
				action_name = "action_rapid_right",
				chain_time = 0.9
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.9
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.3
			},
			force_vent = {
				action_name = "action_force_vent"
			}
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_sfx_alias = "ranged_single_shot"
		},
		spawn_offset = Vector3Box(0.1, -0.5, -0.37),
		anim_event_func = _select_throw_anim,
		projectile_template = ProjectileTemplates.psyker_throwing_knives,
		projectile_template_func = _projectile_template_func,
		smart_targeting_template = SmartTargetingTemplates.throwing_knives_default,
		time_scale_stat_buffs = {
			buff_stat_buffs.psyker_throwing_knife_speed_modifier
		}
	},
	action_rapid_zoomed = {
		kind = "spawn_projectile",
		target_finder_module_class_name = "smart_target_targeting",
		psyker_smite = true,
		weapon_handling_template = "time_scale_1_5",
		should_crit = true,
		prefer_previous_action_targeting_result = true,
		use_target = true,
		use_target_position = false,
		ability_type = "grenade_ability",
		use_ability_charge = true,
		sprint_requires_press_to_interrupt = true,
		anim_event_last = "attack_shoot_last",
		fire_time = 0.25,
		charge_template = "psyker_throwing_knives_homing",
		vo_tag = "ability_gunslinger",
		sticky_targeting = true,
		target_position_distance = 100,
		anim_event_non_last = "attack_shoot_zoomed",
		uninterruptible = true,
		extra_projectile_on_crit = true,
		total_time = 1.5,
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
			start_modifier = 0.75
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			zoom_shoot = {
				action_name = "action_rapid_zoomed",
				chain_time = 1.2
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.3
			}
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_sfx_alias = "ranged_single_shot"
		},
		spawn_offset = Vector3Box(0.045, -0.3, 0.2),
		anim_event_func = _select_throw_anim,
		projectile_template = ProjectileTemplates.psyker_throwing_knives_aimed_piercing,
		projectile_template_func = _aimed_projectile_template_func,
		smart_targeting_template = SmartTargetingTemplates.throwing_knifes_single_target,
		time_scale_stat_buffs = {
			buff_stat_buffs.psyker_throwing_knife_speed_modifier
		}
	},
	action_zoom = {
		target_finder_module_class_name = "smart_target_targeting",
		start_input = "zoom",
		kind = "target_finder",
		soft_sticky_targeting = true,
		must_have_ammo_or_charge = true,
		sticky_targeting = false,
		use_alternate_fire = true,
		ability_type = "grenade_ability",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "dot"
		},
		smart_targeting_template = SmartTargetingTemplates.throwing_knifes_single_target,
		targeting_fx = {
			has_husk_events = true,
			wwise_event_stop = "wwise/events/weapon/stop_psyker_throwing_knife_aim_target_loop",
			wwise_event_start = "wwise/events/weapon/play_psyker_throwing_knife_aim_target_loop",
			husk_effect_name = "content/fx/particles/weapons/force_staff/force_staff_channel_charge",
			effect_name = "content/fx/particles/weapons/force_staff/force_staff_channel_charge"
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			zoom_shoot = {
				action_name = "action_rapid_zoomed",
				chain_time = 0.5
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.3
			}
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.psyker_throwing_knife_speed_modifier
		}
	},
	action_unzoom = {
		kind = "unaim",
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
			}
		}
	},
	action_force_vent = {
		vent_vfx = "content/fx/particles/abilities/psyker_venting",
		vent_source_name = "fx_left_hand",
		anim_end_event = "vent_end",
		kind = "vent_warp_charge",
		additional_vent_vfx = "content/fx/particles/abilities/psyker_venting_2",
		vo_tag = "ability_venting",
		additional_vent_source_name = "fx_right_hand",
		minimum_hold_time = 1.5,
		uninterruptible = true,
		anim_event = "vent_start",
		stop_input = "force_vent_release",
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
				input_name = "vent_release"
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
	action_vent = {
		vent_source_name = "fx_left_hand",
		start_input = "vent",
		anim_end_event = "vent_end",
		kind = "vent_warp_charge",
		vent_vfx = "content/fx/particles/abilities/psyker_venting",
		vo_tag = "ability_venting",
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
				input_name = "vent_release"
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
	},
	action_inspect = {
		skip_3p_anims = true,
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
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_grenades_and_got_grenade",
		input_name = "rewield"
	}
}
weapon_template.keywords = {
	"psyker"
}
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/psyker_smite",
	ogryn = "content/characters/player/ogryn/third_person/animations/unarmed"
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/throwing_knives",
	ogryn = "content/characters/player/ogryn/first_person/animations/unarmed"
}
weapon_template.alternate_fire_settings = {
	stop_anim_event = "to_unaim_ironsight",
	start_anim_event = "to_ironsight",
	spread_template = "no_spread",
	crosshair = {
		crosshair_type = "dot"
	},
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
		custom_vertical_fov = 60,
		vertical_fov = 60,
		near_range = 0.025
	}
}
weapon_template.spread_template = "no_spread"
weapon_template.ammo_template = "no_ammo"
weapon_template.psyker_smite = true
weapon_template.uses_ammunition = true
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.crosshair = {
	crosshair_type = "dot"
}
weapon_template.hit_marker_type = "center"
weapon_template.smart_targeting_template = SmartTargetingTemplates.throwing_knives_default
weapon_template.fx_sources = {
	_shard_04 = "fx_shard_04",
	_shard_01 = "fx_shard_01",
	_shard_02 = "fx_shard_02",
	_shard_03 = "fx_shard_03",
	_muzzle = "fx_right",
	_right = "fx_right"
}
weapon_template.wieldable_slot_scripts = {
	"PsykerSingleTargetEffects"
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.hud_icon = "content/ui/materials/icons/throwables/hud/throwing_knives"

weapon_template.action_none_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not current_action_name or current_action_name == "none"
end

weapon_template.overheated_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	local player_unit = player.player_unit
	local unit_data_ext = ScriptUnit.extension(player_unit, "unit_data_system")
	local warp_charge = unit_data_ext:read_component("warp_charge")
	local has_warp_charge = warp_charge.current_percentage >= 0.1

	return has_warp_charge
end

weapon_template.action_one_charging_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_charge_heavy"
end

weapon_template.action_two_charging_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_zoom"
end

weapon_template.action_two_firing_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_shoot_charged"
end

return weapon_template
