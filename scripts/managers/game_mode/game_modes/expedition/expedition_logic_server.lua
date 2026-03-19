-- chunkname: @scripts/managers/game_mode/game_modes/expedition/expedition_logic_server.lua

require("scripts/managers/game_mode/game_modes/expedition/expedition_logic_base")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local ExpeditionLogicSettings = require("scripts/managers/game_mode/game_modes/expedition/expedition_logic_settings")
local MasterItems = require("scripts/backend/master_items")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Pickups = require("scripts/settings/pickup/pickups")
local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local SingleLevelLoader = require("scripts/loading/loaders/single_level_loader")
local Vo = require("scripts/utilities/vo")
local locomotion_states = ProjectileLocomotionSettings.states
local SERVER_LEVEL_STATES = table.enum("blocked", "idle", "load_next_location", "wait_on_clients_level_despawn", "wait_on_server_level_despawn", "wait_on_clients_level_loading_and_spawn", "wait_on_server_levels_spawned", "registering_levels", "wait_on_server_sparse_graph_connected", "server_spawn_loaded_levels", "teleport_players_to_safe_zone", "teleport_players_from_safe_zone")

local function _log(...)
	Log.info("ExpeditionLogicServer", ...)
end

local ExpeditionLogicServer = class("ExpeditionLogicServer", "ExpeditionLogicBase")

ExpeditionLogicServer.init = function (self, network_event_delegate)
	self._is_server = true

	ExpeditionLogicServer.super.init(self, network_event_delegate)

	self._has_arrived = false
	self._first_location_pacing_started = false
	self._pacing_start_time = nil
	self._telemetry_end_game_result = nil
	self._transition_activator_units = {}
	self._minion_despawn_queue = {}
	self._blocked_start_time = nil
	self._players_spawned_next_location = {}
	self._players_started_despawning = {}

	local server_rpcs = ExpeditionLogicSettings.server_rpcs

	network_event_delegate:register_session_events(self, unpack(server_rpcs))

	local event_manager = Managers.event

	event_manager:register(self, "event_players_left_arrival_level", "event_players_left_arrival_level")
	event_manager:register(self, "event_start_location_safe_zone_door_defence_sequence", "event_start_location_safe_zone_door_defence_sequence")
	event_manager:register(self, "event_end_location_safe_zone_door_defence_sequence", "event_end_location_safe_zone_door_defence_sequence")
	event_manager:register(self, "event_expedition_validate_game_mode_completion", "event_expedition_validate_game_mode_completion")
	event_manager:register(self, "expedition_register_transition_activator", "expedition_register_transition_activator")
	event_manager:register(self, "expedition_unregister_transition_activator", "expedition_unregister_transition_activator")
	event_manager:register(self, "expedition_transition_activator_started", "expedition_transition_activator_started")

	self._dynamic_unit_spawning = {}
	self._airstrike_bomb_spawning = {}
	self._airstrike_supply_spawning = {}

	event_manager:register(self, "event_airstrike_drop_bomb", "event_airstrike_drop_bomb")
	event_manager:register(self, "event_airstrike_drop_supply", "event_airstrike_drop_supply")
	event_manager:register(self, "event_test_sky_mutator", "event_test_sky_mutator")
	event_manager:register(self, "event_expedition_smoke_grenade_airstrike_call_in", "event_expedition_smoke_grenade_airstrike_call_in")
	event_manager:register(self, "event_airstrike_started", "event_airstrike_started")
	event_manager:register(self, "event_airstrike_finished", "event_airstrike_finished")
	event_manager:register(self, "event_register_danger_zone", "event_register_danger_zone")
	event_manager:register(self, "event_unregister_danger_zone", "event_unregister_danger_zone")
end

ExpeditionLogicServer.event_start_location_safe_zone_door_defence_sequence = function (self, level, location_unit)
	local position = location_unit and Unit.world_position(location_unit, 1) or Vector3(0, 0, 0)
	local auto_event_context = {
		intial_cooldown_multiplier_value = "safe_room",
		worldposition = position,
		node_id = math.uuid(),
	}
	local auto_event_id = Managers.state.pacing:request_auto_event(auto_event_context)

	Managers.state.pacing:add_heat_on_oppertunity("escape_event", nil, "safe_room_event")

	self._active_defence_auto_event_id = auto_event_id

	Vo.set_story_ticker(false)
	Vo.set_npc_faction_memory("expeditions_opportunity_start_first_a", 0)

	if self._current_section_index == #self._expedition - 1 then
		Managers.event:trigger("event_disable_backfill")
	end
end

local function _get_location_level(levels_data)
	for i = 1, #levels_data do
		local level_data = levels_data[i]

		if level_data.is_location then
			return level_data.level
		end
	end
end

ExpeditionLogicServer.event_end_location_safe_zone_door_defence_sequence = function (self)
	local auto_event_id = self._active_defence_auto_event_id

	if auto_event_id then
		Managers.state.pacing:request_auto_event_end(auto_event_id)
	end

	local expedition = self._expedition

	for _, section in ipairs(expedition) do
		local levels_data = section.levels_data

		for _, level_data in ipairs(levels_data) do
			if level_data.template_type == "connector_exit_level" then
				local level = level_data.level

				if level then
					Level.trigger_event(level, "event_allow_players_leave_location")

					local custom_data = level_data.custom_data
					local level_slot_id = custom_data.level_slot_id
					local location_level = _get_location_level(levels_data)
					local level_slot_unit = Level.unit_by_id(location_level, level_slot_id)

					Unit.flow_event(level_slot_unit, "lua_players_can_enter_airlock")
				end
			end
		end
	end
end

ExpeditionLogicServer.on_gameplay_init = function (self)
	ExpeditionLogicServer.super.on_gameplay_init(self)
end

ExpeditionLogicServer.on_gameplay_post_init = function (self)
	local mission_objective_system = Managers.state.extension:system("mission_objective_system")
	local current_level_id = Managers.state.unit_spawner:current_level_id()

	self._levels_spawner:server_assign_register_spawned_levels(current_level_id)

	repeat
		-- Nothing
	until self._levels_spawner:register_spawned_levels_sliced()

	self:_setup_roamer_groups()
	self:_set_server_level_state(SERVER_LEVEL_STATES.idle)

	local increment = self._current_section_index
	local max_incremented = #self._expedition

	mission_objective_system:start_mission_objective("expedition_location", nil, nil, nil, increment, max_incremented)
	self:_server_update_location_objective()
	self:start_location_events()
	ExpeditionLogicServer.super.on_gameplay_post_init(self)
end

ExpeditionLogicServer._server_update_location_objective = function (self)
	local mission_objective_system = Managers.state.extension:system("mission_objective_system")
	local location_objective = mission_objective_system:active_objective("expedition_location")

	if location_objective then
		location_objective:set_increment(0)
		mission_objective_system:external_update_mission_objective("expedition_location", nil, 0, self._current_section_index)
	end
end

ExpeditionLogicServer.minion_steal = function (self, player_unit, unit)
	self._minion_loot_handler:event_minion_loot(player_unit, unit)
end

ExpeditionLogicServer.set_minion_spawn_loot_amount = function (self, unit, starting_amount)
	self._minion_loot_handler:_set_spawn_amount(unit, starting_amount)
end

ExpeditionLogicServer.check_minion_loot = function (self, unit)
	return self._minion_loot_handler:check_minion_loot(unit)
end

ExpeditionLogicServer.remove_minion_loot = function (self, unit)
	return self._minion_loot_handler:remove_minion_loot(unit)
end

ExpeditionLogicServer.current_location_index = function (self)
	return self._current_section_index
end

ExpeditionLogicServer._on_gameplay_paused = function (self)
	ExpeditionLogicServer.super._on_gameplay_paused(self)

	self._in_safe_zone = true

	Managers.event:trigger("in_safe_volume", true)
	self:stop_all_events()
	Vo.set_story_ticker(false)
end

ExpeditionLogicServer._on_gameplay_resume = function (self)
	ExpeditionLogicServer.super._on_gameplay_resume(self)

	self._in_safe_zone = false

	Managers.event:trigger("in_safe_volume", false)
	self:start_location_events()
	Vo.set_story_ticker(true)
	Vo.set_npc_faction_memory("expeditions_opportunity_start_first_a", 1)
end

ExpeditionLogicServer.get_mission_level_name = function (self)
	local current_section_index = self._current_section_index
	local level_name_untruncated = self._expedition[current_section_index].location_level_name
	local mission_name = level_name_untruncated:match("([^/]+)$")

	return mission_name
end

ExpeditionLogicServer.get_expedition_template = function (self)
	return self._expedition_template
end

