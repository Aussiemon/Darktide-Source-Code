-- chunkname: @scripts/extension_systems/mission_objective_zone/mission_objective_zone_scan_extension.lua

local MasterItems = require("scripts/backend/master_items")
local MissionObjectiveScanning = require("scripts/settings/mission_objective/mission_objective_scanning")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Vo = require("scripts/utilities/vo")
local MissionObjectiveZoneScanExtension = class("MissionObjectiveZoneScanExtension", "MissionObjectiveZoneBaseExtension")
local SCANNING_VO_LINES = MissionObjectiveScanning.vo_trigger_ids
local SERVO_SKULL_MARKER_TYPES = MissionObjectiveScanning.servo_skull_marker_types
local RETURN_TO_SERVO_SKULL_HEADER = "loc_objective_zone_scanning_return_to_servoskull_header"
local RETURN_TO_SERVO_SKULL_DESC = "loc_objective_zone_scanning_return_to_servoskull_desc"

MissionObjectiveZoneScanExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	MissionObjectiveZoneScanExtension.super.init(self, extension_init_context, unit, extension_init_data, ...)

	local is_server = extension_init_context.is_server

	self._is_server = is_server
	self._num_scanned_objects_per_player = {}
	self._registered_players = 0
	self._num_scannables_in_zone = 0
	self._check_player_condition_timer = 0
	self._check_player_condition_interval = 0.2
	self._finish_zone_timer = 1
	self._start_finish_zone_timer = false
	self._current_progression = 0
	self._scannable_units = {}
	self._selected_scannable_units = {}
	self._max_scannable_objects_per_player = 0
	self._start_vo_line_timer = false
	self._vo_line_interval = MissionObjectiveScanning.zone_settings.vo_trigger_time
	self._vo_line_timer = self._vo_line_interval

	local mission_objective_system = Managers.state.extension:system("mission_objective_system")

	self._mission_objective_system = mission_objective_system
	self._objective_group_id = mission_objective_system:get_objective_group_id_from_unit(unit)

	if is_server then
		self._players_with_scanned_objects = {}

		local event_manager = Managers.event

		event_manager:register(self, "player_unit_despawned", "_on_player_unit_despawned")
	end
end

MissionObjectiveZoneScanExtension.extensions_ready = function (self, world, unit)
	self._mission_objective_target_extension = ScriptUnit.has_extension(unit, "mission_objective_target_system")
end

MissionObjectiveZoneScanExtension.destroy = function (self)
	if self._is_server then
		local event_manager = Managers.event

		event_manager:unregister(self, "player_unit_despawned")
	end
end

MissionObjectiveZoneScanExtension.setup_from_component = function (self, num_scannable_objects, max_scannable_objects_per_player, zone_type, item_to_equip)
	self._num_scannables_in_zone = num_scannable_objects
	self._max_scannable_objects_per_player = max_scannable_objects_per_player
	self._zone_type = zone_type
	self._item_to_equip = item_to_equip
end

MissionObjectiveZoneScanExtension.hot_join_sync = function (self, unit, sender, channel)
	local level_unit_id = Managers.state.unit_spawner:level_index(self._unit)
	local scannable_units = self._scannable_units

	for i = 1, #scannable_units do
		local scannable_unit = scannable_units[i]
		local level_scannable_id = Managers.state.unit_spawner:level_index(scannable_unit)

		RPC.rpc_mission_objective_zone_register_scannable_unit(channel, level_unit_id, level_scannable_id)
	end

	if self._is_waiting_for_player_confirmation then
		Managers.state.game_session:send_rpc_clients("rpc_mission_objective_zone_set_waiting_for_confirmation", level_unit_id)
	end
end

MissionObjectiveZoneScanExtension.update = function (self, unit, dt, t)
	if self._activated and self._is_server then
		if self._registered_players > 0 then
			local check_player_condition_timer = self._check_player_condition_timer

			if check_player_condition_timer > 0 then
				check_player_condition_timer = math.max(check_player_condition_timer - dt, 0)
			else
				self:_check_if_players_knocked_down_or_killed()

				check_player_condition_timer = self._check_player_condition_interval
			end

			self._check_player_condition_timer = check_player_condition_timer
		end

		if self._start_finish_zone_timer then
			local finish_zone_timer = self._finish_zone_timer

			if finish_zone_timer > 0 then
				finish_zone_timer = math.max(finish_zone_timer - dt, 0)
			else
				self._start_finish_zone_timer = false

				self:set_is_waiting_for_player_confirmation()
				self:_set_skull_to_wait_for_players()
				self:_unequip_auspex_from_players()
				self:_play_vo(nil, SCANNING_VO_LINES.all_targets_scanned, true)
			end

			self._finish_zone_timer = finish_zone_timer
		end

		if self._start_vo_line_timer then
			self:_vo_timer(dt)
		end

		if not self._is_waiting_for_player_confirmation then
			self:_equip_auspex_to_players()
		end
	end
