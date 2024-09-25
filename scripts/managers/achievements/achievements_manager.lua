﻿-- chunkname: @scripts/managers/achievements/achievements_manager.lua

local AchievementDefinitions = require("scripts/managers/achievements/achievement_definitions")
local AchievementFlags = require("scripts/settings/achievements/achievement_flags")
local AchievementPlatforms = require("scripts/managers/achievements/achievement_platforms")
local AchievementTypes = require("scripts/managers/achievements/achievement_types")
local AchievementUIHelper = require("scripts/managers/achievements/utility/achievement_ui_helper")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local TextUtilities = require("scripts/utilities/ui/text")
local AchievementsManager = class("AchievementsManager")
local CLIENT_RPCS = {
	"rpc_unlock_achievement",
	"rpc_ally_unlocked_achievement",
}
local PlayerStates = table.enum("loading", "ready")
local RewardClaimStates = table.enum("idle", "pending", "active", "deactive")

AchievementsManager.player_states = PlayerStates

AchievementsManager.init = function (self, is_client, event_delegate, use_batched_saving, broadcast_unlocks)
	self._definitions = nil
	self._definitions = GameParameters.testify and {} or nil
	self._initialized = false
	self._is_host = not is_client
	self._is_client = is_client
	self._event_delegate = event_delegate
	self._use_batched_saving = use_batched_saving
	self._players = {}
	self._players_by_listener_id = {}
	self._saving_promises = {}
	self._saving_accounts = {}
	self._triggers = {}

	for achievement_type, trigger_data in pairs(AchievementTypes) do
		self._triggers[achievement_type] = trigger_data.trigger
	end

	self._broadcast_unlocks = not not broadcast_unlocks

	if is_client then
		self._event_delegate:register_connection_events(self, unpack(CLIENT_RPCS))

		self._penance_claim_status = RewardClaimStates.idle
		self._track_claim_status = RewardClaimStates.idle

		Managers.event:register(self, "event_update_reward_claim_state", "update_reward_claim_state")
		Managers.event:register(self, "backend_achievement_complete", "_backend_achievement_complete")
		Managers.event:register(self, "backend_statistic_update", "_backend_achievement_progress")
	end
end

AchievementsManager.destroy = function (self)
	for _, player_data in pairs(self._players) do
		if player_data.promise then
			player_data.promise:cancel()
		end

		if player_data.save_promise then
			player_data.save_promise:cancel()
		end
	end

	for _, promise in ipairs(self._saving_promises) do
		promise:cancel()
	end

	if self._is_client then
		self._event_delegate:unregister_events(unpack(CLIENT_RPCS))
		Managers.event:unregister(self, "event_update_reward_claim_state")
		Managers.event:unregister(self, "backend_achievement_complete")
		Managers.event:unregister(self, "backend_statistic_update")
	end
end

AchievementsManager._setup_achievements = function (self, backend_data)
	self._initialized = true

	local definitions = table.clone(AchievementDefinitions)

	self._definitions = definitions

	local achievement_lookup = {}

	self._achievement_lookup = achievement_lookup

	for _, definition in pairs(definitions) do
		achievement_lookup[definition.index] = definition.id
		definition.score = 0
	end

	local backend_achievements = backend_data.commendations

	for i = 1, #backend_achievements do
		local backend_achievement = backend_achievements[i]
		local achievement_id = backend_achievement.id
		local definition = definitions[achievement_id]

		if definition then
			definition.score = backend_achievement.score
			definition.rewards = backend_achievement.rewards

			if backend_achievement.allowSolo then
				definition.flags[AchievementFlags.allow_solo] = true
			end
		end
	end
end

AchievementsManager.achievement_definition = function (self, achievement_id)
	return self._definitions[achievement_id]
end

AchievementsManager.achievement_definitions = function (self)
	return self._definitions
end

AchievementsManager._achievement_completed = function (self, player_id, achievement_id)
	local player_data = self._players[player_id]
	local completed = player_data.completed
	local completed_at = player_data.completed_at

	return completed[achievement_id], completed_at[achievement_id]
end

