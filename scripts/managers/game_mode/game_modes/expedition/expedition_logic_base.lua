-- chunkname: @scripts/managers/game_mode/game_modes/expedition/expedition_logic_base.lua

local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Expedition = require("scripts/utilities/expedition")
local ExpeditionAirstrikes = require("scripts/settings/expeditions/expedition_airstrikes")
local ExpeditionCurrencyHandler = require("scripts/utilities/expeditions/expedition_currency_handler")
local ExpeditionLootHandler = require("scripts/utilities/expeditions/expedition_loot_handler")
local ExpeditionMinionLootHandler = require("scripts/utilities/expeditions/expedition_minion_loot_handler")
local ExpeditionNavigationHandler = require("scripts/utilities/expeditions/expedition_navigation_handler")
local ExpeditionObjectivesHandler = require("scripts/utilities/expeditions/expedition_objectives_handler")
local ExpeditionTimerHandler = require("scripts/utilities/expeditions/expedition_timer_handler")
local SingleLevelLoader = require("scripts/loading/loaders/single_level_loader")
local Text = require("scripts/utilities/ui/text")
local ExpeditionEventTemplates = require("scripts/utilities/expeditions/expedition_event_templates")
local ExpeditionCollectiblesHandler = require("scripts/utilities/expeditions/expedition_collectibles_handler")
local ExpeditionPickupDistribution = require("scripts/utilities/expeditions/expedition_pickup_distribution")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local LevelGridHandler = require("scripts/utilities/levels/level_grid_handler")
local ExpeditionLogicTestify = GameParameters.testify and require("scripts/managers/game_mode/game_modes/expedition/expedition_logic_testify")

local function _log(...)
	Log.info("ExpeditionLogicBase", ...)
end

local ExpeditionLogicBase = class("ExpeditionLogicBase")

ExpeditionLogicBase.init = function (self, network_event_delegate)
	self._network_event_delegate = network_event_delegate

	local is_server = self._is_server
	local mechanism_manager = Managers.mechanism
	local mechanism = mechanism_manager:current_mechanism()
	local mechanism_data = mechanism:mechanism_data()

	self._delayed_notifications = {}
	self._current_section_index = mechanism_data.current_location_index
	self._current_safe_zone_section_index = 1

	local levels_spawner = mechanism:levels_spawner()

	self._levels_spawner = levels_spawner

	self._levels_spawner:assign_is_sever(is_server)

	self._expedition = levels_spawner:expedition()

	local expedition_template = levels_spawner:settings_template()

	self._expedition_template = expedition_template
	self._currency_handler = ExpeditionCurrencyHandler:new(expedition_template, is_server, network_event_delegate)
	self._loot_handler = ExpeditionLootHandler:new(expedition_template, is_server, network_event_delegate)
	self._minion_loot_handler = ExpeditionMinionLootHandler:new(expedition_template, is_server, network_event_delegate, self._loot_handler)
	self._navigation_handler = ExpeditionNavigationHandler:new(expedition_template, is_server, self:_game_world())
	self._objectives_handler = ExpeditionObjectivesHandler:new(expedition_template, is_server, network_event_delegate, self._expedition)
	self._collectibles_handler = ExpeditionCollectiblesHandler:new(expedition_template, is_server, network_event_delegate)
	self._timer_handler = ExpeditionTimerHandler:new(expedition_template, is_server)

	local level_grid_settings = expedition_template.level_grid_settings

	if level_grid_settings then
		self._level_grid_handler = LevelGridHandler:new(level_grid_settings, is_server, network_event_delegate)
	end

	self._active_events = {}
	self._event_counter_id = 0

	local event_manager = Managers.event

	event_manager:register(self, "event_on_hud_created", "event_on_hud_created")
	event_manager:register(self, "event_expedition_started", "event_expedition_started")
	event_manager:register(self, "event_expedition_airlock_sealed", "event_expedition_airlock_sealed")
	event_manager:register(self, "event_expedition_airlock_closed", "event_expedition_airlock_closed")
	event_manager:register(self, "event_expedition_resumed", "event_expedition_resumed")
	event_manager:register(self, "event_expedition_teleport_players_to_store", "event_expedition_teleport_players_to_store")
	event_manager:register(self, "event_expedition_teleport_players_from_store", "event_expedition_teleport_players_from_store")
	event_manager:register(self, "event_level_start_extraction", "event_level_start_extraction")
	event_manager:register(self, "event_expedition_start_event", "start_event")
	event_manager:register(self, "event_add_expedition_time_bonus", "event_add_expedition_time_bonus")

	self._airstrike_levels = {}
	self._airstrike_levels_to_despawn = {}

	event_manager:register(self, "event_airstrike_done", "event_airstrike_done")

	self._danger_zones = {}
end

ExpeditionLogicBase.on_gameplay_init = function (self)
	local nav_mesh_manager = Managers.state.nav_mesh
	local nav_world = nav_mesh_manager:nav_world()

	self._nav_world = nav_world

	self._timer_handler:setup_timer()
	self._levels_spawner:assign_nav_world(nav_world)
	self._levels_spawner:generate_navdata()
end

ExpeditionLogicBase.on_gameplay_post_init = function (self)
	self._loot_handler:on_gameplay_init()
	self._currency_handler:on_gameplay_init()
	self._collectibles_handler:on_gameplay_init()
	self._objectives_handler:on_gameplay_init()
	self:_set_pacing(false)
