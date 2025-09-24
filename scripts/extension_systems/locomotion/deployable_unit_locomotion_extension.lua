-- chunkname: @scripts/extension_systems/locomotion/deployable_unit_locomotion_extension.lua

local DeployableLocomotion = require("scripts/extension_systems/locomotion/utilities/deployable_locomotion")
local DeployableUnitLocomotionExtension = class("DeployableUnitLocomotionExtension")

DeployableUnitLocomotionExtension.init = function (self, extension_init_context, unit, extension_init_data)
	local world = extension_init_context.world
	local placed_on_unit = extension_init_data.placed_on_unit

	DeployableLocomotion.set_placed_on_unit(world, unit, placed_on_unit)

	if extension_init_context.is_server then
		Managers.state.extension:system("locomotion_system"):register_deployable(unit)
	end
end

DeployableUnitLocomotionExtension.game_object_initialized = function (self, game_session, game_object_id)
	self._game_object_id = game_object_id
	self._game_session = game_session
end

DeployableUnitLocomotionExtension.current_state = function (self)
	return
end

return DeployableUnitLocomotionExtension
