require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Attack = require("scripts/utilities/attack/attack")
local AttackIntensity = require("scripts/utilities/attack_intensity")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Catapulted = require("scripts/extension_systems/character_state_machine/character_states/utilities/catapulted")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local GroundImpact = require("scripts/utilities/attack/ground_impact")
local Health = require("scripts/utilities/health")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local NavQueries = require("scripts/utilities/nav_queries")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Trajectory = require("scripts/utilities/trajectory")
local attack_types = AttackSettings.attack_types
local BtChaosSpawnGrabAction = class("BtChaosSpawnGrabAction", "BtNode")

BtChaosSpawnGrabAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
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
	scratchpad.sweep_hit_units_cache = {}

	self:_start_grabbing(unit, scratchpad, action_data, t)
end

BtChaosSpawnGrabAction.init_values = function (self, blackboard)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	behavior_component.grabbed_unit = nil
	behavior_component.wants_to_catapult_grabbed_unit = false
	behavior_component.grab_cooldown = 0
end

BtChaosSpawnGrabAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local grabbed_unit = scratchpad.grabbed_unit
	local cooldown = action_data.cooldown
	scratchpad.behavior_component.grab_cooldown = t + cooldown
	local disabled_state_component = scratchpad.hit_unit_disabled_character_state_component

	if reason ~= "done" and ALIVE[grabbed_unit] then
		local _, disabling_unit = PlayerUnitStatus.is_grabbed(disabled_state_component)

		if disabling_unit == unit then
			local target_locomotion_extension = ScriptUnit.extension(grabbed_unit, "locomotion_system")

			target_locomotion_extension:set_parent_unit(nil)

			local disabled_state_input = scratchpad.hit_unit_disabled_state_input

			if disabled_state_input.disabling_unit == unit then
				disabled_state_input.trigger_animation = "none"
				disabled_state_input.disabling_unit = nil
			end
		end

		scratchpad.behavior_component.grabbed_unit = nil
	elseif reason == "done" and disabled_state_component and unit ~= disabled_state_component.disabling_unit then
		scratchpad.behavior_component.grabbed_unit = nil
	end

	scratchpad.navigation_extension:set_enabled(false)

	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)
	MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)

	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end
end

BtChaosSpawnGrabAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local state = scratchpad.state

	if state == "grabbing" then
		local grabbed_unit = scratchpad.grabbed_unit

		if grabbed_unit and not ALIVE[grabbed_unit] then
			return "done"
		end

		if scratchpad.rotation_duration and t <= scratchpad.rotation_duration then
			self:_rotate_towards_target_unit(unit, scratchpad, action_data)
		end

		local disabled_state_component = scratchpad.hit_unit_disabled_character_state_component

		if disabled_state_component and ALIVE[disabled_state_component.disabling_unit] and disabled_state_component.disabling_unit ~= unit then
			return "done"
		end

		self:_update_grabbing(unit, scratchpad, action_data, t, dt)

		if not scratchpad.grabbed_unit and scratchpad.grab_duration_missed < t then
			return "done"
		elseif scratchpad.grabbed_unit and scratchpad.grab_duration < t then
			self:_check_if_want_to_smash(unit, scratchpad, action_data, t)
		end

		if scratchpad.start_eat_timing and scratchpad.start_eat_timing <= t then
			scratchpad.animation_extension:anim_event(action_data.start_eat_anim)

			scratchpad.start_eat_timing = nil
		end
	elseif state == "smashing" then
		local grabbed_unit = scratchpad.grabbed_unit

		if grabbed_unit and not ALIVE[grabbed_unit] then
			return "done"
		end

		self:_update_smashing(unit, scratchpad, action_data, blackboard, breed, t)

		if scratchpad.smash_duration <= t then
			self:_align_throwing(unit, scratchpad, action_data)

			scratchpad.throw_type = "from_smashing"

			self:_start_throwing_target(unit, scratchpad, action_data, t)
		end
	elseif state == "throwing" then
		self:_update_throwing(unit, scratchpad, action_data, breed, t)
	elseif state == "done" then
		return "done"
	end

	return "running"
