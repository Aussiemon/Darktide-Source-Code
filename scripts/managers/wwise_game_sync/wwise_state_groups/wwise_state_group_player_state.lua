-- chunkname: @scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_player_state.lua

require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_base")

local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local STATES = WwiseGameSyncSettings.state_groups.player_state
local CHARACTER_STATE = STATES.character_state
local CHARACTER_STATUS = STATES.character_status
local INTERACTION = STATES.interaction
local FAST_PARAMETER_UPDATE_RATE = 1 / GameParameters.tick_rate * 4
local WwiseStateGroupPlayerState = class("WwiseStateGroupPlayerState", "WwiseStateGroupBase")

WwiseStateGroupPlayerState.init = function (self, wwise_world, wwise_game_sync_name)
	WwiseStateGroupPlayerState.super.init(self, wwise_world, wwise_game_sync_name)

	self._next_fast_parameter_update = 0
end

WwiseStateGroupPlayerState.update = function (self, dt, t)
	WwiseStateGroupPlayerState.super.update(self)

	local player_unit = self._player_unit

	if not player_unit or not ALIVE[player_unit] then
		return
	end

	if t > self._next_fast_parameter_update then
		local wwise_state = self:_wwise_state()

		self:_set_wwise_state(wwise_state)

		self._next_fast_parameter_update = t + FAST_PARAMETER_UPDATE_RATE
	end
end

WwiseStateGroupPlayerState.set_followed_player_unit = function (self, player_unit)
	local unit_data_extension = player_unit and ScriptUnit.has_extension(player_unit, "unit_data_system")

	if unit_data_extension then
		self._player_unit = player_unit
		self._force_field_system = Managers.state.extension:system("force_field_system")
		self._health_extension = ScriptUnit.extension(player_unit, "health_system")
		self._character_state_read_component = unit_data_extension:read_component("character_state")
		self._character_interacting_state_read_component = unit_data_extension:read_component("interacting_character_state")
		self._scanning_read_component = unit_data_extension:read_component("scanning")
		self._first_person_read_component = unit_data_extension:read_component("first_person")
	else
		self._player_unit = nil
		self._force_field_system = nil
		self._health_extension = nil
		self._character_state_read_component = nil
		self._character_interacting_state_read_component = nil
		self._scanning_read_component = nil
		self._first_person_read_component = nil
	end
end

WwiseStateGroupPlayerState._wwise_state = function (self)
	local character_state_read_component = self._character_state_read_component
	local character_state_name = character_state_read_component.state_name
	local wwise_player_state = CHARACTER_STATE[character_state_name]

	if character_state_name == "interacting" then
		local character_interacting_state_read_component = self._character_interacting_state_read_component
		local interaction_template_name = character_interacting_state_read_component.interaction_template

		wwise_player_state = INTERACTION[interaction_template_name] or wwise_player_state
	end

	local scanning_read_component = self._scanning_read_component

	wwise_player_state = scanning_read_component.is_active and "auspex_scanner" or wwise_player_state

	local is_in_psyker_force_field, _, force_field_extension = self._force_field_system:is_object_inside_force_field(self._first_person_read_component.position, 0.05, true)
	local is_in_psyker_force_field_sphere = is_in_psyker_force_field and force_field_extension:is_sphere_shield()

	if not wwise_player_state and is_in_psyker_force_field_sphere then
		wwise_player_state = "psyker_shield"
	end

	local num_wounds = self._health_extension:num_wounds()
	local last_wound = num_wounds == 1

	if not wwise_player_state and last_wound then
		wwise_player_state = CHARACTER_STATUS.last_wound
	end

	return wwise_player_state or STATES.none
end

return WwiseStateGroupPlayerState
