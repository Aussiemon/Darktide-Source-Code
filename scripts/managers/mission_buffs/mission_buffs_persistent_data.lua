-- chunkname: @scripts/managers/mission_buffs/mission_buffs_persistent_data.lua

local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local MissionBuffsPersistentData = class("MissionBuffsPersistentData")

MissionBuffsPersistentData.init = function (self)
	self._persistent_data = {
		should_have_buff_family_selected = false,
		players_data = {},
	}
end

MissionBuffsPersistentData.destroy = function (self)
	self._persistent_data = nil
end

MissionBuffsPersistentData.init_player_data = function (self, player)
	local persistent_data = self._persistent_data
	local players_data = persistent_data.players_data
	local player_account_id = player:account_id()

	players_data[player_account_id] = {
		num_family_buffs_received = 0,
		num_legendary_buffs_received = 0,
		account_id = player_account_id,
		priority_family_buffs_available = {},
		family_buffs_available = {},
		legendary_buffs_available = {},
		buffs_received = {},
		choices_queue = {},
	}

	return players_data[player_account_id]
end

MissionBuffsPersistentData.does_player_have_existing_data = function (self, player)
	local persistent_data = self._persistent_data
	local players_data = persistent_data.players_data
	local player_account_id = player:account_id()

	return players_data[player_account_id] ~= nil
end

MissionBuffsPersistentData.check_player_buff_family_state = function (self, player)
	local persistent_data = self._persistent_data
	local should_have_family_selected = persistent_data.should_have_buff_family_selected
	local player_data = self:_get_player_data(player)

	if player_data == nil then
		return should_have_family_selected, false
	end

	local has_family_choice_pending = player_data.current_choice and player_data.current_choice.is_buff_family_choice or false
	local needs_buff_family = should_have_family_selected and player_data.buff_family_chosen == nil

	return needs_buff_family, has_family_choice_pending
end

MissionBuffsPersistentData.get_buff_family_selected_by_player = function (self, player)
	local player_data = self:_get_player_data(player)

	return player_data and player_data.buff_family_chosen or nil
end

MissionBuffsPersistentData.get_buffs_given_to_player = function (self, player)
	local player_data = self:_get_or_create_player_data(player)

	return player_data.buffs_received
end

MissionBuffsPersistentData.get_num_buffs_given_to_player = function (self, player)
	local target_player_data = self:_get_player_data(player)

	if not target_player_data then
		return 0, 0
	end

	local num_family_buffs_received = target_player_data.num_family_buffs_received
	local num_legendary_buffs_received = target_player_data.num_legendary_buffs_received

	return num_family_buffs_received, num_legendary_buffs_received
end

MissionBuffsPersistentData.get_num_legendary_buff_choices_pending_for_player = function (self, player)
	local target_player_data = self:_get_player_data(player)

	if not target_player_data then
		return 0
	end

	local current_choice = target_player_data.current_choice
	local pending_legendary_choices = current_choice and not current_choice.is_buff_family_choice and 1 or 0
	local queued_choices = target_player_data.choices_queue

	for _, choice in ipairs(queued_choices) do
		local is_legendary_choice = not choice.is_buff_family_choice

		pending_legendary_choices = pending_legendary_choices + (is_legendary_choice and 1 or 0)
	end

	return pending_legendary_choices
end

MissionBuffsPersistentData._get_player_data = function (self, player)
	local persistent_data = self._persistent_data
	local players_data = persistent_data.players_data
	local player_account_id = player:account_id()

	return players_data[player_account_id]
end

MissionBuffsPersistentData._get_or_create_player_data = function (self, player)
	local persistent_data = self._persistent_data
	local players_data = persistent_data.players_data
	local player_account_id = player:account_id()

	return players_data[player_account_id] ~= nil and players_data[player_account_id] or self:init_player_data(player)
end

MissionBuffsPersistentData._add_buff_to_player_data = function (self, player, buff_name)
	local target_player_data = self:_get_or_create_player_data(player)
	local player_buffs = target_player_data.buffs_received
	local existing_buff_data = player_buffs[buff_name]

	if not existing_buff_data then
		player_buffs[buff_name] = {
			stacks = 1,
			buff_name = buff_name,
			buff_indexes = {},
		}

		local is_family_buff = HordesBuffsData[buff_name].is_family_buff

		if is_family_buff then
			target_player_data.num_family_buffs_received = target_player_data.num_family_buffs_received + 1
		else
			target_player_data.num_legendary_buffs_received = target_player_data.num_legendary_buffs_received + 1
		end
	else
		existing_buff_data.stacks = existing_buff_data.stacks + 1
	end
end

MissionBuffsPersistentData._add_buff_index_to_player_data = function (self, player, buff_name, buff_index)
	local target_player_data = self:_get_or_create_player_data(player)
	local player_buffs = target_player_data.buffs_received
	local target_buff = player_buffs[buff_name]

	if target_buff then
		table.insert(target_buff.buff_indexes, buff_index)
	end
end

MissionBuffsPersistentData.set_legendary_buffs_available_for_player = function (self, player, legendary_buffs)
	local target_player_data = self:_get_or_create_player_data(player)

	target_player_data.legendary_buffs_available = legendary_buffs
end

