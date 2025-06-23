-- chunkname: @scripts/extension_systems/pickup_animation/pickup_animation_system.lua

require("scripts/extension_systems/pickup_animation/pickup_animation_extension")

local PickupAnimationSystem = class("PickupAnimationSystem", "ExtensionSystemBase")
local RPCS = {
	"rpc_start_pickup_animation",
	"rpc_start_place_animation"
}

PickupAnimationSystem.init = function (self, context, system_init_data, ...)
	PickupAnimationSystem.super.init(self, context, system_init_data, ...)

	self._network_event_delegate = context.network_event_delegate

	self._network_event_delegate:register_session_events(self, unpack(RPCS))
end

PickupAnimationSystem.start_animation_to_unit = function (self, pickup_unit, destination_unit)
	local pickup_animation_extension = self._unit_to_extension_map[pickup_unit]

	if pickup_animation_extension then
		pickup_animation_extension:start_pickup_animation(destination_unit)

		if self._is_server then
			local unit_spawner_manager = Managers.state.unit_spawner
			local pickup_is_level_unit, pickup_id = unit_spawner_manager:game_object_id_or_level_index(pickup_unit)
			local end_is_level_unit, end_id = unit_spawner_manager:game_object_id_or_level_index(destination_unit)

			Managers.state.game_session:send_rpc_clients("rpc_start_pickup_animation", pickup_id, pickup_is_level_unit, end_id, end_is_level_unit)
		end

		return true
	end

	return false
end

PickupAnimationSystem.start_animation_from_unit = function (self, pickup_unit, from_unit)
	local pickup_animation_extension = self._unit_to_extension_map[pickup_unit]

	if pickup_animation_extension then
		pickup_animation_extension:start_place_animation(from_unit)

		if self._is_server then
			local unit_spawner_manager = Managers.state.unit_spawner
			local pickup_is_level_unit, pickup_id = unit_spawner_manager:game_object_id_or_level_index(pickup_unit)
			local end_is_level_unit, end_id = unit_spawner_manager:game_object_id_or_level_index(from_unit)

			Managers.state.game_session:send_rpc_clients("rpc_start_place_animation", pickup_id, pickup_is_level_unit, end_id, end_is_level_unit)
		end

		return true
	end

	return false
end

PickupAnimationSystem.rpc_start_pickup_animation = function (self, channel_id, pickup_id, pickup_is_level_unit, end_id, end_is_level_unit)
	local unit_spawner_manager = Managers.state.unit_spawner
	local pickup_unit = unit_spawner_manager:unit(pickup_id, pickup_is_level_unit)
	local end_unit = unit_spawner_manager:unit(end_id, end_is_level_unit)
	local pickup_animation_extension = self._unit_to_extension_map[pickup_unit]

	if pickup_animation_extension then
		pickup_animation_extension:start_pickup_animation(end_unit)
	end
end

PickupAnimationSystem.rpc_start_place_animation = function (self, channel_id, pickup_id, pickup_is_level_unit, end_id, end_is_level_unit)
	local unit_spawner_manager = Managers.state.unit_spawner
	local pickup_unit = unit_spawner_manager:unit(pickup_id, pickup_is_level_unit)
	local end_unit = unit_spawner_manager:unit(end_id, end_is_level_unit)
	local pickup_animation_extension = self._unit_to_extension_map[pickup_unit]

	if pickup_animation_extension then
		pickup_animation_extension:start_place_animation(end_unit)
	end
end

PickupAnimationSystem.destroy = function (self)
	self._network_event_delegate:unregister_events(unpack(RPCS))
end

return PickupAnimationSystem
