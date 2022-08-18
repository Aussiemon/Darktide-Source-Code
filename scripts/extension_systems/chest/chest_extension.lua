local NetworkLookup = require("scripts/network_lookup/network_lookup")
local ChestExtension = class("ChestExtension")
ChestExtension.UPDATE_DISABLED_BY_DEFAULT = true
local CHEST_LOCK_DELAY = 0.5
local STATES = table.enum("closed", "locked", "opened")

ChestExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._current_state = STATES.closed
	self._containing_pickups = {}
	self._locked_pickups = {}
	self._chest_size = 0
	self._state_changed = false
	self._owner_system = extension_init_context.owner_system
end

ChestExtension.setup_from_component = function (self, locked)
	if locked then
		self._current_state = STATES.locked
	end
end

ChestExtension.hot_join_sync = function (self, unit, sender, channel)
	if self._state_changed then
		local unit_level_index = Managers.state.unit_spawner:level_index(unit)
		local state_lookup_id = NetworkLookup.chest_states[self._current_state]

		RPC.rpc_chest_hot_join(channel, unit_level_index, state_lookup_id)
	end
end

ChestExtension.update = function (self, unit, dt, t)
	local finished = true
	local locked_pickups = self._locked_pickups

	for interactee, timer in pairs(locked_pickups) do
		timer = timer - dt

		if timer > 0 then
			finished = false
			locked_pickups[interactee] = timer
		else
			interactee:set_active(true)

			locked_pickups[interactee] = nil
		end
	end

	if finished then
		self._owner_system:disable_update_function(self.__class_name, "update", self._unit, self)
	end
end

ChestExtension.reserve_pickup = function (self, index, pickup_name)
	fassert(self._is_server, "[ChestExtension] Server only method.")
	fassert(self._containing_pickups[index] == nil, "[ChestExtension] Chest is already containing a pickup")
	fassert(self._current_state ~= STATES.opened, "[ChestExtension] Can't place an item in an opened chest")

	self._containing_pickups[index] = pickup_name

	if self._chest_size < index then
		self._chest_size = index
	end
end

ChestExtension.current_state = function (self)
	return self._current_state
end

ChestExtension.rpc_set_chest_state = function (self, state)
	self:set_current_state(state)
end

ChestExtension.set_current_state = function (self, state)
	self._current_state = state

	if self._is_server then
		self._state_changed = true
		local unit = self._unit
		local unit_level_index = Managers.state.unit_spawner:level_index(unit)
		local state_id = NetworkLookup.chest_states[state]
		local game_session_manager = Managers.state.game_session

		game_session_manager:send_rpc_clients("rpc_chest_set_state", unit_level_index, state_id)
	end
end

ChestExtension.is_interactable = function (self)
	return self._current_state == STATES.closed
end

ChestExtension.open = function (self)
	fassert(self._is_server, "[ChestExtension] Server only method.")
	fassert(self._current_state == STATES.closed, "[ChestExtension] invalid state.")
	self:set_current_state(STATES.opened)

	local pickup_spawner_extension = ScriptUnit.extension(self._unit, "pickup_system")
	local containing_pickups = self._containing_pickups
	local chest_size = self._chest_size

	for i = 1, chest_size do
		if containing_pickups[i] ~= nil then
			local check_reserve = false
			local unit, _ = pickup_spawner_extension:spawn_specific_item(i, containing_pickups[i], check_reserve)

			if unit then
				local interactee_ext = ScriptUnit.has_extension(unit, "interactee_system")

				if interactee_ext then
					interactee_ext:set_active(false)

					self._locked_pickups[interactee_ext] = CHEST_LOCK_DELAY
				end
			end
		end
	end

	self._owner_system:enable_update_function(self.__class_name, "update", self._unit, self)
	table.clear(containing_pickups)
end

return ChestExtension
