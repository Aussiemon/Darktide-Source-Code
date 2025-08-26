-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_companion_leap_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Block = require("scripts/utilities/attack/block")
local CompanionDogSettings = require("scripts/utilities/companion/companion_dog_settings")
local GroundImpact = require("scripts/utilities/attack/ground_impact")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local NavQueries = require("scripts/utilities/nav_queries")
local Trajectory = require("scripts/utilities/trajectory")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local HitZone = require("scripts/utilities/attack/hit_zone")
local attack_types = AttackSettings.attack_types
local leap_settings = CompanionDogSettings.dog_leap_settings
local BtCompanionLeapAction = class("BtCompanionLeapAction", "BtNode")

BtCompanionLeapAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn

	scratchpad.physics_world = spawn_component.physics_world

	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local perception_component = Blackboard.write_component(blackboard, "perception")

	scratchpad.behavior_component = behavior_component
	scratchpad.perception_component = perception_component
	scratchpad.pounce_component = Blackboard.write_component(blackboard, "pounce")

	local fx_system = Managers.state.extension:system("fx_system")

	scratchpad.fx_system = fx_system
	scratchpad.side_system = Managers.state.extension:system("side_system")

	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
	scratchpad.nav_world = navigation_extension:nav_world()
	scratchpad.traverse_logic = navigation_extension:traverse_logic()

	MinionPerception.set_target_lock(unit, perception_component, true)

	local start_duration, start_leap_anim
	local target_distance = perception_component.target_distance
	local use_fast_jump = scratchpad.pounce_component.use_fast_jump

	if not use_fast_jump then
		start_duration, start_leap_anim = action_data.start_duration_short, action_data.start_leap_anim_event_short
		scratchpad.short_leap = true
	else
		start_duration, start_leap_anim = action_data.start_duration, action_data.start_leap_anim_event
	end

	scratchpad.pounce_component.use_fast_jump = false
	scratchpad.start_duration = t + start_duration

	animation_extension:anim_event(start_leap_anim)

	scratchpad.state = "starting"
	behavior_component.move_state = "attacking"
	scratchpad.broadphase_system = Managers.state.extension:system("broadphase_system")
	scratchpad.pushed_minions = {}
	scratchpad.pushed_enemies = {}
end

BtCompanionLeapAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if not scratchpad.hit_target then
		local locomotion_extension = scratchpad.locomotion_extension

		locomotion_extension:set_movement_type("snap_to_navmesh")

		local perception_component = scratchpad.perception_component
		local target_unit = perception_component.target_unit
		local target_unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
		local target_unit_breed = target_unit_data_extension and target_unit_data_extension:breed()
		local companion_pounce_setting = target_unit_breed and target_unit_breed.companion_pounce_setting
		local token_extension = ScriptUnit.has_extension(target_unit, "token_system")

		if token_extension and companion_pounce_setting then
			local required_token = companion_pounce_setting.required_token

			if token_extension:is_token_free_or_mine(unit, required_token.name) then
				token_extension:free_token(required_token.name)
			end
		end

		local original_rotation_speed = scratchpad.original_rotation_speed

		if original_rotation_speed then
			locomotion_extension:set_rotation_speed(original_rotation_speed)
		end
	end

	scratchpad.pounce_component.started_leap = false

	MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)

	if action_data.effect_template and scratchpad.global_effect_id then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(scratchpad.global_effect_id)
	end
end

BtCompanionLeapAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local result
	local locomotion_extension = scratchpad.locomotion_extension
	local state = scratchpad.state

	if state ~= "landing" and state ~= "stopping" and state ~= "starting" then
		self:_check_if_stuck(unit, scratchpad, action_data, t, locomotion_extension)
	end

	if state == "wall_jump" then
		self:_check_if_stuck_between_walls(unit, scratchpad, action_data, dt)
	end

	if state == "starting" then
		result = self:_update_starting_state(unit, scratchpad, action_data, dt, t, locomotion_extension, perception_component, target_unit)
	elseif state == "stopping" then
		result = self:_update_stopping_state(scratchpad, action_data, t)
	elseif state == "leaping" then
		result = self:_update_leaping_state(unit, scratchpad, action_data, dt, t, breed, locomotion_extension, target_unit)
	elseif state == "wall_jump" then
		result = self:_update_wall_jump_state(unit, scratchpad, action_data, dt, t, locomotion_extension, target_unit)
	elseif state == "falling" then
		result = self:_update_falling_state(unit, scratchpad, action_data, dt, t, locomotion_extension, target_unit)
	elseif state == "landing" then
		result = self:_update_landing_state(unit, scratchpad, action_data, t, locomotion_extension)
	end

	return result
end

local NAV_Z_CORRECTION = 0.1

BtCompanionLeapAction._update_starting_state = function (self, unit, scratchpad, action_data, dt, t, locomotion_extension, perception_component, target_unit)
	local is_short_leap = scratchpad.short_leap

	self:_update_ground_normal_rotation(unit, target_unit, scratchpad, is_short_leap)
	MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
	MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, target_unit)

	local debug

	if not HEALTH_ALIVE[target_unit] then
		self:_stop(scratchpad, action_data, t)

		return "running"
	end

	local position, current_leap_velocity = POSITION_LOOKUP[unit]
	local leap_speed, leap_relax_distance = leap_settings.leap_speed, leap_settings.collision_radius
	local leap_start_position = position + Vector3(0, 0, NAV_Z_CORRECTION)
	local target_node_name = leap_settings.leap_target_node_name
	local target_node = Unit.node(target_unit, target_node_name)
	local target_position = Unit.world_position(target_unit, target_node) + Vector3(0, 0, leap_settings.leap_target_z_offset)
	local target_locomotion = ScriptUnit.extension(target_unit, "locomotion_system")
	local target_velocity = target_locomotion:current_velocity()

	current_leap_velocity = self:_calculate_wanted_velocity(scratchpad.physics_world, leap_start_position, target_position, target_velocity, leap_speed, leap_relax_distance, debug)

	if current_leap_velocity then
		local target_direction = Vector3.normalize(Vector3.flat(target_position - position))

		scratchpad.last_visible_leap_flat_target_direction = scratchpad.last_visible_leap_flat_target_direction or Vector3Box()

		scratchpad.last_visible_leap_flat_target_direction:store(target_direction)

		scratchpad.last_visible_leap_target_position = scratchpad.last_visible_leap_target_position or Vector3Box()

		scratchpad.last_visible_leap_target_position:store(target_position)
	end

	if t >= scratchpad.start_duration then
		scratchpad.start_duration = nil

		if current_leap_velocity == nil and scratchpad.last_visible_leap_target_position then
			local target_position, target_velocity = scratchpad.last_visible_leap_target_position:unbox(), Vector3.zero()

			current_leap_velocity = self:_calculate_wanted_velocity(scratchpad.physics_world, leap_start_position, target_position, target_velocity, leap_speed, leap_relax_distance, debug)
		end

		if current_leap_velocity then
			self:_leap(unit, scratchpad, action_data, leap_start_position, current_leap_velocity, t)
		else
			self:_stop(scratchpad, action_data, t)

			return "running"
		end
	elseif not is_short_leap and current_leap_velocity then
		locomotion_extension:set_wanted_velocity(current_leap_velocity)
	end

	return "running"
end

local TO_OFFSET_UP_DISTANCE = 2

