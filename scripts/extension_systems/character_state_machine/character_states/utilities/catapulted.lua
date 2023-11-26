-- chunkname: @scripts/extension_systems/character_state_machine/character_states/utilities/catapulted.lua

local Catapulted = {}

Catapulted.apply = function (catapulted_state_input, velocity)
	if catapulted_state_input.new_input then
		catapulted_state_input.velocity = catapulted_state_input.velocity + velocity
	else
		catapulted_state_input.new_input = true
		catapulted_state_input.velocity = velocity
	end
end

return Catapulted
