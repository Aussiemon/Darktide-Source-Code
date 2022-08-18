require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local NavQueries = require("scripts/utilities/nav_queries")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Stagger = require("scripts/utilities/attack/stagger")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local attack_types = AttackSettings.attack_types
local BtChargeAction = class("BtChargeAction", "BtNode")

BtChargeAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn
	scratchpad.physics_world = spawn_component.physics_world
	local perception_component = Blackboard.write_component(blackboard, "perception")
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = perception_component
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.broadphase_system = Managers.state.extension:system("broadphase_system")
	scratchpad.side_system = Managers.state.extension:system("side_system")
	scratchpad.pushed_minions = {}

	MinionPerception.set_target_lock(unit, perception_component, true)

	scratchpad.velocity_stored = Vector3Box(0, 0, 0)
	local original_rotation_speed = locomotion_extension:rotation_speed()
	scratchpad.original_rotation_speed = original_rotation_speed
	scratchpad.fx_system = Managers.state.extension:system("fx_system")

	self:_start_buildup(unit, scratchpad, action_data, t)

	if action_data.trigger_move_to_target then
		local target_unit = perception_component.target_unit
		local target_position = POSITION_LOOKUP[target_unit]

		self:_move_to_position(scratchpad, target_position)
	end
end

BtChargeAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)

	if not scratchpad.hit_target then
		locomotion_extension:set_affected_by_gravity(false)
		locomotion_extension:set_movement_type("snap_to_navmesh")
		locomotion_extension:set_mover_displacement(nil)
		locomotion_extension:set_gravity(nil)
		locomotion_extension:set_check_falling(true)
		locomotion_extension:set_anim_driven(false)
	end

	scratchpad.navigation_extension:set_enabled(false)
	MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)

	local global_effect_id = scratchpad.global_effect_id

	if global_effect_id then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(global_effect_id)

		scratchpad.global_effect_id = nil
	end

	scratchpad.behavior_component.move_state = "idle"
end

BtChargeAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	self:_update_ray_can_go(unit, scratchpad)

	local state = scratchpad.state

	if state == "buildup" then
		self:_update_charge_buildup(unit, scratchpad, action_data, t, dt)
	elseif state == "charging" then
		self:_update_charging(unit, scratchpad, action_data, t, dt)
		MinionAttack.push_friendly_minions(unit, scratchpad, action_data)
	elseif state == "navigating" then
		self:_update_navigating(unit, scratchpad, action_data, t)
		MinionAttack.push_friendly_minions(unit, scratchpad, action_data)
	elseif state == "charged_past" then
		local done = self:_update_charged_past(unit, scratchpad, action_data, t, dt)

		if done then
			return "done"
		end

		MinionAttack.push_friendly_minions(unit, scratchpad, action_data)
	elseif state == "attacking" then
		self:_update_attacking(unit, scratchpad, action_data, t, dt)
	elseif state == "done" then
		return "done"
	end

	return "running"
end

BtChargeAction._start_buildup = function (self, unit, scratchpad, action_data, t)
	local navigation_extension = scratchpad.navigation_extension
	local speed = scratchpad.current_charge_speed or action_data.charge_speed_min

	navigation_extension:set_enabled(true, speed)

	scratchpad.state = "buildup"
end

BtChargeAction._start_charging = function (self, unit, scratchpad, action_data, t)
	scratchpad.state = "charging"
	scratchpad.charge_started_at_t = t
	local navigation_extension = scratchpad.navigation_extension

	navigation_extension:set_enabled(false)

	local behavior_component = scratchpad.behavior_component
	behavior_component.move_state = "attacking"
	scratchpad.target_dodged_during_attack = nil
end

BtChargeAction._start_navigating = function (self, scratchpad, action_data, t)
	local navigation_extension = scratchpad.navigation_extension
	local speed = scratchpad.current_charge_speed or action_data.charge_speed_min

	navigation_extension:set_enabled(true, speed)

	scratchpad.state = "navigating"
	scratchpad.min_time_navigating = t + action_data.min_time_navigating

	scratchpad.locomotion_extension:set_rotation_speed(action_data.rotation_speed)

	local behavior_component = scratchpad.behavior_component
	behavior_component.move_state = "moving"
	scratchpad.target_dodged_during_attack = nil