end

BtChaosSpawnGrabAction._start_grabbing = function (self, unit, scratchpad, action_data, t)
	scratchpad.state = "grabbing"
	local target_unit = scratchpad.perception_component.target_unit
	local breed_name = ScriptUnit.extension(target_unit, "unit_data_system"):breed().name
	local grab_anim = action_data.grab_anims[breed_name]
	scratchpad.target_unit = target_unit
	scratchpad.grabbed_unit_breed_name = breed_name

	scratchpad.animation_extension:anim_event(grab_anim)

	local total_grab_duration = action_data.total_grab_durations[breed_name]
	scratchpad.total_grab_duration = t + total_grab_duration
	local grab_duration = action_data.grab_durations[breed_name]
	scratchpad.grab_duration = t + grab_duration
	local grab_duration_missed = action_data.grab_durations_missed[breed_name]
	scratchpad.grab_duration_missed = t + grab_duration_missed
	local next_damage_t = action_data.damage_timings[breed_name][1]
	scratchpad.next_damage_t = t + next_damage_t
	scratchpad.damage_timing_index = 1
	scratchpad.initial_grab_timing = t
	scratchpad.grab_timing = t + action_data.grab_timings[breed_name][1]
	scratchpad.grab_stop_timing = t + action_data.grab_timings[breed_name][2]
	local rotation_duration = action_data.rotation_durations[grab_anim]
	scratchpad.rotation_duration = t + rotation_duration
end

BtChaosSpawnGrabAction._update_grabbing = function (self, unit, scratchpad, action_data, t, dt)
	if scratchpad.wants_to_set_eat_timing then
		local hit_unit_disabled_character_state_component = scratchpad.hit_unit_disabled_character_state_component
		local _, disabling_unit = PlayerUnitStatus.is_grabbed(hit_unit_disabled_character_state_component)

		if disabling_unit == unit then
			local extra_timing = 0
			local player_unit_spawn_manager = Managers.state.player_unit_spawn
			local player = player_unit_spawn_manager:owner(scratchpad.grabbed_unit)

			if player and player.remote then
				extra_timing = player:lag_compensation_rewind_s()
			end

			scratchpad.start_eat_timing = t + action_data.start_eat_timings[scratchpad.grabbed_unit_breed_name] - extra_timing
			scratchpad.wants_to_set_eat_timing = nil
		end
	end

	local target_unit = scratchpad.perception_component.target_unit

	if scratchpad.grab_timing and scratchpad.grab_timing <= t and scratchpad.perception_component.has_line_of_sight then
		if scratchpad.grab_stop_timing and scratchpad.grab_stop_timing <= t then
			scratchpad.grab_timing = nil
			scratchpad.grab_stop_timing = nil
		else
			local grab_node_name = action_data.grab_node
			local grab_node = Unit.node(unit, grab_node_name)
			local grab_position = Unit.world_position(unit, grab_node)
			local grab_target_node_name = action_data.grab_target_node
			local grab_target_node = Unit.node(target_unit, grab_target_node_name)
			local grab_target_position = Unit.world_position(target_unit, grab_target_node)
			local distance = Vector3.distance(grab_position, grab_target_position)
			local is_dodging = scratchpad.successful_dodge or Dodge.is_dodging(target_unit)
			local check_radius = is_dodging and action_data.dodge_grab_check_radius or action_data.grab_check_radius

			if check_radius < distance then
				if is_dodging and not scratchpad.successful_dodge then
					local breed = ScriptUnit.extension(unit, "unit_data_system"):breed()

					Dodge.sucessful_dodge(target_unit, unit, attack_types.melee, nil, breed)

					scratchpad.successful_dodge = true
				end

				return
			end

			self:_grab_target(unit, scratchpad.target_unit, scratchpad, action_data, t)

			scratchpad.grab_timing = nil
		end
	end

	if scratchpad.total_grab_duration < t then
		self:_align_throwing(unit, scratchpad, action_data)

		scratchpad.throw_type = "from_eating"

		self:_start_throwing_target(unit, scratchpad, action_data, t)

		return
	end

	if scratchpad.next_damage_t and scratchpad.next_damage_t < t then
		local target = scratchpad.grabbed_unit
		local damage_profile = action_data.eat_damage_profile
		local damage_type = action_data.eat_damage_type[scratchpad.grabbed_unit_breed_name]
		local power_level = Managers.state.difficulty:get_table_entry_by_challenge(action_data.power_level)
		local node = Unit.node(target, "j_head")
		local hit_position = Unit.world_position(target, node)
		local damage, result, damage_efficiency = Attack.execute(target, damage_profile, "power_level", power_level, "hit_world_position", hit_position, "attacking_unit", unit, "attack_type", attack_types.melee, "damage_type", damage_type)
		local attack_direction = Vector3.up()

		ImpactEffect.play(target, nil, damage, damage_type, nil, result, hit_position, nil, attack_direction, unit, nil, nil, nil, damage_efficiency, damage_profile)

		local heal_amount = Managers.state.difficulty:get_table_entry_by_challenge(action_data.heal_amount)
		local heal_type = nil

		Health.add(unit, heal_amount, heal_type)

		local damage_timings = action_data.damage_timings[scratchpad.grabbed_unit_breed_name]
		local damage_index = scratchpad.damage_timing_index + 1

		if damage_index <= #damage_timings then
			local next_damage_t = damage_timings[damage_index]
			scratchpad.next_damage_t = scratchpad.initial_grab_timing + next_damage_t
			scratchpad.damage_timing_index = damage_index
		else
			scratchpad.next_damage_t = nil
		end
	end
