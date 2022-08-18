require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local AttackIntensity = require("scripts/utilities/attack_intensity")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionMovement = require("scripts/utilities/minion_movement")
local Vo = require("scripts/utilities/vo")
local BtStrafeShootAction = class("BtStrafeShootAction", "BtNode")

BtStrafeShootAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.animation_extension = animation_extension
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.navigation_extension = navigation_extension
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = Blackboard.write_component(blackboard, "perception")

	MinionAttack.init_scratchpad_shooting_variables(unit, scratchpad, action_data, blackboard, breed)

	local target_unit = scratchpad.perception_component.target_unit
	local attack_allowed = AttackIntensity.minion_can_attack(unit, action_data.attack_intensity_type, target_unit)

	if attack_allowed then
		local first_shoot_timing_range = action_data.first_shoot_timing
		local first_shoot_timing = math.random_range(first_shoot_timing_range[1], first_shoot_timing_range[2])

		MinionAttack.start_shooting(unit, scratchpad, t, action_data, first_shoot_timing)

		scratchpad.state = "shooting"
	else
		scratchpad.state = "cooldown"
		scratchpad.cooldown = 0
	end

	local start_aim_anims = action_data.start_aim_anims
	local speed = nil

	if start_aim_anims then
		local start_aim_anim = Animation.random_event(start_aim_anims)

		animation_extension:anim_event(start_aim_anim)

		local start_aim_duration = action_data.start_aim_durations[start_aim_anim]
		scratchpad.start_aim_duration = t + start_aim_duration
		speed = 0
	else
		speed = action_data.speed
	end

	navigation_extension:set_enabled(true, speed)

	local vo_event = action_data.vo_event

	if vo_event then
		Vo.enemy_generic_vo_event(unit, vo_event, breed.name)
	end
end

BtStrafeShootAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local state = scratchpad.state

	if state == "shooting" then
		MinionAttack.stop_shooting(unit, scratchpad)
	end

	scratchpad.navigation_extension:set_enabled(false)
end

BtStrafeShootAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local navigation_extension = scratchpad.navigation_extension
	local has_reached_destination = navigation_extension:has_reached_destination()

	if has_reached_destination then
		return "done"
	end

	local target_unit = scratchpad.perception_component.target_unit

	self:_rotate_towards_target_unit(unit, target_unit, scratchpad)
	MinionAttack.aim_at_target(unit, scratchpad, t, action_data)

	local start_aim_duration = scratchpad.start_aim_duration

	if start_aim_duration then
		if start_aim_duration <= t then
			navigation_extension:set_max_speed(action_data.speed)

			scratchpad.start_aim_duration = nil
		else
			return "running"
		end
	end

	self:_update_moving_animations(unit, scratchpad, action_data)

	local state = scratchpad.state

	if state == "shooting" then
		self:_update_shooting(unit, t, scratchpad, action_data)
	elseif state == "cooldown" then
		self:_update_cooldown(unit, t, scratchpad, action_data)
	end

	return "running"
end

BtStrafeShootAction._update_moving_animations = function (self, unit, scratchpad, action_data)
	local self_position = POSITION_LOOKUP[unit]
	local target_unit = scratchpad.perception_component.target_unit
	local target_position = POSITION_LOOKUP[target_unit]
	local rotation = Quaternion.look(target_position - self_position)
	local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad, nil, rotation)

	if moving_direction_name ~= scratchpad.moving_direction_name then
		local start_move_anim_events = action_data.start_move_anim_events
		local start_move_event = start_move_anim_events[moving_direction_name]

		scratchpad.animation_extension:anim_event(start_move_event)

		scratchpad.moving_direction_name = moving_direction_name
		scratchpad.current_aim_anim_event = start_move_event
		scratchpad.behavior_component.move_state = "attacking"
	end
end

BtStrafeShootAction._update_shooting = function (self, unit, t, scratchpad, action_data)
	local _, fired_last_shot = MinionAttack.update_shooting(unit, scratchpad, t, action_data)

	if fired_last_shot then
		local cooldown_range = action_data.shoot_cooldown
		local diff_cooldown_range = Managers.state.difficulty:get_table_entry_by_challenge(cooldown_range)
		scratchpad.cooldown = t + math.random_range(diff_cooldown_range[1], diff_cooldown_range[2])
		scratchpad.state = "cooldown"
	end
end

BtStrafeShootAction._update_cooldown = function (self, unit, t, scratchpad, action_data)
	local target_unit = scratchpad.perception_component.target_unit
	local attack_allowed = AttackIntensity.minion_can_attack(unit, action_data.attack_intensity_type, target_unit)

	if attack_allowed and scratchpad.cooldown < t then
		MinionAttack.start_shooting(unit, scratchpad, t, action_data)

		scratchpad.state = "shooting"
	end
end

BtStrafeShootAction._rotate_towards_target_unit = function (self, unit, target_unit, scratchpad)
	local locomotion_extension = scratchpad.locomotion_extension
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

	locomotion_extension:set_wanted_rotation(flat_rotation)
end

return BtStrafeShootAction
