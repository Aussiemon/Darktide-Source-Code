local Breed = require("scripts/utilities/breed")

local function _check_anim_events_within_network_bounds(unit, state_machine_name, max_network_entries, network_variable_name)
	local num_anim_events = Unit.animation_event_count(unit)

	fassert(num_anim_events <= max_network_entries, "[AnimationSystemTests] Too many event entries in %s state machine (%d, max:%d), either raise global.network_config value for %s by a factor 2 or remove some events from the state machine.", state_machine_name, num_anim_events, max_network_entries, network_variable_name)
end

local function _check_layer_states(unit, state_machine_name)
	local num_layers, anim_states = Unit.animation_get_state(unit)

	for i = 1, num_layers, 1 do
		local anim_state = anim_states[i]

		fassert(anim_state ~= nil, "[AnimationSystemTests] Missing state for layer %d in state machine %s, this will crash when trying to hot-join sync - ensure that layer has a \"Default State\" set in its state machine.", i, state_machine_name)
	end
end

local function _check_anim_variables_within_network_bounds(unit, state_machine_name, max_network_entries, network_variable_name)
	local num_variables = Unit.animation_variable_count(unit)

	fassert(num_variables <= max_network_entries, "[AnimationSystemTests] Too many variable entries in %s state machine (%d, max:%d), either raise global.network_config value for %s by a factor 2 or remove some variables from the state machine.", state_machine_name, num_variables, max_network_entries, network_variable_name)
end

local function _check_anim_variables_exists_in_game_object_field(breed, animation_variables)
	local game_object_type = breed.game_object_type

	for i = 1, #animation_variables, 1 do
		local animation_variable = animation_variables[i]

		fassert(Network.object_has_field(game_object_type, animation_variable), "[AnimationSystemTests] %s does not exist in game object field of game object type %s", animation_variable, game_object_type)
	end
end

local function _init_and_run_tests(unit, breed)
	local network_variable_name, max_network_entries = nil
	local is_player_character = Breed.is_player(breed)

	if is_player_character then
		max_network_entries = NetworkConstants.max_player_anim_event
		network_variable_name = "player_anim_event"
	else
		max_network_entries = NetworkConstants.max_minion_anim_event
		network_variable_name = "minion_anim_event"
	end

	local state_machine_name = breed.state_machine or breed.base_unit

	_check_anim_events_within_network_bounds(unit, state_machine_name, max_network_entries, network_variable_name)

	if not is_player_character then
		_check_layer_states(unit, state_machine_name)
	end

	max_network_entries = NetworkConstants.max_anim_variable
	network_variable_name = "anim_variable"

	_check_anim_variables_within_network_bounds(unit, state_machine_name, max_network_entries, network_variable_name)

	local animation_variables = breed.animation_variables

	if animation_variables then
		_check_anim_variables_exists_in_game_object_field(breed, animation_variables)
	end
end

return _init_and_run_tests
