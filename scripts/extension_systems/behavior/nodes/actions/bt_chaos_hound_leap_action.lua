require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local GroundImpact = require("scripts/utilities/attack/ground_impact")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Trajectory = require("scripts/utilities/trajectory")
local BtChaosHoundLeapAction = class("BtChaosHoundLeapAction", "BtNode")

BtChaosHoundLeapAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
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
	local stagger_component = Blackboard.write_component(blackboard, "stagger")
	scratchpad.stagger_component = stagger_component

	MinionPerception.set_target_lock(unit, perception_component, true)

	scratchpad.target_dodged_during_attack = false
	scratchpad.target_dodged_type = nil
	scratchpad.dodged_attack = false

	locomotion_extension:set_movement_type("constrained_by_mover")
	locomotion_extension:set_affected_by_gravity(true)

	if action_data.aoe_bot_threat_timing then
		scratchpad.aoe_bot_threat_timing = t + action_data.aoe_bot_threat_timing
	end

	local target_distance = perception_component.target_distance
	local min_velocity = action_data.long_leap_min_velocity
	local current_velocity = Vector3.length(locomotion_extension:current_velocity())

	if current_velocity < min_velocity or target_distance < action_data.short_distance then
		local start_duration = action_data.start_duration_short or 0
		scratchpad.start_duration = t + start_duration
		local start_leap_anim = action_data.start_leap_anim_event_short

		animation_extension:anim_event(start_leap_anim)

		scratchpad.short_leap = true
	else
		local start_duration = action_data.start_duration or 0
		scratchpad.start_duration = t + start_duration
		local start_leap_anim = action_data.start_leap_anim_event

		animation_extension:anim_event(start_leap_anim)
	end

	scratchpad.state = "starting"
	behavior_component.move_state = "moving"
	scratchpad.broadphase_system = Managers.state.extension:system("broadphase_system")
	scratchpad.pushed_minions = {}
	scratchpad.pushed_enemies = {}
	scratchpad.stagger_component.controlled_stagger_finished = true
end

local OVERRIDE_SPEED_Z = 0

BtChaosHoundLeapAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	scratchpad.stagger_component.controlled_stagger_finished = false

	if not scratchpad.hit_target then
		local locomotion_extension = scratchpad.locomotion_extension

		locomotion_extension:set_mover_displacement(nil)

		if scratchpad.is_anim_driven then
			MinionMovement.set_anim_driven(scratchpad, false)
		end

		if reason ~= "done" then
			self:_set_pounce_cooldown(blackboard, t)
		end

		locomotion_extension:set_movement_type("snap_to_navmesh")
	end

	MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)

	local pounce_component = Blackboard.write_component(blackboard, "pounce")
	pounce_component.started_leap = false
end

BtChaosHoundLeapAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local behavior_component = scratchpad.behavior_component
	local state = scratchpad.state
	local locomotion_extension = scratchpad.locomotion_extension
	local mover = Unit.mover(unit)
	local target_unit = scratchpad.perception_component.target_unit

	if state == "starting" then
		local wanted_velocity = nil
		local leap_velocity = self:_calculate_wanted_velocity(unit, t, scratchpad, action_data)

		if leap_velocity then
			leap_velocity = Vector3.normalize(leap_velocity) * action_data.start_move_speed
			wanted_velocity = Vector3(leap_velocity.x, leap_velocity.y, 0)
		else
			local wanted_direction = Vector3.flat(Vector3.normalize(POSITION_LOOKUP[target_unit] - POSITION_LOOKUP[unit]))
			wanted_velocity = wanted_direction * action_data.start_move_speed
			wanted_velocity = Vector3(wanted_velocity.x, wanted_velocity.y, 0)
		end

		if scratchpad.short_leap then
			self:_update_ground_normal_rotation(unit, target_unit, scratchpad, true)
		else
			self:_update_ground_normal_rotation(unit, target_unit, scratchpad, false)
			locomotion_extension:set_wanted_velocity(wanted_velocity)
		end

		local start_duration = scratchpad.start_duration

		if start_duration <= t then
			if leap_velocity or scratchpad.current_velocity then
				self:_try_start_leap(unit, t, scratchpad, action_data)
			else
				local hit_position, hit_normal = self:_check_wall_collision(unit, scratchpad, action_data)

				if hit_position then
					self:_start_wall_jump(unit, scratchpad, action_data, hit_normal)
				else
					scratchpad.animation_extension:anim_event(action_data.stop_anim)

					scratchpad.stop_duration = t + action_data.stop_duration
					scratchpad.state = "stopping"
					behavior_component.move_state = "idle"

					return "running"
				end
			end
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
	elseif state == "telegraph_leap" then
		local telegraph_timing = scratchpad.telegraph_timing

		if telegraph_timing <= t then
			self:_leap(scratchpad, blackboard, action_data, t, unit)

			scratchpad.telegraph_timing = nil
		end

		MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
		MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, target_unit)
	elseif state == "leaping" then
		local is_dodging, dodge_type = Dodge.is_dodging(target_unit)

		if is_dodging and not scratchpad.target_dodged_during_attack then
			scratchpad.target_dodged_during_attack = true
			scratchpad.target_dodged_type = dodge_type
		end

		local current_colliding_target = scratchpad.current_colliding_target
		local hit_player_unit = scratchpad.init_hit_target or self:_check_colliding_players(unit, scratchpad, action_data)

		if not scratchpad.current_colliding_target_check_time and (hit_player_unit and current_colliding_target ~= target_unit or hit_player_unit == target_unit) then
			local extra_timing = 0
			local player_unit_spawn_manager = Managers.state.player_unit_spawn
			local player = player_unit_spawn_manager:owner(hit_player_unit)

			if player and player.remote then
				extra_timing = player:lag_compensation_rewind_s() * 0.5
				scratchpad.lag_compensation_rewind_s = extra_timing
			end

			scratchpad.current_colliding_target = hit_player_unit
			scratchpad.current_colliding_target_check_time = t + extra_timing
		elseif scratchpad.current_colliding_target then
			if scratchpad.current_colliding_target_check_time <= t then
				local pounce_component = Blackboard.write_component(blackboard, "pounce")
				pounce_component.pounce_target = scratchpad.current_colliding_target
				scratchpad.hit_target = true
				scratchpad.current_colliding_target = nil
				scratchpad.current_colliding_target_check_time = nil

				return "done"
			end
		elseif target_unit and ALIVE[target_unit] then
			local current_velocity = locomotion_extension:current_velocity()
			local current_direction = Vector3.normalize(current_velocity)
			local position = POSITION_LOOKUP[unit]
			local target_unit_position = POSITION_LOOKUP[target_unit]
			local to_target = target_unit_position - position
			local direction_to_target = Vector3.normalize(to_target)
			local dot_to_target = Vector3.dot(current_direction, direction_to_target)

			if dot_to_target < 0 and scratchpad.target_dodged_during_attack and not scratchpad.dodged_attack then
				dodge_type = scratchpad.target_dodged_type

				Dodge.sucessful_dodge(target_unit, unit, nil, dodge_type, breed)

				scratchpad.dodged_attack = true
			end
		end

		local current_velocity = locomotion_extension:current_velocity()

		if mover and Mover.collides_down(mover) then
			self:_start_landing(scratchpad, action_data, current_velocity, t)
		elseif mover and (Mover.collides_sides(mover) or Mover.collides_up(mover)) then
			local hit_position, hit_normal = self:_check_wall_collision(unit, scratchpad, action_data, current_velocity)

			if hit_position then
				self:_start_wall_jump(unit, scratchpad, action_data, hit_normal)
			end
		else
			local wanted_velocity = Vector3(current_velocity.x, current_velocity.y, 0)

			locomotion_extension:set_wanted_velocity(wanted_velocity)
		end

		MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
		MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, target_unit)
		self:_update_in_air_stagger(unit, t, dt, scratchpad, action_data)
	elseif state == "in_air_stagger" then
		self:_update_in_air_stagger(unit, t, dt, scratchpad, action_data)

		local current_velocity = locomotion_extension:current_velocity()

		if mover and Mover.collides_down(mover) then
			self:_stop_in_air_stagger(scratchpad)
			self:_start_landing(scratchpad, action_data, current_velocity, t)
		elseif mover and (Mover.collides_sides(mover) or Mover.collides_up(mover)) then
			self:_stop_in_air_stagger(scratchpad)

			local hit_position, hit_normal = self:_check_wall_collision(unit, scratchpad, action_data, current_velocity)

			if hit_position then
				self:_start_wall_jump(unit, scratchpad, action_data, hit_normal)
			end
		end
	elseif state == "wall_jump" then
		local wall_land_duration = scratchpad.wall_land_duration

		if mover and Mover.collides_down(mover) and not wall_land_duration then
			local wall_land_anim_event = action_data.wall_land_anim_event

			scratchpad.animation_extension:anim_event(wall_land_anim_event)

			scratchpad.wall_land_duration = t + action_data.wall_land_duration
		end

		if wall_land_duration and wall_land_duration <= t then
			locomotion_extension:set_anim_driven(false)
			self:_set_pounce_cooldown(blackboard, t)

			return "done"
		end
	elseif state == "landing" then
		if scratchpad.land_impact_timing and scratchpad.land_impact_timing <= t then
			local ground_impact_fx_template = action_data.land_ground_impact_fx_template

			if ground_impact_fx_template then
				GroundImpact.play(unit, scratchpad.physics_world, ground_impact_fx_template)

				scratchpad.land_impact_timing = nil
			end
		end

		if scratchpad.landing_duration < t then
			locomotion_extension:set_anim_driven(false)
			locomotion_extension:use_lerp_rotation(true)
			self:_set_pounce_cooldown(blackboard, t)

			return "done"
		end
	elseif state == "stopping" and scratchpad.stop_duration < t then
		self:_set_pounce_cooldown(blackboard, t)

		return "done"
	end

	return "running"
