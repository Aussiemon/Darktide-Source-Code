local SessionStats = require("scripts/managers/stats/groups/session_stats")
local StatFlags = require("scripts/settings/stats/stat_flags")
local SessionStatTracker = class("SessionStatTracker")

SessionStatTracker.init = function (self)
	self._tracked = {}
end

SessionStatTracker.track = function (self, player)
	local character_id = player:character_id()

	if not math.is_uuid(character_id) then
		Log.warning("SessionStatTracker", "Can't track stats for player with invalid character id '%s'.", character_id)

		return false
	end

	if not self._tracked[character_id] then
		Log.info("SessionStatTracker", "Start tracking session stats for '%s'.", character_id)

		self._tracked[character_id] = {
			account_id = player:account_id(),
			character_id = player:character_id(),
			stat_id = Managers.stats:add_tracker(self, player, SessionStats)
		}
	end

	return true
end

local function _get_data_type(stat_definition)
	if stat_definition:check_flag(StatFlags.ephemeral) then
		return "Ephemeral"
	end

	if stat_definition:check_flag(StatFlags.statistic_to) then
		return "StatisticTo"
	end

	if stat_definition:check_flag(StatFlags.statistic_by) then
		return "StatisticBy"
	end

	return "StatisticBy"
end

local function _create_numeric_event(account_id, character_id, stat_id, raw_data)
	local stat_definition = SessionStats.definitions[stat_id]

	return {
		accountId = account_id,
		characterId = character_id,
		dataType = _get_data_type(stat_definition),
		type = stat_id,
		value = {
			none = raw_data
		}
	}
end

local function _visit_node(values, params, param_names, node)
	for param, value in pairs(node) do
		local param_size = #params
		params[param_size + 1] = string.format("%s:%s", param_names[param_size + 1], param)

		if type(value) ~= "table" then
			values[table.concat(params, "|")] = value
		else
			_visit_node(values, params, param_names, value)
		end

		params[param_size + 1] = nil
	end
end

local function _create_tree_event(account_id, character_id, stat_id, raw_data)
	local stat_definition = SessionStats.definitions[stat_id]
	local values = {}
	local params = {}

	_visit_node(values, params, stat_definition:get_parameters(), raw_data)

	return {
		accountId = account_id,
		characterId = character_id,
		dataType = _get_data_type(stat_definition),
		type = stat_id,
		value = values
	}
end

local function _append_events(events, account_id, character_id, stat_data)
	local event_size = #events

	for _, stat_definition in pairs(SessionStats.definitions) do
		if stat_definition:check_flag(StatFlags.save_to_backend) then
			local raw_data = stat_definition:get_raw(stat_data)
			local raw_type = type(raw_data)

			if raw_type == "number" then
				local next_index = event_size + 1
				events[next_index] = _create_numeric_event(account_id, character_id, stat_definition:get_id(), raw_data)
				event_size = next_index
			end

			if raw_type == "table" then
				local next_index = event_size + 1
				events[next_index] = _create_tree_event(account_id, character_id, stat_definition:get_id(), raw_data)
				event_size = next_index
			end
		end
	end
end

SessionStatTracker.push_all = function (self, session_id)
	local events = {}

	for _, tracked_data in pairs(self._tracked) do
		local stat_data = Managers.stats:remove_tracker(tracked_data.stat_id)

		_append_events(events, tracked_data.account_id, tracked_data.character_id, stat_data)
	end

	self._tracked = {}

	return Managers.backend.interfaces.gameplay_session:events(session_id, events)
end

return SessionStatTracker
