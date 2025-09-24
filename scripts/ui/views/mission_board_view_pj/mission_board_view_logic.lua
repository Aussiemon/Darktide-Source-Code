-- chunkname: @scripts/ui/views/mission_board_view_pj/mission_board_view_logic.lua

local Danger = require("scripts/utilities/danger")
local DangerSettings = require("scripts/settings/difficulty/danger_settings")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local Promise = require("scripts/foundation/utilities/promise")
local PromiseContainer = require("scripts/utilities/ui/promise_container")
local QPCode = require("scripts/utilities/qp_code")
local Settings = require("scripts/ui/views/mission_board_view_pj/mission_board_view_settings")
local MAX_DISPLAYED_STORY_MISSIONS = 3

local function _filter_backend_missions(missions)
	local filtered_count, filtered_missions = 0, {}

	for _, mission in pairs(missions) do
		local is_ok = true
		local map_name = mission.map
		local has_template = not not rawget(MissionTemplates, map_name)

		if not has_template then
			Log.exception("MissionBoardView", "Got mission from backend that doesn't exist locally '%s'", map_name)

			is_ok = false
		end

		if is_ok then
			filtered_count = filtered_count + 1
			filtered_missions[filtered_count] = mission
		end
	end

	return filtered_missions
end

local function _character_save_data()
	local local_player_id = 1
	local player_manager = Managers.player
	local player = player_manager and player_manager:local_player(local_player_id)
	local character_id = player and player:character_id()
	local save_manager = Managers.save
	local character_data = character_id and save_manager and save_manager:character_data(character_id)

	return character_data
end

local function _ignore_player_journey()
	return false
end

local MissionBoardViewLogic = class("MissionBoardViewLogic")

MissionBoardViewLogic.init = function (self, context)
	self._promise_container = PromiseContainer:new()
	self._has_synced = false

	local character_save_data = _character_save_data()

	self._save_data = character_save_data.mission_board
	self._is_private = self._save_data.private_match
	self._page_index = self._save_data.page_index or 1
	self._quickplay_into_narrative = self._save_data.quickplay_into_narrative
	self._view_name = context.view_name

	local player = context.player

	self._player = player

	local profile = player:profile()

	self._player_level = profile.current_level

	local account_id = player:account_id()
	local character_id = player:character_id()
	local region_promise = self:_setup_regions()
	local bonus_promise = self:_setup_bonus_config()
	local progression_promise = self:_fetch_progression_data(account_id, character_id)

	Promise.all(progression_promise, region_promise, bonus_promise):next(callback(self, "_config_success"), callback(self, "_config_failure"))

	self._filtered_missions = {}
	self._backend_unlock_missions = {}
	self._difficulty_progress_data = {}
	self._config_done = false
end

MissionBoardViewLogic._fetch_progression_data = function (self, account_id, character_id)
	return self._promise_container:cancel_on_destroy(Managers.data_service.mission_board:fetch_player_journey_data(account_id, character_id, false))
end

MissionBoardViewLogic.update = function (self, dt, t)
	self:_update_page(t)
	self:_update_backend_data(t)
end

MissionBoardViewLogic.destroy = function (self)
	local save_data = self._save_data

	if save_data then
		save_data.private_match = self._is_private
		save_data.page_index = self._page_index
		save_data.quickplay_into_narrative = self._quickplay_into_narrative

		Managers.save:queue_save()
	end

	self._promise_container:delete()
end

MissionBoardViewLogic._update_backend_data = function (self, t)
	if not self._config_done then
		return
	end

	local backend_expiry_time = self._backend_expiry_time

	if backend_expiry_time and t < backend_expiry_time then
		return
	end

	local fetching_missions = self._fetching_missions

	if fetching_missions then
		return
	end

	local mission_data = self._mission_data
	local backend_mission_count = mission_data and #mission_data or 0

	for i = 1, backend_mission_count do
		local mission = mission_data[i]
		local mission_start_time = mission.start_game_time

		if t < mission_start_time then
			return
		end
	end

	self._fetching_missions = true

	local mission_promise = self._promise_container:cancel_on_destroy(Managers.data_service.mission_board:fetch(nil, 1))

	Promise.all(mission_promise):next(callback(self, "_on_missions_data_fetch_success"), callback(self, "_on_missions_data_fetch_failure"))
