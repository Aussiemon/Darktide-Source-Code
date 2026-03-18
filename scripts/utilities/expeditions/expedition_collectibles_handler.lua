-- chunkname: @scripts/utilities/expeditions/expedition_collectibles_handler.lua

local ExpeditionCollectibles = require("scripts/settings/expeditions/expedition_collectibles")
local ExpeditionCollectible = require("scripts/utilities/expeditions/expedition_collectible")
local ExpeditionCollectibleSettings = require("scripts/settings/expeditions/expedition_collectibles")
local CLIENT_RPCS = {
	"rpc_client_expedition_collectible_collected",
	"rpc_client_expedition_remove_collectible_collected",
}
local SERVER_RPCS = {
	"rpc_server_expedition_collectible_collected",
}
local ExpeditionCollectiblesHandler = class("ExpeditionCollectiblesHandler")

ExpeditionCollectiblesHandler.init = function (self, expedition_template, is_server, network_event_delegate)
	self._is_server = is_server
	self._registered_unit_requirements = {}
	self._original_description_by_unit = {}
	self._collectibles = {}
	self._collectibles_by_id = {}

	for key, _ in pairs(ExpeditionCollectibleSettings) do
		local collectible = ExpeditionCollectible:new(expedition_template, key, is_server, network_event_delegate)

		self._collectibles[#self._collectibles + 1] = collectible
		self._collectibles_by_id[key] = collectible
	end

	local event_manager = Managers.event

	event_manager:register(self, "event_expedition_register_interactable_requirement", "event_expedition_register_interactable_requirement")
	event_manager:register(self, "event_expedition_collectible_collected", "event_expedition_collectible_collected")
	event_manager:register(self, "event_on_interaction_success", "event_on_interaction_success")

	self._network_event_delegate = network_event_delegate

	if self._is_server then
		network_event_delegate:register_session_events(self, unpack(SERVER_RPCS))
	else
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

ExpeditionCollectiblesHandler.rpc_server_expedition_collectible_collected = function (self, channel_id, peer_id, collectible_id_lookup, amount)
	local collectible_id = NetworkLookup.expedition_collectibles[collectible_id_lookup]
	local collectible = self._collectibles_by_id[collectible_id]

	collectible:server_expedition_collectible_collected(peer_id, collectible_id_lookup, amount)
end

ExpeditionCollectiblesHandler.rpc_client_expedition_collectible_collected = function (self, channel_id, peer_id, collectible_id_lookup, amount, expedition_collectible_show_notification)
	local collectible_id = NetworkLookup.expedition_collectibles[collectible_id_lookup]
	local collectible = self._collectibles_by_id[collectible_id]

	collectible:client_expedition_collectible_collected(peer_id, collectible_id_lookup, amount, expedition_collectible_show_notification)
end

ExpeditionCollectiblesHandler.rpc_client_expedition_remove_collectible_collected = function (self, channel_id, peer_id, collectible_id_lookup, amount_to_deduct)
	local collectible_id = NetworkLookup.expedition_collectibles[collectible_id_lookup]
	local collectible = self._collectibles_by_id[collectible_id]

	collectible:client_expedition_remove_collectible_collected(peer_id, collectible_id_lookup, amount_to_deduct)
end

ExpeditionCollectiblesHandler.event_expedition_collectible_collected = function (self, interactor_unit, collectible_id_lookup, amount)
	if self._is_server then
		local collectible_id = NetworkLookup.expedition_collectibles[collectible_id_lookup]
		local collectible = self._collectibles_by_id[collectible_id]
		local interactor_player = Managers.state.player_unit_spawn:owner(interactor_unit)
		local interactor_peer_id = interactor_player and interactor_player:peer_id()

		collectible:peer_collected(interactor_peer_id, collectible_id_lookup, amount)
	end
end

ExpeditionCollectiblesHandler.event_expedition_register_interactable_requirement = function (self, interactable_unit, collectible_id, amount)
	local unit_interactee_extension = ScriptUnit.has_extension(interactable_unit, "interactee_system")
	local requirements_data = self._registered_unit_requirements[interactable_unit]

	if not requirements_data then
		requirements_data = {}
		self._registered_unit_requirements[interactable_unit] = requirements_data
	end

	if not self._original_description_by_unit[interactable_unit] then
		self._original_description_by_unit[interactable_unit] = unit_interactee_extension:description()
	end

	requirements_data[collectible_id] = {
		collectible_id = collectible_id,
		amount = amount,
	}

	if self._is_server and DEDICATED_SERVER then
		local function block_func(interactee_extension, interactor_unit)
			local player = Managers.player:player_by_unit(interactor_unit)
			local peer_id = player:peer_id()
			local requirements_met = self:_can_interact_with_unit(interactable_unit, peer_id)

			if not requirements_met then
				return "cannot afford"
			end

			return nil
		end

		unit_interactee_extension:register_block_text_function(block_func)
	else
		self:_update_interaction_presentation(interactable_unit)
	end
end

ExpeditionCollectiblesHandler._collectible_instance_by_id = function (self, collectible_id)
	local collectibles = self._collectibles

	for _, collectible in ipairs(collectibles) do
		if collectible:collectible_id() == collectible_id then
			return collectible
		end
	end
end

ExpeditionCollectiblesHandler.amount_collected_by_id = function (self, collectible_id, peer_id)
	local collectible = self:_collectible_instance_by_id(collectible_id)

	if not collectible then
		return 0
	end

	local collected_team_amount = collectible:collected_team_amount()
	local collected_player_amount = peer_id and collectible:collected_player_amount(peer_id)

	return collected_team_amount, collected_player_amount
end

ExpeditionCollectiblesHandler._can_interact_with_unit = function (self, interactable_unit, peer_id)
	local requirements_data = self._registered_unit_requirements[interactable_unit]

	if requirements_data then
		for collectible_id, requirement_data in pairs(requirements_data) do
			local collectible = self:_collectible_instance_by_id(collectible_id)
			local amount = requirement_data.amount
			local team_shared_usage = collectible:team_shared_usage()
			local collected_amount

			if team_shared_usage then
				local collected_team_amount = collectible:collected_team_amount()

				collected_amount = collected_team_amount
			else
				local collected_player_amount = collectible:collected_player_amount(peer_id)

				collected_amount = collected_player_amount
			end

			local requirements_met = amount <= collected_amount

			if not requirements_met then
				return false
			end
		end
	end

	return true
end

ExpeditionCollectiblesHandler._update_interaction_presentation = function (self, interactable_unit)
	local player = Managers.player:local_player(1)
	local peer_id = player:peer_id()
	local description_text = ""
	local can_interact = true
	local requirements_found = 0
	local requirements_data = self._registered_unit_requirements[interactable_unit]

	for collectible_id, requirement_data in pairs(requirements_data) do
		local collectible = self:_collectible_instance_by_id(collectible_id)
		local amount = requirement_data.amount
		local team_shared_usage = collectible:team_shared_usage()
		local collected_amount

		if team_shared_usage then
			local collected_team_amount = collectible:collected_team_amount()

			collected_amount = collected_team_amount
		else
			local collected_player_amount = collectible:collected_player_amount(peer_id)

			collected_amount = collected_player_amount
		end

		local requirements_met = amount <= collected_amount

		if not requirements_met then
			can_interact = false
		end

		local collectible_settings = ExpeditionCollectibles[collectible_id]
		local collectible_display_name = collectible_settings.display_name

		if requirements_found > 0 then
			description_text = description_text .. ", "
		end

		description_text = description_text .. Localize(collectible_display_name)
		requirements_found = requirements_found + 1
	end

	local original_description = self._original_description_by_unit[interactable_unit]
	local unit_interactee_extension = ScriptUnit.has_extension(interactable_unit, "interactee_system")

	if can_interact then
		local text_context = {
			description = Localize(original_description),
			value = description_text,
		}

		unit_interactee_extension:set_block_text(nil)
		unit_interactee_extension:set_description("loc_interaction_description_has_requirement", text_context)
		Unit.flow_event(interactable_unit, "lua_update_interaction_presentation_enabled")
	else
		local key_value_color = Color.ui_red_light(255, true)
		local text_context = {
			description = Localize(original_description),
			value = description_text,
			r = key_value_color[2],
			g = key_value_color[3],
			b = key_value_color[4],
		}

		unit_interactee_extension:set_block_text("loc_group_finder_tag_requirement_warning")
		unit_interactee_extension:set_description("loc_interaction_description_missing_requirement", text_context)
		Unit.flow_event(interactable_unit, "lua_update_interaction_presentation_disabled")
	end
end

ExpeditionCollectiblesHandler._client_update_interactables_presentation = function (self)
	for unit, _ in pairs(self._registered_unit_requirements) do
		if Unit.alive(unit) then
			self:_update_interaction_presentation(unit)
		else
			self._original_description_by_unit[unit] = nil
			self._registered_unit_requirements[unit] = nil
		end
	end
end

ExpeditionCollectiblesHandler.event_on_interaction_success = function (self, interaction_unit, interactor_player)
	local requirement_data = self._registered_unit_requirements[interaction_unit]

	if not requirement_data then
		return
	end

	local interactor_peer_id = interactor_player:peer_id()
	local collectibles_by_id = self._collectibles_by_id

	if self._is_server then
		for collectible_id, data in pairs(requirement_data) do
			local amount = data.amount
			local collectible = collectibles_by_id[collectible_id]

			if collectible:consume_on_use() then
				local successful = collectible:server_deduct_amount(interactor_peer_id, amount)
			end
		end
	end

	self._registered_unit_requirements[interaction_unit] = nil
	self._original_description_by_unit[interaction_unit] = nil
end

ExpeditionCollectiblesHandler.on_gameplay_init = function (self)
	for _, collectible in pairs(self._collectibles) do
		collectible:on_gameplay_init()
	end
end

ExpeditionCollectiblesHandler.hot_join_sync = function (self, channel_id)
	for _, collectible in pairs(self._collectibles) do
		collectible:hot_join_sync(channel_id)
	end
end

ExpeditionCollectiblesHandler.update = function (self, dt, t)
	local collectibles_dirty = false

	for _, collectible in pairs(self._collectibles) do
		if collectible:collectible_calculations_dirty(dt, t) then
			collectibles_dirty = true

			break
		end
	end

	for _, collectible in pairs(self._collectibles) do
		collectible:update(dt, t)
	end

	if collectibles_dirty and (not self._is_server or not DEDICATED_SERVER) then
		self:_client_update_interactables_presentation()
	end
end

ExpeditionCollectiblesHandler.destroy = function (self)
	if self._is_server then
		self._network_event_delegate:unregister_events(unpack(SERVER_RPCS))
	else
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	local event_manager = Managers.event

	event_manager:unregister(self, "event_expedition_register_interactable_requirement")
	event_manager:unregister(self, "event_expedition_collectible_collected")
	event_manager:unregister(self, "event_on_interaction_success")

	for _, collectible in pairs(self._collectibles) do
		collectible:destroy()
	end

	self._collectibles = nil
	self._collectibles_by_id = nil
end

return ExpeditionCollectiblesHandler