BtCompanionLeapAction._update_ground_normal_rotation = function (self, unit, target_unit, scratchpad, towards_target)
	local self_position, offset_up = POSITION_LOOKUP[unit], Vector3.up()
	local forward, from_position_1

	if towards_target then
		local target_position = POSITION_LOOKUP[target_unit]
		local to_target = Vector3.normalize(target_position - self_position)

		from_position_1 = self_position + offset_up + to_target
		forward = to_target
	else
		local self_rotation = Unit.local_rotation(unit, 1)

		forward = Vector3.normalize(Quaternion.forward(self_rotation))
		from_position_1 = self_position + offset_up + forward
	end

	local physics_world = scratchpad.physics_world
	local to_position_1 = from_position_1 - offset_up * TO_OFFSET_UP_DISTANCE
	local hit_1, hit_position_1 = self:_ray_cast(physics_world, from_position_1, to_position_1)

	if not hit_1 then
		return
	end

	local from_position_2 = self_position + offset_up - forward
	local to_position_2 = from_position_2 - offset_up * TO_OFFSET_UP_DISTANCE
	local hit_2, hit_position_2 = self:_ray_cast(physics_world, from_position_2, to_position_2)

	if not hit_2 then
		return
	end

	local locomotion_extension = scratchpad.locomotion_extension
	local wanted_direction = Vector3.normalize(hit_position_1 - hit_position_2)

	if not towards_target then
		local current_velocity = locomotion_extension:current_velocity()
		local velocity_normalized = Vector3.normalize(current_velocity)

		Vector3.set_xyz(wanted_direction, velocity_normalized.x, velocity_normalized.y, wanted_direction.z)
	end

	local wanted_rotation = Quaternion.look(wanted_direction)

	locomotion_extension:set_wanted_rotation(wanted_rotation)
end

local COLLISION_FILTER = "filter_minion_line_of_sight_check"

BtCompanionLeapAction._ray_cast = function (self, physics_world, from, to)
	local to_target = to - from
	local direction, distance = Vector3.normalize(to_target), Vector3.length(to_target)
	local result, hit_position, hit_distance, normal, _ = PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", COLLISION_FILTER)

	return result, hit_position, hit_distance, normal
end

BtCompanionLeapAction._calculate_wanted_velocity = function (self, physics_world, start_position, target_position, target_velocity, speed, optional_relax_distance, debug)
	local gravity, acceptable_accuracy = leap_settings.leap_gravity, leap_settings.leap_acceptable_accuracy
	local angle_to_hit_target, est_pos = Trajectory.angle_to_hit_moving_target(start_position, target_position, speed, target_velocity, gravity, acceptable_accuracy)

	if not angle_to_hit_target then
		return nil
	end

	local max_jump_angle = leap_settings.max_jump_angle
	local target_companion_distance = Vector3.length(target_position - start_position)

	if target_companion_distance <= leap_settings.close_distance then
		max_jump_angle = leap_settings.max_jump_angle_close_distance
		speed = leap_settings.leap_speed_close_distance
		est_pos = target_position
	end

	angle_to_hit_target = math.clamp(angle_to_hit_target, 0, max_jump_angle)

	local velocity, _ = Trajectory.get_trajectory_velocity(start_position, est_pos, gravity, speed, angle_to_hit_target)

	return velocity
end

BtCompanionLeapAction._leap = function (self, unit, scratchpad, action_data, start_position, leap_velocity, t)
	local ignore_dot_check = true
	local hit_target, hit_actor, leap_node = self:_check_colliding_minions(unit, scratchpad, action_data, ignore_dot_check)
	local target_unit = scratchpad.perception_component.target_unit
	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local target_unit_breed = target_unit_data_extension:breed()
	local companion_pounce_setting = target_unit_breed.companion_pounce_setting
	local companion_additional_leaping_condition = companion_pounce_setting.companion_additional_leaping_condition

	if companion_additional_leaping_condition and companion_additional_leaping_condition(unit, scratchpad, action_data) then
		self:_stop(scratchpad, action_data, t)

		return "running"
	end

	if action_data.effect_template then
		local fx_system = scratchpad.fx_system
		local global_effect_id = fx_system:start_template_effect(action_data.effect_template, unit)

		scratchpad.global_effect_id = global_effect_id
	end

	scratchpad.init_hit_target = hit_target
	scratchpad.init_hit_actor = hit_actor
	scratchpad.init_leap_node = leap_node

	scratchpad.locomotion_extension:set_movement_type("script_driven")

	scratchpad.pounce_component.started_leap = true
	scratchpad.leap_velocity = Vector3Box(leap_velocity)
	scratchpad.leap_start_position = Vector3Box(start_position)
	scratchpad.state = "leaping"
