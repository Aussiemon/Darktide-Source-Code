require("scripts/extension_systems/trigger/trigger_conditions/trigger_condition_base")

local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local projectile_moving_states = ProjectileLocomotionSettings.moving_states
local TriggerConditionLuggableInside = class("TriggerConditionLuggableInside", "TriggerConditionBase")

TriggerConditionLuggableInside.init = function (self, unit, condition_name, evaluates_bots)
	TriggerConditionLuggableInside.super.init(self, unit, condition_name, evaluates_bots)

	self._sockets_in_volume = {}

	self:_setup_sockets_in_volume()
end

TriggerConditionLuggableInside._setup_sockets_in_volume = function (self)
	local unit = self._unit
	local luggable_socket_system = Managers.state.extension:system("luggable_socket_system")
	local socket_units = luggable_socket_system:socket_units()

	for i = 1, #socket_units, 1 do
		local socket_unit = socket_units[i]
		local unit_pos = Unit.world_position(socket_unit, 1)
		local is_inside = Unit.is_point_inside_volume(unit, "c_volume", unit_pos)

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

			if projectile_moving_states[current_state] then
				self:_socket_luggable(entering_unit)

				return true
			end
		end
	end

	return false
end

TriggerConditionLuggableInside._socket_luggable = function (self, luggable_unit)
	local sockets_in_volume = self._sockets_in_volume
	local closest_distance, closest_socket_extension = nil

	for i = 1, #sockets_in_volume, 1 do
		local socket_unit = sockets_in_volume[i]
		local slot_position = Unit.world_position(socket_unit, 1)
		local luggable_position = Unit.world_position(luggable_unit, 1)
		local socket_extension = ScriptUnit.extension(socket_unit, "luggable_socket_system")

		if socket_extension:is_socketable(luggable_unit) then
			local distance = Vector3.distance(slot_position, luggable_position)

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
