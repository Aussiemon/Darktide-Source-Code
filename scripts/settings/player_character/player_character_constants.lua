local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local HubMovementSettingsTemplates = require("scripts/settings/player_character/hub_movement_settings_templates")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local damage_types = DamageSettings.damage_types
local buff_target_component_lookups = WeaponTweakTemplateSettings.buff_target_component_lookups
local RELOAD_STATES = {
	"none"
}

for _, reload_template in pairs(ReloadTemplates) do
	local states = reload_template.states

	for i = 1, #states, 1 do
		local state_name = states[i]

		if not table.contains(RELOAD_STATES, state_name) then
			RELOAD_STATES[#RELOAD_STATES + 1] = state_name
		end
	end
end

local constants = {
	climb_speed_lerp_interval = 22.5,
	knocked_down_damage_tick_buff = "knocked_down_damage_tick",
	acceleration = 19,
	climb_speed = 1.75,
	player_speed_scale = 1,
	warp_grabbed_drag_speed = 3,
	ladder_top_entering_animation_time = 1,
	air_move_speed_scale = 0.75,
	air_acceleration = 3,
	warp_grabbed_drag_slowdown_distance = 4.5,
	knocked_down_damage_reduction_buff = "knocked_down_damage_reduction",
	step_up_min_fall_speed = -0.1,
	respawn_beacon_spot_radius = 1,
	horizontal_climb_scale = 0.25,
	ladder_top_leaving_time = 1,
	step_up_max_fall_speed = 2.1,
	max_dynamic_weapon_buffs = 4,
	hang_ledge_collision_capsule_radius = 0.5,
	time_until_fall_down_from_hang_ledge = 30,
	walk_move_speed = 1.9,
	max_component_buffs = 10,
	slide_commit_time = 0.65,
	backward_move_scale = 0.5,
	husk_position_lerp_speed = 20,
	time_to_despawn_corpse = 5,
	gravity = 11.82,
	crouch_move_speed = 1.4,
	ladder_cooldown = 0.5,
	default_wielded_slot_name = "slot_primary",
	duration_to_hanging_position_from_hang_ledge = 0.2,
	ladder_top_leaving_animation_time = 1,
	ledge_hanging_to_ground_safe_distance = 1.2,
	deceleration = 6,
	jump_speed = 4,
	hang_ledge_spawn_offset = 0.5,
	hub_gravity = 35.46,
	max_meta_buffs = 10,
	ladder_jump_backwards_force = 8.5,
	step_up_max_distance = 1.5,
	netted_drag_destination_size = 0.25,
	respawn_beacon_spot_height = 2.3,
	jump_step_up_speed = 2,
	move_speed = 4,
	ladder_top_entering_time = 1,
	warp_grabbed_drag_destination_size = 0.15,
	netted_fp_anim_duration = 0.6666666666666666,
	netted_damage_tick_buff = "netted_damage_tick",
	hub_movement = {
		movement_settings = {
			human = HubMovementSettingsTemplates.human,
			ogryn = HubMovementSettingsTemplates.ogryn
		},
		move_method_anims = {
			moving = {
				from_still_turn_anims = {
					left_180 = "start_180_lft",
					right_45 = "start_45_rgt",
					right_180 = "start_180_rgt",
					forward = "start_0",
					right_135 = "start_135_rgt",
					left_45 = "start_45_lft",
					left_90 = "start_90_lft",
					left_135 = "start_135_lft",
					right_90 = "start_90_rgt"
				},
				from_movement_turn_anims = {
					left_180 = "start_180_lft",
					right_45 = "start_45_rgt",
					right_180 = "start_180_rgt",
					forward = "start_0",
					right_135 = "start_135_rgt",
					left_45 = "start_45_lft",
					left_90 = "start_90_lft",
					left_135 = "start_135_lft",
					right_90 = "start_90_rgt"
				}
			},
			idle = {
				from_movement_stop_anims = {
					sprint = "idle_sprint",
					jog = "idle_jog",
					walk = "idle_walk"
				}
			},
			turn_on_spot = {
				from_still_turn_anims = {
					left_180 = "idle_turn_180_lft",
					right_45 = "idle_turn_45_rgt",
					right_180 = "idle_turn_180_rgt",
					forward = "idle_turn_0",
					right_135 = "idle_turn_135_rgt",
					left_45 = "idle_turn_45_lft",
					left_90 = "idle_turn_90_lft",
					left_135 = "idle_turn_135_lft",
					right_90 = "idle_turn_90_rgt"
				},
				from_movement_turn_anims = {
					left_180 = "start_180_lft",
					right_45 = "start_45_rgt",
					right_180 = "start_180_rgt",
					forward = "start_0",
					right_135 = "start_135_rgt",
					left_45 = "start_45_lft",
					left_90 = "start_90_lft",
					left_135 = "start_135_lft",
					right_90 = "start_90_rgt"
				}
			}
		}
	},
	climb_pitch_offset = math.pi / 8,
	air_directional_speed_scale_angle = math.pi / 2,
	air_drag_angle = math.pi / 6,
	slide_friction_function = function (speed, slide_time)
		local grace_time = 0.5
		local lerp_time = 0.2

		if slide_time < grace_time then
			return 0
		else
			local friction_threshold = 7
			local speed_threshold = 4
			local friction_speed = (speed < speed_threshold and math.lerp(10, friction_threshold, speed / speed_threshold)) or friction_threshold

			if slide_time < grace_time + lerp_time then
				return math.lerp(0, friction_speed, (slide_time - grace_time) / lerp_time)
			else
				return friction_speed
			end
		end
	end,
	push_friction_function = function (push_speed, on_ground)
		local friction_speed = nil

		if on_ground then
			friction_speed = 15
		else
			friction_speed = 0.00225 * push_speed * push_speed
		end

		return friction_speed
	end,
	slot_configuration = {
		slot_body_face = {
			wieldable = false,
			mispredict_packages = true,
			priority = 10,
			profile_field = true,
			slot_type = "body",
			slot_dependencies = {
				"slot_body_face_tattoo",
				"slot_body_face_scar",
				"slot_body_face_hair",
				"slot_body_eye_color",
				"slot_body_skin_color",
				"slot_body_hair_color",
				"slot_body_hair",
				"slot_gear_head"
			}
		},
		slot_body_face_hair = {
			wieldable = false,
			mispredict_packages = true,
			priority = 12,
			profile_field = true,
			slot_type = "body",
			slot_dependencies = {
				"slot_body_hair_color"
			}
		},
		slot_body_face_scar = {
			wieldable = false,
			mispredict_packages = true,
			priority = 12,
			profile_field = true,
			slot_type = "body",
			slot_dependencies = {
				"slot_body_skin_color"
			}
		},
		slot_body_face_tattoo = {
			wieldable = false,
			mispredict_packages = true,
			priority = 12,
			profile_field = true,
			slot_type = "body"
		},
		slot_body_arms = {
			wieldable = false,
			mispredict_packages = true,
			priority = 10,
			profile_field = true,
			slot_type = "body",
			slot_dependencies = {
				"slot_body_tattoo",
				"slot_body_face_tattoo",
				"slot_body_skin_color"
			}
		},
		slot_body_hair = {
			wieldable = false,
			mispredict_packages = true,
			priority = 12,
			profile_field = true,
			slot_type = "body",
			slot_dependencies = {
				"slot_body_hair_color"
			}
		},
		slot_body_legs = {
			wieldable = false,
			mispredict_packages = true,
			priority = 10,
			profile_field = true,
			slot_type = "body",
			slot_dependencies = {
				"slot_body_tattoo",
				"slot_body_face_tattoo",
				"slot_body_skin_color"
			}
		},
		slot_body_tattoo = {
			wieldable = false,
			mispredict_packages = true,
			priority = 11,
			profile_field = true,
			slot_type = "body",
			slot_dependencies = {
				"slot_body_face_tattoo"
			}
		},
		slot_body_torso = {
			wieldable = false,
			mispredict_packages = true,
			priority = 10,
			profile_field = true,
			slot_type = "body",
			slot_dependencies = {
				"slot_body_tattoo",
				"slot_body_face_tattoo",
				"slot_body_skin_color"
			}
		},
		slot_body_eye_color = {
			wieldable = false,
			mispredict_packages = true,
			priority = 50,
			profile_field = true,
			slot_type = "body"
		},
		slot_body_hair_color = {
			wieldable = false,
			mispredict_packages = true,
			priority = 50,
			profile_field = true,
			slot_type = "body"
		},
		slot_body_skin_color = {
			wieldable = false,
			mispredict_packages = true,
			priority = 50,
			profile_field = true,
			slot_type = "body"
		},
		slot_gear_extra_cosmetic = {
			wieldable = false,
			mispredict_packages = true,
			priority = 30,
			profile_field = true,
			slot_type = "gear"
		},
		slot_gear_head = {
			wieldable = false,
			mispredict_packages = true,
			priority = 30,
			profile_field = true,
			slot_type = "gear",
			slot_dependencies = {
				"slot_body_skin_color"
			}
		},
		slot_gear_lowerbody = {
			wieldable = false,
			mispredict_packages = true,
			priority = 30,
			profile_field = true,
			slot_type = "gear"
		},
		slot_gear_upperbody = {
			wieldable = false,
			mispredict_packages = true,
			priority = 30,
			profile_field = true,
			slot_type = "gear"
		},
		slot_attachment_1 = {
			slot_type = "gadget",
			mispredict_packages = true,
			display_name = "loc_inventory_title_slot_attachment_1",
			profile_field = true,
			wieldable = false,
			hide_unit_in_slot = true,
			priority = 40
		},
		slot_attachment_2 = {
			slot_type = "gadget",
			mispredict_packages = true,
			display_name = "loc_inventory_title_slot_attachment_2",
			profile_field = true,
			wieldable = false,
			hide_unit_in_slot = true,
			priority = 40
		},
		slot_attachment_3 = {
			slot_type = "gadget",
			mispredict_packages = true,
			display_name = "loc_inventory_title_slot_attachment_3",
			profile_field = true,
			wieldable = false,
			hide_unit_in_slot = true,
			priority = 40
		},
		slot_luggable = {
			disallow_ladders_on_wield = true,
			mispredict_packages = false,
			use_existing_unit_3p = true,
			priority = 1,
			wieldable = true,
			slot_type = "luggable"
		},
		slot_primary = {
			profile_field = true,
			mispredict_packages = true,
			wield_input = "wield_1",
			priority = 1,
			wieldable = true,
			slot_type = "weapon",
			buffable = true
		},
		slot_secondary = {
			profile_field = true,
			mispredict_packages = true,
			wield_input = "wield_2",
			priority = 1,
			wieldable = true,
			slot_type = "weapon",
			buffable = true
		},
		slot_pocketable = {
			priority = 1,
			mispredict_packages = false,
			wield_input = "wield_3",
			wieldable = true,
			slot_type = "pocketable"
		},
		slot_device = {
			wieldable = true,
			slot_type = "device",
			wield_input = "wield_4",
			priority = 1
		},
		slot_unarmed = {
			wieldable = true,
			slot_type = "unarmed",
			mispredict_packages = true,
			priority = 1
		},
		slot_combat_ability = {
			wieldable = true,
			slot_type = "ability",
			mispredict_packages = true,
			priority = 1
		},
		slot_grenade_ability = {
			wieldable = true,
			slot_type = "ability",
			mispredict_packages = true,
			priority = 1
		},
		slot_net = {
			wieldable = false,
			slot_type = "vfx",
			priority = 1
		}
	},
	quick_wield_configuration = {
		default = "slot_primary",
		slot_primary = "slot_secondary"
	},
	scroll_wield_order = {
		"slot_primary",
		"slot_secondary",
		"slot_pocketable",
		slot_primary = 1,
		slot_secondary = 2,
		slot_pocketable = 3
	},
	previously_wielded_slot_types = {
		weapon = true,
		ability = true,
		pocketable = true
	},
	ability_configuration = {
		combat_ability = "slot_combat_ability",
		grenade_ability = "slot_grenade_ability"
	},
	player_interactions = {
		{
			interaction_type = "pull_up",
			override_context = {}
		},
		{
			interaction_type = "rescue",
			override_context = {}
		},
		{
			interaction_type = "revive",
			override_context = {}
		},
		{
			interaction_type = "remove_net",
			override_context = {}
		}
	},
	animation_rollback = {
		num_layers_3p = 6,
		num_layers_1p = 11
	},
	animation_variables_to_cache = {
		third_person = {
			"anim_move_speed",
			"climb_time",
			"aim"
		},
		first_person = {}
	},
	inventory_component_data = {
		weapon = {
			current_ammunition_clip = {
				default_value = 0,
				network_type = "ammunition"
			},
			current_ammunition_reserve = {
				default_value = 0,
				network_type = "ammunition"
			},
			max_ammunition_clip = {
				default_value = 0,
				network_type = "ammunition"
			},
			max_ammunition_reserve = {
				default_value = 0,
				network_type = "ammunition"
			},
			reload_state = {
				default_value = "none",
				network_type = RELOAD_STATES
			},
			overheat_state = {
				default_value = "idle",
				network_type = {
					"idle",
					"increasing",
					"decreasing",
					"exploding"
				}
			},
			overheat_last_charge_at_t = {
				default_value = 0,
				network_type = "fixed_frame_offset_start_t_6bit"
			},
			overheat_remove_at_t = {
				default_value = 0,
				network_type = "fixed_frame_offset_end_t_6bit"
			},
			overheat_current_percentage = {
				default_value = 0,
				network_type = "weapon_overheat"
			},
			overheat_starting_percentage = {
				default_value = 0,
				network_type = "weapon_overheat"
			},
			special_active = {
				default_value = false,
				network_type = "bool"
			},
			num_special_activations = {
				default_value = 0,
				network_type = "num_special_activations"
			},
			special_active_start_t = {
				default_value = 0,
				network_type = "fixed_frame_offset_start_t_6bit"
			},
			powered_weapon_intensity = {
				default_value = 0,
				network_type = "powered_weapon_intensity"
			}
		},
		luggable = {
			existing_unit_3p = {
				network_type = "Unit"
			}
		},
		unarmed = {},
		pocketable = {},
		ability = {},
		device = {}
	},
	fall_damage = {
		warning_wwise_stop_event = "wwise/events/player/stop_foley_fall_wind_2D",
		warning_height = 4,
		landing_wwise_parameter = "fall_height",
		max_damage_height = 25,
		min_damage_height = 7,
		warning_wwise_event = "wwise/events/player/play_foley_fall_wind_2D",
		max_power_level = 1000,
		landing_wwise_event = "wwise/events/player/play_player_experience_fall_damage_2d",
		heavy_damage_height = 13,
		damage_profile_light = DamageProfileTemplates.falling_light,
		damage_type_light = damage_types.kinetic,
		damage_profile_heavy = DamageProfileTemplates.falling_heavy,
		damage_type_heavy = damage_types.kinetic
	},
	critical_health = {
		health_percent_limit = 0.25,
		toughness_percent_limit = 0.3
	},
	coherency = {
		radius = 8,
		stickiness_limit = 20,
		stickiness_time = 2,
		buff_template_names = {
			"coherency_toughness_regen"
		}
	}
}
local inventory_component_data = constants.inventory_component_data
local weapon_component_data = inventory_component_data.weapon

for _, lookups in pairs(buff_target_component_lookups) do
	for i = 1, #lookups, 1 do
		local key = lookups[i]

		fassert(weapon_component_data[key] == nil, "weapon_component_data already has %q defined.", key)

		weapon_component_data[key] = {
			default_value = -1,
			network_type = "buff_id"
		}
	end
end

local wield_inputs = {
	{
		value = true,
		input = "quick_wield"
	},
	{
		value = true,
		input = "wield_prev"
	},
	{
		value = true,
		input = "wield_next"
	}
}
local slot_configuration = constants.slot_configuration

for slot_name, config in pairs(slot_configuration) do
	fassert(config.name == nil, "Variable name \"name\" is occupied.")

	config.name = slot_name

	if config.wieldable and config.wield_input then
		fassert(not table.find(wield_inputs, config.wield_input), "Same wield input %q to multiple slots.", config.wield_input)

		wield_inputs[#wield_inputs + 1] = {
			value = true,
			input = config.wield_input
		}
	end
end

constants.wield_inputs = wield_inputs
local slot_configuration_by_type = {}

for slot_name, config in pairs(slot_configuration) do
	local slot_type = config.slot_type

	if not slot_configuration_by_type[slot_type] then
		slot_configuration_by_type[slot_type] = {}
	end

	slot_configuration_by_type[slot_type][slot_name] = config
end

constants.slot_configuration_by_type = slot_configuration_by_type
local equip_order = {}
local slot_priorities = {}

for slot_name, config in pairs(slot_configuration) do
	slot_priorities[#slot_priorities + 1] = {
		slot_name = slot_name,
		priority = config.priority
	}
end

table.sort(slot_priorities, function (a, b)
	return a.priority < b.priority
end)

for i = 1, #slot_priorities, 1 do
	local slot_name = slot_priorities[i].slot_name
	equip_order[#equip_order + 1] = slot_name
end

constants.slot_equip_order = equip_order

for slot_name, config in pairs(slot_configuration) do
	local slot_dependencies = config.slot_dependencies

	if slot_dependencies then
		for _, slot_dependency in pairs(slot_dependencies) do
			local slot_dependency_config = slot_configuration[slot_dependency]

			fassert(slot_dependency_config, "Slot %s does not exist in player constants slot config and is not a valid dependency, please fix the player constants.", slot_dependency)

			local slot_dependency_config_dependencies = slot_dependency_config.slot_dependencies

			if slot_dependency_config_dependencies then
				fassert(not table.contains(slot_dependency_config_dependencies, slot_name), "Slot %s is introducing a circular dependency by including a dependency on slot %s, please fix the player constants.", slot_name, slot_dependency)
			end
		end
	end
end

local buff_component_key_lookup = {}

for i = 1, constants.max_component_buffs, 1 do
	buff_component_key_lookup[i] = {
		template_name_key = "buff_" .. i .. "_template_name",
		start_time_key = "buff_" .. i .. "_start_time",
		active_start_time_key = "buff_" .. i .. "_active_start_time",
		stack_count_key = "buff_" .. i .. "_stack_count",
		proc_count_key = "buff_" .. i .. "_proc_count"
	}
end

constants.buff_component_key_lookup = buff_component_key_lookup
constants.player_package_aliases = {}
local quick_wield_configuration = constants.quick_wield_configuration

for from_slot, to_slot in pairs(quick_wield_configuration) do
	if from_slot ~= "default" then
		fassert(slot_configuration[from_slot], "quick_wield_config has a slot_name %q that does not exist in slot_configuration.", from_slot)
	end

	fassert(slot_configuration[to_slot], "quick_wield_config has a slot_name %q that does not exist in slot_configuration.", to_slot)
end

return settings("PlayerCharacterConstants", constants)
