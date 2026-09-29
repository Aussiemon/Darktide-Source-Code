-- chunkname: @scripts/managers/mission_buffs/mission_buffs_selector.lua

local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local AllowedBuffs = require("scripts/managers/mission_buffs/mission_buffs_allowed_buffs")
local MissionBuffsSettings = require("scripts/managers/mission_buffs/mission_buffs_settings")
local filtering_categories = MissionBuffsSettings.filtering_categories
local filtering_categories_pick_rate_per_wave = MissionBuffsSettings.filtering_categories_pick_rate_per_wave
local MissionBuffsSelector = class("MissionBuffsSelector")
local NUM_OPTIONS_PER_CHOICE = 3
local COMPOSED_CHOICE_MAX_DRAW_ATTEMPTS = 8
local MAX_AUTO_GRANTED_CHOICES_PER_PASS = 16
local COMPOSED_CHOICE_CATEGORIES = {
	legendary = {
		pop = "_pop_legendary_buff_for_choice_category",
		restore = "_restore_legendary_buff_to_players_pool"
	},
	family = {
		pop = "_pop_family_buff_for_choice_category",
		restore = "_restore_family_buff_to_players_pool"
	},
	basic = {
		granted = "_on_basic_buff_granted_to_player",
		pop = "_pop_basic_buff_for_choice_category",
		restore = "_restore_basic_buff_to_players_pool"
	}
}
local SERVER_RPCS = {
	"rpc_server_mission_buffs_player_buff_choice"
}

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
	self._composed_choices_by_player = {}
	self._reserved_basic_buffs_by_player = {}
	self._is_starting_choice_for_player = {}

	self:_register_rpcs(network_event_delegate)

	self._network_event_delegate = network_event_delegate
end

MissionBuffsSelector.destroy = function (self)
	self._mission_buffs_manager = nil
	self._mission_buffs_handler = nil

	table.clear(self._composed_choices_by_player)

	self._composed_choices_by_player = nil

	table.clear(self._reserved_basic_buffs_by_player)

	self._reserved_basic_buffs_by_player = nil

	table.clear(self._is_starting_choice_for_player)

	self._is_starting_choice_for_player = nil

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
	local is_human = player:is_human_controlled()

	if not is_human then
		return
	end

	local mission_buffs_handler = self._mission_buffs_handler
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

MissionBuffsSelector._get_random_family_buff_for_player = function (self, player)
	local random_buff_name = self:_pop_family_buff_from_players_pool(player)

	return random_buff_name
end

MissionBuffsSelector._get_family_buffs_pool = function (self, family_name)
	return AllowedBuffs.buff_families[family_name].buffs
end

MissionBuffsSelector.init_legendary_buffs_pool_for_player = function (self, player, buffs_to_exclude)
	local valid_categorized_buffs = {}

	for _, filtering_category in pairs(filtering_categories) do
		valid_categorized_buffs[filtering_category] = {}
	end

	local valid_buffs, buffs_in_pool_already_given_to_player = self:_get_valid_legendary_buffs_for_player_setup(player)

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

	self._mission_buffs_handler:set_legendary_buffs_available_for_player(player, valid_categorized_buffs, buffs_in_pool_already_given_to_player)
end

MissionBuffsSelector._filter_and_append_buffs = function (self, player, dest, buffs_to_append, filtered_out_buffs)
	local dest_size = #dest
	local source_size = #buffs_to_append

	for i = 1, source_size do
		local buff_name = buffs_to_append[i]
		local buff_already_given = self._mission_buffs_handler:does_player_have_buff_saved(player, buff_name)

		if not buff_already_given then
			dest_size = dest_size + 1
			dest[dest_size] = buff_name
		else
			table.insert(filtered_out_buffs, buff_name)
			Log.info("MissionBuffsSelector", "Player (PeerID: %s) with Archetype [%s] already had been given buff [%s].", player:peer_id(), player:archetype_name(), buff_name)
		end
	end
end

