-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_leap_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Attack = require("scripts/utilities/attack/attack")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Catapulted = require("scripts/extension_systems/character_state_machine/character_states/utilities/catapulted")
local ChaosSpawnSettings = require("scripts/settings/monster/chaos_spawn_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local GroundImpact = require("scripts/utilities/attack/ground_impact")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local NavQueries = require("scripts/utilities/nav_queries")
local Push = require("scripts/extension_systems/character_state_machine/character_states/utilities/push")
local Trajectory = require("scripts/utilities/trajectory")
local BtLeapAction = class("BtLeapAction", "BtNode")

BtLeapAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn

	scratchpad.physics_world = spawn_component.physics_world

	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local perception_component = Blackboard.write_component(blackboard, "perception")

	scratchpad.behavior_component = behavior_component
	scratchpad.perception_component = perception_component

	local side_system = Managers.state.extension:system("side_system")

	scratchpad.side_system = side_system

	local broadphase_system = Managers.state.extension:system("broadphase_system")

	if action_data.catapult_or_push_players then
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		scratchpad.enemy_side_names = enemy_side_names
		scratchpad.units_catapulted = {}
		scratchpad.side = side
		scratchpad.broadphase = broadphase_system.broadphase
	end

	scratchpad.broadphase_system = broadphase_system
	scratchpad.pushed_minions = {}
	scratchpad.pushed_enemies = {}

	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	scratchpad.animation_extension = animation_extension
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.nav_world = navigation_extension:nav_world()
	scratchpad.traverse_logic = navigation_extension:traverse_logic()

	MinionPerception.set_target_lock(unit, perception_component, true)

	local start_leap_anim
	local distance = perception_component.target_distance
	local is_shortest_leap = distance <= ChaosSpawnSettings.shortest_leap_distance

	if is_shortest_leap then
		start_leap_anim = action_data.shortest_start_leap_anim_event
	elseif distance <= ChaosSpawnSettings.short_leap_distance then
		start_leap_anim = action_data.short_start_leap_anim_event
	else
		start_leap_anim = action_data.start_leap_anim_event
	end

	animation_extension:anim_event(start_leap_anim)

	scratchpad.start_movement_duration = t + action_data.start_movement_duration[start_leap_anim]
	scratchpad.start_leap_timing = t + action_data.start_leap_timing[start_leap_anim]
	scratchpad.state = "starting_movement"
	behavior_component.move_state = "attacking"
end

BtLeapAction.init_values = function (self, blackboard)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.should_leap = false
end

BtLeapAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local state = scratchpad.state

	if state ~= "starting_movement" and state ~= "setup_leap" then
		local locomotion_extension = scratchpad.locomotion_extension

		locomotion_extension:set_movement_type("snap_to_navmesh")
		locomotion_extension:set_anim_driven(false)
		locomotion_extension:use_lerp_rotation(true)
	end

	MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)

	scratchpad.behavior_component.should_leap = false
end

BtLeapAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local result
	local locomotion_extension = scratchpad.locomotion_extension
	local target_unit = scratchpad.perception_component.target_unit
	local state = scratchpad.state

	if state == "starting_movement" then
		result = self:_update_starting_movement(unit, scratchpad, action_data, dt, t, locomotion_extension, target_unit)
	elseif state == "setup_leap" then
		result = self:_update_setup_leap(unit, scratchpad, action_data, dt, t, locomotion_extension, target_unit)
	elseif state == "leaping" then
		result = self:_update_leaping(unit, scratchpad, action_data, dt, t, locomotion_extension, target_unit)
	elseif state == "falling" then
		result = self:_update_falling(unit, scratchpad, action_data, dt, t, locomotion_extension, target_unit)
	elseif state == "landing" then
		result = self:_update_landing(unit, scratchpad, action_data, t)
	end

	return result
end

