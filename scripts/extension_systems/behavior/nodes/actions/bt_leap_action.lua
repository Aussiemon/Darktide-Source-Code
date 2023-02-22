require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local GroundImpact = require("scripts/utilities/attack/ground_impact")
local Trajectory = require("scripts/utilities/trajectory")
local BtLeapAction = class("BtLeapAction", "BtNode")

BtLeapAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn
	scratchpad.physics_world = spawn_component.physics_world
	scratchpad.world = spawn_component.world
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local perception_component = Blackboard.write_component(blackboard, "perception")
	scratchpad.behavior_component = behavior_component
	scratchpad.perception_component = perception_component
	scratchpad.side_system = Managers.state.extension:system("side_system")
	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = navigation_extension

	MinionPerception.set_target_lock(unit, perception_component, true)

	scratchpad.target_dodged_during_attack = false
	scratchpad.target_dodged_type = nil
	scratchpad.dodged_attack = false

	locomotion_extension:set_movement_type("constrained_by_mover")
	locomotion_extension:set_affected_by_gravity(true)

	if action_data.aoe_bot_threat_timing then
		scratchpad.aoe_bot_threat_timing = t + action_data.aoe_bot_threat_timing
	end

	local start_duration = action_data.start_duration or 0
	scratchpad.start_duration = t + start_duration
	local start_leap_anim = action_data.start_leap_anim_event

	animation_extension:anim_event(start_leap_anim)

	scratchpad.state = "starting"
	behavior_component.move_state = "moving"
	scratchpad.broadphase_system = Managers.state.extension:system("broadphase_system")
	scratchpad.pushed_minions = {}
	scratchpad.pushed_enemies = {}
end

BtLeapAction.init_values = function (self, blackboard)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	behavior_component.should_leap = false

	behavior_component.leap_velocity:store(0, 0, 0)
end

BtLeapAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_affected_by_gravity(false)

	if not scratchpad.hit_target then
		locomotion_extension:set_movement_type("snap_to_navmesh")
		locomotion_extension:set_mover_displacement(nil)
		locomotion_extension:set_gravity(nil)
		locomotion_extension:set_check_falling(true)
		locomotion_extension:set_anim_driven(false)
	end

	MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)

	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	behavior_component.should_leap = false
end

BtLeapAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local behavior_component = scratchpad.behavior_component
	local state = scratchpad.state
	local locomotion_extension = scratchpad.locomotion_extension
	local mover = Unit.mover(unit)
	local target_unit = scratchpad.perception_component.target_unit

	if state == "starting" then
		local leap_velocity = behavior_component.leap_velocity:unbox()

		if leap_velocity then
			local leap_velocity_normalized = Vector3.flat(Vector3.normalize(leap_velocity))
			local wanted_rotation = Quaternion.look(leap_velocity_normalized)

			locomotion_extension:set_wanted_rotation(wanted_rotation)

			local speed = MinionMovement.get_animation_wanted_movement_speed(unit, dt)

			locomotion_extension:set_wanted_velocity(leap_velocity_normalized * speed)
		end

		local start_duration = scratchpad.start_duration

		if start_duration <= t and (leap_velocity or scratchpad.current_velocity) then
			self:_try_start_leap(unit, t, blackboard, scratchpad, action_data)
		end

		if scratchpad.aoe_bot_threat_timing and scratchpad.aoe_bot_threat_timing <= t then
			local group_extension = ScriptUnit.extension(target_unit, "group_system")
			local bot_group = group_extension:bot_group()
			local aoe_bot_threat_size = action_data.aoe_bot_threat_size:unbox()

			bot_group:aoe_threat_created(POSITION_LOOKUP[target_unit], "oobb", aoe_bot_threat_size, Unit.local_rotation(unit, 1), action_data.aoe_bot_threat_duration)

			scratchpad.aoe_bot_threat_timing = nil
		end

		MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
		MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, target_unit)
	elseif state == "leaping" then
		local current_velocity = locomotion_extension:current_velocity()

		if Mover.collides_down(mover) then
			self:_start_landing(unit, scratchpad, action_data, current_velocity, t)
		else
			local wanted_velocity = Vector3(current_velocity.x, current_velocity.y, 0)

			locomotion_extension:set_wanted_velocity(wanted_velocity)
		end

		MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
		MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, target_unit)
	elseif state == "landing" then
		if scratchpad.land_impact_timing and scratchpad.land_impact_timing <= t then
			local ground_impact_fx_template = action_data.land_ground_impact_fx_template

			if ground_impact_fx_template then
				GroundImpact.play(unit, scratchpad.physics_world, ground_impact_fx_template)

				scratchpad.land_impact_timing = nil
			end
		end

		if scratchpad.landing_duration < t and Mover.collides_down(mover) then
			locomotion_extension:set_anim_driven(false)
			locomotion_extension:use_lerp_rotation(true)

			return "done"
		end
	end

	return "running"
