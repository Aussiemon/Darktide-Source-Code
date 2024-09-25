-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_beast_of_nurgle_consume_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Attack = require("scripts/utilities/attack/attack")
local AttackIntensity = require("scripts/utilities/attack_intensity")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Catapulted = require("scripts/extension_systems/character_state_machine/character_states/utilities/catapulted")
local ChaosBeastOfNurgleSettings = require("scripts/settings/monster/chaos_beast_of_nurgle_settings")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local NavQueries = require("scripts/utilities/nav_queries")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Trajectory = require("scripts/utilities/trajectory")
local Vo = require("scripts/utilities/vo")
local attack_types = AttackSettings.attack_types
local BtBeastOfNurgleConsumeAction = class("BtBeastOfNurgleConsumeAction", "BtNode")

BtBeastOfNurgleConsumeAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
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

	self:_start_consuming(unit, scratchpad, action_data, t)
end

BtBeastOfNurgleConsumeAction.init_values = function (self, blackboard)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.consumed_unit = nil
	behavior_component.melee_cooldown = 0
	behavior_component.melee_aoe_cooldown = 0
	behavior_component.force_spit_out = true
	behavior_component.wants_to_catapult_consumed_unit = false
	behavior_component.vomit_cooldown = 0
	behavior_component.wants_to_eat = false
	behavior_component.consume_cooldown = 0
	behavior_component.wants_to_play_alerted = false
end

BtBeastOfNurgleConsumeAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local consumed_unit = scratchpad.consumed_unit
	local cooldowns = ChaosBeastOfNurgleSettings.cooldowns

	if ALIVE[consumed_unit] then
		local cooldown = cooldowns.consume

		scratchpad.behavior_component.consume_cooldown = t + cooldown
	else
		local cooldown = cooldowns.consume_failed

		scratchpad.behavior_component.consume_cooldown = t + cooldown
	end

	local disabled_state_component = scratchpad.hit_unit_disabled_character_state_component

	if reason ~= "done" and ALIVE[consumed_unit] then
		local _, disabling_unit = PlayerUnitStatus.is_consumed(disabled_state_component)

		if disabling_unit == unit then
			local target_locomotion_extension = ScriptUnit.extension(consumed_unit, "locomotion_system")

			target_locomotion_extension:set_parent_unit(nil)

			local disabled_state_input = scratchpad.hit_unit_disabled_state_input

			if disabled_state_input.disabling_unit == unit then
				disabled_state_input.trigger_animation = "none"
				disabled_state_input.disabling_unit = nil
			end
		end

		scratchpad.behavior_component.consumed_unit = nil
	elseif reason == "done" and disabled_state_component and unit ~= disabled_state_component.disabling_unit then
		scratchpad.behavior_component.consumed_unit = nil
	end

	scratchpad.navigation_extension:set_enabled(false)

	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)
	MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)

	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	scratchpad.behavior_component.force_spit_out = false

	local stagger_component = Blackboard.write_component(blackboard, "stagger")

	stagger_component.count = 0
	stagger_component.num_triggered_staggers = 0
end

BtBeastOfNurgleConsumeAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local state = scratchpad.state

	if state == "consuming" then
		local disabled_state_component = scratchpad.hit_unit_disabled_character_state_component

		if disabled_state_component and ALIVE[disabled_state_component.disabling_unit] and disabled_state_component.disabling_unit ~= unit then
			return "done"
		end

		local done = self:_update_consuming(unit, scratchpad, action_data, t, dt)

		if done then
			return "done"
		end
	elseif state == "throwing" then
		self:_update_throwing(unit, scratchpad, action_data, breed, t)
	elseif state == "done" then
		return "done"
	end

	return "running"
end

BtBeastOfNurgleConsumeAction._start_consuming = function (self, unit, scratchpad, action_data, t)
	scratchpad.state = "consuming"

	local target_unit = scratchpad.perception_component.target_unit
	local breed_name = ScriptUnit.extension(target_unit, "unit_data_system"):breed().name
	local consume_anim = action_data.consume_anims[breed_name]

	scratchpad.target_unit = target_unit
	scratchpad.consumed_unit_breed_name = breed_name

	scratchpad.animation_extension:anim_event(consume_anim)

	local consume_duration = action_data.consume_durations[breed_name]

	scratchpad.consume_duration = t + consume_duration

	local next_damage_t = action_data.damage_timings[breed_name][1]

	scratchpad.next_damage_t = t + next_damage_t
	scratchpad.damage_timing_index = 1
	scratchpad.initial_consume_timing = t
	scratchpad.consume_timing = t + action_data.consume_timing[breed_name]
end

