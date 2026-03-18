-- chunkname: @scripts/utilities/expeditions/expedition_minion_loot_handler.lua

local Breeds = require("scripts/settings/breed/breeds")
local ExpeditionMinionLootSettings = require("scripts/settings/minion_loot/expedition_minion_loot_settings")
local Text = require("scripts/utilities/ui/text")
local UISettings = require("scripts/settings/ui/ui_settings")
local CLIENT_RPCS = {
	"rpc_player_loot_stolen",
	"rpc_minion_dropped_loot",
}
local SERVER_RPCS = {}
local ExpeditionMinionLootHandler = class("ExpeditionMinionLootHandler")

ExpeditionMinionLootHandler.init = function (self, expedition_template, is_server, network_event_delegate, loot_handler)
	self._expedition_template = expedition_template
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._loot_handler = loot_handler
	self._loot_by_minion = {}
	self._cached_breed_loot_settings = {}

	local loot_settings = self._expedition_template and self._expedition_template.loot_settings
	local loot_loss_settings = loot_settings and loot_settings.loot_loss_settings

	self._breed_loot_settings = loot_loss_settings and loot_loss_settings.by_minion_breed

	local event_manager = Managers.event

	if self._is_server then
		network_event_delegate:register_session_events(self, unpack(SERVER_RPCS))
		event_manager:register(self, "event_minion_loot", "event_minion_loot")
	else
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

ExpeditionMinionLootHandler._get_breed_loot_settings_by_name = function (self, breed_name)
	if not self._cached_breed_loot_settings[breed_name] then
		local breed_setting = self._breed_loot_settings and self._breed_loot_settings[breed_name]

		self._cached_breed_loot_settings[breed_name] = breed_setting or ExpeditionMinionLootSettings[breed_name]
	end

	return self._cached_breed_loot_settings[breed_name]
end

ExpeditionMinionLootHandler._get_breed_info = function (self, breed_id)
	local breed_name = NetworkLookup.breed_names[breed_id]

	if not breed_name then
		return nil
	end

	local breed = Breeds[breed_name]
	local breed_display_name = breed.display_name
	local breed_loot_settings = self:_get_breed_loot_settings_by_name(breed_name)
	local portrait = breed_loot_settings and breed_loot_settings.frame

	return breed_name, breed_display_name, portrait
end

ExpeditionMinionLootHandler.rpc_player_loot_stolen = function (self, channel_id, peer_id, amount_to_steal, breed_id, game_object_id)
	self:_client_show_loot_notification(peer_id, amount_to_steal, breed_id)

	local unit = Managers.state.unit_spawner:unit(game_object_id, nil, nil)
	local outline_system = Managers.state.extension:system("outline_system")

	outline_system:add_outline(unit, "hordes_tagged_remaining_target")
end

ExpeditionMinionLootHandler._client_show_loot_notification = function (self, peer_id, amount_to_steal, breed_id)
	local player_manager = Managers.player
	local local_player_id = 1
	local player = player_manager:player(peer_id, local_player_id)
	local _, breed_display_name, _ = self:_get_breed_info(breed_id)

	Managers.event:trigger("event_add_notification_message", "minion_loot_steal", {
		player = player,
		breed_display_name = breed_display_name,
		amount = amount_to_steal,
	})
end

ExpeditionMinionLootHandler.rpc_minion_dropped_loot = function (self, channel_id, amount_to_steal, breed_id)
	self:_client_show_minion_loot_dropped_notification(amount_to_steal, breed_id)
end

ExpeditionMinionLootHandler._client_show_minion_loot_dropped_notification = function (self, amount_to_steal, breed_id)
	local _, breed_display_name, _ = self:_get_breed_info(breed_id)

	Managers.event:trigger("event_add_notification_message", "minion_loot_drop", {
		breed_display_name = breed_display_name,
		amount = amount_to_steal,
	})
end

ExpeditionMinionLootHandler._calculate_loot = function (self, player, unit)
	local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")
	local breed_name = unit_data_ext:breed().name
	local breed_settings = self:_get_breed_loot_settings_by_name(breed_name)
	local peer_id = player:peer_id()
	local player_collected_loot = self._loot_handler:collected_player_loot_by_type(peer_id, "small")
	local amount_to_steal = math.clamp(player_collected_loot, 0, breed_settings.max_per_opportunity)
	local breed_id = NetworkLookup.breed_names[breed_name]

	return amount_to_steal, breed_settings, breed_id, peer_id
end

