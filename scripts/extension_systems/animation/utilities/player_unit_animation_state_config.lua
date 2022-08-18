local PlayerUnitAnimationStateConfig = {}

PlayerUnitAnimationStateConfig.format = function (animation_state_settings)
	local times_3p = {}
	local animations_3p = {}
	local states_3p = {}
	local times_1p = {}
	local animations_1p = {}
	local states_1p = {}
	local num_layers_3p = animation_state_settings.num_layers_3p

	for i = 1, num_layers_3p do
		times_3p[i] = "times_3p_" .. i
		animations_3p[i] = "animations_3p_" .. i
		states_3p[i] = "states_3p_" .. i
	end

	local num_layers_1p = animation_state_settings.num_layers_1p

	for i = 1, num_layers_1p do
		times_1p[i] = "times_1p_" .. i
		animations_1p[i] = "animations_1p_" .. i
		states_1p[i] = "states_1p_" .. i
	end

	return times_3p, animations_3p, states_3p, times_1p, animations_1p, states_1p
end

return PlayerUnitAnimationStateConfig