end

local LEAP_NODES = {
	"enemy_aim_target_03",
	"enemy_aim_target_04",
}
local TARGET_LEAP_NODE = "enemy_aim_target_02"

BtCompanionLeapAction._check_colliding_minions = function (self, unit, scratchpad, action_data, ignore_dot_check)
	local target_unit = scratchpad.perception_component.target_unit

	for _, leap_node in pairs(LEAP_NODES) do
		local physics_world = scratchpad.physics_world
		local attacking_unit_pos = Unit.world_position(unit, Unit.node(unit, leap_node))
		local radius = leap_settings.collision_radius
		local hit_actors, actor_count = PhysicsWorld.immediate_overlap(physics_world, "shape", "sphere", "position", attacking_unit_pos, "size", radius, "types", "dynamics", "collision_filter", "filter_player_character_melee_sweep")

		for i = 1, actor_count do
			repeat
				local hit_actor = hit_actors[i]
				local hit_unit = Actor.unit(hit_actor)

				if hit_unit == target_unit and HEALTH_ALIVE[hit_unit] then
					return hit_unit, hit_actor, leap_node
				end
			until true
		end
	end

	return nil
end

BtCompanionLeapAction._stop = function (self, scratchpad, action_data, t)
	scratchpad.animation_extension:anim_event(action_data.stop_anim)

	scratchpad.stop_duration = t + action_data.stop_duration
	scratchpad.state = "stopping"
end

BtCompanionLeapAction._update_stopping_state = function (self, scratchpad, action_data, t)
	if t > scratchpad.stop_duration then
		scratchpad.pounce_component.pounce_cooldown = t + action_data.leap_cooldown

		return "done"
	else
		return "running"
	end
end

BtCompanionLeapAction._update_leaping_state = function (self, unit, scratchpad, action_data, dt, t, breed, locomotion_extension, target_unit)
	local current_colliding_target, hit_actor, leap_node = self:_check_colliding_minions(unit, scratchpad, action_data)

	current_colliding_target = current_colliding_target or scratchpad.init_hit_target
	hit_actor = hit_actor or scratchpad.init_hit_actor
	leap_node = leap_node or scratchpad.init_leap_node

	if current_colliding_target then
		scratchpad.hit_target = true

		local pounce_component = scratchpad.pounce_component

		pounce_component.pounce_target = current_colliding_target
		pounce_component.has_pounce_target = true
		pounce_component.target_hit_zone_name = HitZone.get_name(current_colliding_target, hit_actor)
		pounce_component.leap_node = leap_node

		return "done"
	end

	if not current_colliding_target then
		local old_leap_time = scratchpad.leap_time or 0

		scratchpad.leap_time = old_leap_time + dt

		local leap_start_position, leap_velocity = scratchpad.leap_start_position:unbox(), scratchpad.leap_velocity:unbox()

		self:_advance_leap(unit, scratchpad, action_data, locomotion_extension, dt, t, old_leap_time, scratchpad.leap_time, leap_start_position, leap_velocity)
	end

	MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
	MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, target_unit)

	return "running"
end

local FALLING_NAV_MESH_ABOVE = 0.5
local FALLING_NAV_MESH_BELOW = 30
local FALLING_NAV_MESH_LATERAL = 0.5
local FALLING_NAV_MESH_BORDER_DISTANCE = 0.01
local LANDED_DOT_THRESHOLD = math.inverse_sqrt_2

