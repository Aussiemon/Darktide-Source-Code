-- chunkname: @scripts/utilities/expeditions/expedition_navigation_handler.lua

local MasterItems = require("scripts/backend/master_items")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local MinigameClasses = require("scripts/settings/minigame/minigame_classes")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local Vo = require("scripts/utilities/vo")
local ExpeditionNavigationHandler = class("ExpeditionNavigationHandler")

ExpeditionNavigationHandler.init = function (self, template, is_server, world)
	self._template = template
	self._is_server = is_server
	self._auspex_map = template.auspex_map ~= false
	self._is_active = false
	self._registered_exits = {}
	self._registered_extractions = {}
	self._registered_opportunities = {}
	self._completed_levels = {}
	self._player_slot_marked = {}
	self._num_opportunities_left = 0

	local event_manager = Managers.event

	event_manager:register(self, "exit_level_spawned", "exit_level_spawned")
	event_manager:register(self, "extraction_level_spawned", "extraction_level_spawned")
	event_manager:register(self, "opportunity_level_spawned", "opportunity_level_spawned")
	event_manager:register(self, "expedition_mark_level_complete", "expedition_mark_level_complete")

	local minigame_class = MinigameClasses.expedition_map
	local wwise_world = Wwise.wwise_world(world)

	self._minigame = minigame_class:new(nil, is_server, 0, wwise_world)

	self._minigame:set_handler(self)
end

ExpeditionNavigationHandler.hot_join_sync = function (self, channel_id)
	for player_slot, level_index in pairs(self._player_slot_marked) do
		RPC.rpc_expedition_navigation_set_slot_mark(channel_id, player_slot, level_index)
	end

	for level_index, _ in pairs(self._completed_levels) do
		RPC.rpc_expedition_navigation_complete_level(channel_id, level_index)
	end

	RPC.rpc_expedition_set_navigation_active(channel_id, self._is_active)
end

ExpeditionNavigationHandler.reset = function (self, index)
	table.clear(self._registered_exits)
	table.clear(self._registered_extractions)
	table.clear(self._registered_opportunities)
	table.clear(self._completed_levels)
	table.clear(self._player_slot_marked)
	self._minigame:location_reset()

	self._num_opportunities_left = 0
end

ExpeditionNavigationHandler.set_active = function (self, enabled)
	self._is_active = enabled

	if self._is_server then
		Managers.state.game_session:send_rpc_clients("rpc_expedition_set_navigation_active", self._is_active)
	end

	if not DEDICATED_SERVER then
		local save_manager = Managers.save
		local save_data = save_manager:account_data()

		if save_data and not save_data.expedition_auspex_map_wielded then
			self._pulse_auspex_weapon = enabled
		end
	end
end

ExpeditionNavigationHandler.is_active = function (self)
	return self._is_active
end

ExpeditionNavigationHandler.destroy = function (self)
	local event_manager = Managers.event

	event_manager:unregister(self, "exit_level_spawned")
	event_manager:unregister(self, "extraction_level_spawned")
	event_manager:unregister(self, "opportunity_level_spawned")
	event_manager:unregister(self, "expedition_mark_level_complete")
end

local SLOT_NAME = "slot_device"
local ITEM_NAME = "content/items/devices/auspex_map"

ExpeditionNavigationHandler.server_update = function (self, dt, t)
	if self._auspex_map then
		local should_be_equipped = self._is_active
		local item = MasterItems.get_item(ITEM_NAME)
		local players = Managers.player:players()

		for _, player in pairs(players) do
			local player_unit = player.player_unit

			if player_unit then
				local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
				local inventory_component = unit_data_extension:read_component("inventory")
				local current_item_name = inventory_component[SLOT_NAME]
				local is_equipped = current_item_name == ITEM_NAME

				if should_be_equipped then
					if not is_equipped and current_item_name == "not_equipped" then
						PlayerUnitVisualLoadout.equip_item_to_slot(player_unit, item, SLOT_NAME, nil, t)
					end
				else
					local wielded_slot = inventory_component.wielded_slot

					if wielded_slot == SLOT_NAME then
						PlayerUnitVisualLoadout.wield_previous_weapon_slot(inventory_component, player_unit, t)
					end

					if is_equipped then
						PlayerUnitVisualLoadout.unequip_item_from_slot(player_unit, SLOT_NAME, t)
					end
				end
			end
		end
	end
end

ExpeditionNavigationHandler.update = function (self, dt, t)
	if self._pulse_auspex_weapon then
		if not self._pulse_auspex_weapon_hud_timer or t >= self._pulse_auspex_weapon_hud_timer then
			self._pulse_auspex_weapon_hud_timer = t + 1.5

			Managers.event:trigger("event_flash_slot_display_by_id", "slot_device")
		end

		local local_player = Managers.player:local_player(1)

		if local_player and self:_is_player_wielding_auspex(local_player) then
			self._pulse_auspex_weapon = nil

			local save_manager = Managers.save
			local save_data = save_manager:account_data()

			if save_data and not save_data.expedition_auspex_map_wielded then
				save_data.expedition_auspex_map_wielded = true

				save_manager:queue_save()
			end
		end
	end
end

local SLOT_DEVICE_NAME = "slot_device"

