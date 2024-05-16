-- chunkname: @scripts/extension_systems/character_state_machine/character_states/utilities/interacting.lua

local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local states = InteractionSettings.states
local Interacting = {}

Interacting.check = function (interaction_component)
	local state = interaction_component.state

	if state ~= states.is_interacting then
		return false
	end

	return true
end

return Interacting
