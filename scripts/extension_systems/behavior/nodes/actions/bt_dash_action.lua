require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
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
local BtDashAction = class("BtDashAction", "BtNode")

BtDashAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn
	scratchpad.physics_world = spawn_component.physics_world
	scratchpad.hit_targets = {}
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
	local randomized_dash_directions = {}

	self:_calculate_dash_directions(randomized_dash_directions)

	scratchpad.randomized_dash_directions = randomized_dash_directions
	local original_rotation_speed = locomotion_extension:rotation_speed()
	scratchpad.original_rotation_speed = original_rotation_speed
	local num_dashes = action_data.num_dashes

	if num_dashes then
		scratchpad.num_dashes = math.random(num_dashes[1], num_dashes[2])
	end

	scratchpad.fx_system = Managers.state.extension:system("fx_system")

	self:_start_buildup(unit, scratchpad, action_data, t)

	scratchpad.max_duration_t = action_data.max_duration and t + action_data.max_duration
	local target_unit = perception_component.target_unit
	local target_position = POSITION_LOOKUP[target_unit]
	local to_self_from_target = Vector3.normalize(target_position - POSITION_LOOKUP[unit])
	target_position = target_position - to_self_from_target * 0.5

	self:_move_to_position(scratchpad, target_position, action_data)

	local slot_system = Managers.state.extension:system("slot_system")

	slot_system:do_slot_search(unit, false)

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	if breed.combat_range_data then
		behavior_component.lock_combat_range_switch = true
	end
end

BtDashAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)
	locomotion_extension:set_affected_by_gravity(false)
	locomotion_extension:set_movement_type("snap_to_navmesh")
	locomotion_extension:set_mover_displacement(nil)
	locomotion_extension:set_gravity(nil)
	locomotion_extension:set_check_falling(true)
	locomotion_extension:set_anim_driven(false)
	scratchpad.navigation_extension:set_enabled(false)
	MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)

	local global_effect_id = scratchpad.global_effect_id

	if global_effect_id then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(global_effect_id)

		scratchpad.global_effect_id = nil
	end

	scratchpad.behavior_component.move_state = "idle"
	local slot_system = Managers.state.extension:system("slot_system")

	slot_system:do_slot_search(unit, true)

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	if breed.combat_range_data then
		behavior_component.lock_combat_range_switch = false
	end
end

BtDashAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local state = scratchpad.state

	if state == "dashing" or state == "navigating" then
		local target_unit = scratchpad.perception_component.target_unit
		local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
		local target_breed = target_unit_data_extension:breed()

		if Breed.is_player(target_breed) then
			local character_state_component = target_unit_data_extension:read_component("character_state")
			local is_ledge_hanging = PlayerUnitStatus.is_ledge_hanging(character_state_component)

			if is_ledge_hanging then
				return "done"
			end
		end
	end

	if state == "buildup" then
		self:_update_dash_buildup(unit, scratchpad, action_data, t, dt)
	elseif state == "dashing" then
		self:_update_dashing(unit, scratchpad, action_data, t, dt)
		MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)

		local navigation_extension = scratchpad.navigation_extension
		local destination = navigation_extension:destination()
		local unit_position = POSITION_LOOKUP[unit]
		local distance = Vector3.distance(unit_position, destination)

		if distance <= 0.25 then
			self:_start_reached_destination(unit, scratchpad, action_data, t)
		end
	elseif state == "reached_destination" then
		if scratchpad.reached_destination_duration <= t then
			if not scratchpad.num_dashes or scratchpad.num_dashes == 1 then
				return "done"
			else
				scratchpad.num_dashes = scratchpad.num_dashes - 1

				self:_start_buildup(unit, scratchpad, action_data, t)

				local side_system = Managers.state.extension:system("side_system")
				local target_side_id = 1
				local side = side_system:get_side(target_side_id)
				local target_units = side.valid_player_units
				local num_target_units = #target_units
				local optional_target_unit = target_units[math.random(1, num_target_units)]
				local target_position = POSITION_LOOKUP[optional_target_unit]

				if Vector3.distance(target_position, POSITION_LOOKUP[unit]) > 40 then
					local target_unit = scratchpad.perception_component.target_unit
					target_position = POSITION_LOOKUP[target_unit]
				end

				local to_self_from_target = Vector3.normalize(target_position - POSITION_LOOKUP[unit])
				target_position = target_position - to_self_from_target * 0.5

				self:_move_to_position(scratchpad, target_position, action_data)
			end
		else
			local target_unit = scratchpad.perception_component.target_unit
			local target_position = POSITION_LOOKUP[target_unit]

			if not scratchpad.num_dashes then
				local navigation_extension = scratchpad.navigation_extension

				MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
				self:_rotate_towards_target_unit(unit, scratchpad, action_data)
				self:_move_to_position(scratchpad, target_position, action_data)
			else
				local position = POSITION_LOOKUP[unit] + Quaternion.forward(Unit.local_rotation(unit, 1))
				local nav_world = scratchpad.navigation_extension:nav_world()
				local nav_position = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, position, 2, 1, 1)

				if nav_position then
					scratchpad.navigation_extension:move_to(nav_position)
				end

				local navigation_extension = scratchpad.navigation_extension

				MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
			end
		end
	elseif state == "done" then
		return "done"
	end

	if scratchpad.max_duration_t and scratchpad.max_duration_t <= t then
		return "done"
	end

	return "running"
