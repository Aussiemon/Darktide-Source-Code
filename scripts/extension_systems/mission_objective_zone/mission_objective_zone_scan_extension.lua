-- chunkname: @scripts/extension_systems/mission_objective_zone/mission_objective_zone_scan_extension.lua

local MasterItems = require("scripts/backend/master_items")
local MissionObjectiveScanning = require("scripts/settings/mission_objective/mission_objective_scanning")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local MissionObjectiveZoneScanExtension = class("MissionObjectiveZoneScanExtension", "MissionObjectiveZoneBaseExtension")
local SCANNING_VO_LINES = MissionObjectiveScanning.vo_trigger_ids

MissionObjectiveZoneScanExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	MissionObjectiveZoneScanExtension.super.init(self, extension_init_context, unit, extension_init_data, ...)

	local is_server = extension_init_context.is_server

	self._zone_type = "scan"
	self._progress_ui_type = "counter"
	self._is_server = is_server
	self._num_scannables_in_zone = 0
	self._current_progression = 0
	self._scannable_units = {}
	self._selected_scannable_units = {}

	local mission_objective_system = Managers.state.extension:system("mission_objective_system")

	self._mission_objective_system = mission_objective_system
end

MissionObjectiveZoneScanExtension.setup_from_component = function (self, return_to_skull, num_scannable_objects, item_to_equip)
	self._return_to_skull = return_to_skull
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

	MissionObjectiveZoneScanExtension.super.hot_join_sync(self, unit, sender, channel)
end

MissionObjectiveZoneScanExtension.update = function (self, unit, dt, t)
	MissionObjectiveZoneScanExtension.super.update(self, unit, dt, t)

	if self._activated and self._is_server and not self._is_waiting_for_player_confirmation then
		self:_equip_auspex_to_players()
	end
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
	Managers.stats:record_private("hook_scan", player)

	self._current_progression = self._current_progression + 1

	local progression = self._current_progression

	if progression == 1 then
		local is_mission_giver_line = false

		self:_play_vo(player, SCANNING_VO_LINES.scan_performed, is_mission_giver_line)
	end

	if self._is_server then
		if progression == self._num_scannables_in_zone then
			if self._synchronizer_extension:uses_servo_skull() then
				self._start_vo_line_timer = true

				self:_inform_skull_of_completion()
			else
				self:zone_finished()
			end
		else
			self._start_vo_line_timer = false
			self._vo_line_timer = self._vo_line_interval
		end
	end
end

MissionObjectiveZoneScanExtension.current_progression = function (self)
	return self._current_progression
end

MissionObjectiveZoneScanExtension.max_progression = function (self)
	return self:num_scannables_in_zone()
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
	MissionObjectiveZoneScanExtension.super.activate_zone(self)

	if self._is_server then
		local selected_scannable_units = self:_select_scannable_units_for_event()
		local num_scannable_units = #selected_scannable_units

		for i = 1, num_scannable_units do
			local scannable_unit_extension = ScriptUnit.extension(selected_scannable_units[i], "mission_objective_zone_scannable_system")

			scannable_unit_extension:set_active(true)
		end

		self._selected_scannable_units = selected_scannable_units
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
	MissionObjectiveZoneScanExtension.super.set_is_waiting_for_player_confirmation(self)

	if self._is_server then
		self:_unequip_auspex_from_players()
	end
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
