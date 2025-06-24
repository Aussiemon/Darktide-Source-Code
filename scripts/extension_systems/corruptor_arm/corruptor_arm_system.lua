-- chunkname: @scripts/extension_systems/corruptor_arm/corruptor_arm_system.lua

require("scripts/extension_systems/corruptor_arm/corruptor_arm_extension")

local CorruptorArmSystem = class("CorruptorArmSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_set_animation_target",
}

CorruptorArmSystem.init = function (self, context, ...)
	CorruptorArmSystem.super.init(self, context, ...)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

CorruptorArmSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	CorruptorArmSystem.super.destroy(self)
end

CorruptorArmSystem.on_gameplay_post_init = function (self, level)
	self:call_gameplay_post_init_on_extensions(level)
end

CorruptorArmSystem.rpc_set_animation_target = function (self, channel_id, level_unit_id, target_pos, speed_multiplier_type_id, optional_hot_join_animation_pos)
	local unit = Managers.state.unit_spawner:unit(level_unit_id, true)
	local extension = self._unit_to_extension_map[unit]
	local speed_multiplier_type = NetworkLookup.corruptor_arm_animation_speed_types[speed_multiplier_type_id]

	extension:set_animation_target(target_pos, speed_multiplier_type, optional_hot_join_animation_pos)
end

return CorruptorArmSystem
