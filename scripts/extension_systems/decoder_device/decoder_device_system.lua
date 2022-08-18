require("scripts/extension_systems/decoder_device/decoder_device_extension")

local DecoderDeviceSystem = class("DecoderDeviceSystem", "ExtensionSystemBase")
local RPCS = {
	"rpc_decoder_device_hot_join",
	"rpc_decoder_device_place_unit",
	"rpc_decoder_device_enable_unit",
	"rpc_decoder_device_decode_interrupt",
	"rpc_decoder_device_start_decode",
	"rpc_decoder_device_finished"
}

DecoderDeviceSystem.init = function (self, context, system_init_data, ...)
	DecoderDeviceSystem.super.init(self, context, system_init_data, ...)

	self._network_event_delegate = context.network_event_delegate

	self._network_event_delegate:register_session_events(self, unpack(RPCS))
end

DecoderDeviceSystem.destroy = function (self)
	self._network_event_delegate:unregister_events(unpack(RPCS))
	DecoderDeviceSystem.super.destroy(self)
end

DecoderDeviceSystem.hot_join_sync = function (self, sender, channel)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		local unit_is_enabled = extension:unit_is_enabled()
		local is_placed = extension:is_placed()
		local started_decode = extension:started_decode()
		local decoding_interrupted = extension:decoding_interrupted()
		local is_finished = extension:is_finished()
		local level_unit_id = Managers.state.unit_spawner:level_index(unit)

		if level_unit_id then
			RPC.rpc_decoder_device_hot_join(channel, level_unit_id, unit_is_enabled, is_placed, started_decode, decoding_interrupted, is_finished)
		end
	end
end

DecoderDeviceSystem.rpc_decoder_device_hot_join = function (self, channel_id, unit_id, unit_is_enabled, is_placed, started_decode, decoding_interrupted, is_finished)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:hot_join_sync(unit_is_enabled, is_placed, started_decode, decoding_interrupted, is_finished)
end

DecoderDeviceSystem.rpc_decoder_device_enable_unit = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:enable_unit()
end

DecoderDeviceSystem.rpc_decoder_device_place_unit = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:place_unit()
end

DecoderDeviceSystem.rpc_decoder_device_start_decode = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:start_decode()
end

DecoderDeviceSystem.rpc_decoder_device_decode_interrupt = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:decode_interrupt()
end

DecoderDeviceSystem.rpc_decoder_device_finished = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:finished()
end

return DecoderDeviceSystem
