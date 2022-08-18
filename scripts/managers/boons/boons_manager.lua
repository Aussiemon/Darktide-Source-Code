local MasterItems = require("scripts/backend/master_items")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local FixedFrame = require("scripts/utilities/fixed_frame")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local BoonsManager = class("BoonsManager")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local RPCS_CLIENT = {
	"rpc_player_equip_boon_response",
	"rpc_sync_equipped_boons",
	"rpc_boons_activated"
}
local RPCS_SERVER = {
	"rpc_player_equip_boon_request"
}

BoonsManager.init = function (self, is_server)
	self._is_server = is_server
	self._network_event_delegate = Managers.connection:network_event_delegate()
	self._is_client = not is_server

	if self._is_server then
		Managers.event:register(self, "player_unit_spawned", "_on_player_unit_spawned")
		self._network_event_delegate:register_connection_events(self, unpack(RPCS_SERVER))
	end

	if self._is_client then
		self._network_event_delegate:register_connection_events(self, unpack(RPCS_CLIENT))
	end

	self._equipped_boons = {}
	self._active_boons = {}
end

BoonsManager.destroy = function (self)
	if self._is_server then
		Managers.event:unregister(self, "player_unit_spawned")
		self._network_event_delegate:unregister_events(unpack(RPCS_SERVER))
	end

	if self._is_client then
		self._network_event_delegate:unregister_events(unpack(RPCS_CLIENT))
	end
end

BoonsManager._on_player_unit_spawned = function (self, player)
	assert(self._is_server)

	if self._boons_activated then
		self:_add_boon_effects_on_all_player()

		local is_human_controlled = player:is_human_controlled()

		if is_human_controlled then
			local peer_id = player:peer_id()

			self:_send_rpc_client("rpc_boons_activated", peer_id)
		end
	else
		self:_sync_equipped_boons()
	end
end

BoonsManager.update = function (self, dt, t)
	return
end

BoonsManager.request_equip_boon = function (self, player, gear_id)
	local peer_id = player:peer_id()
	local local_player_id = player:local_player_id()

	self:_send_rpc_server("rpc_player_equip_boon_request", peer_id, local_player_id, gear_id)
end

BoonsManager.rpc_player_equip_boon_request = function (self, channel_id, peer_id, local_player_id, gear_id)
	assert(self._is_server)

	local player = Managers.player:player(peer_id, local_player_id)
	local account_id = player:account_id()

	Managers.backend.interfaces.gear:fetch_by_id(account_id, gear_id):next(function (item)
		local boon_item = MasterItems.get_item_instance(item, gear_id)
		local boon_can_be_equipped, optional_fail_reason = self:_boon_can_be_equipped(boon_item)
		local success = boon_can_be_equipped

		self:_send_rpc_client("rpc_player_equip_boon_response", peer_id, success, optional_fail_reason)

		if boon_can_be_equipped then
			self:_equip_boon_on_server(player, boon_item)
			self:_sync_equipped_boons()
		end
	end)
end

BoonsManager.rpc_player_equip_boon_response = function (self, channel_id, success, optional_fail_reason)
	Log.info("BoonsManager", "Equip boon response %s :%s", success, optional_fail_reason)

	if success then
		Managers.event:trigger("event_add_notification_message", "default", "Equip Boon Request Approved")
	else
		local error_string = Localize(optional_fail_reason)

		Managers.event:trigger("event_add_notification_message", "default", string.format("Equip Boon Request Rejected\n%s", error_string))
	end
end

BoonsManager._boon_can_be_equipped = function (self, boon_item)
	if self._boons_activated then
		local reason = "loc_boons_already_activated"

		return false, reason
	end

	local equipped_boons = self._equipped_boons
	local boon_item_name = boon_item.name

	for _, item in pairs(equipped_boons) do
		local item_name = item.name

		if item_name == boon_item_name then
			local reason = "loc_boon_already_equipped"

			return false, reason
		end
	end

	return true
end

BoonsManager._equip_boon_on_server = function (self, player, item)
	assert(self._is_server)

	self._equipped_boons[player] = item
end

BoonsManager.activate_boons = function (self)
	assert(self._is_server)

	self._boons_activated = true

	for player, boon_item in pairs(self._equipped_boons) do
		self._active_boons[player] = boon_item
		self._equipped_boons[player] = nil
	end

	self:_add_boon_effects_on_all_player()
	Managers.connection:send_rpc_clients("rpc_boons_activated")
end

BoonsManager.rpc_boons_activated = function (self, channel_id)
	self._boons_activated = true
end