end

BtChaosHoundLeapAction._try_start_leap = function (self, unit, t, scratchpad, action_data)
	local velocity = scratchpad.current_velocity and scratchpad.current_velocity:unbox() or self:_calculate_wanted_velocity(unit, t, scratchpad, action_data)

	if velocity then
		scratchpad.velocity = Vector3Box(velocity)
		local telegraph_timing = action_data.telegraph_timing
		scratchpad.telegraph_timing = t + telegraph_timing
		scratchpad.start_duration = nil
		scratchpad.state = "telegraph_leap"
	end
end

local MAX_TIME_IN_FLIGHT = 10

BtChaosHoundLeapAction._calculate_wanted_velocity = function (self, unit, t, scratchpad, action_data)
	local target_node_name = action_data.target_node_name
	local physics_world = scratchpad.physics_world
	local self_position = POSITION_LOOKUP[unit] + Vector3.up() * 0.5
	local target_unit = scratchpad.perception_component.target_unit
	local target_node = Unit.node(target_unit, target_node_name)
	local offset = Vector3(0, 0, action_data.z_offset)
	local target_position = Unit.world_position(target_unit, target_node) + offset
	local to_target = Vector3.normalize(target_position - self_position)
	local right = Vector3.cross(to_target, Vector3.up())
	local raycast_collision_check_offset = right * action_data.raycast_collision_check_offset
	local left_ray_cast_hit = self:_ray_cast(physics_world, self_position + raycast_collision_check_offset, target_position + raycast_collision_check_offset)
	local right_ray_cast_hit = not left_ray_cast_hit and self:_ray_cast(physics_world, self_position - raycast_collision_check_offset, target_position - raycast_collision_check_offset)

	if left_ray_cast_hit or right_ray_cast_hit then
		return
	end

	local is_dodging = Dodge.is_dodging(target_unit)
	local speed = action_data.leap_speed
	local target_unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
	local locomotion_component = target_unit_data_extension:read_component("locomotion")
	local target_velocity = is_dodging and Vector3(0, 0, 0) or locomotion_component.velocity_current
	local gravity = action_data.gravity
	local acceptable_accuracy = action_data.acceptable_accuracy
	local angle_to_hit_target, est_pos = Trajectory.angle_to_hit_moving_target(self_position, target_position, speed, target_velocity, gravity, acceptable_accuracy)

	if not angle_to_hit_target then
		return
	end

	angle_to_hit_target = math.min(angle_to_hit_target, 0.5)
	local velocity, time_in_flight = Trajectory.get_trajectory_velocity(self_position, est_pos, gravity, speed, angle_to_hit_target)
	time_in_flight = math.min(time_in_flight, MAX_TIME_IN_FLIGHT)
	local debug = nil
	local trajectory_is_ok = Trajectory.check_trajectory_collisions(scratchpad.physics_world, self_position, est_pos, gravity, speed, angle_to_hit_target, 10, "filter_minion_shooting_geometry", time_in_flight, nil, debug, unit)

	if trajectory_is_ok then
		scratchpad.current_velocity = Vector3Box(velocity)

		return velocity
	end
