local AchievementList = require("scripts/managers/achievements/achievement_list")
local AchievementsEvents = require("scripts/managers/achievements/utility/achievements_events")
local AchievementTracker = require("scripts/managers/achievements/utility/achievement_tracker")
local Promise = require("scripts/foundation/utilities/promise")
local MasterItems = require("scripts/backend/master_items")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local AchievementsManager = class("AchievementsManager")
local CLIENT_RPCS = {
	"rpc_notify_commendation_complete",
	"rpc_notify_commendation_progress"
}

AchievementsManager._is_client = function (self)
	return not self._is_server
end

AchievementsManager._is_tracker = function (self)
	return self._is_server
end

AchievementsManager.init = function (self, is_server, event_delegate)
	self._is_server = is_server
	self._network_event_delegate = event_delegate
	self._achievements = AchievementList
	self._backend_data = nil

	if self:_is_client() then
		self._network_event_delegate:register_connection_events(self, unpack(CLIENT_RPCS))

		self._unlocked = {}
	end

	if self:_is_tracker() then
		self:verify_achievements()

		self._achievement_tracker = AchievementTracker:new(self:get_achievement_definitions())

		AchievementsEvents.install(self)
	end
end

AchievementsManager.destroy = function (self)
	if self:_is_client() then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))

		return
	end

	if self:_is_tracker() then
		self:untrack_all_players()
		AchievementsEvents.uninstall(self)
	end
end

AchievementsManager._platform_available = function (self)
	if rawget(_G, "Achievement") then
		return true
	end

	return false
end

AchievementsManager._platform_is_unlocked = function (self, achievement_id)
	if rawget(_G, "Achievement") then
		return Achievement.unlocked(achievement_id)
	end

	return false
end

AchievementsManager._platform_unlock = function (self, ...)
	if rawget(_G, "Achievement") then
		Achievement.unlock(...)

		return true
	end

	return false
end

AchievementsManager._platform_indicate_progress = function (self, achievement_definition, value)
	if rawget(_G, "Achievement") then
		Achievement.indicate_progress(achievement_definition:id(), value, achievement_definition:get_target())

		return true
	end

	return false
end