MissionBuffsSelector._get_valid_legendary_buffs_for_player_setup = function (self, player)
	local legendary_buffs = AllowedBuffs.legendary_buffs
	local valid_buffs = {}
	local buffs_in_pool_already_given_to_player = {}

	self:_filter_and_append_buffs(player, valid_buffs, legendary_buffs.generic, buffs_in_pool_already_given_to_player)

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

	if legendary_class_buffs and legendary_class_buffs.generic and #legendary_class_buffs.generic > 0 then
		self:_filter_and_append_buffs(player, valid_buffs, legendary_class_buffs.generic, buffs_in_pool_already_given_to_player)
	end

	if legendary_class_buffs and legendary_class_buffs.grenade_ability[player_grenade_ability_name] then
		self:_filter_and_append_buffs(player, valid_buffs, legendary_class_buffs.grenade_ability[player_grenade_ability_name], buffs_in_pool_already_given_to_player)
	end

	if legendary_class_buffs and legendary_class_buffs.combat_ability[player_combat_ability_name] then
		self:_filter_and_append_buffs(player, valid_buffs, legendary_class_buffs.combat_ability[player_combat_ability_name], buffs_in_pool_already_given_to_player)
	end

	if legendary_class_buffs and legendary_class_buffs.talent_specific then
		local profile = player:profile()
		local talents = profile and profile.talents

		for talent_name, talent_based_buffs in pairs(legendary_class_buffs.talent_specific) do
			if talents[talent_name] then
				self:_filter_and_append_buffs(player, valid_buffs, talent_based_buffs, buffs_in_pool_already_given_to_player)
			end
		end
	end

	return valid_buffs, buffs_in_pool_already_given_to_player
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
				weight = category_weight
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

MissionBuffsSelector._fill_with_random_items_from_weighted_pool = function (items_pool, items_pool_weights, num_items, results)
	local total_weight = 0
	local weighted_pool_data = {}

	for _, item_name in pairs(items_pool) do
		local item_weight = items_pool_weights[item_name] or 1

		if item_weight > 0 then
			total_weight = total_weight + item_weight

			if not items_pool_weights[item_name] then
				Log.warning("MissionBuffsSelector", string.format("[%s] has missing weights. Defaulting to 1.", item_name))
			end

			local data = {
				name = item_name,
				weight = item_weight
			}

			table.insert(weighted_pool_data, data)
		end
	end

	local num_available_items = #weighted_pool_data
	local num_items_left = num_items

	while num_items_left > 0 and num_available_items > 0 do
		local random_num = math.random(1, total_weight)

		for i = 1, #weighted_pool_data do
			local weighted_item_data = weighted_pool_data[i]
			local item_weight = weighted_item_data.weight

			if random_num <= item_weight then
				table.insert(results, weighted_item_data.name)
				table.remove(weighted_pool_data, i)

				num_available_items = num_available_items - 1
				num_items_left = num_items_left - 1
				total_weight = total_weight - item_weight

				break
			else
				random_num = random_num - item_weight
			end
		end
	end
end

MissionBuffsSelector.create_buff_family_choice_for_all = function (self, num_choices)
	local players = Managers.player:human_players()

	for _, player in pairs(players) do
		local player_has_family_selected = self._mission_buffs_handler:does_player_have_family_selected(player)

		if not player_has_family_selected then
			self:create_buff_family_choice_for_player(player, num_choices)
		end
	end
end

MissionBuffsSelector.create_buff_family_choice_for_player = function (self, player, num_choices)
	local is_human = player:is_human_controlled()

	if not is_human then
		return
	end

	local family_buffs_pool = AllowedBuffs.available_family_builds
	local buff_families_name_options = {}
	local weighted_randomization_data = self._mission_buffs_manager:get_weighted_randomization_data()

	self._fill_with_random_items_from_weighted_pool(family_buffs_pool, weighted_randomization_data.buff_family_weights, NUM_OPTIONS_PER_CHOICE, buff_families_name_options)

	if num_choices > #buff_families_name_options then
		self._fill_with_random_items_from_pool(family_buffs_pool, NUM_OPTIONS_PER_CHOICE, buff_families_name_options)
	end

	self._mission_buffs_handler:save_buff_family_choice_for_player(player, buff_families_name_options)
	self:try_start_new_buff_choice_for_player(player)
	self._mission_buffs_handler:check_if_all_players_chosen_family()
end