ExpeditionNavigationHandler._is_player_wielding_auspex = function (self, player)
	local player_unit = player.player_unit
	local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

	if not unit_data_extension then
		return false
	end

	local inventory_component = unit_data_extension:read_component("inventory")
	local wielded_slot = inventory_component.wielded_slot

	if wielded_slot ~= SLOT_DEVICE_NAME then
		return false
	end

	local visual_loadout_extension = ScriptUnit.has_extension(player_unit, "visual_loadout_system")
	local weapon_item = visual_loadout_extension and visual_loadout_extension:item_in_slot(SLOT_DEVICE_NAME)
	local weapon_template = weapon_item and WeaponTemplate.weapon_template_from_item(weapon_item)

	if not weapon_template then
		return false
	end

	local not_player_wieldable = weapon_template.not_player_wieldable

	if not_player_wieldable then
		return false
	end

	local is_auspex = weapon_template.name == "auspex_map"

	if is_auspex then
		return true
	end
end

ExpeditionNavigationHandler.minigame = function (self)
	return self._minigame
end

ExpeditionNavigationHandler.get_registered_exits = function (self)
	return self._registered_exits
end

ExpeditionNavigationHandler.get_registered_extractions = function (self)
	return self._registered_extractions
end

ExpeditionNavigationHandler.get_registered_opportunities = function (self)
	return self._registered_opportunities
end

ExpeditionNavigationHandler.get_marked_player_slots = function (self)
	return self._player_slot_marked
end

ExpeditionNavigationHandler.is_level_completed = function (self, level_index)
	return self._completed_levels[level_index]
end

ExpeditionNavigationHandler.exit_level_spawned = function (self, level_index, position)
	self._registered_exits[level_index] = Vector3Box(position)
end

ExpeditionNavigationHandler.extraction_level_spawned = function (self, level_index, position)
	self._registered_extractions[level_index] = Vector3Box(position)
end

ExpeditionNavigationHandler.opportunity_level_spawned = function (self, level_index, position)
	self._registered_opportunities[level_index] = Vector3Box(position)
	self._num_opportunities_left = self._num_opportunities_left + 1
end

ExpeditionNavigationHandler.exit_level_removed = function (self, level_index)
	self._registered_exits[level_index] = nil

	if self._is_server then
		Managers.state.game_session:send_rpc_clients("rpc_expedition_navigation_remove_exit", level_index)
	end
end

ExpeditionNavigationHandler._get_player_from_slot = function (self, slot)
	local players = Managers.player:players()

	for _, player in pairs(players) do
		if player:slot() == slot then
			return player
		end
	end

	return nil
end

ExpeditionNavigationHandler.expedition_mark_level_complete = function (self, level_index)
	self._completed_levels[level_index] = true

	if self._is_server then
		Managers.state.game_session:send_rpc_clients("rpc_expedition_navigation_complete_level", level_index)
		Managers.stats:record_team("hook_expedition_opportunity_completed")
	end

	if Managers.ui then
		Managers.ui:play_2d_sound("wwise/events/player/play_device_auspex_exps_opportunity_done")
	end

	for player_slot, level in pairs(self._player_slot_marked) do
		if level == level_index then
			if self._is_server then
				local player = self:_get_player_from_slot(player_slot)

				if player then
					Managers.achievements:unlock_achievement(player, "expeditions_complete_self_marked_opportunities")
				end

				Managers.state.game_session:send_rpc_clients("rpc_expedition_navigation_clear_slot_mark", player_slot)
			end

			self._player_slot_marked[player_slot] = nil
		end
	end

	if self._registered_opportunities[level_index] then
		self._num_opportunities_left = self._num_opportunities_left - 1

		if self._num_opportunities_left == 0 then
			Vo.mission_giver_mission_info_vo("selected_voice", "tech_priest_a", "expeditions_opportunities_no_more_a")
		end
	end
end

ExpeditionNavigationHandler.player_slot_by_level_marked = function (self, level_index)
	for player_slot, level in pairs(self._player_slot_marked) do
		if level == level_index then
			return player_slot
		end
	end

	return nil
end

ExpeditionNavigationHandler.mark_level_by_player = function (self, level_index, player)
	local player_slot = player and player.slot and player:slot()

	if not player_slot then
		return false
	end

	local current_slot = self:player_slot_by_level_marked(level_index)

	if current_slot == player_slot then
		self._player_slot_marked[player_slot] = nil

		if self._is_server then
			Managers.state.game_session:send_rpc_clients_except("rpc_expedition_navigation_clear_slot_mark", player:channel_id(), player_slot)
		else
			Managers.state.game_session:send_rpc_server("rpc_expedition_navigation_clear_slot_mark", player_slot)
		end

		return true, false
	elseif current_slot == nil and not self._completed_levels[level_index] then
		self._player_slot_marked[player_slot] = level_index

		if self._is_server then
			Managers.state.game_session:send_rpc_clients_except("rpc_expedition_navigation_set_slot_mark", player:channel_id(), player_slot, level_index)
		else
			Managers.state.game_session:send_rpc_server("rpc_expedition_navigation_set_slot_mark", player_slot, level_index)
		end

		return true, true
	end

	return false
end

ExpeditionNavigationHandler.rpc_player_mark_level = function (self, player_slot, level_index)
	self._player_slot_marked[player_slot] = level_index
end

return ExpeditionNavigationHandler
