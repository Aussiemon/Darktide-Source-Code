-- chunkname: @scripts/extension_systems/trigger/trigger_conditions/trigger_condition_luggable_inside.lua

require("scripts/extension_systems/trigger/trigger_conditions/trigger_condition_base")

local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local TriggerSettings = require("scripts/extension_systems/trigger/trigger_settings")
local PROJECTILE_MOVING_STATES = ProjectileLocomotionSettings.moving_states
local VOLUME_NAME = TriggerSettings.trigger_volume_name
local TriggerConditionLuggableInside = class("TriggerConditionLuggableInside", "TriggerConditionBase")

TriggerConditionLuggableInside.init = function (self, engine_volume_event_system, is_server, volume_unit, only_once, condition_name, evaluates_bots)
	TriggerConditionLuggableInside.super.init(self, engine_volume_event_system, is_server, volume_unit, only_once, condition_name, evaluates_bots)

	self._sockets_in_volume = {}

	self:_setup_sockets_in_volume()
end

TriggerConditionLuggableInside._setup_sockets_in_volume = function (self)
	local volume_unit = self._volume_unit
	local luggable_socket_system = Managers.state.extension:system("luggable_socket_system")
	local socket_units = luggable_socket_system:socket_units()

	for ii = 1, #socket_units do
		local socket_unit = socket_units[ii]
		local socket_unit_pos = Unit.world_position(socket_unit, 1)
		local is_inside = Unit.is_point_inside_volume(volume_unit, VOLUME_NAME, socket_unit_pos)

		if is_inside then
			self._sockets_in_volume[#self._sockets_in_volume + 1] = socket_unit
		end
	end
end

TriggerConditionLuggableInside.on_volume_enter = function (self, entering_unit, dt, t)
	local luggable_extension = ScriptUnit.has_extension(entering_unit, "luggable_system")

	if luggable_extension then
		local locomotion_extension = ScriptUnit.extension(entering_unit, "locomotion_system")

		if locomotion_extension then
			local current_state = locomotion_extension:current_state()

			if PROJECTILE_MOVING_STATES[current_state] then
				self:_socket_luggable(entering_unit)

				return true
			end
		end
	end

	return false
end

TriggerConditionLuggableInside._socket_luggable = function (self, luggable_unit)
	local closest_distance, closest_socket_extension
	local sockets_in_volume = self._sockets_in_volume

	for ii = 1, #sockets_in_volume do
		local socket_unit = sockets_in_volume[ii]
		local socket_unit_position = Unit.world_position(socket_unit, 1)
		local luggable_position = Unit.world_position(luggable_unit, 1)
		local socket_extension = ScriptUnit.extension(socket_unit, "luggable_socket_system")

		if socket_extension:is_socketable(luggable_unit) then
			local distance = Vector3.distance(socket_unit_position, luggable_position)

			if not closest_distance or distance < closest_distance then
				closest_distance = distance
				closest_socket_extension = socket_extension
			end
		end
	end

	if closest_socket_extension then
		closest_socket_extension:add_overlapping_unit(luggable_unit)
	end
end

return TriggerConditionLuggableInside
