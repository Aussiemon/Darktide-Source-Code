local AchievementData = require("scripts/managers/achievements/achievement_data")
local AchievementList = require("scripts/managers/achievements/achievement_list")
local AchievementsEvents = require("scripts/managers/achievements/utility/achievements_events")
local AchievementTracker = require("scripts/managers/achievements/utility/achievement_tracker")
local BatchedSavingStrategy = require("scripts/managers/achievements/utility/batched_saving_strategy")
local InstantSavingStrategy = require("scripts/managers/achievements/utility/instant_saving_strategy")
local Promise = require("scripts/foundation/utilities/promise")
local MasterItems = require("scripts/backend/master_items")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local AchievementsManager = class("AchievementsManager")
local CLIENT_RPCS = {
	"rpc_notify_commendation_complete",
	"rpc_notify_commendation_progress"
}

local function _get_platform_class()
	if IS_GDK or IS_XBS then
		return require("scripts/managers/achievements/platforms/xbox_live_achievement")
	end

	if Backend.get_auth_method() == Backend.AUTH_METHOD_STEAM then
		return require("scripts/managers/achievements/platforms/steam_achievement")
	end

	return require("scripts/managers/achievements/platforms/no_platform_achievement")
end

local platform_class = _get_platform_class()

AchievementsManager.init = function (self, is_server, event_delegate, instant_saving)
	self._network_event_delegate = event_delegate
	self._achievements = AchievementList
	self._backend_data = nil

	if is_server then
		local saving_strategy_class = instant_saving and InstantSavingStrategy or BatchedSavingStrategy

		self:_start_tracking(saving_strategy_class)
	else
		self._is_client = true

		self._network_event_delegate:register_connection_events(self, unpack(CLIENT_RPCS))

		self._unlocked = {}
		self._platform = nil
	end
end

AchievementsManager.destroy = function (self)
	if self._is_client then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))

		return
	end

	if self._is_tracker then
		self:_stop_tracking()
	end
end

AchievementsManager._start_tracking = function (self, saving_strategy_class)
	self._is_tracker = true
	self._achievement_tracker = AchievementTracker:new(self:get_achievement_definitions(), saving_strategy_class, false)

	AchievementsEvents.install(self)
end

AchievementsManager._stop_tracking = function (self)
	self:untrack_all_players()
	AchievementsEvents.uninstall(self)
	self._achievement_tracker:delete()

	self._achievement_tracker = nil
	self._is_tracker = false
end

AchievementsManager.client_start_tracking = function (self)
	self:_start_tracking(BatchedSavingStrategy)
	Log.info("AchievementsManager", "client started tracking achievements")
end

AchievementsManager.client_stop_tracking = function (self)
	self:_stop_tracking()
	Log.info("AchievementsManager", "client stopped tracking achievements")
end

AchievementsManager.sync_achievement_data = function (self, account_id)
	local platform_promise = Promise.resolved()

	if self._is_client then
		self._platform, platform_promise = platform_class:new()
	end

	if not math.is_uuid(account_id) then
		return platform_promise
	end

	local backend_promise = Managers.backend.interfaces.commendations:get_commendations(account_id, true, true)

	return Promise.all(backend_promise, platform_promise):next(function (promise_result)
		self._backend_data = promise_result[1]
		local commendations = self._backend_data.commendations

		for _, commendation in ipairs(commendations) do
			repeat
				local id = commendation.id
				local achievement = self:achievement_definition_from_id(id)

				if not achievement then
					break
				end

				achievement:set_score(commendation.score or achievement:score())
				achievement:set_rewards(commendation.rewards)
			until true
		end

		local achievement_data = AchievementData()

		for _, stat in ipairs(self._backend_data.stats) do
			achievement_data.stats[stat.stat] = stat.value
		end

		for i = 1, #commendations do
			local achievement = commendations[i]
			local achievement_id = achievement.id
			local is_achievement = self:achievement_definition_from_id(achievement_id) ~= nil
			local is_complete = achievement.complete

			if is_achievement and is_complete then
				achievement_data.completed[achievement_id] = is_complete and (achievement.at or true) or nil
			end
		end

		for i = 1, #self._achievements do
			repeat
				local achievement = self._achievements[i]
				local id = achievement:id()
				local is_platform = self._platform:is_platform_achievement(id)

				if not is_platform then
					break
				end

				local unlocked_on_platform = self._platform:is_unlocked(id)

				if unlocked_on_platform then
					break
				end

				local is_complete = achievement:is_completed(achievement_data)

				if is_complete then
					self._platform:unlock_achievement(id)
				else
					local progress = achievement:get_progress(achievement_data)
					local target = achievement:get_target()

					self._platform:update_progress(id, progress, target)
				end
			until true
		end

		self._unlocked = achievement_data.completed
	end):catch(function (error)
		Log.warning("AchievementsManager", "Failed to fetch data, the error was: %s", table.tostring(error, 5))
	end)
