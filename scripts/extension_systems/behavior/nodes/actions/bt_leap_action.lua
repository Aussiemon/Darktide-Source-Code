require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Catapulted = require("scripts/extension_systems/character_state_machine/character_states/utilities/catapulted")
local ChaosSpawnSettings = require("scripts/settings/monster/chaos_spawn_settings")
local GroundImpact = require("scripts/utilities/attack/ground_impact")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local NavQueries = require("scripts/utilities/nav_queries")
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

	if action_data.catapult_units then
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")
		scratchpad.enemy_side_names = enemy_side_names
		scratchpad.units_catapulted = {}
		scratchpad.side = side
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		scratchpad.broadphase = broadphase_system.broadphase
	end

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

	local start_leap_anim = nil
	local distance = perception_component.target_distance
	local is_short_leap = distance <= ChaosSpawnSettings.short_leap_distance

	if is_short_leap then
		start_leap_anim = action_data.short_start_leap_anim_event
	else
		start_leap_anim = action_data.start_leap_anim_event
	end

	animation_extension:anim_event(start_leap_anim)

	scratchpad.start_duration = t + action_data.start_duration[start_leap_anim]
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
		local target_position = POSITION_LOOKUP[target_unit]

		if target_position then
			local towards_target_position = Vector3.flat(Vector3.normalize(target_position - POSITION_LOOKUP[unit]))
			local wanted_rotation = Quaternion.look(towards_target_position)

			locomotion_extension:set_wanted_rotation(wanted_rotation)

			local speed = MinionMovement.get_animation_wanted_movement_speed(unit, dt)

			locomotion_extension:set_wanted_velocity(towards_target_position * speed)
		end

		local start_duration = scratchpad.start_duration

		if start_duration <= t and (leap_velocity or scratchpad.current_velocity) then
			self:_try_start_leap(unit, t, blackboard, scratchpad, action_data)
		end

		if ALIVE[target_unit] and scratchpad.aoe_bot_threat_timing and scratchpad.aoe_bot_threat_timing <= t then
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

				self:_catapult_units(unit, scratchpad, action_data, t)
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
	local velocity = self:_get_leap_velocity(unit, scratchpad, action_data) or scratchpad.behavior_component.leap_velocity:unbox()

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
	local gravity = ChaosSpawnSettings.leap_gravity
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

local SECTIONS = 15

BtLeapAction._get_leap_velocity = function (self, unit, scratchpad, action_data)
	local self_position = POSITION_LOOKUP[unit] + Vector3.up()
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit

	if not target_unit then
		return false
	end

	local speed = ChaosSpawnSettings.leap_speed
	local gravity = ChaosSpawnSettings.leap_gravity
	local acceptable_accuracy = 0.1
	local target_position = POSITION_LOOKUP[perception_component.target_unit]
	local offset_dir = Vector3.normalize(self_position - target_position)
	target_position = target_position + offset_dir * ChaosSpawnSettings.offset_in_front_of_target
	local nav_world = scratchpad.navigation_extension:nav_world()
	local target_position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, target_position, 1, 1, 0.5, 0.1)

	if not target_position_on_navmesh then
		return false
	end

	local angle_to_hit_target, est_pos = Trajectory.angle_to_hit_moving_target(self_position, target_position_on_navmesh, speed, Vector3(0, 0, 0), gravity, acceptable_accuracy)

	if not angle_to_hit_target then
		return false
	end

	local velocity, time_in_flight = Trajectory.get_trajectory_velocity(self_position, est_pos, gravity, speed, angle_to_hit_target)
	time_in_flight = math.min(time_in_flight, ChaosSpawnSettings.leap_max_time_in_flight)
	local debug = nil
	local trajectory_is_ok = Trajectory.check_trajectory_collisions(scratchpad.physics_world, self_position, est_pos, gravity, speed, angle_to_hit_target, SECTIONS, "filter_minion_shooting_geometry", time_in_flight, nil, debug, unit)

	if trajectory_is_ok then
		return velocity
	end

	return false
end

local broadphase_results = {}

BtLeapAction._catapult_units = function (self, unit, scratchpad, action_data, t)
	local data = action_data.catapult_units
	local units_catapulted = scratchpad.units_catapulted
	local speed = data.speed
	local angle = data.angle
	local radius = data.radius
	local radius_sq = radius * radius
	local side = scratchpad.side
	local valid_enemy_player_units = side.valid_enemy_player_units
	local broadphase = scratchpad.broadphase
	local unit_position = POSITION_LOOKUP[unit]
	local enemy_side_names = scratchpad.enemy_side_names
	local num_results = broadphase:query(unit_position, radius, broadphase_results, enemy_side_names)

	for i = 1, num_results do
		local hit_unit = broadphase_results[i]
		local hit_position = POSITION_LOOKUP[hit_unit]
		local offset = hit_position - unit_position
		local distance_squared = Vector3.length_squared(offset)

		if not units_catapulted[hit_unit] and valid_enemy_player_units[hit_unit] and distance_squared < radius_sq then
			local length = speed * math.cos(angle)
			local height = speed * math.sin(angle)
			local flat_offset_direction = Vector3.normalize(Vector3.flat(offset))
			local push_velocity = flat_offset_direction * length
			push_velocity.z = height
			local target_unit_data_extension = ScriptUnit.extension(hit_unit, "unit_data_system")
			local catapulted_state_input = target_unit_data_extension:write_component("catapulted_state_input")

			Catapulted.apply(catapulted_state_input, push_velocity)

			units_catapulted[hit_unit] = hit_unit
		end
	end

	MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
end

return BtLeapAction
