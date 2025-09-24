-- chunkname: @scripts/extension_systems/chest/chest_extension.lua

local NetworkLookup = require("scripts/network_lookup/network_lookup")
local ChestExtension = class("ChestExtension")

ChestExtension.UPDATE_DISABLED_BY_DEFAULT = true

local STATES = table.enum("closed", "locked", "opened")

ChestExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._current_state = STATES.closed
	self._interaction_delay = 0
	self._containing_pickups = {}
	self._locked_pickups = {}
	self._state_changed = false
	self._owner_system = extension_init_context.owner_system
end

ChestExtension.setup_from_component = function (self, locked, interaction_delay)
	if locked then
		self._current_state = STATES.locked
	end

	self._interaction_delay = interaction_delay
end

ChestExtension.on_gameplay_post_init = function (self, unit)
	if self._current_state == STATES.locked then
		local interactee_extension = ScriptUnit.extension(self._unit, "interactee_system")

		interactee_extension:set_block_text("loc_action_interaction_locked")
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
	self._containing_pickups[index] = pickup_name
end

ChestExtension.lock = function (self)
	if self._current_state == STATES.opened then
		return
	end

	self:set_current_state(STATES.locked)
end

ChestExtension.unlock = function (self)
	if self._current_state == STATES.opened then
		return
	end

	self:set_current_state(STATES.closed)
end

ChestExtension.current_state = function (self)
	return self._current_state
end

ChestExtension.rpc_set_chest_state = function (self, state)
	self:set_current_state(state)
end

ChestExtension.set_current_state = function (self, state)
	if state == STATES.locked then
		local interactee_extension = ScriptUnit.extension(self._unit, "interactee_system")

		interactee_extension:set_block_text("loc_action_interaction_locked")
	elseif self._current_state == STATES.locked then
		local interactee_extension = ScriptUnit.extension(self._unit, "interactee_system")

		interactee_extension:set_block_text()
	end

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

ChestExtension.is_open = function (self)
	return self._current_state == STATES.opened
end

ChestExtension.open = function (self, opening_unit)
	local unit = self._unit
	local pickup_spawner_extension = ScriptUnit.extension(unit, "pickup_system")
	local containing_pickups = self._containing_pickups
	local chest_size = pickup_spawner_extension:spawner_count()

	Managers.stats:record_team("hook_team_chest_opened")

	for i = 1, chest_size do
		if containing_pickups[i] or pickup_spawner_extension:request_rubberband_pickup(i) then
			local check_reserve = false
			local spawned_unit, _ = pickup_spawner_extension:spawn_specific_item(i, containing_pickups[i], check_reserve)

			if spawned_unit then
				local interactee_ext = ScriptUnit.has_extension(spawned_unit, "interactee_system")

				if interactee_ext then
					interactee_ext:set_active(false)

					self._locked_pickups[interactee_ext] = self._interaction_delay
				end
			end
		end
	end

	local opening_player = Managers.state.player_unit_spawn:owner(opening_unit)

	if opening_player then
		local chest_position = POSITION_LOOKUP[unit]

		Managers.telemetry_events:chest_opened(opening_player, chest_size, chest_position, containing_pickups)
	end

	self:set_current_state(STATES.opened)
	self._owner_system:enable_update_function(self.__class_name, "update", unit, self)
	table.clear(containing_pickups)
end

return ChestExtension