MissionBuffsSelector.create_legendary_buff_choice_for_player = function (self, player, wave_num, num_choices)
	local is_human = player:is_human_controlled()

	if not is_human then
		return
	end

	local target_num_choices = num_choices or NUM_OPTIONS_PER_CHOICE
	local buff_names = ""
	local buff_choices = {}

	for i = 1, target_num_choices do
		local buff_name = self:_pop_legendary_buff_from_players_pool(player, wave_num)

		if buff_name then
			table.insert(buff_choices, buff_name)

			buff_names = buff_names .. buff_name .. " || "
		end
	end

	local num_drawn = #buff_choices

	if num_drawn == 0 then
		Log.error("MissionBuffsSelector", string.format("No legendary buffs left in the pool for player (PeerID %s).", player:peer_id()))

		return
	elseif num_drawn < target_num_choices then
		Log.warning("MissionBuffsSelector", string.format("Creating a short legendary choice for player (PeerID %s). Only %d left in the pool.", player:peer_id(), num_drawn))
		self._mission_buffs_handler:restore_unselected_legendary_buffs_to_player_pool(player, buff_choices, nil)

		return
	end

	Log.info("MissionBuffsSelector", "New choice created for Player (PeerID: %s): %s", player:peer_id(), buff_names)
	self._mission_buffs_handler:save_buff_choice_for_player(player, buff_choices)
end

MissionBuffsSelector.create_legendary_buff_choice_for_all = function (self, wave_num, num_choices)
	local players = Managers.player:human_players()

	for _, player in pairs(players) do
		self:create_legendary_buff_choice_for_player(player, wave_num, num_choices)
		self:try_start_new_buff_choice_for_player(player)
	end
end

MissionBuffsSelector.create_composed_buff_choice_for_player = function (self, player, composition, context)
	local is_human = player:is_human_controlled()

	if not is_human then
		return false
	end

	context = context or {}

	local num_options = composition.num_options or NUM_OPTIONS_PER_CHOICE
	local entries = self:_build_composed_choice_entries(composition, num_options)
	local draws = self:_draw_composed_choice_options(player, entries, num_options, context)
	local num_draws = #draws

	if num_draws == 0 then
		Log.error("MissionBuffsSelector", string.format("No buffs left to compose a choice for player (PeerID %s). Wanted %d.", player:peer_id(), num_options))

		return false
	end

	if num_draws < num_options then
		Log.warning("MissionBuffsSelector", string.format("Composing a short choice for player (PeerID %s). Wanted %d, drew %d.", player:peer_id(), num_options, num_draws))
	end

	if composition.shuffle_options ~= false then
		self._shuffle_array(draws)
	end

	local buff_choices = {}
	local buff_names = ""

	for i = 1, #draws do
		local draw = draws[i]

		buff_choices[i] = draw.buff_name
		buff_names = buff_names .. draw.buff_name .. "[" .. draw.category .. "] || "
	end

	self:_register_composed_choice(player, buff_choices, draws)
	Log.info("MissionBuffsSelector", "New composed choice created for Player (PeerID: %s): %s", player:peer_id(), buff_names)
	self._mission_buffs_handler:save_buff_choice_for_player(player, buff_choices, {
		skip_automatic_restore = true
	})
	self:try_start_new_buff_choice_for_player(player)

	return true
end

MissionBuffsSelector.create_composed_buff_choice_for_all = function (self, composition, context)
	local players = Managers.player:human_players()

	for _, player in pairs(players) do
		self:create_composed_buff_choice_for_player(player, composition, context)
	end
end

MissionBuffsSelector._build_composed_choice_entries = function (self, composition, num_options)
	local entries = {}

	for i = 1, #composition.categories do
		local category_settings = composition.categories[i]
		local category_name = category_settings.name
		local category_provider = COMPOSED_CHOICE_CATEGORIES[category_name]

		entries[i] = {
			is_exhausted = false,
			num_drawn = 0,
			name = category_name,
			provider = category_provider,
			min = category_settings.min or 0,
			max = category_settings.max or num_options,
			weight = category_settings.weight or 1
		}
	end

	return entries
end

MissionBuffsSelector._draw_composed_choice_options = function (self, player, entries, num_options, context)
	local draws = {}
	local drawn_buff_names = {}

	for i = 1, #entries do
		local entry = entries[i]

		for _ = 1, entry.min do
			if num_options <= #draws then
				break
			end

			self:_try_draw_composed_choice_option(player, entry, draws, drawn_buff_names, context)
		end
	end

	while num_options > #draws do
		local entry = self._pick_composed_choice_entry(entries)

		if not entry then
			break
		end

		self:_try_draw_composed_choice_option(player, entry, draws, drawn_buff_names, context)
	end

	return draws
end

