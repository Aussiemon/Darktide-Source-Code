local PlayerUnitAnimationMachineSettings = require("scripts/settings/animation/player_unit_animation_state_machine_settings")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitAnimationStateConfig = require("scripts/extension_systems/animation/utilities/player_unit_animation_state_config")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local animation_variables_to_cache = PlayerCharacterConstants.animation_variables_to_cache
local animation_variables_to_cache_3p = animation_variables_to_cache.third_person
local animation_variables_to_cache_1p = animation_variables_to_cache.first_person
local animation_rollback = PlayerCharacterConstants.animation_rollback
local TIMES_3P, ANIMS_3P, STATES_3P, TIMES_1P, ANIMS_1P, STATES_1P = PlayerUnitAnimationStateConfig.format(animation_rollback)
local NUM_LAYERS_3P = animation_rollback.num_layers_3p
local NUM_LAYERS_1P = animation_rollback.num_layers_1p
local _set_anim_state_machine, _record_times, _record_animations, _record_states, _override_times, _override_animations, _override_states, _compare_animations, _compare_states, _compare_times, _log = nil
local PlayerUnitAnimationState = {
	init_anim_state_component = function (animation_state_component)
		local invalid_player_anim_time = NetworkConstants.invalid_player_anim_time
		local invalid_player_anim = NetworkConstants.invalid_player_anim
		local invalid_player_anim_state = NetworkConstants.invalid_player_anim_state
		animation_state_component.num_layers_3p = NUM_LAYERS_3P
		animation_state_component.num_layers_1p = NUM_LAYERS_1P

		for i = 1, NUM_LAYERS_3P do
			animation_state_component[TIMES_3P[i]] = invalid_player_anim_time
			animation_state_component[ANIMS_3P[i]] = invalid_player_anim
			animation_state_component[STATES_3P[i]] = invalid_player_anim_state
		end

		for i = 1, NUM_LAYERS_1P do
			animation_state_component[TIMES_1P[i]] = invalid_player_anim_time
			animation_state_component[ANIMS_1P[i]] = invalid_player_anim
			animation_state_component[STATES_1P[i]] = invalid_player_anim_state
		end
	end
}

PlayerUnitAnimationState.set_anim_state_machine = function (player_unit, first_person_unit, weapon_template, is_local_unit, anim_variables_3p, anim_variables_1p)
	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local breed_name = unit_data_extension:breed_name()
	local anim_state_machine_3p, anim_state_machine_1p = WeaponTemplate.state_machines(weapon_template, breed_name)

	_set_anim_state_machine(player_unit, anim_state_machine_3p)
	_set_anim_state_machine(first_person_unit, anim_state_machine_1p)
	PlayerUnitAnimationState.cache_anim_variable_ids(player_unit, first_person_unit, anim_variables_3p, anim_variables_1p, anim_state_machine_3p, anim_state_machine_1p)

	local aim_extension = ScriptUnit.has_extension(player_unit, "aim_system")

	if aim_extension then
		aim_extension:state_machine_changed(player_unit)
	end
end

local num_1p_variables = #animation_variables_to_cache_1p
local num_3p_variables = #animation_variables_to_cache_3p
local Unit_animation_find_variable = Unit.animation_find_variable

PlayerUnitAnimationState.cache_anim_variable_ids = function (player_unit, first_person_unit, anim_variables_3p, anim_variables_1p, state_machine_3p_or_nil, state_machine_1p_or_nil)
	for i = 1, num_3p_variables do
		local variable_name = animation_variables_to_cache_3p[i]
		local id = Unit_animation_find_variable(player_unit, variable_name)
		anim_variables_3p[variable_name] = id
	end

	for i = 1, num_1p_variables do
		local variable_name = animation_variables_to_cache_1p[i]
		local id = Unit_animation_find_variable(first_person_unit, variable_name)
		anim_variables_1p[variable_name] = id
	end
end

PlayerUnitAnimationState.should_override_animation_state = function (animation_state_component, simulated_animation_state_component)
	local states_wants_override_3p, states_wants_override_1p = _compare_states(animation_state_component, simulated_animation_state_component)

	if states_wants_override_3p or states_wants_override_1p then
		return states_wants_override_3p, states_wants_override_1p
	end

	local animations_wants_override_3p, animations_wants_override_1p = _compare_animations(animation_state_component, simulated_animation_state_component)

	if animations_wants_override_3p or animations_wants_override_1p then
		return animations_wants_override_3p, animations_wants_override_1p
	end

	local times_wants_override_3p, times_wants_override_1p = _compare_times(animation_state_component, simulated_animation_state_component)

	if times_wants_override_3p or times_wants_override_1p then
		return times_wants_override_3p, times_wants_override_1p
	end

	return false
end

PlayerUnitAnimationState.record_animation_state = function (animation_state_component, player_unit, first_person_unit)
	_record_times(animation_state_component, player_unit, first_person_unit)
	_record_animations(animation_state_component, player_unit, first_person_unit)
	_record_states(animation_state_component, player_unit, first_person_unit)
