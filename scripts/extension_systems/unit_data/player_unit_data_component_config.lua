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
local PlayerCharacterLoopingSoundAliases = require("scripts/settings/sound/player_character_looping_sound_aliases")
local PlayerCharacterStates = require("scripts/settings/player_character/player_character_states")
local PlayerUnitAnimationStateConfig = require("scripts/extension_systems/animation/utilities/player_unit_animation_state_config")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local tweak_template_types = WeaponTweakTemplateSettings.template_types
local animation_rollback = PlayerCharacterConstants.animation_rollback
local NUM_LAYERS_3P = animation_rollback.num_layers_3p
local NUM_LAYERS_1P = animation_rollback.num_layers_1p
local TIMES_3P, ANIMATIONS_3P, STATES_3P, TIMES_1P, ANIMATIONS_1P, STATES_1P = PlayerUnitAnimationStateConfig.format(animation_rollback)
local animation_state_component = {
	num_layers_3p = "player_anim_layer",
	num_layers_1p = "player_anim_layer"
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

local FX_SOURCES = {
	"n/a"
}

for name, _ in pairs(PlayerCharacterFxSourceNames) do
	FX_SOURCES[#FX_SOURCES + 1] = name
end

local slot_configuration = PlayerCharacterConstants.slot_configuration
local INVENTORY_SLOTS = {
	"none"
}
local WEAPON_INVENTORY_SLOTS = {
	"none"
}

for slot_name, config in pairs(slot_configuration) do
	INVENTORY_SLOTS[#INVENTORY_SLOTS + 1] = slot_name

	if config.slot_type == "weapon" then
		WEAPON_INVENTORY_SLOTS[#WEAPON_INVENTORY_SLOTS + 1] = slot_name
	end
end

INVENTORY_SLOTS.network_type = "player_inventory_slot_name"
local CHARACTER_STATES = {
	"dummy"
}

for name, _ in pairs(PlayerCharacterStates) do
	CHARACTER_STATES[#CHARACTER_STATES + 1] = name
end

local PLAYER_ITEMS = {
	network_type = "player_item_name",
	use_network_lookup = "player_item_names"
}
local WEAPON_TEMPLATES = {
	"none"
}
local WEAPON_ACTIONS = {
	"none"
}

for weapon_template_name, weapon_template in pairs(WeaponTemplates) do
	WEAPON_TEMPLATES[#WEAPON_TEMPLATES + 1] = weapon_template_name

	for name, _ in pairs(weapon_template.actions) do
		if not table.find(WEAPON_ACTIONS, name) then
			WEAPON_ACTIONS[#WEAPON_ACTIONS + 1] = name
		end
	end
end

local ABILITY_TEMPLATES = {
	"none"
}
local ABILITY_ACTIONS = {
	"none"
}

for ability_template_name, ability_template in pairs(AbilityTemplates) do
	ABILITY_TEMPLATES[#ABILITY_TEMPLATES + 1] = ability_template_name

	for name, _ in pairs(ability_template.actions) do
		if not table.find(ABILITY_ACTIONS, name) then
			ABILITY_ACTIONS[#ABILITY_ACTIONS + 1] = name
		end
	end
end

local function _extract_weapon_tweak_template_names(target_table, tweak_type)
	local base_template_lookup_iterator = pairs

	for _, weapon_template in pairs(WeaponTemplates) do
		local base_template_lookup = weapon_template.__base_template_lookup
		local tweak_templates = base_template_lookup[tweak_type]

		for lookup_type, lookup_entry in base_template_lookup_iterator(tweak_templates) do
			local new_identifier = lookup_entry.new_identifier

			if not table.find(target_table, new_identifier) then
				target_table[#target_table + 1] = new_identifier
			end
		end
	end
end

local RECOIL_TEMPLATES = {
	"none"
}

_extract_weapon_tweak_template_names(RECOIL_TEMPLATES, tweak_template_types.recoil)

local WEAPON_HANDLING_TEMPLATES = {
	"none"
}

_extract_weapon_tweak_template_names(WEAPON_HANDLING_TEMPLATES, tweak_template_types.weapon_handling)

local SWAY_TEMPLATES = {
	"none"
}

_extract_weapon_tweak_template_names(SWAY_TEMPLATES, tweak_template_types.sway)

local SUPPRESSION_TEMPLATES = {
	"none"
}

_extract_weapon_tweak_template_names(SUPPRESSION_TEMPLATES, tweak_template_types.suppression)

local SPREAD_TEMPLATES = {
	"none"
}

_extract_weapon_tweak_template_names(SPREAD_TEMPLATES, tweak_template_types.spread)

local DODGE_TEMPLATES = {
	"none"
}

_extract_weapon_tweak_template_names(DODGE_TEMPLATES, tweak_template_types.dodge)

local SPRINT_TEMPLATES = {
	"none"
}

_extract_weapon_tweak_template_names(SPRINT_TEMPLATES, tweak_template_types.sprint)

local STAMINA_TEMPLATES = {
	"none"
}

_extract_weapon_tweak_template_names(STAMINA_TEMPLATES, tweak_template_types.stamina)

local TOUGHNESS_TEMPLATES = {
	"none"
}

_extract_weapon_tweak_template_names(TOUGHNESS_TEMPLATES, tweak_template_types.toughness)

local AMMO_TEMPLATES = {
	"none"
}

_extract_weapon_tweak_template_names(AMMO_TEMPLATES, tweak_template_types.ammo)

local MOVEMENT_CURVE_MODIFIER_TEMPLATES = {
	"none"
}

_extract_weapon_tweak_template_names(MOVEMENT_CURVE_MODIFIER_TEMPLATES, tweak_template_types.movement_curve_modifier)

local STAGGER_DURATION_MODIFIER_TEMPLATES = {
	"none"
}

_extract_weapon_tweak_template_names(STAGGER_DURATION_MODIFIER_TEMPLATES, tweak_template_types.stagger_duration_modifier)

local CHARGE_TEMPLATES = {
	"none"
}

_extract_weapon_tweak_template_names(CHARGE_TEMPLATES, tweak_template_types.charge)

local WARP_CHARGE_TEMPLATES = {
	"none"
}

_extract_weapon_tweak_template_names(WARP_CHARGE_TEMPLATES, tweak_template_types.warp_charge)

local BURNINATING_TEMPLATES = {
	"none"
}

_extract_weapon_tweak_template_names(BURNINATING_TEMPLATES, tweak_template_types.burninating)

local SIZE_OF_FLAME_TEMPLATES = {
	"none"
}

_extract_weapon_tweak_template_names(SIZE_OF_FLAME_TEMPLATES, tweak_template_types.size_of_flame)

local PLAYER_ABILITIES = {
	"none"
}

for name, _ in pairs(PlayerAbilities) do
	PLAYER_ABILITIES[#PLAYER_ABILITIES + 1] = name
end

local DISORIENTATION_TYPES = {
	"none"
}

for name, _ in pairs(DisorientationSettings.disorientation_types) do
	DISORIENTATION_TYPES[#DISORIENTATION_TYPES + 1] = name
end

local INTERACTION_TEMPLATES = {
	"none"
}

for name, _ in pairs(InteractionTemplates) do
	if not table.find(INTERACTION_TEMPLATES, name) then
		INTERACTION_TEMPLATES[#INTERACTION_TEMPLATES + 1] = name
	end
end

local INTERACTION_STATES = {
	"none"
}

for state, _ in pairs(InteractionSettings.states) do
	if not table.find(INTERACTION_STATES, state) then
		INTERACTION_STATES[#INTERACTION_STATES + 1] = state
	end
end

local BUFF_TEMPLATES = {
	"none"
}

for name, _ in pairs(BuffTemplates) do
	if not table.find(BUFF_TEMPLATES, name) then
		BUFF_TEMPLATES[#BUFF_TEMPLATES + 1] = name
	end
end

local LUNGE_TEMPLATES = {
	"none"
}

for name, _ in pairs(LungeTemplates) do
	LUNGE_TEMPLATES[#LUNGE_TEMPLATES + 1] = name
end

local inventory_component = {
	wielded_slot = INVENTORY_SLOTS,
	previously_wielded_slot = INVENTORY_SLOTS,
	previously_wielded_weapon_slot = INVENTORY_SLOTS
}

for slot_name, _ in pairs(slot_configuration) do
	inventory_component[slot_name] = PLAYER_ITEMS
end

local CAMERA_TREES = {
	skip_predict_verification = true
}
local CAMERA_NODES = {
	skip_predict_verification = true
}

local function _gather_camera_tree_nodes(tree, node_map, num_nodes, node_list)
	local stack_size = 1
	local stack = {
		tree
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

for _, tree in pairs(CameraSettings) do
	num_nodes = _gather_camera_tree_nodes(tree, parsed_nodes, num_nodes, CAMERA_NODES)
end

local CameraTrees = require("scripts/settings/camera/camera_trees")

for tree_id, tree_name in pairs(CameraTrees) do
	num_trees = num_trees + 1
	CAMERA_TREES[num_trees] = tree_id
end

local PlayerComponentConfig = {
	locomotion_steering = {
		velocity_wanted = "Vector3",
		disable_minion_collision = "bool",
		rotation_based_on_wanted_velocity = "bool",
		calculate_fall_velocity = "bool",
		hub_active_stopping = "bool",
		local_move_x = "local_move_speed",
		disable_velocity_rotation = "bool",
		target_rotation = "Quaternion",
		target_translation = "Vector3",
		local_move_y = "local_move_speed",
		disable_push_velocity = "bool",
		move_method = {
			"script_driven",
			"script_driven_hub"
		}
	},
	locomotion_force_rotation = {
		start_rotation = "Quaternion",
		use_force_rotation = "bool",
		end_time = "fixed_frame_offset",
		start_time = "fixed_frame_offset"
	},
	locomotion_force_translation = {
		start_translation = "Vector3",
		start_time = "fixed_frame_offset",
		end_time = "fixed_frame_offset",
		use_force_translation = "bool"
	},
	locomotion_push = {
		time_to_apply = "fixed_frame_offset_end_t_4bit",
		new_velocity = "Vector3",
		velocity = "Vector3"
	},
	movement_state = {
		is_crouching_transition_start_t = "fixed_frame_offset_small",
		can_crouch = "bool",
		is_crouching = "bool",
		can_jump = "bool",
		is_dodging = "bool",
		can_exit_crouch = "bool",
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
			"vaulting"
		}
	},
	intoxicated_movement = {
		stagger_cooldown = "fixed_frame_offset_end_t_7bit",
		stagger_end_t = "fixed_frame_offset_end_t_7bit",
		in_stagger = "bool",
		stagger_direction = "high_precision_direction",
		stagger_start_t = "fixed_frame_offset_start_t_7bit"
	},
	hub_jog_character_state = {
		move_state_start_t = "fixed_frame_offset_start_t_6bit",
		move_start_delay_t = "fixed_frame_offset_end_t_6bit",
		force_old_input_end_t = "fixed_frame_offset_end_t_6bit",
		force_old_input_start_t = "fixed_frame_offset_start_t_6bit",
		method = {
			"moving",
			"idle",
			"turn_on_spot"
		},
		move_state = {
			"walk",
			"jog",
			"sprint"
		},
		previous_move_state = {
			"walk",
			"jog",
			"sprint"
		}
	},
	walking_character_state = {
		previous_state_allowed_slide = "bool"
	},
	sprint_character_state = {
		cooldown = "fixed_frame_offset",
		sprint_overtime = "fixed_frame_offset",
		last_sprint_time = "fixed_frame_offset",
		use_sprint_start_slowdown = "bool",
		is_sprinting = "bool",
		wants_sprint_camera = "bool",
		is_sprint_jumping = "bool"
	},
	slide_character_state = {
		was_in_dodge_cooldown = "bool",
		friction_function = {
			"default",
			"sprint"
		}
	},
	ledge_vaulting_character_state = {
		was_sprinting = "bool",
		traverse_velocity = "Vector3",
		is_step_up = "bool",
		forward = "Vector3",
		left = "Vector3",
		right = "Vector3"
	},
	character_state = {
		entered_t = "fixed_frame_offset",
		state_name = CHARACTER_STATES,
		previous_state_name = CHARACTER_STATES
	},
	character_state_random = {
		seed = "random_seed"
	},
	character_state_hit_mass = {
		used_hit_mass_percentage = "percentage"
	},
	animation_state = animation_state_component,
	inair_state = {
		inair_entered_t = "fixed_frame_offset",
		fell_from_height = "high_precision_position_component",
		standing_frames = "mover_frames",
		flying_frames = "mover_frames",
		on_ground = "bool"
	},
	locomotion = {
		parent_unit = "locomotion_parent",
		position = "locomotion_position",
		velocity_current = "Vector3",
		rotation = "locomotion_rotation"
	},
	player_unit_linker = {
		parent_unit = "Unit",
		linked = "bool",
		parent_node = {
			"none",
			"j_leftweaponattach",
			"j_tongue_attach",
			"j_spine",
			"root_point"
		},
		node = {
			"none",
			"j_hips"
		}
	},
	first_person = {
		previous_rotation = "locomotion_rotation",
		height = "character_height",
		height_change_duration = "short_time",
		wanted_height = "character_height",
		old_height = "character_height",
		position = "locomotion_position",
		rotation = "locomotion_rotation",
		height_change_start_time = "fixed_frame_offset"
	},
	force_look_rotation = {
		wanted_pitch = "rotation_single",
		start_pitch = "rotation_single",
		use_force_look_rotation = "bool",
		start_yaw = "rotation_single",
		wanted_yaw = "rotation_single",
		end_time = "fixed_frame_offset",
		start_time = "fixed_frame_offset"
	},
	first_person_mode = {
		show_1p_equipment_at_t = "fixed_frame_offset",
		wants_1p_camera = "bool"
	},
	inventory = inventory_component,
	movement_settings = {
		player_speed_scale = "movement_settings"
	},
	minigame_character_state = {
		interface_unit_id = "level_unit_id"
	},
	ladder_character_state = {
		top_enter_leave_timer = "fixed_frame_offset",
		ladder_unit_id = "level_unit_id",
		end_position = "Vector3",
		ladder_cooldown = "fixed_frame_offset",
		start_position = "Vector3"
	},
	assisted_state_input = {
		success = "bool",
		force_assist = "bool",
		in_progress = "bool"
	},
	dodge_character_state = {
		dodge_time = "fixed_frame_offset",
		dodge_direction = "Vector3",
		consecutive_dodges = "consecutive_dodges",
		consecutive_dodges_cooldown = "fixed_frame_offset",
		cooldown = "fixed_frame_offset",
		started_from_crouch = "bool",
		jump_override_time = "fixed_frame_offset",
		distance_left = "short_distance"
	},
	lunge_character_state = {
		lunge_target = "Unit",
		direction = "Vector3",
		is_aiming = "bool",
		is_lunging = "bool",
		distance_left = "extra_long_distance",
		lunge_template = LUNGE_TEMPLATES
	},
	dead_state_input = {
		die = "bool",
		despawn_time = "short_time"
	},
	knocked_down_state_input = {
		knock_down = "bool"
	},
	hogtied_state_input = {
		hogtie = "bool"
	},
	stun_state_input = {
		stun_frame = "fixed_frame_time",
		push_direction = "Vector3",
		disorientation_type = DISORIENTATION_TYPES
	},
	stunned_character_state = {
		stunned = "bool",
		actions_interrupted = "bool",
		exit_event_played = "bool",
		start_time = "fixed_frame_offset",
		disorientation_type = DISORIENTATION_TYPES
	},
	exploding_character_state = {
		is_exploding = "bool",
		slot_name = INVENTORY_SLOTS,
		reason = {
			"overheat",
			"warp_charge"
		}
	},
	catapulted_state_input = {
		velocity = "Vector3",
		new_input = "bool"
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
			"consumed"
		},
		trigger_animation = {
			"none",
			"grabbed_execution",
			"charger_smash",
			"charger_throw",
			"charger_throw_left",
			"charger_throw_right",
			"charger_throw_bwd"
		}
	},
	disabled_character_state = {
		disabling_unit = "Unit",
		is_disabled = "bool",
		target_drag_position = "Vector3",
		has_reached_drag_position = "bool",
		disabling_type = {
			"none",
			"netted",
			"pounced",
			"warp_grabbed",
			"mutant_charged",
			"consumed"
		}
	},
	debug_state_input = {
		self_assist = "bool"
	},
	ledge_hanging_character_state = {
		end_time_position_transition = "fixed_frame_offset",
		position_pre_hanging = "Vector3",
		position_hanging = "Vector3",
		rotation_hanging = "Quaternion",
		hang_ledge_unit = "Unit",
		is_interactible = "bool",
		rotation_pre_hanging = "Quaternion",
		time_to_fall_down = "fixed_frame_offset",
		start_time_position_transition = "fixed_frame_offset"
	},
	interacting_character_state = {
		interaction_template = INTERACTION_TEMPLATES
	},
	falling_character_state = {
		likely_stuck = "bool",
		was_ledge_hanging = "bool",
		has_reached_damagable_distance = "bool"
	},
	weapon_lock_view = {
		yaw = "weapon_view_lock",
		pitch = "weapon_view_lock",
		state = {
			"in_active",
			"weapon_lock",
			"weapon_lock_no_lerp",
			"force_look"
		}
	},
	weapon_action = {
		sprint_ready_time = "fixed_frame_offset",
		is_infinite_duration = "bool",
		special_active_at_start = "bool",
		start_t = "fixed_frame_offset",
		combo_count = "action_combo_count",
		time_scale = "action_time_scale",
		end_t = "fixed_frame_offset",
		template_name = WEAPON_TEMPLATES,
		current_action_name = WEAPON_ACTIONS,
		previous_action_name = WEAPON_ACTIONS
	},
	combat_ability_action = {
		sprint_ready_time = "fixed_frame_offset",
		is_infinite_duration = "bool",
		special_active_at_start = "bool",
		start_t = "fixed_frame_offset",
		combo_count = "action_combo_count",
		time_scale = "action_time_scale",
		end_t = "fixed_frame_offset",
		template_name = ABILITY_TEMPLATES,
		current_action_name = ABILITY_ACTIONS,
		previous_action_name = ABILITY_ACTIONS
	},
	grenade_ability_action = {
		sprint_ready_time = "fixed_frame_offset",
		is_infinite_duration = "bool",
		special_active_at_start = "bool",
		start_t = "fixed_frame_offset",
		combo_count = "action_combo_count",
		time_scale = "action_time_scale",
		end_t = "fixed_frame_offset",
		template_name = ABILITY_TEMPLATES,
		current_action_name = ABILITY_ACTIONS,
		previous_action_name = ABILITY_ACTIONS
	},
	action_throw = {
		thrown = "bool",
		slot_to_wield = INVENTORY_SLOTS
	},
	action_place = {
		rotation_step = "rotation_step",
		aiming_place = "bool",
		placed_on_unit = "Unit",
		position = "Vector3",
		rotation = "Quaternion",
		can_place = "bool"
	},
	action_push = {
		has_pushed = "bool"
	},
	action_flamer_gas = {
		range = "low_precision_long_distance"
	},
	action_aim_projectile = {
		speed = "projectile_speed",
		direction = "Vector3",
		momentum = "high_precision_velocity",
		position = "Vector3",
		rotation = "Quaternion"
	},
	action_heal_target_over_time = {
		target_unit = "Unit"
	},
	action_sweep = {
		sweep_aborted_t = "fixed_frame_offset",
		sweep_aborted = "bool",
		sweep_aborted_actor_index = "hit_zone_actor_index",
		is_sticky = "bool",
		sweep_rotation = "Quaternion",
		sweep_aborted_unit = "Unit",
		sweep_position = "Vector3",
		attack_direction = "Vector3"
	},
	action_shoot = {
		shooting_charge_level = "weapon_charge_level",
		num_shots_fired = "ammunition",
		shooting_rotation = "Quaternion",
		started_from_sprint = "bool",
		shooting_position = "Vector3",
		fire_at_time = "fixed_frame_offset",
		fire_state = {
			"waiting_to_shoot",
			"prepare_shooting",
			"start_shooting",
			"shooting",
			"shot"
		}
	},
	action_shoot_pellets = {
		num_pellets_fired = "ammunition"
	},
	action_reload = {
		has_refilled_ammunition = "bool",
		has_removed_ammunition = "bool",
		has_cleared_overheat = "bool"
	},
	action_unwield = {
		slot_to_wield = INVENTORY_SLOTS
	},
	action_module_charge = {
		charge_complete_time = "fixed_frame_offset",
		max_charge = "weapon_charge_level",
		charge_level = "weapon_charge_level"
	},
	action_module_position_finder = {
		position = "Vector3",
		position_valid = "bool",
		normal = "Vector3"
	},
	action_module_targeting = {
		target_unit_1 = "Unit",
		target_unit_3 = "Unit",
		target_unit_2 = "Unit"
	},
	sway = {
		offset_x = "weapon_sway_offset",
		pitch = "weapon_sway",
		offset_y = "weapon_sway_offset",
		yaw = "weapon_sway"
	},
	sway_control = {
		immediate_pitch = "weapon_sway",
		immediate_yaw = "weapon_sway"
	},
	spread = {
		yaw = "weapon_spread",
		pitch = "weapon_spread"
	},
	spread_control = {
		previous_yaw_offset = "weapon_spread",
		immediate_yaw = "weapon_spread",
		immediate_pitch = "weapon_spread",
		previous_pitch_offset = "weapon_spread",
		seed = "random_seed"
	},
	suppression = {
		spread_yaw = "weapon_spread",
		time = "fixed_frame_offset",
		spread_pitch = "weapon_spread",
		sway_pitch = "weapon_sway",
		sway_yaw = "weapon_sway",
		decay_time = "short_time"
	},
	recoil = {
		unsteadiness = "recoil_unsteadiness",
		pitch_offset = "recoil_angle",
		yaw_offset = "recoil_angle"
	},
	recoil_control = {
		target_yaw = "recoil_angle",
		recoiling = "bool",
		shooting = "bool",
		target_pitch = "recoil_angle",
		starting_rotation = "Quaternion",
		rise_end_time = "fixed_frame_offset",
		seed = "random_seed",
		num_shots = "ammunition"
	},
	shooting_status = {
		shooting = "bool",
		shooting_end_time = "fixed_frame_offset",
		num_shots = "ammunition"
	},
	block = {
		has_blocked = "bool",
		is_blocking = "bool"
	},
	alternate_fire = {
		start_t = "fixed_frame_offset",
		is_active = "bool"
	},
	interaction = {
		done_time = "fixed_frame_time",
		target_unit = "Unit",
		duration = "fixed_frame_offset",
		target_actor_node_index = "actor_node_index",
		start_time = "fixed_frame_time",
		type = INTERACTION_TEMPLATES,
		state = INTERACTION_STATES
	},
	interactee = {
		interactor_unit = "Unit",
		interacted_with = "bool"
	},
	stamina = {
		current_fraction = "stamina_fraction",
		regeneration_paused = "bool",
		last_drain_time = "fixed_frame_offset"
	},
	equipped_abilities = {
		combat_ability = PLAYER_ABILITIES,
		grenade_ability = PLAYER_ABILITIES
	},
	grenade_ability = {
		cooldown = "fixed_frame_time",
		enabled = "bool",
		active = "bool",
		num_charges = "ability_charges"
	},
	combat_ability = {
		cooldown = "fixed_frame_time",
		enabled = "bool",
		active = "bool",
		num_charges = "ability_charges"
	},
	specialization_resource = {
		max_resource = "specialization_resource",
		current_resource = "specialization_resource"
	},
	critical_strike = {
		num_critical_shots = "ammunition",
		prd_state = "prd_state",
		seed = "random_seed",
		is_active = "bool"
	},
	camera_tree = {
		tree = CAMERA_TREES,
		node = CAMERA_NODES
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
		stagger_duration_modifier_template_name = STAGGER_DURATION_MODIFIER_TEMPLATES,
		stamina_template_name = STAMINA_TEMPLATES,
		sway_template_name = SWAY_TEMPLATES,
		suppression_template_name = SUPPRESSION_TEMPLATES,
		toughness_template_name = TOUGHNESS_TEMPLATES,
		warp_charge_template_name = WARP_CHARGE_TEMPLATES,
		weapon_handling_template_name = WEAPON_HANDLING_TEMPLATES
	},
	aim_assist_ramp = {
		decay_end_time = "fixed_frame_offset_end_t_7bit",
		multiplier = "aim_assist_multiplier"
	},
	warp_charge = {
		ramping_modifier = "warp_charge_ramping_modifier",
		starting_percentage = "warp_charge",
		current_percentage = "warp_charge",
		last_charge_at_t = "fixed_frame_offset_start_t_6bit",
		remove_at_t = "fixed_frame_offset_end_t_7bit",
		state = {
			"idle",
			"increasing",
			"decreasing",
			"exploding"
		}
	},
	scanning = {
		line_of_sight = "bool",
		scannable_unit = "Unit",
		is_active = "bool"
	}
}
local inventory_component_data = PlayerCharacterConstants.inventory_component_data

for slot_name, config in pairs(slot_configuration) do
	if config.wieldable then
		local slot_type = config.slot_type
		local component_data = inventory_component_data[slot_type]
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
	seed = "random_seed"
}

for i = 1, max_component_buffs do
	local key_lookup = component_key_lookup[i]
	local template_name_key = key_lookup.template_name_key
	local start_time_key = key_lookup.start_time_key
	local active_start_time_key = key_lookup.active_start_time_key
	local stack_count_key = key_lookup.stack_count_key
	local proc_count_key = key_lookup.proc_count_key
	buff_component_config[template_name_key] = BUFF_TEMPLATES
	buff_component_config[start_time_key] = "fixed_frame_offset"
	buff_component_config[active_start_time_key] = "fixed_frame_offset"
	buff_component_config[stack_count_key] = "buff_stack_count"
	buff_component_config[proc_count_key] = "buff_proc_count"
end

PlayerComponentConfig.buff = buff_component_config

for looping_particle_alias, config in pairs(PlayerCharacterLoopingParticleAliases) do
	if not config.exclude_from_unit_data_components then
		local looping_particle_component = {
			is_playing = "bool"
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

for looping_sound_alias, config in pairs(PlayerCharacterLoopingSoundAliases) do
	if not config.exclude_from_unit_data_components then
		local looping_sound_component = {
			is_playing = "bool"
		}

		if not config.is_2d then
			looping_sound_component.source_name = FX_SOURCES
		end

		local component_name = PlayerUnitData.looping_sound_component_name(looping_sound_alias)
		PlayerComponentConfig[component_name] = looping_sound_component
	end
end

return PlayerComponentConfig