BtCompanionLeapAction._advance_leap = function (self, unit, scratchpad, action_data, locomotion_extension, dt, t, old_leap_time, new_leap_time, leap_start_position, leap_velocity)
	local physics_world = scratchpad.physics_world
	local hit_position, hit_normal, new_position = self:_check_leap_for_collisions(scratchpad, action_data, physics_world, old_leap_time, new_leap_time, leap_start_position, leap_velocity)

	if hit_position then
		local up_dot = Vector3.dot(hit_normal, Vector3.up())
		local has_landed = up_dot > LANDED_DOT_THRESHOLD
		local has_hit_wall = not has_landed and up_dot >= -LANDED_DOT_THRESHOLD
		local nav_world, traverse_logic = scratchpad.nav_world, scratchpad.traverse_logic
		local new_wall_jump_velocity = has_hit_wall and self:_calculate_wall_jump_velocity(action_data, physics_world, nav_world, traverse_logic, new_position, hit_normal)
		local above, below, lateral = 0.1, 0.1, 0.3
		local has_nav_land_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, hit_position, above, below, lateral)

		if has_nav_land_position and has_landed then
			scratchpad.state = "landing"
			scratchpad.start_landing = true
		elseif new_wall_jump_velocity then
			self:_start_wall_jump(scratchpad, action_data, t, hit_normal, new_position, new_wall_jump_velocity)
		elseif NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, new_position, FALLING_NAV_MESH_ABOVE, FALLING_NAV_MESH_BELOW, FALLING_NAV_MESH_LATERAL, FALLING_NAV_MESH_BORDER_DISTANCE) then
			locomotion_extension:set_gravity(nil)
			locomotion_extension:set_affected_by_gravity(true, 0)
			locomotion_extension:set_movement_type("constrained_by_mover")

			scratchpad.state = "falling"

			return scratchpad.state
		else
			scratchpad.behavior_component.is_out_of_bound = true

			return "failed"
		end
	end

	local current_position = POSITION_LOOKUP[unit]
	local wanted_velocity = (new_position - current_position) / dt

	locomotion_extension:set_wanted_velocity(wanted_velocity)

	return scratchpad.state
end

BtCompanionLeapAction._check_leap_for_collisions = function (self, scratchpad, action_data, physics_world, start_t, end_t, leap_start_position, leap_velocity)
	local to_target = Vector3.normalize(Vector3.flat(leap_velocity))
	local x_vel_0 = Vector3.length(Vector3.flat(leap_velocity))
	local y_vel_0 = leap_velocity.z
	local debug
	local collision_filter, gravity, radius = leap_settings.leap_collision_filter, leap_settings.leap_gravity, leap_settings.leap_radius
	local hit_position, hit_normal, new_position = Trajectory.sphere_sweep_collision_check(physics_world, leap_start_position, to_target, x_vel_0, y_vel_0, gravity, radius, collision_filter, start_t, end_t, debug)

	return hit_position, hit_normal, new_position
end

local EPSILON = 0.01
local WALL_JUMP_NAV_ABOVE, WALL_JUMP_NAV_BELOW, WALL_JUMP_NAV_LATERAL = 1, 5, 0.3