BtBeastOfNurgleConsumeAction._update_consuming = function (self, unit, scratchpad, action_data, t, dt)
	local target_unit = scratchpad.perception_component.target_unit

	if scratchpad.consume_timing and t >= scratchpad.consume_timing then
		local consume_node_name = action_data.consume_node
		local consume_node = Unit.node(unit, consume_node_name)
		local consume_position = Unit.world_position(unit, consume_node)
		local consume_target_node_name = action_data.consume_target_node
		local consume_target_node = Unit.node(target_unit, consume_target_node_name)
		local consume_target_position = Unit.world_position(target_unit, consume_target_node)
		local distance = Vector3.distance(consume_position, consume_target_position)
		local consume_check_radius = action_data.consume_check_radius

		if consume_check_radius < distance then
			return true
		end

		self:_consume_target(unit, scratchpad.target_unit, scratchpad, action_data, t)

		scratchpad.consume_timing = nil
	elseif scratchpad.consume_timing then
		local direction_to_target = Vector3.normalize(POSITION_LOOKUP[target_unit] - POSITION_LOOKUP[unit])

		MinionMovement.update_ground_normal_rotation(unit, scratchpad, direction_to_target)
	end

	if t > scratchpad.consume_duration then
		self:_align_throwing(unit, scratchpad, action_data)

		if action_data.exit_after_consume then
			scratchpad.state = "done"
		else
			self:_start_throwing_target(unit, scratchpad, action_data, t)
		end

		return
	end

	if scratchpad.next_damage_t and t > scratchpad.next_damage_t then
		local target = scratchpad.consumed_unit
		local damage_profile = action_data.damage_profile
		local damage_type = action_data.damage_type[scratchpad.consumed_unit_breed_name]
		local power_level = Managers.state.difficulty:get_table_entry_by_challenge(action_data.power_level)
		local node = Unit.node(target, "j_head")
		local hit_position = Unit.world_position(target, node)
		local damage, result, damage_efficiency = Attack.execute(target, damage_profile, "power_level", power_level, "hit_world_position", hit_position, "attacking_unit", unit, "attack_type", attack_types.melee, "damage_type", damage_type)
		local attack_direction = Vector3.up()

		ImpactEffect.play(target, nil, damage, damage_type, nil, result, hit_position, nil, attack_direction, unit, nil, nil, nil, damage_efficiency, damage_profile)

		local damage_timings = action_data.damage_timings[scratchpad.consumed_unit_breed_name]
		local damage_index = scratchpad.damage_timing_index + 1

		if damage_index <= #damage_timings then
			local next_damage_t = damage_timings[damage_index]

			scratchpad.next_damage_t = scratchpad.initial_consume_timing + next_damage_t
			scratchpad.damage_timing_index = damage_index
		else
			scratchpad.next_damage_t = nil
		end
	end
end

BtBeastOfNurgleConsumeAction._start_throwing_target = function (self, unit, scratchpad, action_data, t)
	local throw_direction = Quaternion.forward(scratchpad.throw_rotation:unbox())
	local fwd = Quaternion.forward(Unit.local_rotation(unit, 1))
	local right = Vector3.cross(fwd, Vector3.up())
	local relative_direction_name = MinionMovement.get_relative_direction_name(right, fwd, throw_direction)

	scratchpad.state = "throwing"

	local throw_anim = action_data.throw_anims[scratchpad.consumed_unit_breed_name][relative_direction_name]

	scratchpad.animation_extension:anim_event(throw_anim)

	local locomotion_extension = scratchpad.locomotion_extension

	if relative_direction_name ~= "fwd" then
		MinionMovement.set_anim_driven(scratchpad, true)

		local anim_data = action_data.anim_data[throw_anim]
		local rotation_sign, rotation_radians = anim_data.sign, anim_data.rad
		local destination = POSITION_LOOKUP[unit] + throw_direction
		local rotation_scale = Animation.calculate_anim_rotation_scale(unit, destination, rotation_sign, rotation_radians)

		locomotion_extension:set_anim_rotation_scale(rotation_scale)
	end

	scratchpad.throw_direction = Vector3Box(throw_direction)
	scratchpad.throw_at_t = t + action_data.throw_timing[scratchpad.consumed_unit_breed_name]
	scratchpad.throw_duration = t + action_data.throw_duration[scratchpad.consumed_unit_breed_name]
	scratchpad.throw_direction_name = relative_direction_name

	locomotion_extension:set_rotation_speed(action_data.rotation_speed)
end

local UP_POSITION_OFFSET = 1.5
local DOWN_POSITION_OFFSET = 0.5

BtBeastOfNurgleConsumeAction._align_throwing = function (self, unit, scratchpad, action_data)
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