end

PlayerUnitAnimationState.override_animation_state = function (animation_state_component, player_unit, first_person_unit, simulated_time, override_3p, override_1p)
	_override_times(animation_state_component, player_unit, first_person_unit, simulated_time, override_3p, override_1p)
	_override_animations(animation_state_component, player_unit, first_person_unit, override_3p, override_1p)
	_override_states(animation_state_component, player_unit, first_person_unit, override_3p, override_1p)
end

function _set_anim_state_machine(unit, state_machine_name)
	local state_machine_settings = PlayerUnitAnimationMachineSettings[state_machine_name]
	local blend_time = state_machine_settings.blend_time

	Unit.set_animation_state_machine_blend_base_layer(unit, state_machine_name, nil, blend_time)
end

function _record_times(animation_state_component, player_unit, first_person_unit)
	local invalid_player_anim_time = NetworkConstants.invalid_player_anim_time
	local clamp_value = invalid_player_anim_time - 0.015625
	local num_times_3p, times_3p = Unit.animation_get_time(player_unit)

	fassert(num_times_3p <= NUM_LAYERS_3P, "Found time for animation layer in the player unit we don't sync, need to up the amount of times we sync in the component.")

	for i = 1, num_times_3p do
		local time = times_3p[i]

		if time then
			time = math.min(time, clamp_value)
		else
			time = invalid_player_anim_time
		end

		animation_state_component[TIMES_3P[i]] = time
	end

	local num_times_1p, times_1p = Unit.animation_get_time(first_person_unit)

	fassert(num_times_1p <= NUM_LAYERS_1P, "Found time for animation layer in the first person unit we don't sync, need to up the amount of times we sync in the component.")

	for i = 1, num_times_1p do
		local time = times_1p[i]

		if time then
			time = math.min(time, clamp_value)
		else
			time = invalid_player_anim_time
		end

		animation_state_component[TIMES_1P[i]] = time
	end

	if DevParameters.debug_animation_recording then
		local function build_string(array, length)
			local s = ""

			for i = 1, length do
				local time = array[i]

				if type(time) == "number" then
					s = string.format("%s %.5f", s, time)
				else
					s = string.format("%s %s", s, tostring(time))
				end
			end

			return s
		end

		local s_3p = build_string(times_3p, num_times_3p)

		Debug:fixed_update_text("times_3p: %s", s_3p)

		local s_1p = build_string(times_1p, num_times_1p)

		Debug:fixed_update_text("times_1p: %s", s_1p)
	end
end

function _compare_times(animation_state_component, simulated_animation_state_component)
	return false, false
end

local function _retrieve_time(time, invalid_player_anim_time, simulated_time)
	if time == invalid_player_anim_time then
		return nil
	else
		return time
	end
end

local temp_times_3p = {}
local temp_times_1p = {}

function _override_times(animation_state_component, player_unit, first_person_unit, simulated_time, override_3p, override_1p)
	local invalid_player_anim_time = NetworkConstants.invalid_player_anim_time

	if override_3p then
		table.clear(temp_times_3p)

		local num_layers_3p = animation_state_component.num_layers_3p

		for i = 1, num_layers_3p do
			local time = _retrieve_time(animation_state_component[TIMES_3P[i]], invalid_player_anim_time, simulated_time)
			temp_times_3p[i] = time
		end

		Unit.animation_set_time(player_unit, unpack(temp_times_3p, 1, num_layers_3p))
	end

	if override_1p then
		table.clear(temp_times_1p)

		local num_layers_1p = animation_state_component.num_layers_1p

		for i = 1, num_layers_1p do
			local time = _retrieve_time(animation_state_component[TIMES_1P[i]], invalid_player_anim_time, simulated_time)
			temp_times_1p[i] = time
		end

		Unit.animation_set_time(first_person_unit, unpack(temp_times_1p, 1, num_layers_1p))
	end
end

function _record_animations(animation_state_component, player_unit, first_person_unit)
	local num_anims_3p, anims_3p = Unit.animation_get_animation(player_unit)

	fassert(num_anims_3p <= NUM_LAYERS_3P, "Found animation for animation layer in the first person unit we don't sync, need to up the amount of animations we sync in the component.")

	for i = 1, num_anims_3p do
		local anim = anims_3p[i]
		animation_state_component[ANIMS_3P[i]] = anim
	end

	local num_anims_1p, anims_1p = Unit.animation_get_animation(first_person_unit)

	fassert(num_anims_1p <= NUM_LAYERS_1P, "Found animation for animation layer in the first person unit we don't sync, need to up the amount of animations we sync in the component.")

	for i = 1, num_anims_1p do
		local anim = anims_1p[i]
		animation_state_component[ANIMS_1P[i]] = anim
	end

	if DevParameters.debug_animation_recording then
		local function build_string(array, length)
			local s = ""

			for i = 1, length do
				s = string.format("%s%.5f ", s, array[i])
			end

			return s
		end

		local s_3p = build_string(anims_3p, num_anims_3p)

		Debug:fixed_update_text("animations_3p: " .. s_3p)

		local s_1p = build_string(anims_1p, num_anims_1p)

		Debug:fixed_update_text("animations_1p: " .. s_1p)
	end