ExpeditionLogicServer._set_server_level_state = function (self, new_state)
	local previous_state = self._server_level_state and self._server_level_state or "-"

	_log("CHANING STATE: " .. new_state .. " - OLD STATE:" .. previous_state)

	self._server_level_state = new_state
end

ExpeditionLogicServer._server_sync_registered_levels_with_clients = function (self, optional_channel)
	local game_session_manager = Managers.state.game_session
	local expedition = self._expedition

	for _, section in ipairs(expedition) do
		local levels_data = section.levels_data

		for _, level_data in ipairs(levels_data) do
			local spawned = level_data.spawned
			local level_id = level_data.level_id
			local wanted_level_id = level_data.wanted_level_id

			if spawned and (level_id or wanted_level_id) then
				local expedition_level_id = level_data.expedition_level_id

				if optional_channel then
					RPC.rpc_register_expedition_level(optional_channel, expedition_level_id, level_id or wanted_level_id)
				else
					game_session_manager:send_rpc_clients("rpc_register_expedition_level", expedition_level_id, level_id or wanted_level_id)
				end
			end
		end
	end
end

ExpeditionLogicServer.hot_join_sync = function (self, sender, channel)
	ExpeditionLogicServer.super.hot_join_sync(self, sender, channel)

	local player = Managers.player:player_from_channel_id(channel)
	local unique_id = player:unique_id()

	self._players_spawned_next_location[unique_id] = true

	self:_server_sync_registered_levels_with_clients(channel)
	RPC.rpc_expedition_on_location_setup(channel)
	self:_server_hot_join_sync_active_safe_zone(channel)

	local danger_zones = self._danger_zones

	for i = 1, #danger_zones do
		local danger_zone = danger_zones[i]
		local unit = danger_zone.unit

		if Unit.alive(unit) then
			local is_level_unit, unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(unit)

			RPC.rpc_register_expedition_danger_zone(channel, unit_id, is_level_unit, danger_zone.position, danger_zone.proximity_distance)
		end
	end

	self._loot_handler:hot_join_sync(channel)
	self._currency_handler:hot_join_sync(channel)
	self._navigation_handler:hot_join_sync(channel)
	self._timer_handler:hot_join_sync(channel)
end

ExpeditionLogicServer.rpc_server_expedition_levels_despawned_by_player = function (self, channel_id)
	if self._server_level_state == SERVER_LEVEL_STATES.wait_on_clients_level_despawn then
		local player = Managers.player:player_from_channel_id(channel_id)
		local unique_id = player:unique_id()

		self._players_started_despawning[unique_id] = true
	else
		Log.exception("ExceptionLogicServer", "rpc_server_expedition_levels_despawned_by_player received at the wrong state!")
	end
end

ExpeditionLogicServer.rpc_server_location_loaded_and_spawned_by_player = function (self, channel_id, current_location_index)
	if self._server_level_state == SERVER_LEVEL_STATES.wait_on_clients_level_loading_and_spawn then
		local player = Managers.player:player_from_channel_id(channel_id)
		local unique_id = player:unique_id()

		self._players_spawned_next_location[unique_id] = true
	end
end

ExpeditionLogicServer._server_assign_teleporter_unit = function (self, teleporter_unit)
	if not self._teleporter_unit then
		self._teleporter_unit = teleporter_unit
	end
end

ExpeditionLogicServer._load_location_by_index = function (self, new_index)
	self._current_section_index = new_index

	local mechanism_manager = Managers.mechanism
	local mechanism = mechanism_manager:current_mechanism()

	mechanism:set_current_location_index(new_index)

	local expedition = self._expedition
	local next_section = expedition[new_index]
	local levels_data = next_section.levels_data
	local theme_tag = next_section.theme_tag

	for _, level_data in ipairs(levels_data) do
		local level_name = level_data.level_name
		local level_loader = SingleLevelLoader:new()

		level_loader:start_loading({
			level_name = level_name,
			theme_tag = theme_tag,
			dont_load_theme = not level_data.is_location and not level_data.is_safe_zone,
		})

		level_data.level_loader = level_loader
	end
end

ExpeditionLogicServer._spawn_loaded_levels = function (self)
	local levels_spawner = self._levels_spawner
	local levels_added = false
	local expedition = self._expedition

	for _, section in ipairs(expedition) do
		local levels_data = section.levels_data

		for _, level_data in ipairs(levels_data) do
			local level_loader = level_data.level_loader

			if level_loader and level_loader:is_loading_done() and not level_data.spawned and not level_data.was_spawned then
				levels_spawner:add_level_to_queue(level_data)

				levels_added = true
			end
		end
	end

	if levels_added then
		local force_spawn = true

		levels_spawner:spawn_queued_levels(force_spawn)
	end
end