end

MissionObjectiveZoneScanExtension._set_skull_to_wait_for_players = function (self)
	local is_server = self._is_server
	local servo_skull_target_states = self._mission_objective_zone_system.SERVO_SKULL_TARGET_STATES
	local servo_skull_target_state = servo_skull_target_states.enabled

	self:_set_servo_skull_target(servo_skull_target_state, SERVO_SKULL_MARKER_TYPES.objective, is_server)
end

MissionObjectiveZoneScanExtension._check_if_players_knocked_down_or_killed = function (self)
	local players_with_scanned_objects = self._players_with_scanned_objects

	for player, scannable_extensions in pairs(players_with_scanned_objects) do
		local is_player_alive = player:unit_is_alive()

		if not is_player_alive then
			local killed = true

			self:release_scanned_object_from_player(player, killed)
		else
			local player_unit = player.player_unit
			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
			local character_state_component = unit_data_extension:read_component("character_state")
			local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_component)

			if is_knocked_down then
				self:release_scanned_object_from_player(player, is_knocked_down)
			end
		end
	end
end

local function _set_objectie_name_on_unit(unit, objective_name)
	local mission_objective_target_extension = ScriptUnit.extension(unit, "mission_objective_target_system")

	if mission_objective_target_extension:objective_name() == "default" then
		mission_objective_target_extension:set_objective_name(objective_name)

		return true
	end

	return false
end

