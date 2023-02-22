require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Catapulted = require("scripts/extension_systems/character_state_machine/character_states/utilities/catapulted")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local NavQueries = require("scripts/utilities/nav_queries")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Trajectory = require("scripts/utilities/trajectory")
local BtBeastOfNurgleSpitOutAction = class("BtBeastOfNurgleSpitOutAction", "BtNode")

BtBeastOfNurgleSpitOutAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn
	scratchpad.physics_world = spawn_component.physics_world
	local perception_component = Blackboard.write_component(blackboard, "perception")
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = perception_component
	scratchpad.behavior_component.move_state = "attacking"
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.nav_world = scratchpad.navigation_extension:nav_world()
	scratchpad.broadphase_system = Managers.state.extension:system("broadphase_system")
	scratchpad.side_system = Managers.state.extension:system("side_system")
	scratchpad.fx_system = Managers.state.extension:system("fx_system")
	local throw_directions = self:_calculate_randomized_throw_directions(action_data)
	scratchpad.throw_directions = throw_directions

	MinionPerception.set_target_lock(unit, perception_component, true)

	local original_rotation_speed = locomotion_extension:rotation_speed()
	scratchpad.original_rotation_speed = original_rotation_speed
	scratchpad.initial_distance_to_target = perception_component.target_distance
	local behavior_component = scratchpad.behavior_component
	local consumed_unit = behavior_component.consumed_unit
	local hit_unit_data_extension = ScriptUnit.extension(consumed_unit, "unit_data_system")
	local disabled_state_input = hit_unit_data_extension:write_component("disabled_state_input")
	scratchpad.consumed_unit = consumed_unit
	scratchpad.hit_unit_disabled_state_input = disabled_state_input
	local consumed_unit_breed_name = hit_unit_data_extension:breed().name
	scratchpad.consumed_unit_breed_name = consumed_unit_breed_name
	local self_flat_fwd = Vector3.flat(Quaternion.forward(Unit.local_rotation(unit, 1)))

	Unit.set_local_rotation(unit, 1, Quaternion.look(self_flat_fwd))

	local disabled_character_state_component = hit_unit_data_extension:read_component("disabled_character_state")
	scratchpad.hit_unit_disabled_character_state_component = disabled_character_state_component

	self:_align_throwing(unit, scratchpad, action_data)
	self:_start_aligning(unit, scratchpad, action_data, t)
end

BtBeastOfNurgleSpitOutAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local consumed_unit = scratchpad.consumed_unit

	if reason ~= "done" and ALIVE[consumed_unit] then
		local _, disabling_unit = PlayerUnitStatus.is_consumed(scratchpad.hit_unit_disabled_character_state_component)

		if disabling_unit == unit then
			local target_locomotion_extension = ScriptUnit.extension(consumed_unit, "locomotion_system")

			target_locomotion_extension:set_parent_unit(nil)

			local disabled_state_input = scratchpad.hit_unit_disabled_state_input

			if disabled_state_input.disabling_unit == unit then
				disabled_state_input.trigger_animation = "none"
				disabled_state_input.disabling_unit = nil
			end

			scratchpad.behavior_component.consumed_unit = nil
		end
	end

	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)
	MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)

	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end
end

BtBeastOfNurgleSpitOutAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local state = scratchpad.state

	if state == "aligning" then
		self:_update_aligning(unit, scratchpad, action_data, breed, t)
	elseif state == "throwing" then
		self:_update_throwing(unit, scratchpad, action_data, breed, t)
	elseif state == "done" then
		return "done"
	end

	return "running"
end

BtBeastOfNurgleSpitOutAction._start_aligning = function (self, unit, scratchpad, action_data, t)
	local throw_direction = Quaternion.forward(scratchpad.throw_rotation:unbox())
	local fwd = Quaternion.forward(Unit.local_rotation(unit, 1))
	local right = Vector3.cross(fwd, Vector3.up())
	local relative_direction_name = MinionMovement.get_relative_direction_name(right, fwd, throw_direction)
	scratchpad.state = "aligning"
	local align_anim = action_data.align_anims[relative_direction_name]

	scratchpad.animation_extension:anim_event(align_anim)

	local locomotion_extension = scratchpad.locomotion_extension

	if relative_direction_name ~= "fwd" then
		MinionMovement.set_anim_driven(scratchpad, true)

		local anim_data = action_data.anim_data[align_anim]
		local rotation_sign = anim_data.sign
		local rotation_radians = anim_data.rad
		local destination = POSITION_LOOKUP[unit] + throw_direction
		local rotation_scale = Animation.calculate_anim_rotation_scale(unit, destination, rotation_sign, rotation_radians)

		locomotion_extension:set_anim_rotation_scale(rotation_scale)
	end

	scratchpad.throw_direction = Vector3Box(throw_direction)
	scratchpad.align_duration = t + action_data.align_duration[align_anim]
	scratchpad.throw_direction_name = relative_direction_name

	locomotion_extension:set_rotation_speed(action_data.rotation_speed)
