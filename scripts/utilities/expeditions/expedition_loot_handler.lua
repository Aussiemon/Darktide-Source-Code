-- chunkname: @scripts/utilities/expeditions/expedition_loot_handler.lua

local NavQueries = require("scripts/utilities/nav_queries")
local Text = require("scripts/utilities/ui/text")
local UISettings = require("scripts/settings/ui/ui_settings")
local Vo = require("scripts/utilities/vo")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")

local function _log(...)
	Log.info("ExpeditionLootHandler", ...)
end

local RESCUE_OBJECTIVE_NAME = "expedition_rescue_player"
local CLIENT_RPCS = {
	"rpc_client_expedition_loot_collected",
	"rpc_client_expedition_remove_loot_collected",
	"rpc_client_expedition_update_player_rescue_objective",
	"rpc_client_expedition_register_dropped_heavy_loot_unit",
}
local SERVER_RPCS = {}
local ExpeditionLootHandler = class("ExpeditionLootHandler")

ExpeditionLootHandler.init = function (self, expedition_template, is_server, network_event_delegate)
	self._expedition_template = expedition_template
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._telemetry_tracking_loot_by_player = {}
	self._peer_id_by_pickup_unit = {}
	self._dropped_loot_by_pickup_unit = {}
	self._dropped_reason_by_pickup_unit = {}
	self._loot_calculations_dirty = false
	self._dropped_heavy_loot_units = {}
	self._rescue_loot_amount_per_peer_id = {}
	self._team_loot_collected = {}
	self._total_team_loot_collected = 0
	self._highest_loot_held_this_run = 0

	local event_manager = Managers.event

	if self._is_server then
		network_event_delegate:register_session_events(self, unpack(SERVER_RPCS))
		event_manager:register(self, "event_hogtied_player_rescued", "event_hogtied_player_rescued")
		event_manager:register(self, "event_player_died", "event_player_died")
		event_manager:register(self, "event_expedition_loot_collected", "event_expedition_loot_collected")
		event_manager:register(self, "event_expedition_pocketable_collected", "event_expedition_pocketable_collected")
		event_manager:register(self, "event_expedition_convert_and_collect", "event_expedition_convert_and_collect")
		event_manager:register(self, "event_expedition_pocketable_dropped", "event_expedition_pocketable_dropped")
		event_manager:register(self, "event_expedition_player_loot_collected", "event_expedition_player_loot_collected")
		event_manager:register(self, "client_disconnected", "_event_client_disconnected")
	else
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

ExpeditionLootHandler.on_gameplay_init = function (self)
	if self._is_server then
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")
		local increment = 0
		local max_incremented = 1

		mission_objective_system:start_mission_objective("expedition_loot", nil, nil, nil, increment, max_incremented)
	end
end

ExpeditionLootHandler.event_player_died = function (self, player)
	if self._is_server and not self._in_safe_zone then
		self:server_drop_player_loot_on_death(player)
	end
end

ExpeditionLootHandler._event_client_disconnected = function (self, network_interface, peer_id, channel_id)
	self._telemetry_tracking_loot_by_player[peer_id] = nil
end

ExpeditionLootHandler.loot_type_settings = function (self, loot_type)
	local expedition_template = self._expedition_template

	if not expedition_template then
		return nil
	end

	local loot_settings = expedition_template.loot_settings

	if not loot_settings then
		return nil
	end

	local loot_settings_by_type = loot_settings.settings_by_type

	if not loot_settings_by_type then
		return nil
	end

	return loot_settings_by_type[loot_type]
end

ExpeditionLootHandler.player_death_penalty_values = function (self)
	local expedition_template = self._expedition_template
	local loot_deduction_settings = expedition_template and expedition_template.loot_deduction_settings
	local player_death_penalty_multiplier = loot_deduction_settings and loot_deduction_settings.player_death_penalty_multiplier or 0.25
	local player_death_penalty_drop_amount_multiplier = loot_deduction_settings and loot_deduction_settings.player_death_penalty_drop_amount_multiplier or 0.25
	local player_penalty_increment = loot_deduction_settings and loot_deduction_settings.player_penalty_increment or 5
	local team_loot_player_death_penalty_threshold = loot_deduction_settings and loot_deduction_settings.team_loot_player_death_penalty_threshold or 100
	local player_hogtied_safe_zone_relocation_penalty_multiplier = loot_deduction_settings and loot_deduction_settings.player_hogtied_safe_zone_relocation_penalty_multiplier or 1

	return player_death_penalty_multiplier, player_death_penalty_drop_amount_multiplier, player_penalty_increment, team_loot_player_death_penalty_threshold, player_hogtied_safe_zone_relocation_penalty_multiplier
