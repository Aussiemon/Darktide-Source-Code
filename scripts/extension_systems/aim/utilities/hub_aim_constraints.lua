-- chunkname: @scripts/extension_systems/aim/utilities/hub_aim_constraints.lua

local HubAimConstraintSettings = require("scripts/settings/aim/hub_aim_constraint_settings")
local IDLE_SPEEDS = HubAimConstraintSettings.speed.idle
local PASSIVE_SPEEDS = HubAimConstraintSettings.speed.passive
local MOVING_SPEEDS = HubAimConstraintSettings.speed.moving
local MOVING_PASSIVE_SPEEDS = HubAimConstraintSettings.speed.moving_passive
local RATE_OF_CHANGE = HubAimConstraintSettings.speed.rate_of_change
local HEIGHT_ADJUSTMENTS = HubAimConstraintSettings.height_adjustment
local AIM_WEIGHT = HubAimConstraintSettings.aim_weight
local AIM_WEIGHT_LERP_SPEED = HubAimConstraintSettings.aim_weight_lerp_speed
local STATES = HubAimConstraintSettings.states
local HubAimConstraints = class("HubAimConstraints")
local PI = math.pi

HubAimConstraints.init = function (self, unit, init_context)
	self._unit = unit
	self._first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	self._locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	local head_constraint_target_name = init_context.aim_constraint_target_name
	local torso_constraint_target_name = init_context.aim_constraint_target_torso_name
	local head_aim_weight_name = init_context.head_aim_weight_name
	local torso_aim_weight_name = init_context.torso_aim_weight_name

	self._head_constraint_target_name = head_constraint_target_name
	self._torso_constraint_target_name = torso_constraint_target_name
	self._head_constraint_target_index = Unit.animation_find_constraint_target(unit, head_constraint_target_name)
	self._torso_constraint_target_index = Unit.animation_find_constraint_target(unit, torso_constraint_target_name)
	self._head_aim_weight_index = Unit.animation_find_variable(unit, head_aim_weight_name)
	self._torso_aim_weight_index = Unit.animation_find_variable(unit, torso_aim_weight_name)
	self._aim_constraint_distance = init_context.aim_constraint_distance
	self._head_speed = IDLE_SPEEDS.head
	self._torso_speed = IDLE_SPEEDS.torso
	self._passive_head_speed = PASSIVE_SPEEDS.head
	self._passive_torso_speed = PASSIVE_SPEEDS.torso
	self._head_aim_weight = 0
	self._torso_aim_weight = 0
end

HubAimConstraints.is_moving = function (self)
	local move_speed_squared = self._locomotion_extension:move_speed_squared()

	return move_speed_squared >= HubAimConstraintSettings.moving_threshold_sq
end

HubAimConstraints.update = function (self, head_direction, torso_direction, is_moving, aim_state, dt, t)
	local unit = self._unit
	local unit_pose = Unit.world_pose(unit, 1)
	local is_passive = aim_state == STATES.passive
	local head_goal_speed, torso_goal_speed = self:_goal_speeds(is_moving, is_passive)
	local target_head_position, target_torso_position, head_source_pos, torso_source_pos = self:_target_goal_positions(unit_pose, head_direction, torso_direction, is_passive, is_moving)
	local result_head_speed, result_torso_speed = self:_update_speeds(dt, head_goal_speed, torso_goal_speed, is_passive)
	local head_target_aim_weight = self:_get_aim_weight(aim_state, "head")
	local torso_target_aim_weight = self:_get_aim_weight(aim_state, "torso")

	self._head_aim_weight = self:_update_aim_weight(unit, self._head_aim_weight, head_target_aim_weight, dt, "head", self._head_aim_weight_index)
	self._torso_aim_weight = self:_update_aim_weight(unit, self._torso_aim_weight, torso_target_aim_weight, dt, "torso", self._torso_aim_weight_index)

	local unit_forward = Vector3.normalize(Matrix4x4.forward(unit_pose))
	local unit_right = Vector3.normalize(Matrix4x4.right(unit_pose))

	self:_lerp_target(unit, unit_forward, unit_right, head_source_pos, target_head_position, dt * result_head_speed, self._head_constraint_target_name, self._head_constraint_target_index, is_passive, is_moving)
	self:_lerp_target(unit, unit_forward, unit_right, torso_source_pos, target_torso_position, dt * result_torso_speed, self._torso_constraint_target_name, self._torso_constraint_target_index, is_passive, is_moving)
end

HubAimConstraints._get_aim_weight = function (self, aim_state, target_name)
	local target_settings = AIM_WEIGHT[target_name]

	if not target_settings then
		return 0
	end

	local aim_state_name = aim_state > 0 and STATES[aim_state] or "passive"

	return target_settings[aim_state_name] or 0
end

