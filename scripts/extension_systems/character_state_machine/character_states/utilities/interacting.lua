local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local states = InteractionSettings.states
local Interacting = {
	check = function (interaction_component)
		local state = interaction_component.state

		if state ~= states.is_interacting then
			return false
		end

		return true
	end
}

return Interacting
