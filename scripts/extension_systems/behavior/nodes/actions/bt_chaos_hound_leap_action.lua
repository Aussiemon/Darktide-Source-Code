require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Block = require("scripts/utilities/attack/block")
local ChaosHoundSettings = require("scripts/settings/specials/chaos_hound_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local GroundImpact = require("scripts/utilities/attack/ground_impact")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local NavQueries = require("scripts/utilities/nav_queries")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Trajectory = require("scripts/utilities/trajectory")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local attack_types = AttackSettings.attack_types
local BtChaosHoundLeapAction = class("BtChaosHoundLeapAction", "BtNode")

BtChaosHoundLeapAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn
	scratchpad.physics_world = spawn_component.physics_world
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local perception_component = Blackboard.write_component(blackboard, "perception")
	local stagger_component = Blackboard.write_component(blackboard, "stagger")
	scratchpad.behavior_component = behavior_component
	scratchpad.perception_component = perception_component
	scratchpad.pounce_component = Blackboard.write_component(blackboard, "pounce")
	scratchpad.stagger_component = stagger_component
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

	local target_unit = perception_component.target_unit
	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	scratchpad.target_action_push_component = target_unit_data_extension:read_component("action_push")
	scratchpad.target_locomotion_component = target_unit_data_extension:read_component("locomotion")
	local target_node_name = ChaosHoundSettings.leap_target_node_name
	local target_node = Unit.node(target_unit, target_node_name)
	scratchpad.target_node = target_node
	scratchpad.target_dodged_during_attack = false
	scratchpad.target_dodged_type = nil
	scratchpad.dodged_attack = false

	if action_data.aoe_bot_threat_timing then
		scratchpad.aoe_bot_threat_timing = t + action_data.aoe_bot_threat_timing
	end

	local start_duration, start_leap_anim = nil
	local target_distance = perception_component.target_distance
	local current_speed = Vector3.length(locomotion_extension:current_velocity())

	if current_speed < ChaosHoundSettings.long_leap_min_speed or target_distance < ChaosHoundSettings.short_distance then
		start_leap_anim = action_data.start_leap_anim_event_short
		start_duration = action_data.start_duration_short
		scratchpad.short_leap = true
	else
		start_leap_anim = action_data.start_leap_anim_event
		start_duration = action_data.start_duration
	end

	scratchpad.start_duration = t + start_duration

	animation_extension:anim_event(start_leap_anim)

	scratchpad.state = "starting"
	behavior_component.move_state = "attacking"
	scratchpad.broadphase_system = Managers.state.extension:system("broadphase_system")
	scratchpad.pushed_minions = {}
	scratchpad.pushed_enemies = {}
	scratchpad.stagger_component.controlled_stagger_finished = true
end

BtChaosHoundLeapAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if not scratchpad.hit_target then
		local locomotion_extension = scratchpad.locomotion_extension

		locomotion_extension:set_movement_type("snap_to_navmesh")

		local original_rotation_speed = scratchpad.original_rotation_speed

		if original_rotation_speed then
			locomotion_extension:set_rotation_speed(original_rotation_speed)
		end

		if reason ~= "done" then
			if scratchpad.is_anim_rotation_driven then
				MinionMovement.set_anim_rotation_driven(scratchpad, false)
			end

			self:_set_pounce_cooldown(scratchpad, t)
		end
	end

	MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)

	scratchpad.pounce_component.started_leap = false
	scratchpad.stagger_component.controlled_stagger_finished = false
end

BtChaosHoundLeapAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit

	if ALIVE[target_unit] and not scratchpad.extra_push_applied then
		local target_is_pushing = scratchpad.target_action_push_component.has_pushed
		local unit_position = POSITION_LOOKUP[unit]
		local target_unit_position = POSITION_LOOKUP[target_unit]

		if target_is_pushing and Vector3.distance_squared(unit_position, target_unit_position) < 25 then
			local damage_profile = action_data.push_enemies_damage_profile
			local power_level = action_data.push_enemies_power_level
			local attack_direction = Vector3.normalize(unit_position - target_unit_position)

			Attack.execute(unit, damage_profile, "power_level", power_level, "attacking_unit", target_unit, "attack_direction", attack_direction, "hit_zone_name", "torso")

			scratchpad.extra_push_applied = true
		end
	end

	local result = nil
	local locomotion_extension = scratchpad.locomotion_extension
	local state = scratchpad.state

	if state == "starting" then
		result = self:_update_starting_state(unit, scratchpad, action_data, dt, t, locomotion_extension, perception_component, target_unit)
	elseif state == "stopping" then
		result = self:_update_stopping_state(scratchpad, t)
	elseif state == "leaping" then
		result = self:_update_leaping_state(unit, scratchpad, action_data, dt, t, breed, locomotion_extension, target_unit)
	elseif state == "in_air_stagger" then
		result = self:_update_in_air_stagger_state(unit, scratchpad, action_data, t)
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

BtChaosHoundLeapAction._update_starting_state = function (self, unit, scratchpad, action_data, dt, t, locomotion_extension, perception_component, target_unit)
	local is_short_leap = scratchpad.short_leap

	self:_update_ground_normal_rotation(unit, target_unit, scratchpad, is_short_leap)
	MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
	MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, target_unit)

	local debug = nil
	local position = POSITION_LOOKUP[unit]
	local current_leap_velocity = nil
	local leap_speed = ChaosHoundSettings.leap_speed
	local leap_relax_distance = ChaosHoundSettings.collision_radius
	local leap_start_position = position + Vector3(0, 0, NAV_Z_CORRECTION)

	if perception_component.has_line_of_sight then
		local target_position = Unit.world_position(target_unit, scratchpad.target_node) + Vector3(0, 0, ChaosHoundSettings.leap_target_z_offset)
		local is_dodging, _ = Dodge.is_dodging(target_unit)
		local target_velocity = is_dodging and Vector3.zero() or scratchpad.target_locomotion_component.velocity_current
		current_leap_velocity = self:_calculate_wanted_velocity(scratchpad.physics_world, leap_start_position, target_position, target_velocity, leap_speed, leap_relax_distance, debug)

		if current_leap_velocity then
			local target_direction = Vector3.normalize(Vector3.flat(target_position - position))
			scratchpad.last_visible_leap_flat_target_direction = scratchpad.last_visible_leap_flat_target_direction or Vector3Box()

			scratchpad.last_visible_leap_flat_target_direction:store(target_direction)

			scratchpad.last_visible_leap_target_position = scratchpad.last_visible_leap_target_position or Vector3Box()

			scratchpad.last_visible_leap_target_position:store(target_position)
		end
	end

	if scratchpad.start_duration <= t then
		scratchpad.start_duration = nil

		if current_leap_velocity == nil and scratchpad.last_visible_leap_target_position then
			local target_position = scratchpad.last_visible_leap_target_position:unbox()
			local target_velocity = Vector3.zero()
			current_leap_velocity = self:_calculate_wanted_velocity(scratchpad.physics_world, leap_start_position, target_position, target_velocity, leap_speed, leap_relax_distance, debug)
		end

		if current_leap_velocity then
			self:_leap(unit, scratchpad, action_data, leap_start_position, current_leap_velocity)
		else
			self:_stop(scratchpad, action_data, t)

			return "running"
		end
	elseif not is_short_leap then
		local wanted_flat_direction = nil

		if current_leap_velocity then
			wanted_flat_direction = Vector3.normalize(Vector3.flat(current_leap_velocity))
		elseif scratchpad.last_visible_leap_flat_target_direction then
			wanted_flat_direction = scratchpad.last_visible_leap_flat_target_direction:unbox()
		else
			local target_position = scratchpad.perception_extension:last_los_position(target_unit) or POSITION_LOOKUP[target_unit]
			wanted_flat_direction = Vector3.normalize(Vector3.flat(target_position - position))
		end

		local wanted_velocity = wanted_flat_direction * action_data.start_move_speed
		local found_position = GwNavQueries.move_on_navmesh(scratchpad.nav_world, position, wanted_velocity, dt, scratchpad.traverse_logic)
		local found_flat_direction = Vector3.normalize(Vector3.flat(found_position - position))
		local dot = Vector3.dot(found_flat_direction, wanted_flat_direction)

		if math.inverse_sqrt_2 < dot then
			locomotion_extension:set_wanted_velocity(wanted_velocity)
		else
			self:_stop(scratchpad, action_data, t)

			return "running"
		end
	end

	if scratchpad.aoe_bot_threat_timing and scratchpad.aoe_bot_threat_timing <= t then
		self:_create_bot_aoe_threats(unit, scratchpad, action_data, target_unit)

		scratchpad.aoe_bot_threat_timing = nil
	end

	return "running"