HubAimConstraints._update_aim_weight = function (self, unit, current_weight, target_weight, dt, target_name, anim_variable_id)
	local current_aim_weight = math.lerp(current_weight, target_weight, math.min(dt * AIM_WEIGHT_LERP_SPEED, 1))

	Unit.animation_set_variable(unit, anim_variable_id, current_aim_weight)

	return current_aim_weight
end

HubAimConstraints._goal_speeds = function (self, is_moving, is_passive)
	local head_goal_speed, torso_goal_speed

	if is_moving then
		if is_passive then
			head_goal_speed = MOVING_PASSIVE_SPEEDS.head
			torso_goal_speed = MOVING_PASSIVE_SPEEDS.torso
		else
			head_goal_speed = MOVING_SPEEDS.head
			torso_goal_speed = MOVING_SPEEDS.torso
		end
	elseif is_passive then
		head_goal_speed = PASSIVE_SPEEDS.head
		torso_goal_speed = PASSIVE_SPEEDS.torso
	else
		head_goal_speed = IDLE_SPEEDS.head
		torso_goal_speed = IDLE_SPEEDS.torso
	end

	return head_goal_speed, torso_goal_speed
end

HubAimConstraints._target_goal_positions = function (self, unit_pose, head_direction, torso_direction)
	local unit_position = Matrix4x4.translation(unit_pose)
	local height_from_1p = self._first_person_extension:extrapolated_character_height()
	local aim_contraint_distance = self._aim_constraint_distance
	local head_height = height_from_1p * HEIGHT_ADJUSTMENTS.head
	local torso_height = height_from_1p * HEIGHT_ADJUSTMENTS.torso
	local head_pos = unit_position + Vector3.up() * head_height
	local torso_pos = unit_position + Vector3.up() * torso_height
	local target_head_position = head_pos + head_direction * aim_contraint_distance
	local target_torso_position = torso_pos + torso_direction * aim_contraint_distance

	return target_head_position, target_torso_position, head_pos, torso_pos
end

HubAimConstraints._update_speeds = function (self, dt, head_goal_speed, torso_goal_speed, is_passive)
	local t = dt * RATE_OF_CHANGE
	local result_head_speed, result_torso_speed

	if is_passive then
		local interpolated_passive_head_speed = (1 - t) * self._passive_head_speed + t * head_goal_speed
		local interpolated_passive_torso_speed = (1 - t) * self._passive_torso_speed + t * torso_goal_speed

		self._passive_head_speed = math.min(interpolated_passive_head_speed, head_goal_speed)
		self._passive_torso_speed = math.min(interpolated_passive_torso_speed, torso_goal_speed)
		self._head_speed = 0
		self._torso_speed = 0
		result_head_speed = self._passive_head_speed
		result_torso_speed = self._passive_torso_speed
	else
		self._passive_head_speed = 0
		self._passive_torso_speed = 0

		local interpolated_head_speed = (1 - t) * self._head_speed + t * head_goal_speed
		local interpolated_torso_speed = (1 - t) * self._torso_speed + t * torso_goal_speed

		self._head_speed = math.min(interpolated_head_speed, head_goal_speed)
		self._torso_speed = math.min(interpolated_torso_speed, torso_goal_speed)
		result_head_speed = self._head_speed
		result_torso_speed = self._torso_speed
	end

	return result_head_speed, result_torso_speed
end

HubAimConstraints._lerp_target = function (self, unit, unit_forward, unit_right, source_pos, target_pos, lerp_t, target_name, target, is_passive, is_moving)
	local current_target_pos = Matrix4x4.translation(Unit.animation_get_constraint_target(unit, target))
	local source_to_current_target = Vector3.normalize(current_target_pos - source_pos)
	local source_to_target = Vector3.normalize(target_pos - source_pos)
	local current_target_rot = Quaternion.look(source_to_current_target)
	local target_rot = Quaternion.look(source_to_target)
	local same_look_side = math.sign(Vector3.dot(source_to_current_target, unit_right)) == math.sign(Vector3.dot(source_to_target, unit_right))

	if not same_look_side then
		local current_relative_angle = Vector3.length_squared(source_to_current_target) > 0 and Vector3.angle(source_to_current_target, unit_forward) or 0
		local target_relative_angle = Vector3.length_squared(source_to_target) > 0 and Vector3.angle(unit_forward, source_to_target) or 0
		local big_angle = current_relative_angle + target_relative_angle

		if big_angle >= PI then
			target_rot = Quaternion.lerp(Quaternion.look(unit_forward), target_rot, 0.4)
		end
	end

	local lerped_rot = Quaternion.lerp(current_target_rot, target_rot, math.min(lerp_t, 1))
	local new_target_pos = source_pos + Quaternion.forward(lerped_rot) * self._aim_constraint_distance

	Unit.animation_set_constraint_target(unit, target, new_target_pos)
end

return HubAimConstraints