BtCompanionLeapAction._calculate_wall_jump_velocity = function (self, action_data, physics_world, nav_world, traverse_logic, position, wall_normal)
	local flat_wall_normal = Vector3.flat(wall_normal)
	local offset_position = position + flat_wall_normal * action_data.wall_jump_nav_mesh_offset
	local nav_mesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, offset_position, WALL_JUMP_NAV_ABOVE, WALL_JUMP_NAV_BELOW, WALL_JUMP_NAV_LATERAL)

	if not nav_mesh_position then
		return nil
	end

	local landing_stop_position = nav_mesh_position + flat_wall_normal * action_data.wall_land_length
	local landing_stop_nav_mesh_position = NavQueries.position_on_mesh(nav_world, landing_stop_position, WALL_JUMP_NAV_ABOVE, WALL_JUMP_NAV_BELOW, traverse_logic)

	if not landing_stop_nav_mesh_position then
		return nil
	end

	local ray_can_go = GwNavQueries.raycango(nav_world, nav_mesh_position, landing_stop_nav_mesh_position, traverse_logic)

	if not ray_can_go then
		return nil
	end

	local rotation = Quaternion.look(-wall_normal)
	local up, unobstructed_height = Quaternion.up(rotation), action_data.wall_jump_unobstructed_height
	local collision_filter = leap_settings.leap_collision_filter
	local hit_up = PhysicsWorld.raycast(physics_world, position, up, unobstructed_height, "any", "collision_filter", collision_filter)

	if hit_up then
		return nil
	end

	local up_position = position + up * unobstructed_height
	local forward, forward_length = Quaternion.forward(rotation), leap_settings.leap_radius + EPSILON
	local hit_forward = PhysicsWorld.raycast(physics_world, up_position, forward, forward_length, "any", "collision_filter", collision_filter)

	if not hit_forward then
		return nil
	end

	local debug
	local wall_jump_target_position = nav_mesh_position + Vector3(0, 0, NAV_Z_CORRECTION)
	local jump_speed = action_data.wall_jump_speed
	local wall_jump_velocity = self:_calculate_wanted_velocity(physics_world, position, wall_jump_target_position, Vector3.zero(), jump_speed, nil, debug)

	return wall_jump_velocity
end

BtCompanionLeapAction._start_wall_jump = function (self, scratchpad, action_data, t, wall_normal, wall_jump_start_position, wall_jump_velocity)
	local locomotion_extension = scratchpad.locomotion_extension

	scratchpad.original_rotation_speed = locomotion_extension:rotation_speed()

	locomotion_extension:set_rotation_speed(action_data.wall_jump_align_rotation_speed)

	scratchpad.wall_jump_rotation_timing = t + action_data.wall_jump_rotation_timing
	scratchpad.wall_jump_rotation_duration = t + action_data.wall_jump_rotation_duration

	local rotation = Quaternion.look(-wall_normal)

	scratchpad.wanted_wall_rotation = QuaternionBox(rotation)
	scratchpad.wall_jump_start_position = Vector3Box(wall_jump_start_position)
	scratchpad.wall_jump_velocity = Vector3Box(wall_jump_velocity)
	scratchpad.wall_jump_time = 0

	local wall_jump_anim_event = action_data.wall_jump_anim_event

	scratchpad.animation_extension:anim_event(wall_jump_anim_event)

	scratchpad.state = "wall_jump"
end

BtCompanionLeapAction._start_landing = function (self, scratchpad, action_data, t)
	scratchpad.state = "landing"
	scratchpad.landing_duration = t + (scratchpad.land_duration or action_data.landing_duration)

	local land_anim_event = scratchpad.land_anim_event or action_data.land_anim_event

	scratchpad.animation_extension:anim_event(land_anim_event)

	local locomotion_extension = scratchpad.locomotion_extension
	local anim_driven, affected_by_gravity = true, true

	locomotion_extension:set_anim_driven(anim_driven, affected_by_gravity)
	locomotion_extension:set_movement_type("snap_to_navmesh")
	locomotion_extension:use_lerp_rotation(false)

	local land_impact_timing = t + action_data.land_impact_timing

	scratchpad.land_impact_timing = land_impact_timing
end