AchievementsManager.achievement_completed = function (self, player, achievement_id)
	local player_id = player.remote and player.stat_id or player:local_player_id()

	return self:_achievement_completed(player_id, achievement_id)
end

local function _add_one(root_table, key, to_add)
	local t = root_table[key] or {}

	t[#t + 1] = to_add
	root_table[key] = t
end

AchievementsManager._track_achievements = function (self, player_id)
	local player_data = self._players[player_id]
	local definitions = self._definitions
	local scratchpad = {}

	player_data.scratchpad = scratchpad

	local achievements_by_stat_name = {}

	player_data.achievements_by_stat_name = achievements_by_stat_name

	local achievements_by_achievement_id = {}

	player_data.achievements_by_achievement_id = achievements_by_achievement_id

	local completed = player_data.completed
	local should_unlock = {}

	for _, achievement in pairs(definitions) do
		local achievement_id = achievement.id
		local achievement_type = AchievementTypes[achievement.type]
		local setup_function = achievement_type.setup
		local is_complete = completed[achievement_id]
		local should_track = achievement.flags[AchievementFlags.allow_solo] or DEDICATED_SERVER

		if should_track and not is_complete then
			local already_done = setup_function(achievement, scratchpad, player_id)

			if already_done then
				should_unlock[#should_unlock + 1] = achievement_id
			elseif achievement_type.trigger_type == "stat" or achievement_type.trigger_type == "meta" then
				local base_table = achievement_type.trigger_type == "stat" and achievements_by_stat_name or achievements_by_achievement_id
				local triggers = achievement_type.get_triggers(achievement)

				if type(triggers) == "table" then
					for trigger, _ in pairs(triggers) do
						_add_one(base_table, trigger, achievement_id)
					end
				else
					_add_one(base_table, triggers, achievement_id)
				end
			end
		end
	end

	for _, achievement_id in ipairs(should_unlock) do
		if not self:_achievement_completed(player_id, achievement_id) then
			self:_unlock_achievement(player_id, achievement_id, true)
		end
	end

	local stat_count, stat_names = 0, {}

	for stat_name, _ in pairs(achievements_by_stat_name) do
		stat_count = stat_count + 1
		stat_names[stat_count] = stat_name
	end

	if stat_count > 0 then
		local listener_id = Managers.stats:add_listener(player_id, stat_names, callback(self, "_on_stat_trigger"))

		self._players_by_listener_id[listener_id] = player_data
		player_data.listener_id = listener_id
	end
end

local function _remove_one(root_table, key, to_remove)
	local t = root_table[key]
	local index_to_remove = table.index_of(t, to_remove)

	table.swap_delete(t, index_to_remove)
end

AchievementsManager._untrack_achievement = function (self, player_id, achievement_id)
	local achievement = self._definitions[achievement_id]
	local achievement_type = AchievementTypes[achievement.type]

	if achievement_type.trigger_type ~= "stat" and achievement_type.trigger_type ~= "meta" then
		return
	end

	local player_data = self._players[player_id]
	local base_table = achievement_type.trigger_type == "stat" and player_data.achievements_by_stat_name or player_data.achievements_by_achievement_id
	local triggers = achievement_type.get_triggers(achievement)

	if type(triggers) == "table" then
		for trigger, _ in pairs(triggers) do
			_remove_one(base_table, trigger, achievement_id)
		end
	else
		_remove_one(base_table, triggers, achievement_id)
	end
end

AchievementsManager._untrack_achievements = function (self, player_id)
	local player_data = self._players[player_id]
	local listener_id = player_data.listener_id

	if listener_id then
		player_data.listener_id = nil
		self._players_by_listener_id[listener_id] = nil

		Managers.stats:remove_listener(listener_id)
	end

	player_data.scratchpad = nil
	player_data.achievements_by_stat_name = nil
	player_data.achievements_by_achievement_id = nil
end

AchievementsManager._setup_platform = function (self)
	local definitions = self._definitions

	if self._platform_promise then
		return self._platform_promise:next(function ()
			return
		end, function ()
			return
		end)
	end

	local auth_method = Managers.backend:get_auth_method()
	local platform, platform_promise = AchievementPlatforms[auth_method]:new(definitions)

	self._platform_promise = platform_promise

	return platform_promise:next(function ()
		self._platform = platform
		self._platform_promise = nil

		local player = Managers.player:local_player(1)

		for achievement_id, achievement_definition in pairs(definitions) do
			if platform:is_platform_achievement(achievement_definition) then
				local is_backend_complete = self:_achievement_completed(1, achievement_id)
				local is_platform_complete = platform:is_unlocked(achievement_definition)

				if is_backend_complete and not is_platform_complete then
					platform:unlock(achievement_definition)
				end

				local achievement_type = AchievementTypes[achievement_definition.type]

				if not is_backend_complete and achievement_type.get_progress then
					local progress = achievement_type.get_progress(achievement_definition, player)

					platform:set_progress(achievement_definition, progress)
				end
			end
		end
	end, function ()
		Log.warning("AchievementsManager", "Failed to setup platform achievements for platform '%s'.", auth_method)

		self._platform_promise = nil
	end)
end

AchievementsManager.add_player = function (self, player)
	local player_id = player.remote and player.stat_id or player:local_player_id()
	local account_id = player:account_id(player)

	if not math.is_uuid(account_id) then
		return Promise.resolved(nil)
	end

	local player_data = {}

	self._players[player_id] = player_data
	player_data.id = player_id
	player_data.account_id = account_id
	player_data.state = PlayerStates.loading
	player_data.remote = player.remote
	player_data.peer_id = player:peer_id()
	player_data.local_player_id = player:local_player_id()

	if player_data.remote then
		player_data.channel_id = player:connection_channel_id()
	end

	player_data.completed_this_session = 0
	player_data.completed_at = {}
	player_data.completed = {}
	player_data.dirty = false
	player_data.saved = {}

	local index_of_save = table.index_of(self._saving_accounts, account_id)
	local backend_promise

	if index_of_save > 0 then
		backend_promise = self._saving_promises[index_of_save]:next(function ()
			return Managers.backend.interfaces.commendations:get_commendations(account_id, true, false)
		end, function ()
			return Managers.backend.interfaces.commendations:get_commendations(account_id, true, false)
		end)
	else
		backend_promise = Managers.backend.interfaces.commendations:get_commendations(account_id, true, false)
	end

	player_data.promise = backend_promise

	return backend_promise:next(function (backend_data)
		if not self._initialized then
			self:_setup_achievements(backend_data)
		end

		local definitions = self._definitions
		local backend_achievements = backend_data.commendations

		for _, backend_achievement in ipairs(backend_achievements) do
			local achievement_id = backend_achievement.id

			if not definitions[achievement_id] then
				Log.info("AchievementsManager", "Downloaded unknown achievement '%s' for player '%s' with account id '%s'.", achievement_id, player_id, account_id)
			elseif backend_achievement.complete then
				player_data.completed[achievement_id] = backend_achievement.complete
				player_data.saved[achievement_id] = backend_achievement.complete

				local completed_at = backend_achievement.at

				if type(completed_at) == "string" then
					player_data.completed_at[achievement_id] = completed_at
				end
			end
		end

		player_data.state = PlayerStates.ready
		player_data.promise = nil

		if self._is_host then
			self:_track_achievements(player_id)
		end

		local is_platform_player = self._is_client and player_id == 1

		if is_platform_player then
			return self:_setup_platform()
		else
			return Promise.resolved()
		end
	end, function (error)
		Log.error("AchievementsManager", "Failed to download achievements for player '%s'. Error: %s", player_id, table.tostring(error, 3))

		self._players[player_id] = nil

		return Promise.rejected(error)
	end)
end

AchievementsManager._get_player_diff = function (self, player_id)
	local player_data = self._players[player_id]
	local change_count, changes = 0, {}

	for achievement_name, _ in pairs(player_data.completed) do
		if not player_data.saved[achievement_name] then
			change_count = change_count + 1
			changes[change_count] = {
				complete = true,
				stat = "none",
				id = achievement_name,
			}
		end
	end

	if change_count > 0 then
		return {
			accountId = player_data.account_id,
			stats = {},
			completed = changes,
		}
	end
end

AchievementsManager._save_succeded = function (self, player_data, assumed_complete)
	if assumed_complete then
		Log.info("AchievementsManager", "Assuming achievements will save sucessfully for '%s'.", player_data.id)
	end

	local save_promise = player_data.save_promise

	player_data.save_promise = nil

	if save_promise:is_pending() then
		save_promise:cancel()
	end

	local achievements_in_air = player_data.achievements_in_air

	player_data.achievements_in_air = nil

	local message_client = player_data.remote and not self._use_batched_saving

	if not message_client then
		return
	end

	local player_id = player_data.id

	for i = 1, #achievements_in_air do
		local achievement_id = achievements_in_air[i]

		self:_advertise_unlocked_achievement(player_id, achievement_id)
	end
end

AchievementsManager._save_failed = function (self, player_data, ...)
	local player_id = player_data.id

	Log.warning("AchievementsManager", "Failed saving achievements for player '%s'.", player_id)

	local achievements_in_air = player_data.achievements_in_air

	player_data.achievements_in_air = nil

	for i = 1, #achievements_in_air do
		local achievement_id = achievements_in_air[i]

		player_data.saved[achievement_id] = false
	end

	local save_promise = player_data.save_promise

	player_data.save_promise = nil

	if save_promise:is_pending() then
		save_promise:cancel()
	end

	player_data.dirty = true

	return Promise.rejected(...)
end

AchievementsManager._save_player_diff = function (self, player_id)
	local changes = self:_get_player_diff(player_id)
	local player_data = self._players[player_id]

	if not changes then
		return player_data.save_promise or Promise.resolved(nil)
	end

	local completed = changes.completed

	player_data.dirty = false

	for i = 1, #completed do
		local achievement_id = completed[i].id

		player_data.saved[achievement_id] = true
	end

	local is_saving = player_data.save_promise ~= nil

	if is_saving then
		self:_save_succeded(player_id, true)
	end

	local backend_promise = Managers.backend.interfaces.commendations:bulk_update_commendations({
		changes,
	})

	player_data.save_promise = backend_promise
	player_data.achievements_in_air = table.map(completed, function (completed)
		return completed.id
	end)

	return backend_promise:next(callback(self, "_save_succeded", player_data, false), callback(self, "_save_failed", player_data))
end

AchievementsManager._player_is_dirty = function (self, player_id)
	local player_data = self._players[player_id]

	return player_data and player_data.dirty
end

AchievementsManager._update_dirty_player = function (self, player_id)
	local player_data = self._players[player_id]
	local is_ready = player_data.state == PlayerStates.ready

	if not is_ready then
		return
	end

	if self._use_batched_saving then
		return
	end

	local is_saving = player_data.save_promise

	if is_saving then
		return
	end

	local is_dirty = self:_player_is_dirty(player_id)

	if not is_dirty then
		return
	end

	self:_save_player_diff(player_id)
end

AchievementsManager.update = function (self, dt, t)
	for player_id, _ in pairs(self._players) do
		self:_update_dirty_player(player_id)
	end
end

AchievementsManager.has_player = function (self, player_id)
	return self._players[player_id] ~= nil
end

AchievementsManager._clear_platform = function (self)
	local platform_promise = self._platform_promise

	self._platform_promise = nil

	if platform_promise and platform_promise:is_pending() then
		platform_promise:cancel()
	end

	local platform = self._platform

	self._platform = nil

	if platform then
		platform:delete()
	end
end

AchievementsManager.remove_player = function (self, player_id)
	local player_data = self._players[player_id]
	local platform_player_removed = self._is_client and player_id == 1

	if platform_player_removed then
		self:_clear_platform()
	end

	if player_data.state == PlayerStates.loading then
		player_data.promise:cancel()

		self._players[player_id] = nil

		return Promise.resolved()
	end

	if self._is_host then
		self:_untrack_achievements(player_id)
	end

	local save_promise = self:_save_player_diff(player_id)

	if save_promise:is_pending() then
		local saving_accounts = self._saving_accounts
		local saving_promises = self._saving_promises

		saving_accounts[#saving_accounts + 1] = player_data.account_id
		saving_promises[#saving_promises + 1] = save_promise
		self._players[player_id] = nil

		return save_promise:next(function ()
			local index = table.index_of(saving_accounts, player_data.account_id)

			table.swap_delete(saving_accounts, index)
			table.swap_delete(saving_promises, index)
		end, function (error)
			Log.warning("AchievementsManager", "Failed to save achievements with error: %s", table.tostring(error, 3))

			local index = table.index_of(saving_accounts, player_data.account_id)

			table.swap_delete(saving_accounts, index)
			table.swap_delete(saving_promises, index)

			return Promise.rejected(error)
		end)
	end

	self._players[player_id] = nil

	return Promise.resolved()
end

AchievementsManager.remove_all = function (self)
	for player_id, _ in pairs(self._players) do
		self:remove_player(player_id)
	end

	return Promise.all(unpack(self._saving_promises))
end

AchievementsManager._became_host = function (self)
	for player_id, _ in pairs(self._players) do
		self:_track_achievenments(player_id)
	end
end

AchievementsManager._stopped_being_host = function (self)
	for player_id, _ in pairs(self._players) do
		self:_untrack_achievements(player_id)
	end
end

AchievementsManager.set_host = function (self, is_host)
	if self._is_host == is_host then
		return
	end

	self._is_host = is_host

	if is_host then
		self:_became_host()
	else
		self:_stopped_being_host()
	end
end

AchievementsManager._fetch_unclaimed_penance_rewards = function (self)
	local backend_interface = Managers.backend.interfaces
	local player_rewards = backend_interface.player_rewards
	local promise = player_rewards:get_rewards_by_source_paged(1, "commendation"):next(function (data)
		local items = data.items

		if items and #items > 0 then
			return true
		end

		return false
	end):catch(function (error)
		local error_string = tostring(error)

		Log.error("AchievementsManager", "Error fetching penance reward: %s", error_string)

		return {}
	end)

	return promise:next(function (data)
		return data
	end)
end

local PENANCE_TRACK_ID = "dec942ce-b6ba-439c-95e2-022c5d71394d"

AchievementsManager._fetch_penance_track_account_state = function (self)
	local backend_interface = Managers.backend.interfaces
	local penance_track = backend_interface.tracks
	local promises = {
		penance_track:get_track_state(PENANCE_TRACK_ID),
		penance_track:get_track(PENANCE_TRACK_ID),
	}

	return Promise.all(unpack(promises)):next(function (responses)
		local track_state, track_data = unpack(responses)
		local state = track_state and track_state.state
		local total_tiers = #track_data.tiers

		if not state or not total_tiers then
			return false
		end

		local total_penance_points = state.xpTracked or 0
		local current_rewardable_tier = 1

		for i = total_tiers, 1, -1 do
			local needed_xp = track_data.tiers[i].xpLimit

			if needed_xp <= total_penance_points then
				current_rewardable_tier = i

				break
			end
		end

		local rewarded_tiers = state.rewarded + 1

		if rewarded_tiers < current_rewardable_tier then
			return true
		end

		return false
	end):catch(function (error)
		local error_string = tostring(error)

		Log.error("AchievementsManager", "Error fetching penance track for account: %s", error_string)

		return false
	end)
end

AchievementsManager.is_reward_to_claim = function (self)
	return self._penance_claim_status == RewardClaimStates.active or self._track_claim_status == RewardClaimStates.active
end

AchievementsManager.update_reward_claim_state = function (self)
	if not self._is_client then
		return
	end

	self._track_claim_status = RewardClaimStates.pending

	self:_fetch_penance_track_account_state():next(function (rewards_exist)
		self._track_claim_status = rewards_exist and RewardClaimStates.active or RewardClaimStates.deactive
	end)

	self._penance_claim_status = RewardClaimStates.pending

	self:_fetch_unclaimed_penance_rewards():next(function (rewards_exist)
		self._penance_claim_status = rewards_exist and RewardClaimStates.active or RewardClaimStates.deactive
	end)
end

AchievementsManager.deactive_reward_claim_state = function (self)
	self._penance_claim_status = RewardClaimStates.deactive
	self._track_claim_status = RewardClaimStates.deactive
end

AchievementsManager._backend_achievement_complete = function (self, achievement_id)
	self:_unlock_achievement(1, achievement_id, nil, true)

	self._penance_claim_status = RewardClaimStates.active
end

AchievementsManager._backend_achievement_progress = function (self, stat_name, value)
	Managers.stats:set_user_stat(stat_name, value)
end

local item_rewards = {}

AchievementsManager._show_item_rewards = function (self, rewards)
	table.clear(item_rewards)

	for i = 1, #rewards do
		local reward = rewards[i]

		if reward.rewardType == "item" then
			item_rewards[#item_rewards + 1] = reward.masterId
		end
	end

	if #item_rewards > 0 then
		Managers.data_service.gear:invalidate_gear_cache()

		for i = 1, #item_rewards do
			local master_id = item_rewards[i]

			if MasterItems.item_exists(master_id) then
				local rewarded_master_item = MasterItems.get_item(master_id)
				local sound_event = UISoundEvents.character_news_feed_new_item

				Managers.event:trigger("event_add_notification_message", "penance_item_can_be_claimed", rewarded_master_item, nil, sound_event)
			else
				Log.warning("AchievementManager", "Received invalid item %s as reward from backend.", master_id)
			end
		end
	end
end

AchievementsManager._advertise_unlocked_achievement = function (self, player_id, achievement_id)
	local player_data = self._players[player_id]
	local peer_id = Network.peer_id(player_data.channel_id)
	local local_player_id = player_data.local_player_id
	local achievement = self._definitions[achievement_id]
	local achievement_index = achievement.index
	local is_remote = player_data.remote

	if is_remote then
		RPC.rpc_unlock_achievement(player_data.channel_id, local_player_id, achievement_index)
	end

	local broadcast_unlocks = self._broadcast_unlocks

	if broadcast_unlocks then
		local seen_channels = {
			[player_data.channel_id] = true,
		}

		for _, _player_data in pairs(self._players) do
			local channel_id = _player_data.channel_id

			if not seen_channels[channel_id] then
				seen_channels[channel_id] = true

				RPC.rpc_ally_unlocked_achievement(channel_id, peer_id, local_player_id, achievement_index)
			end
		end
	end
end

AchievementsManager._unlock_achievement = function (self, player_id, achievement_id, never_tracked, remote_unlock)
	local player_data = self._players[player_id]

	player_data.completed[achievement_id] = true
	player_data.completed_at[achievement_id] = player_data.completed_this_session
	player_data.completed_this_session = player_data.completed_this_session + 1
	player_data.dirty = player_data.dirty or not remote_unlock

	if remote_unlock then
		player_data.saved[achievement_id] = true
	end

	local is_client = self._is_client

	if is_client and not player_data.remote then
		local achievement = self._definitions[achievement_id]
		local platform = self._platform

		if platform and platform:is_platform_achievement(achievement) then
			platform:unlock(achievement)
		end

		Managers.event:trigger("event_add_notification_message", "achievement", achievement)

		local rewards = achievement.rewards

		if rewards then
			self:_show_item_rewards(rewards)
		end

		local player = Managers.player:player(player_data.peer_id, player_data.local_player_id)

		if player then
			self:_show_unlock_in_chat(player, achievement_id)
		end
	end

	local is_host = self._is_host

	if is_host then
		if not never_tracked then
			self:_untrack_achievement(player_id, achievement_id)
		end

		local batched_saving = self._use_batched_saving

		if batched_saving then
			self:_advertise_unlocked_achievement(player_id, achievement_id)
		end

		self:_on_achievement_unlock(player_id, achievement_id)
	end
end

AchievementsManager.unlock_achievement = function (self, player, achievement_id, unlock_previous)
	local player_id = player.remote and player.stat_id or player:local_player_id()
	local player_data = self._players[player_id]

	if not player_data then
		Log.info("AchievementsManager", "Failed to unlock achievement '%s'. Player '%s' not added.", achievement_id, player_id)

		return false
	end

	if player_data.completed[achievement_id] then
		Log.info("AchievementsManager", "Failed to unlock achievement '%s'. Achievement is already unlocked.", achievement_id)

		return false
	end

	local achievement_definition = self._definitions[achievement_id]

	if not achievement_definition then
		Log.info("AchievementsManager", "Failed to unlock achievement '%s'. Achievement doesn't exist.", achievement_id)

		return false
	end

	local flags = achievement_definition.flags

	if not DEDICATED_SERVER and not flags[AchievementFlags.allow_solo] then
		Log.info("AchievementsManager", "Failed to unlock achievement '%s'. Host isn't a server.", achievement_id, player_id)

		return false
	end

	local previous_id = achievement_definition.previous

	if previous_id and unlock_previous then
		self:unlock_achievement(player, previous_id, unlock_previous)
	end

	self:_unlock_achievement(player_id, achievement_id)

	return true
end

AchievementsManager.rpc_unlock_achievement = function (self, _, local_player_id, achievement_index)
	local achievement_id = self._achievement_lookup[achievement_index]

	self:_unlock_achievement(local_player_id, achievement_id, nil, true)
end

AchievementsManager._show_unlock_in_chat = function (self, player, achievement_id)
	local player_name = player:name()
	local save_manager = Managers.save
	local option = "none"

	if save_manager then
		local account_data = save_manager:account_data()

		option = account_data and account_data.interface_settings.penance_unlock_chat_message_type
	end

	local is_local_player = player:peer_id() == Network.peer_id()
	local desired_option = is_local_player and "mine" or "others"
	local should_show = option == "all" or option == desired_option

	if not should_show then
		return
	end

	local achievement_definition = achievement_id and self._definitions[achievement_id]
	local achievement_name = achievement_definition and AchievementUIHelper.localized_title(achievement_definition)

	if player_name and achievement_name then
		local player_color = Color.terminal_text_key_value(255, true)

		player_name = TextUtilities.apply_color_to_text(player_name, player_color)

		local achievement_color = Color.ui_brown_super_light(255, true)

		achievement_name = TextUtilities.apply_color_to_text(achievement_name, achievement_color)

		local message = Localize("loc_ally_unlocked_penance", true, {
			player_name = player_name,
			achievement_name = achievement_name,
		})

		Managers.event:trigger("system_chat_message", message, "SYSTEM")
	end
end

AchievementsManager.rpc_ally_unlocked_achievement = function (self, _, peer_id, local_player_id, achievement_index)
	local player = Managers.player and Managers.player:player(peer_id, local_player_id)
	local achievement_id = self._achievement_lookup[achievement_index]

	if not player or not achievement_id then
		return
	end

	self:_show_unlock_in_chat(player, achievement_id)
end

AchievementsManager._on_achievement_unlock = function (self, player_id, achievement_id)
	local player_data = self._players[player_id]
	local triggers = self._triggers
	local definitions = self._definitions
	local scratch_pad = player_data.scratchpad
	local relevant_achievements = player_data.achievements_by_achievement_id[achievement_id]
	local relevant_achievement_count = relevant_achievements and #relevant_achievements or 0

	for i = relevant_achievement_count, 1, -1 do
		local next_achievement_id = relevant_achievements[i]
		local achievement = definitions[next_achievement_id]
		local achievement_type = achievement.type
		local trigger = triggers[achievement_type]
		local is_complete = trigger(achievement, scratch_pad, player_id, achievement_id)

		if is_complete then
			self:_unlock_achievement(player_id, next_achievement_id)
		end
	end
end

AchievementsManager._on_stat_trigger = function (self, listener_id, stat_name, value)
	local player_data = self._players_by_listener_id[listener_id]
	local player_id = player_data.id
	local triggers = self._triggers
	local definitions = self._definitions
	local scratch_pad = player_data.scratchpad
	local relevant_achievements = player_data.achievements_by_stat_name[stat_name]
	local relevant_achievement_count = relevant_achievements and #relevant_achievements or 0

	for i = relevant_achievement_count, 1, -1 do
		local achievement_id = relevant_achievements[i]
		local achievement = definitions[achievement_id]
		local achievement_type = achievement.type
		local trigger = triggers[achievement_type]
		local is_complete = trigger(achievement, scratch_pad, player_id, stat_name, value)

		if is_complete then
			self:_unlock_achievement(player_id, achievement_id)
		end
	end
end

return AchievementsManager
