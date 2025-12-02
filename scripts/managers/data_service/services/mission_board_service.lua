-- chunkname: @scripts/managers/data_service/services/mission_board_service.lua

local Havoc = require("scripts/utilities/havoc")
local Promise = require("scripts/foundation/utilities/promise")
local Text = require("scripts/utilities/ui/text")
local CampaignSettings = require("scripts/settings/campaign/campaign_settings")
local Danger = require("scripts/utilities/danger")
local MissionBoardService = class("MissionBoardService")

MissionBoardService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
	self._progression_version = 0
end

MissionBoardService.fetch_mission = function (self, mission_id)
	return self._backend_interface.mission_board:fetch_mission(mission_id)
end

local function format_missions_data(result)
	local missions_data, happening_data = unpack(result, 1, 2)
	local t = Managers.time:time("main")
	local server_time = Managers.backend:get_server_time(t)
	local mission_data_expiry = tonumber(missions_data.refreshAt)

	missions_data.expiry_game_time = (mission_data_expiry - server_time) / 1000 + t

	if happening_data then
		local happening_expiry = tonumber(happening_data.expiry) or 0

		happening_data.expiry_game_time = (happening_expiry - server_time) / 1000 + t
		missions_data.happening = happening_data
	end

	local missions = missions_data.missions

	for i = 1, #missions do
		local mission = missions[i]
		local start = mission.start
		local expiry = mission.expiry

		mission.duration = (expiry - start) / 1000
		mission.expiry_game_time = (tonumber(expiry) - server_time) / 1000 + t
		mission.start_game_time = (tonumber(start) - server_time) / 1000 + t
		mission.required_level = mission.requiredLevel
		mission.side_mission = mission.sideMission
		mission.mission_xp = mission.xp
		mission.mission_reward = mission.credits
		mission.start_server_time = start
		mission.expiry_server_time = expiry

		local flags = mission.flags

		flags.happening_mission = flags.event and flags.altered
	end

	return missions_data
end

MissionBoardService.fetch = function (self, on_expiry, pause_time)
	local missions_promise, happening_promise

	pause_time = pause_time or 1
	missions_promise = self._backend_interface.mission_board:fetch(on_expiry, pause_time)
	happening_promise = self._backend_interface.mission_happenings:fetch_current()

	return Promise.all(missions_promise, happening_promise):next(format_missions_data)
end

MissionBoardService.start_mission = function (self, party_manager, mission_id, private_match, prefered_mission_region)
	return party_manager:wanted_mission_selected(mission_id, private_match, prefered_mission_region)
end

MissionBoardService.get_rewards = function (self)
	return self._backend_interface.mission_board:get_rewards()
end

MissionBoardService.get_unlocked_missions = function (self, account_id, character_id)
	return self._backend_interface.mission_board:get_unlocked_missions(account_id, character_id)
end

MissionBoardService.get_difficulty_progress = function (self, account_id, character_id)
	return self._backend_interface.mission_board:get_difficulty_progress(account_id, character_id)
end

MissionBoardService._refresh_progression_data = function (self)
	self._progression_version = (self._progression_version + 1) % 16
	self._progression_data_tree = self:_build_progression_data_tree(self._backend_interface.mission_board:get_progression_unlock_data())
end

MissionBoardService.progression_version = function (self)
	return self._progression_version
end

MissionBoardService.fetch_player_journey_data = function (self, account_id, character_id, force_refresh)
	return self._backend_interface.mission_board:fetch_player_journey_data(account_id, character_id, force_refresh):next(function ()
		self:_refresh_progression_data()
		self:_build_campaign_order()
	end)
end

MissionBoardService.fetch_character_campaign_skip_data = function (self, account_id, character_id)
	return self._backend_interface.mission_board:fetch_character_campaign_skip_data(account_id, character_id)
end

MissionBoardService.skip_and_unlock_campaign = function (self, account_id, character_id)
	return self._backend_interface.mission_board:skip_and_unlock_campaign(account_id, character_id):next(function ()
		self:_refresh_progression_data()
	end)
end

MissionBoardService.set_character_has_been_shown_skip_campaign_popup = function (self, account_id, character_id)
	return self._backend_interface.mission_board:set_character_has_been_shown_skip_campaign_popup(account_id, character_id)
end

MissionBoardService.get_difficulty_progression_data = function (self)
	return self._backend_interface.mission_board:get_difficulty_progression_data()
end

MissionBoardService.reset_cached_highest_difficulty = function (self, character_id)
	return self._backend_interface.mission_board:reset_cached_highest_difficulty(character_id)
