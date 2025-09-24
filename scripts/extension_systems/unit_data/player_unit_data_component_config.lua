-- chunkname: @scripts/extension_systems/unit_data/player_unit_data_component_config.lua

local AbilityTemplates = require("scripts/settings/ability/ability_templates/ability_templates")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local DisorientationSettings = require("scripts/settings/damage/disorientation_settings")
local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local InteractionTemplates = require("scripts/settings/interaction/interaction_templates")
local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerCharacterFxSourceNames = require("scripts/settings/fx/player_character_fx_source_names")
local PlayerCharacterLoopingParticleAliases = require("scripts/settings/particles/player_character_looping_particle_aliases")
local PlayerCharacterStates = require("scripts/settings/player_character/player_character_states")
local PlayerUnitAnimationStateConfig = require("scripts/extension_systems/animation/utilities/player_unit_animation_state_config")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local tweak_template_types = WeaponTweakTemplateSettings.template_types
local animation_rollback = PlayerCharacterConstants.animation_rollback
local NUM_LAYERS_3P, NUM_LAYERS_1P = animation_rollback.num_layers_3p, animation_rollback.num_layers_1p
local TIMES_3P, ANIMATIONS_3P, STATES_3P, TIMES_1P, ANIMATIONS_1P, STATES_1P = PlayerUnitAnimationStateConfig.format(animation_rollback)
local animation_state_component = {
	num_layers_1p = "player_anim_layer",
	num_layers_3p = "player_anim_layer",
}

for i = 1, NUM_LAYERS_3P do
	animation_state_component[TIMES_3P[i]] = "player_anim_time"
	animation_state_component[ANIMATIONS_3P[i]] = "player_anim"
	animation_state_component[STATES_3P[i]] = "player_anim_state"
end

for i = 1, NUM_LAYERS_1P do
	animation_state_component[TIMES_1P[i]] = "player_anim_time"
	animation_state_component[ANIMATIONS_1P[i]] = "player_anim"
	animation_state_component[STATES_1P[i]] = "player_anim_state"
end

local fx_source_names = table.keys(PlayerCharacterFxSourceNames)

table.sort(fx_source_names)

local FX_SOURCES = {
	"n/a",
}