BtLeapAction._update_starting_movement = function (self, unit, scratchpad, action_data, dt, t, locomotion_extension, target_unit)
	if not HEALTH_ALIVE[target_unit] then
		return "failed"
	end

	local position, target_position = POSITION_LOOKUP[unit], POSITION_LOOKUP[target_unit]
	local towards_target_position = Vector3.flat(Vector3.normalize(target_position - position))
	local speed = MinionMovement.get_animation_wanted_movement_speed(unit, dt)
	local wanted_velocity = towards_target_position * speed

	locomotion_extension:set_wanted_velocity(wanted_velocity)
	MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
	MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, target_unit)

	local start_movement_duration = scratchpad.start_movement_duration

	if start_movement_duration <= t then
		local success = self:_try_start_leap(unit, scratchpad, action_data, t, position, target_position)

		if not success then
			return "failed"
		end
	end

	return "running"
end

BtLeapAction._try_start_leap = function (self, unit, scratchpad, action_data, t, self_position, target_position)
	scratchpad.start_movement_duration = nil

	local velocity, start_position, start_position_nav_mesh = self:_get_leap_velocity(scratchpad, action_data, self_position, target_position)

	if velocity then
		self:_create_bot_aoe_threats(unit, scratchpad, action_data, target_position)

		scratchpad.leap_velocity = Vector3Box(velocity)
		scratchpad.leap_start_position = Vector3Box(start_position)
		scratchpad.leap_start_position_nav_mesh = Vector3Box(start_position_nav_mesh)
		scratchpad.check_start_position = Vector3Box(self_position)
		scratchpad.check_t = t
		scratchpad.state = "setup_leap"

		return true
	else
		return false
	end
end

local NAV_Z_CORRECTION = 0.1

BtLeapAction._get_leap_velocity = function (self, scratchpad, action_data, self_position, target_position)
	local towards_target_position = Vector3.normalize(target_position - self_position)
	local offset_self_position = self_position + towards_target_position * action_data.start_offset_distance
	local nav_world, traverse_logic = scratchpad.nav_world, scratchpad.traverse_logic
	local nav_mesh_position = NavQueries.position_on_mesh(nav_world, offset_self_position, 1, 1, traverse_logic)

	if not nav_mesh_position then
		return nil, nil
	end

	local raycango = GwNavQueries.raycango(nav_world, self_position, nav_mesh_position, traverse_logic)

	if not raycango then
		return nil, nil
	end

	local offset_target_position = target_position - towards_target_position * ChaosSpawnSettings.offset_in_front_of_target
	local offset_target_position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, offset_target_position, 1, 1, 0.5, 0.1)

	if not offset_target_position_on_navmesh then
		return nil, nil
	end

	local start_position, leap_target_position = nav_mesh_position + Vector3(0, 0, NAV_Z_CORRECTION), offset_target_position_on_navmesh + Vector3(0, 0, NAV_Z_CORRECTION)
	local speed, gravity, acceptable_accuracy = ChaosSpawnSettings.leap_speed, ChaosSpawnSettings.leap_gravity, ChaosSpawnSettings.trajectory_acceptable_accuracy
	local angle_to_hit_target, est_pos = Trajectory.angle_to_hit_moving_target(start_position, leap_target_position, speed, Vector3(0, 0, 0), gravity, acceptable_accuracy)

	if not angle_to_hit_target then
		return nil, nil
	end

	local velocity, time_in_flight = Trajectory.get_trajectory_velocity(start_position, est_pos, gravity, speed, angle_to_hit_target)

	time_in_flight = math.min(time_in_flight, ChaosSpawnSettings.leap_max_time_in_flight)

	local debug
	local num_sections, collision_filter, radius = ChaosSpawnSettings.trajectory_num_sections, ChaosSpawnSettings.trajectory_collision_filter, ChaosSpawnSettings.trajectory_radius
	local trajectory_is_ok = Trajectory.check_trajectory_collisions(scratchpad.physics_world, start_position, est_pos, gravity, speed, angle_to_hit_target, num_sections, collision_filter, time_in_flight, debug, radius)

	if not trajectory_is_ok then
		return nil, nil
	end

	return velocity, start_position, nav_mesh_position
end