end

AchievementsManager.get_achievement_definitions = function (self)
	return self._achievements
end

AchievementsManager.achievement_definition_from_id = function (self, achievement_id)
	return self._achievements.achievement_from_id(achievement_id)
end

AchievementsManager.track_player = function (self, player)
	if not self._is_tracker then
		return
	end

	Log.info("AchievementsManager", "Track achievements for account %s.", player:account_id())

	return self._achievement_tracker:track_player(player)
end

AchievementsManager.untrack_player = function (self, account_id)
	if not self._is_tracker then
		return
	end

	Log.info("AchievementsManager", "Untrack achievements for account %s.", account_id)

	return self._achievement_tracker:untrack_player(account_id)
end

AchievementsManager.untrack_all_players = function (self)
	if not self._is_tracker then
		return
	end

	Log.info("AchievementsManager", "Untrack achievements for all accounts.")

	return self._achievement_tracker:untrack_all()
end

AchievementsManager.trigger_event = function (self, account_id, character_id, event_name, event_data)
	if not self._is_tracker then
		return
	end

	Log.info("AchievementsManager", "Trigger event %s for %s.", event_name, account_id)
	self._achievement_tracker:_on_event_trigger(account_id, event_name, event_data)
end

AchievementsManager.unlock_achievement = function (self, achievement_id)
	if not self._is_client then
		return
	end

	if self._unlocked[achievement_id] then
		return
	end

	Log.info("AchievementsManager", "Try to unlock achievement with id '%s'.", achievement_id)
	Managers.data_service.account:unlock_achievement(achievement_id):next(function (_)
		local achievement_definition = self._achievements.achievement_from_id(achievement_id)

		self:_unlock_achievement(achievement_definition)
	end):catch(function (error)
		Log.warning("AchievementsManager", "Failed to unlock achievement '%s' with error '%s'.", achievement_id, table.tostring(error, 99))
	end)
end

AchievementsManager.is_unlocked = function (self, achievement_id)
	if self._is_client and self._unlocked[achievement_id] then
		return true
	end

	return false
end

AchievementsManager._notify_achievement_unlock = function (self, achievement_definition)
	Managers.event:trigger("event_add_notification_message", "achievement", achievement_definition)

	return true
end

local item_rewards = {}

AchievementsManager._notify_achievement_rewards = function (self, rewards)
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

				Managers.event:trigger("event_add_notification_message", "item_granted", rewarded_master_item, nil, sound_event)
			else
				Log.warning("AchievementManager", "Received invalid item %s as reward from backend.", master_id)
			end
		end
	end
end

AchievementsManager._unlock_achievement = function (self, achievement_definition)
	local id = achievement_definition:id()

	if self._platform:is_platform_achievement(id) then
		self._platform:unlock_achievement(id)
	end

	self:_notify_achievement_unlock(achievement_definition)

	local rewards = achievement_definition:get_rewards()

	if rewards then
		self:_notify_achievement_rewards(rewards)
	end

	self._unlocked[achievement_definition:id()] = true
end

AchievementsManager.rpc_notify_commendation_progress = function (self, channel_id, achievement_index, value)
	self:notify_commendation_progress(achievement_index, value)
end

AchievementsManager.notify_commendation_progress = function (self, achievement_index, value)
	local achievement_definition = self._achievements[achievement_index]
	local id = achievement_definition:id()

	if self._platform:is_platform_achievement(id) then
		local target = achievement_definition:get_target()

		self._platform:update_progress(id, value, target)
	end
end

AchievementsManager.rpc_notify_commendation_complete = function (self, channel_id, achievement_index)
	self:notify_commendation_complete(achievement_index)
end

AchievementsManager.notify_commendation_complete = function (self, achievement_index)
	local achievement_definition = self._achievements[achievement_index]

	self:_unlock_achievement(achievement_definition)
end

return AchievementsManager
