-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
local Promise = require("scripts/foundation/utilities/promise")
local AchievementTypes = require("scripts/settings/achievements/achievement_types")
local AchievementStats = require("scripts/managers/stats/groups/achievement_stats")
local StatFlags = require("scripts/settings/stats/stat_flags")
local AchievementTracker = class("AchievementTracker")

AchievementTracker.init = function (self, achievement_definitions)
	self._achievement_definitions = achievement_definitions
	self._triggered_by = {
		[AchievementTypes.event] = {},
		[AchievementTypes.stat] = {},
		[AchievementTypes.meta] = {}
	}

	for index, achievement_definition in ipairs(achievement_definitions) do
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
end

AchievementTracker._get_data_diff = function (self, account_id, initial_data, current_data)
	local stat_changes = {}

	for _, stat_definition in pairs(AchievementStats.definitions) do
		if stat_definition:check_flag(StatFlags.save_to_backend) then
			local initial_value = stat_definition:get_raw(initial_data.stats)
			local current_value = stat_definition:get_raw(current_data.stats)

			if initial_value ~= current_value then
				local id = stat_definition:get_id()

				fassert(type(current_value) == "number", "AchievementTracker is trying to save a non-numeric stat '%s' with id '%s' to the backend.", current_value, id)

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
			local type, triggers = self._achievement_definitions.achievement_from_id(achievement_id):get_triggers()
			local stat_name = (type == AchievementTypes.stat and triggers[1]) or "none"
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

AchievementTracker.track_player = function (self, player)
	local account_id = player.account_id and player:account_id()

	if not math.is_uuid(account_id) then
		Log.warning("AchievementTracker", "Unable to track achievements for '%s'.", account_id)

		return Promise.resolved()
	end

	if self._tracked_players[account_id] then
		Log.warning("AchievementTracker", "Already tracking achievements for '%s'.", account_id)

		return Promise.resolved()
	end

	self._tracked_players[account_id] = {
		connection_channel_id = player:connection_channel_id()
	}

	return Managers.data_service.account:pull_achievement_data(account_id, self._achievement_definitions):next(function (achievement_data)
		local tracked_table = self._tracked_players[account_id]

		if not tracked_table then
			return
		end

		tracked_table.current_data = achievement_data
		tracked_table.initial_data = table.clone(achievement_data)
		local stat_id = Managers.stats:add_tracker(self, player, AchievementStats, AchievementTracker._on_stat_trigger, achievement_data.stats)
		tracked_table.stat_id = stat_id
		self._tracked_stats[stat_id] = account_id
	end):catch(function (error)
		self._tracked_players[account_id] = nil

		Log.error("AchievementTracker", "Failed to download achievement data for '%s' with error: '%s'.", account_id, tostring(error))
	end)
end

