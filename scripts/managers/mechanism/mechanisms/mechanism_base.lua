-- chunkname: @scripts/managers/mechanism/mechanisms/mechanism_base.lua

local MechanismSettings = require("scripts/settings/mechanism/mechanism_settings")
local MechanismBase = class("MechanismBase")

MechanismBase.INTERFACE = {
	"wanted_transition",
	"sync_data",
	"is_allowed_to_reserve_slots",
	"peers_reserved_slots",
	"peer_freed_slot"
}

MechanismBase.init = function (self, mechanism_name, network_event_delegate, mechanism_context, optional_teams)
	self.name = mechanism_name
	self._context = mechanism_context

	local settings = MechanismSettings[mechanism_name]

	self._settings = settings

	local states = settings.states

	self._states = states
	self._states_lookup = table.mirror_table(states)
	self._state_index = 1
	self._state = states[self._state_index]
	self._game_states = settings.game_states or {}
	self._transition_flags = settings.transition_flags or {}
	self._network_event_delegate = network_event_delegate
	self._teams = optional_teams
	self._mechanism_data = {}
end

MechanismBase.settings = function (self)
	return self._settings
end

MechanismBase.profile_changes_are_allowed = function (self)
	return true
end

MechanismBase._set_state = function (self, state)
	Log.info("MechanismBase", "Mechanism %s changing state %s -> %s", self.name, self._state, state)

	self._state_index = self._states_lookup[state]
	self._state = state

	return self._game_states[state]
end

local DONE = true
local NOT_DONE = false
local CHANGED = true
local NOT_CHANGED = false

MechanismBase._proceed_to_next_state = function (self)
	local current_state = self._state
	local required_transition_flag = self._transition_flags[current_state]

	if required_transition_flag and not self._mechanism_data[required_transition_flag] then
		return NOT_CHANGED, NOT_DONE
	end

	local next_index = self._state_index + 1
	local states = self._states

	if next_index > #states then
		return CHANGED, DONE
	else
		self._state_index = next_index

		local state = states[next_index]

		self._state = state

		local optional_game_state = self._game_states[state]

		return CHANGED, NOT_DONE, optional_game_state
	end
end

return MechanismBase
