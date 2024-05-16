-- chunkname: @scripts/extension_systems/aim/minion_ranged_husk_aim_extension.lua

local MinionRangedHuskAimExtension = class("MinionRangedHuskAimExtension")

MinionRangedHuskAimExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id)
	self._game_session = game_session
	self._game_object_id = game_object_id

	local breed = extension_init_data.breed
	local aim_config = breed.aim_config

	self._constraint_target = Unit.animation_find_constraint_target(unit, aim_config.target)
	self._previous_aim_target = Vector3Box()
	self._aim_lerp_speed = aim_config.lerp_speed
	self._aim_distance = aim_config.distance
	self._aim_node = Unit.node(unit, aim_config.node)
end

MinionRangedHuskAimExtension.update = function (self, unit, dt, t)
	local lerp_t = math.min(dt * self._aim_lerp_speed, 1)
	local game_session, game_object_id = self._game_session, self._game_object_id
	local unit_position = Unit.world_position(unit, self._aim_node)
	local aim_direction = GameSession.game_object_field(game_session, game_object_id, "aim_direction")
	local aim_distance = self._aim_distance
	local aim_target = unit_position + aim_direction * aim_distance
	local previous_aim_target = self._previous_aim_target:unbox()
	local new_aim_target = Vector3.lerp(previous_aim_target, aim_target, lerp_t)
	local constraint_target = self._constraint_target

	Unit.animation_set_constraint_target(unit, constraint_target, new_aim_target)
	self._previous_aim_target:store(new_aim_target)
end

return MinionRangedHuskAimExtension