MissionBuffsPersistentData.get_legendary_buffs_available_for_player = function (self, player)
	local target_player_data = self:_get_or_create_player_data(player)

	return target_player_data.legendary_buffs_available
end

MissionBuffsPersistentData.buff_family_choice_initiated = function (self)
	self._persistent_data.should_have_buff_family_selected = true
end

MissionBuffsPersistentData.set_buff_family_for_player = function (self, player, buff_family_name, priotity_family_buffs, family_buffs, buffs_to_exclude)
	local target_player_data = self:_get_or_create_player_data(player)

	target_player_data.buff_family_chosen = buff_family_name

	for _, buff_name in ipairs(priotity_family_buffs) do
		if not buffs_to_exclude[buff_name] then
			table.insert(target_player_data.priority_family_buffs_available, buff_name)
		else
			Log.info("MissionBuffsSelector", "Family Buff excluded %s from priority pool", buff_name)
		end
	end

	for _, buff_name in ipairs(family_buffs) do
		if not buffs_to_exclude[buff_name] then
			table.insert(target_player_data.family_buffs_available, buff_name)
		else
			Log.info("MissionBuffsSelector", "Family Buff excluded %s from regular pool", buff_name)
		end
	end
end

MissionBuffsPersistentData.does_player_have_family_selected = function (self, player)
	local player_data = self:_get_player_data(player)

	return player_data and player_data.buff_family_chosen ~= nil
end

MissionBuffsPersistentData.have_all_players_chosen_family = function (self)
	local players = Managers.player:human_players()

	for _, player in pairs(players) do
		local is_alive = player:unit_is_alive()
		local needs_buff_family, _ = self:check_player_buff_family_state(player)

		if is_alive and needs_buff_family then
			return false
		end
	end

	return true
end

MissionBuffsPersistentData.get_player_priority_family_buffs_available = function (self, player)
	local target_player_data = self:_get_or_create_player_data(player)

	return target_player_data.priority_family_buffs_available
end

MissionBuffsPersistentData.get_player_family_buffs_available = function (self, player)
	local target_player_data = self:_get_or_create_player_data(player)

	return target_player_data.family_buffs_available
end

MissionBuffsPersistentData.save_buff_for_player = function (self, player, buff_name)
	self:_add_buff_to_player_data(player, buff_name)
end

MissionBuffsPersistentData.save_buff_index_for_player = function (self, player, buff_name, buff_index)
	self:_add_buff_index_to_player_data(player, buff_name, buff_index)
end

MissionBuffsPersistentData.save_player_buffs = function (self, player, buffs)
	return
end

MissionBuffsPersistentData.get_player_buffs = function (self, player)
	return
end

MissionBuffsPersistentData.does_player_have_buff_saved = function (self, player, buff_name)
	local target_player_data = self:_get_player_data(player)

	if not target_player_data then
		return false
	end

	local player_buffs = target_player_data.buffs_received

	return player_buffs[buff_name] ~= nil
end

MissionBuffsPersistentData.get_current_choice_for_player = function (self, player)
	local target_player_data = self:_get_or_create_player_data(player)

	return target_player_data.current_choice
end

MissionBuffsPersistentData.add_choice_for_player = function (self, player, options, is_buff_family_choice)
	local target_player_data = self:_get_or_create_player_data(player)
	local new_choice = {
		is_buff_family_choice = is_buff_family_choice and true or false,
		options = options,
	}

	table.insert(target_player_data.choices_queue, new_choice)
end

MissionBuffsPersistentData.try_start_new_choice_for_player = function (self, player)
	local target_player_data = self:_get_or_create_player_data(player)
	local current_choice = target_player_data.current_choice

	if current_choice then
		return current_choice
	end

	local choices_queue = target_player_data.choices_queue
	local choices_in_queue = #choices_queue

	if choices_in_queue == 0 then
		return false
	end

	local next_choice = choices_queue[1]

	table.remove(choices_queue, 1)

	target_player_data.current_choice = next_choice

	return next_choice
end

MissionBuffsPersistentData.try_resolve_current_choice_for_player = function (self, player, choice_index)
	local target_player_data = self:_get_or_create_player_data(player)
	local has_active_choice = target_player_data.current_choice ~= nil

	if not has_active_choice then
		return false, false
	end

	local current_choice = target_player_data.current_choice
	local choice_options = current_choice.options
	local num_choices = #choice_options
	local clamped_index = math.clamp(choice_index, 1, num_choices)
	local selected_choice_name = choice_options[clamped_index]
	local is_buff_family_choice = current_choice.is_buff_family_choice

	if not is_buff_family_choice then
		self:restore_unselected_legendary_buffs_to_player_pool(player, choice_options, clamped_index)
	end

	target_player_data.current_choice = nil

	return selected_choice_name, is_buff_family_choice
end

MissionBuffsPersistentData.restore_unselected_legendary_buffs_to_player_pool = function (self, player, buff_options, chosen_option_index)
	local target_player_data = self:_get_or_create_player_data(player)

	for i = 1, #buff_options do
		if i ~= chosen_option_index then
			local buff_name = buff_options[i]
			local buff_data = HordesBuffsData[buff_name]
			local buff_filter_category = buff_data.filter_category
			local target_pool = target_player_data.legendary_buffs_available[buff_filter_category]

			table.insert(target_pool, buff_name)
		end
	end
end

return MissionBuffsPersistentData
