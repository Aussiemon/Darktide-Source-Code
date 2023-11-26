-- chunkname: @scripts/extension_systems/blackboard/blackboard_extension.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BlackboardExtension = class("BlackboardExtension")

BlackboardExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	local component_config = extension_init_data.component_config
	local blackboard = Blackboard.create(component_config)

	BLACKBOARDS[unit] = blackboard
	self._blackboard = blackboard
end

return BlackboardExtension
