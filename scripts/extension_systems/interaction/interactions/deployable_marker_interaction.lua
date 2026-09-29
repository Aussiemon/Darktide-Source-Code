-- chunkname: @scripts/extension_systems/interaction/interactions/deployable_marker_interaction.lua

require("scripts/extension_systems/interaction/interactions/base_interaction")

local DeployableMarkerInteraction = class("DeployableMarkerInteraction", "BaseInteraction")

DeployableMarkerInteraction.interactee_condition_func = function (self, interactee_unit)
	return false
end

return DeployableMarkerInteraction
