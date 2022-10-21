local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionRangedAimExtension = class("MinionRangedAimExtension")

MinionRangedAimExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	local blackboard = BLACKBOARDS[unit]

	self:_init_blackboard_components(blackboard)

	local breed = extension_init_data.breed
	local aim_config = breed.aim_config
	self._constraint_target = Unit.animation_find_constraint_target(unit, aim_config.target)
	self._aim_component = blackboard.aim
	self._perception_component = blackboard.perception
	self._aim_lerp_speed = aim_config.lerp_speed
	self._aim_distance = aim_config.distance
	self._aim_node = Unit.node(unit, aim_config.node)
	local unit_position = Unit.world_position(unit, self._aim_node)
	local unit_forward = Quaternion.forward(Unit.local_rotation(unit, 1))
	local init_target = unit_position + unit_forward * self._aim_distance
	self._previous_aim_target = Vector3Box(init_target)
	self._previous_lean_dot = 1
	self._aim_config = aim_config
	self._lean_variable_name = aim_config.lean_variable_name
	self._lean_variable_modifier = aim_config.lean_variable_modifier
	self._require_line_of_sight = aim_config.require_line_of_sight
	self._unit = unit
end

MinionRangedAimExtension._init_blackboard_components = function (self, blackboard)
	local aim_write_component = Blackboard.write_component(blackboard, "aim")
	aim_write_component.controlled_aiming = false

	aim_write_component.controlled_aim_position:store(0, 0, 0)

	aim_write_component.lean_dot = 1
end

MinionRangedAimExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id
end

MinionRangedAimExtension.extensions_ready = function (self, world, unit)
	self._animation_extension = ScriptUnit.extension(unit, "animation_system")
	self._perception_extension = ScriptUnit.extension(unit, "perception_system")
end

MinionRangedAimExtension.update = function (self, unit, dt, t)
	local perception_component = self._perception_component
	local game_session = self._game_session
	local game_object_id = self._game_object_id
	local unit_position = Unit.world_position(unit, self._aim_node)
	local target_unit = perception_component.target_unit

	if not ALIVE[target_unit] or self._require_line_of_sight and not perception_component.has_line_of_sight then
		local perception_extension = self._perception_extension
		local last_los_position = perception_extension:last_los_position(target_unit)
		local fallback_target, fallback_direction = nil

		if last_los_position then
			local to_last_los_position = Vector3.normalize(last_los_position - unit_position)
			fallback_target = unit_position + to_last_los_position * self._aim_distance
			fallback_direction = to_last_los_position
		else
			fallback_target = self._previous_aim_target:unbox()
			local to_fallback_target = Vector3.normalize(fallback_target - unit_position)
			fallback_direction = to_fallback_target
		end

		local constraint_target = self._constraint_target

		Unit.animation_set_constraint_target(unit, constraint_target, fallback_target)
		GameSession.set_game_object_field(game_session, game_object_id, "aim_direction", fallback_direction)
		self._previous_aim_target:store(fallback_target)

		return
	end

	local aim_component = self._aim_component
	local target_position = nil

	if aim_component.controlled_aiming then
		target_position = aim_component.controlled_aim_position:unbox()
	else
		local target_node = Unit.node(target_unit, self._aim_config.target_node)
		target_position = Unit.world_position(target_unit, target_node)
	end

	local to_target = target_position - unit_position
	local aim_direction = Vector3.normalize(to_target)
	local aim_distance = self._aim_distance
	local aim_target = unit_position + aim_direction * aim_distance
	local rotation = Unit.world_rotation(unit, 1)
	local rotation_forward = Vector3.flat(Quaternion.forward(rotation))
	local rotation_forward_normalized = Vector3.normalize(rotation_forward)
	local aim_direction_normalized = Vector3.normalize(aim_direction)
	local dot = Vector3.dot(aim_direction_normalized, rotation_forward_normalized)

	if dot < 0 then
		local old_z = aim_target.z
		local rotation_right = Vector3.flat(Quaternion.right(rotation))

		if Vector3.cross(rotation_forward_normalized, aim_direction_normalized).z > 0 then
			aim_target = unit_position + (rotation_forward - rotation_right) * aim_distance
		else
			aim_target = unit_position + (rotation_forward + rotation_right) * aim_distance
		end

		aim_target.z = old_z
	end

	local previous_aim_target = self._previous_aim_target:unbox()
	local lerp_t = math.min(dt * self._aim_lerp_speed, 1)
	aim_target = Vector3.lerp(previous_aim_target, aim_target, lerp_t)
	local lean_variable_name = self._lean_variable_name

	if lean_variable_name then
		local previous_lean_dot = self._previous_lean_dot
		local lean_dot = aim_component.lean_dot
		lean_dot = math.abs(lean_dot - 1) + self._lean_variable_modifier
		lean_dot = math.lerp(previous_lean_dot, lean_dot, lerp_t)
		local lean_variable_value = math.clamp(lean_dot, 0, 1)
		local animation_extension = self._animation_extension

		animation_extension:set_variable(lean_variable_name, lean_variable_value)

		self._previous_lean_dot = lean_variable_value
	end

	local direction = Vector3.normalize(aim_target - unit_position)
	local final_target = unit_position + direction * aim_distance
	local constraint_target = self._constraint_target

	Unit.animation_set_constraint_target(unit, constraint_target, final_target)
	GameSession.set_game_object_field(game_session, game_object_id, "aim_direction", direction)
	self._previous_aim_target:store(aim_target)
end

return MinionRangedAimExtension