end

local BROADPHASE_RESULTS = {}

BtChaosSpawnGrabAction._check_if_want_to_smash = function (self, unit, scratchpad, action_data, t)
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local broadphase_relation = "enemy"
	local target_side_names = side:relation_side_names(broadphase_relation)
	local radius = action_data.check_for_smash_radius
	local from = POSITION_LOOKUP[unit]
	local num_results = broadphase:query(from, radius, BROADPHASE_RESULTS, target_side_names)

	if num_results <= 1 then
		return
	end

	local target_unit = BROADPHASE_RESULTS[num_results]
	scratchpad.smash_target = target_unit

	self:_start_smashing(unit, scratchpad, action_data, t)
end

BtChaosSpawnGrabAction._start_smashing = function (self, unit, scratchpad, action_data, t)
	local grab_unit_name = scratchpad.grabbed_unit_breed_name
	local smash_anim = action_data.smash_anims[grab_unit_name]

	scratchpad.animation_extension:anim_event(smash_anim)

	scratchpad.state = "smashing"
	scratchpad.smash_start_t = t
	scratchpad.smash_index = 1
	scratchpad.smash_anim = smash_anim
	local smash_sweep_start_timings = action_data.smash_sweep_start_timings

	if smash_sweep_start_timings and smash_sweep_start_timings[grab_unit_name] then
		scratchpad.sweep_start_time = t
		scratchpad.start_sweep_t = t + smash_sweep_start_timings[grab_unit_name][1][1]
		scratchpad.stop_sweep_t = t + smash_sweep_start_timings[grab_unit_name][1][2]
	else
		local smash_timings = action_data.smash_timings[grab_unit_name]
		scratchpad.next_smash_t = t + smash_timings[1]
		scratchpad.smash_timings = smash_timings
	end

	scratchpad.smash_duration = t + action_data.smash_durations[grab_unit_name]
	local ground_impact_fx_template = action_data.ground_impact_fx_template

	if ground_impact_fx_template and action_data.sweep_ground_impact_fx_timing[grab_unit_name] then
		local ground_impact_fx_timings = action_data.sweep_ground_impact_fx_timing[grab_unit_name]
		local ground_impact_fx_timing = ground_impact_fx_timings[1]
		scratchpad.sweep_ground_impact_at_t = t + ground_impact_fx_timing
		scratchpad.ground_impact_index = 1
		scratchpad.ground_impact_start_time = t
	end

	local disabled_state_input = scratchpad.hit_unit_disabled_state_input
	disabled_state_input.trigger_animation = "smash"