end

local MOVER_DISPLACEMENT_DURATION = 0.1

BtChaosHoundLeapAction._leap = function (self, scratchpad, blackboard, action_data, t, unit)
	local ignore_dot_check = true
	local hit_target = self:_check_colliding_players(unit, scratchpad, action_data, ignore_dot_check)
	scratchpad.init_hit_target = hit_target

	scratchpad.navigation_extension:set_enabled(false)

	local mover_displacement = Vector3(0, 0, 0.25)
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
	local pounce_component = Blackboard.write_component(blackboard, "pounce")
	pounce_component.started_leap = true
	scratchpad.stagger_component.controlled_stagger_finished = false
end

BtChaosHoundLeapAction._start_landing = function (self, scratchpad, action_data, current_velocity, t)
	scratchpad.state = "landing"
	scratchpad.landing_duration = t + action_data.landing_duration
	local animation_extension = scratchpad.animation_extension
	local land_anim_event = action_data.land_anim_event

	animation_extension:anim_event(land_anim_event)

	local locomotion_extension = scratchpad.locomotion_extension
	local anim_driven = true
	local affected_by_gravity = true

	locomotion_extension:set_movement_type("snap_to_navmesh")
	locomotion_extension:set_mover_displacement(nil)
	locomotion_extension:set_anim_driven(anim_driven, affected_by_gravity, nil, OVERRIDE_SPEED_Z)
	locomotion_extension:use_lerp_rotation(false)

	if action_data.land_impact_timing then
		local land_impact_timing = t + action_data.land_impact_timing
		scratchpad.land_impact_timing = land_impact_timing
	end

	scratchpad.stagger_component.controlled_stagger_finished = true
end

BtChaosHoundLeapAction._start_wall_jump = function (self, unit, scratchpad, action_data, wall_normal)
	scratchpad.state = "wall_jump"
	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_wanted_velocity(Vector3.zero())
	locomotion_extension:set_affected_by_gravity(false, OVERRIDE_SPEED_Z)

	local anim_driven = true
	local affected_by_gravity = false
	local script_driven_rotation = true

	locomotion_extension:set_anim_driven(anim_driven, affected_by_gravity, script_driven_rotation)

	local rotation = Quaternion.look(-wall_normal)

	Unit.set_local_rotation(unit, 1, rotation)

	local wall_jump_anim_event = action_data.wall_jump_anim_event

	scratchpad.animation_extension:anim_event(wall_jump_anim_event)

	scratchpad.stagger_component.controlled_stagger_finished = true
end

BtChaosHoundLeapAction._check_wall_collision = function (self, unit, scratchpad, action_data)
	local wall_raycast_node_name = action_data.wall_raycast_node_name
	local wall_raycast_node = Unit.node(unit, wall_raycast_node_name)
	local from = Unit.world_position(unit, wall_raycast_node)
	local physics_world = scratchpad.physics_world
	local wall_raycast_distance = action_data.wall_raycast_distance
	local rotation = Unit.local_rotation(unit, 1)
	local direction = Quaternion.forward(rotation)
	local collision_filter = "filter_minion_line_of_sight_check"
	local _, hit_position, _, hit_normal_1, _ = PhysicsWorld.raycast(physics_world, from, direction, wall_raycast_distance, "closest", "collision_filter", collision_filter)

	if not hit_position then
		local right = Quaternion.right(rotation)
		local from_right = from + right
		_, hit_position, _, hit_normal_1, _ = PhysicsWorld.raycast(physics_world, from_right, direction, wall_raycast_distance, "closest", "collision_filter", collision_filter)
	end

	if not hit_position then
		local left = -Quaternion.right(rotation)
		local from_left = from + left
		_, hit_position, _, hit_normal_1, _ = PhysicsWorld.raycast(physics_world, from_left, direction, wall_raycast_distance, "closest", "collision_filter", collision_filter)
	end

	if hit_position then
		local average_normal = hit_normal_1
		local num_normal_hits = 1
		local from_2 = from + Vector3.up() * 0.5
		local from_3 = from - Vector3.up() * 0.5
		local _, _, _, hit_normal_2, _ = PhysicsWorld.raycast(physics_world, from_2, direction, wall_raycast_distance, "closest", "collision_filter", collision_filter)

		if hit_normal_2 then
			average_normal = average_normal + hit_normal_2
			num_normal_hits = num_normal_hits + 1
		end

		local _, _, _, hit_normal_3, _ = PhysicsWorld.raycast(physics_world, from_3, direction, wall_raycast_distance, "closest", "collision_filter", collision_filter)

		if hit_normal_3 then
			average_normal = average_normal + hit_normal_3
			num_normal_hits = num_normal_hits + 1
		end

		average_normal = average_normal / num_normal_hits

		return hit_position, average_normal
	end
