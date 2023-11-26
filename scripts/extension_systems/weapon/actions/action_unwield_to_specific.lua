-- chunkname: @scripts/extension_systems/weapon/actions/action_unwield_to_specific.lua

require("scripts/extension_systems/weapon/actions/action_unwield")

local ActionUnwieldToSpecific = class("ActionUnwieldToSpecific", "ActionUnwield")

ActionUnwieldToSpecific._next_slot = function (self, used_input, action_settings)
	local next_slot = action_settings.slot_to_wield

	return next_slot
end

return ActionUnwieldToSpecific