BtBeastOfNurgleConsumeAction._update_throwing = function (self, unit, scratchpad, action_data, breed, t)
	local throw_direction = scratchpad.throw_direction:unbox()
	local wanted_rotation = Quaternion.look(throw_direction)
	local throw_direction_name = scratchpad.throw_direction_name
	local locomotion_extension = scratchpad.locomotion_extension

	if throw_direction_name == "fwd" then
		locomotion_extension:set_wanted_rotation(wanted_rotation)
	end

	if scratchpad.throw_at_t and t > scratchpad.throw_at_t then
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

		if scratchpad.throw_duration and t > scratchpad.throw_duration then
			MinionMovement.set_anim_driven(scratchpad, false)

			if scratchpad.skip_taunt then
				scratchpad.state = "done"
			else
				local after_throw_taunt_anim_event = Animation.random_event(action_data.after_throw_taunt_anim)

				scratchpad.animation_extension:anim_event(after_throw_taunt_anim_event)

				local after_throw_taunt_duration = action_data.after_throw_taunt_duration

				scratchpad.after_throw_taunt_duration = t + after_throw_taunt_duration
				scratchpad.throw_duration = nil

				self:_add_threat_to_other_targets(unit, breed, scratchpad, scratchpad.consumed_unit)
			end
		elseif scratchpad.after_throw_taunt_duration then
			local target_unit = scratchpad.consumed_unit

			if target_unit then
				local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

				locomotion_extension:set_wanted_rotation(flat_rotation)

				if t >= scratchpad.after_throw_taunt_duration then
					scratchpad.state = "done"
				end
			end
		end
	end
end

local ABOVE = 1
local BELOW = 2
local LATERAL = 2
local THROW_TELEPORT_UP_OFFSET_HUMAN, THROW_TELEPORT_UP_OFFSET_OGRYN, MAX_STEPS, MAX_TIME = 0.75, 0, 20, 1.25

BtBeastOfNurgleConsumeAction._test_throw_trajectory = function (self, unit, scratchpad, action_data, test_direction, to)
	local unit_position = POSITION_LOOKUP[unit]
	local is_human = scratchpad.consumed_unit_breed_name == "human"
	local up = Vector3.up() * (is_human and THROW_TELEPORT_UP_OFFSET_HUMAN or THROW_TELEPORT_UP_OFFSET_OGRYN)
	local from = unit_position + test_direction + up
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

	local physics_world = scratchpad.physics_world
	local velocity = Trajectory.get_trajectory_velocity(from, estimated_position, gravity, speed, angle)
	local hit, _, _, hit_position = Trajectory.ballistic_raycast(physics_world, "filter_player_mover", from, velocity, angle, gravity, MAX_STEPS, MAX_TIME)

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

BtBeastOfNurgleConsumeAction._consume_target = function (self, unit, target_unit, scratchpad, action_data, t)
	local hit_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local disabled_state_input = hit_unit_data_extension:write_component("disabled_state_input")

	disabled_state_input.wants_disable = true
	disabled_state_input.disabling_unit = unit
	disabled_state_input.disabling_type = "consumed"
	scratchpad.consumed_unit = target_unit
	scratchpad.hit_unit_disabled_state_input = disabled_state_input

	local behavior_component = scratchpad.behavior_component

	behavior_component.consumed_unit = target_unit

	local disabled_character_state_component = hit_unit_data_extension:read_component("disabled_character_state")

	scratchpad.hit_unit_disabled_character_state_component = disabled_character_state_component

	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	AttackIntensity.add_intensity(target_unit, action_data.attack_intensities)

	local drag_in_anim = action_data.drag_in_anims[scratchpad.consumed_unit_breed_name]

	scratchpad.animation_extension:anim_event(drag_in_anim)

	local vo_event = action_data.vo_event

	if vo_event then
		Vo.generic_mission_vo_event_closest_friend(target_unit, vo_event)
	end
end

local DEGREE_RANGE = 360

BtBeastOfNurgleConsumeAction._calculate_randomized_throw_directions = function (self, action_data)
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

BtBeastOfNurgleConsumeAction._add_threat_to_other_targets = function (self, unit, breed, scratchpad, excluded_target)
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

BtBeastOfNurgleConsumeAction._rotate_towards_target_unit = function (self, unit, scratchpad)
	local target_unit = scratchpad.target_unit
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

	scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)

	return flat_rotation
end

local COLLISION_FILTER = "filter_minion_shooting_geometry"

BtBeastOfNurgleConsumeAction._ray_cast = function (self, physics_world, from, to)
	local to_target = to - from
	local direction = Vector3.normalize(to_target)
	local distance = Vector3.length(to_target)
	local result, hit_position, hit_distance, normal, _ = PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", COLLISION_FILTER)

	return result, hit_position, hit_distance, normal
end

return BtBeastOfNurgleConsumeAction
