-- chunkname: @scripts/extension_systems/outline/player_unit_outline_extension.lua

local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitOutlineExtension = class("PlayerUnitOutlineExtension")
local IGNORED_DISABLED_OUTLINE_STATES = {
	catapulted = true,
	consumed = true,
	grabbed = true,
}
local UPDATE_WAITING_PERIOD = 0.5

PlayerUnitOutlineExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	local is_server = extension_init_context.is_server

	self._is_server = is_server
	self._is_local_human = extension_init_data.is_local_unit and extension_init_data.is_human_controlled

	if not is_server then
		self._game_session_id = game_object_data_or_game_session
		self._game_object_id = nil_or_game_object_id
	end

	self._world = extension_init_context.world
	self._unit = unit
	self._next_update_t = 0
end

PlayerUnitOutlineExtension.game_object_initialized = function (self, session, object_id)
	self._game_session_id = session
	self._game_object_id = object_id
end

PlayerUnitOutlineExtension.extensions_ready = function (self, world, unit)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local outline_system = Managers.state.extension:system("outline_system")
	local smart_tag_system = Managers.state.extension:system("smart_tag_system")

	self._character_state_component = unit_data_extension:read_component("character_state")
	self._outline_system = outline_system
	self._smart_tag_system = smart_tag_system
end

PlayerUnitOutlineExtension.destroy = function (self)
	return
end

return PlayerUnitOutlineExtension