end

ExpeditionLootHandler.event_expedition_convert_and_collect = function (self, interactor_unit, loot_type, tier)
	local type_settings = self:loot_type_settings(loot_type)
	local amount = type_settings.values_per_tier[tier]

	Managers.event:trigger("event_expedition_loot_collected", interactor_unit, "small", nil, amount)

	if self._is_server then
		Vo.set_npc_faction_memory("data_reliquary_carried", 0)
	end
end

ExpeditionLootHandler.event_expedition_pocketable_collected = function (self, interactor_unit, pickup_unit, loot_type, tier, show_notification)
	local player = Managers.state.player_unit_spawn:owner(interactor_unit)
	local peer_id = player and player:peer_id()
	local type_settings = self:loot_type_settings(loot_type)
	local amount = type_settings.values_per_tier[tier]

	if loot_type == "heavy" then
		local dropped_heavy_loot_units = self._dropped_heavy_loot_units

		for i = 1, #dropped_heavy_loot_units do
			local unit = dropped_heavy_loot_units[i]

			if unit == pickup_unit then
				table.remove(dropped_heavy_loot_units, i)

				break
			end
		end
	end

	if self._is_server then
		Managers.state.game_session:send_rpc_clients("rpc_client_expedition_loot_collected", peer_id, amount, loot_type, show_notification)

		if show_notification then
			self:_show_collected_materials_notification(peer_id, amount, loot_type)
		end

		self:_add_player_loot_by_type(peer_id, amount, loot_type)
		Vo.set_npc_faction_memory("data_reliquary_carried", 1)
	end
end

ExpeditionLootHandler.event_expedition_pocketable_dropped = function (self, interactor_unit, pickup_unit, loot_type, tier, show_notification)
	local player = Managers.state.player_unit_spawn:owner(interactor_unit)
	local peer_id = player and player:peer_id()
	local type_settings = self:loot_type_settings(loot_type)
	local amount = -type_settings.values_per_tier[tier]

	if loot_type == "heavy" and pickup_unit then
		self:_register_dropped_heavy_loot_unit(pickup_unit)

		local pickup_is_level_unit, pickup_unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(pickup_unit)

		Managers.state.game_session:send_rpc_clients("rpc_client_expedition_register_dropped_heavy_loot_unit", pickup_unit_id, pickup_is_level_unit)
	end

	Managers.state.game_session:send_rpc_clients("rpc_client_expedition_loot_collected", peer_id, amount, loot_type, show_notification)

	if show_notification then
		self:_show_collected_materials_notification(peer_id, amount, loot_type)
	end

	self:_add_player_loot_by_type(peer_id, amount, loot_type)
	Vo.set_npc_faction_memory("data_reliquary_carried", 0)
end

ExpeditionLootHandler.rpc_client_expedition_register_dropped_heavy_loot_unit = function (self, channel_id, pickup_unit_id, is_level_unit)
	local pickup_unit = Managers.state.unit_spawner:unit(pickup_unit_id, is_level_unit)

	self:_register_dropped_heavy_loot_unit(pickup_unit)
end