end

MissionBoardViewLogic._update_page = function (self, t)
	local current_page_index = self._page_index
	local requested_page_index = self._requested_page_index

	if requested_page_index and requested_page_index ~= current_page_index then
		if self:page_is_unlocked(requested_page_index) then
			self._page_index = requested_page_index
		else
			self._requested_page_index = nil
		end
	end
end

MissionBoardViewLogic._setup_bonus_config = function (self)
	self._bonus_data = {}

	return self._promise_container:cancel_on_destroy(Managers.data_service.mission_board:get_rewards()):next(function (bonus_data)
		local filtered_bonus_data = {}

		for mission_type, values in pairs(bonus_data) do
			for type, value in pairs(values) do
				local percentile_value = math.floor(value * 100 - 100)

				if percentile_value > 0 then
					filtered_bonus_data[mission_type] = filtered_bonus_data[mission_type] or {}
					filtered_bonus_data[mission_type][type] = percentile_value
				end
			end
		end

		self._bonus_data = filtered_bonus_data
	end)
end

MissionBoardViewLogic._setup_regions = function (self)
	return self._promise_container:cancel_on_destroy(Managers.data_service.region_latency:fetch_regions_latency()):next(function (regions_latency)
		self._regions_latency = regions_latency
	end)
end

MissionBoardViewLogic._request_page = function (self, index)
	local page_settings = self._page_settings
	local page_setting = page_settings[index]

	if not page_setting then
		return
	end

	if self:page_is_unlocked(index) then
		self._requested_page_index = index
	end
end

MissionBoardViewLogic.get_requested_page_index = function (self)
	return self._requested_page_index
end

MissionBoardViewLogic.get_current_page_index = function (self)
	return self._page_index
end

MissionBoardViewLogic.get_page_settings = function (self)
	return self._page_settings
end

MissionBoardViewLogic.has_synced_missions_data = function (self)
	return self._has_synced
end

MissionBoardViewLogic.get_missions_data = function (self)
	return self._mission_data
end

MissionBoardViewLogic.get_filtered_missions = function (self)
	return self._filtered_missions
end

MissionBoardViewLogic.get_mission_data_by_id = function (self, mission_id)
	if self._mission_data then
		for i = 1, #self._mission_data do
			local mission = self._mission_data[i]

			if mission.id == mission_id then
				return mission
			end
		end
	end

	return nil
end

MissionBoardViewLogic.get_current_page = function (self, page_index)
	local page_settings = self._page_settings

	return page_settings and page_settings[page_index or self._page_index]
end

MissionBoardViewLogic.get_last_unlocked_page = function (self, page_settings)
	local page_settings = page_settings or self._page_settings

	if not page_settings then
		return nil
	end

	local at = #page_settings

	while at >= 1 and not self:page_is_unlocked(at, page_settings) do
		at = at - 1
	end

	return at
end

MissionBoardViewLogic.request_prev_page = function (self)
	local current_page = self:get_current_page()

	if current_page and current_page.prev_page_index then
		self:_request_page(current_page.prev_page_index)
	end
end

MissionBoardViewLogic.request_next_page = function (self)
	local current_page = self:get_current_page()

	if current_page and current_page.next_page_index then
		self:_request_page(current_page.next_page_index)
	end
end

MissionBoardViewLogic.request_page_at = function (self, index)
	self:_request_page(index)
end

MissionBoardViewLogic.get_bonus_data = function (self, category)
	if not category then
		return nil
	end

	local bonus_data = self._bonus_data[category]

	return bonus_data and bonus_data or nil
end

MissionBoardViewLogic.get_threat_level_progress = function (self)
	local return_table = {}
	local difficulty_progress_data = self._difficulty_progress_data

	if not difficulty_progress_data then
		return nil
	end

	local current_difficulty = difficulty_progress_data.current
	local next_difficulty = difficulty_progress_data.next
	local current_progress = next_difficulty and next_difficulty.progress or 0
	local target_progress = next_difficulty and next_difficulty.target or 0
	local current_difficulty_progress = 0

	current_difficulty_progress = target_progress == 0 and 1 or math.clamp(current_progress / target_progress, 0, 1)
	return_table.progress = current_difficulty_progress
	return_table.current = current_progress
	return_table.target = target_progress
	return_table.current_difficulty = current_difficulty and current_difficulty.name or "n/a"
	return_table.next_difficulty = next_difficulty and next_difficulty.name or "n/a"

	return return_table
