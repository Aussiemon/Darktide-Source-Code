local AchievementPlatformChecker = require("scripts/managers/achievements/utility/achievement_platform_checker")
local AchievementStats = require("scripts/managers/stats/groups/achievement_stats")
local AchievementTypes = require("scripts/settings/achievements/achievement_types")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local Promise = require("scripts/foundation/utilities/promise")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local AchievementTracker = class("AchievementTracker")

AchievementTracker.init = function (self, achievement_definitions, saving_strategy_class, optional_push_platform_progress)
	self._achievement_definitions = achievement_definitions
	self._triggered_by = {
		[AchievementTypes.event] = {},
		[AchievementTypes.stat] = {},
		[AchievementTypes.meta] = {}
	}

	for index = 1, #achievement_definitions do
		local achievement_definition = achievement_definitions[index]
		local achievement_type, triggers = achievement_definition:get_triggers()
		local triggered_by = self._triggered_by[achievement_type]

		if triggered_by and triggers then
			for _, trigger in ipairs(triggers) do
				local triggered_by_name = triggered_by[trigger] or {}
				triggered_by_name[#triggered_by_name + 1] = index
				triggered_by[trigger] = triggered_by_name
			end
		end
	end

	self._tracked_players = {}
	self._tracked_stats = {}
	self._push_platform_progress = optional_push_platform_progress == true
	self._saving_strategy = saving_strategy_class:new(achievement_definitions)
end

AchievementTracker.destroy = function (self)
	self:untrack_all()
	self._saving_strategy:delete()
end

AchievementTracker.track_player = function (self, player)
	local account_id = player.account_id and player:account_id()

	if not math.is_uuid(account_id) then
		Log.warning("AchievementTracker", "Unable to track achievements for '%s'.", account_id)

		return Promise.resolved()
	end

	if self:is_tracking(account_id) then
		Log.warning("AchievementTracker", "Already tracking achievements for '%s'.", account_id)

		return Promise.resolved()
	end

	self._tracked_players[account_id] = {
		connection_channel_id = player:connection_channel_id(),
		remote_player = player.remote
	}

	return Managers.data_service.account:pull_achievement_data(account_id, self._achievement_definitions):next(function (achievement_data)
		local tracked_table = self._tracked_players[account_id]

		if not tracked_table then
			return
		end

		tracked_table.data = achievement_data
		local stat_id = Managers.stats:add_tracker(self, player, AchievementStats, AchievementTracker._on_stat_trigger, achievement_data.stats)
		tracked_table.stat_id = stat_id
		self._tracked_stats[stat_id] = account_id

		self._saving_strategy:track_player(account_id, tracked_table)

		for trigger_id, value in pairs(achievement_data.stats) do
			if self._triggered_by[AchievementTypes.stat][trigger_id] then
				self:_on_stat_trigger(stat_id, trigger_id, value)
			end
		end
	end):catch(function (error)
		self._tracked_players[account_id] = nil

		Log.error("AchievementTracker", "Failed to download achievement data for '%s' with error: '%s'.", account_id, tostring(error))
	end)
end

AchievementTracker._stop_tracking = function (self, account_id)
	local player_data = self._tracked_players[account_id]
	self._tracked_players[account_id] = nil
	local stat_id = player_data.stat_id

	if stat_id then
		self._tracked_stats[stat_id] = nil

		Managers.stats:remove_tracker(stat_id)
	end
end

AchievementTracker.untrack_player = function (self, account_id)
	if not self:is_tracking(account_id) then
		Log.warning("AchievementTracker", "Can't untrack when not tracking achievements for '%s'.", account_id)

		return Promise.resolved()
	end

	self:_stop_tracking(account_id)

	return self._saving_strategy:save_on_player_exit(account_id):next(function (_)
		Log.debug("AchievementTracker", "Sending achievement update complete.")
	end):catch(function (error)
		Log.error("AchievementTracker", "Sending achievement update failed %s.", tostring(error))
	end)
end

AchievementTracker.untrack_all = function (self)
	for account_id, _ in pairs(self._tracked_players) do
		self:_stop_tracking(account_id)
	end

	return self._saving_strategy:save_on_all_exit():next(function (_)
		Log.debug("AchievementTracker", "Sending achievement update complete.")
	end):catch(function (error)
		Log.error("AchievementTracker", "Sending achievement update failed %s.", tostring(error))
	end)
end

AchievementTracker.is_tracking = function (self, account_id)
	return self._tracked_players[account_id] ~= nil
end

AchievementTracker._unlock_achievement = function (self, account_id, achievement_id)
	local tracked_table = self._tracked_players[account_id]
	local achievement_data = tracked_table.data
	local achievement_index = self._achievement_definitions._lookup[achievement_id]
	achievement_data.completed[achievement_id] = true
	local remote_player = tracked_table.remote_player

	if remote_player then
		RPC.rpc_notify_commendation_complete(tracked_table.connection_channel_id, achievement_index)
	else
		Managers.achievements:notify_commendation_complete(achievement_index)
	end

	self._saving_strategy:save_on_achievement_unlock(account_id, achievement_id)
	self:_on_achievement_unlock(account_id, achievement_id)
end

AchievementTracker._progress_achievement = function (self, account_id, achievement_id)
	local achievement_index = self._achievement_definitions._lookup[achievement_id]
	local achievement_definition = self._achievement_definitions[achievement_index]
	local is_platform_achievement = AchievementPlatformChecker.is_any_plaform_achievement(achievement_id)
	local should_send_progress = self._push_platform_progress and is_platform_achievement

	if not should_send_progress then
		return
	end

	local tracked_table = self._tracked_players[account_id]
	local achievement_data = tracked_table.data
	local progress = achievement_definition:get_progress(achievement_data)
	local remote_player = tracked_table.remote_player

	if remote_player then
		RPC.rpc_notify_commendation_progress(tracked_table.connection_channel_id, achievement_index, progress)
	else
		Managers.achievements:notify_commendation_progress(achievement_index, progress)
	end
end

AchievementTracker._on_trigger = function (self, account_id, type, trigger_id, ...)
	local tracked_table = self._tracked_players[account_id]

	if not tracked_table then
		Log.warning("AchievementTracker", "Trying to trigger %s %s for non tracked account '%s'.", type, trigger_id, account_id)

		return
	end

	local achievement_data = tracked_table.data
	local triggered_by = self._triggered_by[type][trigger_id]

	if not triggered_by then
		return
	end

	for index = 1, #triggered_by do
		local achievement_index = triggered_by[index]
		local achievement_definition = self._achievement_definitions[achievement_index]

		if achievement_definition:trigger(achievement_data, type, trigger_id, ...) then
			self:_unlock_achievement(account_id, achievement_definition:id())
		elseif not achievement_definition:is_completed(achievement_data) then
			self:_progress_achievement(account_id, achievement_definition:id())
		end
	end
end

AchievementTracker._on_achievement_unlock = function (self, account_id, achievement_id)
	self:_on_trigger(account_id, AchievementTypes.meta, achievement_id)
end

AchievementTracker._on_event_trigger = function (self, account_id, event_name, event_params)
	self:_on_trigger(account_id, AchievementTypes.event, event_name, event_params)
end

AchievementTracker._on_stat_trigger = function (self, id, trigger_id, trigger_value, ...)
	local account_id = self._tracked_stats[id]

	self._saving_strategy:save_on_stat_change(account_id, trigger_id, trigger_value, ...)
	self:_on_trigger(account_id, AchievementTypes.stat, trigger_id, trigger_value, ...)
end

return AchievementTracker