end

BtChaosSpawnGrabAction._update_smashing = function (self, unit, scratchpad, action_data, blackboard, breed, t)
	local smash_target = scratchpad.smash_target
	local flat_rotation = ALIVE[smash_target] and MinionMovement.rotation_towards_unit_flat(unit, smash_target) or scratchpad.smash_rotation and scratchpad.smash_rotation:unbox()

	if flat_rotation then
		scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)

		if not scratchpad.smash_rotation then
			scratchpad.smash_rotation = QuaternionBox(flat_rotation)
		else
			scratchpad.smash_rotation:store(flat_rotation)
		end
	end

	if scratchpad.sweep_ground_impact_at_t and scratchpad.sweep_ground_impact_at_t <= t then
		local ground_impact_fx_template = action_data.ground_impact_fx_template

		if ground_impact_fx_template then
			GroundImpact.play(unit, scratchpad.physics_world, ground_impact_fx_template)
		end

		local grab_unit_name = scratchpad.grabbed_unit_breed_name
		local ground_impact_fx_timings = action_data.sweep_ground_impact_fx_timing[grab_unit_name]
		local ground_impact_index = scratchpad.ground_impact_index + 1

		if ground_impact_index <= #ground_impact_fx_timings then
			scratchpad.ground_impact_index = ground_impact_index
			local ground_impact_fx_timing = ground_impact_fx_timings[ground_impact_index]
			scratchpad.sweep_ground_impact_at_t = scratchpad.ground_impact_start_time + ground_impact_fx_timing
		else
			scratchpad.sweep_ground_impact_at_t = nil
		end
	end

	if scratchpad.start_sweep_t then
		if scratchpad.start_sweep_t <= t and t < scratchpad.stop_sweep_t then
			local physics_world = scratchpad.physics_world
			local sweep_hit_units_cache = scratchpad.sweep_hit_units_cache
			local attack_event = scratchpad.attack_event
			local target_unit = scratchpad.perception_component.target_unit
			local sweep_node = scratchpad.override_sweep_node or action_data.sweep_node
			local optional_ignore_target_unit = true
			local grab_unit_name = scratchpad.grabbed_unit_breed_name
			local smash_damage_profile = action_data.smash_damage_profile[grab_unit_name]

			MinionAttack.sweep(unit, breed, sweep_node, scratchpad, blackboard, target_unit, action_data, physics_world, sweep_hit_units_cache, smash_damage_profile, nil, attack_event, optional_ignore_target_unit)
		elseif scratchpad.stop_sweep_t and scratchpad.stop_sweep_t <= t then
			local smash_sweep_start_timings = action_data.smash_sweep_start_timings
			local grab_unit_name = scratchpad.grabbed_unit_breed_name
			local smash_timings = smash_sweep_start_timings[grab_unit_name]
			local smash_index = scratchpad.smash_index + 1
			local smash_index_timings = smash_timings[smash_index]
			local sweep_start_time = scratchpad.sweep_start_time

			if smash_index_timings then
				scratchpad.start_sweep_t = sweep_start_time + smash_index_timings[1]
				scratchpad.stop_sweep_t = sweep_start_time + smash_index_timings[2]

				table.clear(scratchpad.sweep_hit_units_cache)

				scratchpad.smash_index = smash_index
			else
				scratchpad.start_sweep_t = nil
				scratchpad.stop_sweep_t = nil
			end
		end
	elseif scratchpad.next_smash_t and scratchpad.next_smash_t <= t then
		local smash_timings = action_data.smash_timings[scratchpad.grabbed_unit_breed_name]
		local index = scratchpad.smash_index + 1

		MinionAttack.melee(unit, breed, scratchpad, blackboard, smash_target, action_data, scratchpad.physics_world)

		if index > #smash_timings then
			scratchpad.next_smash_t = nil

			return
		end

		scratchpad.next_smash_t = scratchpad.smash_start_t + smash_timings[index]
		scratchpad.smash_index = index
	end
