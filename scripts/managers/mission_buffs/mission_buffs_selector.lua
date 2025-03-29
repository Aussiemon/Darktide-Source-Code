-- chunkname: @scripts/managers/mission_buffs/mission_buffs_selector.lua

local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local MissionBuffsAllowedBuffs = require("scripts/managers/mission_buffs/mission_buffs_allowed_buffs")
local MissionBuffsSettings = require("scripts/managers/mission_buffs/mission_buffs_settings")
local filtering_categories = MissionBuffsSettings.filtering_categories
local filtering_categories_pick_rate_per_wave = MissionBuffsSettings.filtering_categories_pick_rate_per_wave
local MissionBuffsSelector = class("MissionBuffsSelector")
local NUM_OPTIONS_PER_CHOICE = 3
local SERVER_RPCS = {
	"rpc_server_mission_buffs_player_buff_choice",
}

MissionBuffsSelector._register_events = function (self)
	return
end

MissionBuffsSelector._unregister_events = function (self)
	return
end

MissionBuffsSelector._register_rpcs = function (self, network_event_delegate)
	network_event_delegate:register_session_events(self, unpack(SERVER_RPCS))
end

MissionBuffsSelector._unregister_rpcs = function (self, network_event_delegate)
	network_event_delegate:unregister_events(unpack(SERVER_RPCS))
end

MissionBuffsSelector.init = function (self, mission_buffs_manager, mission_buffs_handler, network_event_delegate, is_server)
	self._is_server = is_server
	self._mission_buffs_manager = mission_buffs_manager
	self._mission_buffs_handler = mission_buffs_handler

	self:_register_events()
	self:_register_rpcs(network_event_delegate)

	self._network_event_delegate = network_event_delegate
end

MissionBuffsSelector.destroy = function (self)
	self._mission_buffs_manager = nil
	self._mission_buffs_handler = nil

	self:_unregister_events()
	self:_unregister_rpcs(self._network_event_delegate)

	self._network_event_delegate = nil
end

MissionBuffsSelector.give_random_buff_to_all = function (self, buffs_pool)
	local random_buff = self._get_random_buff_from_pool(buffs_pool)

	self._mission_buffs_handler:give_buff_to_all(random_buff)
end

MissionBuffsSelector.give_random_buff_to_player = function (self, player, buffs_pool)
	local random_buff = self._get_random_buff_from_pool(buffs_pool)

	self._mission_buffs_handler:give_buff_to_player(player, random_buff)
end

MissionBuffsSelector.give_family_buff_to_all = function (self, skip_notification)
	local players = Managers.player:human_players()

	for _, player in pairs(players) do
		self:give_family_buff_to_player(player, skip_notification)
	end
end

MissionBuffsSelector.give_family_buff_to_player = function (self, player, skip_notification)
	local mission_buffs_handler = self._mission_buffs_handler
	local is_human = player:is_human_controlled()

	if is_human then
		local player_has_family_selected = mission_buffs_handler:does_player_have_family_selected(player)

		if not player_has_family_selected then
			Log.error("MissionBuffsSelector", string.format("Player has no family selected but we tried to give it a family buff (PeerID %s)", player:peer_id()))

			return
		end

		local buff_name = self:_get_random_family_buff_for_player(player)

		if buff_name then
			mission_buffs_handler:give_buff_to_player(player, buff_name, skip_notification, nil)
		end
	end
end

MissionBuffsSelector._get_random_family_buff_for_player = function (self, player)
	local priority_buffs_available, family_buffs_available = self._mission_buffs_handler:get_family_buffs_available_for_player(player)
	local target_buff_pool = #priority_buffs_available > 0 and priority_buffs_available or family_buffs_available
	local num_buffs = #target_buff_pool

	if num_buffs <= 0 then
		return nil
	end

	local random_buff_index = math.random(num_buffs)
	local random_buff_name = target_buff_pool[random_buff_index]

	table.remove(target_buff_pool, random_buff_index)

	return random_buff_name
end

MissionBuffsSelector._get_family_buffs_pool = function (self, family_name)
	return MissionBuffsAllowedBuffs.buff_families[family_name].buffs
end

MissionBuffsSelector._init_legendary_buffs_pool_for_player = function (self, player, buffs_to_exclude)
	local valid_categorized_buffs = {}

	for _, filtering_category in pairs(filtering_categories) do
		valid_categorized_buffs[filtering_category] = {}
	end

	local valid_buffs = self:_get_valid_legendary_buffs_for_player_setup(player)

	for _, buff_name in ipairs(valid_buffs) do
		if not buffs_to_exclude[buff_name] then
			local buff_data = HordesBuffsData[buff_name]
			local buff_filtering_category = buff_data.filter_category
			local target_pool = valid_categorized_buffs[buff_filtering_category]

			table.insert(target_pool, buff_name)
		else
			Log.info("MissionBuffsSelector", "Excluded Buff %s from pool", buff_name)
		end
	end

	self._mission_buffs_handler:set_legendary_buffs_available_for_player(player, valid_categorized_buffs)