ExpeditionLogicServer._clear_location_systems = function (self)
	Managers.state.game_session:send_rpc_clients("rpc_expedition_clear_location_systems")

	if not table.is_empty(self._minion_despawn_queue) then
		Log.warning("ExpeditionLogicServer", "%s minions were still in the despawn que on location clear", #self._minion_despawn_queue)
		table.clear(self._minion_despawn_queue)
	end

	Managers.state.minion_spawn:despawn_all_minions()
	Managers.state.pacing:reset()
	ExpeditionLogicServer.super._clear_location_systems(self)
end

ExpeditionLogicServer._get_active_safe_zone_section = function (self)
	local expedition = self._expedition

	for _, section in ipairs(expedition) do
		local levels_data = section.levels_data

		for _, level_data in ipairs(levels_data) do
			if level_data.template_type == "safe_zone_level" and level_data.spawned then
				return section
			end
		end
	end
end

ExpeditionLogicServer._server_update_safe_zone = function (self, force_update)
	local safe_zone_section = self:_get_active_safe_zone_section()

	if not safe_zone_section then
		return
	end

	local safe_zone_section_index = safe_zone_section.index
	local update_products_presentation = false
	local currency_handler = self._currency_handler
	local collected_team_currency = currency_handler:collected_team_currency()

	if not safe_zone_section.latest_currency_update or safe_zone_section.latest_currency_update ~= collected_team_currency or force_update then
		safe_zone_section.latest_currency_update = collected_team_currency
		update_products_presentation = true
	end

	local expedition = self._expedition
	local current_section = expedition[safe_zone_section_index]
	local store_info = current_section.store_info
	local store_product_info = store_info.pickups
	local loot_handler = self._loot_handler
	local collected_team_loot = loot_handler:collected_team_loot()

	if not safe_zone_section.latest_loot_update or safe_zone_section.latest_loot_update ~= collected_team_loot or force_update then
		safe_zone_section.latest_loot_update = collected_team_loot

		local store_units = safe_zone_section.store_units

		if store_units then
			local game_session_manager = Managers.state.game_session
			local unit_spawner_manager = Managers.state.unit_spawner
			local purchase_data_by_store_unit = safe_zone_section.purchase_data_by_store_unit or {}
			local pickup_spawner_index = 1
			local random_pickup_spawners = {}

			for i = 1, #store_units do
				local store_unit = store_units[i]

				if Unit.alive(store_unit) then
					local pickup_type = Unit.get_data(store_unit, "pickup_type")
					local interactee_extension = ScriptUnit.has_extension(store_unit, "interactee_system")
					local interaction_type = interactee_extension and interactee_extension:interaction_type()
					local interaction_only = (store_product_info[interaction_type] or store_product_info[pickup_type]) ~= nil
					local store_unit_pickup_extension = ScriptUnit.has_extension(store_unit, "pickup_system")
					local has_next_item = not interaction_only and store_unit_pickup_extension:has_next_item()
					local has_pickups_to_spawn = has_next_item and store_unit_pickup_extension:spawnable_pickups_amount() > 0

					if has_pickups_to_spawn or interaction_only then
						local existing_pickup_data = purchase_data_by_store_unit[store_unit]
						local pickup_info = existing_pickup_data and existing_pickup_data.info
						local has_charges_left = pickup_info and (not pickup_info.charges or pickup_info.charges ~= 0)

						if not existing_pickup_data or not interaction_only and not Unit.alive(existing_pickup_data.pickup_unit) and has_charges_left then
							if interaction_only then
								local success = self:_register_safe_zone_pickup_unit_by_pickup_spawner_unit(safe_zone_section_index, nil, store_unit)

								if success then
									local store_unit_level_id = unit_spawner_manager:level_index(store_unit)

									game_session_manager:send_rpc_clients("rpc_register_safe_zone_store_unit", safe_zone_section_index, store_unit_level_id)
								end
							else
								local pickup_unit = not interaction_only and store_unit_pickup_extension:spawn_item()
								local success = self:_register_safe_zone_pickup_unit_by_pickup_spawner_unit(safe_zone_section_index, pickup_unit, store_unit)

								if success then
									local pickup_spawner_level_id = unit_spawner_manager:level_index(store_unit)
									local pickup_game_object_id = unit_spawner_manager:game_object_id(pickup_unit)

									game_session_manager:send_rpc_clients("rpc_register_safe_zone_pickup_unit_by_pickup_spawner_unit", safe_zone_section_index, pickup_game_object_id, pickup_spawner_level_id)
								end
							end
						end
					else
						random_pickup_spawners[#random_pickup_spawners + 1] = store_unit
					end
				end
			end

			local random_store_products_to_spawn = safe_zone_section.random_store_products_to_spawn

			for i = 1, #random_store_products_to_spawn do
				local store_product_to_spawn = random_store_products_to_spawn[i]

				if pickup_spawner_index > #random_pickup_spawners then
					break
				end

				local store_unit = random_pickup_spawners[pickup_spawner_index]
				local store_unit_pickup_extension = ScriptUnit.has_extension(store_unit, "pickup_system")
				local unit_interaction_extension = ScriptUnit.has_extension(store_unit, "interaction_system")
				local interaction_only = not store_unit_pickup_extension and unit_interaction_extension
				local existing_pickup_data = purchase_data_by_store_unit[store_unit]
				local pickup_info = existing_pickup_data and existing_pickup_data.info
				local has_charges_left = pickup_info and (not pickup_info.charges or pickup_info.charges ~= 0)

				if not existing_pickup_data or not interaction_only and not Unit.alive(existing_pickup_data.pickup_unit) and has_charges_left then
					local component_index
					local pickup_name = store_product_to_spawn
					local check_reserve = false

					if interaction_only then
						local success = self:_register_safe_zone_pickup_unit_by_pickup_spawner_unit(safe_zone_section_index, nil, store_unit)

						if success then
							local store_unit_level_id = unit_spawner_manager:level_index(store_unit)

							game_session_manager:send_rpc_clients("rpc_register_safe_zone_store_unit", safe_zone_section_index, store_unit_level_id)
						end
					else
						local pickup_unit = store_unit_pickup_extension:spawn_specific_item(component_index, pickup_name, check_reserve)
						local success = self:_register_safe_zone_pickup_unit_by_pickup_spawner_unit(safe_zone_section_index, pickup_unit, store_unit)

						if success then
							local pickup_spawner_level_id = unit_spawner_manager:level_index(store_unit)
							local pickup_game_object_id = unit_spawner_manager:game_object_id(pickup_unit)

							game_session_manager:send_rpc_clients("rpc_register_safe_zone_pickup_unit_by_pickup_spawner_unit", safe_zone_section_index, pickup_game_object_id, pickup_spawner_level_id)
						end
					end
				end

				pickup_spawner_index = pickup_spawner_index + 1
			end

			update_products_presentation = true
		end
	end

	if update_products_presentation then
		local purchase_data_by_store_unit = safe_zone_section.purchase_data_by_store_unit or {}

		for owner_unit, pickup_data in pairs(purchase_data_by_store_unit) do
			self:_refresh_safe_zone_unit_store_data_presentation(pickup_data)
		end
	end
end

ExpeditionLogicServer.expedition_currency = function (self, optional_peer_id)
	local currency_handler = self._currency_handler
	local peer_id = optional_peer_id or Network.peer_id()
	local collected_player_currency = currency_handler:collected_player_currency(peer_id)

	return collected_player_currency
end

ExpeditionLogicServer._server_hot_join_sync_active_safe_zone = function (self, channel_id)
	local safe_zone_section = self:_get_active_safe_zone_section()

	if not safe_zone_section then
		return
	end

	if self._in_safe_zone then
		RPC.rpc_expedition_on_gameplay_pause(channel_id)

		if self._server_level_state == SERVER_LEVEL_STATES.idle then
			RPC.rpc_can_proceed_to_safe_zone_exit(channel_id, safe_zone_section.index)
		end
	end

	local purchase_data_by_store_unit = safe_zone_section.purchase_data_by_store_unit

	if purchase_data_by_store_unit then
		local unit_spawner_manager = Managers.state.unit_spawner
		local safe_zone_section_index = safe_zone_section.index

		for store_unit, pickup_data in pairs(purchase_data_by_store_unit) do
			local pickup_unit = pickup_data.pickup_unit

			if pickup_unit then
				local pickup_spawner_level_id = unit_spawner_manager:level_index(store_unit)
				local pickup_game_object_id = unit_spawner_manager:game_object_id(pickup_unit)

				RPC.rpc_register_safe_zone_pickup_unit_by_pickup_spawner_unit(channel_id, safe_zone_section_index, pickup_game_object_id, pickup_spawner_level_id)
			else
				local store_unit_level_id = unit_spawner_manager:level_index(store_unit)

				RPC.rpc_register_safe_zone_store_unit(channel_id, safe_zone_section_index, store_unit_level_id)
			end
		end
	end
end

ExpeditionLogicServer.server_perform_purchase = function (self, pickup_unit, player)
	local pickup_data = self:_get_safe_zone_product_data_by_purchase_unit(pickup_unit)
	local pickup_info = pickup_data.info
	local purchase_price = pickup_info.price
	local pickup_name = pickup_data.pickup_name

	if pickup_info.charges and pickup_info.charges > 0 then
		pickup_info.charges = pickup_info.charges - 1
	end

	local peer_id = player:peer_id()

	if player:is_human_controlled() then
		self._currency_handler:server_deduct_player_currency(peer_id, purchase_price)
		Managers.stats:record_private("hook_expedition_spent_in_store", player, purchase_price)

		local expedition = self._expedition
		local current_section_index = self._current_section_index
		local current_section = expedition[current_section_index]
		local players_purchases = current_section.players_purchases
		local character_id = player:character_id()

		if not players_purchases[character_id] then
			players_purchases[character_id] = {}
		end

		local current_player_purchases = players_purchases[character_id]
		local current_player_product_purchases = current_player_purchases[pickup_name] or 0

		current_player_purchases[pickup_name] = (current_player_product_purchases or 0) + 1

		local fx_extension = ScriptUnit.has_extension(player.player_unit, "fx_system")

		if fx_extension then
			fx_extension:trigger_wwise_event("wwise/events/player/play_expeditions_loot_buy", true)
		end

		if Managers.telemetry_events then
			local active_safe_zone_section = self:_get_active_safe_zone_section()
			local safe_zone_section_index = active_safe_zone_section.index

			Managers.telemetry_events:expedition_store_purchase(player, pickup_name, purchase_price, safe_zone_section_index)
		end
	end

	if pickup_data.is_pickup then
		pickup_data.pickup_unit = nil
	end

	local done_callback

	Managers.event:trigger("event_add_notification_message", "default", "[DEV] Purchased " .. pickup_name .. " for " .. purchase_price, nil, nil, done_callback)

	local original_description = pickup_data.original_description
	local original_extra_description = pickup_data.original_extra_description
	local is_level_unit, pickup_unit_game_object_id = Managers.state.unit_spawner:game_object_id_or_level_index(pickup_unit)
	local charges_to_send_to_client = pickup_info.charges or -1

	Managers.state.game_session:send_rpc_clients("rpc_client_expedition_on_purchase_performed", peer_id, is_level_unit, pickup_unit_game_object_id, charges_to_send_to_client, original_description, original_extra_description or "")

	if not DEDICATED_SERVER then
		self:_reset_safe_zone_pickup_unit_presentation(pickup_unit, original_description, original_extra_description)

		if pickup_data.is_pickup then
			self:_client_purchase_flow_event()
		end
	end

	local force_update = true

	self:_server_update_safe_zone(force_update)
end

ExpeditionLogicServer.update = function (self, dt, t)
	if self._levels_spawner then
		self._levels_spawner:update(dt)
	end

	local minion_despawn_queue = self._minion_despawn_queue

	if #minion_despawn_queue > 0 then
		local minion_unit = minion_despawn_queue[1]

		if ALIVE[minion_unit] then
			Managers.state.minion_spawn:despawn_minion(minion_unit)
		end

		table.remove(minion_despawn_queue, 1)
	end

	local airstrike_bomb_spawning = self._airstrike_bomb_spawning

	if #airstrike_bomb_spawning > 0 then
		local next_bomb_to_spawn = table.remove(airstrike_bomb_spawning)

		self:_on_airstrike_drop_bomb(next_bomb_to_spawn)
	end

	local airstrike_supply_spawning = self._airstrike_supply_spawning

	if #airstrike_supply_spawning > 0 then
		local next_supply_to_spawn = table.remove(airstrike_supply_spawning)

		self:_on_airstrike_drop_supply(next_supply_to_spawn)
	end

	local dynamic_unit_spawning = self._dynamic_unit_spawning

	if #dynamic_unit_spawning > 0 then
		for i = #dynamic_unit_spawning, 1, -1 do
			local dynamic_unit_data = dynamic_unit_spawning[i]
			local delayed_spawn_time = dynamic_unit_data.delayed_spawn_time

			if delayed_spawn_time <= 0 then
				local next_supply_to_spawn = table.remove(dynamic_unit_spawning, i)

				self:_on_airstrike_drop_bomb(next_supply_to_spawn)
			else
				dynamic_unit_data.delayed_spawn_time = delayed_spawn_time - dt

				local position = dynamic_unit_data.boxed_position:unbox()
				local hit_position = dynamic_unit_data.hit_position:unbox()

				QuickDrawer:line(position, hit_position, Color.orange())
			end
		end
	end

	self._navigation_handler:server_update(dt, t)
	self:_server_update_safe_zone()

	local connection = Managers.connection
	local num_connections = connection:is_host() and connection:num_connections() or 0
	local num_clients_in_session = Managers.state.game_session:num_clients_in_session()
	local wait_for_joining_players = num_connections ~= num_clients_in_session
	local state = self._server_level_state

	if wait_for_joining_players then
		if self._blocked_start_time == nil then
			self._blocked_start_time = t

			_log("[WaitForPlayers] Start wait. Block state progression.")
		end

		state = SERVER_LEVEL_STATES.blocked
	elseif self._blocked_start_time then
		_log("[WaitForPlayers] End wait. Took %.2f seconds. Resume state progression.", t - self._blocked_start_time)

		self._blocked_start_time = nil
	end

	if state == SERVER_LEVEL_STATES.idle then
		if not self._first_location_pacing_started and self._current_section_index == 1 and Managers.state.main_path:is_main_path_ready() then
			self._first_location_pacing_started = true

			self:_set_pacing(true)
		end

		if self._teleporter_unit then
			self:_set_server_level_state(SERVER_LEVEL_STATES.teleport_players_to_safe_zone)
		elseif self._exit_safe_zone_location_unit then
			self:_set_server_level_state(SERVER_LEVEL_STATES.teleport_players_from_safe_zone)
		end
	elseif state == SERVER_LEVEL_STATES.load_next_location then
		local expedition = self._expedition
		local current_section_index = self._current_section_index

		if current_section_index < #expedition then
			local next_section_index = current_section_index + 1

			self:_load_location_by_index(next_section_index)
			self._levels_spawner:start_level_loading()
			self:_set_server_level_state(SERVER_LEVEL_STATES.wait_on_clients_level_loading_and_spawn)
			table.clear(self._players_spawned_next_location)
		else
			self:_set_server_level_state(SERVER_LEVEL_STATES.idle)
		end
	elseif state == SERVER_LEVEL_STATES.wait_on_clients_level_loading_and_spawn then
		local player_manager = Managers.player
		local players = player_manager:players()
		local all_clients_done = true
		local players_spawned_next_location = self._players_spawned_next_location

		for _, player in pairs(players) do
			local valid_player = player:is_human_controlled()

			if valid_player then
				local unique_id = player:unique_id()

				if players_spawned_next_location[unique_id] == nil then
					players_spawned_next_location[unique_id] = false

					local peer_id = player:peer_id()
					local current_section_index = self._current_section_index

					Managers.state.game_session:send_rpc_client("rpc_load_and_spawn_location", peer_id, current_section_index)

					all_clients_done = false
				elseif players_spawned_next_location[unique_id] == false then
					all_clients_done = false
				end
			end
		end

		if all_clients_done then
			self:_set_server_level_state(SERVER_LEVEL_STATES.server_spawn_loaded_levels)
		end
	elseif state == SERVER_LEVEL_STATES.server_spawn_loaded_levels then
		if self._levels_spawner:is_all_level_loading_done() then
			self._levels_spawner:unload_despawned_levels()
			self:_spawn_loaded_levels()
			self:_set_server_level_state(SERVER_LEVEL_STATES.wait_on_server_levels_spawned)
		end
	elseif state == SERVER_LEVEL_STATES.wait_on_server_levels_spawned then
		local levels_spawner = self._levels_spawner

		if levels_spawner:done() then
			levels_spawner:clear_done()

			local current_level_id = Managers.state.unit_spawner:current_level_id()

			levels_spawner:server_assign_register_spawned_levels(current_level_id)
			self:_server_sync_registered_levels_with_clients()
			self:_set_server_level_state(SERVER_LEVEL_STATES.registering_levels)
		end
	elseif state == SERVER_LEVEL_STATES.registering_levels then
		local done = self._levels_spawner:register_spawned_levels_sliced()

		if done then
			self:_set_server_level_state(SERVER_LEVEL_STATES.wait_on_server_sparse_graph_connected)
		end
	elseif state == SERVER_LEVEL_STATES.wait_on_server_sparse_graph_connected then
		local nav_mesh_manager = Managers.state.nav_mesh

		if nav_mesh_manager:is_sparse_graph_connected() then
			self:_setup_roamer_groups()
			self._levels_spawner:setup_main_path_for_level()
			Managers.state.extension:on_location_setup()
			Managers.state.game_session:send_rpc_clients("rpc_expedition_on_location_setup")

			local safe_zone_section = self:_get_active_safe_zone_section()

			if safe_zone_section then
				Managers.state.game_session:send_rpc_clients("rpc_can_proceed_to_safe_zone_exit", safe_zone_section.index)
				self:rpc_can_proceed_to_safe_zone_exit(nil, safe_zone_section.index)
			end

			self._levels_spawner:apply_location_themes()
			self:_set_server_level_state(SERVER_LEVEL_STATES.idle)
		end
	elseif state == SERVER_LEVEL_STATES.teleport_players_to_safe_zone then
		local current_section = self._expedition[self._current_section_index]

		if self._teleporter_unit then
			self._teleporter_unit = nil
		end

		self:_server_inform_all_players_teleporting_to_safe_zone()

		local safe_zone_level = current_section.safe_zone_level

		if safe_zone_level then
			local connector_exit_unit = current_section.connector_exit_unit
			local safe_zone_entrance_slot_unit = current_section.safe_zone_entrance_slot_unit
			local transition_level = current_section.connector_exit_level
			local volume_name = Level.has_volume(transition_level, "transition_area") and "transition_area" or nil

			self:_retain_last_environment(connector_exit_unit)
			self:_server_teleport_players_and_objects_to_target(safe_zone_entrance_slot_unit, connector_exit_unit, transition_level, volume_name)
			Level.trigger_event(safe_zone_level, "event_players_arrived_to_safe_zone")
		end

		self:_set_pacing(false)
		self._timer_handler:set_active(false)
		self._navigation_handler:set_active(false)
		self:_clear_location_systems()
		self:_spawn_dead_players()
		self._loot_handler:server_update_dropped_loot_pickups()
		self:_set_server_level_state(SERVER_LEVEL_STATES.wait_on_server_level_despawn)
		self._levels_spawner:start_despawning()
		self:_server_inform_all_players_on_safe_zone_enter()
	elseif state == SERVER_LEVEL_STATES.wait_on_server_level_despawn then
		local despawn_in_progress = self._levels_spawner:despawning()

		if not despawn_in_progress then
			table.clear(self._players_started_despawning)
			self:_set_server_level_state(SERVER_LEVEL_STATES.wait_on_clients_level_despawn)
		end
	elseif state == SERVER_LEVEL_STATES.teleport_players_from_safe_zone then
		local current_section = self._expedition[self._current_section_index]
		local last_section = self._expedition[self._current_section_index - 1]
		local connector_entrance_unit = current_section.connector_entrance_unit
		local exit_safe_zone_location_unit = self._exit_safe_zone_location_unit
		local transition_level = last_section.safe_zone_connector_exit_level
		local volume_name = Level.has_volume(transition_level, "transition_area") and "transition_area" or nil
		local respawn_beacon_system = Managers.state.extension:system("respawn_beacon_system")

		respawn_beacon_system:set_use_safe_zone(false)
		self:_server_teleport_players_and_objects_to_target(connector_entrance_unit, exit_safe_zone_location_unit, transition_level, volume_name)
		self:_set_pacing_time()

		if exit_safe_zone_location_unit then
			self._exit_safe_zone_location_unit = nil
		end

		self:_set_server_level_state(SERVER_LEVEL_STATES.idle)
		self:_server_inform_all_players_on_safe_zone_left()
		self:_server_update_location_objective()
	elseif state == SERVER_LEVEL_STATES.wait_on_clients_level_despawn then
		local player_manager = Managers.player
		local players = player_manager:players()
		local all_clients_done = true
		local players_started_despawning = self._players_started_despawning

		for _, player in pairs(players) do
			local valid_player = player:is_human_controlled()
			local unique_id = player:unique_id()

			if valid_player then
				if players_started_despawning[unique_id] == nil then
					players_started_despawning[unique_id] = false

					local peer_id = player:peer_id()

					Managers.state.game_session:send_rpc_client("rpc_expedition_start_despawning_levels", peer_id)

					all_clients_done = false
				elseif players_started_despawning[unique_id] == false then
					all_clients_done = false
				end
			end
		end

		if all_clients_done then
			self:_set_server_level_state(SERVER_LEVEL_STATES.load_next_location)
		end
	end

	ExpeditionLogicServer.super.update(self, dt, t)
end

ExpeditionLogicServer._spawn_dead_players = function (self)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local players_to_spawn = player_unit_spawn_manager:players_to_spawn()
	local force_spawn = true
	local is_respawn = false
	local current_section = self._expedition[self._current_section_index]
	local safe_zone_entrance_slot_unit = current_section.safe_zone_entrance_slot_unit
	local position, rotation, parent, side_name = Unit.world_position(safe_zone_entrance_slot_unit, 1), Unit.local_rotation(safe_zone_entrance_slot_unit, 1), nil, "heroes"

	for i = 1, #players_to_spawn do
		local player = players_to_spawn[i]

		player_unit_spawn_manager:spawn_player(player, position, rotation, parent, force_spawn, side_name, nil, "walking", is_respawn)
	end
end

ExpeditionLogicServer.next_spawn_point_identifier = function (self)
	if self._in_safe_zone then
		return "expedition_store"
	else
		return nil
	end
end

ExpeditionLogicServer._get_level_unit_by_value_key = function (self, level, key, value)
	local level_units = Level.units(level)

	for i = 1, #level_units do
		local unit = level_units[i]

		if Unit.get_data(unit, key) == value then
			return unit
		end
	end
end

ExpeditionLogicServer._get_units_by_key = function (self, level, key, index_table_by_value)
	local return_table = {}
	local level_units = Level.units(level)

	for i = 1, #level_units do
		local unit = level_units[i]
		local value = Unit.get_data(unit, key)

		if value ~= nil then
			if index_table_by_value then
				return_table[value] = unit
			else
				return_table[#return_table + 1] = unit
			end
		end
	end

	return return_table
end

ExpeditionLogicServer.event_expedition_started = function (self)
	ExpeditionLogicServer.super.event_expedition_started(self)
	self._timer_handler:set_active(true)
	self._navigation_handler:set_active(true)
	self:_set_pacing_time()
	Vo.mission_giver_mission_info_vo("selected_voice", "pilot_a", "expeditions_mission_start_a")

	if not self._navigation_handler:is_active() then
		Vo.set_npc_faction_memory("expeditions_mission_start_b", 1)
	end
end

ExpeditionLogicServer._disable_enemies_outside = function (self, unit)
	local perception_system = Managers.state.extension:system("perception_system")
	local navigation_system = Managers.state.extension:system("navigation_system")
	local behavior_system = Managers.state.extension:system("behavior_system")
	local side_system = Managers.state.extension:system("side_system")
	local side_name = side_system:get_default_player_side_name()
	local side = side_system:get_side_from_name(side_name)
	local enemy_minions = side:alive_units_by_tag("enemy", "minion")
	local num_enemy_minions = enemy_minions.size
	local unit_to_navigation_extension_map = navigation_system:unit_to_extension_map()
	local unit_to_perception_extension_map = perception_system:unit_to_extension_map()
	local unit_to_behavior_extension_map = behavior_system:unit_to_extension_map()
	local minions_to_despawn = self._minion_despawn_queue

	for i = 1, num_enemy_minions do
		local minion_unit = enemy_minions[i]

		if ALIVE[minion_unit] then
			local enemy_position = Unit.world_position(minion_unit, 1)

			if not Unit.is_point_inside_volume(unit, "c_volume", enemy_position) then
				local navigation_extension = unit_to_navigation_extension_map[minion_unit]
				local perception_extension = unit_to_perception_extension_map[minion_unit]

				unit_to_behavior_extension_map[minion_unit]:set_brain_enabled(false)
				perception_system:disable_update_function("MinionPerceptionExtension", "update", minion_unit, perception_extension)
				navigation_extension:stop()
				navigation_extension:set_enabled(false)

				minions_to_despawn[#minions_to_despawn + 1] = minion_unit
			end
		end
	end
end

ExpeditionLogicServer.event_expedition_airlock_sealed = function (self, hostile_area_unit)
	local current_section = self._expedition[self._current_section_index]
	local transition_level = current_section.connector_exit_level

	if transition_level then
		local level_index = Managers.state.unit_spawner:index_by_level(transition_level)

		if level_index then
			self._navigation_handler:exit_level_removed(level_index)
		end
	end

	if not self:_is_any_player_in_exit_airlock() then
		for unit, _ in pairs(self._transition_activator_units) do
			Unit.flow_event(unit, "lua_reactivate_extract_event")
		end

		return
	end

	self._timer_handler:location_finished(self._current_section_index)
	self._timer_handler:set_active(false)
	self._navigation_handler:set_active(false)
	self:clean_up_current_level_hazards()
	self:_set_pacing(false)

	local respawn_beacon_system = Managers.state.extension:system("respawn_beacon_system")
	local safe_zone_level = self._expedition[self._current_section_index].safe_zone_level
	local level_units = Level.units(safe_zone_level)
	local beacon_unit

	for i = 1, #level_units do
		local unit = level_units[i]

		if ScriptUnit.has_extension(unit, "respawn_beacon_system") then
			beacon_unit = unit

			break
		end
	end

	respawn_beacon_system:set_use_safe_zone(true, beacon_unit)

	if not hostile_area_unit then
		return
	end

	self._hostile_area_unit = hostile_area_unit

	self:_disable_enemies_outside(hostile_area_unit)

	if not transition_level then
		return
	end

	local volume_name = "transition_area"

	if not Level.has_volume(transition_level, volume_name) then
		return
	end

	local player_manager = Managers.player
	local players = player_manager:players()

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if player_unit and player:is_human_controlled() then
			local player_position = Unit.world_position(player_unit, 1)
			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
			local character_state_component = unit_data_extension:read_component("character_state")

			if not PlayerUnitStatus.is_hogtied(character_state_component) and player_position and not Level.is_point_inside_volume(transition_level, volume_name, player_position) then
				local dead_state_input = unit_data_extension:write_component("dead_state_input")

				dead_state_input.die = true
			end
		end
	end
end

ExpeditionLogicServer.event_expedition_airlock_closed = function (self)
	local hostile_area_unit = self._hostile_area_unit

	if not hostile_area_unit then
		return
	end

	Unit.flow_event(hostile_area_unit, "enable")

	self._hostile_area_unit = nil
end

ExpeditionLogicServer.event_expedition_resumed = function (self)
	ExpeditionLogicServer.super.event_expedition_resumed(self)
	self:_set_pacing(true)
	Managers.state.pacing:set_new_heat_stage(self._current_section_index)

	local mutator_manager = Managers.state.mutator
	local currently_active_mutators = mutator_manager:all_activated_mutators()

	for key, data in pairs(currently_active_mutators) do
		if data:reset() then
			data:reset()
		end
	end

	self._timer_handler:set_active(true)
	self._navigation_handler:set_active(true)
end

local function _player_health_percentage(player)
	local player_unit = player.player_unit
	local player_health = 0

	if player_unit then
		local unit_data_extension = ScriptUnit.has_extension(player.player_unit, "unit_data_system")

		if unit_data_extension then
			local character_state_component = unit_data_extension:read_component("character_state")

			if not PlayerUnitStatus.is_hogtied(character_state_component) then
				player_health = ScriptUnit.extension(player_unit, "health_system"):current_health_percent()
			end
		end
	end

	return player_health
end

ExpeditionLogicServer.send_gamemode_finished_telemetry = function (self, result, reason)
	local end_reason = reason or result == "won" and "victory_default" or "loss_default"
	local loot_handler = self._loot_handler
	local location_index = self._current_section_index
	local gameplay_time = Managers.time:time("gameplay")
	local time_remaining = self._timer_handler:get_remaining_duration()
	local end_game_result = self._telemetry_end_game_result or {
		extracted_loot_amount = 0,
		extracted_players = {},
		lost_loot_amount = loot_handler:collected_team_loot(),
	}
	local player_manager = Managers.player
	local players = player_manager:players()

	for _, player in pairs(players) do
		local player_health = _player_health_percentage(player)

		Managers.telemetry_events:expedition_finished(player, end_reason, location_index, gameplay_time, time_remaining, end_game_result.extracted_loot_amount, end_game_result.lost_loot_amount, end_game_result.extracted_players[player] ~= nil, loot_handler:collected_player_loot(player:peer_id()), player_health)
	end
end

ExpeditionLogicServer.event_expedition_teleport_players_from_store = function (self, level, exit_safe_zone_location_unit)
	self._exit_safe_zone_location_unit = exit_safe_zone_location_unit

	local loot_handler = self._loot_handler
	local currency_handler = self._currency_handler
	local location_index = self._current_section_index
	local gameplay_time = Managers.time:time("gameplay")
	local time_remaining = self._timer_handler:get_remaining_duration()
	local total_loot = loot_handler:collected_team_loot()
	local player_manager = Managers.player
	local players = player_manager:players()

	for _, player in pairs(players) do
		local player_health = _player_health_percentage(player)
		local peer_id = player:peer_id()

		Managers.telemetry_events:expedition_reached_location_index(player, location_index, gameplay_time, time_remaining, total_loot, loot_handler:collected_player_loot(peer_id), currency_handler:collected_player_currency(peer_id), player_health)
	end
end

ExpeditionLogicServer._is_any_player_in_exit_airlock = function (self)
	local current_section = self._expedition[self._current_section_index]
	local transition_level = current_section.connector_exit_level

	if not Level.has_volume(transition_level, "transition_area") then
		return false
	end

	local player_manager = Managers.player
	local players = player_manager:players()

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if player_unit then
			local player_position = Unit.world_position(player_unit, 1)

			if Level.is_point_inside_volume(transition_level, "transition_area", player_position) then
				return true
			end
		end
	end
end

ExpeditionLogicServer.event_expedition_teleport_players_to_store = function (self, level, teleporter_unit)
	self:_server_assign_teleporter_unit(teleporter_unit)
end

ExpeditionLogicServer._server_inform_all_players_on_safe_zone_left = function (self)
	Managers.state.game_session:send_rpc_clients("rpc_expedition_on_gameplay_resume")
	self:rpc_expedition_on_gameplay_resume()
end

ExpeditionLogicServer._server_inform_all_players_teleporting_to_safe_zone = function (self)
	Managers.state.game_session:send_rpc_clients("rpc_expedition_teleporting_to_safe_zone")
	self:_on_teleporting_to_safe_zone()
end

ExpeditionLogicServer._server_inform_all_players_on_safe_zone_enter = function (self)
	Managers.state.game_session:send_rpc_clients("rpc_expedition_on_gameplay_pause")
	self:_on_gameplay_paused()
end

local EMPTY_TAGS = {}

ExpeditionLogicServer._server_teleport_players_and_objects_to_target = function (self, target_unit, relative_unit, transition_level, volume_name)
	local function _new_rotation_and_position(previous_rotation, previous_position)
		local relative_rotation, relative_position = PlayerMovement.calculate_relative_rotation_position(relative_unit, previous_rotation, previous_position)

		return PlayerMovement.calculate_absolute_rotation_position(target_unit, relative_rotation, relative_position)
	end

	local function _teleport_player_companion(player)
		local player_unit = player.player_unit
		local companion_spawner_extension = ScriptUnit.extension(player_unit, "companion_spawner_system")
		local companion_units = companion_spawner_extension and companion_spawner_extension:companion_units()

		if companion_units then
			for i = 1, #companion_units do
				local companion_unit = companion_units[i]

				if companion_unit and ALIVE[companion_unit] then
					local companion_blackboard = BLACKBOARDS[companion_unit]
					local has_teleport_component = companion_blackboard and Blackboard.has_component(companion_blackboard, "teleport")

					if has_teleport_component then
						local destination_position
						local companion_position = Unit.world_position(companion_unit, 1)
						local companion_rotation = Unit.world_rotation(companion_unit, 1)

						if Level.is_point_inside_volume(transition_level, volume_name, companion_position) then
							local _, absolute_position = _new_rotation_and_position(companion_rotation, companion_position)

							destination_position = absolute_position
						else
							destination_position = POSITION_LOOKUP[target_unit]
						end

						local teleport_component = Blackboard.write_component(companion_blackboard, "teleport")

						teleport_component.teleport_position:store(destination_position)

						teleport_component.has_teleport_position = true
					end
				end
			end
		end
	end

	local player_manager = Managers.player
	local players = player_manager:players()

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if player_unit then
			local player_position = Unit.world_position(player_unit, 1)
			local player_rotation = Unit.world_rotation(player_unit, 1)
			local camera_manager = Managers.state.camera

			if camera_manager and player then
				local viewport_name = player.viewport_name
				local camera = camera_manager:has_camera(viewport_name)

				if camera then
					player_rotation = camera_manager:camera_rotation(viewport_name)
				end
			end

			local absolute_rotation, absolute_position = _new_rotation_and_position(player_rotation, player_position)
			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
			local character_state_component = unit_data_extension:read_component("character_state")

			if not PlayerUnitStatus.is_hogtied(character_state_component) then
				local teleport_companions = true
				local is_human_controlled = player:is_human_controlled()

				if player_position and Level.is_point_inside_volume(transition_level, volume_name, player_position) then
					PlayerMovement.teleport(player, absolute_position, absolute_rotation)
				elseif not is_human_controlled then
					PlayerMovement.teleport(player, POSITION_LOOKUP[target_unit], player_rotation)
				else
					local dead_state_input = unit_data_extension:write_component("dead_state_input")

					dead_state_input.die = true
					teleport_companions = false
				end

				if teleport_companions then
					_teleport_player_companion(player)
				end
			end
		end
	end

	local transition_units = {}

	local function register_transition_unit(unit, reference_type, source_context, optional_transition_tags, optional_cleanup_func, ...)
		local existing_data = transition_units[unit]

		if existing_data and reference_type == "soft" then
			return
		end

		transition_units[unit] = {
			reference_type = reference_type,
			source_context = source_context,
			transition_tags = optional_transition_tags or EMPTY_TAGS,
			optional_cleanup_func = optional_cleanup_func,
			cleanup_params = optional_cleanup_func and {
				...,
			},
		}
	end

	local pickup_system = Managers.state.extension:system("pickup_system")

	pickup_system:get_pickups_for_location_transition(register_transition_unit)

	local locomotion_system = Managers.state.extension:system("locomotion_system")

	locomotion_system:get_deployables_for_location_transition(register_transition_unit)

	for unit, transition_data in pairs(transition_units) do
		if ALIVE[unit] then
			if volume_name and Level.is_point_inside_volume(transition_level, volume_name, POSITION_LOOKUP[unit]) then
				local pickup_position = Unit.world_position(unit, 1)
				local pickup_rotation = Unit.world_rotation(unit, 1)
				local absolute_rotation, absolute_position = _new_rotation_and_position(pickup_rotation, pickup_position)
				local locomotion_extension = ScriptUnit.has_extension(unit, "locomotion_system")

				if locomotion_extension and locomotion_extension.external_move then
					locomotion_extension:external_move(absolute_position, absolute_rotation)
				end

				if transition_data.transition_tags.pickup then
					pickup_system:move_pickup(unit, absolute_position, absolute_rotation)
				end
			elseif transition_data.optional_cleanup_func then
				transition_data.optional_cleanup_func(unpack(transition_data.cleanup_params))
			else
				Managers.state.unit_spawner:mark_for_deletion(unit)
			end
		end
	end
end

ExpeditionLogicServer._game_world = function (self)
	local world_name = "level_world"
	local world = Managers.world:world(world_name)

	return world, self._nav_world
end

ExpeditionLogicServer.destroy = function (self)
	local event_manager = Managers.event

	event_manager:unregister(self, "event_airstrike_drop_bomb")
	event_manager:unregister(self, "event_airstrike_drop_supply")
	event_manager:unregister(self, "event_test_sky_mutator")
	event_manager:unregister(self, "event_expedition_smoke_grenade_airstrike_call_in")
	event_manager:unregister(self, "event_airstrike_started")
	event_manager:unregister(self, "event_airstrike_finished")
	event_manager:unregister(self, "event_register_danger_zone")
	event_manager:unregister(self, "event_unregister_danger_zone")
	event_manager:unregister(self, "expedition_register_transition_activator")
	event_manager:unregister(self, "expedition_unregister_transition_activator")
	event_manager:unregister(self, "event_players_left_arrival_level")
	event_manager:unregister(self, "event_start_location_safe_zone_door_defence_sequence")
	event_manager:unregister(self, "event_end_location_safe_zone_door_defence_sequence")
	event_manager:unregister(self, "event_expedition_validate_game_mode_completion")

	local server_rpcs = ExpeditionLogicSettings.server_rpcs

	self._network_event_delegate:unregister_events(unpack(server_rpcs))

	self._timer_handler = nil

	ExpeditionLogicServer.super.destroy(self)
end

ExpeditionLogicServer.event_players_left_arrival_level = function (self)
	local expedition = self._expedition

	for _, section in ipairs(expedition) do
		local levels_data = section.levels_data

		for _, level_data in ipairs(levels_data) do
			local level = level_data.level

			if level then
				Level.trigger_event(level, "event_trigger_arrival_leave")
			end
		end
	end

	Managers.event:unregister(self, "event_players_left_arrival_level")

	self._has_arrived = true
end

ExpeditionLogicServer._set_pacing = function (self, enabled)
	ExpeditionLogicServer.super._set_pacing(self, enabled)
	Managers.state.pacing:set_enabled(self._pacing_enabled)
end

ExpeditionLogicServer._set_pacing_time = function (self)
	self._pacing_start_time = Managers.time:time("gameplay")
end

ExpeditionLogicServer._setup_roamer_groups = function (self)
	local main_path_manager = Managers.state.main_path
	local roamer_group_count = #main_path_manager:group_locations()
	local roamer_groups_to_spawn = Managers.state.pacing:get_minimum_roamer_groups() - roamer_group_count

	for i = 1, roamer_groups_to_spawn do
		main_path_manager:add_group_location(Vector3(math.random(-92, 92), math.random(-92, 92), 0))
	end
end

ExpeditionLogicServer.pacing_update = function (self, dt, t)
	if not self._pacing_start_time then
		return 0
	end

	local rates = self:_get_pacing_rates()
	local progress = self:_calculate_progress(rates)

	return dt * progress
end

ExpeditionLogicServer._get_pacing_rates = function (self)
	local settings = self._expedition_template.pacing_settings

	return {
		base_rate = settings.progress_base_rate.numerator / settings.progress_base_rate.denominator,
		per_second = settings.progress_rate_per_second.numerator / settings.progress_rate_per_second.denominator,
		per_location = settings.progress_rate_per_location,
	}
end

ExpeditionLogicServer._calculate_progress = function (self, rates)
	local time_elapsed = Managers.time:time("gameplay") - self._pacing_start_time
	local location_progress = self._current_section_index * rates.per_location
	local time_progress = time_elapsed * rates.per_second

	return (location_progress + time_progress) * rates.base_rate
end

ExpeditionLogicServer.on_player_unit_despawn = function (self, player)
	if self._is_server then
		self._loot_handler:server_drop_player_loot(player)
	end
end

ExpeditionLogicServer.get_navigation_handler = function (self)
	return self._navigation_handler
end

ExpeditionLogicServer._retain_last_environment = function (self, connector_exit_unit)
	local target_level
	local expedition = self._expedition

	for _, section in ipairs(expedition) do
		local levels_data = section.levels_data

		for _, level_data in ipairs(levels_data) do
			if level_data.is_safe_zone_connector_entrance_level and level_data.level then
				target_level = level_data.level
			end
		end
	end

	local world = self:_game_world()
	local current_level = Unit.level(connector_exit_unit)
	local current_position = Unit.world_position(connector_exit_unit, 1) + Vector3(0, 0, 1)
	local target_volume_unit
	local data = {
		blend_layer = nil,
		blend_mask = nil,
		fade_in_distance = nil,
		shading_environment_resource_name = nil,
	}
	local environment_volumes = World.units_by_resource(world, "content/gizmos/volume_units/shading_environment/shading_environment_volume")

	for i = 1, #environment_volumes do
		local volume_unit = environment_volumes[i]
		local volume_level = Unit.level(volume_unit)

		if volume_level == current_level then
			local inside = Unit.is_point_inside_volume(volume_unit, "env_volume", current_position)

			if inside then
				local environment_extension = ScriptUnit.fetch_component_extension(volume_unit, "shading_environment_system")

				if environment_extension then
					local shading_environment_resource_name = environment_extension._shading_environment_resource_name
					local layer = environment_extension._layer

					if shading_environment_resource_name ~= nil and shading_environment_resource_name ~= "" and layer == 1 then
						data.fade_in_distance = environment_extension._fade_in_distance
						data.blend_layer = layer
						data.blend_mask = environment_extension._blend_mask == 0 and "ALL" or "OVERRIDES"
						data.shading_environment_resource_name = environment_extension._shading_environment_resource_name
					end
				end
			end
		elseif volume_level == target_level then
			local environment_extension = ScriptUnit.fetch_component_extension(volume_unit, "shading_environment_system")

			if environment_extension and environment_extension._shading_environment_resource_name == nil then
				target_volume_unit = volume_unit
			end
		end
	end

	if target_volume_unit and data.shading_environment_resource_name then
		local environment_extension = ScriptUnit.fetch_component_extension(target_volume_unit, "shading_environment_system")

		environment_extension:setup_from_component(data.fade_in_distance, data.blend_layer, data.blend_mask, data.shading_environment_resource_name, -1, true)
	end
end

local COLLISION_FILTER = "filter_player_mover"

ExpeditionLogicServer._ray_cast = function (self, from, to)
	local world = self:_game_world()
	local physics_world = World.physics_world(world)
	local to_target = to - from
	local direction, distance = Vector3.normalize(to_target), Vector3.length(to_target)
	local result, hit_position, hit_distance, normal, _ = PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", COLLISION_FILTER)

	return result, hit_position, hit_distance, normal
end

ExpeditionLogicServer.event_test_sky_mutator = function (self, spawn_data)
	local location_width = 256
	local start_delay = 5
	local PI = math.pi
	local impact_radius = 5
	local world = self:_game_world()

	for i = 1, 40 do
		local position = Vector3(-location_width * 0.5 + math.random(0, location_width), -location_width * 0.5 + math.random(0, location_width), 50)
		local result, hit_position, hit_distance, normal = self:_ray_cast(position, position + Vector3(0, 0, -100))

		if hit_position then
			local random_rotation = Quaternion.axis_angle(Vector3.forward(), math.random() * (math.pi * 2))

			self._dynamic_unit_spawning[#self._dynamic_unit_spawning + 1] = {
				boxed_position = Vector3Box(position),
				boxed_rotation = QuaternionBox(random_rotation),
				delayed_spawn_time = start_delay + i * 0.25,
				hit_position = Vector3Box(hit_position),
			}

			local diameter = impact_radius * 2
			local decal_unit_name = "content/levels/training_grounds/fx/decal_aoe_indicator"
			local decal_unit = World.spawn_unit_ex(world, decal_unit_name, nil, hit_position + Vector3(0, 0, 0.1))

			Unit.set_local_scale(decal_unit, 1, Vector3(diameter, diameter, 1))

			local random_rad = math.random() * PI
			local random_rot = Quaternion.axis_angle(Vector3.up(), random_rad)
			local decal_extents = Vector3(0.35, 0.35, 4)
			local game_time = Managers.time:time("gameplay")

			Managers.state.decal:add_projection_decal(decal_unit_name, position, Quaternion.identity(), normal, decal_extents, nil, nil, game_time)
		end
	end
end

ExpeditionLogicServer.event_airstrike_drop_supply = function (self, origin_unit)
	local origin_position = Unit.world_position(origin_unit, 1)
	local origin_rotation = Unit.world_rotation(origin_unit, 1)

	self._airstrike_supply_spawning[#self._airstrike_supply_spawning + 1] = {
		boxed_position = Vector3Box(origin_position),
		boxed_rotation = QuaternionBox(origin_rotation),
	}
end

ExpeditionLogicServer.event_airstrike_drop_bomb = function (self, origin_unit)
	local origin_position = Unit.world_position(origin_unit, 1)
	local origin_rotation = Unit.world_rotation(origin_unit, 1)

	self._airstrike_bomb_spawning[#self._airstrike_bomb_spawning + 1] = {
		boxed_position = Vector3Box(origin_position),
		boxed_rotation = QuaternionBox(origin_rotation),
	}
end

ExpeditionLogicServer.event_airstrike_started = function (self, unit, position)
	return
end

ExpeditionLogicServer.event_airstrike_finished = function (self, unit)
	self:event_unregister_danger_zone(unit)
end

ExpeditionLogicServer.event_expedition_smoke_grenade_airstrike_call_in = function (self, unit, position, direction)
	local airstrike_type = "bomb"

	self:_trigger_airstrike_spawn(airstrike_type, unit, position, direction)
end

ExpeditionLogicServer._trigger_airstrike_spawn = function (self, airstrike_type, unit, position, direction)
	local flat_dir = Vector3(direction.x, direction.y, 0)

	flat_dir = Vector3.normalize(flat_dir) * -1

	local game_session_manager = Managers.state.game_session
	local airstrikes_lookup_id = NetworkLookup.expedition_airstrikes[airstrike_type]

	game_session_manager:send_rpc_clients("rpc_spawn_expedition_airstrike", airstrikes_lookup_id, position, flat_dir)
	self:rpc_spawn_expedition_airstrike(nil, airstrikes_lookup_id, position, flat_dir)
	Vo.mission_giver_mission_info_vo("selected_voice", "pilot_a", "expeditions_valkyrie_support_a")
end

ExpeditionLogicServer._on_airstrike_drop_bomb = function (self, spawn_data)
	local position = spawn_data.boxed_position:unbox() + Vector3(0, 0, -5)
	local forward_rotation = Quaternion.flat_no_roll(spawn_data.boxed_rotation:unbox())
	local projectile_units = {}
	local units = {}
	local direction = Vector3.down()
	local check_vector = Vector3.dot(direction, Vector3.right()) < 1 and Vector3.right() or Vector3.forward()
	local start_axis = Vector3.cross(direction, check_vector)
	local angle_distrbution = math.pi
	local random_start_rotation = math.pi * 2 * math.random()
	local projectile_template = ProjectileTemplates.expedition_airstrike_nuke
	local material
	local item_name = "content/items/weapons/player/ranged/bullets/attack_valkyrie_bomb"
	local item_definitions = MasterItems.get_cached()
	local item = item_definitions[item_name]
	local starting_state = locomotion_states.manual_physics
	local max = math.pi / 10
	local angular_velocity = Vector3(math.random() * max, math.random() * max, math.random() * max)

	for i = 1, 1 do
		local random_position = position + Quaternion.right(forward_rotation) * math.random_range(2, -2)
		local angle = angle_distrbution * i + random_start_rotation + math.lerp(-angle_distrbution * 0.5, angle_distrbution * 0.5, math.random())
		local random_rotation = Quaternion.axis_angle(direction, angle)
		local flat_direction = Quaternion.rotate(random_rotation, start_axis)
		local random_alpha = math.random_range(0.9, 0.975)
		local random_direction = Vector3.lerp(flat_direction, direction, random_alpha) or Vector3.down()
		local speed = math.random_range(50, 60)
		local unit_template_name = projectile_template.unit_template_name or "item_projectile"
		local projectile_unit, _ = Managers.state.unit_spawner:spawn_network_unit(nil, unit_template_name, random_position, random_rotation, material, item, projectile_template, starting_state, random_direction, speed, angular_velocity)

		units[#units + 1] = projectile_unit
	end

	for _, unit in ipairs(units) do
		projectile_units[#projectile_units + 1] = unit
	end
end

ExpeditionLogicServer._on_airstrike_drop_supply = function (self, spawn_data)
	local position = spawn_data.boxed_position:unbox() + Vector3(0, 0, -5)
	local rotation = Quaternion.axis_angle(Vector3.forward(), 1)
	local projectile_unit_name = "content/environment/artsets/imperial/expeditions/airstrike/supply_drop/stock_pallet_crates_supply_drop_01"
	local random_x = math.random() * 2 - 1
	local random_y = math.random() * 2 - 1
	local random_z = math.random() * 2 - 1
	local random_direction = Vector3(random_x, random_y, random_z)
	local force_direction_boxed = Vector3Box(Vector3.normalize(random_direction))
	local unit_template_name = "expedition_airstrike_supply"
	local projectile_unit, _ = Managers.state.unit_spawner:spawn_network_unit(projectile_unit_name, unit_template_name, position, rotation, nil, force_direction_boxed)
end

ExpeditionLogicServer.event_register_danger_zone = function (self, unit, position, proximity_distance)
	local game_session_manager = Managers.state.game_session
	local is_level_unit, unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(unit)

	game_session_manager:send_rpc_clients("rpc_register_expedition_danger_zone", unit_id, is_level_unit, position, proximity_distance)
	self:rpc_register_expedition_danger_zone(nil, unit_id, is_level_unit, position, proximity_distance)
end

ExpeditionLogicServer.event_unregister_danger_zone = function (self, unit)
	local game_session_manager = Managers.state.game_session
	local is_level_unit, unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(unit)

	game_session_manager:send_rpc_clients("rpc_unregister_expedition_danger_zone", unit_id, is_level_unit)
	self:rpc_unregister_expedition_danger_zone(nil, unit_id, is_level_unit)
end

ExpeditionLogicServer.expedition_transition_activator_started = function (self, started_unit)
	for unit, _ in pairs(self._transition_activator_units) do
		if unit ~= started_unit then
			Unit.flow_event(unit, "lua_disable_transition_activator")
		end
	end
end

ExpeditionLogicServer.expedition_register_transition_activator = function (self, unit)
	self._transition_activator_units[unit] = true
end

ExpeditionLogicServer.expedition_unregister_transition_activator = function (self, unit)
	self._transition_activator_units[unit] = nil
end

ExpeditionLogicServer._loot_in_extraction_zone = function (self, volume_unit)
	local extension_manager = Managers.state.extension
	local pickup_system = extension_manager:system("pickup_system")
	local dropped_pickups = pickup_system:dropped_pickups()
	local loot_handler = self._loot_handler
	local total_dropped_loot = 0

	for unit, _ in pairs(dropped_pickups) do
		if Unit.alive(unit) then
			local unit_position = POSITION_LOOKUP[unit]
			local in_zone = Unit.is_point_inside_volume(volume_unit, "c_extraction_zone", unit_position)

			if in_zone then
				local pickup_name = Unit.get_data(unit, "pickup_type")
				local pickup_settings = Pickups.by_name[pickup_name]
				local loot_data = pickup_settings and pickup_settings.loot_data

				if loot_data then
					local is_expedition_loot = loot_data.is_expedition_loot

					if is_expedition_loot then
						local loot_type = loot_data.type
						local loot_tier = loot_data.tier
						local type_settings = loot_handler:loot_type_settings(loot_type)
						local amount = type_settings.values_per_tier[loot_tier]

						total_dropped_loot = total_dropped_loot + amount
					end
				end
			end
		end
	end

	return total_dropped_loot
end

ExpeditionLogicServer._players_in_extraction_zone = function (self, volume_unit)
	local players_in_zone = 0
	local players_in_extraction_zone = {}
	local player_manager = Managers.player
	local players = player_manager:players()

	for _, player in pairs(players) do
		local valid_player = player:is_human_controlled()

		if valid_player and player:unit_is_alive() then
			local player_unit = player.player_unit
			local player_position = POSITION_LOOKUP[player_unit]
			local in_zone = Unit.is_point_inside_volume(volume_unit, "c_extraction_zone", player_position)

			if in_zone then
				players_in_zone = players_in_zone + 1
				players_in_extraction_zone[player] = true
			end
		end
	end

	local any_player_in_extraction_zone = players_in_zone > 0

	return any_player_in_extraction_zone, players_in_extraction_zone
end

ExpeditionLogicServer.event_expedition_validate_game_mode_completion = function (self, volume_unit)
	local any_player_in_extraction_zone, extracted_players = self:_players_in_extraction_zone(volume_unit)

	if any_player_in_extraction_zone then
		local loot_handler = self._loot_handler
		local extracted_loot_amount = 0
		local player_extracted_count = 0

		for player, _ in pairs(extracted_players) do
			local peer_id = player:peer_id()
			local player_loot = loot_handler:collected_player_loot(peer_id)

			extracted_loot_amount = extracted_loot_amount + player_loot

			if loot_handler:collected_player_loot_by_type(player:peer_id(), "heavy") > 0 then
				Managers.stats:record_private("hook_loot_luggable_extracted", player)
				Managers.achievements:unlock_achievement(player, "expeditions_extract_with_luggable_loot")
			end

			player_extracted_count = player_extracted_count + 1
		end

		local loot_in_extraction_zone = self:_loot_in_extraction_zone(volume_unit)
		local collected_team_loot = loot_handler:collected_team_loot()
		local total_extracted_loot = extracted_loot_amount + loot_in_extraction_zone

		self._telemetry_end_game_result = {
			extracted_players = extracted_players,
			extracted_loot_amount = total_extracted_loot,
			lost_loot_amount = collected_team_loot - extracted_loot_amount,
		}

		Managers.stats:record_team("hook_expedition_loot_collected_by_team", total_extracted_loot)

		if self._current_section_index == #self._expedition then
			Managers.stats:record_team("hook_expedition_extract_at_last_location")

			if player_extracted_count >= GameParameters.max_players then
				Managers.stats:record_team("hook_expedition_extract_at_last_location_full_team")
			end
		end

		Managers.state.game_mode:complete_game_mode("extracted")
	else
		Managers.state.game_mode:fail_game_mode("extraction_timeout")
	end
end

return ExpeditionLogicServer
