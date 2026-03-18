-- chunkname: @scripts/utilities/expeditions/expedition_collectible.lua

local Text = require("scripts/utilities/ui/text")
local UISettings = require("scripts/settings/ui/ui_settings")
local ExpeditionCollectibles = require("scripts/settings/expeditions/expedition_collectibles")
local ExpeditionCollectible = class("ExpeditionCollectible")

ExpeditionCollectible.init = function (self, expedition_template, collectible_id, is_server, network_event_delegate)
	self._expedition_template = expedition_template
	self._collectible_id = collectible_id
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._amount_by_player = {}
	self._peer_id_by_pickup_unit = {}
	self._collectible_calculations_dirty = false
	self._total_team_amount_collected = 0

	local collectible_settings = ExpeditionCollectibles[collectible_id]

	self._collect_mode = collectible_settings.collect_mode or "individual"
	self._consume_mode = collectible_settings.consume_mode or "individual"
end

ExpeditionCollectible.has_interactable_unit_requirements = function (self, interactable_unit)
	return self._registered_unit_requirements[interactable_unit] ~= nil
end

ExpeditionCollectible.on_gameplay_init = function (self)
	return
end

ExpeditionCollectible.peer_collected = function (self, interactor_peer_id, collectible_id_lookup, amount)
	local collectible_id = NetworkLookup.expedition_collectibles[collectible_id_lookup]

	if self._collectible_id ~= collectible_id then
		return
	end

	if self._is_server then
		local collect_mode = self._collect_mode

		if collect_mode == "individual" then
			local expedition_collectible_show_notification = true

			Managers.state.game_session:send_rpc_clients("rpc_client_expedition_collectible_collected", interactor_peer_id, collectible_id_lookup, amount, expedition_collectible_show_notification)
			self:_add_player_collectible(interactor_peer_id, amount)
		elseif collect_mode == "team" then
			local player_manager = Managers.player
			local players = player_manager:players()

			for _, player in pairs(players) do
				local valid_player = player:is_human_controlled()

				if valid_player then
					local peer_id = player:peer_id()
					local expedition_collectible_show_notification = peer_id == interactor_peer_id

					Managers.state.game_session:send_rpc_clients("rpc_client_expedition_collectible_collected", peer_id, collectible_id_lookup, amount, expedition_collectible_show_notification)
					self:_add_player_collectible(peer_id, amount)
				end
			end
		end
	end
end

ExpeditionCollectible._add_player_collectible = function (self, peer_id, amount)
	local amount_by_player = self._amount_by_player

	if not amount_by_player[peer_id] then
		amount_by_player[peer_id] = 0
	end

	amount_by_player[peer_id] = amount_by_player[peer_id] + amount
	self._collectible_calculations_dirty = true
end

ExpeditionCollectible.client_expedition_remove_collectible_collected = function (self, peer_id, collectible_id_lookup, amount_to_deduct)
	local collectible_id = NetworkLookup.expedition_collectibles[collectible_id_lookup]

	if self._collectible_id ~= collectible_id then
		return
	end

	self:_add_player_collectible(peer_id, -amount_to_deduct)

	self._collectible_calculations_dirty = true
end

ExpeditionCollectible.hot_join_sync = function (self, channel_id)
	local collectible_id = self._collectible_id
	local collectible_id_lookup = NetworkLookup.expedition_collectibles[collectible_id]
	local expedition_collectible_show_notification = false
	local amount_by_player = self._amount_by_player

	for currencyer_peer_id, amount in pairs(amount_by_player) do
		RPC.rpc_client_expedition_collectible_collected(channel_id, currencyer_peer_id, collectible_id_lookup, amount, expedition_collectible_show_notification)
	end
end

ExpeditionCollectible.client_expedition_collectible_collected = function (self, peer_id, collectible_id_lookup, amount, expedition_collectible_show_notification)
	local collectible_id = NetworkLookup.expedition_collectibles[collectible_id_lookup]

	if self._collectible_id ~= collectible_id then
		return
	end

	self:_add_player_collectible(peer_id, amount)

	if expedition_collectible_show_notification then
		self:_show_collectible_notification(peer_id, amount)
	end
end

ExpeditionCollectible.server_expedition_collectible_collected = function (self, peer_id, collectible_id_lookup, amount)
	local collectible_id = NetworkLookup.expedition_collectibles[collectible_id_lookup]

	if self._collectible_id ~= collectible_id then
		return
	end

	Managers.state.game_session:send_rpc_clients("rpc_client_expedition_collectible_collected", peer_id, collectible_id_lookup, amount, true)
	self:_show_collectible_notification(peer_id, amount)
end