end

BtChaosSpawnGrabAction._start_throwing_target = function (self, unit, scratchpad, action_data, t)
	local throw_direction = Quaternion.forward(scratchpad.throw_rotation:unbox())
	local relative_direction_name = "fwd"

	if scratchpad.throw_type == "from_smashing" and scratchpad.grabbed_unit_breed_name ~= "human" then
		local fwd = Quaternion.forward(Unit.local_rotation(unit, 1))
		local right = Vector3.cross(fwd, Vector3.up())
		relative_direction_name = MinionMovement.get_relative_direction_name(right, fwd, throw_direction)
	end

	scratchpad.state = "throwing"
	local throw_anim = action_data.throw_anims[scratchpad.grabbed_unit_breed_name][relative_direction_name]

	scratchpad.animation_extension:anim_event(throw_anim)

	local disabled_state_input = scratchpad.hit_unit_disabled_state_input
	local locomotion_extension = scratchpad.locomotion_extension

	if relative_direction_name ~= "fwd" then
		MinionMovement.set_anim_driven(scratchpad, true)

		local anim_data = action_data.anim_data[throw_anim]
		local rotation_sign = anim_data.sign
		local rotation_radians = anim_data.rad
		local destination = POSITION_LOOKUP[unit] + throw_direction
		local rotation_scale = Animation.calculate_anim_rotation_scale(unit, destination, rotation_sign, rotation_radians)

		locomotion_extension:set_anim_rotation_scale(rotation_scale)

		disabled_state_input.trigger_animation = "throw_" .. relative_direction_name
	else
		disabled_state_input.trigger_animation = "throw"
	end

	scratchpad.throw_direction = Vector3Box(throw_direction)
	local throw_timings = action_data.throw_timing[scratchpad.grabbed_unit_breed_name]

	if type(throw_timings) == "table" then
		scratchpad.throw_at_t = t + throw_timings[scratchpad.throw_type]
	else
		scratchpad.throw_at_t = t + throw_timings
	end

	local throw_durations = action_data.throw_duration[scratchpad.grabbed_unit_breed_name]

	if type(throw_durations) == "table" then
		scratchpad.throw_duration = t + throw_durations[scratchpad.throw_type]
	else
		scratchpad.throw_duration = t + throw_durations
	end

	scratchpad.throw_direction_name = relative_direction_name

	locomotion_extension:set_rotation_speed(action_data.rotation_speed)
end

local UP_POSITION_OFFSET = 1.5
local DOWN_POSITION_OFFSET = 0.5

BtChaosSpawnGrabAction._align_throwing = function (self, unit, scratchpad, action_data)
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

	local throw_rotation = Quaternion.inverse(Unit.local_rotation(unit, 1))
	scratchpad.throw_rotation = QuaternionBox(throw_rotation)
	local navigation_extension = scratchpad.navigation_extension
	local traverse_logic = navigation_extension:traverse_logic()
	local pos = POSITION_LOOKUP[unit] + Quaternion.forward(throw_rotation) * 2
	local fallback_throw_position = NavQueries.position_on_mesh_with_outside_position(scratchpad.nav_world, traverse_logic, pos, 1, 2, 2) or POSITION_LOOKUP[unit]
	scratchpad.fallback_throw_position = Vector3Box(fallback_throw_position)
	local target_unit = scratchpad.grabbed_unit
	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local disabled_character_state_component = target_unit_data_extension:write_component("disabled_character_state")
	disabled_character_state_component.target_drag_position = fallback_throw_position
