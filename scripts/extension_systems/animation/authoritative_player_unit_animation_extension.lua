local PlayerUnitAnimationState = require("scripts/extension_systems/animation/utilities/player_unit_animation_state")
local AuthoritativePlayerUnitAnimationExtension = class("AuthoritativePlayerUnitAnimationExtension")
local VARIABLES_INDEXES_RPC_CACHE = {}
local VARIABLES_VALUES_RPC_CACHE = {}

AuthoritativePlayerUnitAnimationExtension.init = function (self, extension_init_context, unit, extension_init_data)
	self._unit = unit
	self._player = extension_init_data.player
	local unit_data = ScriptUnit.extension(unit, "unit_data_system")
	local animation_state = unit_data:write_component("animation_state")

	PlayerUnitAnimationState.init_anim_state_component(animation_state)

	self._animation_state_component = animation_state
	local is_local_unit = extension_init_data.is_local_unit
	self._is_local_unit = is_local_unit
	self._anim_variable_ids_third_person = {}
	self._anim_variable_ids_first_person = {}
end

AuthoritativePlayerUnitAnimationExtension.extensions_ready = function (self, world, unit)
	local first_person_unit = ScriptUnit.extension(unit, "first_person_system"):first_person_unit()
	self._first_person_unit = first_person_unit

	PlayerUnitAnimationState.cache_anim_variable_ids(unit, first_person_unit, self._anim_variable_ids_third_person, self._anim_variable_ids_first_person)
end

AuthoritativePlayerUnitAnimationExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id
end

AuthoritativePlayerUnitAnimationExtension.hot_join_sync = function (self, unit, sender, channel)
	local anim_states = Unit.animation_get_state(unit)
	local seeds = Unit.animation_get_seeds(unit)

	RPC.rpc_sync_anim_state(channel, self._game_object_id, false, anim_states, seeds)
end

AuthoritativePlayerUnitAnimationExtension.anim_event = function (self, event_name)
	local unit = self._unit
	local event_index = Unit.animation_event(unit, event_name)

	PlayerUnitAnimationState.record_animation_state(self._animation_state_component, unit, self._first_person_unit)

	local first_person = false

	Managers.state.game_session:send_rpc_clients_except("rpc_player_anim_event", self._player:channel_id(), self._game_object_id, event_index, first_person)
end

AuthoritativePlayerUnitAnimationExtension.anim_event_with_variable_float = function (self, event_name, variable_name, variable_value)
	local unit = self._unit
	local variable_index = Unit.animation_find_variable(unit, variable_name)

	Unit.animation_set_variable(unit, variable_index, variable_value)

	local event_index = Unit.animation_event(unit, event_name)

	PlayerUnitAnimationState.record_animation_state(self._animation_state_component, unit, self._first_person_unit)

	local first_person = false

	Managers.state.game_session:send_rpc_clients_except("rpc_player_anim_event_variable_float", self._player:channel_id(), self._game_object_id, event_index, variable_index, variable_value, first_person)
end

