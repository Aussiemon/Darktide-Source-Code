-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_wizard_idle_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local Vo = require("scripts/utilities/vo")
local BtWizardIdleAction = class("BtWizardIdleAction", "BtNode")

BtWizardIdleAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	if behavior_component.move_state ~= "idle" then
		local is_enraged = blackboard.abilites.is_enraged
		local events = action_data.anim_events

		if is_enraged then
			events = action_data.enraged_anim_events
		end

		local event = Animation.random_event(events)
		local animation_extension = ScriptUnit.has_extension(unit, "animation_system") and ScriptUnit.extension(unit, "animation_system")

		if animation_extension then
			animation_extension:anim_event(event)
		end

		behavior_component.move_state = "idle"
	end

	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	if ScriptUnit.has_extension(unit, "perception_system") then
		local perception_component = blackboard.perception

		scratchpad.perception_component = perception_component
		scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")

		local vo_event = action_data.vo_event

		if vo_event and perception_component.aggro_state == "passive" then
			Vo.enemy_vo_event(unit, vo_event)
		end
	end
end

BtWizardIdleAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	self:_rotate_towards_target(unit, breed, blackboard, scratchpad, action_data, dt, t)

	return "running"
end

BtWizardIdleAction._rotate_towards_target = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local flat_rotation
	local look_at_position = blackboard.abilites.default_look_at_position:unbox()

	if look_at_position then
		local position = POSITION_LOOKUP[unit]
		local to_last_los_position = Vector3.normalize(Vector3.flat(look_at_position - position))

		flat_rotation = Quaternion.look(to_last_los_position)
	end

	if flat_rotation then
		local locomotion_extension = scratchpad.locomotion_extension

		locomotion_extension:set_wanted_rotation(flat_rotation)
	end
end

BtWizardIdleAction.init_values = function (self, blackboard)
	return
end

return BtWizardIdleAction