BtCompanionLeapAction._update_wall_jump_state = function (self, unit, scratchpad, action_data, dt, t, locomotion_extension, target_unit)
	if t <= scratchpad.wall_jump_rotation_timing then
		locomotion_extension:set_wanted_rotation(scratchpad.wanted_wall_rotation:unbox())

		return "running"
	elseif t <= scratchpad.wall_jump_rotation_duration then
		if not scratchpad.is_anim_rotation_driven then
			scratchpad.locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)

			scratchpad.original_rotation_speed = nil

			MinionMovement.set_anim_rotation_driven(scratchpad, true)
		end

		MinionMovement.set_anim_rotation(unit, scratchpad)

		return "running"
	elseif scratchpad.is_anim_rotation_driven then
		MinionMovement.set_anim_rotation_driven(scratchpad, false)
	end

	local old_wall_jump_time = scratchpad.wall_jump_time

	scratchpad.wall_jump_time = old_wall_jump_time + dt

	local wall_jump_start_position, wall_jump_velocity = scratchpad.wall_jump_start_position:unbox(), scratchpad.wall_jump_velocity:unbox()
	local new_state = self:_advance_leap(unit, scratchpad, action_data, locomotion_extension, dt, t, old_wall_jump_time, scratchpad.wall_jump_time, wall_jump_start_position, wall_jump_velocity)

	MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
	MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, target_unit)

	if new_state == "landing" then
		scratchpad.land_anim_event = action_data.wall_land_anim_event
		scratchpad.land_duration = action_data.wall_land_duration
	end

	return "running"
end

local SPEED_THRESHOLD = 0.1

BtCompanionLeapAction._update_falling_state = function (self, unit, scratchpad, action_data, dt, t, locomotion_extension, target_unit)
	local mover = Unit.mover(unit)

	if Mover.collides_down(mover) then
		local unit_position = POSITION_LOOKUP[unit]
		local above, below, lateral, nav_world, traverse_logic = 0.2, 0.2, 0.3, scratchpad.nav_world, scratchpad.traverse_logic
		local landing_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, unit_position, above, below, lateral)

		if landing_position then
			scratchpad.state = "landing"
			scratchpad.start_landing = true
		else
			local velocity = Vector3.flat(locomotion_extension:current_velocity())
			local speed = Vector3.length(velocity)

			if speed < SPEED_THRESHOLD then
				scratchpad.behavior_component.is_out_of_bound = true

				return "failed"
			end

			return "running"
		end
	end

	MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
	MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, target_unit)

	return "running"
end

BtCompanionLeapAction._update_landing_state = function (self, unit, scratchpad, action_data, t, locomotion_extension)
	if scratchpad.start_landing then
		self:_start_landing(scratchpad, action_data, t)

		scratchpad.start_landing = false
	elseif scratchpad.land_impact_timing and t >= scratchpad.land_impact_timing then
		local ground_impact_fx_template = action_data.land_ground_impact_fx_template

		if ground_impact_fx_template then
			GroundImpact.play(unit, scratchpad.physics_world, ground_impact_fx_template)
		end

		scratchpad.land_impact_timing = nil
	elseif t > scratchpad.landing_duration then
		locomotion_extension:set_anim_driven(false)
		locomotion_extension:use_lerp_rotation(true)

		scratchpad.pounce_component.started_leap = false

		return "done"
	end

	return "running"
end

local STUCK_OFFSET = 0.01

BtCompanionLeapAction._check_if_stuck = function (self, unit, scratchpad, action_data, t, locomotion_extension)
	local current_velocity = locomotion_extension:current_velocity()
	local speed = Vector3.length(current_velocity)

	if speed < STUCK_OFFSET then
		if not scratchpad.stuck_timer then
			scratchpad.stuck_timer = t + action_data.stuck_time
		end
	else
		scratchpad.stuck_timer = nil
	end

	if scratchpad.stuck_timer and t > scratchpad.stuck_timer then
		scratchpad.behavior_component.is_out_of_bound = true
	end
end

BtCompanionLeapAction._check_if_stuck_between_walls = function (self, unit, scratchpad, action_data, dt)
	local state = scratchpad.state

	if state and state == "wall_jump" then
		if not scratchpad.stuck_between_walls_timer then
			scratchpad.stuck_between_walls_timer = 0
		else
			scratchpad.stuck_between_walls_timer = scratchpad.stuck_between_walls_timer + dt
		end

		if scratchpad.stuck_between_walls_timer and scratchpad.stuck_between_walls_timer > action_data.stuck_between_walls_time then
			scratchpad.behavior_component.is_out_of_bound = true
		end
	end
end

return BtCompanionLeapAction