end

BtChargeAction._update_charging = function (self, unit, scratchpad, action_data, t, dt)
	if not scratchpad.navmesh_ray_can_go then
		self:_start_navigating(scratchpad, action_data, t)

		return
	end

	local target_unit = scratchpad.perception_component.target_unit
	local locomotion_extension = scratchpad.locomotion_extension
	local navigation_extension = scratchpad.navigation_extension
	local self_position = POSITION_LOOKUP[unit]
	local charge_started_at_t = scratchpad.charge_started_at_t
	local time_spent_charging = t - charge_started_at_t
	local charge_speed_min = action_data.charge_speed_min
	local charge_speed_max = action_data.charge_speed_max
	local charge_max_speed_at = action_data.charge_max_speed_at
	local charge_scale = time_spent_charging / charge_max_speed_at
	local wanted_charge_speed = math.min(charge_speed_min + charge_scale * (charge_speed_max - charge_speed_min), charge_speed_max)
	local target_velocity = MinionMovement.target_velocity(target_unit)
	local target_position = POSITION_LOOKUP[target_unit]
	local extrapolated_position = target_position + target_velocity * action_data.target_extrapolation_length_scale
	local direction_to_target = Vector3.normalize(Vector3.flat(extrapolated_position - self_position))
	local slowdown_percentage = self:_get_turn_slowdown_percentage(unit, direction_to_target, action_data)
	wanted_charge_speed = wanted_charge_speed * slowdown_percentage

	navigation_extension:set_max_speed(wanted_charge_speed)

	local wanted_direction = Quaternion.forward(Unit.local_rotation(unit, 1))
	local new_velocity = wanted_direction * wanted_charge_speed

	locomotion_extension:set_wanted_velocity(new_velocity)
	scratchpad.velocity_stored:store(new_velocity)

	scratchpad.current_charge_speed = wanted_charge_speed
	local rotation = Quaternion.look(direction_to_target)
	local distance_to_target = Vector3.distance(self_position, extrapolated_position)
	local close_distance = action_data.close_distance

	if distance_to_target < close_distance then
		if not scratchpad.target_dodged_during_attack then
			local is_target_dodging = Dodge.is_dodging(target_unit, attack_types.melee)

			if is_target_dodging then
				scratchpad.target_dodged_during_attack = true
			end
		end

		local rotation_speed = scratchpad.target_dodged_during_attack and action_data.dodge_rotation_speed or action_data.close_rotation_speed

		locomotion_extension:set_rotation_speed(rotation_speed)
		locomotion_extension:set_wanted_rotation(rotation)

		if action_data.min_time_spent_charging <= time_spent_charging then
			local dot = Vector3.dot(wanted_direction, direction_to_target)
			local charged_past_dot = action_data.charged_past_dot

			if dot < charged_past_dot then
				local miss_animation = Animation.random_event(action_data.miss_animations)

				scratchpad.animation_extension:anim_event(miss_animation)

				local miss_duration = action_data.miss_durations[miss_animation]
				scratchpad.charged_past_exit_t = t + miss_duration
				local can_hit_wall_duration = action_data.can_hit_wall_durations[miss_animation]
				scratchpad.can_hit_wall_t = t + can_hit_wall_duration
				scratchpad.state = "charged_past"

				return
			end
		end
	else
		locomotion_extension:set_rotation_speed(action_data.rotation_speed)
		locomotion_extension:set_wanted_rotation(rotation)
	end

	local colliding_unit = self:_check_colliding_players(unit, scratchpad, action_data)

	if colliding_unit then
		self:_hit_target(unit, colliding_unit, scratchpad, action_data, t)
	end

	self:_update_anim_lean_variable(unit, scratchpad, action_data, dt, target_position)
end

local MIN_DISTANCE_FOR_MOVE_TO = 2