MissionObjectiveZoneScanExtension._select_scannable_units_for_event = function (self)
	local mission_objective_target_extension = self._mission_objective_target_extension
	local objective_name = mission_objective_target_extension:objective_name()
	local scannable_units = self._scannable_units
	local selected_units = {}
	local num_scannables_in_zone = self._num_scannables_in_zone
	local random_table, _ = table.generate_random_table(1, #scannable_units, self._seed)
	local i = 1
	local spawned = 0

	while spawned < num_scannables_in_zone do
		local index = random_table[i]
		local selected_unit = scannable_units[index]

		if _set_objectie_name_on_unit(selected_unit, objective_name) then
			selected_units[#selected_units + 1] = selected_unit
			spawned = spawned + 1
		end

		i = i + 1
	end

	return selected_units
end

MissionObjectiveZoneScanExtension._last_scanned_object = function (self)
	local total_scanned = 0

	for _, points in pairs(self._num_scanned_objects_per_player) do
		total_scanned = total_scanned + points
	end

	total_scanned = total_scanned + self._current_progression

	return total_scanned == self._num_scannables_in_zone
end

MissionObjectiveZoneScanExtension._set_servo_skull_target = function (self, server_skull_target_state, marker_type, is_server)
	self._mission_objective_zone_system:set_servo_skull_target_state(server_skull_target_state, marker_type, is_server)
end

MissionObjectiveZoneScanExtension.register_scannable_unit = function (self, scannable_unit)
	local scannable_units = self._scannable_units

	scannable_units[#scannable_units + 1] = scannable_unit
	self._scannable_units = scannable_units

	if self._is_server then
		local level_object_id = Managers.state.unit_spawner:level_index(self._unit)
		local level_scannable_id = Managers.state.unit_spawner:level_index(scannable_unit)

		Managers.state.game_session:send_rpc_clients("rpc_mission_objective_zone_register_scannable_unit", level_object_id, level_scannable_id)
	end
end

MissionObjectiveZoneScanExtension.assign_scanned_object_to_player_and_bank = function (self, scannable_extension, player)
	local player_incapacitated = false

	self:assign_scanned_object_to_player(scannable_extension, player)
	self:release_scanned_object_from_player(player, player_incapacitated)
end

MissionObjectiveZoneScanExtension.assign_scanned_object_to_player = function (self, scannable_extension, player)
	local players_with_scanned_objects = self._players_with_scanned_objects
	local unit_list = players_with_scanned_objects[player]

	if not unit_list then
		unit_list = {}
		self._registered_players = self._registered_players + 1
	end

	unit_list[#unit_list + 1] = scannable_extension
	self._players_with_scanned_objects[player] = unit_list

	scannable_extension:set_active(false)

	local scanned_object_points = 1

	if self._is_server then
		local level_object_id = Managers.state.unit_spawner:level_index(self._unit)
		local peer_id = player:peer_id()
		local local_player_id = player:local_player_id()

		Managers.state.game_session:send_rpc_clients("rpc_mission_objective_zone_scan_add_player_scanned_object", level_object_id, peer_id, local_player_id, scanned_object_points)
	end

	self:add_scanned_points_to_player(player, scanned_object_points)
end

MissionObjectiveZoneScanExtension.release_scanned_object_from_player = function (self, player, player_incapacitated)
	local scannable_extensions = self._players_with_scanned_objects[player]

	if scannable_extensions and #scannable_extensions > 0 then
		local scannable_count = #scannable_extensions

		for i = 1, scannable_count do
			if player_incapacitated then
				local scannable_extension = scannable_extensions[i]

				scannable_extension:set_active(true)
			else
				self._current_progression = self._current_progression + 1

				if self._current_progression == self._num_scannables_in_zone then
					self._start_finish_zone_timer = true
				end
			end
		end

		self._players_with_scanned_objects[player] = nil
		self._registered_players = self._registered_players - 1

		local scanned_object_points = 0

		if self._is_server then
			if not player_incapacitated then
				Managers.telemetry_events:player_scanned_objects(player, scannable_count)
				Managers.stats:record_private("hook_scan", player, scannable_count)
			end

			local level_object_id = Managers.state.unit_spawner:level_index(self._unit)
			local peer_id = player:peer_id()
			local local_player_id = player:local_player_id()

			Managers.state.game_session:send_rpc_clients("rpc_mission_objective_zone_scan_add_player_scanned_object", level_object_id, peer_id, local_player_id, scanned_object_points)
		end

		self:add_scanned_points_to_player(player, scanned_object_points)
	end
end

MissionObjectiveZoneScanExtension.player_scanned_objects = function (self, player)
	local scanned_objects = self._num_scanned_objects_per_player[player] or 0

	return scanned_objects
end

MissionObjectiveZoneScanExtension.num_scanned_objects_per_player = function (self)
	return self._num_scanned_objects_per_player
end

MissionObjectiveZoneScanExtension.max_scannable_objects_per_player = function (self)
	return self._max_scannable_objects_per_player
end

MissionObjectiveZoneScanExtension.add_scanned_points_to_player = function (self, player, scanned_points)
	local new_scan_points

	if scanned_points > 0 then
		local current_scanned_points = self._num_scanned_objects_per_player[player]

		new_scan_points = current_scanned_points and current_scanned_points + scanned_points or scanned_points
	end

	self._num_scanned_objects_per_player[player] = new_scan_points

	local is_mission_giver_line = false

	self:_play_vo(player, SCANNING_VO_LINES.scan_performed, is_mission_giver_line)

	if self._is_server then
		if self:_last_scanned_object() then
			self._start_vo_line_timer = true
		else
			self._start_vo_line_timer = false
			self._vo_line_timer = self._vo_line_interval
		end
	end
end

MissionObjectiveZoneScanExtension.current_progression = function (self)
	return self._current_progression / self._num_scannables_in_zone
end

MissionObjectiveZoneScanExtension.num_objets_banked = function (self)
	return self._current_progression
end

MissionObjectiveZoneScanExtension.num_scannables_in_zone = function (self)
	return self._num_scannables_in_zone
end

MissionObjectiveZoneScanExtension.selected_scannable_units = function (self)
	return self._selected_scannable_units
end

MissionObjectiveZoneScanExtension.scannable_units = function (self)
	return self._scannable_units
end

MissionObjectiveZoneScanExtension._on_player_unit_despawned = function (self, player)
	local disconnect = true

	self:release_scanned_object_from_player(player, disconnect)
end

MissionObjectiveZoneScanExtension.activate_zone = function (self)
	self._activated = true

	self:_enable_update()

	if self._is_server then
		local selected_scannable_units = self:_select_scannable_units_for_event()
		local num_scannable_units = #selected_scannable_units

		for i = 1, num_scannable_units do
			local scannable_unit_extension = ScriptUnit.extension(selected_scannable_units[i], "mission_objective_zone_scannable_system")

			scannable_unit_extension:set_active(true)
		end

		self._selected_scannable_units = selected_scannable_units

		local current_objective_name = self._mission_objective_zone_system:current_objective_name()

		if current_objective_name then
			local mission_objective_system = self._mission_objective_system
			local objective_group_id = self._objective_group_id

			mission_objective_system:set_objective_show_counter(current_objective_name, objective_group_id, true)
		end
	end
end

MissionObjectiveZoneScanExtension._deactivate_zone = function (self)
	self._is_waiting_for_player_confirmation = false

	MissionObjectiveZoneScanExtension.super._deactivate_zone(self)

	if self._is_server then
		local current_objective_name = self._mission_objective_zone_system:current_objective_name()

		if current_objective_name then
			local mission_objective_system = self._mission_objective_system
			local objective_group_id = self._objective_group_id

			mission_objective_system:override_ui_string(current_objective_name, objective_group_id, nil, nil)
		end
	end
end

MissionObjectiveZoneScanExtension.set_is_waiting_for_player_confirmation = function (self)
	self._is_waiting_for_player_confirmation = true

	if self._is_server then
		local current_objective_name = self._mission_objective_zone_system:current_objective_name()

		if current_objective_name then
			local mission_objective_system = self._mission_objective_system
			local objective_group_id = self._objective_group_id

			mission_objective_system:set_objective_show_counter(current_objective_name, objective_group_id, false)
			mission_objective_system:override_ui_string(current_objective_name, objective_group_id, RETURN_TO_SERVO_SKULL_HEADER, RETURN_TO_SERVO_SKULL_DESC)
		end

		local level_object_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_mission_objective_zone_set_waiting_for_confirmation", level_object_id)
	end
end

MissionObjectiveZoneScanExtension._vo_timer = function (self, dt)
	local vo_line_timer = self._vo_line_timer

	if vo_line_timer > 0 then
		vo_line_timer = math.max(vo_line_timer - dt, 0)
	else
		vo_line_timer = self._vo_line_interval

		local is_mission_giver_line = true
		local player

		self:_play_vo(player, SCANNING_VO_LINES.event_scan_skull_waiting, is_mission_giver_line)
	end

	self._vo_line_timer = vo_line_timer
end

MissionObjectiveZoneScanExtension._play_vo = function (self, player, scanning_vo_line, is_mission_giver_line)
	if is_mission_giver_line then
		local current_objective_name = self._mission_objective_zone_system:current_objective_name()
		local objective_group_id = self._objective_group_id
		local mission_objective = self._mission_objective_system:active_objective(current_objective_name, objective_group_id)
		local voice_profile = mission_objective:mission_giver_voice_profile()

		if voice_profile then
			local concept = MissionObjectiveScanning.vo_settings.concept

			Vo.mission_giver_vo_event(voice_profile, concept, scanning_vo_line)
		else
			Vo.mission_giver_mission_info_vo("rule_based", nil, scanning_vo_line)
		end
	else
		local player_unit = player.player_unit

		if not ALIVE[player_unit] then
			return
		end

		Vo.generic_mission_vo_event(player_unit, scanning_vo_line)
	end
end

MissionObjectiveZoneScanExtension.reset_vo_timer = function (self)
	if self._is_server then
		self._vo_line_timer = self._vo_line_interval
	end
end

MissionObjectiveZoneScanExtension.abort_vo_timer = function (self)
	if self._is_server then
		self._start_vo_line_timer = false
		self._vo_line_timer = self._vo_line_interval
	end
end

MissionObjectiveZoneScanExtension.is_waiting_for_player_confirmation = function (self)
	local is_waiting_for_player_confirmation = self._is_waiting_for_player_confirmation

	return is_waiting_for_player_confirmation
end

local SLOT_NAME = "slot_device"

MissionObjectiveZoneScanExtension._equip_auspex_to_players = function (self)
	local t = Managers.time:time("gameplay")
	local item_to_equip = self._item_to_equip
	local item = MasterItems.get_item(item_to_equip)
	local players = Managers.player:players()

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if player_unit then
			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
			local inventory_component = unit_data_extension:read_component("inventory")
			local item_name = inventory_component[SLOT_NAME]
			local is_equipped = item_name == item_to_equip

			if not is_equipped then
				local unequip_current_device = item_name ~= "not_equipped"

				if unequip_current_device then
					PlayerUnitVisualLoadout.unequip_item_from_slot(player_unit, SLOT_NAME, t)
				end

				PlayerUnitVisualLoadout.equip_item_to_slot(player_unit, item, SLOT_NAME, nil, t)
			end
		end
	end
end

MissionObjectiveZoneScanExtension._unequip_auspex_from_players = function (self)
	local t = Managers.time:time("gameplay")
	local players = Managers.player:players()

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if player_unit then
			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
			local inventory_component = unit_data_extension:read_component("inventory")
			local wielded_slot = inventory_component.wielded_slot

			if wielded_slot == SLOT_NAME then
				PlayerUnitVisualLoadout.wield_previous_weapon_slot(inventory_component, player_unit, t)
			end

			local item_to_unequip = self._item_to_equip
			local item_name = inventory_component[SLOT_NAME]
			local unequip_device = item_name == item_to_unequip

			if unequip_device then
				PlayerUnitVisualLoadout.unequip_item_from_slot(player_unit, SLOT_NAME, t)
			end
		end
	end
end

return MissionObjectiveZoneScanExtension