end

local DISABLING_UNIT_LINK_NODE = "j_lefthand"

BtChaosSpawnGrabAction._update_throwing = function (self, unit, scratchpad, action_data, breed, t)
	local throw_direction = scratchpad.throw_direction:unbox()
	local wanted_rotation = Quaternion.look(throw_direction)
	local throw_direction_name = scratchpad.throw_direction_name
	local locomotion_extension = scratchpad.locomotion_extension

	if throw_direction_name == "fwd" then
		locomotion_extension:set_wanted_rotation(wanted_rotation)
	end

	local target_unit = scratchpad.grabbed_unit

	if scratchpad.throw_at_t and scratchpad.throw_at_t < t then
		scratchpad.throw_at_t = nil
		local hit_unit_disabled_state_input = scratchpad.hit_unit_disabled_state_input
		hit_unit_disabled_state_input.trigger_animation = "none"
		local wants_catapult = not scratchpad.fallback_throw_position
		scratchpad.wants_catapult = wants_catapult

		if wants_catapult then
			local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
			local wanted_node = Unit.node(unit, DISABLING_UNIT_LINK_NODE)
			local teleport_position = Unit.world_position(unit, wanted_node)
			local disabled_character_state_component = target_unit_data_extension:write_component("disabled_character_state")
			disabled_character_state_component.target_drag_position = teleport_position
		end

		scratchpad.wants_catapult = true
	else
		if scratchpad.wants_catapult then
			local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
			local catapult_force = action_data.catapult_force[scratchpad.grabbed_unit_breed_name]
			local catapult_z_force = action_data.catapult_z_force[scratchpad.grabbed_unit_breed_name]
			local direction = Vector3.normalize(throw_direction)
			local velocity = direction * catapult_force
			velocity.z = catapult_z_force
			local catapulted_state_input = target_unit_data_extension:write_component("catapulted_state_input")

			Catapulted.apply(catapulted_state_input, velocity)

			scratchpad.wants_catapult = nil
			scratchpad.behavior_component.grabbed_unit = nil
			local hit_unit_disabled_state_input = scratchpad.hit_unit_disabled_state_input
			hit_unit_disabled_state_input.disabling_unit = nil
		end

		if scratchpad.throw_duration and scratchpad.throw_duration < t then
			MinionMovement.set_anim_driven(scratchpad, false)

			if scratchpad.skip_taunt then
				scratchpad.state = "done"
			else
				local after_throw_taunt_anim_event = Animation.random_event(action_data.after_throw_taunt_anim)

				scratchpad.animation_extension:anim_event(after_throw_taunt_anim_event)

				local after_throw_taunt_duration = action_data.after_throw_taunt_duration
				scratchpad.after_throw_taunt_duration = t + after_throw_taunt_duration
				scratchpad.throw_duration = nil

				self:_add_threat_to_other_targets(unit, breed, scratchpad, scratchpad.grabbed_unit)
			end
		elseif scratchpad.after_throw_taunt_duration and target_unit then
			local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

			locomotion_extension:set_wanted_rotation(flat_rotation)

			if scratchpad.after_throw_taunt_duration <= t then
				scratchpad.state = "done"
			end
		end
	end
end

local ABOVE = 1
local BELOW = 2
local LATERAL = 2
local THROW_TELEPORT_UP_OFFSET_HUMAN = 2.7
local THROW_TELEPORT_UP_OFFSET_OGRYN = 2.15
local MAX_STEPS = 20
local MAX_TIME = 1.25
local THROW_LEFT_OFFSET_HUMAN = 1.65
local THROW_LEFT_OFFSET_OGRYN = 2
local THROW_FWD_OFFSET_HUMAN = 2
local THROW_FWD_OFFSET_OGRYN = 2

