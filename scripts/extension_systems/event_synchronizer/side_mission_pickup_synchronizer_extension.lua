local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local MasterItems = require("scripts/backend/master_items")
local Pickups = require("scripts/settings/pickup/pickups")
local FixedFrame = require("scripts/utilities/fixed_frame")
local SideMissionPickupSynchronizerExtension = class("SideMissionPickupSynchronizerExtension", "EventSynchronizerBaseExtension")

SideMissionPickupSynchronizerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	SideMissionPickupSynchronizerExtension.super.init(self, extension_init_context, unit, extension_init_data, ...)

	self._participate_in_game = false
	self._auto_start_on_level_spawned = false
	self._increment_value = 0
	self._player_buff_amount = 0
	self._pickup_data = nil
	self._player_buff_id = {}
	self._should_sync_buffs = false
	self._stored_grimoires = 0
end

SideMissionPickupSynchronizerExtension.setup_from_component = function (self, auto_start_on_level_spawned)
	local mission_manager = Managers.state.mission
	local side_mission = mission_manager:side_mission()

	if side_mission and mission_manager:side_mission_is_pickup() then
		local objective_name = side_mission.name

		self._mission_objective_system:register_objective_synchronizer(objective_name, self._unit)

		self._objective_name = objective_name
		self._participate_in_game = true
	end

	self._auto_start_on_level_spawned = auto_start_on_level_spawned
end

SideMissionPickupSynchronizerExtension.on_gameplay_post_init = function (self, level)
	if self._is_server and self._participate_in_game and self._auto_start_on_level_spawned then
		local objective_name = Managers.state.mission:side_mission().name

		self._mission_objective_system:start_mission_objective(objective_name)
	end
end

SideMissionPickupSynchronizerExtension.hot_join_sync = function (self, sender, channel)
	if self._player_buff_amount > 0 then
		self._should_sync_buffs = true
	end
end

SideMissionPickupSynchronizerExtension._sync_buffs = function (self, t)
	local player_manager = Managers.player
	local players = player_manager:players()
	local player_buff_id = self._player_buff_id

	for unique_id, player in pairs(players) do
		if not player_buff_id[player] then
			for i = 1, self._player_buff_amount do
				self:_add_buff(t, player)
			end
		end
	end
end

SideMissionPickupSynchronizerExtension.update = function (self, unit, dt, t)
	if self._is_server and self._participate_in_game then
		if self._should_sync_buffs then
			self:_sync_buffs(t)

			self._should_sync_buffs = false
		end

		local increment_value = self._increment_value

		if increment_value ~= 0 then
			local picked_up_unit = increment_value > 0 and true or false

			self:_update_mission_increment(dt, increment_value)

			if self._pickup_data and self._pickup_data.buff_name then
				self:_update_buff_amount(t, picked_up_unit)
			end

			local flow_event_name = picked_up_unit and "lua_picked_up_unit" or "lua_released_unit"

			Unit.flow_event(unit, flow_event_name)

			self._increment_value = 0
		end
	end
end

SideMissionPickupSynchronizerExtension.grant_grimoire = function (self, player_unit)
	if self._stored_grimoires <= 0 then
		return
	end

	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local slot_pocketable = "slot_pocketable"
	local item_name = inventory_component[slot_pocketable]

	if item_name ~= "not_equipped" then
		return
	end

	local t = FixedFrame.get_latest_fixed_time()
	local pickup_data = Pickups.by_name.grimoire
	local item_definitions = MasterItems.get_cached()
	local inventory_item = item_definitions[pickup_data.inventory_item]

	PlayerUnitVisualLoadout.equip_item_to_slot(player_unit, inventory_item, slot_pocketable, nil, t)

	if inventory_component.wielded_slot == slot_pocketable then
		PlayerUnitVisualLoadout.wield_slot(slot_pocketable, player_unit, t)
	end

	self._stored_grimoires = self._stored_grimoires - 1
end

SideMissionPickupSynchronizerExtension.store_grimoire = function (self)
	self._stored_grimoires = self._stored_grimoires + 1
end

SideMissionPickupSynchronizerExtension.start_event = function (self)
	if self._is_server then
		local unit_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_event_synchronizer_started", unit_id)
	end

	Unit.flow_event(self._unit, "lua_event_started")
end

SideMissionPickupSynchronizerExtension.update_progression = function (self, increment, pickup_data)
	if pickup_data then
		self._pickup_data = pickup_data
	end

	self._increment_value = increment
end

SideMissionPickupSynchronizerExtension._update_mission_increment = function (self, dt, increment)
	local objective_name = self._objective_name
	local mission_objective_system = Managers.state.extension:system("mission_objective_system")

	if mission_objective_system:is_current_active_objective(objective_name) then
		mission_objective_system:external_update_mission_objective(objective_name, dt, increment)
	end
end

SideMissionPickupSynchronizerExtension._update_buff_amount = function (self, t, add_buff)
	local player_manager = Managers.player
	local players = player_manager:players()
	self._player_buff_amount = add_buff and self._player_buff_amount + 1 or self._player_buff_amount - 1
	local ALIVE = ALIVE

	for unique_id, player in pairs(players) do
		if ALIVE[player.player_unit] then
			if add_buff then
				self:_add_buff(t, player)
			else
				self:_remove_buff(player)
			end
		end
	end
end

SideMissionPickupSynchronizerExtension._add_buff = function (self, t, player)
	local buff_extension = ScriptUnit.extension(player.player_unit, "buff_system")
	local buff_array = self._player_buff_id[player] or {}
	local _, buff_id, component_index = buff_extension:add_externally_controlled_buff(self._pickup_data.buff_name, t)
	local buff_data = {
		buff_id = buff_id,
		component_index = component_index
	}
	buff_array[#buff_array + 1] = buff_data
	self._player_buff_id[player] = buff_array
end

SideMissionPickupSynchronizerExtension._remove_buff = function (self, player)
	local buff_array = self._player_buff_id[player]

	if not buff_array or #buff_array == 0 then
		return
	end

	local buff_index = #buff_array
	local buff_data = buff_array[buff_index]
	local buff_extension = ScriptUnit.extension(player.player_unit, "buff_system")

	buff_extension:remove_externally_controlled_buff(buff_data.buff_id, buff_data.component_index)

	buff_array[buff_index] = nil
end

return SideMissionPickupSynchronizerExtension