end

local TO_OFFSET_UP_DISTANCE = 2

BtChaosHoundLeapAction._update_ground_normal_rotation = function (self, unit, target_unit, scratchpad, towards_target)
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

BtChaosHoundLeapAction._ray_cast = function (self, physics_world, from, to)
	local to_target = to - from
	local direction = Vector3.normalize(to_target)
	local distance = Vector3.length(to_target)
	local result, hit_position, hit_distance, normal, _ = PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", COLLISION_FILTER)

	return result, hit_position, hit_distance, normal
end

BtChaosHoundLeapAction._calculate_wanted_velocity = function (self, physics_world, start_position, target_position, target_velocity, speed, optional_relax_distance, debug)
	local gravity = ChaosHoundSettings.leap_gravity
	local acceptable_accuracy = ChaosHoundSettings.leap_acceptable_accuracy
	local angle_to_hit_target, est_pos = Trajectory.angle_to_hit_moving_target(start_position, target_position, speed, target_velocity, gravity, acceptable_accuracy)

	if not angle_to_hit_target then
		return nil
	end

	local velocity, time_in_flight = Trajectory.get_trajectory_velocity(start_position, est_pos, gravity, speed, angle_to_hit_target)
	time_in_flight = math.min(time_in_flight, ChaosHoundSettings.leap_max_time_in_flight)
	local num_sections = ChaosHoundSettings.leap_num_sections
	local collision_filter = ChaosHoundSettings.leap_collision_filter
	local radius = ChaosHoundSettings.leap_radius
	local trajectory_is_ok = Trajectory.check_trajectory_collisions(physics_world, start_position, est_pos, gravity, speed, angle_to_hit_target, num_sections, collision_filter, time_in_flight, debug, radius, optional_relax_distance)

	if not trajectory_is_ok then
		return nil
	end

	return velocity
end

BtChaosHoundLeapAction._leap = function (self, unit, scratchpad, action_data, start_position, leap_velocity)
	local ignore_dot_check = true
	local hit_target = self:_check_colliding_players(unit, scratchpad, action_data, ignore_dot_check)
	scratchpad.init_hit_target = hit_target

	scratchpad.locomotion_extension:set_movement_type("script_driven")

	scratchpad.leap_velocity = Vector3Box(leap_velocity)
	scratchpad.leap_start_position = Vector3Box(start_position)
	scratchpad.pounce_component.started_leap = true
	scratchpad.stagger_component.controlled_stagger_finished = false
	scratchpad.state = "leaping"
end

local LEAP_NODE = "j_head"
local TARGET_LEAP_NODE = "j_spine"