end

local function _simulated_does_not_match(animation_state_component, simulated_animation_state_component, identifier)
	local value = animation_state_component[identifier]
	local simulated_value = simulated_animation_state_component[identifier]

	if value ~= simulated_value then
		return true
	end

	return false
end

function _compare_animations(animation_state_component, simulated_animation_state_component)
	return false, false
end

local temp_anims_3p = {}
local temp_anims_1p = {}

function _override_animations(animation_state_component, player_unit, first_person_unit, override_3p, override_1p)
	local invalid_player_anim = NetworkConstants.invalid_player_anim

	if override_3p then
		table.clear(temp_anims_3p)

		local num_layers_3p = animation_state_component.num_layers_3p

		for i = 1, num_layers_3p do
			local anim = animation_state_component[ANIMS_3P[i]]

			if anim == invalid_player_anim then
				anim = nil
			end

			temp_anims_3p[i] = anim
		end

		Unit.animation_set_animation(player_unit, unpack(temp_anims_3p, 1, num_layers_3p))
	end

	if override_1p then
		table.clear(temp_anims_1p)

		local num_layers_1p = animation_state_component.num_layers_1p

		for i = 1, num_layers_1p do
			local anim = animation_state_component[ANIMS_1P[i]]

			if anim == invalid_player_anim then
				anim = nil
			end

			temp_anims_1p[i] = anim
		end

		Unit.animation_set_animation(first_person_unit, unpack(temp_anims_1p, 1, num_layers_1p))
	end
end

function _record_states(animation_state_component, player_unit, first_person_unit)
	local invalid_player_anim_state = NetworkConstants.invalid_player_anim_state
	local Unit_animation_get_state = Unit.animation_get_state
	local num_states_3p, states_3p = Unit_animation_get_state(player_unit)

	fassert(num_states_3p <= NUM_LAYERS_3P, "Found state for animation layer in the player unit we don't sync, need to up the amount of states we sync in the component.")

	animation_state_component.num_layers_3p = num_states_3p

	for i = 1, num_states_3p do
		local state = states_3p[i] or invalid_player_anim_state

		fassert(state <= invalid_player_anim_state, "Animation state is larger than what network_type \"player_anim_state\" can support. Up it in global.network_config by a factor of 2")

		animation_state_component[STATES_3P[i]] = state
	end

	local num_states_1p, states_1p = Unit_animation_get_state(first_person_unit)

	fassert(num_states_1p <= NUM_LAYERS_1P, "Found state for animation layer in the first person unit we don't sync, need to up the amount of states we sync in the component.")

	animation_state_component.num_layers_1p = num_states_1p

	for i = 1, num_states_1p do
		local state = states_1p[i] or invalid_player_anim_state

		fassert(state <= invalid_player_anim_state, "Animation state is larger than what network_type \"player_anim_state\" can support. Up it in global.network_config by a factor of 2")

		animation_state_component[STATES_1P[i]] = state
	end
end

function _compare_states(animation_state_component, simulated_animation_state_component)
	local wants_override_3p = false
	local wants_override_1p = false
	local num_layers_3p = animation_state_component.num_layers_3p

	for i = 1, num_layers_3p do
		if _simulated_does_not_match(animation_state_component, simulated_animation_state_component, STATES_3P[i]) then
			wants_override_3p = true

			break
		end
	end

	local num_layers_1p = animation_state_component.num_layers_1p

	for i = 1, num_layers_1p do
		if _simulated_does_not_match(animation_state_component, simulated_animation_state_component, STATES_1P[i]) then
			wants_override_1p = true

			break
		end
	end

	return wants_override_3p, wants_override_1p
end

local temp_states_3p = {}
local temp_states_1p = {}

function _override_states(animation_state_component, player_unit, first_person_unit, override_3p, override_1p)
	local invalid_player_anim_state = NetworkConstants.invalid_player_anim_state

	if override_3p then
		table.clear(temp_states_3p)

		local num_layers_3p = animation_state_component.num_layers_3p

		for i = 1, num_layers_3p do
			local state = animation_state_component[STATES_3P[i]]

			if state == invalid_player_anim_state then
				state = nil
			end

			temp_states_3p[i] = state
		end

		Unit.animation_set_state(player_unit, unpack(temp_states_3p, 1, num_layers_3p))
	end

	if override_1p then
		table.clear(temp_states_1p)

		local num_layers_1p = animation_state_component.num_layers_1p

		for i = 1, num_layers_1p do
			local state = animation_state_component[STATES_1P[i]]

			if state == invalid_player_anim_state then
				state = nil
			end

			temp_states_1p[i] = state
		end

		Unit.animation_set_state(first_person_unit, unpack(temp_states_1p, 1, num_layers_1p))
	end
end

return PlayerUnitAnimationState
