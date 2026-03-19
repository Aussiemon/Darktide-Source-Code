-- chunkname: @scripts/extension_systems/locomotion/deployable_husk_locomotion_extension.lua

local DeployableLocomotion = require("scripts/extension_systems/locomotion/utilities/deployable_locomotion")
local DeployableHuskLocomotionExtension = class("DeployableHuskLocomotionExtension")

DeployableHuskLocomotionExtension.UPDATE_DISABLED_BY_DEFAULT = true

local RPCS = {
	"rpc_move_deployable",
}

DeployableHuskLocomotionExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id)
	self._unit = unit
	self._world = extension_init_context.world
	self._owner_system = extension_init_context.owner_system

	local unit_id = GameSession.game_object_field(game_session, game_object_id, "placed_on_unit_id")

	if unit_id and unit_id ~= 0 then
		if Managers.state.unit_spawner:unit_exists(unit_id, true) then
			self._placed_on_unit = self:_attach_to_unit(unit_id)
		else
			self._attach_later_on_id = unit_id

			self._owner_system:enable_update_function(self.__class_name, "update", self._unit, self)
		end
	end

	self._game_object_id = game_object_id

	local network_event_delegate = extension_init_context.network_event_delegate

	network_event_delegate:register_session_unit_events(self, game_object_id, unpack(RPCS))

	self._network_event_delegate = network_event_delegate
end

DeployableHuskLocomotionExtension._attach_to_unit = function (self, unit_id)
	local unit = self._unit
	local placed_on_unit = unit_id and unit_id ~= 0 and Managers.state.unit_spawner:unit(unit_id, true)
	local moveable_platform_extension = placed_on_unit and ScriptUnit.has_extension(placed_on_unit, "moveable_platform_system")

	if moveable_platform_extension then
		local platform_position = Unit.world_position(placed_on_unit, 1)
		local platform_rot = Unit.local_rotation(placed_on_unit, 1)
		local unit_pos = Unit.world_position(unit, 1)
		local unit_rot = Unit.local_rotation(unit, 1)
		local grounded_unit_pos = Vector3(unit_pos.x, unit_pos.y, platform_position.z)
		local position_difference = grounded_unit_pos - platform_position
		local x, y, z = Quaternion.to_euler_angles_xyz(platform_rot)
		local angle = (360 - z) * math.pi / 180
		local newX = position_difference.x * math.cos(angle) - position_difference.y * math.sin(angle)
		local newY = position_difference.x * math.sin(angle) + position_difference.y * math.cos(angle)
		local new_local_pos = Vector3(newX, newY, 0)

		World.link_unit(self._world, unit, 1, placed_on_unit, 1)
		Unit.set_local_position(unit, 1, new_local_pos)
		Unit.set_local_rotation(unit, 1, unit_rot)

		return placed_on_unit
	end

	return nil
end

DeployableHuskLocomotionExtension.rpc_move_deployable = function (self, channel_id, game_object_id, position, rotation)
	if self._placed_on_unit then
		self._placed_on_unit = nil

		World.unlink(self._world, self._unit)
	end

	DeployableLocomotion.teleport_deployable(self._unit, position, rotation)
end

DeployableHuskLocomotionExtension.fixed_update = function (self, unit, dt, t)
	return
end

DeployableHuskLocomotionExtension.update = function (self, unit, dt, t)
	local unit_attach_id = self._attach_later_on_id

	if self._attach_later_on_id and Managers.state.unit_spawner:unit_exists(unit_attach_id, true) then
		self:_attach_to_unit(unit_attach_id)
		self._owner_system:disable_update_function(self.__class_name, "update", self._unit, self)
	end
end

DeployableHuskLocomotionExtension.current_state = function (self)
	return
end

DeployableHuskLocomotionExtension.destroy = function (self)
	self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(RPCS))
end

return DeployableHuskLocomotionExtension
