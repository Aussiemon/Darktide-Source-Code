-- chunkname: @scripts/extension_systems/mission_objective_zone/mission_objective_zone_scan_extension.lua

local MasterItems = require("scripts/backend/master_items")
local MissionObjectiveScanning = require("scripts/settings/mission_objective/mission_objective_scanning")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Vo = require("scripts/utilities/vo")
local MissionObjectiveZoneScanExtension = class("MissionObjectiveZoneScanExtension", "MissionObjectiveZoneBaseExtension")
local SCANNING_VO_LINES = MissionObjectiveScanning.vo_trigger_ids
local RETURN_TO_SERVO_SKULL_HEADER = "loc_objective_zone_scanning_return_to_servoskull_header"
local RETURN_TO_SERVO_SKULL_DESC = "loc_objective_zone_scanning_return_to_servoskull_desc"

MissionObjectiveZoneScanExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	MissionObjectiveZoneScanExtension.super.init(self, extension_init_context, unit, extension_init_data, ...)

	local is_server = extension_init_context.is_server

	self._zone_type = "scan"
	self._is_server = is_server
	self._num_scanned_objects_per_player = {}
	self._registered_players = 0
	self._num_scannables_in_zone = 0
	self._finish_zone_timer = 1
	self._start_finish_zone_timer = false
	self._current_progression = 0
	self._scannable_units = {}
	self._selected_scannable_units = {}
	self._start_vo_line_timer = false
	self._vo_line_interval = MissionObjectiveScanning.zone_settings.vo_trigger_time
	self._vo_line_timer = self._vo_line_interval

	local mission_objective_system = Managers.state.extension:system("mission_objective_system")

	self._mission_objective_system = mission_objective_system
end

MissionObjectiveZoneScanExtension.setup_from_component = function (self, num_scannable_objects, item_to_equip)
	self._num_scannables_in_zone = num_scannable_objects
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
	self._synchronizer_extension:set_servo_skull_target_enabled(true)
end

local function _set_objectie_name_on_unit(unit, objective_name, objective_group)
	local mission_objective_target_extension = ScriptUnit.extension(unit, "mission_objective_target_system")

	if mission_objective_target_extension:objective_name() == "default" then
		mission_objective_target_extension:set_objective_name(objective_name)
		mission_objective_target_extension:set_objective_group_id(objective_group)

		return true
	end

	return false
end

MissionObjectiveZoneScanExtension._select_scannable_units_for_event = function (self)
	local mission_objective_target_extension = self._mission_objective_target_extension
	local objective_name = mission_objective_target_extension:objective_name()
	local objective_group = mission_objective_target_extension:objective_group_id()
	local scannable_units = self._scannable_units
	local selected_units = {}
	local num_scannables_in_zone = self._num_scannables_in_zone
	local random_table, _ = table.generate_random_table(1, #scannable_units, self._seed)
	local i = 1
	local spawned = 0

	while spawned < num_scannables_in_zone do
		local index = random_table[i]
		local selected_unit = scannable_units[index]

		if _set_objectie_name_on_unit(selected_unit, objective_name, objective_group) then
			selected_units[#selected_units + 1] = selected_unit
			spawned = spawned + 1
		end

		i = i + 1
	end

	return selected_units
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

MissionObjectiveZoneScanExtension.set_scanned = function (self, scannable_extension, player)
	scannable_extension:set_active(false)

	self._current_progression = self._current_progression + 1

	local progression = self._current_progression

	if progression == 1 then
		local is_mission_giver_line = false

		self:_play_vo(player, SCANNING_VO_LINES.scan_performed, is_mission_giver_line)
	end

	if self._is_server then
		if progression == self._num_scannables_in_zone then
			self._start_vo_line_timer = true
			self._start_finish_zone_timer = true
		else
			self._start_vo_line_timer = false
			self._vo_line_timer = self._vo_line_interval
		end
	end
end

MissionObjectiveZoneScanExtension.current_progression = function (self)
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

		local mission_objective_system = self._mission_objective_system

		mission_objective_system:set_objective_show_counter(self._objective_name, self._objective_group, true)
	end
end

MissionObjectiveZoneScanExtension._deactivate_zone = function (self)
	self._is_waiting_for_player_confirmation = false

	MissionObjectiveZoneScanExtension.super._deactivate_zone(self)

	if self._is_server then
		local mission_objective_system = self._mission_objective_system

		mission_objective_system:override_ui_string(self._objective_name, self._objective_group, nil, nil)
	end
end

MissionObjectiveZoneScanExtension.set_is_waiting_for_player_confirmation = function (self)
	self._is_waiting_for_player_confirmation = true

	if self._is_server then
		local mission_objective_system = self._mission_objective_system

		mission_objective_system:set_objective_show_counter(self._objective_name, self._objective_group, false)
		mission_objective_system:override_ui_string(self._objective_name, self._objective_group, RETURN_TO_SERVO_SKULL_HEADER, RETURN_TO_SERVO_SKULL_DESC)

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
		local mission_objective = self._mission_objective_system:active_objective(self._objective_name, self._objective_group)
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