end

local LEAP_NODE = "j_head"
local TARGET_LEAP_NODE = "j_spine"

BtChaosHoundLeapAction._check_colliding_players = function (self, unit, scratchpad, action_data, ignore_dot_check)
	local attacking_unit_pos = Unit.world_position(unit, Unit.node(unit, LEAP_NODE))
	local direction = Quaternion.forward(Unit.world_rotation(unit, 1))
	local physics_world = scratchpad.physics_world
	local radius = action_data.collision_radius
	local dodge_radius = action_data.dodge_collision_radius
	local hit_actors, actor_count = PhysicsWorld.immediate_overlap(physics_world, "shape", "sphere", "position", attacking_unit_pos, "size", radius, "types", "dynamics", "collision_filter", "filter_player_detection")

	for i = 1, actor_count do
		repeat
			local hit_actor = hit_actors[i]
			local hit_unit = Actor.unit(hit_actor)
			local hit_unit_pos = Unit.world_position(hit_unit, Unit.node(hit_unit, TARGET_LEAP_NODE))
			local is_dodging = Dodge.is_dodging(hit_unit)

			if is_dodging then
				local flat_pos = Vector3(attacking_unit_pos.x, attacking_unit_pos.y, hit_unit_pos.z)
				local distance = Vector3.distance(flat_pos, hit_unit_pos)

				if dodge_radius < distance then
					break
				end
			end

			local to_target = Vector3.normalize(hit_unit_pos - attacking_unit_pos)
			local dot = Vector3.dot(to_target, direction)

			if dot < action_data.max_pounce_dot and not ignore_dot_check then
				break
			end

			local target_unit_data_extension = ScriptUnit.extension(hit_unit, "unit_data_system")
			local disabled_character_state_component = target_unit_data_extension:read_component("disabled_character_state")
			local is_pounced = PlayerUnitStatus.is_pounced(disabled_character_state_component)
			local side_system = scratchpad.side_system
			local side = side_system.side_by_unit[unit]
			local ai_target_units = side.ai_target_units
			local character_state_component = target_unit_data_extension:read_component("character_state")
			local is_on_ladder = PlayerUnitStatus.is_climbing_ladder(character_state_component)

			if ai_target_units[hit_unit] and not is_pounced and not is_on_ladder then
				return hit_unit
			end
		until true
	end

	return nil
end

local TO_OFFSET_UP_DISTANCE = 2

BtChaosHoundLeapAction._update_ground_normal_rotation = function (self, unit, target_unit, scratchpad, towards_target)
	local physics_world = scratchpad.physics_world
	local self_position = POSITION_LOOKUP[unit]
	local offset_up = Vector3.up()
	local forward, from_position_1 = nil

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

	local to_position_1 = from_position_1 - offset_up * TO_OFFSET_UP_DISTANCE
	local _, hit_position_1 = self:_ray_cast(physics_world, from_position_1, to_position_1)
	local from_position_2 = self_position + offset_up - forward
	local to_position_2 = from_position_2 - offset_up * TO_OFFSET_UP_DISTANCE
	local _, hit_position_2 = self:_ray_cast(physics_world, from_position_2, to_position_2)

	if hit_position_1 and hit_position_2 then
		local locomotion_extension = scratchpad.locomotion_extension
		local current_velocity = locomotion_extension:current_velocity()
		local velocity_normalized = Vector3.normalize(current_velocity)
		local wanted_direction = Vector3.normalize(hit_position_1 - hit_position_2)

		if not towards_target then
			wanted_direction[1] = velocity_normalized[1]
			wanted_direction[2] = velocity_normalized[2]
		end

		local wanted_rotation = Quaternion.look(wanted_direction)

		locomotion_extension:set_wanted_rotation(wanted_rotation)
	end