end

ExpeditionLogicBase.can_player_enter_game = function (self)
	local levels_spawner = self._levels_spawner

	if levels_spawner:is_post_levels_spawned_done() then
		return true
	end

	return false
end

ExpeditionLogicBase.in_safe_zone = function (self)
	return self._in_safe_zone
end

ExpeditionLogicBase.rpc_expedition_on_gameplay_pause = function (self, channel, safe_zone_section_index, is_hotjoin)
	self._current_safe_zone_section_index = safe_zone_section_index

	self:_on_gameplay_paused(is_hotjoin)
end

ExpeditionLogicBase.update = function (self, dt, t)
	self._timer_handler:update(dt, t)

	if self._level_grid_handler then
		self._level_grid_handler:update(dt, t)
	end

	self._loot_handler:update(dt, t)
	self._minion_loot_handler:update(dt, t)
	self._currency_handler:update(dt, t)
	self._collectibles_handler:update(dt, t)
	self._objectives_handler:update(dt, t)
	self._navigation_handler:update(dt, t)
	self:_update_levels_visibility()
	self:_update_events(dt, t)

	local airstrike_levels_to_despawn = self._airstrike_levels_to_despawn

	for level, _ in pairs(airstrike_levels_to_despawn) do
		self:_despawn_airstrike_level(level)
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(ExpeditionLogicTestify, self)
	end
end

ExpeditionLogicBase.get_level_data = function (self, check_level)
	local level_id = Level.get_data(check_level, "server_level_id")
	local expedition = self._expedition

	if expedition then
		for _, section in ipairs(expedition) do
			local levels_data = section.levels_data

			for _, level_data in ipairs(levels_data) do
				local level = level_data.level

				if level and level_data.spawned then
					local server_level_id = Level.get_data(level, "server_level_id")

					if server_level_id == level_id then
						return level_data
					end
				end
			end
		end
	end
end

