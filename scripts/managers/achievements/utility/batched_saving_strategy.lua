local AchievementStats = require("scripts/managers/stats/groups/achievement_stats")
local AchievementTypes = require("scripts/settings/achievements/achievement_types")
local Promise = require("scripts/foundation/utilities/promise")
local SavingStrategyInterface = require("scripts/managers/achievements/utility/saving_strategy_interface")
local StatFlags = require("scripts/settings/stats/stat_flags")
local BatchedSavingStrategy = class("BatchedSavingStrategy")

BatchedSavingStrategy.init = function (self, achievement_definitions)
	self._definitions = achievement_definitions
	self._pushing = Promise.resolved()
	self._pending = Promise.resolved()
	self._players = {}
	self._updates = {}
end

BatchedSavingStrategy.destroy = function (self)
	if self._pending:is_pending() then
		self._pending:reject("Failed to push data to the backend.")
	end

	if self._pushing:is_pending() then
		self._pushing:cancel()
	end
end

BatchedSavingStrategy._get_data_diff = function (self, account_id, initial_data, current_data)
	local definitions = self._definitions
	local stat_changes = {}

	for _, stat_definition in pairs(AchievementStats.definitions) do
		if stat_definition:check_flag(StatFlags.save_to_backend) then
			local initial_value = stat_definition:get_raw(initial_data.stats)
			local current_value = stat_definition:get_raw(current_data.stats)

			if initial_value ~= current_value then
				local id = stat_definition:get_id()
				stat_changes[#stat_changes + 1] = {
					isPlatformStat = false,
					stat = id,
					value = current_value
				}
			end
		end
	end

	local unlocked_achievements = {}

	for achievement_id, _ in pairs(current_data.completed) do
		if not initial_data.completed[achievement_id] then
			local achievement_definition = definitions.achievement_from_id(achievement_id)
			local type, triggers = achievement_definition:get_triggers()
			local stat_name = type == AchievementTypes.stat and triggers[1] or "none"
			unlocked_achievements[#unlocked_achievements + 1] = {
				complete = true,
				id = achievement_id,
				stat = stat_name
			}
		end
	end

	if #stat_changes > 0 or #unlocked_achievements > 0 then
		return Managers.backend.interfaces.commendations:create_update(account_id, stat_changes, unlocked_achievements)
	end
end

BatchedSavingStrategy._add_to_push = function (self, account_id)
	local data = self._players[account_id]
	self._players[account_id] = nil
	local update = self:_get_data_diff(data.account_id, data.initial_data, data.current_data)

	if update then
		local updates = self._updates
		updates[#updates + 1] = update
	end

	if self._pending:is_fulfilled() then
		self._pending = Promise:new()
	end
end

BatchedSavingStrategy._push_all = function (self)
	if self._pushing:is_pending() then
		return
	end

	if self._pending:is_fulfilled() then
		return
	end

	self._pushing = Managers.backend.interfaces.commendations:bulk_update_commendations(self._updates)

	self._pushing:next(function ()
		self:_push_all()
	end)
	self._pending:resolve(nil)

	self._updates = {}
end

BatchedSavingStrategy.track_player = function (self, account_id, constant_player_data)
	self._players[account_id] = {
		account_id = account_id,
		current_data = constant_player_data.data,
		initial_data = table.clone(constant_player_data.data)
	}
end

BatchedSavingStrategy.save_on_player_exit = function (self, account_id)
	self:_add_to_push(account_id)
	self:_push_all()

	return self._pending
end

BatchedSavingStrategy.save_on_all_exit = function (self)
	local account_ids = table.keys(self._players)

	for i = 1, #account_ids do
		self:_add_to_push(account_ids[i])
	end

	self:_push_all()

	return self._pending
end

BatchedSavingStrategy.save_on_stat_change = function (self, account_id, trigger_id, trigger_value, ...)
	return
end

BatchedSavingStrategy.save_on_achievement_unlock = function (self, account_id, achievement_id)
	return Promise.resolved()
end

implements(BatchedSavingStrategy, SavingStrategyInterface)

return BatchedSavingStrategy
