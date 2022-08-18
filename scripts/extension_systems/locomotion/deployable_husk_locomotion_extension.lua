local DeployableHuskLocomotionExtension = class("DeployableHuskLocomotionExtension")

DeployableHuskLocomotionExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id)
	self._unit = unit
	self._world = extension_init_context.world
	local unit_id = GameSession.game_object_field(game_session, game_object_id, "placed_on_unit_id")
	local placed_on_unit = unit_id and unit_id ~= 0 and Managers.state.unit_spawner:unit(unit_id, true)
	local moveable_platform_extension = placed_on_unit and ScriptUnit.has_extension(placed_on_unit, "moveable_platform_system")

	if moveable_platform_extension then
		local platform_position = Unit.world_position(placed_on_unit, 1)
		local unit_pos = Unit.world_position(unit, 1)
		local grounded_unit_pos = Vector3(unit_pos.x, unit_pos.y, platform_position.z)
		local position_difference = platform_position - grounded_unit_pos

		World.link_unit(self._world, unit, 1, placed_on_unit, 1)
		Unit.set_local_position(unit, 1, position_difference)
	end
end

DeployableHuskLocomotionExtension.fixed_update = function (self, unit, dt, t)
	return
end

DeployableHuskLocomotionExtension.update = function (self, unit, dt, t)
	return
end

DeployableHuskLocomotionExtension.current_state = function (self)
	return
end

return DeployableHuskLocomotionExtension