end

MissionBoardViewLogic.get_bonus_range = function (self, category)
	local bonus_data = self._bonus_data[category]

	if not bonus_data then
		return nil, nil
	end

	local lo, hi

	for _, percentile_value in pairs(bonus_data) do
		lo = (lo == nil or percentile_value < lo) and percentile_value or lo
		hi = (hi == nil or hi < percentile_value) and percentile_value or hi
	end

	return lo, hi
end

MissionBoardViewLogic.is_mission_locked = function (self, mission)
	local mission_key = mission.map
	local mission_category = mission.category
	local is_locked = true
	local mission_unlock_data = self:get_mission_unlock_data(mission_key, mission_category)

	if not mission_unlock_data then
		return is_locked
	end

	if mission_unlock_data.unlocked == true then
		is_locked = false
	end

	return is_locked
end

MissionBoardViewLogic.get_mission_unlock_data = function (self, mission_key, mission_category)
	if not mission_key or not mission_category then
		Log.warning("MissionBoardView", "Trying to get mission unlock data with invalid key or category. key: %s, category: %s", tostring(mission_key), tostring(mission_category))

		return nil
	end

	local backend_unlock_mission = self._backend_unlock_missions

	if not backend_unlock_mission then
		return nil
	end

	local mission_category_data = backend_unlock_mission[mission_category]

	if not mission_category_data then
		return nil
	end

	local mission_data = mission_category_data[mission_key]

	if not mission_data then
		return nil
	end

	return mission_data
end

MissionBoardViewLogic.refresh_filtered_missions = function (self)
	local mission_data = self._mission_data
	local page_settings = self:get_current_page()
	local filtered_missions = self._filtered_missions

	if not mission_data or not page_settings then
		table.clear(filtered_missions)

		return
	end

	local included_ids = {}
	local filters = {
		page_settings.filter,
	}

	for _, mission in ipairs(mission_data) do
		local id = mission.id
		local on_page = self:_mission_passes_all_filters(mission, filters)
		local should_include = on_page and self:_should_show_mission(mission)

		included_ids[id] = should_include

		if should_include and not filtered_missions[id] then
			filtered_missions[id] = mission
		end
	end

	for id, _ in pairs(filtered_missions) do
		if not included_ids[id] then
			filtered_missions[id] = nil
		end
	end

	self:_remove_unwanted_missions(filtered_missions)
end

MissionBoardViewLogic._remove_unwanted_missions = function (self, missions)
	local story_missions = self:_get_missions_per_category("story")

	if not story_missions then
		return
	end

	local ordered_story_missions = self._ordered_story_missions

	if not ordered_story_missions then
		return
	end

	local first_unlocked_index = -1

	for i = 1, #ordered_story_missions do
		local ordered_mission = ordered_story_missions[i]
		local mission_key = ordered_mission.key
		local mission = story_missions[mission_key]

		if mission.unlocked == true and mission.completed == false then
			first_unlocked_index = i

			break
		end
	end

	if first_unlocked_index == -1 then
		return
	end

	local first_locked_index, second_locked_index

	for i = first_unlocked_index, #ordered_story_missions do
		local ordered_mission = ordered_story_missions[i]
		local mission_key = ordered_mission.key
		local mission = story_missions[mission_key]

		if mission.unlocked == false then
			if not first_locked_index then
				first_locked_index = i
			else
				second_locked_index = second_locked_index or i
			end
		end
	end

	local max_allowed_index = MAX_DISPLAYED_STORY_MISSIONS

	if second_locked_index then
		max_allowed_index = second_locked_index - first_unlocked_index + 1
	end

	local allowed_story_missions = table.slice(ordered_story_missions, first_unlocked_index, max_allowed_index)

	for mission_id, mission in pairs(missions) do
		if mission.category == "story" then
			local mission_map = mission.map
			local is_mission_allowed = false

			for i = 1, #allowed_story_missions do
				local allowed_mission = allowed_story_missions[i].key

				if mission_map == allowed_mission then
					is_mission_allowed = true

					break
				end
			end

			if not is_mission_allowed then
				missions[mission_id] = nil
			end
		elseif mission.category == "common" then
			local mission_map = mission.map
			local is_mission_allowed = true

			for i = 1, #allowed_story_missions do
				local allowed_mission = allowed_story_missions[i].key

				if mission_map == allowed_mission then
					is_mission_allowed = false

					break
				end
			end

			if not is_mission_allowed then
				missions[mission_id] = nil
			end
		end
	end

	self._filtered_missions = missions
