require("scripts/extension_systems/gadget/player_unit_gadget_extension")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local FixedFrame = require("scripts/utilities/fixed_frame")
local MetaBuff = require("scripts/extension_systems/buff/buffs/meta_buff")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local GadgetSystem = class("GadgetSystem", "ExtensionSystemBase")
local MAX_META_BUFFS = PlayerCharacterConstants.max_meta_buffs
local RPCS_CLIENT = {
	"rpc_add_meta_buff",
	"rpc_remove_meta_buff"
}

GadgetSystem.init = function (self, context, system_init_data, ...)
	GadgetSystem.super.init(self, context, system_init_data, ...)

	self._is_server = context.is_server
	self._is_client = not context.is_server
	self._buffs = {}
	self._player_stat_buffs = {}
	self._buff_instance_id = 0
	self._stat_buffs = {}

	if self._is_client then
		self._network_event_delegate = context.network_event_delegate

		self._network_event_delegate:register_session_events(self, unpack(RPCS_CLIENT))
	end
end

GadgetSystem.destroy = function (self)
	if self._is_client then
		self._network_event_delegate:unregister_events(unpack(RPCS_CLIENT))
	end
end

GadgetSystem.add_meta_buff = function (self, player, buff_name, start_time, lerp_value)
	assert(self._is_server)

	local buff_instance_id = self._buff_instance_id + 1
	self._buff_instance_id = buff_instance_id

	self:_add_meta_buff(player, buff_name, buff_instance_id, start_time, lerp_value)
	self:_update_meta_stat_buffs(player)

	local peer_id = player:peer_id()
	local local_player_id = player:local_player_id()
	local buff_template_id = NetworkLookup.buff_templates[buff_name]

	Managers.state.game_session:send_rpc_clients("rpc_add_meta_buff", peer_id, local_player_id, buff_template_id, buff_instance_id, lerp_value)

	return buff_instance_id
end

GadgetSystem.rpc_add_meta_buff = function (self, channel_id, peer_id, local_player_id, buff_template_id, buff_instance_id, optional_lerp_value)
	assert(self._is_client)

	local player = Managers.player:player(peer_id, local_player_id)
	local buff_name = NetworkLookup.buff_templates[buff_template_id]
	local start_time = FixedFrame.get_latest_fixed_time()

	self:_add_meta_buff(player, buff_name, buff_instance_id, start_time, optional_lerp_value)
	self:_update_meta_stat_buffs(player)
end

GadgetSystem._add_meta_buff = function (self, player, buff_name, buff_instance_id, start_time, lerp_value)
	local template = BuffTemplates[buff_name]
	local context = {
		player = player
	}
	local meta_buff = MetaBuff:new(context, template, start_time, buff_instance_id, "buff_lerp_value", lerp_value)
	self._buffs[#self._buffs + 1] = meta_buff
end

GadgetSystem.meta_buffs = function (self)
	return self._buffs
end

GadgetSystem.remove_meta_buff = function (self, player, buff_instance_id)
	assert(self._is_server)
	self:_remove_meta_buff(buff_instance_id)
	self:_update_meta_stat_buffs(player)

	local peer_id = player:peer_id()
	local local_player_id = player:local_player_id()

	Managers.state.game_session:send_rpc_clients("rpc_remove_meta_buff", peer_id, local_player_id, buff_instance_id)
end

GadgetSystem.rpc_remove_meta_buff = function (self, channel_id, peer_id, local_player_id, buff_instance_id)
	assert(self._is_client)

	local player = Managers.player:player(peer_id, local_player_id)

	self:_remove_meta_buff(buff_instance_id)
	self:_update_meta_stat_buffs(player)
end

GadgetSystem._remove_meta_buff = function (self, buff_instance_id)
	local buffs = self._buffs

	for i = 1, #buffs, 1 do
		if instance_id == buff:instance_id() then
			table.remove(buffs, i)

			break
		end
	end
end

GadgetSystem._update_meta_stat_buffs = function (self, player)
	self:_reset_stat_buffs(player)

	local buffs = self._buffs
	local current_stat_buffs = self._stat_buffs[player]
	local t = FixedFrame.get_latest_fixed_time()

	for i = 1, #buffs, 1 do
		local buff = buffs[i]

		if buff:player() == player then
			buff:update_stat_buffs(current_stat_buffs, t)
		end
	end
end

GadgetSystem._reset_stat_buffs = function (self, player)
	local stat_buff_types = BuffSettings.meta_stat_buff_types
	local stat_buffs = BuffSettings.meta_stat_buffs
	local stat_buff_base_values = BuffSettings.stat_buff_base_values
	local current_stat_buffs = self._stat_buffs[player] or {}

	for _, value in pairs(stat_buffs) do
		local stat_buff_type = stat_buff_types[value]

		fassert(stat_buff_type, "stat_buff with name %s missing a type definition in stat_buff_settings", value)

		local base_value = stat_buff_base_values[stat_buff_type]
		current_stat_buffs[value] = base_value
	end

	self._stat_buffs[player] = current_stat_buffs
end

GadgetSystem.stat_buffs = function (self, player)
	local stat_buffs = self._stat_buffs[player] or self:_default_stat_buffs(player)

	return stat_buffs
end

GadgetSystem._default_stat_buffs = function (self, player)
	self:_reset_stat_buffs(player)

	local stat_buffs = self._stat_buffs[player]

	return stat_buffs
end

GadgetSystem.update = function (self, dt, t)
	return
end

return GadgetSystem