BtChaosHoundLeapAction._check_colliding_players = function (self, unit, scratchpad, action_data, ignore_dot_check)
	local physics_world = scratchpad.physics_world
	local attacking_unit_pos = Unit.world_position(unit, Unit.node(unit, LEAP_NODE))
	local radius = ChaosHoundSettings.collision_radius
	local dodge_radius = ChaosHoundSettings.dodge_collision_radius
	local hit_actors, actor_count = PhysicsWorld.immediate_overlap(physics_world, "shape", "sphere", "position", attacking_unit_pos, "size", radius, "types", "dynamics", "collision_filter", "filter_player_detection")
	local side = scratchpad.side_system.side_by_unit[unit]
	local ai_target_units = side.ai_target_units
	local direction = Quaternion.forward(Unit.world_rotation(unit, 1))

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

			local hit_unit_data_extension = ScriptUnit.extension(hit_unit, "unit_data_system")
			local disabled_character_state_component = hit_unit_data_extension:read_component("disabled_character_state")
			local is_pounced = PlayerUnitStatus.is_pounced(disabled_character_state_component)
			local character_state_component = hit_unit_data_extension:read_component("character_state")
			local is_on_ladder = PlayerUnitStatus.is_climbing_ladder(character_state_component)

			if ai_target_units[hit_unit] and not is_pounced and not is_on_ladder then
				return hit_unit
			end
		until true
	end

	return nil
end

BtChaosHoundLeapAction._stop = function (self, scratchpad, action_data, t)
	scratchpad.animation_extension:anim_event(action_data.stop_anim)

	scratchpad.stop_duration = t + action_data.stop_duration
	scratchpad.state = "stopping"
end

BtChaosHoundLeapAction._create_bot_aoe_threats = function (self, unit, scratchpad, action_data, target_unit)
	local aoe_bot_threat_size = action_data.aoe_bot_threat_size:unbox()
	local aoe_bot_threat_duration = action_data.aoe_bot_threat_duration
	local aoe_bot_threat_rotation = Unit.local_rotation(unit, 1)
	local target_unit_position = POSITION_LOOKUP[target_unit]
	local side_system = scratchpad.side_system
	local side = side_system.side_by_unit[unit]
	local enemy_sides = side:relation_sides("enemy")
	local group_system = Managers.state.extension:system("group_system")
	local bot_groups = group_system:bot_groups_from_sides(enemy_sides)
	local num_bot_groups = #bot_groups

	for i = 1, num_bot_groups do
		local bot_group = bot_groups[i]

		bot_group:aoe_threat_created(target_unit_position, "oobb", aoe_bot_threat_size, aoe_bot_threat_rotation, aoe_bot_threat_duration)
	end
end

BtChaosHoundLeapAction._update_stopping_state = function (self, scratchpad, t)
	if scratchpad.stop_duration < t then
		self:_set_pounce_cooldown(scratchpad, t)

		return "done"
	else
		return "running"
	end
end

BtChaosHoundLeapAction._set_pounce_cooldown = function (self, scratchpad, t)
	local cooldown = Managers.state.difficulty:get_table_entry_by_challenge(MinionDifficultySettings.cooldowns.chaos_hound_pounce)
	scratchpad.pounce_component.pounce_cooldown = t + cooldown
end

local EXTRA_BLOCK_TIMING = 0.1
local LAG_COMPENSATION_CHECK_RADIUS = 3
local MAX_LAG_COMPENSATION = 0.2