end

MissionBoardViewLogic.get_region_latencies = function (self)
	return self._regions_latency
end

MissionBoardViewLogic.start_mission_matchmaking = function (self, party_manager, selected_mission_id)
	local prefered_mission_region = Managers.data_service.region_latency:get_prefered_mission_region()

	Managers.data_service.mission_board:start_mission(party_manager, selected_mission_id, self._is_private, prefered_mission_region)

	return true
end

MissionBoardViewLogic.start_quickplay_matchmaking = function (self, party_manager, categories)
	local page_settings = self:get_current_page()
	local qp_settings = page_settings and page_settings.qp

	if not qp_settings then
		return false
	end

	qp_settings = table.clone(qp_settings)
	qp_settings.category = self:_get_quickplay_categories(qp_settings.category)

	local qp_string = QPCode.encode(qp_settings)
	local prefered_mission_region = Managers.data_service.region_latency:get_prefered_mission_region()

	Managers.data_service.mission_board:start_mission(party_manager, qp_string, self._is_private, prefered_mission_region)
	Log.info("MissionBoardViewLogic", "Requesting qp with key %s.", qp_string)

	return true
end

MissionBoardViewLogic.set_private_matchmaking = function (self, value)
	self._is_private = value
end

MissionBoardViewLogic.is_private_match = function (self)
	return self._is_private
end

MissionBoardViewLogic.set_quickplay_into_narrative = function (self, value)
	self._quickplay_into_narrative = value
end

MissionBoardViewLogic.get_quickplay_into_narrative = function (self)
	return not not self._quickplay_into_narrative
end

MissionBoardViewLogic._annotate_pages = function (self)
	local pages = self._page_settings
	local prev_unlocked_index

	for i = 1, #pages do
		local page_setting = pages[i]
		local is_unlocked = self:page_is_unlocked(i)

		page_setting.is_unlocked = is_unlocked
		page_setting.prev_page_index = nil
		page_setting.next_page_index = nil

		if is_unlocked then
			page_setting.prev_page_index = prev_unlocked_index

			if prev_unlocked_index then
				pages[prev_unlocked_index].next_page_index = i
			end

			prev_unlocked_index = i
		end
	end
end

MissionBoardViewLogic.get_quickplay_unlock_status = function (self)
	local game_modes_data = Managers.data_service.mission_board:get_game_modes_progression_data()
	local quickplay_data = game_modes_data and game_modes_data.quickplay

	if not quickplay_data then
		return false
	end

	local quickplay_unlocked = quickplay_data.unlocked
	local prerequisites = quickplay_data.prerequisites or {}

	return quickplay_unlocked, prerequisites
end

MissionBoardViewLogic._get_ordered_story_missions = function (self, campaign_id)
	local campaign_ordered_missions = Managers.data_service.mission_board:get_ordered_campaign_missions()

	if campaign_id then
		if not campaign_ordered_missions[campaign_id] then
			Log.warning("MissionBoardViewLogic", "No ordered missions found for campaign_id: %s", tostring(campaign_id))
		end

		return campaign_ordered_missions[campaign_id] or {}
	else
		return campaign_ordered_missions["player-journey"] or {}
	end
end

MissionBoardViewLogic.get_campaign_mission_display_order = function (self, mission_key, mission_category)
	if not mission_key or not mission_category then
		Log.warning("MissionBoardView", "Trying to get campaign mission display order with invalid key or category. key: %s, category: %s", tostring(mission_key), tostring(mission_category))

		return nil
	end

	return Managers.data_service.mission_board:index_in_campaign("mission", mission_key, mission_category, "player-journey")