for fx_source_name_index = 1, #fx_source_names do
	local name = fx_source_names[fx_source_name_index]

	FX_SOURCES[#FX_SOURCES + 1] = name
end

local slot_configuration = PlayerCharacterConstants.slot_configuration
local slot_names = table.keys(slot_configuration)

table.sort(slot_names)

local INVENTORY_SLOTS = {
	"none",
}
local WEAPON_INVENTORY_SLOTS = {
	"none",
}

for slot_names_index = 1, #slot_names do
	local slot_name = slot_names[slot_names_index]
	local config = slot_configuration[slot_name]

	INVENTORY_SLOTS[#INVENTORY_SLOTS + 1] = slot_name

	if config.slot_type == "weapon" then
		WEAPON_INVENTORY_SLOTS[#WEAPON_INVENTORY_SLOTS + 1] = slot_name
	end
end

INVENTORY_SLOTS.network_type = "player_inventory_slot_name"

local character_state_names = table.keys(PlayerCharacterStates)

table.sort(character_state_names)

local CHARACTER_STATES = {
	"dummy",
}

for character_state_name_index = 1, #character_state_names do
	local name = character_state_names[character_state_name_index]

	CHARACTER_STATES[#CHARACTER_STATES + 1] = name
end

Managers.backend.interfaces.master_data:refresh_network_lookup()

local PLAYER_ITEMS = {}

PLAYER_ITEMS.network_type = "player_item_name"
PLAYER_ITEMS.use_network_lookup = "player_item_names"

local WEAPON_TEMPLATES = {
	"none",
}
local WEAPON_ACTIONS = {
	"none",
}
local WEAPON_TEMPLATE_NAMES = table.keys(WeaponTemplates)

table.sort(WEAPON_TEMPLATE_NAMES)

for weapon_template_name_index = 1, #WEAPON_TEMPLATE_NAMES do
	local weapon_template_name = WEAPON_TEMPLATE_NAMES[weapon_template_name_index]
	local weapon_template = WeaponTemplates[weapon_template_name]

	WEAPON_TEMPLATES[#WEAPON_TEMPLATES + 1] = weapon_template_name

	local action_names = table.keys(weapon_template.actions)

	table.sort(action_names)

	for action_name_index = 1, #action_names do
		local name = action_names[action_name_index]

		if not table.find(WEAPON_ACTIONS, name) then
			WEAPON_ACTIONS[#WEAPON_ACTIONS + 1] = name
		end
	end
end

local ABILITY_TEMPLATES = {
	"none",
}
local ABILITY_ACTIONS = {
	"none",
}
local ability_template_names = table.keys(AbilityTemplates)

table.sort(ability_template_names)

for ability_template_name_index = 1, #ability_template_names do
	local ability_template_name = ability_template_names[ability_template_name_index]
	local ability_template = AbilityTemplates[ability_template_name]

	ABILITY_TEMPLATES[#ABILITY_TEMPLATES + 1] = ability_template_name

	local action_names = table.keys(ability_template.actions)

	table.sort(action_names)

	for action_name_index = 1, #action_names do
		local name = action_names[action_name_index]

		if not table.find(ABILITY_ACTIONS, name) then
			ABILITY_ACTIONS[#ABILITY_ACTIONS + 1] = name
		end
	end
end

local function _extract_weapon_tweak_template_names(target_table, tweak_type)
	for weapon_template_name_index = 1, #WEAPON_TEMPLATE_NAMES do
		local weapon_template_name = WEAPON_TEMPLATE_NAMES[weapon_template_name_index]
		local weapon_template = WeaponTemplates[weapon_template_name]
		local base_template_lookup = weapon_template.__base_template_lookup
		local tweak_templates = base_template_lookup[tweak_type]
		local tweak_template_keys = table.keys(tweak_templates)

		table.sort(tweak_template_keys)

		for tweak_template_key_index = 1, #tweak_template_keys do
			local lookup_type = tweak_template_keys[tweak_template_key_index]
			local lookup_entry = tweak_templates[lookup_type]
			local new_identifier = lookup_entry.new_identifier

			if not table.find(target_table, new_identifier) then
				target_table[#target_table + 1] = new_identifier
			end
		end
	end
end

local RECOIL_TEMPLATES = {
	"none",
}

_extract_weapon_tweak_template_names(RECOIL_TEMPLATES, tweak_template_types.recoil)

local WEAPON_HANDLING_TEMPLATES = {
	"none",
}

_extract_weapon_tweak_template_names(WEAPON_HANDLING_TEMPLATES, tweak_template_types.weapon_handling)

local WEAPON_SHOUT_TEMPLATES = {
	"none",
}

_extract_weapon_tweak_template_names(WEAPON_SHOUT_TEMPLATES, tweak_template_types.weapon_shout)

local SWAY_TEMPLATES = {
	"none",
}

_extract_weapon_tweak_template_names(SWAY_TEMPLATES, tweak_template_types.sway)

local SUPPRESSION_TEMPLATES = {
	"none",
}

_extract_weapon_tweak_template_names(SUPPRESSION_TEMPLATES, tweak_template_types.suppression)

local SPREAD_TEMPLATES = {
	"none",
}

_extract_weapon_tweak_template_names(SPREAD_TEMPLATES, tweak_template_types.spread)

local DODGE_TEMPLATES = {
	"none",
}

_extract_weapon_tweak_template_names(DODGE_TEMPLATES, tweak_template_types.dodge)

local SPRINT_TEMPLATES = {
	"none",
}

_extract_weapon_tweak_template_names(SPRINT_TEMPLATES, tweak_template_types.sprint)

local STAMINA_TEMPLATES = {
	"none",
}

_extract_weapon_tweak_template_names(STAMINA_TEMPLATES, tweak_template_types.stamina)

local TOUGHNESS_TEMPLATES = {
	"none",
}

_extract_weapon_tweak_template_names(TOUGHNESS_TEMPLATES, tweak_template_types.toughness)

local AMMO_TEMPLATES = {
	"none",
}

_extract_weapon_tweak_template_names(AMMO_TEMPLATES, tweak_template_types.ammo)

local MOVEMENT_CURVE_MODIFIER_TEMPLATES = {
	"none",
}

_extract_weapon_tweak_template_names(MOVEMENT_CURVE_MODIFIER_TEMPLATES, tweak_template_types.movement_curve_modifier)

local CHARGE_TEMPLATES = {
	"none",
}

_extract_weapon_tweak_template_names(CHARGE_TEMPLATES, tweak_template_types.charge)

local WARP_CHARGE_TEMPLATES = {
	"none",
}

_extract_weapon_tweak_template_names(WARP_CHARGE_TEMPLATES, tweak_template_types.warp_charge)

local BURNINATING_TEMPLATES = {
	"none",
}

_extract_weapon_tweak_template_names(BURNINATING_TEMPLATES, tweak_template_types.burninating)

local SIZE_OF_FLAME_TEMPLATES = {
	"none",
}

_extract_weapon_tweak_template_names(SIZE_OF_FLAME_TEMPLATES, tweak_template_types.size_of_flame)

local PLAYER_ABILITIES = {
	"none",
}
local player_ability_names = table.keys(PlayerAbilities)

table.sort(player_ability_names)

for player_ability_name_index = 1, #player_ability_names do
	local player_ability_name = player_ability_names[player_ability_name_index]

	PLAYER_ABILITIES[#PLAYER_ABILITIES + 1] = player_ability_name
end

local DISORIENTATION_TYPES = {
	"none",
}
local disorientation_type_names = table.keys(DisorientationSettings.disorientation_types)

table.sort(disorientation_type_names)

for disorientation_type_name_index = 1, #disorientation_type_names do
	local disorientation_type_name = disorientation_type_names[disorientation_type_name_index]

	DISORIENTATION_TYPES[#DISORIENTATION_TYPES + 1] = disorientation_type_name
end

local INTERACTION_TEMPLATES = {
	"none",
}
local interaction_template_names = table.keys(InteractionTemplates)

table.sort(interaction_template_names)

for interaction_template_name_index = 1, #interaction_template_names do
	local interaction_template_name = interaction_template_names[interaction_template_name_index]

	if not table.find(INTERACTION_TEMPLATES, interaction_template_name) then
		INTERACTION_TEMPLATES[#INTERACTION_TEMPLATES + 1] = interaction_template_name
	end
end

local INTERACTION_STATES = {
	"none",
}
local interaction_state_names = table.keys(InteractionSettings.states)

table.sort(interaction_state_names)

for interaction_state_name_index = 1, #interaction_state_names do
	local interaction_state_name = interaction_state_names[interaction_state_name_index]

	if not table.find(INTERACTION_STATES, interaction_state_name) then
		INTERACTION_STATES[#INTERACTION_STATES + 1] = interaction_state_name
	end
end

local PREDICTED_BUFF_TEMPLATES = {
	"none",
}
local predicted_buff_template_names = {}

for name, _ in pairs(BuffTemplates.PREDICTED) do
	if not table.find(PREDICTED_BUFF_TEMPLATES, name) then
		table.insert(predicted_buff_template_names, name)
	end
end

table.sort(predicted_buff_template_names)

local PREDICTED_BUFF_TEMPLATES = {
	"none",
}

for buff_template_name_index = 1, #predicted_buff_template_names do
	local buff_template_name = predicted_buff_template_names[buff_template_name_index]

	PREDICTED_BUFF_TEMPLATES[#PREDICTED_BUFF_TEMPLATES + 1] = buff_template_name
end

local LUNGE_TEMPLATES = {
	"none",
}
local lunge_template_names = table.keys(LungeTemplates)

table.sort(lunge_template_names)

for lunge_template_name_index = 1, #lunge_template_names do
	local lunge_template_name = lunge_template_names[lunge_template_name_index]

	LUNGE_TEMPLATES[#LUNGE_TEMPLATES + 1] = lunge_template_name
end

local inventory_component = {
	wielded_slot = INVENTORY_SLOTS,
	previously_wielded_slot = INVENTORY_SLOTS,
	previously_wielded_weapon_slot = INVENTORY_SLOTS,
}

for slot_name, _ in pairs(slot_configuration) do
	inventory_component[slot_name] = PLAYER_ITEMS
end

local CAMERA_TREES = {
	skip_predict_verification = true,
}
local CAMERA_NODES = {
	skip_predict_verification = true,
}

do
	local function _gather_camera_tree_nodes(tree, node_map, num_nodes, node_list)
		local stack_size = 1
		local stack = {
			tree,
		}

		while stack_size > 0 do
			local node = stack[stack_size]

			stack[stack_size] = nil
			stack_size = stack_size - 1

			local node_name = node._node.name

			if node_name and not node_map[node_name] then
				num_nodes = num_nodes + 1
				node_list[num_nodes] = node_name
			end

			for i = 1, #node do
				local child = node[i]

				stack_size = stack_size + 1
				stack[stack_size] = child
			end
		end

		return num_nodes
	end

	local CameraSettings = require("scripts/settings/camera/camera_settings")
	local num_trees = 0
	local num_nodes = 0
	local parsed_nodes = {}
	local sorted_camera = table.keys(CameraSettings)

	table.sort(sorted_camera)

	for _, key in ipairs(sorted_camera) do
		num_nodes = _gather_camera_tree_nodes(CameraSettings[key], parsed_nodes, num_nodes, CAMERA_NODES)
	end

	local CameraTrees = require("scripts/settings/camera/camera_trees")

	sorted_camera = table.keys(CameraTrees)

	table.sort(sorted_camera)

	for _, tree_id in ipairs(sorted_camera) do
		num_trees = num_trees + 1
		CAMERA_TREES[num_trees] = tree_id
	end
end

local PlayerComponentConfig = {
	locomotion_steering = {
		calculate_fall_velocity = "bool",
		disable_minion_collision = "bool",
		disable_push_velocity = "bool",
		disable_velocity_rotation = "bool",
		hub_active_stopping = "bool",
		local_move_x = "local_move_speed",
		local_move_y = "local_move_speed",
		rotation_based_on_wanted_velocity = "bool",
		target_rotation = "Quaternion",
		target_translation = "Vector3",
		velocity_wanted = "Vector3",
		move_method = {
			"script_driven",
			"script_driven_hub",
		},
	},
	locomotion_force_rotation = {
		end_time = "fixed_frame_offset",
		start_rotation = "Quaternion",
		start_time = "fixed_frame_offset",
		use_force_rotation = "bool",
	},
	locomotion_force_translation = {
		end_time = "fixed_frame_offset",
		start_time = "fixed_frame_offset",
		start_translation = "Vector3",
		use_force_translation = "bool",
	},
	locomotion_push = {
		new_velocity = "Vector3",
		time_to_apply = "fixed_frame_offset_end_t_4bit",
		velocity = "Vector3",
	},
	movement_state = {
		can_crouch = "bool",
		can_exit_crouch = "bool",
		can_jump = "bool",
		is_crouching = "bool",
		is_crouching_transition_start_t = "fixed_frame_offset_small",
		is_dodging = "bool",
		is_effective_dodge = "bool",
		method = {
			"falling",
			"jumping",
			"ladder_idle",
			"ladder_climbing",
			"move_fwd",
			"move_bwd",
			"idle",
			"sprint",
			"lunging",
			"dodging",
			"sliding",
			"vaulting",
		},
	},
	intoxicated_movement = {
		in_stagger = "bool",
		stagger_cooldown = "fixed_frame_offset_end_t_7bit",
		stagger_direction = "high_precision_direction",
		stagger_end_t = "fixed_frame_offset_end_t_7bit",
		stagger_start_t = "fixed_frame_offset_start_t_7bit",
	},
	hub_jog_character_state = {
		force_old_input_end_t = "fixed_frame_offset_end_t_6bit",
		force_old_input_start_t = "fixed_frame_offset_start_t_6bit",
		move_start_delay_t = "fixed_frame_offset_end_t_6bit",
		move_state_start_t = "fixed_frame_offset_start_t_6bit",
		method = {
			"moving",
			"idle",
			"turn_on_spot",
		},
		move_state = {
			"walk",
			"jog",
			"sprint",
		},
		previous_move_state = {
			"walk",
			"jog",
			"sprint",
		},
	},
	walking_character_state = {
		previous_state_allowed_slide = "bool",
	},
	sprint_character_state = {
		cooldown = "fixed_frame_offset",
		is_sprint_jumping = "bool",
		is_sprinting = "bool",
		last_sprint_time = "fixed_frame_offset",
		sprint_overtime = "fixed_frame_offset",
		use_sprint_start_slowdown = "bool",
		wants_sprint_camera = "bool",
	},
	slide_character_state = {
		was_in_dodge_cooldown = "bool",
		friction_function = {
			"default",
			"sprint",
			"ineffective_slide",
		},
	},
	ledge_vaulting_character_state = {
		forward = "Vector3",
		is_step_up = "bool",
		left = "Vector3",
		right = "Vector3",
		traverse_velocity = "Vector3",
		was_sprinting = "bool",
	},
	character_state = {
		entered_t = "fixed_frame_offset",
		state_name = CHARACTER_STATES,
		previous_state_name = CHARACTER_STATES,
	},
	character_state_random = {
		seed = "random_seed",
	},
	character_state_hit_mass = {
		used_hit_mass_percentage = "percentage",
	},
	animation_state = animation_state_component,
	inair_state = {
		fell_from_height = "high_precision_position_component",
		flying_frames = "mover_frames",
		inair_entered_t = "fixed_frame_offset",
		on_ground = "bool",
		standing_frames = "mover_frames",
	},
	locomotion = {
		parent_unit = "locomotion_parent",
		position = "locomotion_position",
		rotation = "locomotion_rotation",
		velocity_current = "Vector3",
	},
	player_unit_linker = {
		linked = "bool",
		parent_unit = "Unit",
		parent_node = {
			"none",
			"j_leftweaponattach",
			"j_tongue_attach",
			"j_spine",
			"root_point",
			"j_lefthand",
		},
		node = {
			"none",
			"j_hips",
		},
	},
	first_person = {
		height = "character_height",
		height_change_duration = "short_time",
		height_change_start_time = "fixed_frame_offset",
		old_height = "character_height",
		position = "locomotion_position",
		previous_rotation = "locomotion_rotation",
		rotation = "locomotion_rotation",
		wanted_height = "character_height",
		height_change_function = {
			"ease_out_quad",
			"ease_in_cubic",
		},
	},
	force_look_rotation = {
		end_time = "fixed_frame_offset",
		start_pitch = "rotation_single",
		start_time = "fixed_frame_offset",
		start_yaw = "rotation_single",
		use_force_look_rotation = "bool",
		wanted_pitch = "rotation_single",
		wanted_yaw = "rotation_single",
	},
	first_person_mode = {
		show_1p_equipment_at_t = "fixed_frame_offset",
		wants_1p_camera = "bool",
	},
	inventory = inventory_component,
	movement_settings = {
		player_speed_scale = "movement_settings",
	},
	minigame_character_state = {
		interface_game_object_id = "game_object_id",
		interface_is_level_unit = "bool",
		interface_level_unit_id = "level_unit_id",
		pocketable_device_active = "bool",
	},
	ladder_character_state = {
		end_position = "Vector3",
		ladder_cooldown = "fixed_frame_offset",
		ladder_unit_id = "level_unit_id",
		start_position = "Vector3",
		top_enter_leave_timer = "fixed_frame_offset",
	},
	assisted_state_input = {
		force_assist = "bool",
		in_progress = "bool",
		success = "bool",
	},
	dodge_character_state = {
		consecutive_dodges = "consecutive_dodges",
		consecutive_dodges_cooldown = "fixed_frame_offset",
		cooldown = "fixed_frame_offset",
		distance_left = "short_distance",
		dodge_direction = "Vector3",
		dodge_time = "fixed_frame_offset",
		jump_override_time = "fixed_frame_offset",
		started_from_crouch = "bool",
	},
	lunge_character_state = {
		direction = "Vector3",
		distance_left = "extra_long_distance",
		is_aiming = "bool",
		is_lunging = "bool",
		lunge_target = "Unit",
		lunge_template = LUNGE_TEMPLATES,
	},
	dead_state_input = {
		despawn_time = "short_time",
		die = "bool",
	},
	knocked_down_state_input = {
		knock_down = "bool",
	},
	hogtied_state_input = {
		hogtie = "bool",
	},
	stun_state_input = {
		push_direction = "Vector3",
		stun_frame = "fixed_frame_time",
		disorientation_type = DISORIENTATION_TYPES,
	},
	stunned_character_state = {
		actions_interrupted = "bool",
		exit_event_played = "bool",
		start_time = "fixed_frame_offset",
		stunned = "bool",
		disorientation_type = DISORIENTATION_TYPES,
	},
	exploding_character_state = {
		is_exploding = "bool",
		slot_name = INVENTORY_SLOTS,
		reason = {
			"overheat",
			"warp_charge",
		},
	},
	catapulted_state_input = {
		new_input = "bool",
		velocity = "Vector3",
	},
	disabled_state_input = {
		disabling_unit = "Unit",
		wants_disable = "bool",
		disabling_type = {
			"none",
			"netted",
			"pounced",
			"warp_grabbed",
			"mutant_charged",
			"consumed",
			"grabbed",
		},
		trigger_animation = {
			"none",
			"grabbed_execution",
			"smash",
			"throw",
			"throw_left",
			"throw_right",
			"throw_bwd",
		},
	},
	disabled_character_state = {
		disabling_unit = "Unit",
		has_reached_drag_position = "bool",
		is_disabled = "bool",
		target_drag_position = "Vector3",
		disabling_type = {
			"none",
			"netted",
			"pounced",
			"warp_grabbed",
			"mutant_charged",
			"consumed",
			"grabbed",
		},
	},
	debug_state_input = {
		self_assist = "bool",
	},
	ledge_hanging_character_state = {
		end_time_position_transition = "fixed_frame_offset",
		hang_ledge_unit = "Unit",
		is_interactible = "bool",
		position_hanging = "Vector3",
		position_pre_hanging = "Vector3",
		rotation_hanging = "Quaternion",
		rotation_pre_hanging = "Quaternion",
		start_time_position_transition = "fixed_frame_offset",
		time_to_fall_down = "fixed_frame_offset",
	},
	interacting_character_state = {
		interaction_template = INTERACTION_TEMPLATES,
	},
	falling_character_state = {
		has_reached_damagable_distance = "bool",
		likely_stuck = "bool",
		was_ledge_hanging = "bool",
	},
	weapon_lock_view = {
		pitch = "weapon_view_lock",
		yaw = "weapon_view_lock",
		state = {
			"in_active",
			"weapon_lock",
			"weapon_lock_no_lerp",
			"force_look",
		},
	},
	weapon_action = {
		combo_count = "action_combo_count",
		end_t = "fixed_frame_offset",
		is_infinite_duration = "bool",
		special_active_at_start = "bool",
		sprint_ready_time = "fixed_frame_offset",
		start_t = "fixed_frame_offset",
		time_scale = "action_time_scale",
		template_name = WEAPON_TEMPLATES,
		current_action_name = WEAPON_ACTIONS,
		previous_action_name = WEAPON_ACTIONS,
	},
	combat_ability_action = {
		combo_count = "action_combo_count",
		end_t = "fixed_frame_offset",
		is_infinite_duration = "bool",
		special_active_at_start = "bool",
		sprint_ready_time = "fixed_frame_offset",
		start_t = "fixed_frame_offset",
		time_scale = "action_time_scale",
		template_name = ABILITY_TEMPLATES,
		current_action_name = ABILITY_ACTIONS,
		previous_action_name = ABILITY_ACTIONS,
	},
	grenade_ability_action = {
		combo_count = "action_combo_count",
		end_t = "fixed_frame_offset",
		is_infinite_duration = "bool",
		special_active_at_start = "bool",
		sprint_ready_time = "fixed_frame_offset",
		start_t = "fixed_frame_offset",
		time_scale = "action_time_scale",
		template_name = ABILITY_TEMPLATES,
		current_action_name = ABILITY_ACTIONS,
		previous_action_name = ABILITY_ACTIONS,
	},
	pocketable_ability_action = {
		combo_count = "action_combo_count",
		end_t = "fixed_frame_offset",
		is_infinite_duration = "bool",
		special_active_at_start = "bool",
		sprint_ready_time = "fixed_frame_offset",
		start_t = "fixed_frame_offset",
		time_scale = "action_time_scale",
		template_name = ABILITY_TEMPLATES,
		current_action_name = ABILITY_ACTIONS,
		previous_action_name = ABILITY_ACTIONS,
	},
	action_throw_luggable = {
		thrown = "bool",
		slot_to_wield = INVENTORY_SLOTS,
	},
	action_place = {
		aiming_place = "bool",
		can_place = "bool",
		placed_on_unit = "Unit",
		position = "Vector3",
		rotation = "Quaternion",
		rotation_step = "rotation_step",
	},
	action_push = {
		has_pushed = "bool",
	},
	action_flamer_gas = {
		range = "low_precision_long_distance",
	},
	action_aim_projectile = {
		direction = "Vector3",
		momentum = "high_precision_velocity",
		position = "Vector3",
		rotation = "Quaternion",
		speed = "projectile_speed",
	},
	action_sweep = {
		attack_direction = "Vector3",
		is_sticky = "bool",
		reference_position = "Vector3",
		reference_rotation = "Quaternion",
		sweep_aborted_actor_index = "hit_zone_actor_index",
		sweep_aborted_bit_array = "lookup_2bit0",
		sweep_aborted_t = "fixed_frame_offset",
		sweep_aborted_unit = "Unit",
		sweep_state = {
			"before_damage_window",
			"during_damage_window",
			"after_damage_window",
		},
	},
	action_shoot = {
		current_fire_config = "lookup_1bit",
		fire_at_time = "fixed_frame_offset",
		fire_last_t = "fixed_frame_offset_start_t_9bit",
		num_shots_fired = "ammunition_small",
		shooting_charge_level = "weapon_charge_level",
		shooting_position = "Vector3",
		shooting_rotation = "Quaternion",
		started_from_sprint = "bool",
		fire_state = {
			"waiting_to_shoot",
			"prepare_shooting",
			"start_shooting",
			"shooting",
			"prepare_simultaneous_shot",
			"shot",
		},
	},
	action_shoot_pellets = {
		num_pellets_fired = "ammunition_small",
	},
	action_reload = {
		has_cleared_overheat = "bool",
		has_refilled_ammunition = "bool",
		has_removed_ammunition = "bool",
	},
	action_unwield = {
		slot_to_wield = INVENTORY_SLOTS,
	},
	action_module_charge = {
		charge_level = "weapon_charge_level",
		charge_start_time = "fixed_frame_offset",
		max_charge = "weapon_charge_level",
	},
	action_module_position_finder = {
		normal = "Vector3",
		position = "Vector3",
		position_valid = "bool",
	},
	action_module_target_finder = {
		target_unit_1 = "Unit",
		target_unit_2 = "Unit",
		target_unit_3 = "Unit",
	},
	sway = {
		offset_x = "weapon_sway_offset",
		offset_y = "weapon_sway_offset",
		pitch = "weapon_sway",
		yaw = "weapon_sway",
	},
	sway_control = {
		immediate_pitch = "weapon_sway",
		immediate_yaw = "weapon_sway",
	},
	spread = {
		pitch = "weapon_spread",
		yaw = "weapon_spread",
	},
	spread_control = {
		immediate_pitch = "weapon_spread",
		immediate_yaw = "weapon_spread",
		previous_pitch_offset = "weapon_spread",
		previous_yaw_offset = "weapon_spread",
		seed = "random_seed",
	},
	suppression = {
		decay_time = "short_time",
		spread_pitch = "weapon_spread",
		spread_yaw = "weapon_spread",
		sway_pitch = "weapon_sway",
		sway_yaw = "weapon_sway",
		time = "fixed_frame_offset",
	},
	recoil = {
		pitch_offset = "recoil_angle",
		unsteadiness = "recoil_unsteadiness",
		yaw_offset = "recoil_angle",
	},
	recoil_control = {
		num_shots = "ammunition_small",
		recoiling = "bool",
		rise_end_time = "fixed_frame_offset",
		seed = "random_seed",
		shooting = "bool",
		starting_rotation = "Quaternion",
		target_pitch = "recoil_angle",
		target_yaw = "recoil_angle",
	},
	shooting_status = {
		num_shots = "ammunition_small",
		shooting = "bool",
		shooting_end_time = "fixed_frame_offset",
	},
	block = {
		has_blocked = "bool",
		is_blocking = "bool",
		is_perfect_blocking = "bool",
	},
	alternate_fire = {
		is_active = "bool",
		start_t = "fixed_frame_offset",
	},
	peeking = {
		has_significant_obstacle_in_front = "bool",
		in_cover = "bool",
		is_peeking = "bool",
		peeking_height = "character_height",
		peeking_is_possible = "bool",
	},
	interaction = {
		done_time = "fixed_frame_time",
		duration = "fixed_frame_offset",
		start_time = "fixed_frame_time",
		target_actor_node_index = "actor_node_index",
		target_unit = "Unit",
		type = INTERACTION_TEMPLATES,
		state = INTERACTION_STATES,
	},
	interactee = {
		interacted_with = "bool",
		interactor_unit = "Unit",
	},
	stamina = {
		current_fraction = "stamina_fraction",
		last_drain_time = "fixed_frame_offset",
		regeneration_paused = "bool",
	},
	equipped_abilities = {
		combat_ability = PLAYER_ABILITIES,
		grenade_ability = PLAYER_ABILITIES,
		pocketable_ability = PLAYER_ABILITIES,
	},
	grenade_ability = {
		active = "bool",
		cooldown = "fixed_frame_time",
		cooldown_paused = "bool",
		enabled = "bool",
		num_charges = "ability_charges",
	},
	combat_ability = {
		active = "bool",
		cooldown = "fixed_frame_time",
		cooldown_paused = "bool",
		enabled = "bool",
		num_charges = "ability_charges",
	},
	pocketable_ability = {
		active = "bool",
		cooldown = "fixed_frame_time",
		cooldown_paused = "bool",
		enabled = "bool",
		num_charges = "ability_charges",
	},
	talent_resource = {
		current_resource = "talent_resource",
		max_resource = "talent_resource",
	},
	critical_strike = {
		is_active = "bool",
		num_critical_shots = "ammunition_small",
		prd_state = "prd_state",
		seed = "random_seed",
	},
	camera_tree = {
		tree = CAMERA_TREES,
		node = CAMERA_NODES,
	},
	weapon_tweak_templates = {
		ammo_template_name = AMMO_TEMPLATES,
		burninating_template_name = BURNINATING_TEMPLATES,
		charge_template_name = CHARGE_TEMPLATES,
		dodge_template_name = DODGE_TEMPLATES,
		movement_curve_modifier_template_name = MOVEMENT_CURVE_MODIFIER_TEMPLATES,
		recoil_template_name = RECOIL_TEMPLATES,
		size_of_flame_template_name = SIZE_OF_FLAME_TEMPLATES,
		spread_template_name = SPREAD_TEMPLATES,
		sprint_template_name = SPRINT_TEMPLATES,
		stamina_template_name = STAMINA_TEMPLATES,
		suppression_template_name = SUPPRESSION_TEMPLATES,
		sway_template_name = SWAY_TEMPLATES,
		toughness_template_name = TOUGHNESS_TEMPLATES,
		warp_charge_template_name = WARP_CHARGE_TEMPLATES,
		weapon_handling_template_name = WEAPON_HANDLING_TEMPLATES,
		weapon_shout_template_name = WEAPON_SHOUT_TEMPLATES,
	},
	aim_assist_ramp = {
		decay_end_time = "fixed_frame_offset_end_t_7bit",
		multiplier = "aim_assist_multiplier",
	},
	warp_charge = {
		current_percentage = "warp_charge",
		last_charge_at_t = "fixed_frame_offset_start_t_6bit",
		ramping_modifier = "warp_charge_ramping_modifier",
		remove_at_t = "fixed_frame_offset_end_t_7bit",
		starting_percentage = "warp_charge",
		state = {
			"idle",
			"increasing",
			"decreasing",
			"exploding",
		},
	},
	scanning = {
		is_active = "bool",
		line_of_sight = "bool",
		scannable_unit = "Unit",
	},
}
local inventory_slot_component_data = PlayerCharacterConstants.inventory_slot_component_data

for slot_name, config in pairs(slot_configuration) do
	if config.wieldable then
		local slot_type = config.slot_type
		local component_data = inventory_slot_component_data[slot_type]
		local component_config = {}

		for key, data in pairs(component_data) do
			component_config[key] = data.network_type
		end

		PlayerComponentConfig[slot_name] = component_config
	end
end

local max_component_buffs = PlayerCharacterConstants.max_component_buffs
local component_key_lookup = PlayerCharacterConstants.buff_component_key_lookup
local buff_component_config = {
	seed = "random_seed",
}

for ii = 1, max_component_buffs do
	local key_lookup = component_key_lookup[ii]
	local template_name_key = key_lookup.template_name_key
	local start_time_key = key_lookup.start_time_key
	local active_start_time_key = key_lookup.active_start_time_key
	local stack_count_key = key_lookup.stack_count_key
	local proc_count_key = key_lookup.proc_count_key

	buff_component_config[template_name_key] = PREDICTED_BUFF_TEMPLATES
	buff_component_config[start_time_key] = "fixed_frame_offset"
	buff_component_config[active_start_time_key] = "fixed_frame_offset"
	buff_component_config[stack_count_key] = "buff_stack_count"
	buff_component_config[proc_count_key] = "buff_proc_count"
end

PlayerComponentConfig.buff = buff_component_config

for looping_particle_alias, config in pairs(PlayerCharacterLoopingParticleAliases) do
	if not config.exclude_from_unit_data_components then
		local looping_particle_component = {
			is_playing = "bool",
		}

		if not config.screen_space then
			looping_particle_component.spawner_name = FX_SOURCES
		end

		local external_properties = config.external_properties

		if external_properties then
			for property_name, possible_properties in pairs(external_properties) do
				local properties = table.clone(possible_properties)

				properties[#properties + 1] = "n/a"
				looping_particle_component[property_name] = properties
			end
		end

		PlayerComponentConfig[looping_particle_alias] = looping_particle_component
	end
end

return PlayerComponentConfig