AuthoritativePlayerUnitAnimationExtension.anim_event_with_variable_floats = function (self, event_name, ...)
	local unit = self._unit

	table.clear(VARIABLES_INDEXES_RPC_CACHE)
	table.clear(VARIABLES_VALUES_RPC_CACHE)

	local num_params = select("#", ...)

	for ii = 1, num_params, 2 do
		local variable_name, variable_value = select(ii, ...)
		local variable_index = Unit.animation_find_variable(unit, variable_name)

		if variable_value and variable_index then
			VARIABLES_INDEXES_RPC_CACHE[#VARIABLES_INDEXES_RPC_CACHE + 1] = variable_index
			VARIABLES_VALUES_RPC_CACHE[#VARIABLES_VALUES_RPC_CACHE + 1] = variable_value

			Unit.animation_set_variable(unit, variable_index, variable_value)
		end
	end

	local event_index = Unit.animation_event(unit, event_name)

	PlayerUnitAnimationState.record_animation_state(self._animation_state_component, unit, self._first_person_unit)

	local first_person = false

	Managers.state.game_session:send_rpc_clients_except("rpc_player_anim_event_variable_floats", self._player:channel_id(), self._game_object_id, event_index, VARIABLES_INDEXES_RPC_CACHE, VARIABLES_VALUES_RPC_CACHE, first_person)
end

AuthoritativePlayerUnitAnimationExtension.anim_event_with_variable_int = function (self, event_name, variable_name, variable_value)
	local unit = self._unit
	local variable_index = Unit.animation_find_variable(unit, variable_name)

	Unit.animation_set_variable(unit, variable_index, variable_value)

	local event_index = Unit.animation_event(unit, event_name)

	PlayerUnitAnimationState.record_animation_state(self._animation_state_component, unit, self._first_person_unit)

	local first_person = false

	Managers.state.game_session:send_rpc_clients_except("rpc_player_anim_event_variable_int", self._player:channel_id(), self._game_object_id, event_index, variable_index, variable_value, first_person)
end

AuthoritativePlayerUnitAnimationExtension.anim_event_1p = function (self, event_name)
	local unit = self._first_person_unit
	local event_index = Unit.animation_event(unit, event_name)

	PlayerUnitAnimationState.record_animation_state(self._animation_state_component, self._unit, self._first_person_unit)

	local is_first_person = true

	Managers.state.game_session:send_rpc_clients_except("rpc_player_anim_event", self._player:channel_id(), self._game_object_id, event_index, is_first_person)
end

AuthoritativePlayerUnitAnimationExtension.anim_event_with_variable_float_1p = function (self, event_name, variable_name, variable_value)
	local first_person_unit = self._first_person_unit
	local variable_index = Unit.animation_find_variable(first_person_unit, variable_name)

	Unit.animation_set_variable(first_person_unit, variable_index, variable_value)

	local event_index = Unit.animation_event(first_person_unit, event_name)

	PlayerUnitAnimationState.record_animation_state(self._animation_state_component, self._unit, first_person_unit)

	local is_first_person = true

	Managers.state.game_session:send_rpc_clients_except("rpc_player_anim_event_variable_float", self._player:channel_id(), self._game_object_id, event_index, variable_index, variable_value, is_first_person)
end

AuthoritativePlayerUnitAnimationExtension.anim_event_with_variable_floats_1p = function (self, event_name, ...)
	local first_person_unit = self._first_person_unit

	table.clear(VARIABLES_INDEXES_RPC_CACHE)
	table.clear(VARIABLES_VALUES_RPC_CACHE)

	local num_params = select("#", ...)

	for ii = 1, num_params, 2 do
		local variable_name, variable_value = select(ii, ...)
		local variable_index = Unit.animation_find_variable(first_person_unit, variable_name)

		if variable_value and variable_index then
			VARIABLES_INDEXES_RPC_CACHE[#VARIABLES_INDEXES_RPC_CACHE + 1] = variable_index
			VARIABLES_VALUES_RPC_CACHE[#VARIABLES_VALUES_RPC_CACHE + 1] = variable_value

			Unit.animation_set_variable(first_person_unit, variable_index, variable_value)
		end
	end

	local event_index = Unit.animation_event(first_person_unit, event_name)

	PlayerUnitAnimationState.record_animation_state(self._animation_state_component, self._unit, first_person_unit)

	local is_first_person = true

	Managers.state.game_session:send_rpc_clients_except("rpc_player_anim_event_variable_floats", self._player:channel_id(), self._game_object_id, event_index, VARIABLES_INDEXES_RPC_CACHE, VARIABLES_VALUES_RPC_CACHE, is_first_person)
end

AuthoritativePlayerUnitAnimationExtension.inventory_slot_wielded = function (self, weapon_template)
	local unit = self._unit
	local first_person_unit = self._first_person_unit
	local is_local_unit = self._is_local_unit

	PlayerUnitAnimationState.set_anim_state_machine(unit, first_person_unit, weapon_template, is_local_unit, self._anim_variable_ids_third_person, self._anim_variable_ids_first_person)
	PlayerUnitAnimationState.record_animation_state(self._animation_state_component, unit, first_person_unit)
end

AuthoritativePlayerUnitAnimationExtension.anim_variable_id = function (self, anim_variable)
	return self._anim_variable_ids_third_person[anim_variable]
end

AuthoritativePlayerUnitAnimationExtension.anim_variable_id_1p = function (self, anim_variable)
	return self._anim_variable_ids_first_person[anim_variable]
end

AuthoritativePlayerUnitAnimationExtension.fixed_update = function (self, unit, dt, t, frame)
	PlayerUnitAnimationState.record_animation_state(self._animation_state_component, unit, self._first_person_unit)
end

AuthoritativePlayerUnitAnimationExtension.destroy = function (self)
	return
end

return AuthoritativePlayerUnitAnimationExtension
