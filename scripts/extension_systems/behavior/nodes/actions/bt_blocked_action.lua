require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionShield = require("scripts/utilities/minion_shield")
local NavQueries = require("scripts/utilities/nav_queries")
local BtBlockedAction = class("BtBlockedAction", "BtNode")
local ROTATION_SPEED = 100

BtBlockedAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn
	scratchpad.physics_world = spawn_component.physics_world
	local anim_events = action_data.blocked_anims
	local block_anim = Animation.random_event(anim_events)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(block_anim)

	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.locomotion_extension = locomotion_extension
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	behavior_component.move_state = "stagger"
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.nav_world = navigation_extension:nav_world()
	scratchpad.original_rotation_speed = locomotion_extension:rotation_speed()
	scratchpad.traverse_logic = navigation_extension:traverse_logic()
	local anim_driven = true
	local script_driven_rotation = false
	local affected_by_gravity = locomotion_extension.movement_type == "constrained_by_mover"
	local velocity = locomotion_extension:current_velocity()
	local override_velocity_z = affected_by_gravity and velocity.z > 0 and 0 or nil

	locomotion_extension:set_anim_driven(anim_driven, affected_by_gravity, script_driven_rotation, override_velocity_z)
	locomotion_extension:set_rotation_speed(ROTATION_SPEED)
	locomotion_extension:set_wanted_velocity(Vector3.zero())
	locomotion_extension:use_lerp_rotation(false)

	local durations = action_data.blocked_duration

	if type(durations) == "table" then
		local blocked_duration = t + durations[block_anim]
		scratchpad.blocked_duration = blocked_duration
	else
		local blocked_duration = t + durations
		scratchpad.blocked_duration = blocked_duration
	end

	MinionShield.init_block_timings(scratchpad, action_data, block_anim, t)
end

BtBlockedAction.init_values = function (self, blackboard)
	local blocked_component = Blackboard.write_component(blackboard, "blocked")
	blocked_component.is_blocked = false
end

BtBlockedAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local original_rotation_speed = scratchpad.original_rotation_speed
	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_anim_driven(false)
	locomotion_extension:set_rotation_speed(original_rotation_speed)
	locomotion_extension:set_wanted_rotation(nil)
	locomotion_extension:set_movement_type("snap_to_navmesh")
	locomotion_extension:set_affected_by_gravity(false)
	locomotion_extension:use_lerp_rotation(true)
	locomotion_extension:set_wanted_velocity(Vector3.zero())
	locomotion_extension:set_anim_translation_scale(Vector3(1, 1, 1))

	local blocked_component = Blackboard.write_component(blackboard, "blocked")
	blocked_component.is_blocked = false

	MinionShield.reset_block_timings(scratchpad, unit)
end

BtBlockedAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
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

	local blocked_duration = scratchpad.blocked_duration

	if blocked_duration < t then
		return "done"
	else
		return "running"
	end
end

return BtBlockedAction