BoonsManager._add_boon_effects_on_all_player = function (self)
	assert(self._is_server)

	local active_boons = self._active_boons
	local players = Managers.player:human_players()

	for _, boon_item in pairs(active_boons) do
		local effects = boon_item.effects

		for i, data in ipairs(effects) do
			local name = data.name

			for id, player in pairs(players) do
				repeat
					local player_unit = player.player_unit

					if not player_unit then
						break
					end

					local player_have_buff = self:_player_have_buff(player, name)

					if player_have_buff then
						break
					end

					self:_add_buff(player, name)
				until true
			end
		end
	end

	self:_sync_equipped_boons()
end

BoonsManager._add_buff = function (self, player, name)
	assert(self._is_server)

	local t = FixedFrame.get_latest_fixed_time()
	local buff_template = BuffTemplates[name]

	if not buff_template then
		Log.error("BoonsManager", "Trying to activate a Boon Item with a non-existing buff template: %s", name)

		return
	end

	local is_meta_buff = buff_template.meta_buff

	if is_meta_buff then
		local gadget_system = Managers.state.extension:system("gadget_system")

		gadget_system:add_meta_buff(player, name, t)
		Log.info("BoonsManager", "Added Meta Buff :%s", name)
	else
		local player_unit = player.player_unit
		local buff_extension = ScriptUnit.extension(player_unit, "buff_system")

		buff_extension:add_externally_controlled_buff(name, t)
		Log.info("BoonsManager", "Added buff:%s ", name)
	end
end

BoonsManager._player_have_buff = function (self, player, buff_template_name)
	local player_unit = player.player_unit

	if player_unit then
		local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
		local buffs = buff_extension:buffs()

		for i, buff in ipairs(buffs) do
			local template_name = buff:template_name()

			if template_name == buff_template_name then
				return true
			end
		end
	end

	local gadget_system = Managers.state.extension:system("gadget_system")
	local meta_buffs = gadget_system:meta_buffs()

	for i, meta_buff in ipairs(meta_buffs) do
		repeat
			local meta_buff_player = meta_buff:player()

			if meta_buff_player ~= player then
				break
			end

			local template_name = meta_buff:template_name()

			if template_name == buff_template_name then
				return true
			end
		until true
	end

	return false
end

BoonsManager._sync_equipped_boons = function (self)
	assert(self._is_server)

	local equipped_boons = self._equipped_boons
	local peer_ids_list = {}
	local local_player_ids_list = {}
	local boon_items_id_list = {}

	for player, boon_item in pairs(equipped_boons) do
		local peer_id = player:peer_id()
		local local_player_id = player:local_player_id()
		local boon_item_name = boon_item.name
		local boon_item_id = NetworkLookup.player_item_names[boon_item_name]

		table.insert(peer_ids_list, peer_id)
		table.insert(local_player_ids_list, local_player_id)
		table.insert(boon_items_id_list, boon_item_id)
	end

	Managers.connection:send_rpc_clients("rpc_sync_equipped_boons", peer_ids_list, local_player_ids_list, boon_items_id_list)
end

BoonsManager.rpc_sync_equipped_boons = function (self, channel_id, peer_ids_list, local_player_ids_list, boon_items_id_list)
	assert(self._is_client)
	table.clear(self._equipped_boons)

	for i, peer_id in ipairs(peer_ids_list) do
		local local_player_id = local_player_ids_list[i]
		local player = Managers.player:player(peer_id, local_player_id)
		local boon_item_id = boon_items_id_list[i]
		local boon_item_name = NetworkLookup.player_item_names[boon_item_id]
		local boon_item_template = MasterItems.get_item(boon_item_name)
		self._equipped_boons[player] = boon_item_template
	end
end

BoonsManager.equipped_boon = function (self, player)
	local boon_item = self._equipped_boons[player]

	return boon_item
end

BoonsManager.get_boon_items_in_inventory = function (self, player, callback)
	local character_id = player:character_id()
	local num_items = 500
	local filter = nil

	Managers.data_service.gear:fetch_inventory_paged(character_id, num_items, filter):next(function (items)
		callback(items)
	end):catch(function (errors)
		Log.error("BoonsManager", "fetch_inventory_paged failed: %s", errors)
	end)
end

BoonsManager._send_rpc_server = function (self, rpc_name, peer_id, ...)
	local send_rpc = self._is_client

	if send_rpc then
		Managers.connection:send_rpc_server(rpc_name, peer_id, ...)
	else
		self[rpc_name](self, nil, peer_id, ...)
	end
end

BoonsManager._send_rpc_client = function (self, rpc_name, peer_id, ...)
	local send_rpc = peer_id ~= Network.peer_id()

	if send_rpc then
		Managers.connection:send_rpc_client(rpc_name, peer_id, ...)
	else
		self[rpc_name](self, nil, ...)
	end
end

return BoonsManager