end

MissionBuffsSelector._get_valid_legendary_buffs_for_player_setup = function (self, player)
	local legendary_buffs = MissionBuffsAllowedBuffs.legendary_buffs
	local valid_buffs = {}

	table.append(valid_buffs, legendary_buffs.generic)

	local player_unit = player.player_unit
	local player_ability_extension = ScriptUnit.has_extension(player_unit, "ability_system")

	if not player_ability_extension then
		return valid_buffs
	end

	local player_class_name = player:archetype_name()
	local equipped_abilities = player_ability_extension:equipped_abilities()
	local player_grenade_ability_name = player_ability_extension:has_ability_type("grenade_ability") and equipped_abilities.grenade_ability.name
	local player_combat_ability_name = player_ability_extension:has_ability_type("combat_ability") and equipped_abilities.combat_ability.ability_group
	local player_has_basic_ogryn_box = player_class_name == "ogryn" and player_grenade_ability_name == "ogryn_grenade_box"

	if player_has_basic_ogryn_box then
		self._mission_buffs_handler:give_buff_to_player(player, "hordes_buff_ogryn_basic_box_spawns_cluster", true, false)
	end

	local legendary_class_buffs = legendary_buffs[player_class_name]

	if legendary_class_buffs and legendary_class_buffs.grenade_ability[player_grenade_ability_name] then
		table.append(valid_buffs, legendary_class_buffs.grenade_ability[player_grenade_ability_name])
	end

	if legendary_class_buffs and legendary_class_buffs.combat_ability[player_combat_ability_name] then
		table.append(valid_buffs, legendary_class_buffs.combat_ability[player_combat_ability_name])
	end

	return valid_buffs
end

MissionBuffsSelector._pop_legendary_buff_from_players_pool = function (self, player, wave_num)
	local target_wave = "wave_" .. (wave_num or 3)
	local categories_available = {}
	local legendary_buffs_available = self._mission_buffs_handler:get_legendary_buffs_available_for_player(player)
	local total_weight = 0

	for category, buffs_available in pairs(legendary_buffs_available) do
		local target_wave_pick_rates = filtering_categories_pick_rate_per_wave[target_wave]
		local category_weight = target_wave_pick_rates and target_wave_pick_rates[category] or 1

		if not target_wave_pick_rates then
			Log.error("MissionBuffsSelector", string.format("Category [%s] has missing data for category pick rate per wave. %s", category, target_wave))
		end

		if #buffs_available > 0 and category_weight > 0 then
			total_weight = total_weight + category_weight

			local category_data = {
				name = category,
				weight = category_weight,
			}

			table.insert(categories_available, category_data)
		end
	end

	if total_weight == 0 then
		Log.error("MissionBuffsSelector", string.format("There are no legendary buffs left on player's data (PeerID %s)", player:peer_id()))

		return nil
	end

	local random_num = math.random(1, total_weight)
	local picked_category

	for _, category_data in ipairs(categories_available) do
		local category_weight = category_data.weight

		if random_num <= category_weight then
			picked_category = category_data.name

			break
		else
			random_num = random_num - category_weight
		end
	end

	local buffs_in_picked_category = legendary_buffs_available[picked_category]

	return self._get_random_buff_and_remove_from_pool(buffs_in_picked_category)
end

MissionBuffsSelector._get_random_buff_from_pool = function (buffs_pool)
	local available_buffs = buffs_pool
	local num_buffs = #available_buffs

	return available_buffs[math.random(num_buffs)]
end

MissionBuffsSelector._get_random_buff_and_remove_from_pool = function (buffs_pool)
	local available_buffs = buffs_pool
	local num_buffs = #available_buffs
	local target_index = math.random(num_buffs)
	local target_buff_name = available_buffs[target_index]

	table.swap_delete(available_buffs, target_index)

	return target_buff_name
end

MissionBuffsSelector._fill_with_random_items_from_pool = function (items_pool, num_items, results)
	local items_pool_clone = table.shallow_copy(items_pool)
	local num_available_items = #items_pool_clone
	local num_items_left = num_items

	while num_items_left > 0 and num_available_items > 0 do
		local random_index = math.random(num_available_items)

		table.insert(results, items_pool_clone[random_index])
		table.remove(items_pool_clone, random_index)

		num_items_left = num_items_left - 1
		num_available_items = #items_pool_clone
	end
