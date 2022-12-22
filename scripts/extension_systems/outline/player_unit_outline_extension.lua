local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitOutlineExtension = class("PlayerUnitOutlineExtension")
local UPDATE_WAITING_PERIOD = 0.5

PlayerUnitOutlineExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	local is_server = extension_init_context.is_server
	self._is_server = is_server
	self._is_local_unit = extension_init_data.is_local_unit and extension_init_data.is_human_controlled

	if not is_server then
		self._game_session_id = game_object_data_or_game_session
		self._game_object_id = nil_or_game_object_id
	end

	self._world = Unit.world(unit)
	self._unit = unit
	self._timer = 0
	self._added_disabled_outline = false
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
	local save_data = Managers.save:account_data()
	local interface_settings = save_data.interface_settings
	local player_outlines_enabled = false

	if player_outlines_enabled and not self._is_local_unit then
		self._outline_system:add_outline(unit, "default_outlines_obscured")
	end

	self._player_outlines_enabled = player_outlines_enabled
end

PlayerUnitOutlineExtension.destroy = function (self)
	return
end

local IGNORED_DISABLED_OUTLINE_STATES = {
	catapulted = true,
	consumed = true
}

PlayerUnitOutlineExtension.update = function (self, unit, dt, t)
	local added_outline = self._added_disabled_outline

	if self._player_outlines_enabled then
		local character_state_component = self._character_state_component
		local state_name = character_state_component.state_name
		local is_disabled = PlayerUnitStatus.is_disabled(character_state_component)

		if is_disabled and not added_outline and not IGNORED_DISABLED_OUTLINE_STATES[state_name] then
			self._outline_system:add_outline(unit, "knocked_down")

			self._added_disabled_outline = true
		elseif added_outline and not is_disabled then
			self._outline_system:remove_outline(unit, "knocked_down")

			self._added_disabled_outline = false
		end
	elseif added_outline then
		self._outline_system:remove_outline(unit, "knocked_down")

		self._added_disabled_outline = false
	end

	self._timer = self._timer + dt

	if self._timer < UPDATE_WAITING_PERIOD then
		return
	end

	self._timer = 0
	local save_data = Managers.save:account_data()
	local interface_settings = save_data.interface_settings
	local player_outlines_enabled = false

	if not self._is_local_unit and player_outlines_enabled ~= self._player_outlines_enabled then
		if not player_outlines_enabled then
			self._outline_system:remove_outline(unit, "default_outlines_obscured")
		else
			self._outline_system:add_outline(unit, "default_outlines_obscured")
		end

		self._player_outlines_enabled = player_outlines_enabled
	end
end

return PlayerUnitOutlineExtension