MissionBuffsSelector._try_draw_composed_choice_option = function (self, player, entry, draws, drawn_buff_names, context)
	local provider = entry.provider

	for _ = 1, COMPOSED_CHOICE_MAX_DRAW_ATTEMPTS do
		local buff_name, restore_data = self[provider.pop](self, player, context)

		if not buff_name then
			entry.is_exhausted = true

			return false
		end

		if not drawn_buff_names[buff_name] then
			drawn_buff_names[buff_name] = true
			entry.num_drawn = entry.num_drawn + 1
			draws[#draws + 1] = {
				buff_name = buff_name,
				category = entry.name,
				restore_data = restore_data
			}

			return true
		end

		self[provider.restore](self, player, buff_name, restore_data)
	end

	entry.is_exhausted = true

	return false
end

MissionBuffsSelector._pick_composed_choice_entry = function (entries)
	local total_weight = 0
	local candidates = {}

	for i = 1, #entries do
		local entry = entries[i]
		local has_capacity = entry.num_drawn < entry.max

		if has_capacity and not entry.is_exhausted and entry.weight > 0 then
			total_weight = total_weight + entry.weight
			candidates[#candidates + 1] = entry
		end
	end

	if total_weight <= 0 then
		return nil
	end

	local random_num = math.random() * total_weight

	for i = 1, #candidates do
		local entry = candidates[i]

		if random_num <= entry.weight then
			return entry
		end

		random_num = random_num - entry.weight
	end

	return candidates[#candidates]
end

MissionBuffsSelector._register_composed_choice = function (self, player, buff_choices, draws)
	local player_key = self._get_player_key(player)
	local player_choices = self._composed_choices_by_player[player_key]

	if not player_choices then
		player_choices = {}
		self._composed_choices_by_player[player_key] = player_choices
	end

	local option_lookup = {}

	for i = 1, #buff_choices do
		option_lookup[buff_choices[i]] = true
	end

	player_choices[#player_choices + 1] = {
		option_lookup = option_lookup,
		draws = draws
	}
end

MissionBuffsSelector._resolve_composed_choice = function (self, player, selected_buff_name)
	local player_key = self._get_player_key(player)
	local player_choices = self._composed_choices_by_player[player_key]

	if not player_choices then
		return false
	end

	for i = 1, #player_choices do
		local record = player_choices[i]

		if record.option_lookup[selected_buff_name] then
			table.remove(player_choices, i)
			self:_restore_composed_choice_draws(player, record.draws, selected_buff_name)

			return true
		end
	end

	return false
end

MissionBuffsSelector._restore_composed_choice_draws = function (self, player, draws, optional_selected_buff_name)
	for i = 1, #draws do
		local draw = draws[i]
		local provider = COMPOSED_CHOICE_CATEGORIES[draw.category]
		local was_selected = draw.buff_name == optional_selected_buff_name

		if was_selected then
			local granted_method = provider.granted

			if granted_method then
				self[granted_method](self, player, draw.buff_name, draw.restore_data)
			end
		else
			self[provider.restore](self, player, draw.buff_name, draw.restore_data)
		end
	end
end

MissionBuffsSelector.clear_composed_choices_for_player = function (self, player)
	local player_key = self._get_player_key(player)

	self._composed_choices_by_player[player_key] = nil
	self._reserved_basic_buffs_by_player[player_key] = nil
end

MissionBuffsSelector._get_player_key = function (player)
	if player.unique_id then
		return player:unique_id()
	end

	return string.format("%s_%s", player:peer_id(), player:local_player_id())
end

MissionBuffsSelector._shuffle_array = function (array)
	for i = #array, 2, -1 do
		local j = math.random(i)

		array[i], array[j] = array[j], array[i]
	end
end

MissionBuffsSelector._pop_legendary_buff_for_choice_category = function (self, player, context)
	local buff_name = self:_pop_legendary_buff_from_players_pool(player, context.wave_num)

	return buff_name, nil
end

MissionBuffsSelector._restore_legendary_buff_to_players_pool = function (self, player, buff_name, restore_data)
	self._mission_buffs_handler:restore_unselected_legendary_buffs_to_player_pool(player, {
		buff_name
	}, -1)
end

MissionBuffsSelector._pop_family_buff_for_choice_category = function (self, player, context)
	return self:_pop_family_buff_from_players_pool(player)
end

MissionBuffsSelector._pop_family_buff_from_players_pool = function (self, player)
	local mission_buffs_handler = self._mission_buffs_handler
	local player_has_family_selected = mission_buffs_handler:does_player_have_family_selected(player)

	if not player_has_family_selected then
		Log.error("MissionBuffsSelector", string.format("Tried to pop a family buff for a player with no family selected (PeerID %s)", player:peer_id()))

		return nil
	end

	local priority_buffs_available, family_buffs_available = mission_buffs_handler:get_family_buffs_available_for_player(player)
	local use_priority_pool = #priority_buffs_available > 0
	local target_buff_pool = use_priority_pool and priority_buffs_available or family_buffs_available
	local num_buffs = #target_buff_pool

	if num_buffs <= 0 then
		return nil
	end

	local random_buff_index = math.random(num_buffs)
	local random_buff_name = target_buff_pool[random_buff_index]

	table.remove(target_buff_pool, random_buff_index)

	return random_buff_name, {
		is_priority_buff = use_priority_pool
	}
end

MissionBuffsSelector._evict_buff_from_family_pools = function (self, player, buff_name)
	local priority_buffs_available, family_buffs_available = self._mission_buffs_handler:get_family_buff_pools_for_player(player)

	for _, target_buff_pool in ipairs({
		priority_buffs_available,
		family_buffs_available
	}) do
		for i = #target_buff_pool, 1, -1 do
			if target_buff_pool[i] == buff_name then
				table.remove(target_buff_pool, i)
			end
		end
	end
end

MissionBuffsSelector._pop_basic_buff_for_choice_category = function (self, player, context)
	return self:_pop_basic_buff_from_players_pool(player)
end

MissionBuffsSelector._pop_basic_buff_from_players_pool = function (self, player)
	local candidate_buffs = self:_get_basic_buff_candidates_for_player(player)
	local num_candidates = #candidate_buffs

	if num_candidates <= 0 then
		Log.error("MissionBuffsSelector", string.format("No basic buffs left to draw for player (PeerID %s). Every family buff is either excluded or already given.", player:peer_id()))

		return nil
	end

	local random_buff_name = candidate_buffs[math.random(num_candidates)]

	self:_reserve_basic_buff_for_player(player, random_buff_name)

	return random_buff_name, nil
end

MissionBuffsSelector._restore_basic_buff_to_players_pool = function (self, player, buff_name, restore_data)
	self:_release_basic_buff_for_player(player, buff_name)
end

MissionBuffsSelector._on_basic_buff_granted_to_player = function (self, player, buff_name, restore_data)
	self:_release_basic_buff_for_player(player, buff_name)
	self:_evict_buff_from_family_pools(player, buff_name)
end

MissionBuffsSelector._get_basic_buff_candidates_for_player = function (self, player)
	local mission_buffs_handler = self._mission_buffs_handler
	local buffs_to_exclude = self._mission_buffs_manager:get_buffs_to_exclude() or {}
	local reserved_buffs = self:_get_reserved_basic_buffs_for_player(player)
	local all_family_buffs = self:_get_all_family_buffs()
	local candidate_buffs = {}

	for i = 1, #all_family_buffs do
		local buff_name = all_family_buffs[i]
		local is_excluded = buffs_to_exclude[buff_name] and true or false
		local is_reserved = reserved_buffs[buff_name] and true or false
		local is_already_given = mission_buffs_handler:does_player_have_buff_saved(player, buff_name)

		if not is_excluded and not is_reserved and not is_already_given then
			candidate_buffs[#candidate_buffs + 1] = buff_name
		end
	end

	return candidate_buffs
end

MissionBuffsSelector._get_all_family_buffs = function (self)
	if self._all_family_buffs then
		return self._all_family_buffs
	end

	local all_family_buffs = {}
	local buffs_added = {}
	local available_family_builds = AllowedBuffs.available_family_builds

	for i = 1, #available_family_builds do
		local family_name = available_family_builds[i]
		local family_build = AllowedBuffs.buff_families[family_name]

		if not family_build then
			Log.error("MissionBuffsSelector", "Family build [%s] is listed in available_family_builds but missing from buff_families. Skipped for basic buffs.", family_name)
		else
			for _, buff_pool in ipairs({
				family_build.priority_buffs,
				family_build.buffs
			}) do
				for _, buff_name in ipairs(buff_pool or {}) do
					if not buffs_added[buff_name] then
						buffs_added[buff_name] = true
						all_family_buffs[#all_family_buffs + 1] = buff_name
					end
				end
			end
		end
	end

	self._all_family_buffs = all_family_buffs

	return all_family_buffs
end

MissionBuffsSelector._get_reserved_basic_buffs_for_player = function (self, player)
	local player_key = self._get_player_key(player)
	local reserved_buffs = self._reserved_basic_buffs_by_player[player_key]

	if not reserved_buffs then
		reserved_buffs = {}
		self._reserved_basic_buffs_by_player[player_key] = reserved_buffs
	end

	return reserved_buffs
end

MissionBuffsSelector._reserve_basic_buff_for_player = function (self, player, buff_name)
	local reserved_buffs = self:_get_reserved_basic_buffs_for_player(player)

	reserved_buffs[buff_name] = true
end

MissionBuffsSelector._release_basic_buff_for_player = function (self, player, buff_name)
	local reserved_buffs = self:_get_reserved_basic_buffs_for_player(player)

	reserved_buffs[buff_name] = nil
end

MissionBuffsSelector._restore_family_buff_to_players_pool = function (self, player, buff_name, restore_data)
	local priority_buffs_available, family_buffs_available = self._mission_buffs_handler:get_family_buff_pools_for_player(player)
	local is_priority_buff = restore_data and restore_data.is_priority_buff
	local target_buff_pool = is_priority_buff and priority_buffs_available or family_buffs_available

	table.insert(target_buff_pool, buff_name)
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
		self:_resolve_composed_choice(player, selected_choice_name)
		self._mission_buffs_handler:give_buff_to_player(player, selected_choice_name, true)
	end
end

MissionBuffsSelector.set_buff_family_for_player = function (self, player, buff_family_name, from_choice)
	Log.info("MissionBuffsSelector", "Setting Buff Family %s to player (peer_id: %s)", buff_family_name, player:peer_id())

	local family_build = AllowedBuffs.buff_families[buff_family_name]

	self._mission_buffs_handler:set_buff_family_for_player(player, buff_family_name, family_build.priority_buffs, family_build.buffs, from_choice)
end

MissionBuffsSelector.try_start_new_buff_choice_for_player = function (self, player)
	local player_key = self._get_player_key(player)

	if self._is_starting_choice_for_player[player_key] then
		return
	end

	self._is_starting_choice_for_player[player_key] = true

	for _ = 1, MAX_AUTO_GRANTED_CHOICES_PER_PASS do
		local new_choice = self._mission_buffs_handler:try_start_new_choice_for_player(player)

		if not new_choice then
			self._is_starting_choice_for_player[player_key] = nil

			return
		end

		local num_options = #new_choice.options

		if num_options ~= 1 then
			self._mission_buffs_manager:send_choice_options_to_player(player, new_choice)

			self._is_starting_choice_for_player[player_key] = nil

			return
		end

		local was_granted = self:_auto_grant_single_option_choice(player)

		if not was_granted then
			self._is_starting_choice_for_player[player_key] = nil

			return
		end
	end

	self._is_starting_choice_for_player[player_key] = nil

	Log.error("MissionBuffsSelector", string.format("Stopped auto granting single option choices for player (PeerID %s) after %d in a row. The rest stay queued.", player:peer_id(), MAX_AUTO_GRANTED_CHOICES_PER_PASS))
end

MissionBuffsSelector._auto_grant_single_option_choice = function (self, player)
	local selected_choice_name, is_buff_family_choice = self._mission_buffs_handler:try_resolve_current_choice_for_player(player, 1)

	if not selected_choice_name then
		Log.error("MissionBuffsSelector", string.format("Tried to auto grant a single option choice that could not be resolved (PeerID %s)", player:peer_id()))

		return false
	end

	Log.info("MissionBuffsSelector", "Single option choice auto granted to player (PeerID: %s): %s", player:peer_id(), selected_choice_name)

	if is_buff_family_choice then
		local from_choice = false

		self:set_buff_family_for_player(player, selected_choice_name, from_choice)
		self:give_family_buff_to_player(player)
		self._mission_buffs_manager:check_catchup_for_new_player(player)
		self._mission_buffs_handler:check_if_all_players_chosen_family()
	else
		self:_resolve_composed_choice(player, selected_choice_name)

		local skip_notification = false

		self._mission_buffs_handler:give_buff_to_player(player, selected_choice_name, skip_notification)
	end

	return true
end

MissionBuffsSelector.rpc_server_mission_buffs_player_buff_choice = function (self, channel_id, local_player_id, choice_index)
	local peer_id = Network.peer_id(channel_id)
	local target_player = Managers.player:player(peer_id, local_player_id)

	if target_player == nil then
		Log.exception("MissionBuffsSelector", "Could not find target player (peerID: %s) for buff choice %i", peer_id, choice_index)

		return
	end

	self:player_selected_buff_choice(target_player, choice_index)
	self:try_start_new_buff_choice_for_player(target_player)
end

return MissionBuffsSelector