end

BtDashAction._start_buildup = function (self, unit, scratchpad, action_data, t)
	local navigation_extension = scratchpad.navigation_extension
	local speed = action_data.dash_speed

	navigation_extension:set_enabled(true, speed)

	scratchpad.state = "buildup"
	scratchpad.hit_targets = {}
	local behavior_component = scratchpad.behavior_component
	behavior_component.move_state = "moving"
	scratchpad.started_dash_anim = nil
	scratchpad.dash_duration = nil
	local global_effect_id = scratchpad.global_effect_id

	if global_effect_id then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(global_effect_id)

		scratchpad.global_effect_id = nil
	end
end

BtDashAction._start_dashing = function (self, unit, scratchpad, action_data, t)
	scratchpad.state = "dashing"
	scratchpad.dash_started_at_t = t
	local behavior_component = scratchpad.behavior_component
	behavior_component.move_state = "moving"
	scratchpad.target_dodged_during_attack = nil
	local effect_template = action_data.dash_effect_template

	if effect_template then
		local fx_system = scratchpad.fx_system
		local global_effect_id = fx_system:start_template_effect(effect_template, unit)
		scratchpad.global_effect_id = global_effect_id
	end
end

BtDashAction._start_reached_destination = function (self, unit, scratchpad, action_data, t)
	scratchpad.state = "reached_destination"
	local reached_destination_anim_events = action_data.reached_destination_anim_events
	local reached_destination_anim_event = Animation.random_event(reached_destination_anim_events)

	scratchpad.animation_extension:anim_event(reached_destination_anim_event)

	local reached_destination_duration = action_data.reached_destination_durations[reached_destination_anim_event]
	scratchpad.reached_destination_duration = t + reached_destination_duration
	scratchpad.stored_dash_position = nil
end

BtDashAction._update_dashing = function (self, unit, scratchpad, action_data, t, dt)
	local colliding_unit = self:_check_colliding_players(unit, scratchpad, action_data)

	if colliding_unit then
		self:_hit_target(unit, colliding_unit, scratchpad, action_data, t)

		scratchpad.hit_targets[colliding_unit] = true
	end

	local navigation_extension = scratchpad.navigation_extension

	navigation_extension:set_max_speed(action_data.dash_speed)
end

local ABOVE = 1
local BELOW = 2

BtDashAction._move_to_position = function (self, scratchpad, target_position, action_data)
	local navigation_extension = scratchpad.navigation_extension
	local nav_world = navigation_extension:nav_world()
	local traverse_logic = navigation_extension:traverse_logic()
	local random_target_position = action_data.random_target_position
	local goal_position = nil

	if random_target_position then
		goal_position = scratchpad.stored_dash_position and scratchpad.stored_dash_position:unbox() or self:_get_dash_position(target_position, scratchpad, action_data)
	end

	goal_position = goal_position or NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, target_position, ABOVE, BELOW)

	if goal_position then
		navigation_extension:move_to(goal_position)
	end
end

BtDashAction._check_colliding_players = function (self, unit, scratchpad, action_data)
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

		if not is_disabled and is_enemy and not scratchpad.hit_targets[hit_unit] then
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

BtDashAction._hit_target = function (self, unit, hit_unit, scratchpad, action_data, t)
	scratchpad.hit_target = hit_unit

	self:_damage_target(hit_unit, unit, action_data, scratchpad)
end

BtDashAction._rotate_towards_target_unit = function (self, unit, scratchpad, action_data)
	local target_unit = scratchpad.perception_component.target_unit
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

	if not action_data.dont_rotate_towards_target then
		scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)
	end

	return flat_rotation
end

