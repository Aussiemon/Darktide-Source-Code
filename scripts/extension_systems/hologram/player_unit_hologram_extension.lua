local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitHologramExtension = class("PlayerUnitHologramExtension")
local UPDATE_WAITING_PERIOD = 0.5
local UNITS = {
	human = {
		default = "content/characters/player/human/attachments_base/shared/see_through_skeleton/see_through_skeleton",
		consumed = "content/characters/player/human/attachments_base/shared/see_through_skeleton/see_through_skeleton_bon"
	},
	ogryn = {
		default = "content/characters/player/ogryn/attachments_base/shared/see_through_skeleton/see_through_skeleton",
		consumed = "content/characters/player/ogryn/attachments_base/shared/see_through_skeleton/see_through_skeleton_bon"
	}
}
local SWITCH_STATES = {
	consumed = true
}
local IGNORED_DISABLED_OUTLINE_STATES = {
	grabbed = true,
	catapulted = true
}
local _spawn_hologram_unit, _despawn_hologram_unit = nil

PlayerUnitHologramExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	local is_server = extension_init_context.is_server
	self._is_server = is_server

	if not is_server then
		self._game_session_id = game_object_data_or_game_session
		self._game_object_id = nil_or_game_object_id
	end

	self._world = extension_init_context.world
	self._unit = unit
	self._next_update_t = 0
	self._character_state_component = nil
	self._target_health_extension = nil
	self._hologram_unit = nil
	self._unit_resources = UNITS[extension_init_data.breed_name]
	self._health_percent = 1
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

PlayerUnitHologramExtension.destroy = function (self)
	local hologram_unit = self._hologram_unit

	if hologram_unit then
		_despawn_hologram_unit(self._world, hologram_unit)
	end
end

PlayerUnitHologramExtension.update = function (self, unit, dt, t)
	local hologram_unit = self._hologram_unit
	local world = self._world

	if t < self._next_update_t then
		return
	end

	self._next_update_t = t + UPDATE_WAITING_PERIOD
	local state_name = self._character_state_component.state_name
	local should_switch_unit = SWITCH_STATES[state_name] and self._current_spawned_state ~= state_name or SWITCH_STATES[self._current_spawned_state] and not SWITCH_STATES[state_name]

	if state_name == "dead" then
		if hologram_unit then
			_despawn_hologram_unit(world, hologram_unit)

			self._hologram_unit = nil
		end

		return
	else
		if not hologram_unit or should_switch_unit then
			if hologram_unit then
				_despawn_hologram_unit(world, hologram_unit)
			end

			hologram_unit = _spawn_hologram_unit(world, self._unit_resources, self._unit, state_name)
			self._hologram_unit = hologram_unit
			self._current_spawned_state = state_name
		end

		local health_percent = self._target_health_extension:current_health_percent()
		local is_disabled = PlayerUnitStatus.is_disabled(self._character_state_component) and not IGNORED_DISABLED_OUTLINE_STATES[state_name]

		if health_percent == self._health_percent and is_disabled == self._was_disabled then
			return
		end

		local shader_input = 1

		if not is_disabled then
			shader_input = 1 - health_percent
		end

		Unit.set_scalar_for_materials(hologram_unit, "health_value", shader_input, false)

		self._health_percent = health_percent
		self._was_disabled = is_disabled
	end
end

function _spawn_hologram_unit(world, resources, parent_unit, state_name)
	if not world then
		return nil
	end

	local resource = SWITCH_STATES[state_name] and resources[state_name] or resources.default
	local hologram_unit = World.spawn_unit_ex(world, resource)

	World.link_unit(world, hologram_unit, 1, parent_unit, 1, true)
	Unit.set_unit_culling(hologram_unit, false, true)

	local player_visibility_extension = ScriptUnit.has_extension(parent_unit, "player_visibility_system")

	if player_visibility_extension and not player_visibility_extension:visible() then
		Unit.set_unit_visibility(hologram_unit, false, true)
	end

	return hologram_unit
end

function _despawn_hologram_unit(world, hologram_unit)
	if not world then
		return
	end

	World.unlink_unit(world, hologram_unit, true)
	World.destroy_unit(world, hologram_unit)
end

return PlayerUnitHologramExtension
