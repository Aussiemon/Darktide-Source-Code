-- chunkname: @scripts/extension_systems/locomotion/deployable_unit_locomotion_extension.lua

local DeployableLocomotion = require("scripts/extension_systems/locomotion/utilities/deployable_locomotion")
local DeployableUnitLocomotionExtension = class("DeployableUnitLocomotionExtension")

DeployableUnitLocomotionExtension.init = function (self, extension_init_context, unit, extension_init_data)
	local world = extension_init_context.world

	self._world = world
	self._unit = unit

	local placed_on_unit = extension_init_data.placed_on_unit

	self._placed_on_unit = DeployableLocomotion.set_placed_on_unit(world, unit, placed_on_unit)

	if extension_init_context.is_server then
		Managers.state.extension:system("locomotion_system"):register_deployable(unit)
	end
end

DeployableUnitLocomotionExtension.game_object_initialized = function (self, game_session, game_object_id)
	self._game_object_id = game_object_id
	self._game_session = game_session
end

DeployableUnitLocomotionExtension.external_move = function (self, position, rotation)
	if self._placed_on_unit then
		World.unlink_unit(self._world, self._unit)

		self._placed_on_unit = nil
	end

	DeployableLocomotion.teleport_deployable(self._unit, position, rotation)
	Managers.state.game_session:send_rpc_clients("rpc_move_deployable", self._game_object_id, position, rotation)
end

DeployableUnitLocomotionExtension.current_state = function (self)
	return
end

return DeployableUnitLocomotionExtension