BtChaosSpawnGrabAction._test_throw_trajectory = function (self, unit, scratchpad, action_data, test_direction, to)
	local unit_position = POSITION_LOOKUP[unit]
	local is_human = scratchpad.grabbed_unit_breed_name == "human"
	local up = Vector3.up() * (is_human and THROW_TELEPORT_UP_OFFSET_HUMAN or THROW_TELEPORT_UP_OFFSET_OGRYN)
	local left = -Vector3.cross(test_direction, Vector3.up())
	left = is_human and left * THROW_LEFT_OFFSET_HUMAN or left * THROW_LEFT_OFFSET_OGRYN
	to = to + left
	local fwd_offset = Vector3.normalize(test_direction) * (is_human and THROW_FWD_OFFSET_HUMAN or THROW_FWD_OFFSET_OGRYN)
	local from = unit_position + up + left + fwd_offset
	local catapult_force = action_data.catapult_force[scratchpad.grabbed_unit_breed_name]
	local catapult_z_force = action_data.catapult_z_force[scratchpad.grabbed_unit_breed_name]
	local direction = Vector3.normalize(to - from)
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
	local hit, segments, _, hit_position = Trajectory.ballistic_raycast(physics_world, "filter_player_mover", from, velocity, angle, gravity, MAX_STEPS, MAX_TIME)

	if hit then
		local navigation_extension = scratchpad.navigation_extension
		local nav_world = scratchpad.nav_world
		local traverse_logic = navigation_extension:traverse_logic()
		local navmesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, hit_position, ABOVE, BELOW, LATERAL)

		if navmesh_position then
			local new_direction = Vector3.normalize(Vector3.flat(navmesh_position - from))

			return true, new_direction
		else
			return false
		end
	else
		return false
	end
end

BtChaosSpawnGrabAction._grab_target = function (self, unit, target_unit, scratchpad, action_data, t)
	local hit_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local disabled_state_input = hit_unit_data_extension:write_component("disabled_state_input")
	disabled_state_input.wants_disable = true
	disabled_state_input.disabling_unit = unit
	disabled_state_input.disabling_type = "grabbed"
	scratchpad.grabbed_unit = target_unit
	scratchpad.hit_unit_disabled_state_input = disabled_state_input
	local behavior_component = scratchpad.behavior_component
	behavior_component.grabbed_unit = target_unit
	local disabled_character_state_component = hit_unit_data_extension:write_component("disabled_character_state")
	scratchpad.hit_unit_disabled_character_state_component = disabled_character_state_component
	local disabled_character_state_write_component = hit_unit_data_extension:write_component("disabled_character_state")
	local init_target_drag_position = POSITION_LOOKUP[unit]
	disabled_character_state_write_component.target_drag_position = init_target_drag_position

	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	AttackIntensity.add_intensity(target_unit, action_data.attack_intensities)

	local drag_in_anim = action_data.drag_in_anims[scratchpad.grabbed_unit_breed_name]

	scratchpad.animation_extension:anim_event(drag_in_anim)

	scratchpad.wants_to_set_eat_timing = true
end

local DEGREE_RANGE = 360

BtChaosSpawnGrabAction._calculate_randomized_throw_directions = function (self, action_data)
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

BtChaosSpawnGrabAction._add_threat_to_other_targets = function (self, unit, breed, scratchpad, excluded_target)
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

BtChaosSpawnGrabAction._rotate_towards_target_unit = function (self, unit, scratchpad, action_data)
	local target_unit = scratchpad.perception_component.target_unit
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

	if not action_data.dont_rotate_towards_target then
		scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)
	end

	return flat_rotation
end

local COLLISION_FILTER = "filter_minion_shooting_geometry"

BtChaosSpawnGrabAction._ray_cast = function (self, physics_world, from, to)
	local to_target = to - from
	local direction = Vector3.normalize(to_target)
	local distance = Vector3.length(to_target)
	local result, hit_position, hit_distance, normal, _ = PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", COLLISION_FILTER)

	return result, hit_position, hit_distance, normal
end

return BtChaosSpawnGrabAction
