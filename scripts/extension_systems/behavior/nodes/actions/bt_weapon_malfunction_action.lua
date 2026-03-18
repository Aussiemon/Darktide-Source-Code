-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_weapon_malfunction_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local Vo = require("scripts/utilities/vo")
local BtWeaponMalfunctionAction = class("BtWeaponMalfunctionAction", "BtNode")

BtWeaponMalfunctionAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local events = action_data.anim_events
	local animation_extension = ScriptUnit.has_extension(unit, "animation_system")

	if animation_extension then
		for _, anim_event in ipairs(events) do
			animation_extension:anim_event(anim_event)
		end
	end

	behavior_component.move_state = "idle"
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	local perception_extension = ScriptUnit.has_extension(unit, "perception_system")

	if perception_extension then
		local perception_component = blackboard.perception

		scratchpad.perception_component = perception_component
		scratchpad.perception_extension = perception_extension

		local vo_event = action_data.vo_event

		if vo_event and perception_component.aggro_state == "passive" then
			Vo.enemy_vo_event(unit, vo_event)
		end
	end

	scratchpad.time_to_next_proximity_check = t + 1
end

BtWeaponMalfunctionAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local perception_component = scratchpad.perception_component
	local liquid_area_system = Managers.state.extension:system("liquid_area_system")
	local is_position_in_liquid = liquid_area_system:is_position_in_liquid(POSITION_LOOKUP[unit])
	local should_leave_state = is_position_in_liquid

	if t >= scratchpad.time_to_next_proximity_check then
		scratchpad.time_to_next_proximity_check = t + 2
		should_leave_state = should_leave_state or perception_component.target_unit and perception_component.has_line_of_sight and perception_component.target_distance <= 5
	end

	if should_leave_state then
		local combat_vector_extension = ScriptUnit.has_extension(unit, "combat_vector_system")

		if combat_vector_extension then
			combat_vector_extension:look_for_new_location(10)
		end

		local cover_component = Blackboard.has_component(blackboard, "cover") and Blackboard.write_component(blackboard, "cover")

		if cover_component then
			cover_component.has_cover = false
		end

		return "done"
	end

	return "running"
end

BtWeaponMalfunctionAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local events = action_data.end_anim_events

	if reason == "aborted" and not destroy then
		local combat_vector_extension = ScriptUnit.has_extension(unit, "combat_vector_system")

		if combat_vector_extension then
			combat_vector_extension:look_for_new_location()
		end

		local cover_component = Blackboard.has_component(blackboard, "cover") and Blackboard.write_component(blackboard, "cover")

		if cover_component then
			cover_component.has_cover = false
		end
	end

	local animation_extension = ScriptUnit.has_extension(unit, "animation_system")

	if animation_extension then
		for _, anim_event in ipairs(events) do
			animation_extension:anim_event(anim_event)
		end
	end
end

BtWeaponMalfunctionAction.init_values = function (self, blackboard)
	return
end

return BtWeaponMalfunctionAction
