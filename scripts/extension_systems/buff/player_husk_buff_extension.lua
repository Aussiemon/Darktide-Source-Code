local BuffExtensionInterface = require("scripts/extension_systems/buff/buff_extension_interface")
local PlayerHuskBuffExtension = class("PlayerHuskBuffExtension")
local RPCS = {
	"rpc_add_buff",
	"rpc_remove_buff",
	"rpc_buff_proc_set_active_time"
}
local EMPTY_TABLE = {}

PlayerHuskBuffExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id, owner_id)
	self._world = extension_init_context.world
	self._unit = unit
	self._game_object_id = game_object_id
	self._game_session = game_session
	self._player = extension_init_data.player
	local network_event_delegate = extension_init_context.network_event_delegate

	network_event_delegate:register_session_unit_events(self, self._game_object_id, unpack(RPCS))

	self._network_event_delegate = network_event_delegate
end

PlayerHuskBuffExtension.destroy = function (self)
	self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(RPCS))
end

PlayerHuskBuffExtension.has_buff_id = function (self)
	return
end

PlayerHuskBuffExtension.has_unique_buff_id = function (self)
	return
end

PlayerHuskBuffExtension.has_keyword = function (self)
	return
end

PlayerHuskBuffExtension.keywords = function (self)
	return
end

PlayerHuskBuffExtension.rpc_add_buff = function (self, channel_id, game_object_id)
	return
end

PlayerHuskBuffExtension.rpc_remove_buff = function (self, channel_id, game_object_id)
	return
end

PlayerHuskBuffExtension.rpc_buff_proc_set_active_time = function (self, channel_id, game_object_id, server_index, activation_time)
	return
end

PlayerHuskBuffExtension.stat_buffs = function (self)
	return EMPTY_TABLE
end

PlayerHuskBuffExtension.buffs = function (self)
	return EMPTY_TABLE
end

PlayerHuskBuffExtension.add_externally_controlled_buff = function (self)
	ferror("[PlayerHuskBuffExtension] add_externally_controlled_buff can only be called on server!")
end

PlayerHuskBuffExtension.add_internally_controlled_buff = function (self)
	ferror("[PlayerHuskBuffExtension] add_internally_controlled_buff can only be called on server!")
end

PlayerHuskBuffExtension.add_proc_event = function (self)
	ferror("[PlayerHuskBuffExtension] add_proc_event can only be called on server!")
end

PlayerHuskBuffExtension.current_stacks = function (self)
	ferror("[PlayerHuskBuffExtension] current_stacks can only be called on server!")
end

PlayerHuskBuffExtension.is_frame_unique_proc = function (self)
	ferror("[PlayerHuskBuffExtension] is_frame_unique_proc can only be called on server!")
end

PlayerHuskBuffExtension.refresh_duration_of_stacking_buff = function (self)
	ferror("[PlayerHuskBuffExtension] refresh_duration_of_stacking_buff can only be called on server!")
end

PlayerHuskBuffExtension.remove_externally_controlled_buff = function (self)
	ferror("[PlayerHuskBuffExtension] remove_externally_controlled_buff can only be called on server!")
end

PlayerHuskBuffExtension.request_proc_event_param_table = function (self)
	ferror("[PlayerHuskBuffExtension] request_proc_event_param_table can only be called on server!")
end

PlayerHuskBuffExtension.set_frame_unique_proc = function (self)
	ferror("[PlayerHuskBuffExtension] set_frame_unique_proc can only be called on server!")
end

implements(PlayerHuskBuffExtension, BuffExtensionInterface)

return PlayerHuskBuffExtension
