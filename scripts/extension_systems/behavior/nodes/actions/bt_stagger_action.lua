require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionShield = require("scripts/utilities/minion_shield")
local NavQueries = require("scripts/utilities/nav_queries")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local DEFAULT_IN_AIR_MOVER_CHECK_RADIUS = 0.35
local ROTATION_SPEED = 100
local BtStaggerAction = class("BtStaggerAction", "BtNode")
local BASE_LAYER_EMPTY_EVENT = "base_layer_to_empty"
local IMPACT_HIT_MASS_MODIFIERS = {
	0.9,
	0.75,
	0.5
}

BtStaggerAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local stagger_component = blackboard.stagger
	local num_triggered_staggers = stagger_component.num_triggered_staggers
	scratchpad.current_triggered_stagger = num_triggered_staggers
	local spawn_component = blackboard.spawn
	scratchpad.physics_world = spawn_component.physics_world
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local was_already_in_stagger = num_triggered_staggers > 1 and behavior_component.move_state == "stagger"

	if not was_already_in_stagger then
		local overlap_radius = DEFAULT_IN_AIR_MOVER_CHECK_RADIUS
		local overlap_pos = POSITION_LOOKUP[unit]
		local overlap_size = Vector3(overlap_radius, 1, overlap_radius)
		local overlap_rotation = Quaternion.look(Vector3.down(), Vector3.forward())
		local _, actor_count = PhysicsWorld.immediate_overlap(scratchpad.physics_world, "position", overlap_pos, "rotation", overlap_rotation, "size", overlap_size, "shape", "capsule", "types", "both", "collision_filter", "filter_minion_mover")

		if actor_count == 0 then
			local override_mover_move_distance = breed.override_mover_move_distance

			locomotion_extension:set_movement_type("constrained_by_mover", override_mover_move_distance)
		end

		if not scratchpad.original_rotation_speed then
			scratchpad.original_rotation_speed = locomotion_extension:rotation_speed()
		end
	end

	local stagger_impact_comparison = StaggerSettings.stagger_impact_comparison
	local current_stagger_type = stagger_component.type
	local current_stagger_impact = stagger_impact_comparison[current_stagger_type]

	if current_stagger_impact then
		local hit_mass_modifier = IMPACT_HIT_MASS_MODIFIERS[math.min(current_stagger_impact, #IMPACT_HIT_MASS_MODIFIERS)]

		if not scratchpad.current_hit_mass_modifier then
			local health_extension = ScriptUnit.extension(unit, "health_system")
			local current_hit_mass = health_extension:hit_mass()
			scratchpad.original_hit_mass = current_hit_mass
			scratchpad.current_hit_mass_modifier = hit_mass_modifier

			health_extension:set_hit_mass(current_hit_mass * hit_mass_modifier)
		elseif hit_mass_modifier < scratchpad.current_hit_mass_modifier then
			local health_extension = ScriptUnit.extension(unit, "health_system")

			health_extension:set_hit_mass(scratchpad.original_hit_mass * hit_mass_modifier)
		end
	end

	behavior_component.move_state = "stagger"
	scratchpad.behavior_component = behavior_component
	local stagger_type = stagger_component.type
	local stagger_anims = action_data.stagger_anims[stagger_type]
	local stagger_direction = stagger_component.direction:unbox()
	local stagger_anim, stagger_rotation = self:_select_stagger_anim_and_rotation(unit, stagger_direction, stagger_anims, blackboard, action_data)

	Unit.set_local_rotation(unit, 1, stagger_rotation)

	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(BASE_LAYER_EMPTY_EVENT)
	animation_extension:anim_event(stagger_anim)

	scratchpad.animation_extension = animation_extension
	local scale = stagger_component.length

	locomotion_extension:set_anim_translation_scale(Vector3(scale, scale, scale))

	if not was_already_in_stagger then
		scratchpad.set_anim_driven = true
	end

	locomotion_extension:set_rotation_speed(ROTATION_SPEED)
	locomotion_extension:use_lerp_rotation(false)

	scratchpad.locomotion_extension = locomotion_extension
	local stagger_anim_duration = breed.stagger_durations[stagger_type]
	local stagger_duration = stagger_component.duration
	local anim_duration_mod = action_data.stagger_duration_mods and action_data.stagger_duration_mods[stagger_anim] or 1

	if action_data.ignore_extra_stagger_duration then
		stagger_duration = stagger_anim_duration
		scratchpad.stagger_anim_duration = t + stagger_anim_duration
	elseif stagger_anim_duration < stagger_duration then
		scratchpad.stagger_anim_duration = t + stagger_anim_duration * anim_duration_mod
	end

	scratchpad.stagger_time = t + stagger_duration * anim_duration_mod
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.nav_world = navigation_extension:nav_world()
	scratchpad.traverse_logic = navigation_extension:traverse_logic()
	scratchpad.stagger_hit_wall = nil

	MinionShield.init_block_timings(scratchpad, action_data, stagger_anim, t)
end

BtStaggerAction.init_values = function (self, blackboard)
	local stagger_component = Blackboard.write_component(blackboard, "stagger")
	stagger_component.type = ""
	stagger_component.length = 0

	stagger_component.direction:store(0, 0, 0)

	stagger_component.count = 0
	stagger_component.duration = 0
	stagger_component.immune_time = 0
	stagger_component.num_triggered_staggers = 0
	stagger_component.controlled_stagger = false
	stagger_component.stagger_strength_multiplier = 0
	stagger_component.stagger_strength_pool = 0
	stagger_component.stagger_pool_last_modified = 0
	stagger_component.attacker_unit = nil
	stagger_component.controlled_stagger_finished = false
end

BtStaggerAction._select_stagger_anim_and_rotation = function (self, unit, impact_vector, stagger_anims, blackboard, action_data)
	local impact_direction = Vector3.normalize(impact_vector)
	local my_fwd = Vector3.normalize(Quaternion.forward(Unit.local_rotation(unit, 1)))
	local angle = Vector3.angle(my_fwd, impact_direction)
	local impact_rot, anim_table = nil

	if impact_vector.z == -1 and stagger_anims.dwn then
		impact_direction.z = 0
		impact_rot = Quaternion.look(-impact_direction)
		anim_table = stagger_anims.dwn
	else
		impact_direction.z = 0

		if angle > math.pi * 0.75 then
			impact_rot = Quaternion.look(-impact_direction)
			anim_table = stagger_anims.bwd
		elseif angle < math.pi * 0.25 then
			impact_rot = Quaternion.look(impact_direction)
			anim_table = stagger_anims.fwd
		elseif Vector3.cross(my_fwd, impact_direction).z > 0 then
			local dir = Vector3.cross(Vector3(0, 0, -1), impact_direction)
			impact_rot = Quaternion.look(dir)
			anim_table = stagger_anims.left
		else
			local dir = Vector3.cross(Vector3(0, 0, 1), impact_direction)
			impact_rot = Quaternion.look(dir)
			anim_table = stagger_anims.right
		end
	end

	local stagger_anim = Animation.random_event(anim_table)

	if action_data.towards_impact_vector_rotation_overrides and action_data.towards_impact_vector_rotation_overrides then
		local yaw = Quaternion.yaw(Quaternion.look(-impact_direction))
		local final_rotation = Quaternion(Vector3.up(), yaw)

		return stagger_anim, final_rotation
	end

	local yaw = Quaternion.yaw(impact_rot)
	local final_rotation = Quaternion(Vector3.up(), yaw)

	return stagger_anim, final_rotation
end

BtStaggerAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local original_rotation_speed = scratchpad.original_rotation_speed
	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_anim_driven(false)
	locomotion_extension:set_rotation_speed(original_rotation_speed)
	locomotion_extension:set_wanted_rotation(nil)
	locomotion_extension:set_movement_type("snap_to_navmesh")
	locomotion_extension:set_affected_by_gravity(false)
	locomotion_extension:use_lerp_rotation(true)
	locomotion_extension:set_anim_translation_scale(Vector3(1, 1, 1))

	local death_component = blackboard.death
	local has_force_instant_ragdoll = death_component.force_instant_ragdoll

	if not has_force_instant_ragdoll then
		scratchpad.animation_extension:anim_event("stagger_finished")
	end

	local stagger_component = Blackboard.write_component(blackboard, "stagger")
	stagger_component.count = 0
	stagger_component.num_triggered_staggers = 0
	stagger_component.type = ""

	MinionShield.reset_block_timings(scratchpad, unit)

	local health_extension = ScriptUnit.extension(unit, "health_system")

	health_extension:set_hit_mass(scratchpad.original_hit_mass)
end

BtStaggerAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local stagger_component = blackboard.stagger
	local num_triggered_staggers = stagger_component.num_triggered_staggers

	if scratchpad.start_anim_driven then
		scratchpad.start_anim_driven = nil
		local locomotion_extension = scratchpad.locomotion_extension
		local anim_driven = true
		local script_driven_rotation = false
		local affected_by_gravity = locomotion_extension.movement_type == "constrained_by_mover"
		local velocity = locomotion_extension:current_velocity()
		local override_velocity_z = affected_by_gravity and velocity.z > 0 and 0 or nil

		locomotion_extension:set_anim_driven(anim_driven, affected_by_gravity, script_driven_rotation, override_velocity_z)
	elseif scratchpad.set_anim_driven then
		scratchpad.set_anim_driven = nil
		scratchpad.start_anim_driven = true
	end

	if num_triggered_staggers ~= scratchpad.current_triggered_stagger then
		MinionShield.reset_block_timings(scratchpad, unit)
		self:enter(unit, breed, blackboard, scratchpad, action_data, t)

		scratchpad.start_anim_driven = nil
	end

	local locomotion_extension = scratchpad.locomotion_extension

	if locomotion_extension.movement_type ~= "constrained_by_mover" and not scratchpad.stagger_hit_wall then
		local position = POSITION_LOOKUP[unit]
		local velocity = locomotion_extension:current_velocity()
		local result = NavQueries.movement_check(scratchpad.nav_world, scratchpad.physics_world, position, velocity, scratchpad.traverse_logic)

		if result == "navmesh_hit_wall" then
			scratchpad.stagger_hit_wall = true
		elseif result == "navmesh_use_mover" then
			local mover_move_distance = breed.override_mover_move_distance
			local ignore_forced_mover_kill = true
			local successful = locomotion_extension:set_movement_type("constrained_by_mover", mover_move_distance, ignore_forced_mover_kill)
			local override_velocity_z = velocity.z > 0 and 0 or nil

			locomotion_extension:set_affected_by_gravity(true, override_velocity_z)

			if not successful then
				locomotion_extension:set_movement_type("snap_to_navmesh")

				scratchpad.stagger_hit_wall = true
			end
		end
	end

	MinionShield.update_block_timings(scratchpad, unit, t)

	local stagger_time_finished = scratchpad.stagger_time < t

	if stagger_time_finished then
		return "done"
	end

	local stagger_anim_duration = scratchpad.stagger_anim_duration
	local stagger_anim_finished = stagger_anim_duration and stagger_anim_duration < t

	if stagger_anim_finished then
		scratchpad.animation_extension:anim_event("idle")

		scratchpad.behavior_component.move_state = "idle"
		scratchpad.stagger_anim_duration = nil
	end

	return "running"
end

return BtStaggerAction
