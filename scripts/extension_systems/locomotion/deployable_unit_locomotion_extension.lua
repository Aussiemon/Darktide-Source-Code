local DeployableUnitLocomotionExtension = class("DeployableUnitLocomotionExtension")

DeployableUnitLocomotionExtension.init = function (self, extension_init_context, unit, extension_init_data)
	self._unit = unit
	self._world = extension_init_context.world
	local placed_on_unit = extension_init_data.placed_on_unit
	local moveable_platform_extension = ScriptUnit.has_extension(placed_on_unit, "moveable_platform_system")

	if moveable_platform_extension then
		local platform_position = Unit.world_position(placed_on_unit, 1)
		local unit_pos = Unit.world_position(unit, 1)
		local unit_rot = Unit.local_rotation(unit, 1)
		local grounded_unit_pos = Vector3(unit_pos.x, unit_pos.y, platform_position.z)
		local position_difference = grounded_unit_pos - platform_position

		World.link_unit(self._world, unit, 1, placed_on_unit, 1)
		Unit.set_local_position(unit, 1, position_difference)
		Unit.set_local_rotation(unit, 1, unit_rot)
	end
end

DeployableUnitLocomotionExtension.game_object_initialized = function (self, game_session, game_object_id)
	self._game_object_id = game_object_id
	self._game_session = game_session
end

DeployableUnitLocomotionExtension.fixed_update = function (self, unit, dt, t)
	return
end

DeployableUnitLocomotionExtension.update = function (self, unit, dt, t)
	return
end

DeployableUnitLocomotionExtension.current_state = function (self)
	return
end

return DeployableUnitLocomotionExtension