end

BtChaosHoundLeapAction._update_in_air_stagger = function (self, unit, t, dt, scratchpad, action_data)
	local stagger_component = scratchpad.stagger_component
	local locomotion_extension = scratchpad.locomotion_extension
	local animation_extension = scratchpad.animation_extension
	local behavior_component = scratchpad.behavior_component
	local done = false

	if stagger_component.controlled_stagger and not scratchpad.stagger_duration then
		scratchpad.stagger_velocity_magnitude = Vector3.length(locomotion_extension:current_velocity())

		if scratchpad.is_anim_driven then
			MinionMovement.set_anim_driven(scratchpad, false)
		end

		local stagger_anims = action_data.in_air_staggers
		local stagger_anim = Animation.random_event(stagger_anims)

		animation_extension:anim_event(stagger_anim)
		locomotion_extension:set_movement_type("constrained_by_mover")

		local override_velocity_z = 0

		locomotion_extension:set_affected_by_gravity(true, override_velocity_z)

		local durations = action_data.in_air_stagger_duration

		if type(durations) == "table" then
			local duration = durations[stagger_anim]
			scratchpad.stagger_duration = t + duration
			local min_durations = action_data.in_air_stagger_min_duration

			if min_durations then
				local min_duration = min_durations[stagger_anim]

				if min_duration then
					scratchpad.stagger_min_duration = t + min_duration
				end
			end
		else
			scratchpad.stagger_duration = t + durations
		end

		scratchpad.original_movement_speed = scratchpad.navigation_extension:max_speed()
		behavior_component.lock_combat_range_switch = true
		stagger_component.immune_time = 0
		scratchpad.state = "in_air_stagger"
	end

	local running_stagger_min_duration = scratchpad.stagger_min_duration
	scratchpad.running_stagger_block_evaluate = running_stagger_min_duration and t < running_stagger_min_duration

	if scratchpad.stagger_duration and scratchpad.stagger_duration < t then
		self:_stop_in_air_stagger(scratchpad)

		done = true
	elseif scratchpad.stagger_duration then
		local stagger_direction = stagger_component.direction:unbox()
		local magnitude = scratchpad.stagger_velocity_magnitude * 0.5
		local stagger_velocity = Vector3(stagger_direction.x * magnitude, stagger_direction.y * magnitude, 0)

		locomotion_extension:set_wanted_velocity(stagger_velocity)
		locomotion_extension:set_wanted_rotation(Quaternion.look(-Vector3.flat(stagger_direction)))
	end

	return done
end

BtChaosHoundLeapAction._stop_in_air_stagger = function (self, scratchpad)
	local locomotion_extension = scratchpad.locomotion_extension
	local behavior_component = scratchpad.behavior_component

	locomotion_extension:set_movement_type("snap_to_navmesh")

	scratchpad.stagger_duration = nil
	behavior_component.lock_combat_range_switch = false

	scratchpad.navigation_extension:set_max_speed(scratchpad.original_movement_speed)

	scratchpad.stagger_component.controlled_stagger = false
	scratchpad.stagger_component.controlled_stagger_finished = true
end

local COLLISION_FILTER = "filter_minion_line_of_sight_check"

BtChaosHoundLeapAction._ray_cast = function (self, physics_world, from, to)
	local to_target = to - from
	local direction = Vector3.normalize(to_target)
	local distance = Vector3.length(to_target)
	local result, hit_position, hit_distance, normal, _ = PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", COLLISION_FILTER)

	return result, hit_position, hit_distance, normal
end

BtChaosHoundLeapAction._set_pounce_cooldown = function (self, blackboard, t)
	local cooldown = Managers.state.difficulty:get_table_entry_by_challenge(MinionDifficultySettings.cooldowns.chaos_hound_pounce)
	local pounce_component = Blackboard.write_component(blackboard, "pounce")
	pounce_component.pounce_cooldown = t + cooldown
end

return BtChaosHoundLeapAction