BtChargeAction._update_navigating = function (self, unit, scratchpad, action_data, t)
	local can_exit_navigating = not scratchpad.min_time_navigating or scratchpad.min_time_navigating < t

	if can_exit_navigating and scratchpad.navmesh_ray_can_go then
		self:_start_charging(unit, scratchpad, action_data, t)

		scratchpad.min_time_navigating = nil

		return
	end

	local target_unit = scratchpad.perception_component.target_unit
	local target_position = POSITION_LOOKUP[target_unit]
	local navigation_extension = scratchpad.navigation_extension
	local destination = navigation_extension:destination()
	local distance = Vector3.distance(target_position, destination)

	if MIN_DISTANCE_FOR_MOVE_TO < distance then
		self:_move_to_position(scratchpad, target_position)
	end

	local is_following_path = navigation_extension:is_following_path()

	if not is_following_path then
		return
	end

	local wanted_node_index = 4
	local current_node, next_node_in_path = navigation_extension:current_and_wanted_node_position_in_path(wanted_node_index)

	if current_node == nil or next_node_in_path == nil then
		return
	end

	local nav_path_direction = Vector3.normalize(next_node_in_path - current_node)
	local slowdown_percentage = self:_get_turn_slowdown_percentage(unit, nav_path_direction, action_data)
	local max_speed = scratchpad.current_charge_speed or action_data.charge_speed_min
	local new_max_speed = max_speed * slowdown_percentage

	navigation_extension:set_max_speed(new_max_speed)
end

BtChargeAction._update_charged_past = function (self, unit, scratchpad, action_data, t, dt)
	if scratchpad.charged_past_exit_t < t then
		local done = true

		return done
	end

	local charge_direction = Vector3.normalize(scratchpad.velocity_stored:unbox())
	local wanted_speed = MinionMovement.get_animation_wanted_movement_speed(unit, dt, action_data.charge_speed_max)

	scratchpad.locomotion_extension:set_wanted_velocity(charge_direction * wanted_speed)

	local can_hit_wall = t < scratchpad.can_hit_wall_t

	if can_hit_wall then
		local hit_wall, hit_normal = self:_check_wall_collision(unit, scratchpad, action_data)

		if hit_wall then
			local stun_time = action_data.wall_stun_time

			Stagger.force_stagger(unit, StaggerSettings.stagger_types.wall_collision, hit_normal, stun_time, 1, stun_time)
		end
	end
end

local ABOVE = 1
local BELOW = 2
local LATERAL = 3

BtChargeAction._update_ray_can_go = function (self, unit, scratchpad)
	local navigation_extension = scratchpad.navigation_extension
	local nav_world = navigation_extension:nav_world()
	local traverse_logic = navigation_extension:traverse_logic()
	local target_unit = scratchpad.perception_component.target_unit
	local target_position = POSITION_LOOKUP[target_unit]
	local navmesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, target_position, ABOVE, BELOW, LATERAL)

	if navmesh_position then
		local ray_can_go = GwNavQueries.raycango(nav_world, POSITION_LOOKUP[unit], navmesh_position, traverse_logic)
		scratchpad.navmesh_ray_can_go = ray_can_go
	end
end

BtChargeAction._update_attacking = function (self, unit, scratchpad, action_data, t, dt)
	local attack_duration_t = scratchpad.attack_duration_t

	if attack_duration_t < t then
		scratchpad.state = "done"
	end

	local attack_damage_t = scratchpad.attack_damage_t

	if not scratchpad.has_dealt_damage and attack_damage_t < t then
		scratchpad.has_dealt_damage = true
		local hit_target = scratchpad.hit_target
		local damage_profile = action_data.damage_profile
		local damage_type = action_data.damage_type
		local power_level = action_data.power_level
		local unit_position = POSITION_LOOKUP[unit]
		local target_position = POSITION_LOOKUP[hit_target]
		local direction = Vector3.normalize(target_position - unit_position)

		if Vector3.length_squared(direction) == 0 then
			local current_rotation = Unit.local_rotation(unit, 1)
			direction = Quaternion.forward(current_rotation)
		end

		local head_node = Unit.node(unit, "j_head")
		local hit_world_position = Unit.world_position(hit_target, head_node)
		local damage, result, damage_efficiency = Attack.execute(hit_target, damage_profile, "power_level", power_level, "attacking_unit", unit, "attack_type", attack_types.melee, "attack_direction", direction, "hit_world_position", hit_world_position, "damage_type", damage_type, "hit_zone_name", action_data.hit_zone_name)

		ImpactEffect.play(hit_target, nil, damage, damage_type, nil, result, hit_world_position, nil, direction, unit, nil, nil, nil, damage_efficiency, damage_profile)

		local effect_template = action_data.effect_template

		if effect_template then
			local fx_system = scratchpad.fx_system
			local global_effect_id = fx_system:start_template_effect(effect_template, unit)
			scratchpad.global_effect_id = global_effect_id
		end
	end

	local navigation_extension = scratchpad.navigation_extension

	MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
