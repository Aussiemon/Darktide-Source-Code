require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local MinionMovement = require("scripts/utilities/minion_movement")
local Vo = require("scripts/utilities/vo")
local BtReloadAction = class("BtReloadAction", "BtNode")

BtReloadAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.perception_component = blackboard.perception
	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.animation_extension = animation_extension
	local anim_events = action_data.anim_events
	local anim_event = Animation.random_event(anim_events)

	animation_extension:anim_event(anim_event)

	local anim_durations = action_data.anim_durations
	local duration = anim_durations[anim_event]
	scratchpad.reload_exit_t = t + duration
	local enter_vo_event = action_data.enter_vo_event

	if enter_vo_event then
		Vo.enemy_generic_vo_event(unit, enter_vo_event, breed.name)
	end
end

BtReloadAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local exit_anim_events = action_data.exit_anim_events

	if exit_anim_events then
		local exit_anim_event = Animation.random_event(exit_anim_events)

		scratchpad.animation_extension:anim_event(exit_anim_event)
	end

	if reason == "done" then
		local exit_vo_event = action_data.exit_vo_event

		if exit_vo_event then
			Vo.enemy_generic_vo_event(unit, exit_vo_event, breed.name)
		end
	end
end

BtReloadAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.reload_exit_t and scratchpad.reload_exit_t < t then
		return "done"
	end

	local rotate_towards_target = action_data.rotate_towards_target

	if rotate_towards_target then
		local target_unit = scratchpad.perception_component.target_unit

		if target_unit then
			local locomotion_extension = scratchpad.locomotion_extension

			self:_rotate_towards_target_unit(unit, locomotion_extension, target_unit)
		end
	end

	return "running"
end

BtReloadAction._rotate_towards_target_unit = function (self, unit, locomotion_extension, target_unit)
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

	locomotion_extension:set_wanted_rotation(flat_rotation)
end

return BtReloadAction
