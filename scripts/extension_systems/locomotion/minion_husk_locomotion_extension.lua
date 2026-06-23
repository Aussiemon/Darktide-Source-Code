-- chunkname: @scripts/extension_systems/locomotion/minion_husk_locomotion_extension.lua

local MinionHuskLocomotionExtension = class("MinionHuskLocomotionExtension")

MinionHuskLocomotionExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id)
	local sync_full_rotation = GameSession.has_game_object_field(game_session, game_object_id, "rotation")
	local spring_dampened_rotation = extension_init_data.breed.spring_dampened_husk_rotation
	local exponential_smoothing_rotation = extension_init_data.breed.exponential_smoothing_rotation_sync_husk

	self._engine_extension_id = MinionHuskLocomotion.register_extension(unit, game_object_id, sync_full_rotation, spring_dampened_rotation, exponential_smoothing_rotation)

	Unit._set_mover(unit, nil)
end

MinionHuskLocomotionExtension.destroy = function (self)
	MinionHuskLocomotion.destroy_extension(self._engine_extension_id)
end

MinionHuskLocomotionExtension.current_velocity = function (self)
	return MinionHuskLocomotion.velocity(self._engine_extension_id)
end

MinionHuskLocomotionExtension.set_rotation_responsiveness = function (self, responsiveness)
	return MinionHuskLocomotion.set_rotation_responsiveness(self._engine_extension_id, responsiveness)
end

return MinionHuskLocomotionExtension
