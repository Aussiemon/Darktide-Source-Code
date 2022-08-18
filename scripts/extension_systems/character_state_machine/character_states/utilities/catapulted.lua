local Catapulted = {
	apply = function (catapulted_state_input, velocity)
		fassert(Vector3.length_squared(velocity) ~= 0, "Catapulted velocity is 0.")

		if catapulted_state_input.new_input then
			catapulted_state_input.velocity = catapulted_state_input.velocity + velocity
		else
			catapulted_state_input.new_input = true
			catapulted_state_input.velocity = velocity
		end
	end
}

return Catapulted