AchievementTracker._untrack_player = function (self, account_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-4, warpins: 1 ---
	local tracked_table = self._tracked_players[account_id]

	if not tracked_table then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 5-12, warpins: 1 ---
		Log.warning("AchievementTracker", "Can't untrack '%s', they aren't tracked.", account_id)

		return nil
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 13-18, warpins: 2 ---
	self._tracked_players[account_id] = nil

	if not tracked_table.stat_id then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 19-25, warpins: 1 ---
		Log.debug("AchievementTracker", "Untracked player '%s' before data was downloaded from the backend.")

		return nil
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 26-41, warpins: 2 ---
	local stat_id = tracked_table.stat_id
	self._tracked_stats[stat_id] = nil

	Managers.stats:remove_tracker(stat_id)

	return self:_get_data_diff(account_id, tracked_table.initial_data, tracked_table.current_data)
	--- END OF BLOCK #2 ---



end

AchievementTracker.untrack_player = function (self, account_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	local achievement_update = self:_untrack_player(account_id)

	if not achievement_update then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 7-9, warpins: 1 ---
		return Promise.resolved()
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 10-27, warpins: 1 ---
	return Managers.backend.interfaces.commendations:bulk_update_commendations({
		achievement_update
	}):next(function (_)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-6, warpins: 1 ---
		Log.debug("AchievementTracker", "Sending achievement update complete.")

		return
		--- END OF BLOCK #0 ---



	end):catch(function (error)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-9, warpins: 1 ---
		Log.error("AchievementTracker", "Sending achievement update failed %s.", tostring(error))

		return
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 28-28, warpins: 2 ---
	--- END OF BLOCK #2 ---



end

AchievementTracker.untrack_all = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	local achievement_updates = {}

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 6-14, warpins: 0 ---
	for account_id, _ in pairs(self._tracked_players) do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 6-12, warpins: 1 ---
		local achievement_update = self:_untrack_player(account_id)
		achievement_updates[#achievement_updates + 1] = achievement_update
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 13-14, warpins: 2 ---
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 15-17, warpins: 1 ---
	if #achievement_updates == 0 then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 18-20, warpins: 1 ---
		return Promise.resolved()
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 21-37, warpins: 1 ---
	return Managers.backend.interfaces.commendations:bulk_update_commendations(achievement_updates):next(function (_)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-6, warpins: 1 ---
		Log.debug("AchievementTracker", "Sending achievement update complete.")

		return
		--- END OF BLOCK #0 ---



	end):catch(function (error)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-9, warpins: 1 ---
		Log.error("AchievementTracker", "Sending achievement update failed %s.", tostring(error))

		return
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #3 ---

	FLOW; TARGET BLOCK #4



	-- Decompilation error in this vicinity:
	--- BLOCK #4 38-38, warpins: 2 ---
	--- END OF BLOCK #4 ---



end

AchievementTracker._unlock_achievement = function (self, account_id, achievement_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-20, warpins: 1 ---
	local tracked_table = self._tracked_players[account_id]
	local achievement_data = tracked_table.current_data
	achievement_data.completed[achievement_id] = true
	local achievement_index = self._achievement_definitions._lookup[achievement_id]

	RPC.rpc_notify_commendation_complete(tracked_table.connection_channel_id, achievement_index)
	self:_on_achievement_unlock(account_id, achievement_id)

	return
	--- END OF BLOCK #0 ---



end

AchievementTracker._on_trigger = function (self, account_id, type, trigger_id, ...)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-8, warpins: 1 ---
	local tracked_table = self._tracked_players[account_id]
	local achievement_data = tracked_table.current_data
	local triggered_by = self._triggered_by[type][trigger_id]

	if not triggered_by then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 9-9, warpins: 1 ---
		return
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 10-13, warpins: 2 ---
	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 14-33, warpins: 0 ---
	for index = 1, #triggered_by, 1 do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 14-25, warpins: 2 ---
		local achievement_index = triggered_by[index]
		local achievement_definition = self._achievement_definitions[achievement_index]

		if achievement_definition:trigger(achievement_data, type, trigger_id, ...) then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 26-32, warpins: 1 ---
			self:_unlock_achievement(account_id, achievement_definition:id())
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 33-33, warpins: 2 ---
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 34-34, warpins: 1 ---
	return
	--- END OF BLOCK #3 ---



end

AchievementTracker._on_achievement_unlock = function (self, account_id, achievement_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-8, warpins: 1 ---
	self:_on_trigger(account_id, AchievementTypes.meta, achievement_id)

	return
	--- END OF BLOCK #0 ---



end

AchievementTracker._on_event_trigger = function (self, account_id, event_name, event_params)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-9, warpins: 1 ---
	self:_on_trigger(account_id, AchievementTypes.event, event_name, event_params)

	return
	--- END OF BLOCK #0 ---



end

AchievementTracker._on_stat_trigger = function (self, id, trigger_id, trigger_value, trigger_params)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-17, warpins: 1 ---
	local account_id = self._tracked_stats[id]

	fassert(account_id, "Recieved stat when not tracking stats for id '%s'.", id)
	self:_on_trigger(account_id, AchievementTypes.stat, trigger_id, trigger_value, trigger_params)

	return
	--- END OF BLOCK #0 ---



end

return AchievementTracker