end

BtChargeAction._move_to_position = function (self, scratchpad, target_position)
	local navigation_extension = scratchpad.navigation_extension
	local nav_world = navigation_extension:nav_world()
	local traverse_logic = navigation_extension:traverse_logic()
	local goal_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, target_position, ABOVE, BELOW)

	if goal_position then
		navigation_extension:move_to(goal_position)
	end

	local success = goal_position ~= nil

	return success
end

BtChargeAction._check_wall_collision = function (self, unit, scratchpad, action_data)
	local wall_raycast_node_name = action_data.wall_raycast_node_name
	local wall_raycast_node = Unit.node(unit, wall_raycast_node_name)
	local from = Unit.world_position(unit, wall_raycast_node)
	local physics_world = scratchpad.physics_world
	local wall_raycast_distance = action_data.wall_raycast_distance
	local rotation = Unit.local_rotation(unit, 1)
	local direction = Vector3.flat(Quaternion.forward(rotation))
	local collision_filter = "filter_minion_line_of_sight_check"
	local hit, _, _, normal = PhysicsWorld.raycast(physics_world, from, direction, wall_raycast_distance, "closest", "collision_filter", collision_filter)

	return hit, normal
end

BtChargeAction._check_colliding_players = function (self, unit, scratchpad, action_data)
	local position = POSITION_LOOKUP[unit]
	local physics_world = scratchpad.physics_world
	local radius = action_data.collision_radius
	local hit_actors, actor_count = PhysicsWorld.immediate_overlap(physics_world, "shape", "sphere", "position", position, "size", radius, "types", "dynamics", "collision_filter", "filter_player_detection")

	if actor_count > 0 then
		local hit_actor = hit_actors[1]
		local hit_unit = Actor.unit(hit_actor)
		local target_unit_data_extension = ScriptUnit.extension(hit_unit, "unit_data_system")
		local character_state_component = target_unit_data_extension:read_component("character_state")
		local is_disabled = PlayerUnitStatus.is_disabled(character_state_component)
		local is_enemy = scratchpad.side_system:is_enemy(unit, hit_unit)

		if not is_disabled and is_enemy then
			local target_position = POSITION_LOOKUP[hit_unit]
			local direction = Vector3.normalize(target_position - position)
			local length = Vector3.length_squared(direction)

			if length > 0 then
				local rotation = Unit.world_rotation(unit, 1)
				local forward = Quaternion.forward(rotation)
				local angle = Vector3.angle(direction, forward)
				local collision_angle = action_data.collision_angle

				if angle < collision_angle then
					return hit_unit
				end
			end
		end
	end

	return nil
end

BtChargeAction._hit_target = function (self, unit, hit_unit, scratchpad, action_data, t)
	scratchpad.hit_target = hit_unit
	scratchpad.attack_duration_t = t + action_data.attack_anim_duration
	scratchpad.attack_damage_t = t + action_data.attack_anim_damage_timing
	local attack_anim = action_data.attack_anim

	scratchpad.animation_extension:anim_event(attack_anim)

	scratchpad.state = "attacking"
	local speed = scratchpad.current_charge_speed or action_data.charge_speed_min

	scratchpad.navigation_extension:set_enabled(true, speed)

	local slot_system = Managers.state.extension:system("slot_system")

	slot_system:do_slot_search(unit, true)