end

MissionBoardViewLogic.get_random_mission = function (self)
	local filtered_missions = self._filtered_missions

	if not filtered_missions or table.is_empty(filtered_missions) then
		return nil
	end

	local size = table.size(filtered_missions)

	if size == 0 then
		return nil
	end

	local random_index = math.random(1, size)
	local count = 1

	for mission_id, mission in pairs(filtered_missions) do
		if count == random_index then
			return mission
		end

		count = count + 1
	end

	return nil
end

MissionBoardViewLogic._get_missions_per_category = function (self, category)
	return self._backend_unlock_missions[category] or {}
end

MissionBoardViewLogic._get_quickplay_categories = function (self, categories)
	if categories then
		return categories
	end

	local qp_categories = {
		"common",
		"event",
	}

	if self._quickplay_into_narrative then
		qp_categories[#qp_categories + 1] = "story"
	end

	return qp_categories
end

MissionBoardViewLogic.page_is_unlocked = function (self, page_index, page_settings)
	page_settings = page_settings or self._page_settings

	local page_setting = page_settings[page_index]

	if not page_setting then
		return false
	end

	return page_setting.check_unlocked and page_setting.check_unlocked(self) or page_setting.is_unlocked
end

local function level_matches_unlock(difficulty_data, current_difficulty)
	local challenge = difficulty_data.challenge
	local resistance = difficulty_data.resistance

	return challenge <= current_difficulty.challenge and resistance <= current_difficulty.resistance
end

local function level_is_at_least(level)
	return function (parent)
		return parent._player_level >= level
	end
end

local function _pages_from_difficulty()
	local pages = {}

	for i, difficulty_data in ipairs(DangerSettings) do
		local is_auric = difficulty_data.name == "auric"
		local unlocks_at_level = Danger.required_level_by_mission_type(i)

		pages[i] = {
			loc_name = difficulty_data.display_name,
			ui_theme = is_auric and "auric" or "default",
			check_unlocked = level_is_at_least(unlocks_at_level or 1),
			filter = {
				challenge = difficulty_data.challenge,
				resistance = difficulty_data.resistance,
				category_blacklist = {
					"horde",
				},
			},
			qp = {
				challenge = difficulty_data.challenge,
			},
		}
	end

	return pages
end

local function _populate_pages(missions, difficulty_progress_data)
	local pages = {}
	local page_index = 1
	local current_difficulty = difficulty_progress_data.current

	for i, difficulty_data in ipairs(DangerSettings) do
		local is_auric = difficulty_data.name == "auric"

		pages[i] = {
			loc_name = difficulty_data.display_name,
			ui_theme = is_auric and "auric" or "default",
			is_unlocked = level_matches_unlock(difficulty_data, current_difficulty),
			filter = {
				challenge = difficulty_data.challenge,
				resistance = difficulty_data.resistance,
				category_blacklist = {
					"horde",
				},
			},
			qp = {
				challenge = difficulty_data.challenge,
				resistance = difficulty_data.resistance,
			},
		}
	end

	return pages
end

MissionBoardViewLogic._should_show_mission = function (self, mission)
	local mission_data = self:get_mission_unlock_data(mission.map, mission.category)

	if mission.category == "story" and self:_is_story_mission_complete(mission) then
		return false
	end

	if mission.category == "common" and mission.unlocked == true then
		return true
	end

	local prerequisites = mission_data and mission_data.prerequisites
	local prerequisites_fullfilled = true

	if prerequisites and not table.is_empty(prerequisites) then
		for _, prerequisite in ipairs(prerequisites) do
			local mission_key = prerequisite.key
			local mission_category = prerequisite.category
			local mission_data = self:get_mission_unlock_data(mission_key, mission_category)

			if not mission_data then
				prerequisites_fullfilled = false

				break
			end

			if mission_data.unlocked and mission_data.unlocked == false then
				prerequisites_fullfilled = false

				break
			end

			if mission_data.completed and mission_data.completed == false then
				prerequisites_fullfilled = false

				break
			end
		end
	end

	return prerequisites_fullfilled
end

MissionBoardViewLogic.get_missions_by_filters = function (self, filters)
	local missions_t = {}
	local missions = self._mission_data

	if table.is_empty(missions) then
		return missions_t
	end

	if not filters or table.is_empty(filters) then
		return missions_t
	end

	for _, mission in ipairs(missions) do
		local id = mission.id

		if self:_mission_passes_all_filters(mission, filters) then
			missions_t[id] = mission
		end
	end

	return missions_t
end

MissionBoardViewLogic._mission_passes_filter = function (self, mission, filter)
	if filter.category_blacklist and table.array_contains(filter.category_blacklist, mission.category) then
		return false
	end

	if filter.required_category and not table.array_contains(filter.required_category, mission.category) then
		return false
	end

	if filter.resistance and mission.resistance ~= filter.resistance then
		return false
	end

	if filter.challenge and mission.challenge ~= filter.challenge then
		return false
	end

	local mission_unlock_data = self:get_mission_unlock_data(mission.map, mission.category)

	if not mission_unlock_data then
		return false
	end

	if filter.required_campaign and not table.array_contains(filter.required_campaign, mission_unlock_data.campaign) then
		return false
	end

	if filter.unlocked and mission_unlock_data.unlocked ~= filter.unlocked then
		return false
	end

	return true
end

MissionBoardViewLogic._is_story_mission_complete = function (self, mission)
	if mission.category ~= "story" then
		return false
	end

	local mission_key = mission.map
	local mission_unlock_data = self:get_mission_unlock_data(mission_key, mission.category)

	if not mission_unlock_data then
		return false
	end

	if mission_unlock_data.unlocked == true and mission_unlock_data.completed == true then
		return true
	end

	return false
end

MissionBoardViewLogic._mission_passes_filters = function (self, mission, filters, target, exact)
	target, exact = target or #filters, exact == true

	local count = 0

	for _, filter in ipairs(filters) do
		if self:_mission_passes_filter(mission, filter) then
			count = count + 1
		end

		if exact and target < count then
			return false
		end

		if not exact and target <= count then
			return true
		end
	end

	return count == target
end

MissionBoardViewLogic._mission_passes_all_filters = function (self, mission, filters)
	return self:_mission_passes_filters(mission, filters, #filters, false)
end

MissionBoardViewLogic._on_missions_data_fetch_success = function (self, results)
	local mission_data = unpack(results)

	self._fetching_missions = false
	self._backend_expiry_time = mission_data.expiry_game_time
	self._mission_data = _filter_backend_missions(mission_data.missions)

	local difficulty_progress_data = self._difficulty_progress_data
	local page_settings = _populate_pages(mission_data.missions, difficulty_progress_data)
	local page_index = self._page_index
	local page_setting = page_settings[page_index]

	if page_setting and page_setting.is_unlocked then
		self._page_index = page_index
	else
		self._page_index = self:get_last_unlocked_page(page_settings) or 1
	end

	self._page_settings = page_settings

	self:_annotate_pages()
	self:refresh_filtered_missions()

	self._has_synced = true
end

MissionBoardViewLogic._on_missions_data_fetch_failure = function (self)
	Log.warning("MissionBoardView", "Failed to download mission data. Will retry in %d seconds", Settings.fetch_retry_cooldown)

	self._backend_expiry_time = Managers.time:time("main") + Settings.fetch_retry_cooldown
	self._fetching_missions = false
	self._has_synced = false
end

MissionBoardViewLogic._config_success = function (self, config_results)
	local has_cached_progression_data = Managers.data_service.mission_board:has_cached_progression_data()

	self._has_cached_progression_data = has_cached_progression_data
	self._backend_unlock_missions = Managers.data_service.mission_board:get_filtered_missions_data()
	self._difficulty_progress_data = Managers.data_service.mission_board:get_difficulty_progression_data()
	self._ordered_story_missions = self:_get_ordered_story_missions()
	self._config_done = true
end

MissionBoardViewLogic._config_failure = function (self, errors)
	local error_message = Localize("loc_popup_description_backend_error")

	Managers.event:trigger("event_add_notification_message", "alert", {
		text = error_message,
	})

	self._config_done = false

	Managers.ui:close_view(self._view_name)
end

return MissionBoardViewLogic