ExpeditionCollectible._show_collectible_notification = function (self, peer_id, amount)
	local collectible_id = self._collectible_id
	local player_manager = Managers.player
	local local_player_id = 1
	local player = player_manager:player(peer_id, local_player_id)
	local player_name = player and player:name()
	local player_slot = player and player.slot and player:slot()
	local player_slot_colors = UISettings.player_slot_colors
	local player_slot_color = player_slot and player_slot_colors[player_slot]

	if player_name and player_slot_color then
		player_name = Text.apply_color_to_text(player_name, player_slot_color)
	end

	local collectible_settings = ExpeditionCollectibles[collectible_id]
	local collectible_display_name = collectible_settings.display_name
	local done_callback

	Managers.event:trigger("event_add_notification_message", "default", "[DEV] " .. player_name .. " Picked up: " .. Localize(collectible_display_name) .. " (" .. amount .. ")", nil, nil, done_callback)
end

ExpeditionCollectible.collectible_id = function (self)
	return self._collectible_id
end

ExpeditionCollectible.collected_team_amount = function (self)
	return self._total_team_amount_collected
end

ExpeditionCollectible.team_shared_usage = function (self)
	return self._consume_mode == "team"
end

ExpeditionCollectible.consume_on_use = function (self)
	return self._consume_mode ~= "never"
end

ExpeditionCollectible.collected_player_amount = function (self, peer_id)
	local amount_by_player = self._amount_by_player
	local player_currency = amount_by_player[peer_id] or 0

	return player_currency
end

ExpeditionCollectible.server_deduct_amount = function (self, interactor_peer_id, amount)
	local collectible_id = self._collectible_id
	local collectible_id_lookup = NetworkLookup.expedition_collectibles[collectible_id]
	local amount_by_player = self._amount_by_player
	local consume_mode = self._consume_mode

	local function try_consume_from_player(peer_id)
		local player_currency_amount = amount_by_player[peer_id]

		if player_currency_amount and player_currency_amount >= amount then
			amount_by_player[peer_id] = player_currency_amount - amount
			self._collectible_calculations_dirty = true

			Managers.state.game_session:send_rpc_clients("rpc_client_expedition_remove_collectible_collected", peer_id, collectible_id_lookup, amount)

			return true
		end

		return false
	end

	if self._is_server then
		if consume_mode == "individual" then
			return try_consume_from_player(interactor_peer_id)
		elseif consume_mode == "team" then
			if try_consume_from_player(interactor_peer_id) then
				return true
			else
				local player_manager = Managers.player
				local players = player_manager:players()

				for _, player in pairs(players) do
					local valid_player = player:is_human_controlled()

					if valid_player then
						local peer_id = player:peer_id()

						if try_consume_from_player(peer_id) then
							return true
						end
					end
				end
			end
		end
	end

	return false
end

ExpeditionCollectible.collectible_calculations_dirty = function (self)
	return self._collectible_calculations_dirty
end

ExpeditionCollectible.update = function (self, dt, t)
	if self._collectible_calculations_dirty then
		self:_update_collectible_calculations(dt, t)
	end
end

ExpeditionCollectible._update_collectible_calculations = function (self, dt, t)
	local total_amount = 0
	local amount_by_player = self._amount_by_player

	for peer_id, player_currency in pairs(amount_by_player) do
		total_amount = total_amount + player_currency
	end

	self._total_team_amount_collected = total_amount
	self._collectible_calculations_dirty = false
end

ExpeditionCollectible.get_block_text_by_unit = function (self, interactable_unit, peer_id)
	local data = self._registered_unit_requirements[interactable_unit]
	local original_description = data.original_description
	local amount = data.amount
	local collectible_id = self._collectible_id
	local collectible_settings = ExpeditionCollectibles[collectible_id]
	local collectible_display_name = collectible_settings.display_name
	local collected_player_amount = self:collected_player_amount(peer_id)
	local requirements_met = amount <= collected_player_amount
	local unit_interactee_extension = ScriptUnit.has_extension(interactable_unit, "interactee_system")

	if requirements_met then
		local text_context = {
			description = Localize(original_description),
			value = Localize(collectible_display_name),
		}

		unit_interactee_extension:set_block_text(nil)
		unit_interactee_extension:set_description("loc_interaction_description_has_requirement", text_context)
	else
		local key_value_color = Color.ui_red_light(255, true)
		local text_context = {
			description = Localize(original_description),
			value = Localize(collectible_display_name),
			r = key_value_color[2],
			g = key_value_color[3],
			b = key_value_color[4],
		}

		unit_interactee_extension:set_block_text("loc_group_finder_tag_requirement_warning")
		unit_interactee_extension:set_description("loc_interaction_description_missing_requirement", text_context)
	end
end

ExpeditionCollectible.destroy = function (self)
	return
end

return ExpeditionCollectible
