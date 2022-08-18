local MinionHuskLocomotionExtension = class("MinionHuskLocomotionExtension")

MinionHuskLocomotionExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id)
	local sync_full_rotation = GameSession.has_game_object_field(game_session, game_object_id, "rotation")
	self._engine_extension_id = MinionHuskLocomotion.register_extension(unit, game_object_id, sync_full_rotation)

	Unit._set_mover(unit, nil)
end

MinionHuskLocomotionExtension.destroy = function (self)
	MinionHuskLocomotion.destroy_extension(self._engine_extension_id)
end

MinionHuskLocomotionExtension.current_velocity = function (self)
	return MinionHuskLocomotion.velocity(self._engine_extension_id)
end

return MinionHuskLocomotionExtension
