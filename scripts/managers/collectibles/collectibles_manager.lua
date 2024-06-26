-- chunkname: @scripts/managers/collectibles/collectibles_manager.lua

local Component = require("scripts/utilities/component")
local TextUtilities = require("scripts/utilities/ui/text")
local UISettings = require("scripts/settings/ui/ui_settings")
local CollectiblesManager = class("CollectiblesManager")
local CLIENT_RPCS = {
	"rpc_player_destroyed_destructible_collectible",
	"rpc_player_collected_collectible",
	"rpc_player_helped_collecting_collectible",
}
local NOTIFICATION_TYPES = table.enum("collected", "helped_collect")

CollectiblesManager.init = function (self, is_server, network_event_delegate)
	self._network_event_delegate = network_event_delegate
	self._is_server = is_server

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end

	self._num_destructibles = 0
	self._destructible_data = {}
	self._num_destructibles_destroyed = 0
	self._delayed_notifications = {}
	self._collectible_rewarded = false
end

CollectiblesManager.on_gameplay_post_init = function (self, level_seed)
	self._seed = level_seed

	local destructibles = {}

	self._num_destructibles = 0

	for section_id = 1, #self._destructible_data do
		local section = self._destructible_data[section_id]
		local num_ids = #section
		local random_id = self:_random(1, num_ids)

		if not destructibles[section_id] then
			destructibles[section_id] = {}
		end

		local new_entry = table.clone(self._destructible_data[section_id][random_id])

		new_entry.id = 1
		destructibles[section_id][#destructibles[section_id] + 1] = new_entry

		local destructible_extension = ScriptUnit.has_extension(new_entry.unit, "destructible_system")

		destructible_extension:set_collectible_data(new_entry)
		Unit.flow_event(new_entry.unit, "destructible_enabled")
		table.remove(self._destructible_data[section_id], random_id)

		self._num_destructibles = self._num_destructibles + 1
	end

	for section_id = 1, #self._destructible_data do
		local section_data = self._destructible_data[section_id]

		for id = 1, #section_data do
			local data = section_data[id]
			local unit = data.unit

			Component.event(unit, "disable_visibility")
			Component.event(unit, "destructible_disable")
			Unit.set_unit_visibility(unit, false)
		end
	end

	self._destructibles = destructibles
end

CollectiblesManager.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

CollectiblesManager._random = function (self, ...)
	local seed, value = math.next_random(self._seed, ...)

	self._seed = seed

	return value
end

CollectiblesManager.register_destructible = function (self, data)
	local destructible_data = self._destructible_data
	local section_id = data.section_id
	local id = data.id

	if not destructible_data[section_id] then
		destructible_data[section_id] = {}
	end

	if not destructible_data[section_id][id] then
		destructible_data[section_id][id] = data
	end

	self._num_destructibles = self._num_destructibles + 1
end

local function _add_collectible_crafting_material(player_unit)
	local optional_ignore_notification = true
	local optional_allow_multiple_per_unit = true
	local pickup_system = Managers.state.extension:system("pickup_system")
	local challenge = Managers.state.difficulty:get_challenge()

	for i = 1, challenge * 2 do
		pickup_system:register_material_collected(nil, player_unit, "plasteel", "small", optional_ignore_notification, optional_allow_multiple_per_unit)
	end

	Managers.telemetry_events:collectible_collected(challenge * 10 * 2)
end

local FIRST_TIME_PLAYERS = {}
local ALREADY_COMPLETED_PLAYERS = {}

CollectiblesManager.register_collectible = function (self, interactor_unit, collectible_type)
	local interactor_player = Managers.state.player_unit_spawn:owner(interactor_unit)

	if not interactor_player then
		return
	end

	local interactor_peer_id = interactor_player:peer_id()
	local interactor_channel_id = interactor_player:channel_id()

	table.clear(FIRST_TIME_PLAYERS)
	table.clear(ALREADY_COMPLETED_PLAYERS)

	local players = Managers.player:players()
	local collectible_type_lookup = NetworkLookup.collectible_type_lookup[collectible_type]
	local completed_stat_name = string.format("mission_%s_collectible", Managers.state.mission:mission_name())

	for _, player in pairs(players) do
		if player and player:is_human_controlled() and player.remote then
			local stat_id = player.remote and player.stat_id or player:local_player_id()
			local completed_value = Managers.stats:read_user_stat(stat_id, completed_stat_name)
			local has_completed_already = completed_value and completed_value >= 1

			if not has_completed_already then
				FIRST_TIME_PLAYERS[player:peer_id()] = true
			else
				ALREADY_COMPLETED_PLAYERS[player:peer_id()] = player:channel_id()
			end
		end
	end

	if FIRST_TIME_PLAYERS[interactor_peer_id] then
		if not self._collectible_rewarded then
			for peer_id, channel in pairs(ALREADY_COMPLETED_PLAYERS) do
				RPC.rpc_player_helped_collecting_collectible(channel, peer_id, collectible_type_lookup, FIRST_TIME_PLAYERS)
			end

			_add_collectible_crafting_material(interactor_player.player_unit)

			self._collectible_rewarded = true
		end

		RPC.rpc_player_collected_collectible(interactor_channel_id, interactor_peer_id, collectible_type_lookup)
	end

	local player = Managers.state.player_unit_spawn:owner(interactor_unit)

	Managers.stats:record_private("hook_collect_collectible", player)
end

CollectiblesManager.collectible_destroyed = function (self, data, attacking_unit)
	local player = Managers.state.player_unit_spawn:owner(attacking_unit)

	if not player then
		return
	end

	local peer_id = player:peer_id()
	local section_id = data.section_id
	local id = data.id

	Managers.state.game_session:send_rpc_clients("rpc_player_destroyed_destructible_collectible", peer_id, section_id, id)
	self:_show_delayed_destructible_notification(peer_id, section_id, id)

	local optional_ignore_notification = true
	local optional_allow_multiple_per_unit = true
	local pickup_system = Managers.state.extension:system("pickup_system")
	local challenge = Managers.state.difficulty:get_challenge()

	for i = 1, challenge do
		pickup_system:register_material_collected(data.unit, attacking_unit, "plasteel", "small", optional_ignore_notification, optional_allow_multiple_per_unit)
	end

	if ALIVE[data.unit] then
		local position = POSITION_LOOKUP[data.unit]

		Managers.telemetry_events:destructible_destroyed(challenge * 10, position, id, section_id)
	end
end

CollectiblesManager.rpc_player_destroyed_destructible_collectible = function (self, channel_id, peer_id, section_id, id)
	self:_show_delayed_destructible_notification(peer_id, section_id, id)
end

local DELAY = 0.4

CollectiblesManager._show_delayed_destructible_notification = function (self, peer_id, section_id, id)
	self._delayed_notifications[#self._delayed_notifications + 1] = {
		peer_id = peer_id,
		section_id = section_id,
		id = id,
		timer = DELAY,
	}
end

CollectiblesManager._update_delayed_destructible_notification = function (self, dt)
	for i = 1, #self._delayed_notifications do
		local delayed_notification = self._delayed_notifications[i]

		delayed_notification.timer = delayed_notification.timer - dt

		if delayed_notification.timer <= 0 then
			self:_show_destructible_notification(delayed_notification.peer_id, delayed_notification.section_id, delayed_notification.id)
			table.remove(self._delayed_notifications, i)

			return
		end
	end
end

CollectiblesManager._show_destructible_notification = function (self, peer_id, section_id, id)
	local player_manager = Managers.player
	local local_player_id = 1
	local player = player_manager:player(peer_id, local_player_id)
	local player_name = player and player:name()

	self._num_destructibles_destroyed = self._num_destructibles_destroyed + 1

	local player_slot = player and player.slot and player:slot()
	local player_slot_colors = UISettings.player_slot_colors
	local player_slot_color = player_slot and player_slot_colors[player_slot]

	if player_name and player_slot_color then
		player_name = TextUtilities.apply_color_to_text(player_name, player_slot_color)
	end

	local collectible_data = self._destructibles
	local section_data = collectible_data[section_id]
	local data = section_data[id]

	data.collected = true

	local num_collected_in_section = 0

	for i = 1, #section_data do
		if section_data[i].collected then
			num_collected_in_section = num_collected_in_section + 1
		end
	end

	local num_in_section = #collectible_data[section_id]
	local num_total = self._num_destructibles

	Managers.event:trigger("event_add_notification_message", "destructible", {
		player_name = player_name,
		player = player,
		num_in_section = num_in_section,
		num_collected_in_section = num_collected_in_section,
		num_collected = self._num_destructibles_destroyed,
		num_total = num_total,
	})
end

CollectiblesManager.rpc_player_collected_collectible = function (self, channel_id, peer_id, collectible_type_lookup)
	local type_lookup = NetworkLookup.collectible_type_lookup[collectible_type_lookup]

	self:_show_collectible_notification(peer_id, type_lookup, NOTIFICATION_TYPES.collected)
end

CollectiblesManager.rpc_player_helped_collecting_collectible = function (self, channel_id, peer_id, collectible_type_lookup, assisted_players)
	local type_lookup = NetworkLookup.collectible_type_lookup[collectible_type_lookup]

	self:_show_collectible_notification(peer_id, type_lookup, NOTIFICATION_TYPES.helped_collect, assisted_players)
end

CollectiblesManager._show_collectible_notification = function (self, peer_id, collectible_type, notification_type, assisted_players)
	local player_manager = Managers.player
	local local_player_id = 1
	local player = player_manager:player(peer_id, local_player_id)
	local player_name = player and player:name()
	local player_slot = player and player.slot and player:slot()
	local player_slot_colors = UISettings.player_slot_colors
	local player_slot_color = player_slot and player_slot_colors[player_slot]

	if player_name and player_slot_color then
		player_name = TextUtilities.apply_color_to_text(player_name, player_slot_color)
	end

	local delay = 0.4

	if notification_type == NOTIFICATION_TYPES.collected then
		Managers.event:trigger("event_add_notification_message", "collectible", {
			player_name = player_name,
			player = player,
		}, nil, nil, nil, delay)
	elseif notification_type == NOTIFICATION_TYPES.helped_collect then
		local local_player_peer_id = Network.peer_id()
		local helped_string = ""

		for i = 1, #assisted_players do
			local assisted_peer_id = assisted_players[i]

			if assisted_peer_id ~= local_player_peer_id then
				local assisted_player = player_manager:player(assisted_peer_id, 1)

				if assisted_player.remote then
					helped_string = helped_string .. assisted_player:character_name() .. " "
				end
			end
		end

		Managers.event:trigger("event_add_notification_message", "helped_collect_collectible", {
			player_name = player_name,
			player = player,
			helped_string = helped_string,
		}, nil, nil, nil, delay)
	end
end

CollectiblesManager.update = function (self, dt, t)
	self:_update_delayed_destructible_notification(dt)
end

return CollectiblesManager
