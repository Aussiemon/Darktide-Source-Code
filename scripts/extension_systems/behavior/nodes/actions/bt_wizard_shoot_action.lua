-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_wizard_shoot_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local Items = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Trajectory = require("scripts/utilities/trajectory")
local NavQueries = require("scripts/utilities/nav_queries")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local BtWizardShootAction = class("BtWizardShootAction", "BtNode")
local SHOOTING_STATES = table.enum("checking_trajectory", "aim_and_prepare", "shoot")
local _resolve_trajectory_paramters, _collect_non_disabled_players, _resolve_hit_offsets, _resolve_wanted_projectile_type, _check_trajectory, _apply_launch_spread, _get_particle_position

BtWizardShootAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn

	scratchpad.physics_world = spawn_component.physics_world
	scratchpad.world = spawn_component.world

	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.combat_vector_extension = ScriptUnit.extension(unit, "combat_vector_system")
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.fx_system = Managers.state.extension:system("fx_system")
	scratchpad.navigation_extension = navigation_extension
	scratchpad.nav_world = navigation_extension:nav_world()

	local combat_vector_component = blackboard.combat_vector

	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.combat_vector_component = combat_vector_component
	scratchpad.perception_component = blackboard.perception

	local non_disabled_players = _collect_non_disabled_players()
	local num_non_disabled = #non_disabled_players
	local selected_type = _resolve_wanted_projectile_type(blackboard, action_data, num_non_disabled)
	local shoot_data = action_data[selected_type]
	local is_enraged = blackboard.abilites.is_enraged

	scratchpad.is_enraged = is_enraged

	local anim_duration = self:_get_anim_variables(scratchpad, unit, shoot_data)
	local anim_events = shoot_data.anim_events

	if is_enraged then
		anim_events = shoot_data.enraged_anim_events
	end

	local random_event = Animation.random_event(anim_events)

	scratchpad.selected_type = selected_type
	scratchpad.shoot_data = shoot_data

	local projectile_templates = shoot_data.throw_config.projectile_template
	local effect_templates = shoot_data.throw_config.effect_templates
	local idx = math.random(1, #projectile_templates)

	scratchpad.projectile_template = projectile_templates[idx]
	scratchpad.effect_template = EffectTemplates[effect_templates[idx]]
	scratchpad.random_event = random_event
	scratchpad.use_fan_attack = shoot_data.multi_shot or false
	scratchpad.fan_target_units = non_disabled_players

	local configured_shots = shoot_data.multi_shot and shoot_data.fan_pattern.num_shot or 1

	scratchpad.num_shots = scratchpad.use_fan_attack and math.min(configured_shots, num_non_disabled) or 1
	scratchpad.action_duration = anim_duration + t
	scratchpad.state = SHOOTING_STATES.checking_trajectory
	scratchpad.throw_indexed_data = {}

	local abilites_component = Blackboard.write_component(blackboard, "abilites")

	abilites_component.in_basic_attack = true
end

BtWizardShootAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if HEALTH_ALIVE[unit] then
		local abilites_component = Blackboard.write_component(blackboard, "abilites")
		local cooldown_multiplier = abilites_component.basic_attack_multiplier

		abilites_component.in_basic_attack = false

		local delays = action_data.delay_between_basic_attacks
		local delay = math.random(delays[1], delays[2])

		abilites_component.t_to_next_base_attack = t + delay * cooldown_multiplier
	end

	if scratchpad.effect_template_id then
		scratchpad.fx_system:stop_template_effect(scratchpad.effect_template_id)

		scratchpad.effect_template_id = nil
	end
end

BtWizardShootAction.init_values = function (self, blackboard, action_data, node_data)
	local abilites_component = Blackboard.write_component(blackboard, "abilites")

	abilites_component.t_to_next_base_attack = 0
	abilites_component.base_ground_attack_allowed = false
	abilites_component.in_basic_attack = false
	abilites_component.basic_attack_multiplier = 1
	abilites_component.is_enraged = false
end

BtWizardShootAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.state == SHOOTING_STATES.checking_trajectory then
		local use_fan_attack = scratchpad.use_fan_attack
		local num_shots = scratchpad.num_shots
		local fan_target_units = scratchpad.fan_target_units

		for i = 1, num_shots do
			local index = i
			local target_unit = use_fan_attack and fan_target_units[index] or scratchpad.perception_component.target_unit

			_check_trajectory(unit, scratchpad, action_data, use_fan_attack, index, target_unit)
		end

		scratchpad.state = SHOOTING_STATES.aim_and_prepare
	end

	if scratchpad.state == SHOOTING_STATES.aim_and_prepare then
		local throw_data = scratchpad.throw_indexed_data[1]
		local wanted_rotation = throw_data.wanted_rotation:unbox()

		scratchpad.locomotion_extension:set_wanted_rotation(wanted_rotation)

		if not scratchpad.damage_timings then
			self:_start_aiming(unit, breed, blackboard, scratchpad, action_data, dt, t)
		elseif scratchpad.damage_timings and t > scratchpad.damage_timings[1] then
			scratchpad.state = SHOOTING_STATES.shoot
		end
	end

	if scratchpad.state == SHOOTING_STATES.shoot then
		self:_update_shooting(unit, breed, blackboard, scratchpad, action_data, dt, t)
	end

	if not scratchpad.rotation_saved then
		scratchpad.rotation_saved = true

		local throw_data = scratchpad.throw_indexed_data[#scratchpad.throw_indexed_data]
		local target_unit = throw_data.target_unit
		local target_position = target_unit and POSITION_LOOKUP[target_unit]
		local look_at_position = target_position or throw_data.throw_position:unbox()

		self:_update_default_look_at_rotation(blackboard, look_at_position)
	end

	return scratchpad.action_duration and t > scratchpad.action_duration and "done" or "running"
end

BtWizardShootAction._update_default_look_at_rotation = function (self, blackboard, new_rotation)
	local abilites_component = Blackboard.write_component(blackboard, "abilites")

	abilites_component.default_look_at_position:store(new_rotation)
end

BtWizardShootAction._update_shooting = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local timings = scratchpad.damage_timings
	local shots_done = scratchpad.shots_done

	if not timings then
		return
	end

	local next_shot = shots_done or 1

	if (not shots_done or next_shot <= scratchpad.num_shots) and t > timings[next_shot] then
		self:_shoot(unit, breed, blackboard, scratchpad, action_data, dt, t, scratchpad.throw_indexed_data[next_shot])

		scratchpad.shots_done = next_shot + 1
	end
end

BtWizardShootAction._start_aiming = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local _, anim_timings = self:_get_anim_variables(scratchpad, unit, scratchpad.shoot_data)

	scratchpad.damage_timings = {}

	for i = 1, #anim_timings do
		scratchpad.damage_timings[i] = anim_timings[i] + t
	end

	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	local anim_event = scratchpad.random_event

	animation_extension:anim_event(anim_event)

	local wwise_event = action_data.wwise_event
	local wwise_position = HEALTH_ALIVE[unit] and POSITION_LOOKUP[unit]

	if wwise_event and wwise_position then
		scratchpad.fx_system:trigger_wwise_event(wwise_event, wwise_position)
	end

	local projectile_effect_template = scratchpad.effect_template

	scratchpad.effect_template_id = scratchpad.fx_system:start_template_effect(projectile_effect_template, unit)
end

BtWizardShootAction._shoot = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t, throw_data)
	local shoot_data = scratchpad.shoot_data
	local throw_config = shoot_data.throw_config
	local speed = shoot_data.speed
	local projectile_template = scratchpad.projectile_template
	local locomotion_template = projectile_template.locomotion_template
	local trajectory_parameters = _resolve_trajectory_paramters(locomotion_template)
	local throw_position = _get_particle_position(unit)
	local throw_direction = throw_data.throw_direction:unbox()
	local wanted_rotation = throw_data.wanted_rotation:unbox()
	local item_name = throw_config.item
	local item_definitions = MasterItems.get_cached()
	local item = item_definitions[item_name]
	local grenade_unit_name, locomotion_state = Items.base_unit(item, breed.name), trajectory_parameters.locomotion_state
	local angular_velocity

	if trajectory_parameters.randomized_angular_velocity then
		local max = trajectory_parameters.randomized_angular_velocity

		angular_velocity = Vector3(math.random() * max.x, math.random() * max.y, math.random() * max.z)
	elseif trajectory_parameters.initial_angular_velocity then
		angular_velocity = trajectory_parameters.initial_angular_velocity:unbox()
	else
		angular_velocity = Vector3.zero()
	end

	local target_unit = throw_data.target_unit or scratchpad.perception_component.target_unit
	local target_distance = scratchpad.shoot_data.target_distance
	local target_position

	if target_distance then
		local forward = Quaternion.forward(wanted_rotation)
		local meters_ahead = target_distance

		target_position = throw_position + forward * meters_ahead
		target_unit = nil
	end

	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local is_critical_strike, origin_item_slot, charge_level, weapon_item_or_nil
	local fuse_override_time_or_nil = 15
	local owner_side = side and side:name()
	local projectile_unit = Managers.state.unit_spawner:spawn_network_unit(grenade_unit_name, "item_projectile", throw_position, wanted_rotation, nil, item, projectile_template, locomotion_state, throw_direction, speed, angular_velocity, unit, is_critical_strike, origin_item_slot, charge_level, target_unit, target_position, weapon_item_or_nil, fuse_override_time_or_nil, owner_side)

	if target_unit then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local target_player = player_unit_spawn_manager and player_unit_spawn_manager:owner(target_unit)
		local target_is_bot = target_player and not target_player:is_human_controlled()

		if target_is_bot then
			local group_system = Managers.state.extension:system("group_system")
			local target_side = side_system.side_by_unit[target_unit]
			local bot_group = target_side and group_system:bot_group_from_side(target_side)

			if bot_group then
				bot_group:register_incoming_projectile(projectile_unit, target_unit)
			end
		end
	end

	if scratchpad.effect_template_id then
		scratchpad.fx_system:stop_template_effect(scratchpad.effect_template_id)

		scratchpad.effect_template_id = nil
	end
end

local FLOAT_ABOVE, FLOAT_BELOW = 0.5, 2

local function _position_is_floating(navigation_extension, position)
	local nav_world = navigation_extension:nav_world()
	local traverse_logic = navigation_extension:traverse_logic()
	local on_mesh = NavQueries.position_on_mesh(nav_world, position, FLOAT_ABOVE, FLOAT_BELOW, traverse_logic)

	return on_mesh == nil
end

BtWizardShootAction._get_anim_variables = function (self, scratchpad, unit, shoot_data)
	local move_type = _position_is_floating(scratchpad.navigation_extension, POSITION_LOOKUP[unit]) and "flying" or "ground"
	local anim_duration = shoot_data.anim_duration
	local anim_timings = shoot_data.anim_timings

	if scratchpad.is_enraged then
		anim_duration = shoot_data.enraged_anim_duration
		anim_timings = shoot_data.enraged_anim_timings
	end

	return anim_duration[move_type], anim_timings[move_type]
end

function _resolve_hit_offsets(scratchpad, use_fan_attack, index)
	if scratchpad.shoot_data.ground_offset then
		return scratchpad.shoot_data.ground_offset
	end

	return Vector3(0, 1, 1)
end

function _collect_non_disabled_players()
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side(1)
	local target_units = side.valid_player_units
	local num_target_units = #target_units
	local non_disabled_players = {}

	for i = 1, num_target_units do
		local player_unit = target_units[i]
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")
		local requires_help = PlayerUnitStatus.requires_help(character_state_component)

		if not requires_help then
			non_disabled_players[#non_disabled_players + 1] = player_unit
		end
	end

	return non_disabled_players
end

local TEST_TYPES = {
	"spawn",
	"throw",
}

function _resolve_trajectory_paramters(locomotion_template)
	for _, param_type in ipairs(TEST_TYPES) do
		local params = locomotion_template.trajectory_parameters[param_type]

		if params then
			return params
		end
	end
end

local ALLOWED_PROJECTILES = {}

function _resolve_wanted_projectile_type(blackboard, action_data, num_non_disabled_players)
	table.clear(ALLOWED_PROJECTILES)

	local abilites_component = blackboard.abilites
	local singular_allowed = action_data.allowed_attack_types.singular

	if singular_allowed then
		ALLOWED_PROJECTILES[#ALLOWED_PROJECTILES + 1] = singular_allowed
	end

	local base_ground_attack_allowed = abilites_component.base_ground_attack_allowed and action_data.allowed_attack_types.ground

	if base_ground_attack_allowed then
		ALLOWED_PROJECTILES[#ALLOWED_PROJECTILES + 1] = base_ground_attack_allowed
	end

	local fan_attack_allowed = num_non_disabled_players and num_non_disabled_players > 1 and action_data.allowed_attack_types.fan

	if fan_attack_allowed then
		ALLOWED_PROJECTILES[#ALLOWED_PROJECTILES + 1] = fan_attack_allowed
	end

	local idx = math.random(1, #ALLOWED_PROJECTILES)
	local selected_projectile_type = ALLOWED_PROJECTILES[idx]

	return selected_projectile_type
end

function _check_trajectory(unit, scratchpad, action_data, use_fan_attack, index, target_unit)
	target_unit = target_unit or scratchpad.perception_component.target_unit

	local target_position = POSITION_LOOKUP[target_unit]
	local self_position = POSITION_LOOKUP[unit]
	local default_trajectory_paramaters = action_data.default_trajectory_paramaters
	local speed, gravity, acceptable_accuracy = default_trajectory_paramaters.speed, default_trajectory_paramaters.gravity, default_trajectory_paramaters.acceptable_accuracy
	local throw_position = Vector3(target_position[1], target_position[2], target_position[3] + 1)
	local flat_target_direction = Vector3.flat(throw_position - self_position)
	local wanted_rotation, scale = Quaternion.look(flat_target_direction), Unit.world_scale(unit, 1)
	local throw_node_local_offset = scratchpad.shoot_data.throw_node_local_offset
	local rotated_root_world_pose = Matrix4x4.from_quaternion_position_scale(wanted_rotation, self_position, scale)
	local throw_node_position = Matrix4x4.transform(rotated_root_world_pose, throw_node_local_offset)
	local target_velocity = MinionMovement.target_velocity(target_unit)
	local target_player_look_toward = Quaternion.look(-1 * flat_target_direction)
	local target_player_4x4 = Matrix4x4.from_quaternion_position_scale(target_player_look_toward, target_position, scale)
	local hit_offset = _resolve_hit_offsets(scratchpad, use_fan_attack, index)
	local to_position = Matrix4x4.transform(target_player_4x4, hit_offset)
	local angle_to_hit_target, estimated_position = Trajectory.angle_to_hit_moving_target(throw_node_position, to_position, speed, target_velocity, gravity, acceptable_accuracy)

	if angle_to_hit_target == nil then
		return false
	end

	local velocity, _ = Trajectory.get_trajectory_velocity(throw_node_position, estimated_position, gravity, speed, angle_to_hit_target)
	local throw_direction = Vector3.normalize(velocity)

	if use_fan_attack then
		throw_direction = _apply_launch_spread(scratchpad, throw_direction, index)
	end

	scratchpad.throw_indexed_data[index] = {
		throw_direction = Vector3Box(throw_direction),
		throw_position = Vector3Box(throw_node_position),
		wanted_rotation = QuaternionBox(wanted_rotation),
		target_unit = target_unit,
	}
end

local DEFAULT_LAUNCH_SPREAD_ANGLE = 12

function _apply_launch_spread(scratchpad, throw_direction, index)
	local num_shots = scratchpad.num_shots

	if num_shots <= 1 then
		return throw_direction
	end

	local fan_pattern = scratchpad.shoot_data.fan_pattern
	local spread_angle = fan_pattern and fan_pattern.launch_spread_angle or DEFAULT_LAUNCH_SPREAD_ANGLE
	local center = (num_shots + 1) * 0.5
	local yaw = (index - center) * math.rad(spread_angle)
	local spread_rotation = Quaternion(Vector3.up(), yaw)

	return Quaternion.rotate(spread_rotation, throw_direction)
end

local PARTICLE_OFFSET = 0.2

function _get_particle_position(unit)
	local node = Unit.node(unit, "j_leftweaponattach")
	local node_pos = Unit.world_position(unit, node)
	local node_rot = Unit.world_rotation(unit, node)
	local offset_direction = Quaternion.right(node_rot) + Quaternion.up(node_rot)

	return node_pos + offset_direction * PARTICLE_OFFSET
end

return BtWizardShootAction