BtChaosHoundLeapAction._update_leaping_state = function (self, unit, scratchpad, action_data, dt, t, breed, locomotion_extension, target_unit)
	local target_is_dodging, target_dodge_type = Dodge.is_dodging(target_unit)

	if target_is_dodging and not scratchpad.target_dodged_during_attack then
		scratchpad.target_dodged_during_attack = true
		scratchpad.target_dodged_type = target_dodge_type
	end

	self:_update_in_air_stagger(scratchpad, action_data, t)

	if scratchpad.state == "in_air_stagger" then
		return "running"
	end

	local current_colliding_target = scratchpad.current_colliding_target
	local hit_player_unit = scratchpad.init_hit_target or self:_check_colliding_players(unit, scratchpad, action_data)

	if not scratchpad.dodged_attack and not scratchpad.current_colliding_target_check_time and hit_player_unit then
		local extra_timing = 0
		local player = Managers.state.player_unit_spawn:owner(hit_player_unit)

		if player and player.remote then
			local lag_compensation_rewind = player:lag_compensation_rewind_s() * 0.5
			extra_timing = math.min(lag_compensation_rewind, MAX_LAG_COMPENSATION)
			local hit_unit_data_extension = ScriptUnit.extension(hit_player_unit, "unit_data_system")
			local weapon_action_component = hit_unit_data_extension:read_component("weapon_action")
			local target_weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
			local attack_type = attack_types.melee
			local is_blocking = Block.is_blocking(hit_player_unit, unit, attack_type, target_weapon_template, true)

			if is_blocking then
				extra_timing = extra_timing + EXTRA_BLOCK_TIMING
			end
		end

		scratchpad.current_colliding_target = hit_player_unit
		scratchpad.current_colliding_target_check_time = t + extra_timing
	elseif current_colliding_target then
		if ALIVE[current_colliding_target] then
			local fwd = Quaternion.forward(Unit.local_rotation(unit, 1))
			local position = POSITION_LOOKUP[unit]
			local colliding_target_position = POSITION_LOOKUP[current_colliding_target]
			local to_target = Vector3.normalize(Vector3.flat(colliding_target_position - position))
			local dot = Vector3.dot(fwd, to_target)
			local is_in_front = dot > 0.3

			if scratchpad.current_colliding_target_check_time <= t then
				local target_distance_sq = Vector3.distance_squared(position, colliding_target_position)
				local can_hit = is_in_front and target_distance_sq < LAG_COMPENSATION_CHECK_RADIUS * LAG_COMPENSATION_CHECK_RADIUS

				if can_hit then
					scratchpad.hit_target = true
					scratchpad.pounce_component.pounce_target = current_colliding_target
					scratchpad.stagger_component.controlled_stagger_finished = true

					return "done"
				else
					scratchpad.current_colliding_target_check_time = nil
					scratchpad.current_colliding_target = nil
				end
			end

			local colliding_target_is_dodging, colliding_target_dodge_type = Dodge.is_dodging(current_colliding_target)

			if colliding_target_is_dodging and not is_in_front then
				Dodge.sucessful_dodge(current_colliding_target, unit, "melee", colliding_target_dodge_type, breed)

				scratchpad.dodged_attack = true
				scratchpad.current_colliding_target_check_time = nil
				scratchpad.current_colliding_target = nil
			end
		else
			scratchpad.current_colliding_target_check_time = nil
			scratchpad.current_colliding_target = nil
		end
	elseif ALIVE[target_unit] then
		local current_velocity = locomotion_extension:current_velocity()
		local current_direction = Vector3.normalize(current_velocity)
		local position = POSITION_LOOKUP[unit]
		local target_unit_position = POSITION_LOOKUP[target_unit]
		local to_target = target_unit_position - position
		local direction_to_target = Vector3.normalize(to_target)
		local dot_to_target = Vector3.dot(current_direction, direction_to_target)

		if dot_to_target < 0 and scratchpad.target_dodged_during_attack and not scratchpad.dodged_attack then
			Dodge.sucessful_dodge(target_unit, unit, "melee", scratchpad.target_dodged_type, breed)

			scratchpad.dodged_attack = true
		end
	end

	if not scratchpad.current_colliding_target then
		local old_leap_time = scratchpad.leap_time or 0
		scratchpad.leap_time = old_leap_time + dt
		local leap_start_position = scratchpad.leap_start_position:unbox()
		local leap_velocity = scratchpad.leap_velocity:unbox()

		self:_advance_leap(unit, scratchpad, action_data, locomotion_extension, dt, t, old_leap_time, scratchpad.leap_time, leap_start_position, leap_velocity)
	end

	MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
	MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, target_unit)

	return "running"
end

local FALLING_NAV_MESH_ABOVE = 0.5
local FALLING_NAV_MESH_BELOW = 30
local FALLING_NAV_MESH_LATERAL = 5
local FALLING_NAV_MESH_BORDER_DISTANCE = 0.01
local LANDED_DOT_THRESHOLD = math.inverse_sqrt_2