local function _verify_localization(achievements, issues)
	local missing_labels = {}
	local missing_descriptions = {}

	for _, achievement in ipairs(achievements) do
		local label = achievement:label(true)

		if not Managers.localization:exists(label) and not table.array_contains(missing_labels, label) then
			missing_labels[#missing_labels + 1] = label
		end

		local description = achievement:description(true)

		if not Managers.localization:exists(description) and not table.array_contains(missing_descriptions, description) then
			missing_descriptions[#missing_descriptions + 1] = description
		end
	end

	for _, label in ipairs(missing_labels) do
		issues[#issues + 1] = string.format("Missing localization for label %s", label)
	end

	for _, description in ipairs(missing_descriptions) do
		issues[#issues + 1] = string.format("Missing localization for description %s", description)
	end
end

local function _verify_backend(achievements, backend_data, issues)
	local missing_in_backend = {}
	local only_in_backend = {}
	local backend_ids = {}

	for _, commendation in ipairs(backend_data.commendations) do
		local id = commendation.id
		backend_ids[id] = true

		if not achievements.achievement_exists(id) then
			only_in_backend[#only_in_backend + 1] = id
		end
	end

	for _, achievement in ipairs(achievements) do
		local id = achievement:id()

		if not backend_ids[id] then
			missing_in_backend[#missing_in_backend + 1] = id
		end
	end

	for _, id in ipairs(missing_in_backend) do
		issues[#issues + 1] = string.format("Achievement with id %s is missing in the backend.", id)
	end

	for _, id in ipairs(only_in_backend) do
		issues[#issues + 1] = string.format("Achievement with id %s only exists in the backend.", id)
	end
end

AchievementsManager.verify_achievements = function (self)
	local issues = {}

	_verify_localization(self._achievements, issues)

	if self._backend_data then
		_verify_backend(self._achievements, self._backend_data, issues)
	end

	if #issues > 0 then
		Log.warning("AchievementsManager", "Achievements have the following issues : %s", table.tostring(issues, 99))
	else
		Log.info("AchievementsManager", "No issues found with achievement.")
	end

	return #issues == 0
end

AchievementsManager.sync_achievement_data = function (self, account_id)
	if not math.is_uuid(account_id) then
		return Promise.resolved()
	end

	return Managers.backend.interfaces.commendations:get_commendations(account_id, true, false):next(function (data)
		self._backend_data = data
		local commendations = self._backend_data.commendations
		local has_platform = self:_platform_available()
		local unlock_on_platform = {}
		local no_rewards = {}

		for _, commendation in ipairs(commendations) do
			repeat
				local id = commendation.id
				local achievement = self:achievement_definition_from_id(id)

				if not achievement then
					break
				end

				achievement:set_score(commendation.score or achievement:score())

				local rewards = commendation.rewards or no_rewards

				for _, reward in ipairs(rewards) do
					achievement:add_reward(reward)
				end

				local is_complete = commendation.complete
				local is_plaform_achievement = achievement:is_platform()
				local should_be_unlocked = is_complete and has_platform and is_plaform_achievement

				if should_be_unlocked and not self:_platform_is_unlocked(id) then
					unlock_on_platform[#unlock_on_platform + 1] = id
				end

				if is_complete then
					self._unlocked[id] = true
				end
			until true
		end

		self:_platform_unlock(unpack(unlock_on_platform))
		self:verify_achievements()
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

AchievementsManager.track_player = function (self, session_id, player)
	if not self:_is_tracker() then
		return
	end

	Log.info("AchievementsManager", "Track commendations for account %s.", player:account_id())

	return self._achievement_tracker:track_player(player)
end

AchievementsManager.untrack_player = function (self, session_id, account_id)
	if not self:_is_tracker() then
		return
	end

	Log.info("AchievementsManager", "Untrack commendations for account %s.", account_id)

	return self._achievement_tracker:untrack_player(account_id)
end

AchievementsManager.untrack_all_players = function (self, session_id)
	if not self:_is_tracker() then
		return
	end

	Log.info("AchievementsManager", "Untrack commendations for all accounts.")

	return self._achievement_tracker:untrack_all()
end

AchievementsManager.trigger_event = function (self, account_id, character_id, event_name, event_data)
	if not self:_is_tracker() then
		return
	end

	Log.info("AchievementsManager", "Trigger event %s for %s.", event_name, account_id)
	self._achievement_tracker:_on_event_trigger(account_id, event_name, event_data)
end

AchievementsManager.unlock_achievement = function (self, achievement_id)
	if not self:_is_client() then
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

AchievementsManager._notify_achievement_unlock = function (self, achievement_definition)
	local achievement_label = achievement_definition:label()
	local notification_string = string.format("Achievement '%s' completed!", achievement_label)

	Managers.event:trigger("event_add_notification_message", "default", notification_string)

	return true
end

AchievementsManager._notify_achievement_reward = function (self, reward)
	if reward.rewardType == "item" then
		if MasterItems.item_exists(reward.name) then
			local rewarded_master_item = MasterItems.get_item(reward.name)
			local sound_event = UISoundEvents.character_news_feed_new_item

			Managers.event:trigger("event_add_notification_message", "item_granted", rewarded_master_item, nil, sound_event)

			return true
		else
			Log.warning("AchievementManager", "Received invalid item %s as reward from backend.", reward.name)

			return false
		end
	end

	local notification_string = "You've received a reward!"

	Managers.event:trigger("event_add_notification_message", "default", notification_string)

	return true
end

AchievementsManager._unlock_achievement = function (self, achievement_definition)
	local player_notified = false

	if achievement_definition:is_platform() and self:_platform_available() then
		player_notified = self:_platform_unlock(achievement_definition:id())
	end

	player_notified = player_notified or self:_notify_achievement_unlock(achievement_definition)
	local rewards = achievement_definition:get_rewards()

	if rewards then
		for i = 1, #rewards do
			local notified_about_reward = self:_notify_achievement_reward(rewards[i])
			player_notified = player_notified or notified_about_reward
		end
	end

	self._unlocked[achievement_definition:id()] = true
end

AchievementsManager.rpc_notify_commendation_progress = function (self, channel_id, achievement_index, value)
	assert(self:_is_client(), "Only clients can be notified about achievements.")

	local achievement_definition = self._achievements[achievement_index]

	if achievement_definition:is_platform() and self:_platform_available() then
		self:_platform_indicate_progress(achievement_definition, value)
	end
end

AchievementsManager.rpc_notify_commendation_complete = function (self, channel_id, achievement_index)
	assert(self:_is_client(), "Only clients can be notified about achievements.")

	local achievement_definition = self._achievements[achievement_index]

	self:_unlock_achievement(achievement_definition)
end

return AchievementsManager