BtLeapAction._create_bot_aoe_threats = function (self, unit, scratchpad, action_data, target_position)
	local aoe_bot_threat_size, aoe_bot_threat_duration = action_data.aoe_bot_threat_size:unbox(), action_data.aoe_bot_threat_duration
	local aoe_bot_threat_rotation = Unit.local_rotation(unit, 1)
	local side_system = scratchpad.side_system
	local side = side_system.side_by_unit[unit]
	local enemy_sides = side:relation_sides("enemy")
	local group_system = Managers.state.extension:system("group_system")
	local bot_groups = group_system:bot_groups_from_sides(enemy_sides)
	local num_bot_groups = #bot_groups

	for i = 1, num_bot_groups do
		local bot_group = bot_groups[i]

		bot_group:aoe_threat_created(target_position, "oobb", aoe_bot_threat_size, aoe_bot_threat_rotation, aoe_bot_threat_duration)
	end
end

BtLeapAction._update_setup_leap = function (self, unit, scratchpad, action_data, dt, t, locomotion_extension, target_unit)
	local check_t, start_leap_timing = scratchpad.check_t, scratchpad.start_leap_timing
	local lerp_duration = start_leap_timing - check_t
	local lerp_t

	if lerp_duration > 0 then
		lerp_t = math.min((t - check_t) / lerp_duration, 1)
	else
		lerp_t = 1
	end

	local check_start_position = scratchpad.check_start_position:unbox()
	local leap_start_position_nav_mesh = scratchpad.leap_start_position_nav_mesh:unbox()
	local lerp_position = Vector3.lerp(check_start_position, leap_start_position_nav_mesh, lerp_t)
	local wanted_velocity = (lerp_position - POSITION_LOOKUP[unit]) / dt

	locomotion_extension:set_wanted_velocity(wanted_velocity)
	MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
	MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, target_unit)

	if start_leap_timing <= t then
		scratchpad.start_leap_timing = nil

		self:_leap(scratchpad)
	end

	return "running"
end

BtLeapAction._leap = function (self, scratchpad)
	scratchpad.locomotion_extension:set_movement_type("script_driven")

	scratchpad.state = "leaping"
end

local FALLING_NAV_MESH_ABOVE = 0.5
local FALLING_NAV_MESH_BELOW = 30
local LANDED_DOT_THRESHOLD = math.inverse_sqrt_2

BtLeapAction._update_leaping = function (self, unit, scratchpad, action_data, dt, t, locomotion_extension, target_unit)
	local old_leap_time = scratchpad.leap_time or 0

	scratchpad.leap_time = old_leap_time + dt

	local hit_position, hit_normal, new_position = self:_check_leap_for_collisions(scratchpad, scratchpad.physics_world, old_leap_time, scratchpad.leap_time)

	if hit_position then
		local up_dot = Vector3.dot(hit_normal, Vector3.up())
		local has_landed = up_dot > LANDED_DOT_THRESHOLD

		if has_landed then
			scratchpad.state = "landing"
			scratchpad.start_landing = true
		elseif NavQueries.position_on_mesh(scratchpad.nav_world, new_position, FALLING_NAV_MESH_ABOVE, FALLING_NAV_MESH_BELOW, scratchpad.traverse_logic) then
			scratchpad.state = "falling"
		else
			local attack_direction, damage_profile = Vector3.down(), DamageProfileTemplates.kill_volume_and_off_navmesh
			local health_extension = ScriptUnit.extension(unit, "health_system")
			local last_damaging_unit = health_extension:last_damaging_unit()

			Attack.execute(unit, damage_profile, "instakill", true, "attack_direction", attack_direction, "attacking_unit", last_damaging_unit)
		end
	end

	local current_position = POSITION_LOOKUP[unit]
	local wanted_velocity = (new_position - current_position) / dt

	locomotion_extension:set_wanted_velocity(wanted_velocity)
	MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
	MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, target_unit)

	return "running"
end

BtLeapAction._check_leap_for_collisions = function (self, scratchpad, physics_world, start_t, end_t)
	local leap_velocity = scratchpad.leap_velocity:unbox()
	local leap_start_position = scratchpad.leap_start_position:unbox()
	local to_target = Vector3.normalize(Vector3.flat(leap_velocity))
	local x_vel_0 = Vector3.length(Vector3.flat(leap_velocity))
	local y_vel_0 = leap_velocity.z
	local debug
	local gravity, radius, collision_filter = ChaosSpawnSettings.leap_gravity, ChaosSpawnSettings.trajectory_radius, ChaosSpawnSettings.trajectory_collision_filter
	local hit_position, hit_normal, new_position = Trajectory.sphere_sweep_collision_check(physics_world, leap_start_position, to_target, x_vel_0, y_vel_0, gravity, radius, collision_filter, start_t, end_t, debug)

	return hit_position, hit_normal, new_position