ExpeditionLootHandler._register_dropped_heavy_loot_unit = function (self, unit)
	local unit_found = false
	local dropped_heavy_loot_units = self._dropped_heavy_loot_units

	for i = 1, #dropped_heavy_loot_units do
		local heavy_loot_unit = dropped_heavy_loot_units[i]

		if heavy_loot_unit == unit then
			unit_found = true

			break
		end
	end

	if not unit_found then
		self._dropped_heavy_loot_units[#self._dropped_heavy_loot_units + 1] = unit
	end
end

ExpeditionLootHandler.dropped_loot_by_pickup_units = function (self)
	return self._dropped_loot_by_pickup_unit
end

ExpeditionLootHandler.dropped_heavy_loot_units = function (self)
	return self._dropped_heavy_loot_units
end

ExpeditionLootHandler.event_expedition_player_loot_collected = function (self, interactor_unit, pickup_unit)
	if self._is_server then
		local dropped_loot_by_pickup_unit = self._dropped_loot_by_pickup_unit
		local amount = dropped_loot_by_pickup_unit[pickup_unit] or 0
		local reason = self._dropped_reason_by_pickup_unit[pickup_unit]

		self._dropped_loot_by_pickup_unit[pickup_unit] = nil
		self._dropped_reason_by_pickup_unit[pickup_unit] = nil

		Managers.event:trigger("event_expedition_loot_collected", interactor_unit, "small", nil, amount)

		local player = Managers.state.player_unit_spawn:owner(interactor_unit)

		if player then
			Managers.stats:record_private("hook_expedition_loot_recovered", player, reason, amount)
		end
	end
end

ExpeditionLootHandler.event_expedition_loot_collected = function (self, interactor_unit, loot_type, tier, optional_amount)
	local player = Managers.state.player_unit_spawn:owner(interactor_unit)
	local peer_id = player and player:peer_id()
	local amount

	if optional_amount then
		amount = optional_amount
	else
		local type_settings = self:loot_type_settings(loot_type)

		amount = type_settings.values_per_tier[tier]
	end

	if self._is_server then
		Managers.state.game_session:send_rpc_clients("rpc_client_expedition_loot_collected", peer_id, amount, loot_type, true)
		self:_show_collected_materials_notification(peer_id, amount, loot_type)
		self:_add_player_loot_by_type(peer_id, amount, loot_type, tier)
	end
end

ExpeditionLootHandler._add_player_loot_by_type = function (self, peer_id, amount, loot_type)
	if not self._team_loot_collected[loot_type] then
		self._team_loot_collected[loot_type] = 0
	end

	self._team_loot_collected[loot_type] = self._team_loot_collected[loot_type] + amount
	self._total_team_loot_collected = self._total_team_loot_collected + amount

	if self._total_team_loot_collected > self._highest_loot_held_this_run then
		self._highest_loot_held_this_run = self._total_team_loot_collected
	end

	local telemetry_tracking_loot_by_player = self._telemetry_tracking_loot_by_player

	if not telemetry_tracking_loot_by_player[peer_id] then
		telemetry_tracking_loot_by_player[peer_id] = {}
	end

	if not telemetry_tracking_loot_by_player[peer_id][loot_type] then
		telemetry_tracking_loot_by_player[peer_id][loot_type] = 0
	end

	telemetry_tracking_loot_by_player[peer_id][loot_type] = telemetry_tracking_loot_by_player[peer_id][loot_type] + amount
	self._loot_calculations_dirty = true
end

ExpeditionLootHandler.rpc_client_expedition_remove_loot_collected = function (self, channel_id, peer_id, loot_type, amount_to_deduct)
	self:_add_player_loot_by_type(peer_id, -amount_to_deduct, loot_type)

	self._loot_calculations_dirty = true
end

ExpeditionLootHandler.hot_join_sync = function (self, channel_id)
	local expedition_loot_show_notification = false
	local telemetry_tracking_loot_by_player = self._telemetry_tracking_loot_by_player

	for looter_peer_id, loot_by_type in pairs(telemetry_tracking_loot_by_player) do
		for loot_type, amount in pairs(loot_by_type) do
			RPC.rpc_client_expedition_loot_collected(channel_id, looter_peer_id, amount, loot_type, expedition_loot_show_notification)
		end
	end

	local total_team_rescue_amount = self:_total_rescue_loot_amount()

	if total_team_rescue_amount > 0 then
		RPC.rpc_client_expedition_update_player_rescue_objective(channel_id, total_team_rescue_amount)
	end
end

ExpeditionLootHandler.on_client_left = function (self, removed_players_data)
	local peer_id = removed_players_data.peer_id

	if self.is_server then
		self._rescue_loot_amount_per_peer_id[peer_id] = nil

		local total_team_rescue_amount = self:_total_rescue_loot_amount()

		Managers.state.game_session:send_rpc_clients("rpc_client_expedition_update_player_rescue_objective", total_team_rescue_amount)
	end
end

ExpeditionLootHandler.rpc_client_expedition_loot_collected = function (self, channel_id, peer_id, amount, loot_type, expedition_loot_show_notification)
	self:_add_player_loot_by_type(peer_id, amount, loot_type)

	if expedition_loot_show_notification then
		self:_show_collected_materials_notification(peer_id, amount, loot_type)
	end
end

ExpeditionLootHandler._show_collected_materials_notification = function (self, peer_id, amount, loot_type)
	local player_manager = Managers.player
	local local_player_id = 1
	local player = player_manager:player(peer_id, local_player_id)
	local player_name = player and player:name()

	if amount < 0 then
		Managers.event:trigger("event_add_notification_message", "player_loot_drop", {
			currency = "expedition_loot",
			amount = math.abs(amount),
			player_name = player_name,
			player = player,
		})
	else
		local player_slot = player and player.slot and player:slot()
		local player_slot_colors = UISettings.player_slot_colors
		local player_slot_color = player_slot and player_slot_colors[player_slot]

		if player_name and player_slot_color then
			player_name = Text.apply_color_to_text(player_name, player_slot_color)
		end

		local optional_localization_key = "loc_tactical_overlay_crafting_mat_notification"

		Managers.event:trigger("event_add_notification_message", "currency", {
			currency = "expedition_loot",
			amount = amount,
			player_name = player_name,
			optional_localization_key = optional_localization_key,
		})
	end
end

ExpeditionLootHandler.collected_team_loot_by_type = function (self, loot_type)
	return self._team_loot_collected[loot_type] or 0
end

ExpeditionLootHandler.collected_team_loot = function (self)
	return self._total_team_loot_collected
end

ExpeditionLootHandler.highest_loot_held_this_run = function (self)
	return self._highest_loot_held_this_run
end

ExpeditionLootHandler.add_external_player_pickup_unit = function (self, pickup_unit, amount, reason)
	self._dropped_loot_by_pickup_unit[pickup_unit] = amount
	self._dropped_reason_by_pickup_unit[pickup_unit] = reason

	Managers.state.extension:system("pickup_system"):dropped(pickup_unit)
end

ExpeditionLootHandler.collected_player_loot_by_type_telemetry_only = function (self, peer_id, type)
	local telemetry_tracking_loot_by_player = self._telemetry_tracking_loot_by_player
	local player_loot = telemetry_tracking_loot_by_player[peer_id]
	local total_amount = player_loot and player_loot[type] or 0

	return total_amount
end

ExpeditionLootHandler.collected_player_loot_telemetry_only = function (self, peer_id)
	local telemetry_tracking_loot_by_player = self._telemetry_tracking_loot_by_player
	local player_loot = telemetry_tracking_loot_by_player[peer_id]
	local total_amount = 0

	if player_loot then
		for _, amount in pairs(player_loot) do
			total_amount = total_amount + amount
		end
	end

	return total_amount
end

ExpeditionLootHandler.server_deduct_loot = function (self, amount, peer_id)
	local loot_type = "small"
	local team_loot_collected = self._team_loot_collected
	local team_small_loot_amount = team_loot_collected[loot_type]

	if team_small_loot_amount and amount <= team_small_loot_amount then
		team_loot_collected[loot_type] = team_loot_collected[loot_type] - amount
		self._total_team_loot_collected = self._total_team_loot_collected - amount
		self._loot_calculations_dirty = true

		Managers.state.game_session:send_rpc_clients("rpc_client_expedition_remove_loot_collected", peer_id, loot_type, amount)

		local telemetry_tracking_loot_by_player = self._telemetry_tracking_loot_by_player
		local player_loot_by_type = telemetry_tracking_loot_by_player[peer_id]
		local player_small_loot_amount = player_loot_by_type and player_loot_by_type[loot_type]

		if player_small_loot_amount then
			player_loot_by_type[loot_type] = player_loot_by_type[loot_type] - amount
		end

		return true
	end

	return false
end

ExpeditionLootHandler.event_hogtied_player_rescued = function (self, target_unit, interactor_unit)
	local player_manager = Managers.player
	local rescued_player = player_manager:player_by_unit(target_unit)

	if not rescued_player:is_human_controlled() then
		return
	end

	local rescued_player_peer_id = rescued_player:peer_id()
	local reward_amount = self._rescue_loot_amount_per_peer_id[rescued_player_peer_id]

	if reward_amount then
		local rescuer_player = player_manager:player_by_unit(interactor_unit)
		local rescuer_peer_id = rescuer_player:peer_id()
		local loot_type = "small"

		self:_add_player_loot_by_type(rescuer_peer_id, reward_amount, loot_type)

		self._rescue_loot_amount_per_peer_id[rescued_player_peer_id] = nil

		local total_team_rescue_amount = self:_total_rescue_loot_amount()

		self:_update_player_rescue_objective(total_team_rescue_amount)
		Managers.state.game_session:send_rpc_clients("rpc_client_expedition_loot_collected", rescuer_peer_id, reward_amount, loot_type, true)
		Managers.state.game_session:send_rpc_clients("rpc_client_expedition_update_player_rescue_objective", total_team_rescue_amount)
	end
end

ExpeditionLootHandler.rpc_client_expedition_update_player_rescue_objective = function (self, channel_id, total_team_rescue_amount)
	self:_update_player_rescue_objective(total_team_rescue_amount)
end

ExpeditionLootHandler._update_player_rescue_objective = function (self, total_team_rescue_amount)
	local mission_objective_system = Managers.state.extension:system("mission_objective_system")
	local objective = mission_objective_system:active_objective(RESCUE_OBJECTIVE_NAME)

	if total_team_rescue_amount > 0 then
		if not objective then
			mission_objective_system:start_mission_objective(RESCUE_OBJECTIVE_NAME)
		end

		Managers.event:trigger("event_expedition_rescue_objective_update", total_team_rescue_amount)
	elseif objective then
		local name = objective:name()
		local group_id = objective:group_id()

		mission_objective_system:end_mission_objective(name, group_id)
	end
end

ExpeditionLootHandler.update = function (self, dt, t)
	local dropped_heavy_loot_units = self._dropped_heavy_loot_units

	for i = #dropped_heavy_loot_units, 1, -1 do
		local unit = dropped_heavy_loot_units[i]

		if not Unit.alive(unit) then
			table.remove(dropped_heavy_loot_units, i)
		end
	end

	if self._is_server then
		self:_server_update_loot_amounts(dt, t)
	end

	if self._loot_calculations_dirty then
		self:_update_loot_calculations(dt, t)
	end
end

ExpeditionLootHandler._update_loot_calculations = function (self, dt, t)
	local total_amount = 0
	local telemetry_tracking_loot_by_player = self._telemetry_tracking_loot_by_player

	for peer_id, player_loot in pairs(telemetry_tracking_loot_by_player) do
		for loot_type, loot in pairs(player_loot) do
			total_amount = total_amount + loot
		end
	end

	self._loot_calculations_dirty = false

	if self._is_server then
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")
		local loot_objective = mission_objective_system:active_objective("expedition_loot")

		if loot_objective then
			loot_objective:set_increment(0)
			mission_objective_system:external_update_mission_objective("expedition_loot", nil, dt, self._total_team_loot_collected)
		end
	end
end

ExpeditionLootHandler._server_update_loot_amounts = function (self, dt, t)
	return
end

ExpeditionLootHandler.server_drop_player_loot_on_death = function (self, player)
	if not player:is_human_controlled() then
		return
	end

	local player_unit = player.player_unit

	if player_unit then
		local drop_position = Unit.world_position(player_unit, 1)
		local navigation_extension = ScriptUnit.has_extension(player_unit, "navigation_system")

		if navigation_extension then
			local nav_position = navigation_extension:latest_position_on_nav_mesh()

			if nav_position then
				local nav_world, traverse_logic = navigation_extension:nav_world(), navigation_extension:traverse_logic()
				local offset = -Quaternion.forward(Unit.local_rotation(player_unit, 1)) * 0.25

				drop_position = NavQueries.position_on_mesh_guaranteed(nav_world, nav_position + offset, 0.5, 0.5, traverse_logic) or nav_position
			end
		end

		local peer_id = player:peer_id()
		local loot_type = "small"
		local team_loot_of_type = self._team_loot_collected[loot_type] or 0

		if team_loot_of_type > 0 then
			local player_death_penalty_multiplier, player_death_penalty_drop_amount_multiplier, player_penalty_increment, team_loot_player_death_penalty_threshold = self:player_death_penalty_values()

			if team_loot_of_type < team_loot_player_death_penalty_threshold then
				return
			end

			local penalty_amount = math.round_down_with_precision(team_loot_of_type * player_death_penalty_multiplier)
			local amount_to_deduct = math.round_to_closest_multiple_toward_zero(penalty_amount, player_penalty_increment)

			if amount_to_deduct > 0 then
				self:_add_player_loot_by_type(peer_id, -amount_to_deduct, loot_type)
				Managers.state.game_session:send_rpc_clients("rpc_client_expedition_loot_collected", peer_id, -amount_to_deduct, loot_type, true)

				local amount_to_drop = math.round_down_with_precision(amount_to_deduct * player_death_penalty_drop_amount_multiplier)
				local amount_to_drop_by_increment = math.round_to_closest_multiple_toward_zero(amount_to_drop, player_penalty_increment)

				if amount_to_drop_by_increment > 0 then
					local pickup_name = "expedition_loot_player_drop"
					local extension_manager = Managers.state.extension
					local pickup_system = extension_manager:system("pickup_system")
					local pickup_unit, _ = pickup_system:spawn_pickup(pickup_name, drop_position, Quaternion.identity(), nil, nil, nil, nil)

					self._dropped_loot_by_pickup_unit[pickup_unit] = amount_to_drop_by_increment
					self._dropped_reason_by_pickup_unit[pickup_unit] = "death"

					pickup_system:dropped(pickup_unit)

					local remaining_amount_of_lost_share = amount_to_deduct - amount_to_drop_by_increment

					self._rescue_loot_amount_per_peer_id[peer_id] = remaining_amount_of_lost_share

					local total_team_rescue_amount = self:_total_rescue_loot_amount()

					self:_update_player_rescue_objective(total_team_rescue_amount)
					Managers.state.game_session:send_rpc_clients("rpc_client_expedition_update_player_rescue_objective", total_team_rescue_amount)
				end
			end
		end
	end

	self._loot_calculations_dirty = true
end

ExpeditionLootHandler.server_clear_rescue = function (self)
	local _, _, player_penalty_increment, _, player_hogtied_safe_zone_relocation_penalty_multiplier = self:player_death_penalty_values()
	local rescue_loot_amount_per_peer_id = self._rescue_loot_amount_per_peer_id
	local player_manager = Managers.player
	local players = player_manager:players()

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if player_unit and player:is_human_controlled() then
			local peer_id = player:peer_id()
			local rescue_loot_amount = rescue_loot_amount_per_peer_id[peer_id]

			if rescue_loot_amount then
				local amount_to_deduct = math.round_down_with_precision(rescue_loot_amount * player_hogtied_safe_zone_relocation_penalty_multiplier)
				local amount_to_deduct_by_increment = math.round_to_closest_multiple_toward_zero(amount_to_deduct, player_penalty_increment)

				rescue_loot_amount_per_peer_id[peer_id] = rescue_loot_amount - amount_to_deduct_by_increment
			end
		end
	end

	local total_team_rescue_amount = self:_total_rescue_loot_amount()

	self:_update_player_rescue_objective(total_team_rescue_amount)
	Managers.state.game_session:send_rpc_clients("rpc_client_expedition_update_player_rescue_objective", total_team_rescue_amount)
end

ExpeditionLootHandler._total_rescue_loot_amount = function (self)
	local rescue_loot_amount_per_peer_id = self._rescue_loot_amount_per_peer_id
	local total_amount = 0

	for peer_id, amount in pairs(rescue_loot_amount_per_peer_id) do
		total_amount = total_amount + amount
	end

	return total_amount
end

ExpeditionLootHandler.server_update_dropped_loot_pickups = function (self)
	local dropped_loot_by_pickup_unit = self._dropped_loot_by_pickup_unit
	local dropped_reason_by_pickup_unit = self._dropped_reason_by_pickup_unit

	for unit, _ in pairs(dropped_loot_by_pickup_unit) do
		if not ALIVE[unit] then
			dropped_loot_by_pickup_unit[unit] = nil
			dropped_reason_by_pickup_unit[unit] = nil
		end
	end
end

ExpeditionLootHandler.destroy = function (self)
	local event_manager = Managers.event

	if self._is_server then
		event_manager:unregister(self, "event_player_died")
		event_manager:unregister(self, "event_expedition_loot_collected")
		event_manager:unregister(self, "event_expedition_pocketable_collected")
		event_manager:unregister(self, "event_expedition_convert_and_collect")
		event_manager:unregister(self, "event_expedition_pocketable_dropped")
		event_manager:unregister(self, "event_expedition_player_loot_collected")
		event_manager:unregister(self, "client_disconnected")
		self._network_event_delegate:unregister_events(unpack(SERVER_RPCS))
	else
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

return ExpeditionLootHandler