end

MissionBoardService.get_new_difficulty_unlocked = function (self, character_id)
	return self._backend_interface.mission_board:get_new_difficulty_unlocked(character_id)
end

MissionBoardService.is_difficulty_unlocked = function (self, difficulty_name)
	local difficulty_progression_data = self:get_difficulty_progression_data()

	if not difficulty_progression_data then
		Log.warning("MissionBoardService", "Request difficulty unlock information before caching progression data. Assume locked.")

		return false
	end

	local current_difficulty_name = table.nested_get(difficulty_progression_data, "current", "name")

	if not current_difficulty_name then
		Log.warning("MissionBoardService", "Current difficulty not found. Assume locked.")

		return false
	end

	local requested_index = Danger.index_by_name(difficulty_name)
	local current_index = Danger.index_by_name(current_difficulty_name)

	if not requested_index or not current_index then
		Log.warning("MissionBoardService", "Invalid difficulty name. Requested :%s Backend: %s", difficulty_name, current_difficulty_name)

		return false
	end

	return requested_index <= current_index
end

MissionBoardService.get_campaigns_data = function (self)
	return self._backend_interface.mission_board:get_campaigns_data()
end

MissionBoardService.get_progression_unlock_data = function (self)
	return self._backend_interface.mission_board:get_progression_unlock_data()
end

MissionBoardService.get_filtered_missions_data = function (self)
	return self._backend_interface.mission_board:get_filtered_missions_data()
end

MissionBoardService.has_cached_progression_data = function (self)
	return self._backend_interface.mission_board:has_cached_progression_data()
end

MissionBoardService.get_game_modes_progression_data = function (self)
	return self._backend_interface.mission_board:get_filtered_game_modes_data()
end

MissionBoardService.get_hub_facilities_progression_data = function (self)
	return self._backend_interface.mission_board:get_filtered_hub_facilities_data()
end

MissionBoardService.get_is_character_eligible_to_skip_campaign = function (self)
	return self._backend_interface.mission_board:get_is_character_eligible_to_skip_campaign()
end

MissionBoardService.get_has_character_been_asked_to_skip_campaign = function (self)
	return self._backend_interface.mission_board:get_has_character_been_asked_to_skip_campaign()
end

MissionBoardService.is_campaign_active = function (self, campaign_id)
	local campaigns_data = self:get_campaigns_data()

	if not campaigns_data or table.is_empty(campaigns_data) then
		return false
	end

	for _, campaign_data in pairs(campaigns_data) do
		if campaign_data.id == campaign_id then
			if campaign_data.active then
				return true
			else
				return false
			end
		end
	end

	return false
end

MissionBoardService._build_campaign_order = function (self)
	self._campaign_order_cache = {}

	local entries_by_campaign = {}
	local progression_data = self:get_progression_unlock_data()

	for _, entry in ipairs(progression_data) do
		local campaign = entry.campaign

		if campaign then
			if not entries_by_campaign[campaign] then
				entries_by_campaign[campaign] = {}
			end

			table.insert(entries_by_campaign[campaign], entry)
		end
	end

	for campaign, entries in pairs(entries_by_campaign) do
		local lookup = {}

		for _, entry in ipairs(entries) do
			local type = entry.type
			local key = entry.key
			local category = entry.category

			lookup[type] = lookup[type] or {}
			lookup[type][category] = lookup[type][category] or {}
			lookup[type][category][key] = entry
		end

		local degree = {}

		for _, entry in ipairs(entries) do
			degree[entry] = 0

			local prerequisites = entry.prerequisites
			local prerequisites_count = prerequisites and #prerequisites or 0

			for i = 1, prerequisites_count do
				local prerequisite = prerequisites[i]
				local p_campaign = prerequisite.campaign
				local p_type = prerequisite.type
				local p_key = prerequisite.key
				local p_category = prerequisite.category
				local p_entry = table.nested_get(lookup, p_type, p_category, p_key)

				if p_campaign == campaign and p_entry then
					degree[p_entry] = (degree[p_entry] or 0) + 1
				end
			end
		end

		local visit_count, visit_at, to_visit = 0, 0, {}

		for _, entry in ipairs(entries) do
			if degree[entry] == 0 then
				visit_count = visit_count + 1
				to_visit[visit_count] = entry
			end
		end

		while visit_at < visit_count do
			visit_at = visit_at + 1

			local entry = to_visit[visit_at]
			local prerequisites = entry.prerequisites
			local prerequisites_count = prerequisites and #prerequisites or 0

			for i = 1, prerequisites_count do
				local prerequisite = prerequisites[i]
				local p_campaign = prerequisite.campaign
				local p_type = prerequisite.type
				local p_key = prerequisite.key
				local p_category = prerequisite.category
				local p_entry = table.nested_get(lookup, p_type, p_category, p_key)

				if p_campaign == campaign and p_entry then
					degree[p_entry] = degree[p_entry] - 1

					if degree[p_entry] == 0 then
						visit_count = visit_count + 1
						to_visit[visit_count] = p_entry
					end
				end
			end
		end

		local campaign_order = {}

		for i = 1, visit_count do
			local entry = to_visit[visit_count - i + 1]

			campaign_order[i] = {
				type = entry.type,
				key = entry.key,
				category = entry.category,
			}
		end

		self._campaign_order_cache[campaign] = campaign_order
	end