end

BtChargeAction._get_turn_slowdown_percentage = function (self, unit, direction, action_data)
	local current_rotation = Unit.local_rotation(unit, 1)
	local forward = Quaternion.forward(current_rotation)
	local dot = Vector3.dot(forward, direction)
	local angle = math.radians_to_degrees(math.acos(dot))
	local min_slowdown_angle = action_data.min_slowdown_angle
	local max_slowdown_angle = action_data.max_slowdown_angle

	if dot > 1 or angle <= min_slowdown_angle then
		return 1
	end

	local slowdown_angle_percentage = math.min((angle - min_slowdown_angle) / max_slowdown_angle, 1)
	local max_slowdown_percentage = action_data.max_slowdown_percentage
	local wanted_slowdown_percentage = 1 - slowdown_angle_percentage * max_slowdown_percentage

	return wanted_slowdown_percentage
end

BtChargeAction._update_charge_buildup = function (self, unit, scratchpad, action_data, t, dt)
	local charge_duration = scratchpad.charge_duration

	if charge_duration and charge_duration < t then
		self:_start_charging(unit, scratchpad, action_data, t)

		return
	end

	local behavior_component = scratchpad.behavior_component
	local navigation_extension = scratchpad.navigation_extension
	local _ = behavior_component.move_state
	local is_following_path = navigation_extension:is_following_path()

	if is_following_path then
		if not scratchpad.started_charge_anim then
			if action_data.charge_direction_anim_events then
				self:_start_charge_direction_anim(unit, scratchpad, action_data, t)
			else
				self:_start_charge_anim(unit, scratchpad, action_data, t)
			end

			scratchpad.started_charge_anim = true
		end

		local start_rotation_timing = scratchpad.start_rotation_timing

		if start_rotation_timing and start_rotation_timing <= t then
			MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
		end

		if not scratchpad.is_anim_driven then
			MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
		end
	end
end

BtChargeAction._start_charge_direction_anim = function (self, unit, scratchpad, action_data, t)
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)
	local charge_direction_anim_events = action_data.charge_direction_anim_events
	local charge_anim_events = charge_direction_anim_events[moving_direction_name]
	local charge_anim = Animation.random_event(charge_anim_events)

	if moving_direction_name ~= "fwd" then
		MinionMovement.set_anim_driven(scratchpad, true)

		local start_move_rotation_timings = action_data.start_move_rotation_timings
		local start_rotation_timing = start_move_rotation_timings[charge_anim]
		scratchpad.start_rotation_timing = t + start_rotation_timing
		scratchpad.move_start_anim_event_name = charge_anim
	else
		scratchpad.start_rotation_timing = nil
		scratchpad.move_start_anim_event_name = nil
	end

	scratchpad.animation_extension:anim_event(charge_anim)

	local charge_direction_durations = action_data.charge_direction_durations
	local charge_duration = charge_direction_durations[charge_anim]
	scratchpad.charge_duration = t + charge_duration
end

BtChargeAction._start_charge_anim = function (self, unit, scratchpad, action_data, t)
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local charge_anim_events = action_data.charge_anim_events
	local charge_anim = Animation.random_event(charge_anim_events)
	scratchpad.start_rotation_timing = nil
	scratchpad.move_start_anim_event_name = nil

	scratchpad.animation_extension:anim_event(charge_anim)

	local charge_durations = action_data.charge_durations
	local charge_duration = charge_durations[charge_anim]
	scratchpad.charge_duration = t + charge_duration
end

BtChargeAction._update_anim_lean_variable = function (self, unit, scratchpad, action_data, dt, target_position)
	local lean_value = MinionMovement.get_lean_animation_variable_value(unit, scratchpad, action_data, dt, target_position)

	if lean_value then
		local lean_variable_name = action_data.lean_variable_name

		scratchpad.animation_extension:set_variable(lean_variable_name, lean_value)
	end
end

return BtChargeAction