BtChaosHoundLeapAction._advance_leap = function (self, unit, scratchpad, action_data, locomotion_extension, dt, t, old_leap_time, new_leap_time, leap_start_position, leap_velocity)
	local physics_world = scratchpad.physics_world
	local hit_position, hit_normal, new_position = self:_check_leap_for_collisions(scratchpad, action_data, physics_world, old_leap_time, new_leap_time, leap_start_position, leap_velocity)

	if hit_position then
		local up_dot = Vector3.dot(hit_normal, Vector3.up())
		local has_landed = LANDED_DOT_THRESHOLD < up_dot
		local has_hit_wall = not has_landed and up_dot >= -LANDED_DOT_THRESHOLD
		local nav_world = scratchpad.nav_world
		local traverse_logic = scratchpad.traverse_logic
		local new_wall_jump_velocity = has_hit_wall and self:_calculate_wall_jump_velocity(action_data, physics_world, nav_world, traverse_logic, new_position, hit_normal)

		if has_landed then
			scratchpad.state = "landing"
			scratchpad.start_landing = true
		elseif new_wall_jump_velocity then
			self:_start_wall_jump(scratchpad, action_data, t, hit_normal, new_position, new_wall_jump_velocity)
		elseif NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, new_position, FALLING_NAV_MESH_ABOVE, FALLING_NAV_MESH_BELOW, FALLING_NAV_MESH_LATERAL, FALLING_NAV_MESH_BORDER_DISTANCE) then
			local collision_filter = ChaosHoundSettings.leap_collision_filter
			local hit, hit_pos, _, _, _ = PhysicsWorld.raycast(physics_world, new_position, Vector3.down(), FALLING_NAV_MESH_BELOW, "closest", "collision_filter", collision_filter)
			scratchpad.use_inside_from_outside_z = hit and hit_pos.z or new_position.z
			scratchpad.state = "falling"
		else
			local attack_direction = Vector3.down()
			local damage_profile = DamageProfileTemplates.kill_volume_and_off_navmesh
			local health_extension = ScriptUnit.extension(unit, "health_system")
			local last_damaging_unit = health_extension:last_damaging_unit()

			Attack.execute(unit, damage_profile, "instakill", true, "attack_direction", attack_direction, "attacking_unit", last_damaging_unit)
		end
	end

	local current_position = POSITION_LOOKUP[unit]
	local wanted_velocity = (new_position - current_position) / dt

	locomotion_extension:set_wanted_velocity(wanted_velocity)

	return scratchpad.state
end

BtChaosHoundLeapAction._update_in_air_stagger = function (self, scratchpad, action_data, t)
	local stagger_component = scratchpad.stagger_component

	if not stagger_component.controlled_stagger then
		return
	end

	local locomotion_extension = scratchpad.locomotion_extension

	if not scratchpad.stagger_duration then
		scratchpad.stagger_velocity_magnitude = Vector3.length(locomotion_extension:current_velocity())
		local stagger_anims = action_data.in_air_staggers
		local stagger_anim = Animation.random_event(stagger_anims)

		scratchpad.animation_extension:anim_event(stagger_anim)

		local override_velocity_z = 0

		locomotion_extension:set_affected_by_gravity(true, override_velocity_z)
		locomotion_extension:set_movement_type("constrained_by_mover")

		local durations = action_data.in_air_stagger_duration

		if type(durations) == "table" then
			local duration = durations[stagger_anim]
			scratchpad.stagger_duration = t + duration
		else
			scratchpad.stagger_duration = t + durations
		end

		scratchpad.behavior_component.lock_combat_range_switch = true
		stagger_component.immune_time = 0
		scratchpad.state = "in_air_stagger"
	end

	if scratchpad.stagger_duration < t then
		self:_stop_in_air_stagger(scratchpad)
	else
		local stagger_direction = stagger_component.direction:unbox()
		local magnitude = scratchpad.stagger_velocity_magnitude * 0.5
		local stagger_velocity = Vector3(stagger_direction.x * magnitude, stagger_direction.y * magnitude, 0)

		locomotion_extension:set_wanted_velocity(stagger_velocity)
		locomotion_extension:set_wanted_rotation(Quaternion.look(-Vector3.flat(stagger_direction)))
	end