BtDashAction._update_dash_buildup = function (self, unit, scratchpad, action_data, t, dt)
	local dash_duration = scratchpad.dash_duration

	if dash_duration and dash_duration < t then
		self:_start_dashing(unit, scratchpad, action_data, t)

		return
	end

	local behavior_component = scratchpad.behavior_component
	local navigation_extension = scratchpad.navigation_extension
	local _ = behavior_component.move_state
	local is_following_path = navigation_extension:is_following_path()

	if is_following_path then
		if not scratchpad.started_dash_anim then
			if action_data.dash_direction_anim_events then
				self:_start_dash_direction_anim(unit, scratchpad, action_data, t)
			else
				self:_start_dash_anim(unit, scratchpad, action_data, t)
			end

			scratchpad.started_dash_anim = true
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

BtDashAction._start_dash_direction_anim = function (self, unit, scratchpad, action_data, t)
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)
	local dash_direction_anim_events = action_data.dash_direction_anim_events
	local dash_anim_events = dash_direction_anim_events[moving_direction_name]
	local dash_anim = Animation.random_event(dash_anim_events)

	if moving_direction_name ~= "fwd" then
		MinionMovement.set_anim_driven(scratchpad, true)

		local start_move_rotation_timings = action_data.start_move_rotation_timings
		local start_rotation_timing = start_move_rotation_timings[dash_anim]
		scratchpad.start_rotation_timing = t + start_rotation_timing
		scratchpad.move_start_anim_event_name = dash_anim
	else
		scratchpad.start_rotation_timing = nil
		scratchpad.move_start_anim_event_name = nil
	end

	scratchpad.animation_extension:anim_event(dash_anim)

	local dash_direction_durations = action_data.dash_direction_durations
	local dash_duration = dash_direction_durations[dash_anim]
	scratchpad.dash_duration = t + dash_duration
end

BtDashAction._start_dash_anim = function (self, unit, scratchpad, action_data, t)
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local dash_anim_events = action_data.dash_anim_events
	local dash_anim = Animation.random_event(dash_anim_events)
	scratchpad.start_rotation_timing = nil
	scratchpad.move_start_anim_event_name = nil

	scratchpad.animation_extension:anim_event(dash_anim)

	local dash_durations = action_data.dash_durations
	local dash_duration = dash_durations[dash_anim]
	scratchpad.dash_duration = t + dash_duration
end

BtDashAction._damage_target = function (self, hit_target, unit, action_data, scratchpad)
	local damage_profile = action_data.damage_profile
	local damage_type = action_data.damage_type
	local power_level = action_data.power_level
	local unit_position = POSITION_LOOKUP[unit]
	local target_position = POSITION_LOOKUP[hit_target]
	local direction = Vector3.normalize(target_position - unit_position)
	local head_node = Unit.node(hit_target, "j_head")
	local hit_world_position = Unit.world_position(hit_target, head_node)
	local damage, result, damage_efficiency = Attack.execute(hit_target, damage_profile, "power_level", power_level, "attacking_unit", unit, "attack_type", attack_types.melee, "attack_direction", direction, "hit_world_position", hit_world_position, "damage_type", damage_type, "hit_zone_name", action_data.hit_zone_name)

	ImpactEffect.play(hit_target, nil, damage, damage_type, nil, result, hit_world_position, nil, direction, unit, nil, nil, nil, damage_efficiency, damage_profile)
end

local RADIANS_RANGE = math.two_pi
local RADIANS_PER_DIRECTION = math.degrees_to_radians(10)
local NUM_DIRECTIONS = RADIANS_RANGE / RADIANS_PER_DIRECTION

BtDashAction._calculate_dash_directions = function (self, randomized_directions)
	local current_radians = -(RADIANS_RANGE / 2)

	for i = 1, NUM_DIRECTIONS do
		current_radians = current_radians + RADIANS_PER_DIRECTION
		local direction = Vector3(math.sin(current_radians), math.cos(current_radians), 0)
		randomized_directions[i] = Vector3Box(direction)
	end

	table.shuffle(randomized_directions)

	return randomized_directions
end

local RAYCAST_Z_OFFSET = 0.1

BtDashAction._get_dash_position = function (self, target_position, scratchpad, action_data)
	local range = math.random_range(action_data.random_position_distance[1], action_data.random_position_distance[2])
	local randomized_dash_directions = scratchpad.randomized_dash_directions
	local randomized_direction = randomized_dash_directions[math.random(1, #randomized_dash_directions)]:unbox()
	local z_offset = Vector3(0, 0, RAYCAST_Z_OFFSET)
	target_position = target_position + z_offset
	local randomized_position = target_position + randomized_direction * range
	local nav_world = scratchpad.navigation_extension:nav_world()
	local traverse_logic = scratchpad.navigation_extension:traverse_logic()
	randomized_position = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, randomized_position, 2, 1, 1)

	if not randomized_position then
		return
	end

	local ray_can_go = GwNavQueries.raycango(nav_world, target_position, randomized_position, traverse_logic)

	if not ray_can_go then
		return
	end

	return randomized_position
end

return BtDashAction
