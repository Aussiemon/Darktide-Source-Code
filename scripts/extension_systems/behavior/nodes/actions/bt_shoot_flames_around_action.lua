-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_shoot_flames_around_action.lua

require("scripts/extension_systems/behavior/nodes/actions/bt_shoot_flames_action")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local CompanionServoSkullSettings = require("scripts/settings/companion/companion_servo_skull_settings")
local flamethrower_types = CompanionServoSkullSettings.FLAMETHROWER_TYPES
local servo_skull_states = CompanionServoSkullSettings.STATES
local BtShootFlamesAroundAction = class("BtShootFlamesAroundAction", "BtShootFlamesAction")

BtShootFlamesAroundAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	BtShootFlamesAroundAction.super.enter(self, unit, breed, blackboard, scratchpad, action_data, t)

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	scratchpad.behavior_component = behavior_component

	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	scratchpad.locomotion_extension = locomotion_extension

	local in_rotation_speed = action_data.in_rotation_speed

	locomotion_extension:set_rotation_speed(in_rotation_speed)
	self:_initial_pitch_rotation(unit, action_data, behavior_component)
end

BtShootFlamesAroundAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local flame_stop_animation = action_data.flame_stop_animation

	if flame_stop_animation then
		scratchpad.animation_extension:anim_event(flame_stop_animation)
	end

	local out_rotation_speed = action_data.out_rotation_speed

	scratchpad.locomotion_extension:set_rotation_speed(out_rotation_speed)
	BtShootFlamesAroundAction.super.leave(self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
end

BtShootFlamesAroundAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local behavior_component = scratchpad.behavior_component
	local has_move_to_position = behavior_component.has_move_to_position
	local wait_to_reach_position = action_data.wait_to_reach_position
	local current_position = POSITION_LOOKUP[unit]

	if not scratchpad.position_already_reached and wait_to_reach_position and has_move_to_position then
		local target_position = behavior_component.move_to_position:unbox()
		local distance_to_target_sq = Vector3.distance_squared(current_position, target_position)
		local reached_destination = distance_to_target_sq <= action_data.distance_threshold_sq

		if reached_destination then
			scratchpad.position_already_reached = true
			scratchpad.flame_effect_id = self:_start_effect_template(unit, scratchpad, action_data.effect_template_name)

			local game_session = Managers.state.game_session:game_session()
			local game_object_id = Managers.state.unit_spawner:game_object_id(unit)
			local game_object_exists = GameSession.game_object_exists(game_session, game_object_id)

			if not game_object_exists then
				return
			end

			behavior_component.has_target_rotation = false
			scratchpad._base_rotation = QuaternionBox(Unit.world_rotation(unit, 1))

			GameSession.set_game_object_field(game_session, game_object_id, "state", servo_skull_states.flamethrower_shooting)

			local flame_start_animation = action_data.flame_start_animation

			if flame_start_animation then
				scratchpad.animation_extension:anim_event(flame_start_animation)
			end
		else
			return "running"
		end
	end

	local game_session = Managers.state.game_session:game_session()
	local game_object_id = Managers.state.unit_spawner:game_object_id(unit)
	local game_object_exists = GameSession.game_object_exists(game_session, game_object_id)

	if not game_object_exists then
		return
	end

	local current_flamethrower_type = GameSession.game_object_field(game_session, game_object_id, "flamethrower_type")

	if current_flamethrower_type == flamethrower_types.circle then
		self:_rotate_unit_around(unit, action_data, scratchpad, dt)
	else
		self:_rotate_unit_cone(unit, scratchpad, action_data, dt, t)
	end

	return BtShootFlamesAroundAction.super.run(self, unit, breed, blackboard, scratchpad, action_data, dt, t)
end

BtShootFlamesAroundAction._rotate_unit_around = function (self, unit, action_data, scratchpad, dt)
	local rotation_angle_speed = action_data.flame_circle.rotation_angle_speed
	local current_rotation = Unit.world_rotation(unit, 1)
	local delta_rotation = Quaternion.axis_angle(Vector3.up(), rotation_angle_speed * dt)
	local new_rotation = Quaternion.multiply(delta_rotation, current_rotation)

	Unit.set_local_rotation(unit, 1, new_rotation)
end

BtShootFlamesAroundAction._rotate_unit_cone = function (self, unit, scratchpad, action_data, dt, t)
	if not scratchpad._initial_t then
		scratchpad._initial_t = t
	end

	if not scratchpad._initial_rotation then
		scratchpad._initial_rotation = QuaternionBox(Unit.local_rotation(unit, 1))
	end

	local flame_cone = action_data.flame_cone
	local rotation_angle_speed = flame_cone.rotation_angle_speed
	local max_angle = flame_cone.max_angle
	local current_rotation = scratchpad._base_rotation:unbox()
	local angle = max_angle * math.sin((t - scratchpad._initial_t) * rotation_angle_speed)
	local delta_rotation = Quaternion.axis_angle(Vector3.up(), angle)
	local new_rotation = Quaternion.multiply(delta_rotation, current_rotation)

	Unit.set_local_rotation(unit, 1, new_rotation)
end

BtShootFlamesAroundAction._initial_pitch_rotation = function (self, unit, action_data, behavior_component)
	local current_rotation = Unit.world_rotation(unit, 1)
	local right_direction = Quaternion.right(current_rotation)
	local initial_pitch_rotation_angle = action_data.initial_pitch_rotation_angle
	local rotation = Quaternion.axis_angle(right_direction, math.degrees_to_radians(initial_pitch_rotation_angle))
	local target_direction = Quaternion.multiply(rotation, current_rotation)

	behavior_component.has_target_rotation = true

	behavior_component.target_rotation:store(target_direction)
end

return BtShootFlamesAroundAction