ExpeditionLogicBase.get_all_levels_of_specified_tag = function (self, index, valid_types)
	local level_data_by_choosen_type = {}
	local expedition = self._expedition

	if expedition then
		local selected_section = expedition[index]
		local selected_section_levels_data = selected_section.levels_data

		for _, level_data in ipairs(selected_section_levels_data) do
			local level = level_data.level

			if level and level_data.spawned and level_data.tags then
				for i = 1, #level_data.tags do
					local tag = level_data.tags[i]

					if valid_types[tag] then
						level_data_by_choosen_type[#level_data_by_choosen_type + 1] = level_data
					end
				end
			end
		end
	end

	return level_data_by_choosen_type
end

ExpeditionLogicBase.minion_steal = function (self, player_unit, unit)
	self._minion_loot_handler:event_minion_loot(player_unit, unit)
end

ExpeditionLogicBase.set_minion_spawn_loot_amount = function (self, unit, starting_amount)
	self._minion_loot_handler:_set_spawn_amount(unit, starting_amount)
end

ExpeditionLogicBase.check_minion_loot = function (self, unit)
	return self._minion_loot_handler:check_minion_loot(unit)
end

ExpeditionLogicBase.remove_minion_loot = function (self, unit)
	return self._minion_loot_handler:remove_minion_loot(unit)
end

ExpeditionLogicBase.current_location_index = function (self)
	return self._current_section_index
end

ExpeditionLogicBase._on_gameplay_paused = function (self, is_hotjoin)
	_log("Gameplay Pause", is_hotjoin)

	local current_safe_zone_section_index = self._current_safe_zone_section_index

	self._in_safe_zone = true

	Managers.event:trigger("in_safe_zone")
	self._levels_spawner:apply_safe_zone_themes()

	local expedition = self._expedition

	for section_index, section in ipairs(expedition) do
		local belongs_to_current_safe_zone_section = current_safe_zone_section_index == section_index
		local levels_data = section.levels_data

		for _, level_data in ipairs(levels_data) do
			if level_data.level and level_data.spawned then
				local template_type = level_data.template_type
				local template = Expedition.get_level_template_by_type(template_type)
				local on_gameplay_pause_function = template and template.on_gameplay_pause_function

				if on_gameplay_pause_function then
					on_gameplay_pause_function(level_data, belongs_to_current_safe_zone_section, is_hotjoin)
				end
			end
		end
	end
end

ExpeditionLogicBase.rpc_expedition_clear_location_systems = function (self)
	self:_clear_location_systems()
end

ExpeditionLogicBase.rpc_expedition_navigation_complete_level = function (self, channel_id, level_index)
	self._navigation_handler:expedition_mark_level_complete(level_index)
end

ExpeditionLogicBase.rpc_expedition_set_navigation_active = function (self, channel_id, active)
	self._navigation_handler:set_active(active)
end

ExpeditionLogicBase.rpc_expedition_navigation_remove_exit = function (self, channel_id, level_index)
	self._navigation_handler:exit_level_removed(level_index)
end

local function _is_player_slot_on_channel_id(player_slot, channel_id)
	local peer_players = Managers.player:players_at_peer(Network.peer_id(channel_id))

	if not peer_players then
		return false
	end

	for _, player in pairs(peer_players) do
		local peer_player_slot = player.slot and player:slot()

		if player_slot == peer_player_slot then
			return true
		end
	end

	return false
end

ExpeditionLogicBase.rpc_expedition_navigation_set_slot_mark = function (self, channel_id, player_slot, level_index)
	if self._is_server then
		if not _is_player_slot_on_channel_id(player_slot, channel_id) then
			return
		end

		Managers.state.game_session:send_rpc_clients("rpc_expedition_navigation_set_slot_mark", player_slot, level_index)
	end

	self._navigation_handler:rpc_player_mark_level(player_slot, level_index)
end

ExpeditionLogicBase.rpc_expedition_navigation_clear_slot_mark = function (self, channel_id, player_slot)
	if self._is_server then
		if not _is_player_slot_on_channel_id(player_slot, channel_id) then
			return
		end

		Managers.state.game_session:send_rpc_clients("rpc_expedition_navigation_clear_slot_mark", player_slot)
	end

	self._navigation_handler:rpc_player_mark_level(player_slot, nil)
end

ExpeditionLogicBase.rpc_expedition_timer_set_active = function (self, channel_id, active)
	self._timer_handler:set_active(active)
end

ExpeditionLogicBase.rpc_expedition_on_gameplay_resume = function (self)
	self:_on_gameplay_resume()
end

ExpeditionLogicBase.rpc_expedition_on_location_setup = function (self)
	Managers.state.extension:on_location_setup()
end

ExpeditionLogicBase._update_levels_visibility = function (self)
	local in_safe_zone = self._in_safe_zone
	local current_safe_zone_section_index = self._current_safe_zone_section_index
	local expedition = self._expedition

	for section_index, section in ipairs(expedition) do
		local belongs_to_current_safe_zone_section = current_safe_zone_section_index == section_index
		local levels_data = section.levels_data

		for _, level_data in ipairs(levels_data) do
			local level = level_data.level

			if level and level_data.spawned then
				local template_type = level_data.template_type
				local template = Expedition.get_level_template_by_type(template_type)
				local visibility_function = template.visibility_function

				if visibility_function then
					local visible = visibility_function(level_data, belongs_to_current_safe_zone_section, in_safe_zone)

					if visible ~= level_data.visible then
						level_data.visible = visible

						Level.set_lod_level_type(level, visible and LodLevelType.SHOW_LEVEL or LodLevelType.HIDE)
					end
				end
			end
		end
	end
end

ExpeditionLogicBase._on_gameplay_resume = function (self)
	_log("Gameplay Resume")

	self._in_safe_zone = false

	Managers.event:trigger("left_safe_zone")

	local current_safe_zone_section_index = self._current_safe_zone_section_index
	local expedition = self._expedition

	for section_index, section in ipairs(expedition) do
		local belongs_to_current_safe_zone_section = current_safe_zone_section_index == section_index
		local levels_data = section.levels_data

		for _, level_data in ipairs(levels_data) do
			if level_data.level and level_data.spawned then
				local template_type = level_data.template_type
				local template = Expedition.get_level_template_by_type(template_type)
				local on_gameplay_resume_function = template and template.on_gameplay_resume_function

				if on_gameplay_resume_function then
					on_gameplay_resume_function(level_data, belongs_to_current_safe_zone_section)
				end
			end
		end
	end

	Managers.state.rooms_and_portals:reset()
	self._levels_spawner:apply_location_themes()

	local world = self:_game_world()

	World.set_data(world, "shadow_baked", false)
end

ExpeditionLogicBase.rpc_expedition_start_despawning_levels = function (self, channel_id)
	local levels_spawner = self._levels_spawner

	levels_spawner:start_despawning()

	self._report_after_despawning_levels = true
end

ExpeditionLogicBase.rpc_load_and_spawn_location = function (self, channel_id, new_index)
	Log.info("ExpeditionLogicBase", "Server changed current level location (%i)", new_index)

	self._report_when_section_spawned = true

	self:_load_location_by_index(new_index)

	local levels_spawner = self._levels_spawner

	levels_spawner:start_level_loading()
end

ExpeditionLogicBase.rpc_can_proceed_to_safe_zone_exit = function (self, channel_id, section_index)
	local expedition = self._expedition
	local section = expedition[section_index]
	local levels_data = section.levels_data

	for _, level_data in ipairs(levels_data) do
		local level = level_data.level

		if level_data.level and level_data.spawned then
			Level.trigger_event(level, "event_allow_players_leave_safe_zone")
		end
	end
end

ExpeditionLogicBase.event_on_hud_created = function (self)
	Managers.event:unregister(self, "event_on_hud_created")
	self._levels_spawner:apply_location_themes()
end

ExpeditionLogicBase._set_server_level_state = function (self, new_state)
	local previous_state = self._server_level_state and self._server_level_state or "-"

	_log("[ExpeditionLogicBase] - CHANING STATE: " .. new_state .. " - OLD STATE:" .. previous_state)

	self._server_level_state = new_state
end

ExpeditionLogicBase.hot_join_sync = function (self, sender, channel)
	self._collectibles_handler:hot_join_sync(channel)
	self._objectives_handler:hot_join_sync(channel)
	self:_hot_join_sync_location_events(channel)
end

ExpeditionLogicBase._load_location_by_index = function (self, new_index)
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

ExpeditionLogicBase.rpc_register_expedition_level = function (self, channel_id, expedition_level_id, level_id)
	local levels_spawner = self._levels_spawner

	levels_spawner:register_spawned_level_by_expedition_level_id(expedition_level_id, level_id)
end

ExpeditionLogicBase._spawn_loaded_levels = function (self)
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

ExpeditionLogicBase._clear_location_systems = function (self)
	if self._is_server then
		Managers.state.game_session:send_rpc_clients("rpc_expedition_clear_location_systems")
		Managers.state.minion_spawn:despawn_all_minions()
		Managers.state.pacing:reset()
	end

	local extension_manager = Managers.state.extension

	extension_manager:system("interactor_system"):reset()
	extension_manager:system("mission_objective_system"):evaluate_location_objectives()
	self._navigation_handler:reset()
	Managers.state.minion_death:delete_units()
	Managers.state.blood:delete_units()
end

ExpeditionLogicBase._get_active_safe_zone_section = function (self)
	local current_safe_zone_section_index = self._current_safe_zone_section_index
	local expedition = self._expedition
	local section = expedition[current_safe_zone_section_index]

	return section
end

ExpeditionLogicBase.loot_handler = function (self)
	return self._loot_handler
end

ExpeditionLogicBase.expedition_team_loot = function (self)
	local loot_handler = self._loot_handler
	local player_loot = loot_handler:collected_team_loot()

	return player_loot
end

ExpeditionLogicBase.expedition_loot = function (self, optional_peer_id)
	local loot_handler = self._loot_handler
	local peer_id = optional_peer_id or Network.peer_id()
	local player_loot = loot_handler:collected_player_loot(peer_id)

	return player_loot
end

ExpeditionLogicBase.expedition_currency = function (self, optional_peer_id)
	local currency_handler = self._currency_handler
	local peer_id = optional_peer_id or Network.peer_id()
	local collected_player_currency = currency_handler:collected_player_currency(peer_id)

	return collected_player_currency
end

ExpeditionLogicBase.rpc_register_safe_zone_store_unit = function (self, channel_id, section_index, store_unit_level_id, num_charges_left)
	local unit_spawner_manager = Managers.state.unit_spawner
	local store_unit = unit_spawner_manager:unit(store_unit_level_id, true)

	self:_register_safe_zone_pickup_unit_by_pickup_spawner_unit(section_index, nil, store_unit, num_charges_left)
end

ExpeditionLogicBase.rpc_register_safe_zone_pickup_unit_by_pickup_spawner_unit = function (self, channel_id, section_index, pickup_game_object_id, pickup_spawner_level_id, num_charges_left)
	local unit_spawner_manager = Managers.state.unit_spawner
	local pickup_spawner_unit = unit_spawner_manager:unit(pickup_spawner_level_id, true)
	local pickup_unit = unit_spawner_manager:unit(pickup_game_object_id) or pickup_spawner_unit

	self:_register_safe_zone_pickup_unit_by_pickup_spawner_unit(section_index, pickup_unit, pickup_spawner_unit, num_charges_left)
end

ExpeditionLogicBase._register_safe_zone_pickup_unit_by_pickup_spawner_unit = function (self, section_index, pickup_unit, spawner_unit, num_charges_left)
	local expedition = self._expedition
	local current_section = expedition[section_index]
	local purchase_data_by_store_unit = current_section.purchase_data_by_store_unit or {}

	current_section.purchase_data_by_store_unit = purchase_data_by_store_unit

	local pickup_name = pickup_unit and Unit.get_data(pickup_unit, "pickup_type") or Unit.get_data(spawner_unit, "pickup_type")
	local is_pickup = pickup_name ~= nil
	local name

	if is_pickup then
		name = pickup_name
	else
		local interactee_extension = ScriptUnit.has_extension(spawner_unit, "interactee_system")
		local interaction_type = interactee_extension and interactee_extension:interaction_type()

		name = interaction_type
	end

	local unit_interactee_extension = ScriptUnit.has_extension(pickup_unit or spawner_unit, "interactee_system")
	local store_info = current_section.store_info
	local store_product_info = store_info.pickups
	local product_info = store_product_info[name]

	if product_info then
		local product_data = {
			is_pickup = is_pickup,
			name = name,
			pickup_name = name,
			spawner_unit = spawner_unit,
			pickup_unit = is_pickup and pickup_unit or nil,
			original_description = unit_interactee_extension:description(),
			original_extra_description = unit_interactee_extension:extra_description(),
			info = product_info,
		}

		if num_charges_left and num_charges_left > -1 then
			local pickup_info = product_data.info

			pickup_info.charges = num_charges_left
		end

		purchase_data_by_store_unit[spawner_unit] = product_data

		self:_refresh_safe_zone_unit_store_data_presentation(product_data)

		return true
	end
end

ExpeditionLogicBase._refresh_safe_zone_unit_store_data_presentation = function (self, data)
	local expedition_currency_amount = self:expedition_currency()
	local unit = data.pickup_unit or data.spawner_unit

	if unit and Unit.alive(unit) then
		local info = data.info
		local purchase_price = info.price
		local original_description = data.original_description
		local original_extra_description = data.original_extra_description
		local can_afford = purchase_price <= expedition_currency_amount
		local unit_interactee_extension = ScriptUnit.has_extension(unit, "interactee_system")

		if unit_interactee_extension then
			local price_text_color = can_afford and Color.terminal_icon(255, true) or Color.ui_red_light(255, true)
			local price_text = Text.apply_color_to_text(purchase_price, price_text_color)

			unit_interactee_extension:set_description("loc_game_mode_expedition_pickup_price_desc", {
				description = Localize(original_description),
				price = price_text,
			})

			local num_charges = info.charges

			if num_charges and num_charges > 0 then
				local charges_text = Localize("loc_game_mode_expedition_pickup_charges_desc", true, {
					charges = num_charges,
				})

				charges_text = Text.apply_color_to_text(charges_text, Color.terminal_icon(255, true))

				if original_extra_description then
					charges_text = charges_text .. "\n\n" .. Localize(original_extra_description)
				end

				unit_interactee_extension:set_extra_description(nil, charges_text)
			elseif num_charges and num_charges == 0 then
				unit_interactee_extension:set_extra_description(nil)
			end
		end
	end
end

ExpeditionLogicBase.rpc_client_expedition_on_purchase_performed = function (self, channel_id, peer_id, is_level_unit, pickup_unit_id, charges_left, original_description, original_extra_description)
	local pickup_unit = Managers.state.unit_spawner:unit(pickup_unit_id, is_level_unit)
	local product_data = self:_get_safe_zone_product_data_by_purchase_unit(pickup_unit)
	local local_player_id = 1
	local player_manager = Managers.player
	local player = player_manager:player(peer_id, local_player_id)

	if player and player:is_human_controlled() then
		local current_section = self:_get_active_safe_zone_section()
		local players_purchases = current_section.players_purchases
		local name = product_data.name
		local character_id = player:character_id()

		if not players_purchases[character_id] then
			players_purchases[character_id] = {}
		end

		local current_player_purchases = players_purchases[character_id]
		local current_player_product_purchases = current_player_purchases[name] or 0

		current_player_purchases[name] = (current_player_product_purchases or 0) + 1

		local fx_extension = ScriptUnit.has_extension(player.player_unit, "fx_system")

		if fx_extension then
			fx_extension:trigger_wwise_event("wwise/events/player/play_expeditions_loot_buy", true)
		end
	end

	if charges_left > -1 then
		local pickup_info = product_data.info

		pickup_info.charges = charges_left
	end

	product_data.unit = nil

	if original_extra_description == "" then
		original_extra_description = nil
	end

	self:_reset_safe_zone_pickup_unit_presentation(pickup_unit, original_description, original_extra_description)
	Managers.event:trigger("expedition_player_purchase_performed", player)

	local local_player = Managers.player:local_player(local_player_id)

	if local_player == player and product_data.is_pickup then
		self:_client_purchase_flow_event()
	end
end

ExpeditionLogicBase._client_purchase_flow_event = function (self)
	local safe_zone_section = self:_get_active_safe_zone_section()
	local safe_zone_level = safe_zone_section.safe_zone_level

	Level.trigger_event(safe_zone_level, "client_purchase")
end

ExpeditionLogicBase._reset_safe_zone_pickup_unit_presentation = function (self, pickup_unit, original_description, original_extra_description)
	local unit_interactee_extension = ScriptUnit.has_extension(pickup_unit, "interactee_system")

	unit_interactee_extension:set_description(original_description)
	unit_interactee_extension:set_extra_description(original_extra_description)
end

ExpeditionLogicBase._get_safe_zone_product_data_by_purchase_unit = function (self, unit)
	local current_section = self:_get_active_safe_zone_section()

	if not current_section then
		return
	end

	local purchase_data_by_store_unit = current_section.purchase_data_by_store_unit

	if not purchase_data_by_store_unit then
		return
	end

	local unit_pickup_data = purchase_data_by_store_unit[unit]

	if unit_pickup_data then
		return unit_pickup_data
	end

	for _, pickup_data in pairs(purchase_data_by_store_unit) do
		if pickup_data.pickup_unit == unit then
			return pickup_data
		end
	end
end

ExpeditionLogicBase.is_store_product = function (self, unit)
	return self:_get_safe_zone_product_data_by_purchase_unit(unit) ~= nil
end

ExpeditionLogicBase.can_purchase_product = function (self, interactee_unit, interactor_unit)
	local player = Managers.state.player_unit_spawn:owner(interactor_unit)

	if player then
		local pickup_data = self:_get_safe_zone_product_data_by_purchase_unit(interactee_unit)

		if pickup_data then
			local pickup_name = pickup_data.pickup_name
			local pickup_store_data = self:get_unit_store_data(interactee_unit)
			local pickup_info = pickup_store_data.info
			local player_purchases_per_store = pickup_info.player_purchases_per_store

			if player_purchases_per_store then
				local expedition = self._expedition
				local current_section_index = self._current_section_index
				local current_section = expedition[current_section_index]
				local players_purchases = current_section.players_purchases
				local character_id = player:character_id()
				local current_player_purchases = players_purchases[character_id]
				local current_player_product_purchases = current_player_purchases and current_player_purchases[pickup_name] or 0

				if player_purchases_per_store <= current_player_product_purchases then
					return false, "loc_expeditions_store_purchase_limit_reached"
				end
			end

			local buff_name = pickup_data.buff_name

			if buff_name then
				local buff_extension = ScriptUnit.has_extension(interactor_unit, "buff_system")
				local has_buff = buff_extension and buff_extension:has_buff_using_buff_templates(buff_name)

				if has_buff then
					local current_stacks = buff_extension:current_stacks(buff_name)
					local buff_template = BuffTemplates[buff_name]
					local max_stacks = buff_template.max_stacks

					if max_stacks and max_stacks <= current_stacks then
						return false, "loc_game_mode_expedition_pickup_buff_maxed_out"
					end
				end
			end

			local peer_id = player:peer_id()
			local expedition_currency_amount = self:expedition_currency(peer_id)
			local purchase_price = self:get_unit_store_product_price(interactee_unit)
			local can_afford = purchase_price <= expedition_currency_amount

			if not can_afford then
				local blocked_text = "loc_game_mode_expedition_pickup_insufficient_funds"

				return false, blocked_text
			end

			return true
		end
	end

	return false
end

ExpeditionLogicBase.get_unit_store_product_price = function (self, unit)
	local pickup_data = self:_get_safe_zone_product_data_by_purchase_unit(unit)

	if pickup_data then
		local pickup_info = pickup_data.info
		local purchase_price = pickup_info.price

		return purchase_price
	end

	return nil
end

ExpeditionLogicBase.get_unit_store_data = function (self, unit)
	local pickup_data = self:_get_safe_zone_product_data_by_purchase_unit(unit)

	return pickup_data
end

ExpeditionLogicBase._set_pacing = function (self, enabled)
	self._pacing_enabled = enabled
end

ExpeditionLogicBase.pacing_enabled = function (self)
	return self._pacing_enabled
end

ExpeditionLogicBase.event_expedition_started = function (self)
	return
end

ExpeditionLogicBase.event_expedition_airlock_sealed = function (self)
	return
end

ExpeditionLogicBase.event_expedition_airlock_closed = function (self)
	return
end

ExpeditionLogicBase.event_expedition_resumed = function (self)
	return
end

ExpeditionLogicBase.event_level_start_extraction = function (self)
	local expedition = self._expedition
	local current_section_index = self._current_section_index
	local section = expedition[current_section_index]
	local extraction_level = section.extraction_level

	Level.trigger_event(extraction_level, "event_level_start_extraction")
end

ExpeditionLogicBase.event_expedition_teleport_players_to_store = function (self, level, teleporter_unit)
	return
end

ExpeditionLogicBase.event_expedition_teleport_players_from_store = function (self, level, exit_safe_zone_location_unit)
	return
end

ExpeditionLogicBase._game_world = function (self)
	local world_name = "level_world"
	local world = Managers.world:world(world_name)

	return world, self._nav_world
end

ExpeditionLogicBase.map_minigame = function (self)
	return self._navigation_handler:minigame()
end

ExpeditionLogicBase.mission_cleanup = function (self, on_shutdown)
	local levels_spawner = self._levels_spawner

	if levels_spawner then
		on_shutdown = true

		levels_spawner:despawn_levels_sync()
	end
end

ExpeditionLogicBase.destroy = function (self)
	local airstrike_levels = self._airstrike_levels

	for uuid, level in pairs(airstrike_levels) do
		self:_despawn_airstrike_level(level)
	end

	if self._levels_spawner then
		self._levels_spawner:destroy()

		self._levels_spawner = nil
	end

	self._loot_handler:destroy()

	self._loot_handler = nil

	self._minion_loot_handler:destroy()

	self._minion_loot_handler = nil

	self._currency_handler:destroy()

	self._currency_handler = nil

	self._collectibles_handler:destroy()

	self._collectibles_handler = nil

	self._navigation_handler:destroy()

	self._navigation_handler = nil

	self._objectives_handler:destroy()

	self._objectives_handler = nil

	if self._level_grid_handler then
		self._level_grid_handler:destroy()

		self._level_grid_handler = nil
	end

	self._current_section_index = nil

	local event_manager = Managers.event

	event_manager:unregister(self, "event_on_hud_created")
	event_manager:unregister(self, "event_expedition_started")
	event_manager:unregister(self, "event_expedition_airlock_sealed")
	event_manager:unregister(self, "event_expedition_airlock_closed")
	event_manager:unregister(self, "event_expedition_resumed")
	event_manager:unregister(self, "event_expedition_teleport_players_to_store")
	event_manager:unregister(self, "event_expedition_teleport_players_from_store")
	event_manager:unregister(self, "event_level_start_extraction")
	event_manager:unregister(self, "event_expedition_start_event")
	event_manager:unregister(self, "event_add_expedition_time_bonus")
	event_manager:unregister(self, "event_airstrike_done")
end

ExpeditionLogicBase._all_players_disabled = function (self, num_alive_players, alive_players, include_bots)
	for i = 1, num_alive_players do
		local player = alive_players[i]
		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

		if unit_data_extension then
			local is_human = player:is_human_controlled()
			local count_player = is_human or include_bots and not is_human
			local character_state_component = unit_data_extension:read_component("character_state")
			local is_disabled = HEALTH_ALIVE[player_unit] and PlayerUnitStatus.is_disabled_for_mission_failure(character_state_component)

			if count_player and not is_disabled and HEALTH_ALIVE[player_unit] then
				return false
			end
		end
	end

	return true
end

ExpeditionLogicBase._all_players_dead = function (self, num_alive_players, alive_players, include_bots)
	for i = 1, num_alive_players do
		local player = alive_players[i]
		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

		if unit_data_extension then
			local is_human = player:is_human_controlled()
			local count_player = is_human or include_bots and not is_human
			local character_state_component = unit_data_extension:read_component("character_state")
			local is_dead = not HEALTH_ALIVE[player_unit] or PlayerUnitStatus.is_dead_for_mission_failure(character_state_component)

			if count_player and not is_dead then
				return false
			end
		end
	end

	return true
end

ExpeditionLogicBase.on_player_unit_spawn = function (self, player, unit, is_respawn)
	return
end

ExpeditionLogicBase.on_player_unit_despawn = function (self, player)
	return
end

ExpeditionLogicBase.pre_populate_pickups_setup = function (self, pickup_spawners)
	if self._is_server then
		local template = self._expedition_template
		local current_location_data = self._expedition[self._current_section_index]

		return ExpeditionPickupDistribution.pre_populate_pickups_setup(template, current_location_data, pickup_spawners)
	end
end

ExpeditionLogicBase.event_add_expedition_time_bonus = function (self, bonus_time)
	if self._is_server then
		self._timer_handler:extend_max_time(bonus_time)
	end
end

ExpeditionLogicBase.get_additional_pickups = function (self)
	local template = self._expedition_template

	return ExpeditionPickupDistribution.get_additional_pickups(template, self._current_section_index)
end

ExpeditionLogicBase.get_navigation_handler = function (self)
	return self._navigation_handler
end

ExpeditionLogicBase.get_objectives_handler = function (self)
	return self._objectives_handler
end

ExpeditionLogicBase.get_collectibles_handler = function (self)
	return self._collectibles_handler
end

ExpeditionLogicBase.get_expedition_template = function (self)
	return self._expedition_template
end

ExpeditionLogicBase.register_level_hazard = function (self, params)
	if not self._level_hazards then
		self._level_hazards = {}
	end

	self._level_hazards[params.flow_level] = params.hazard_type
end

ExpeditionLogicBase.unregister_level_hazard = function (self, params)
	if not self._level_hazards then
		return
	end

	if self._level_hazards[params.flow_level] then
		self._level_hazards[params.flow_level] = nil
	end
end

ExpeditionLogicBase.get_active_level_hazards = function (self)
	return self._level_hazards
end

ExpeditionLogicBase.clean_up_current_level_hazards = function (self)
	self._level_hazards = nil
end

ExpeditionLogicBase._retain_last_environment = function (self, connector_exit_unit)
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

ExpeditionLogicBase.rpc_spawn_expedition_airstrike = function (self, channel, airstrikes_lookup_id, position, direction)
	local world = self:_game_world()
	local airstrike_type = NetworkLookup.expedition_airstrikes[airstrikes_lookup_id]
	local airstrike_settings = ExpeditionAirstrikes[airstrike_type]
	local level_path = airstrike_settings.level_path
	local scale = 1

	position = position or Vector3(0, 0, 0)

	local rotation = Quaternion.identity()

	if direction then
		rotation = Quaternion.look(direction, Vector3.up())
	end

	local level = World.spawn_level(world, level_path, position, rotation, scale)

	Level.set_data(level, "runtime_loaded_level", true)

	local level_units = Level.units(level, true)

	Level.trigger_unit_spawned(level)

	local category_name
	local extension_manager = Managers.state.extension

	extension_manager:add_and_register_units(world, level_units, nil, category_name)
	Level.trigger_event(level, "expedition_play_airstrike")

	local uuid = math.uuid()

	Level.set_data(level, "uuid", uuid)

	self._airstrike_levels[uuid] = level
end

ExpeditionLogicBase.event_airstrike_done = function (self, level)
	self._airstrike_levels_to_despawn[level] = true
end

ExpeditionLogicBase._despawn_airstrike_level = function (self, level)
	local level_uuid = Level.get_data(level, "uuid")
	local airstrike_levels = self._airstrike_levels

	airstrike_levels[level_uuid] = nil
	self._airstrike_levels_to_despawn[level] = nil

	Level.trigger_level_shutdown(level)

	local level_units = Level.units(level, true)
	local extension_manager = Managers.state.extension

	if extension_manager then
		extension_manager:unregister_units(level_units, #level_units)
	end

	local networked_flow_state_manager = Managers.state.networked_flow_state

	if networked_flow_state_manager then
		networked_flow_state_manager:unregister_level(level)
	end

	local network_story_manager = Managers.state.network_story

	if network_story_manager then
		network_story_manager:unregister_level(level)
	end

	local world = self:_game_world()
	local level_name = Level.name(level)

	level_name = level_name:match("(.+)%..+$")

	World.destroy_level(world, level)
end

ExpeditionLogicBase.rpc_register_expedition_danger_zone = function (self, channel, unit_id, is_level_unit, position, proximity_distance)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

	self._danger_zones[#self._danger_zones + 1] = {
		unit = unit,
		position = Vector3Box(position),
		proximity_distance = proximity_distance,
	}
end

ExpeditionLogicBase.rpc_unregister_expedition_danger_zone = function (self, channel, unit_id, is_level_unit)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local danger_zones = self._danger_zones

	for i = 1, #danger_zones do
		local danger_zone = danger_zones[i]

		if unit == danger_zone.unit then
			table.remove(self._danger_zones, i)

			break
		end
	end
end

ExpeditionLogicBase.is_player_in_danger_zone = function (self, player)
	local player_unit = player.player_unit
	local in_proximity = false
	local proximity_unit

	if not player_unit then
		return in_proximity, proximity_unit
	end

	local player_position = Unit.local_position(player_unit, 1)
	local danger_zones = self._danger_zones

	for i = 1, #danger_zones do
		local danger_zone = danger_zones[i]
		local unit = danger_zone.unit
		local proximity_distance = danger_zone.proximity_distance

		if Unit.alive(unit) then
			local position = danger_zone.position:unbox()

			if proximity_distance > Vector3.distance(position, player_position) then
				in_proximity = true
				proximity_unit = unit

				break
			end
		end
	end

	return in_proximity, proximity_unit
end

ExpeditionLogicBase.rpc_expedition_start_event = function (self, channel, event_name, event_seed, time_into_event)
	self:start_event(event_name, event_seed, time_into_event)
end

ExpeditionLogicBase.rpc_expedition_top_event = function (self, channel, event_id)
	self:stop_event(event_id)
end

ExpeditionLogicBase.rpc_expedition_start_location_events = function (self, channel)
	self:start_location_events()
end

ExpeditionLogicBase.rpc_expedition_stop_all_events = function (self, channel)
	self:stop_all_events()
end

ExpeditionLogicBase.start_event = function (self, event_name, event_seed, time_into_event, optional_server_context)
	local active_events = self._active_events
	local event_template = ExpeditionEventTemplates[event_name]

	if self._is_server then
		event_seed = event_seed or math.random_seed()
	end

	if self._is_server then
		time_into_event = time_into_event or 0

		Managers.state.game_session:send_rpc_clients("rpc_expedition_start_event", event_name, event_seed, time_into_event, time_into_event)
	end

	if not event_template.server_only or self._is_server then
		local world = self:_game_world()

		self._event_counter_id = self._event_counter_id + 1

		local id = self._event_counter_id
		local game_time = Managers.time:time("gameplay")
		local entry = {
			id = id,
			event_name = event_name,
			start_time = game_time,
			data = {
				seed = event_seed,
			},
			template = table.clone_instance(event_template),
			context = {
				world = world,
				is_server = self._is_server,
				physics_world = World.physics_world(world),
				wwise_world = Managers.world:wwise_world(world),
				nav_world = self._nav_world,
				level_grid_handler = self._level_grid_handler,
			},
		}

		if optional_server_context and self._is_server then
			table.merge_recursive(entry.context, optional_server_context)
		end

		active_events[#active_events + 1] = entry

		event_template.init(entry.data, entry.template, entry.context, time_into_event)

		return id, event_seed
	end
end

ExpeditionLogicBase.stop_event = function (self, event_id)
	if self._is_server then
		Managers.state.game_session:send_rpc_clients("rpc_expedition_top_event", event_id)
	end

	local active_events = self._active_events

	for i = #active_events, 1, -1 do
		local entry = active_events[i]
		local id = entry.id

		if id == event_id then
			local data = entry.data
			local template = entry.template
			local context = entry.context

			template.destroy(data, template, context)
			table.remove(active_events, i)

			break
		end
	end
end

ExpeditionLogicBase._hot_join_sync_location_events = function (self, channel)
	if not self._is_server then
		return
	end

	local peer_id = Network.peer_id(channel)
	local game_time = Managers.time:time("gameplay")
	local active_events = self._active_events

	for i = #active_events, 1, -1 do
		local entry = active_events[i]
		local event_template = entry.template
		local server_only = event_template.server_only

		if not server_only then
			local start_time = entry.start_time
			local time_into_event = game_time - start_time
			local event_name = entry.event_name
			local data = entry.data
			local event_seed = data.seed

			Managers.state.game_session:send_rpc_client("rpc_expedition_start_event", peer_id, event_name, event_seed, time_into_event)
		end
	end
end

ExpeditionLogicBase.start_location_events = function (self)
	if self._is_server then
		Managers.state.game_session:send_rpc_clients("rpc_expedition_start_location_events")
	end

	local current_section_index = self._current_section_index
	local expedition = self._expedition
	local current_section = expedition[current_section_index]
	local events = current_section.events

	if #events > 0 then
		for i = 1, #events do
			local event_name = events[i]

			self:start_event(event_name)
		end
	end
end

ExpeditionLogicBase.stop_all_events = function (self)
	if self._is_server then
		Managers.state.game_session:send_rpc_clients("rpc_expedition_stop_all_events")
	end

	local active_events = self._active_events

	for i = #active_events, 1, -1 do
		local entry = active_events[i]
		local data = entry.data
		local template = entry.template
		local context = entry.context

		template.destroy(data, template, context)
		table.remove(active_events, i)
	end
end

ExpeditionLogicBase._update_events = function (self, dt, t)
	local active_events = self._active_events

	for i = #active_events, 1, -1 do
		local entry = active_events[i]
		local data = entry.data
		local template = entry.template
		local context = entry.context

		template.update(data, template, context, dt, t)

		if template.done(data, template, context, dt, t) then
			template.destroy(data, template, context)
			table.remove(active_events, i)
		end
	end
end

ExpeditionLogicBase.zone_override_times = function (self)
	local template = self._expedition_template
	local override_times = {}
	local exit_settings = template.exit_event_settings

	override_times.objective_expedition_clear_exit = exit_settings and exit_settings.duration

	local extraction_settings = template.exit_event_settings

	override_times.objective_expedition_clear_extraction = extraction_settings and extraction_settings.duration

	return override_times
end

return ExpeditionLogicBase