end

local UP_POSITION_OFFSET = 1.5
local DOWN_POSITION_OFFSET = 0.5

BtBeastOfNurgleSpitOutAction._align_throwing = function (self, unit, scratchpad, action_data)
	local throw_directions = scratchpad.throw_directions
	local position_up = POSITION_LOOKUP[unit] + Vector3.up() * UP_POSITION_OFFSET
	local position_down = POSITION_LOOKUP[unit] + Vector3.up() * DOWN_POSITION_OFFSET

	for i = 1, #throw_directions do
		local test_direction = throw_directions[i]:unbox()
		local up_throw_test_position = position_up + test_direction * action_data.throw_test_distance
		local down_throw_test_position = position_down + test_direction * action_data.throw_test_distance
		local up_hit = self:_ray_cast(scratchpad.physics_world, position_up, up_throw_test_position)
		local down_hit = self:_ray_cast(scratchpad.physics_world, position_down, down_throw_test_position)

		if not up_hit and not down_hit then
			local trajectory_is_ok, new_direction = self:_test_throw_trajectory(unit, scratchpad, action_data, test_direction, down_throw_test_position)

			if trajectory_is_ok then
				scratchpad.throw_rotation = QuaternionBox(Quaternion.look(new_direction or test_direction))

				return
			end
		end
	end

	scratchpad.throw_rotation = QuaternionBox(Quaternion.inverse(Unit.local_rotation(unit, 1)))
end

BtBeastOfNurgleSpitOutAction._update_aligning = function (self, unit, scratchpad, action_data, breed, t)
	local throw_direction = scratchpad.throw_direction:unbox()
	local wanted_rotation = Quaternion.look(throw_direction)
	local throw_direction_name = scratchpad.throw_direction_name
	local locomotion_extension = scratchpad.locomotion_extension

	if throw_direction_name == "fwd" then
		locomotion_extension:set_wanted_rotation(wanted_rotation)
	end

	if scratchpad.align_duration and scratchpad.align_duration < t then
		MinionMovement.set_anim_driven(scratchpad, false)
		self:_add_threat_to_other_targets(unit, breed, scratchpad, scratchpad.consumed_unit)
		self:_start_throwing(unit, scratchpad, action_data, t)
	end
end

BtBeastOfNurgleSpitOutAction._start_throwing = function (self, unit, scratchpad, action_data, t)
	scratchpad.state = "throwing"
	local throw_anim = action_data.throw_anims[scratchpad.consumed_unit_breed_name]

	scratchpad.animation_extension:anim_event(throw_anim)

	scratchpad.throw_at_t = t + action_data.throw_timing[scratchpad.consumed_unit_breed_name]
	scratchpad.throw_duration = t + action_data.throw_duration[scratchpad.consumed_unit_breed_name]
end

BtBeastOfNurgleSpitOutAction._update_throwing = function (self, unit, scratchpad, action_data, breed, t)
	local throw_direction = scratchpad.throw_direction:unbox()
	local locomotion_extension = scratchpad.locomotion_extension

	if scratchpad.throw_at_t and scratchpad.throw_at_t < t then
		scratchpad.throw_at_t = nil
		local hit_unit_disabled_state_input = scratchpad.hit_unit_disabled_state_input
		hit_unit_disabled_state_input.trigger_animation = "none"
		hit_unit_disabled_state_input.disabling_unit = nil
		scratchpad.wants_catapult = true
	else
		local disabled_character_state_component = scratchpad.hit_unit_disabled_character_state_component
		local is_disabled = disabled_character_state_component.is_disabled

		if scratchpad.wants_catapult and not is_disabled then
			local target_unit = scratchpad.consumed_unit
			local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
			local catapult_force = action_data.catapult_force[scratchpad.consumed_unit_breed_name]
			local catapult_z_force = action_data.catapult_z_force[scratchpad.consumed_unit_breed_name]
			local direction = Vector3.normalize(throw_direction)
			local velocity = direction * catapult_force
			velocity.z = catapult_z_force
			local catapulted_state_input = target_unit_data_extension:write_component("catapulted_state_input")

			Catapulted.apply(catapulted_state_input, velocity)

			scratchpad.wants_catapult = nil
			scratchpad.behavior_component.consumed_unit = nil
		end

		if scratchpad.throw_duration and scratchpad.throw_duration < t then
			MinionMovement.set_anim_driven(scratchpad, false)

			local after_throw_taunt_anim_event = Animation.random_event(action_data.after_throw_taunt_anim)

			scratchpad.animation_extension:anim_event(after_throw_taunt_anim_event)

			local after_throw_taunt_duration = action_data.after_throw_taunt_duration
			scratchpad.after_throw_taunt_duration = t + after_throw_taunt_duration
			scratchpad.throw_duration = nil
		elseif scratchpad.after_throw_taunt_duration then
			local target_unit = scratchpad.consumed_unit

			if target_unit then
				local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

				locomotion_extension:set_wanted_rotation(flat_rotation)

				if scratchpad.after_throw_taunt_duration <= t then
					scratchpad.state = "done"
				end
			end
		end
	end