end

BtLeapAction._try_start_leap = function (self, unit, t, blackboard, scratchpad, action_data)
	local velocity = self:_get_leap_velocity(unit, scratchpad) or scratchpad.behavior_component.leap_velocity:unbox()

	if velocity then
		scratchpad.velocity = Vector3Box(velocity)
		scratchpad.start_duration = nil

		self:_leap(scratchpad, blackboard, action_data, t, unit)
	end
end

local MOVER_DISPLACEMENT_DURATION = 1
local OVERRIDE_SPEED_Z = 0

BtLeapAction._leap = function (self, scratchpad, blackboard, action_data, t, unit)
	scratchpad.navigation_extension:set_enabled(false)

	local mover_displacement = Vector3(0, 0, 0.5)
	local velocity = scratchpad.velocity:unbox()
	local gravity = action_data.gravity
	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_affected_by_gravity(true, OVERRIDE_SPEED_Z)
	locomotion_extension:set_movement_type("constrained_by_mover")
	locomotion_extension:set_mover_displacement(mover_displacement, MOVER_DISPLACEMENT_DURATION)
	locomotion_extension:set_wanted_velocity(velocity)
	locomotion_extension:set_gravity(gravity)
	locomotion_extension:set_check_falling(true)

	scratchpad.state = "leaping"
	local behavior_component = scratchpad.behavior_component
	behavior_component.move_state = "attacking"
end

BtLeapAction._start_landing = function (self, unit, scratchpad, action_data, current_velocity, t)
	scratchpad.state = "landing"
	scratchpad.landing_duration = t + action_data.landing_duration
	local animation_extension = scratchpad.animation_extension
	local land_anim_event = action_data.land_anim_event

	animation_extension:anim_event(land_anim_event)

	local locomotion_extension = scratchpad.locomotion_extension
	local anim_driven = true
	local affected_by_gravity = true

	locomotion_extension:set_anim_driven(anim_driven, affected_by_gravity, nil, OVERRIDE_SPEED_Z)
	locomotion_extension:use_lerp_rotation(false)

	local land_impact_timing = t + action_data.land_impact_timing
	scratchpad.land_impact_timing = land_impact_timing
end

local COLLISION_FILTER = "filter_minion_line_of_sight_check"

BtLeapAction._ray_cast = function (self, physics_world, from, to)
	local to_target = to - from
	local direction = Vector3.normalize(to_target)
	local distance = Vector3.length(to_target)
	local result, hit_position, hit_distance, normal, _ = PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", COLLISION_FILTER)

	return result, hit_position, hit_distance, normal
end

local MIN_LEAP_DISTANCE = 10
local MAX_LEAP_DISTANCE = 20
local LEAP_SPEED = 12
local GRAVITY = 12
local MAX_TIME_IN_FLIGHT = 3
local SECTIONS = 15

BtLeapAction._get_leap_velocity = function (self, unit, scratchpad)
	local self_position = POSITION_LOOKUP[unit] + Vector3.up()
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit

	if not target_unit then
		return false
	end

	local distance = perception_component.target_distance

	if distance < MIN_LEAP_DISTANCE or MAX_LEAP_DISTANCE < distance then
		return false
	end

	local speed = LEAP_SPEED
	local gravity = GRAVITY
	local acceptable_accuracy = 0.1
	local slot_system = Managers.state.extension:system("slot_system")
	local target_position = slot_system:user_unit_slot_position(unit)

	if not target_position then
		return false
	end

	local angle_to_hit_target, est_pos = Trajectory.angle_to_hit_moving_target(self_position, target_position, speed, Vector3(0, 0, 0), gravity, acceptable_accuracy)

	if not angle_to_hit_target then
		return false
	end

	local velocity, time_in_flight = Trajectory.get_trajectory_velocity(self_position, est_pos, gravity, speed, angle_to_hit_target)
	time_in_flight = math.min(time_in_flight, MAX_TIME_IN_FLIGHT)
	local debug = nil
	local trajectory_is_ok = Trajectory.check_trajectory_collisions(scratchpad.physics_world, self_position, est_pos, gravity, speed, angle_to_hit_target, SECTIONS, "filter_minion_shooting_geometry", time_in_flight, nil, debug, unit)

	if trajectory_is_ok then
		return velocity
	end

	return false
end

return BtLeapAction