end

BtChaosHoundLeapAction._stop_in_air_stagger = function (self, scratchpad)
	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_affected_by_gravity(false)
	locomotion_extension:set_movement_type("snap_to_navmesh")

	scratchpad.stagger_duration = nil
	scratchpad.behavior_component.lock_combat_range_switch = false
	local stagger_component = scratchpad.stagger_component
	stagger_component.controlled_stagger = false
	stagger_component.controlled_stagger_finished = true
end

BtChaosHoundLeapAction._check_leap_for_collisions = function (self, scratchpad, action_data, physics_world, start_t, end_t, leap_start_position, leap_velocity)
	local to_target = Vector3.normalize(Vector3.flat(leap_velocity))
	local x_vel_0 = Vector3.length(Vector3.flat(leap_velocity))
	local y_vel_0 = leap_velocity.z
	local debug = nil
	local collision_filter = ChaosHoundSettings.leap_collision_filter
	local gravity = ChaosHoundSettings.leap_gravity
	local radius = ChaosHoundSettings.leap_radius
	local hit_position, hit_normal, new_position = Trajectory.sphere_sweep_collision_check(physics_world, leap_start_position, to_target, x_vel_0, y_vel_0, gravity, radius, collision_filter, start_t, end_t, debug)

	return hit_position, hit_normal, new_position
end

local EPSILON = 0.01
local WALL_JUMP_NAV_ABOVE = 1
local WALL_JUMP_NAV_BELOW = 5
local WALL_JUMP_NAV_LATERAL = 1

BtChaosHoundLeapAction._calculate_wall_jump_velocity = function (self, action_data, physics_world, nav_world, traverse_logic, position, wall_normal)
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
	local up = Quaternion.up(rotation)
	local unobstructed_height = action_data.wall_jump_unobstructed_height
	local collision_filter = ChaosHoundSettings.leap_collision_filter
	local hit_up = PhysicsWorld.raycast(physics_world, position, up, unobstructed_height, "any", "collision_filter", collision_filter)

	if hit_up then
		return nil
	end

	local up_position = position + up * unobstructed_height
	local forward = Quaternion.forward(rotation)
	local forward_length = ChaosHoundSettings.leap_radius + EPSILON
	local hit_forward = PhysicsWorld.raycast(physics_world, up_position, forward, forward_length, "any", "collision_filter", collision_filter)

	if not hit_forward then
		return nil
	end

	local debug = nil
	local wall_jump_target_position = nav_mesh_position + Vector3(0, 0, NAV_Z_CORRECTION)
	local jump_speed = action_data.wall_jump_speed
	local wall_jump_velocity = self:_calculate_wanted_velocity(physics_world, position, wall_jump_target_position, Vector3.zero(), jump_speed, nil, debug)

	return wall_jump_velocity
end

BtChaosHoundLeapAction._start_wall_jump = function (self, scratchpad, action_data, t, wall_normal, wall_jump_start_position, wall_jump_velocity)
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

	scratchpad.stagger_component.controlled_stagger_finished = true
	scratchpad.state = "wall_jump"
end

BtChaosHoundLeapAction._update_in_air_stagger_state = function (self, unit, scratchpad, action_data, t)
	self:_update_in_air_stagger(scratchpad, action_data, t)

	local mover = Unit.mover(unit)

	if mover and Mover.collides_down(mover) then
		self:_stop_in_air_stagger(scratchpad)
		self:_start_landing(scratchpad, action_data, t)
	end

	return "running"
end

