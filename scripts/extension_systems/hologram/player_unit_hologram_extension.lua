local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitHologramExtension = class("PlayerUnitHologramExtension")
local UPDATE_WAITING_PERIOD = 0.25
local UNITS = {
	human = "content/characters/player/human/attachments_base/shared/see_through_skeleton/see_through_skeleton",
	ogryn = "content/characters/player/ogryn/attachments_base/shared/see_through_skeleton/see_through_skeleton"
}

PlayerUnitHologramExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	local is_server = extension_init_context.is_server
	self._is_server = is_server

	if not is_server then
		self._game_session_id = game_object_data_or_game_session
		self._game_object_id = nil_or_game_object_id
	end

	self._world = Unit.world(unit)
	self._unit = unit
	self._timer = 0
	self._character_state_component = nil
	self._target_health_extension = nil
	self._hologram_unit = nil
	self._unit_resource = UNITS[extension_init_data.breed_name]
	self._health = 1
	self._was_disabled = false
end

PlayerUnitHologramExtension.game_object_initialized = function (self, session, object_id)
	self._game_session_id = session
	self._game_object_id = object_id
end

PlayerUnitHologramExtension.extensions_ready = function (self, world, unit)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._character_state_component = unit_data_extension:read_component("character_state")
	self._target_health_extension = ScriptUnit.has_extension(unit, "health_system")
end

local _despawn = nil

PlayerUnitHologramExtension.destroy = function (self)
	local hologram_unit = self._hologram_unit

	if hologram_unit then
		_despawn(self._world, hologram_unit)
	end
end

local _spawn = nil

PlayerUnitHologramExtension.update = function (self, unit, dt, t)
	self._timer = self._timer + dt

	if self._timer < UPDATE_WAITING_PERIOD then
		return
	end

	self._timer = 0
	local state_name = self._character_state_component.state_name
	local hologram_unit = self._hologram_unit

	if state_name == "dead" then
		if hologram_unit then
			_despawn(self._world, hologram_unit)

			self._hologram_unit = nil
		end

		return
	else
		if not hologram_unit then
			hologram_unit = _spawn(self._world, self._unit_resource, self._unit)
			self._hologram_unit = hologram_unit
		end

		local health_percent = self._target_health_extension:current_health_percent()
		local is_disabled = PlayerUnitStatus.is_disabled(self._character_state_component)

		if health_percent == self._health and is_disabled == self._was_disabled then
			return
		end

		local shader_input = 1

		if not is_disabled then
			shader_input = 1 - health_percent
		end

		Unit.set_scalar_for_materials(hologram_unit, "health_value", shader_input, false)

		self._health = health_percent
		self._was_disabled = is_disabled
	end
end

function _spawn(world, resource, parent_unit)
	if not world then
		return nil
	end

	local hologram_unit = World.spawn_unit_ex(world, resource)

	World.link_unit(world, hologram_unit, 1, parent_unit, 1, true)
	Unit.set_unit_culling(hologram_unit, false, true)

	local player_visibility_system = ScriptUnit.has_extension(parent_unit, "player_visibility_system")

	if player_visibility_system and not player_visibility_system:visible() then
		Unit.set_unit_visibility(hologram_unit, false, true)
	end

	return hologram_unit
end

function _despawn(world, hologram_unit)
	World.unlink_unit(world, hologram_unit, true)
	World.destroy_unit(world, hologram_unit)
end

return PlayerUnitHologramExtension
