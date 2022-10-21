local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitOutlineExtension = class("PlayerUnitOutlineExtension")
local UPDATE_WAITING_PERIOD = 0.25

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
	self._is_disabled = false
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
	local player_outline_mode = DevParameters.player_outlines_mode
	local player_outline_type = DevParameters.player_outlines_type

	if player_outline_mode ~= "off" and player_outline_mode ~= "skeleton" then
		self._current_outline = "default_" .. player_outline_type .. "_" .. player_outline_mode

		if not self._is_local_unit then
			self._outline_system:add_outline(unit, self._current_outline)
		end
	end

	self._player_outline_mode = player_outline_mode
	self._player_outline_type = player_outline_type
end

PlayerUnitOutlineExtension.destroy = function (self)
	return
end

local IGNORED_DISABLED_OUTLINE_STATES = {
	catapulted = true,
	consumed = true
}

PlayerUnitOutlineExtension.update = function (self, unit, dt, t)
	self._timer = self._timer + dt

	if self._timer < UPDATE_WAITING_PERIOD then
		return
	end

	self._timer = 0
	local player_outline_mode = DevParameters.player_outlines_mode

	if not self._is_local_unit then
		local player_outline_type = DevParameters.player_outlines_type

		if player_outline_mode ~= self._player_outline_mode or player_outline_type ~= self._player_outline_type then
			local previous_player_outline = self._current_outline

			self._outline_system:remove_outline(unit, previous_player_outline)

			if player_outline_mode ~= "off" and player_outline_mode ~= "skeleton" then
				local new_outline = "default_" .. player_outline_type .. "_" .. player_outline_mode

				self._outline_system:add_outline(unit, new_outline)

				self._current_outline = new_outline

				Log.info("OutlineSystem", "Swap: " .. (previous_player_outline or "nil") .. " to: " .. new_outline)
			else
				Log.info("OutlineSystem", "Swap: " .. (previous_player_outline or "nil") .. " to: " .. player_outline_mode)
			end

			self._player_outline_mode = player_outline_mode
			self._player_outline_type = player_outline_type
		end
	end

	if player_outline_mode ~= "off" and player_outline_mode ~= "skeleton" then
		local character_state_component = self._character_state_component
		local state_name = character_state_component.state_name
		local is_disabled = PlayerUnitStatus.is_disabled(character_state_component)
		local was_disabled = self._is_disabled

		if is_disabled and not was_disabled and not IGNORED_DISABLED_OUTLINE_STATES[state_name] then
			self._outline_system:add_outline(unit, "knocked_down")

			self._is_disabled = is_disabled
		elseif was_disabled and not is_disabled then
			self._outline_system:remove_outline(unit, "knocked_down")

			self._is_disabled = is_disabled
		end
	end
end

return PlayerUnitOutlineExtension
