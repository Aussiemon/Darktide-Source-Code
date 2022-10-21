require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BtExitSpawnerAction = class("BtExitSpawnerAction", "BtNode")
local WANTED_DISTANCE_TO_EXIT_SQ = 0.010000000000000002

BtExitSpawnerAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn
	local spawner_unit = spawn_component.spawner_unit
	local spawner_extension = ScriptUnit.extension(spawner_unit, "minion_spawner_system")
	scratchpad.exit_position = spawner_extension:exit_position_boxed()
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.locomotion_extension = locomotion_extension
	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	local run_anim_event = action_data.run_anim_event

	animation_extension:anim_event(run_anim_event)
	locomotion_extension:set_movement_type("script_driven")
end

BtExitSpawnerAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local spawn_component = Blackboard.write_component(blackboard, "spawn")
	spawn_component.is_exiting_spawner = false
	spawn_component.spawner_unit = nil

	scratchpad.locomotion_extension:set_movement_type("snap_to_navmesh")
end

BtExitSpawnerAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local unit_position = POSITION_LOOKUP[unit]
	local exit_position = scratchpad.exit_position:unbox()
	local exit_vector = exit_position - unit_position
	local distance_to_exit_sq = Vector3.length_squared(exit_vector)

	if WANTED_DISTANCE_TO_EXIT_SQ < distance_to_exit_sq then
		local exit_direction = Vector3.normalize(exit_vector)
		local move_speed = breed.run_speed
		local exit_velocity = exit_direction * move_speed
		local locomotion_extension = scratchpad.locomotion_extension

		locomotion_extension:set_wanted_velocity(exit_velocity)

		return "running"
	else
		return "done"
	end
end

return BtExitSpawnerAction