end

MissionBoardService._build_progression_data_tree = function (self, progression_data)
	local tree = {}

	for _, entry in ipairs(progression_data) do
		local type = entry.type
		local key = entry.key
		local category = entry.category or "default"

		if not tree[type] then
			tree[type] = {}
		end

		if not tree[type][category] then
			tree[type][category] = {}
		end

		if tree[type][category][key] then
			Log.warning("MissionBoardService", "Duplicate progression entry found for type: %s, key: %s, category: %s", type, key, category)
		end

		tree[type][category][key] = entry
	end

	return tree
end

MissionBoardService._progression_entry = function (self, type, key, optional_category)
	return table.nested_get(self, "_progression_data_tree", type, optional_category or "default", key)
end

MissionBoardService.index_in_campaign = function (self, type, key, category, campaign)
	local campaign_order = table.nested_get(self, "_campaign_order_cache", campaign)

	if not campaign_order then
		return
	end

	for i = 1, #campaign_order do
		local entry = campaign_order[i]

		if entry.type == type and entry.key == key and entry.category == category then
			return i
		end
	end
end

MissionBoardService.get_block_reason = function (self, type, key, optional_category, force_unknown)
	if self:is_key_unlocked(type, key, optional_category) then
		return
	end

	local progression_entry = self:_progression_entry(type, key, optional_category)

	if not progression_entry then
		Log.warning("MissionBoardService", "Can't get block reason. No progression entry found for type: %s, key: %s, category: %s", type, key, optional_category)

		return "loc_narrative_unknown_lock_reason"
	end

	if force_unknown then
		return "loc_narrative_unknown_lock_reason"
	end

	local required_campaign
	local missing_prerequisites = {}
	local prerequisites = progression_entry.prerequisites
	local prerequisite_count = prerequisites and #prerequisites or 0

	for i = 1, prerequisite_count do
		local prerequisite = prerequisites[i]
		local p_type = prerequisite.type
		local p_key = prerequisite.key
		local p_category = prerequisite.category
		local p_campaign = prerequisite.campaign

		if not self:is_key_completed(p_type, p_key, p_category) then
			local index_in_campaign = self:index_in_campaign(p_type, p_key, p_category, p_campaign)

			if index_in_campaign then
				table.insert(missing_prerequisites, index_in_campaign)
			end

			required_campaign = required_campaign or p_campaign

			if not index_in_campaign or not p_campaign or required_campaign ~= p_campaign then
				return "loc_narrative_unknown_lock_reason"
			end
		end
	end

	if #missing_prerequisites == 0 then
		return "loc_narrative_unknown_lock_reason"
	end

	local campaign_name = CampaignSettings[required_campaign] and CampaignSettings[required_campaign].display_name

	if not campaign_name then
		return "loc_narrative_unknown_lock_reason"
	end

	campaign_name = Localize(campaign_name)

	table.sort(missing_prerequisites)
	table.for_each(missing_prerequisites, Text.convert_to_roman_numerals)

	local chapters = table.concat(missing_prerequisites, ",")

	return "loc_narrative_unknown_campaign_lock_reason", {
		campaign_name = campaign_name,
		chapters = chapters,
	}
end

MissionBoardService.is_key_completed = function (self, type, key, optional_category)
	local progression_entry = self:_progression_entry(type, key, optional_category)

	return progression_entry ~= nil and progression_entry.completed
end

MissionBoardService.is_key_unlocked = function (self, type, key, optional_category)
	local progression_entry = self:_progression_entry(type, key, optional_category)

	return progression_entry ~= nil and progression_entry.unlocked
end

MissionBoardService.get_ordered_campaign_missions = function (self)
	return self._campaign_order_cache
end

return MissionBoardService
