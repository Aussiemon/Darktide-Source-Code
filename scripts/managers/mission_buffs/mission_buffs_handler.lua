-- chunkname: @scripts/managers/mission_buffs/mission_buffs_handler.lua

local FixedFrame = require("scripts/utilities/fixed_frame")
local MissionBuffsPersistentData = require("scripts/managers/mission_buffs/mission_buffs_persistent_data")
local MissionBuffsHandler = class("MissionBuffsHandler")

MissionBuffsHandler.init = function (self, mission_buffs_manager, game_mode, is_server)
	self._game_mode = game_mode
	self._mission_buffs_manager = mission_buffs_manager
	self._persistent_data = MissionBuffsPersistentData:new()
end

MissionBuffsHandler.destroy = function (self)
	self._game_mode = nil
	self._mission_buffs_manager = nil

	self._persistent_data:destroy()

	self._persistent_data = nil
end

MissionBuffsHandler.does_player_have_existing_data = function (self, player)
	return self._persistent_data:does_player_have_existing_data(player)
end

MissionBuffsHandler.does_player_have_legendary_buffs_pool = function (self, player)
	return self._persistent_data:does_player_have_legendary_buffs_pool(player)
end

MissionBuffsHandler.check_player_buff_family_state = function (self, player)
	return self._persistent_data:check_player_buff_family_state(player)
end

MissionBuffsHandler.get_buff_family_selected_by_player = function (self, player)
	return self._persistent_data:get_buff_family_selected_by_player(player)
end

MissionBuffsHandler.get_num_buffs_given_to_player = function (self, player)
	return self._persistent_data:get_num_buffs_given_to_player(player)
end

MissionBuffsHandler.get_num_legendary_buff_choices_pending_for_player = function (self, player)
	return self._persistent_data:get_num_legendary_buff_choices_pending_for_player(player)
end

MissionBuffsHandler.does_player_have_buff_saved = function (self, player, buff_name)
	return self._persistent_data:does_player_have_buff_saved(player, buff_name)
end

MissionBuffsHandler.save_buff_family_choice_for_player = function (self, player, family_name_choices)
	self._persistent_data:add_choice_for_player(player, family_name_choices, true)
end

MissionBuffsHandler.save_buff_choice_for_player = function (self, player, buff_name_choices)
	self._persistent_data:add_choice_for_player(player, buff_name_choices, false)
end

MissionBuffsHandler.restore_unselected_legendary_buffs_to_player_pool = function (self, player, buff_options, chosen_option_index)
	self._persistent_data:restore_unselected_legendary_buffs_to_player_pool(player, buff_options, chosen_option_index)
end

MissionBuffsHandler.try_resolve_current_choice_for_player = function (self, player, choice_index)
	return self._persistent_data:try_resolve_current_choice_for_player(player, choice_index)
end

MissionBuffsHandler.try_start_new_choice_for_player = function (self, player)
	return self._persistent_data:try_start_new_choice_for_player(player)
end

MissionBuffsHandler.get_current_choice_for_player = function (self, player)
	return self._persistent_data:get_current_choice_for_player(player)
end

MissionBuffsHandler.restore_buffs_given_to_player = function (self, player)
	local buffs_to_restore = self._persistent_data:get_buffs_given_to_player(player)

	for buff_name, buff_data in pairs(buffs_to_restore) do
		table.clear_array(buff_data.buff_indexes, #buff_data.buff_indexes)

		local num_stacks = buff_data.stacks

		for i = 1, num_stacks do
			self:give_buff_to_player(player, buff_name, true, true)
		end
	end
end

MissionBuffsHandler.give_buff_to_all = function (self, buff_name)
	local players = Managers.player:human_players()

	for _, player in pairs(players) do
		self:give_buff_to_player(player, buff_name)
	end
end

MissionBuffsHandler.give_buff_to_player = function (self, player, buff_name, skip_notification, skip_saving_buff_in_player_data)
	local player_unit = player.player_unit
	local is_human = player:is_human_controlled()

	if is_human then
		local save_to_player_data = not skip_saving_buff_in_player_data

		if save_to_player_data then
			self._persistent_data:save_buff_for_player(player, buff_name)
		end

		if not skip_notification then
			self._mission_buffs_manager:notify_buff_given_to_player(player, buff_name)
		end

		local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

		if ALIVE[player_unit] and buff_extension then
			Log.info("MissionBuffsSelector", "Giving %s to player (peer_id: %s)", buff_name, player:peer_id())

			local current_time = FixedFrame.get_latest_fixed_time()
			local _, buff_index, _ = buff_extension:add_externally_controlled_buff(buff_name, current_time)

			if buff_index ~= nil then
				if save_to_player_data then
					self._persistent_data:save_buff_index_for_player(player, buff_name, buff_index)
				end
			else
				Log.exception("MissionBuffsHandler", "Could not give buff (%s) to player unit. PeerID: %s | AccountID: %s", buff_name, player:peer_id(), player:account_id())
			end
		else
			Log.exception("MissionBuffsHandler", "Tried adding buff to player unit without a buff_extension. Buff: %s | PeerID: %s | AccountID: %s", buff_name, player:peer_id(), player:account_id())
		end
	end
end

MissionBuffsHandler.set_legendary_buffs_available_for_player = function (self, player, legendary_buffs)
	self._persistent_data:set_legendary_buffs_available_for_player(player, legendary_buffs)
end

MissionBuffsHandler.get_legendary_buffs_available_for_player = function (self, player)
	return self._persistent_data:get_legendary_buffs_available_for_player(player)
end

MissionBuffsHandler.buff_family_choice_initiated = function (self)
	self._persistent_data:buff_family_choice_initiated()
end

MissionBuffsHandler.set_buff_family_for_player = function (self, player, family_name, priotity_family_buffs, family_buffs, from_choice)
	local buffs_to_exclude = self._mission_buffs_manager:get_buffs_to_exclude()

	self._persistent_data:set_buff_family_for_player(player, family_name, priotity_family_buffs, family_buffs, buffs_to_exclude)
	self._mission_buffs_manager:_notify_buff_family_given_to_player(player, family_name, from_choice)
end

MissionBuffsHandler.check_if_all_players_chosen_family = function (self)
	local all_players_have_chosen_family = self._persistent_data:have_all_players_chosen_family()

	if all_players_have_chosen_family then
		self._game_mode:can_start_wave_one()
	else
		self._game_mode:wait_for_players_to_choose_family()
	end
end

MissionBuffsHandler.does_player_have_family_selected = function (self, player)
	return self._persistent_data:does_player_have_family_selected(player)
end

MissionBuffsHandler.get_family_buffs_available_for_player = function (self, player)
	local priority_buffs_available = self._persistent_data:get_player_priority_family_buffs_available(player)
	local family_buffs_available = self._persistent_data:get_player_family_buffs_available(player)

	if not (#priority_buffs_available > 0) and not (#family_buffs_available > 0) then
		Log.error("MissionBuffsHandler", string.format("[MissionBuffsHandler] Player (PeerID: %s | AccountID: %s) does not have family buffs left.", player:peer_id(), player:account_id()))
	end

	return priority_buffs_available, family_buffs_available
end

MissionBuffsHandler.log_player_data = function (self, player)
	self._persistent_data:log_player_data(player)
end

return MissionBuffsHandler
