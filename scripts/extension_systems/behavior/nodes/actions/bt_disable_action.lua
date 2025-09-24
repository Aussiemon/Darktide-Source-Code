-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_disable_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionPerception = require("scripts/utilities/minion_perception")
local BtDisableAction = class("BtDisableAction", "BtNode")
local BASE_LAYER_EMPTY_EVENT = "base_layer_to_empty"

BtDisableAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	scratchpad.perception_component = Blackboard.write_component(blackboard, "perception")
	behavior_component.move_state = "disabled"
	scratchpad.behavior_component = behavior_component

	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	navigation_extension:set_enabled(false)

	scratchpad.visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

	self:_play_disable_anim(unit, blackboard, action_data, scratchpad)
end

BtDisableAction.init_values = function (self, blackboard)
	local disable_component = Blackboard.write_component(blackboard, "disable")

	disable_component.is_disabled = false
	disable_component.type = ""
	disable_component.attacker_unit = nil
end

BtDisableAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.standing_animation_duration and scratchpad.disable_component.attacker_unit then
		scratchpad.standing_animation_duration = nil

		self:_play_disable_anim(unit, blackboard, action_data, scratchpad)
	end

	if scratchpad.standing_animation_duration and t > scratchpad.standing_animation_duration then
		local stagger_component = Blackboard.write_component(blackboard, "stagger")

		stagger_component.count = 0
		stagger_component.num_triggered_staggers = 0
		scratchpad.disable_component.type = ""
		scratchpad.disable_component.is_disabled = false
		scratchpad.disable_component.attacker_unit = nil

		return "done"
	end

	if not scratchpad.standing_animation_duration and not scratchpad.disable_component.attacker_unit then
		local stand_anim = action_data.stand_anim

		scratchpad.animation_extension:anim_event(stand_anim.name)

		scratchpad.standing_animation_duration = t + stand_anim.duration

		local visual_loadout_extension = scratchpad.visual_loadout_extension

		if scratchpad.current_slot then
			local current_slot_data = visual_loadout_extension:slot_item(scratchpad.current_slot)

			if not current_slot_data.visible then
				visual_loadout_extension:set_slot_visibility(scratchpad.current_slot, true)
			end
		end

		local should_hide = false

		visual_loadout_extension:send_on_show_hide_weapon_event(should_hide)
	end

	return "running"
end

BtDisableAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local perception_component = scratchpad.perception_component

	if perception_component and perception_component.lock_target then
		MinionPerception.set_target_lock(unit, perception_component, false)
	end
end

BtDisableAction._select_disable_anim_and_rotation = function (self, unit, impact_vector, disable_anims, blackboard, action_data)
	local impact_direction = Vector3.normalize(impact_vector)
	local my_fwd = Vector3.normalize(Quaternion.forward(Unit.local_rotation(unit, 1)))
	local angle = Vector3.angle(my_fwd, impact_direction)
	local anim_table

	impact_direction.z = 0

	if angle > math.pi * 0.75 then
		anim_table = disable_anims.bwd
	elseif angle < math.pi * 0.25 then
		anim_table = disable_anims.fwd
	elseif Vector3.cross(my_fwd, impact_direction).z > 0 then
		anim_table = disable_anims.left
	else
		anim_table = disable_anims.right
	end

	local disable_anim = Animation.random_event(anim_table)
	local yaw = Quaternion.yaw(Quaternion.look(-impact_direction))
	local final_rotation = Quaternion(Vector3.up(), yaw)

	return disable_anim, final_rotation
end

BtDisableAction._play_disable_anim = function (self, unit, blackboard, action_data, scratchpad)
	local disable_component = Blackboard.write_component(blackboard, "disable")
	local disable_type = disable_component.type
	local disable_anims = action_data.disable_anims[disable_type]
	local attacker_unit = disable_component.attacker_unit
	local attack_direction = Vector3.normalize(Quaternion.forward(Unit.local_rotation(attacker_unit, 1)))

	scratchpad.disable_component = disable_component

	if not attack_direction then
		return
	end

	local disable_anim, disable_rotation = self:_select_disable_anim_and_rotation(unit, attack_direction, disable_anims, blackboard, action_data)

	Unit.set_local_rotation(unit, 1, disable_rotation)

	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(BASE_LAYER_EMPTY_EVENT)
	animation_extension:anim_event(disable_anim)

	scratchpad.animation_extension = animation_extension

	local visual_loadout_extension = scratchpad.visual_loadout_extension
	local current_slot = visual_loadout_extension:wielded_slot_name()

	if current_slot then
		local current_slot_data = visual_loadout_extension:slot_item(current_slot)

		if current_slot_data and current_slot_data.visible then
			scratchpad.current_slot = current_slot

			visual_loadout_extension:set_slot_visibility(current_slot, false)
		end
	end

	local should_hide = true

	visual_loadout_extension:send_on_show_hide_weapon_event(should_hide)
end

return BtDisableAction