end

MissionBuffsSelector.create_buff_family_choice_for_all = function (self, num_choices)
	local players = Managers.player:human_players()

	for _, player in pairs(players) do
		self:create_buff_family_choice_for_player(player, num_choices)
	end
end

MissionBuffsSelector.create_buff_family_choice_for_player = function (self, player, num_choices)
	local is_human = player:is_human_controlled()

	if is_human then
		local family_buffs_pool = MissionBuffsAllowedBuffs.available_family_builds
		local buff_families_name_options = {}

		self._fill_with_random_items_from_pool(family_buffs_pool, NUM_OPTIONS_PER_CHOICE, buff_families_name_options)
		self._mission_buffs_handler:save_buff_family_choice_for_player(player, buff_families_name_options)
		self:try_start_new_buff_choice_for_player(player)
		self._mission_buffs_handler:check_if_all_players_chosen_family()
	end
end

MissionBuffsSelector.create_legendary_buff_choice_for_player = function (self, player, wave_num, num_choices)
	local is_human = player:is_human_controlled()

	if is_human then
		local buff_names = ""
		local buff_choices = {}

		for i = 1, NUM_OPTIONS_PER_CHOICE do
			local buff_name = self:_pop_legendary_buff_from_players_pool(player, wave_num)

			if buff_name then
				table.insert(buff_choices, buff_name)

				buff_names = buff_names .. buff_name .. " || "
			end
		end

		if #buff_choices == NUM_OPTIONS_PER_CHOICE then
			Log.info("MissionBuffsSelector", "New choice created for Player (PeerID: %s): %s", player:peer_id(), buff_names)
			self._mission_buffs_handler:save_buff_choice_for_player(player, buff_choices)
		else
			self._mission_buffs_handler:restore_unselected_legendary_buffs_to_player_pool(player, buff_choices, -1)
			Log.error("MissionBuffsSelector", string.format("Not enough buffs are left in the pool to create a full choice for player (PeerID %s). Only %d left", player:peer_id(), #buff_choices))
		end
	end
end

MissionBuffsSelector.create_legendary_buff_choice_for_all = function (self, wave_num, num_choices)
	local players = Managers.player:human_players()

	for _, player in pairs(players) do
		self:create_legendary_buff_choice_for_player(player, wave_num, num_choices)
		self:try_start_new_buff_choice_for_player(player)
	end
end

MissionBuffsSelector.player_selected_buff_choice = function (self, player, choice_index)
	local selected_choice_name, is_buff_family_choice = self._mission_buffs_handler:try_resolve_current_choice_for_player(player, choice_index)

	if not selected_choice_name then
		Log.info("MissionBuffsSelector", "Tried to select buff from non existent choice.")

		return
	end

	if is_buff_family_choice then
		self:set_buff_family_for_player(player, selected_choice_name, true)
		self:give_family_buff_to_player(player)
		self._mission_buffs_manager:check_catchup_for_new_player(player)
		self._mission_buffs_handler:check_if_all_players_chosen_family()
	else
		self._mission_buffs_handler:give_buff_to_player(player, selected_choice_name, true)
	end
end

MissionBuffsSelector.set_buff_family_for_player = function (self, player, buff_family_name, from_choice)
	Log.info("MissionBuffsSelector", "Setting Buff Family %s to player (peer_id: %s)", buff_family_name, player:peer_id())

	local family_build = MissionBuffsAllowedBuffs.buff_families[buff_family_name]

	self._mission_buffs_handler:set_buff_family_for_player(player, buff_family_name, family_build.priority_buffs, family_build.buffs, from_choice)
end

MissionBuffsSelector.try_start_new_buff_choice_for_player = function (self, player)
	local new_choice = self._mission_buffs_handler:try_start_new_choice_for_player(player)

	if new_choice then
		self._mission_buffs_manager:send_choice_options_to_player(player, new_choice)
	end
end

MissionBuffsSelector.rpc_server_mission_buffs_player_buff_choice = function (self, channel_id, peer_id, local_player_id, choice_index)
	local target_player = Managers.player:player(peer_id, local_player_id)

	if target_player == nil then
		Log.exception("MissionBuffsSelector", "Could not find target player (peerID: %s) for buff choice %i", peer_id, choice_index)

		return
	end

	self:player_selected_buff_choice(target_player, choice_index)
	self:try_start_new_buff_choice_for_player(target_player)
end

return MissionBuffsSelector