end

BtLeapAction._update_falling = function (self, unit, scratchpad, action_data, dt, t, locomotion_extension, target_unit)
	local current_velocity, gravity = locomotion_extension:current_velocity(), ChaosSpawnSettings.leap_gravity
	local fall_speed = current_velocity.z - gravity * dt
	local current_position, position_on_nav_mesh = POSITION_LOOKUP[unit]

	if fall_speed < 0 then
		local above, below = 0.1, -fall_speed * dt

		position_on_nav_mesh = NavQueries.position_on_mesh(scratchpad.nav_world, current_position, above, below, scratchpad.traverse_logic)
	end

	local wanted_velocity

	if position_on_nav_mesh then
		scratchpad.state = "landing"
		scratchpad.start_landing = true
		wanted_velocity = (position_on_nav_mesh - current_position) / dt
	else
		wanted_velocity = Vector3(0, 0, fall_speed)
	end

	locomotion_extension:set_wanted_velocity(wanted_velocity)
	MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
	MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, target_unit)

	return "running"
end

BtLeapAction._update_landing = function (self, unit, scratchpad, action_data, t)
	if scratchpad.start_landing then
		self:_start_landing(scratchpad, action_data, t)

		scratchpad.start_landing = false
	elseif scratchpad.land_impact_timing and t >= scratchpad.land_impact_timing then
		local ground_impact_fx_template = action_data.land_ground_impact_fx_template

		if ground_impact_fx_template then
			GroundImpact.play(unit, scratchpad.physics_world, ground_impact_fx_template)
		end

		scratchpad.land_impact_timing = nil

		self:_push_or_catapult_players(unit, scratchpad, action_data, t)
	elseif t > scratchpad.landing_duration then
		return "done"
	end

	return "running"
end

BtLeapAction._start_landing = function (self, scratchpad, action_data, t)
	scratchpad.landing_duration = t + action_data.landing_duration

	local land_anim_event = action_data.land_anim_event

	scratchpad.animation_extension:anim_event(land_anim_event)

	local locomotion_extension = scratchpad.locomotion_extension
	local anim_driven, affected_by_gravity = true, false

	locomotion_extension:set_anim_driven(anim_driven, affected_by_gravity)
	locomotion_extension:set_movement_type("snap_to_navmesh")
	locomotion_extension:use_lerp_rotation(false)

	local land_impact_timing = t + action_data.land_impact_timing

	scratchpad.land_impact_timing = land_impact_timing
end

local broadphase_results = {}

BtLeapAction._push_or_catapult_players = function (self, unit, scratchpad, action_data, t)
	local data = action_data.catapult_or_push_players
	local units_catapulted = scratchpad.units_catapulted
	local speed, angle, radius = data.speed, data.angle, data.radius
	local radius_sq = radius * radius
	local side = scratchpad.side
	local valid_enemy_player_units = side.valid_enemy_player_units
	local broadphase = scratchpad.broadphase
	local unit_position = POSITION_LOOKUP[unit]
	local enemy_side_names = scratchpad.enemy_side_names
	local num_results = broadphase.query(broadphase, unit_position, radius, broadphase_results, enemy_side_names)

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
			local breed_name = target_unit_data_extension:breed().name

			if data.catapult_breed_names[breed_name] then
				local catapulted_state_input = target_unit_data_extension:write_component("catapulted_state_input")

				Catapulted.apply(catapulted_state_input, push_velocity)
			else
				local locomotion_push_component = target_unit_data_extension:write_component("locomotion_push")

				Push.add(hit_unit, locomotion_push_component, flat_offset_direction, data.push_template, "push")
			end

			units_catapulted[hit_unit] = hit_unit
		end
	end

	MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
end

return BtLeapAction
