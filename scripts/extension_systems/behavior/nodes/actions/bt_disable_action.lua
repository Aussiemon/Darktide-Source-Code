-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_disable_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BtDisableAction = class("BtDisableAction", "BtNode")
local BASE_LAYER_EMPTY_EVENT = "base_layer_to_empty"

BtDisableAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local spawn_component = blackboard.spawn

	scratchpad.physics_world = spawn_component.physics_world
	behavior_component.move_state = "disabled"
	scratchpad.behavior_component = behavior_component

	local disable_component = Blackboard.write_component(blackboard, "disable")
	local disable_type = disable_component.type
	local disable_anims = action_data.disable_anims[disable_type]
	local attack_direction = -Quaternion.forward(Unit.local_rotation(unit, 1))
	local disable_anim, disable_rotation = self:_select_disable_anim_and_rotation(unit, attack_direction, disable_anims, blackboard, action_data)

	Unit.set_local_rotation(unit, 1, disable_rotation)

	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(BASE_LAYER_EMPTY_EVENT)
	animation_extension:anim_event(disable_anim)

	scratchpad.animation_extension = animation_extension
	scratchpad.locomotion_extension = locomotion_extension

	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.nav_world = navigation_extension:nav_world()
	scratchpad.traverse_logic = navigation_extension:traverse_logic()
end

BtDisableAction.init_values = function (self, blackboard)
	local disable_component = Blackboard.write_component(blackboard, "disable")

	disable_component.is_disabled = false
	disable_component.type = ""
	disable_component.attacker_unit = nil
end

BtDisableAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	return "running"
end

BtDisableAction._select_disable_anim_and_rotation = function (self, unit, impact_vector, disable_anims, blackboard, action_data)
	local impact_direction = Vector3.normalize(impact_vector)
	local my_fwd = Vector3.normalize(Quaternion.forward(Unit.local_rotation(unit, 1)))
	local angle = Vector3.angle(my_fwd, impact_direction)
	local impact_rot, anim_table

	impact_direction.z = 0

	if angle > math.pi * 0.75 then
		impact_rot = Quaternion.look(-impact_direction)
		anim_table = disable_anims.bwd
	elseif angle < math.pi * 0.25 then
		impact_rot = Quaternion.look(impact_direction)
		anim_table = disable_anims.fwd
	elseif Vector3.cross(my_fwd, impact_direction).z > 0 then
		local dir = Vector3.cross(Vector3(0, 0, -1), impact_direction)

		impact_rot = Quaternion.look(dir)
		anim_table = disable_anims.left
	else
		local dir = Vector3.cross(Vector3(0, 0, 1), impact_direction)

		impact_rot = Quaternion.look(dir)
		anim_table = disable_anims.right
	end

	local disable_anim = Animation.random_event(anim_table)
	local yaw = Quaternion.yaw(impact_rot)
	local final_rotation = Quaternion(Vector3.up(), yaw)

	return disable_anim, final_rotation
end

return BtDisableAction