BtChaosHoundLeapAction._start_landing = function (self, scratchpad, action_data, t)
	scratchpad.state = "landing"
	scratchpad.landing_duration = t + (scratchpad.land_duration or action_data.landing_duration)
	local land_anim_event = scratchpad.land_anim_event or action_data.land_anim_event

	scratchpad.animation_extension:anim_event(land_anim_event)

	local locomotion_extension = scratchpad.locomotion_extension
	local anim_driven = true
	local affected_by_gravity = false

	locomotion_extension:set_anim_driven(anim_driven, affected_by_gravity)
	locomotion_extension:set_movement_type("snap_to_navmesh")
	locomotion_extension:use_lerp_rotation(false)

	local land_impact_timing = t + action_data.land_impact_timing
	scratchpad.land_impact_timing = land_impact_timing
	scratchpad.stagger_component.controlled_stagger_finished = true
end

BtChaosHoundLeapAction._update_wall_jump_state = function (self, unit, scratchpad, action_data, dt, t, locomotion_extension, target_unit)
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
	local wall_jump_start_position = scratchpad.wall_jump_start_position:unbox()
	local wall_jump_velocity = scratchpad.wall_jump_velocity:unbox()
	local new_state = self:_advance_leap(unit, scratchpad, action_data, locomotion_extension, dt, t, old_wall_jump_time, scratchpad.wall_jump_time, wall_jump_start_position, wall_jump_velocity)

	MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
	MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, target_unit)

	if new_state == "landing" then
		scratchpad.land_anim_event = action_data.wall_land_anim_event
		scratchpad.land_duration = action_data.wall_land_duration
	end

	return "running"
end

BtChaosHoundLeapAction._update_falling_state = function (self, unit, scratchpad, action_data, dt, t, locomotion_extension, target_unit)
	local current_velocity = locomotion_extension:current_velocity()
	local gravity = ChaosHoundSettings.leap_gravity
	local fall_speed = current_velocity.z - gravity * dt
	local current_position = POSITION_LOOKUP[unit]
	local landing_position = nil

	if fall_speed < 0 then
		local above = 0.1
		local below = -fall_speed * dt
		local nav_world = scratchpad.nav_world
		local traverse_logic = scratchpad.traverse_logic

		if scratchpad.use_inside_from_outside_z >= current_position.z - below then
			local nav_mesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, current_position, above, below, FALLING_NAV_MESH_LATERAL, FALLING_NAV_MESH_BORDER_DISTANCE)

			if nav_mesh_position then
				landing_position = Vector3(current_position.x, current_position.y, nav_mesh_position.z)
			end
		else
			landing_position = NavQueries.position_on_mesh(nav_world, current_position, above, below, traverse_logic)
		end
	end

	local wanted_velocity = nil

	if landing_position then
		scratchpad.state = "landing"
		scratchpad.start_landing = true
		wanted_velocity = (landing_position - current_position) / dt
	else
		wanted_velocity = Vector3(0, 0, fall_speed)
	end

	locomotion_extension:set_wanted_velocity(wanted_velocity)
	MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
	MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, target_unit)

	return "running"
end

BtChaosHoundLeapAction._update_landing_state = function (self, unit, scratchpad, action_data, t, locomotion_extension)
	if scratchpad.start_landing then
		self:_start_landing(scratchpad, action_data, t)

		scratchpad.start_landing = false
	elseif scratchpad.land_impact_timing and scratchpad.land_impact_timing <= t then
		local ground_impact_fx_template = action_data.land_ground_impact_fx_template

		if ground_impact_fx_template then
			GroundImpact.play(unit, scratchpad.physics_world, ground_impact_fx_template)
		end

		scratchpad.land_impact_timing = nil
	elseif scratchpad.landing_duration < t then
		locomotion_extension:set_anim_driven(false)
		locomotion_extension:use_lerp_rotation(true)
		self:_set_pounce_cooldown(scratchpad, t)

		return "done"
	end

	return "running"
end

return BtChaosHoundLeapAction