ExpeditionMinionLootHandler.steal = function (self, player_unit, unit)
	local player = Managers.state.player_unit_spawn:owner(player_unit)

	if player then
		local amount_to_steal, breed_settings, breed_id, peer_id = self:_calculate_loot(player, unit)
		local loot_by_minion = self._loot_by_minion[unit]

		if not loot_by_minion then
			self._loot_by_minion[unit] = {
				amount = 0,
				reason = "stolen",
				position = Vector3Box(POSITION_LOOKUP[unit]),
				breed_id = breed_id,
			}
			loot_by_minion = self._loot_by_minion[unit]
		else
			loot_by_minion.reason = "stolen"
		end

		local max_remaining_allowed_amount = math.max(breed_settings.max_stolen - loot_by_minion.amount, 0)

		amount_to_steal = math.min(amount_to_steal, max_remaining_allowed_amount)

		if amount_to_steal == 0 then
			if loot_by_minion.amount == 0 then
				self._loot_by_minion[unit] = nil
			end

			return
		end

		self._loot_handler:server_deduct_player_loot(peer_id, amount_to_steal)

		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

		Managers.state.game_session:send_rpc_clients("rpc_player_loot_stolen", peer_id, amount_to_steal, breed_id, game_object_id)

		loot_by_minion.amount = loot_by_minion.amount + amount_to_steal
	end
end

ExpeditionMinionLootHandler._set_spawn_amount = function (self, unit, spawn_amount)
	local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")
	local breed_name = unit_data_ext:breed().name
	local breed_id = NetworkLookup.breed_names[breed_name]

	if not self._loot_by_minion[unit] then
		self._loot_by_minion[unit] = {
			reason = "reward",
			position = Vector3Box(POSITION_LOOKUP[unit]),
			amount = spawn_amount,
			breed_id = breed_id,
		}
	end
end

ExpeditionMinionLootHandler.insta_drop = function (self, player_unit, unit)
	local player = Managers.state.player_unit_spawn:owner(player_unit)

	if player then
		local amount_to_steal, _, breed_id, peer_id = self:_calculate_loot(player, unit)

		if amount_to_steal == 0 then
			return
		end

		self._loot_handler:server_deduct_player_loot(peer_id, amount_to_steal)

		local position = Vector3Box(POSITION_LOOKUP[player_unit])
		local spawn_data = {
			position = position,
			amount = amount_to_steal,
			breed_id = breed_id,
		}

		self:_drop_loot(spawn_data)
	end
end

ExpeditionMinionLootHandler.event_minion_loot = function (self, player_unit, unit)
	local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")
	local breed_name = unit_data_ext:breed().name
	local breed_settings = self:_get_breed_loot_settings_by_name(breed_name)
	local loot_method = breed_settings.method

	if loot_method == "drop_on_death" then
		self:steal(player_unit, unit)
	elseif loot_method == "direct_drop" then
		self:insta_drop(player_unit, unit)
	end
end

ExpeditionMinionLootHandler._drop_loot = function (self, unit_data)
	local unit_position = unit_data.position:unbox()
	local minion_small_loot_amount = unit_data.amount
	local breed_id = unit_data.breed_id
	local pickup_name = "expedition_loot_player_drop"
	local extension_manager = Managers.state.extension
	local pickup_system = extension_manager:system("pickup_system")
	local pickup_unit, _ = pickup_system:spawn_pickup(pickup_name, unit_position, Quaternion.identity(), nil, nil, nil, nil)

	self._loot_handler:add_external_player_pickup_unit(pickup_unit, minion_small_loot_amount, unit_data.reason)
	Managers.state.game_session:send_rpc_clients("rpc_minion_dropped_loot", minion_small_loot_amount, breed_id)
end

ExpeditionMinionLootHandler.update = function (self, dt, t)
	if self._is_server then
		if Managers.state.pacing:is_enabled() then
			local loot_data_by_enemy = self._loot_by_minion

			for unit, data in pairs(loot_data_by_enemy) do
				local unit_data = data

				if HEALTH_ALIVE[unit] then
					unit_data.position = Vector3Box(POSITION_LOOKUP[unit])

					local blackboard = BLACKBOARDS[unit]

					if blackboard then
						local perception_component = blackboard.perception
						local aggro_state = perception_component.aggro_state

						unit_data.last_aggroed_state = aggro_state
					end
				else
					local last_aggroed_state = unit_data.last_aggroed_state

					if last_aggroed_state and last_aggroed_state == "aggroed" then
						self:_drop_loot(unit_data)
					end

					loot_data_by_enemy[unit] = nil
				end
			end
		else
			table.clear(self._loot_by_minion)
		end
	end
end

ExpeditionMinionLootHandler.check_minion_loot = function (self, unit)
	return self._loot_by_minion[unit] ~= nil
end

ExpeditionMinionLootHandler.remove_minion_loot = function (self, unit)
	if self._loot_by_minion[unit] then
		self._loot_by_minion[unit] = nil
	end
end

ExpeditionMinionLootHandler.destroy = function (self)
	local event_manager = Managers.event

	if self._is_server then
		event_manager:unregister(self, "event_minion_loot")
		self._network_event_delegate:unregister_events(unpack(SERVER_RPCS))
	else
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

return ExpeditionMinionLootHandler