end

local ABOVE = 1
local BELOW = 2
local LATERAL = 2
local MAX_STEPS = 20
local MAX_TIME = 1.25
local THROW_TELEPORT_UP_OFFSET_HUMAN = 1.5
local THROW_TELEPORT_UP_OFFSET_OGRYN = 1.5
local THROW_TELEPORT_FWD_OFFSET_HUMAN = 3.2
local THROW_TELEPORT_FWD_OFFSET_OGRYN = 3.2

BtBeastOfNurgleSpitOutAction._test_throw_trajectory = function (self, unit, scratchpad, action_data, test_direction, to)
	local unit_position = POSITION_LOOKUP[unit]
	local is_human = scratchpad.consumed_unit_breed_name == "human"
	local up = Vector3.up() * (is_human and THROW_TELEPORT_UP_OFFSET_HUMAN or THROW_TELEPORT_UP_OFFSET_OGRYN)
	local fwd = test_direction * (is_human and THROW_TELEPORT_FWD_OFFSET_HUMAN or THROW_TELEPORT_FWD_OFFSET_OGRYN)
	local from = unit_position + fwd + up
	local physics_world = scratchpad.physics_world
	local initial_ray_test = self:_ray_cast(physics_world, unit_position + up, from)

	if initial_ray_test then
		return false
	end

	local catapult_force = action_data.catapult_force[scratchpad.consumed_unit_breed_name]
	local catapult_z_force = action_data.catapult_z_force[scratchpad.consumed_unit_breed_name]
	local direction = Vector3.normalize(test_direction)
	local catapult_velocity = direction * catapult_force
	catapult_velocity.z = catapult_z_force
	local speed = Vector3.length(catapult_velocity)
	local target_velocity = Vector3(0, 0, 0)
	local gravity = PlayerCharacterConstants.gravity
	local angle, estimated_position = Trajectory.angle_to_hit_moving_target(from, to, speed, target_velocity, gravity, 1)

	if angle == nil then
		return false
	end

	local velocity = Trajectory.get_trajectory_velocity(from, estimated_position, gravity, speed, angle)
	local hit, segment_list, _, hit_position = Trajectory.ballistic_raycast(physics_world, "filter_player_mover", from, velocity, angle, gravity, MAX_STEPS, MAX_TIME)

	if hit then
		local navigation_extension = scratchpad.navigation_extension
		local nav_world = scratchpad.nav_world
		local traverse_logic = navigation_extension:traverse_logic()
		local navmesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, hit_position, ABOVE, BELOW, LATERAL)

		if navmesh_position then
			local new_direction = Vector3.normalize(Vector3.flat(navmesh_position - unit_position))

			return true, new_direction
		else
			return false
		end
	else
		return false
	end
end

local DEGREE_RANGE = 360

BtBeastOfNurgleSpitOutAction._calculate_randomized_throw_directions = function (self, action_data)
	local degree_per_direction = action_data.degree_per_throw_direction
	local num_directions = DEGREE_RANGE / degree_per_direction
	local current_degree = -(DEGREE_RANGE / 2)
	local directions = {}

	for i = 1, num_directions do
		current_degree = current_degree + degree_per_direction
		local radians = math.degrees_to_radians(current_degree)
		local direction = Vector3(math.sin(radians), math.cos(radians), 0)
		directions[i] = Vector3Box(direction)
	end

	table.shuffle(directions)

	return directions
end

BtBeastOfNurgleSpitOutAction._add_threat_to_other_targets = function (self, unit, breed, scratchpad, excluded_target)
	local side_system = scratchpad.side_system
	local side = side_system.side_by_unit[unit]
	local valid_enemy_player_units = side.valid_enemy_player_units
	local num_enemies = #valid_enemy_player_units
	local perception_extension = ScriptUnit.extension(unit, "perception_system")
	local max_threat = breed.threat_config.max_threat

	for i = 1, num_enemies do
		local target_unit = valid_enemy_player_units[i]

		if target_unit ~= excluded_target then
			perception_extension:add_threat(target_unit, max_threat)
		end
	end
end

BtBeastOfNurgleSpitOutAction._rotate_towards_target_unit = function (self, unit, scratchpad)
	local target_unit = scratchpad.target_unit
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

	scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)

	return flat_rotation
end

local COLLISION_FILTER = "filter_player_mover"

BtBeastOfNurgleSpitOutAction._ray_cast = function (self, physics_world, from, to)
	local to_target = to - from
	local direction = Vector3.normalize(to_target)
	local distance = Vector3.length(to_target)
	local result, hit_position, hit_distance, normal, _ = PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", COLLISION_FILTER)

	return result, hit_position, hit_distance, normal
end

return BtBeastOfNurgleSpitOutAction
