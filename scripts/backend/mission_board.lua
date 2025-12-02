-- chunkname: @scripts/backend/mission_board.lua

local Promise = require("scripts/foundation/utilities/promise")
local BackendError = require("scripts/managers/error/errors/backend_error")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local PromiseContainer = require("scripts/utilities/ui/promise_container")

local function _filter_backend_unlock_data(backend_data)
	local filtered_progression_data = {}

	for i = 1, #backend_data do
		local data = backend_data[i]

		if data and data.type == "mission" then
			local mission_key = data.key
			local mission_category = data.category

			if not filtered_progression_data[data.type] then
				filtered_progression_data[data.type] = {}
			end

			local filtered_mission_data = filtered_progression_data[data.type]

			if not filtered_mission_data[mission_category] then
				filtered_mission_data[mission_category] = {}
			end

			if not filtered_mission_data[mission_category][mission_key] then
				filtered_mission_data[mission_category][mission_key] = {}
			end

			filtered_mission_data[mission_category][mission_key] = data
		elseif data and data.type == "game_mode" then
			local game_mode_key = data.key

			if not filtered_progression_data[data.type] then
				filtered_progression_data[data.type] = {}
			end

			local game_modes_data = filtered_progression_data[data.type]

			if not game_modes_data[game_mode_key] then
				game_modes_data[game_mode_key] = {}
			end

			game_modes_data[game_mode_key] = data
		elseif data and data.type == "hub_facility" then
			if not filtered_progression_data[data.type] then
				filtered_progression_data[data.type] = {}
			end

			local hub_facilities_data = filtered_progression_data[data.type]
			local facility_key = data.key

			hub_facilities_data[facility_key] = data
		elseif data and data.type == "campaign" then
			if not filtered_progression_data[data.type] then
				filtered_progression_data[data.type] = {}
			end

			local campaigns_data = filtered_progression_data[data.type]
			local campaign_key = data.key

			if not campaigns_data[campaign_key] then
				campaigns_data[campaign_key] = {}
			end

			campaigns_data[campaign_key] = data
		end
	end

	return filtered_progression_data
end

local Interface = {
	"fetch",
	"create_mission",
}
local MissionBoard = class("MissionBoard")
local missionboard_path = "/mission-board"

MissionBoard.init = function (self)
	self._promise_container = PromiseContainer:new()
	self._difficulty_progression_data = {}
	self._progression_unlock_data = {}
	self._cached_progression_data = false
	self._cached_highest_difficulty = {}
	self._campaigns_data = {}
end

MissionBoard.fetch_mission = function (self, mission_id)
	return Managers.backend:title_request(missionboard_path .. "/" .. mission_id):next(function (data)
		return data.body
	end)
end

MissionBoard.fetch = function (self, on_expiry, pause_time)
	return Managers.backend:title_request(missionboard_path):next(function (data)
		data.body.expire_in = BackendUtilities.on_expiry_do(data.headers, on_expiry, pause_time)
		data.body.server_time = data.headers["server-time"]
		data.body.data_age = (data.headers.age or 0) * 1000

		return data.body
	end)
end

MissionBoard.create_mission = function (self, mission_data)
	if not next(mission_data.flags) then
		mission_data.flags = {
			none = {
				none = "test",
			},
		}
	end

	return Managers.backend:title_request(missionboard_path .. "/create", {
		method = "POST",
		body = {
			mission = mission_data,
		},
	}):next(function (data)
		return data.body
	end)
end

MissionBoard.get_rewards = function (self, on_expiry, pause_time)
	return Managers.backend:title_request(missionboard_path .. "/rewards", {
		method = "GET",
	}):next(function (data)
		return data.body
	end)
end

MissionBoard.get_campaigns = function (self)
	local data_path = BackendUtilities.url_builder():path("/data/campaigns")
	local request_option = {
		method = "GET",
	}

	return Managers.backend:title_request(data_path:to_string(), request_option):next(function (data)
		return data.body and data.body.campaigns or {}
	end)
end

MissionBoard.get_unlocked_missions = function (self, account_id, character_id)
	if not account_id or not character_id then
		return nil
	end

	local data_path = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/characters/"):path(character_id):path("/access")
	local request_option = {
		method = "GET",
	}

	return Managers.backend:title_request(data_path:to_string(), request_option):next(function (data)
		return data.body and data.body.access or {}
	end)
end

MissionBoard.get_difficulty_progress = function (self, account_id, character_id)
	if not account_id or not character_id then
		return nil
	end

	local data_path = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/characters/"):path(character_id):path("/difficulty")
	local request_option = {
		method = "GET",
	}

	return Managers.backend:title_request(data_path:to_string(), request_option):next(function (data)
		return data.body and data.body.difficulty or {}
	end)
end

MissionBoard.has_character_been_asked_to_skip_campaign = function (self, account_id, character_id)
	if not account_id or not character_id then
		return nil
	end

	local section_path = "narrative|events"
	local part = "player_journey_option_popup"

	return Managers.backend.interfaces.characters:get_data(character_id, section_path, part):next(function (result)
		return result and (result == true or result == "true")
	end)
end

MissionBoard.is_character_eligible_to_skip_campaign = function (self, account_id, character_id)
	if not account_id or not character_id then
		return nil
	end

	local data_path = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/characters/"):path(character_id):path("/campaigns/player-journey/skip")
	local request_option = {
		method = "GET",
	}

	return Managers.backend:title_request(data_path:to_string(), request_option):next(function (data)
		return data.body and data.body.skippable or false
	end)
end

MissionBoard.skip_and_unlock_campaign = function (self, account_id, character_id)
	if not account_id or not character_id then
		return nil
	end

	local data_path = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/characters/"):path(character_id):path("/campaigns/player-journey/skip")
	local request_options = {
		method = "POST",
		body = {
			player_journey_option_popup = true,
		},
	}

	return Managers.backend:title_request(data_path:to_string(), request_options):next(function (data)
		return self:fetch_player_journey_data(account_id, character_id)
	end):catch(function (error)
		local error_string = tostring(error)

		Log.error("MissionBoard", "MissionBoard:unlock_campaign: error unlocking campaign", error_string)

		return BackendError:new(error_string)
	end)
end

MissionBoard.set_character_has_been_shown_skip_campaign_popup = function (self, account_id, character_id)
	local body = {
		player_journey_option_popup = "true",
	}

	return Managers.backend.interfaces.characters:set_data(character_id, "narrative|events", body):catch(function (error)
		local error_string = tostring(error)

		Log.error("MissionBoard", "MissionBoard:set_character_has_been_shown_skip_campaign_popup: error setting data", error_string)

		return BackendError:new(error_string)
	end)
end

MissionBoard.reset_cached_highest_difficulty = function (self, character_id)
	self._cached_highest_difficulty[character_id] = self._difficulty_progression_data and self._difficulty_progression_data.current.name
end

MissionBoard.fetch_player_journey_data = function (self, account_id, character_id, force_refresh)
	force_refresh = force_refresh ~= false

	if not account_id or not character_id then
		Log.error("MissionBoard", "MissionBoard:fetch_player_journey_data: account_id or character_id is nil")

		return nil
	end

	if force_refresh then
		self:_clear_cached_progression_data()
	end

	if self._cached_progression_data then
		return Promise.resolved()
	end

	local difficulty_progression_data_promise = self._promise_container:cancel_on_destroy(self:get_difficulty_progress(account_id, character_id))
	local progression_unlock_data_promise = self._promise_container:cancel_on_destroy(self:get_unlocked_missions(account_id, character_id))
	local campaigns_data_promise = self._promise_container:cancel_on_destroy(self:get_campaigns())

	return Promise.all(difficulty_progression_data_promise, progression_unlock_data_promise, campaigns_data_promise):next(function (data)
		local difficulty_progression_data, progression_unlock_data, campaigns_data = unpack(data)

		if not difficulty_progression_data or not progression_unlock_data then
			Log.error("MissionBoard", "MissionBoard:fetch_player_journey_data: error fetching data")

			return nil
		end

		self._difficulty_progression_data = difficulty_progression_data

		if not self._cached_highest_difficulty[character_id] then
			self._cached_highest_difficulty[character_id] = difficulty_progression_data and difficulty_progression_data.current.name
		end

		self._progression_unlock_data = progression_unlock_data

		local filtered_progression_data = _filter_backend_unlock_data(progression_unlock_data)

		self._filtered_progression_data = filtered_progression_data
		self._campaigns_data = campaigns_data
		self._cached_progression_data = true
	end):catch(function (error)
		local error_string = tostring(error)

		Log.error("MissionBoard", "MissionBoard:fetch_player_journey_data: error fetching data", error_string)

		return BackendError:new(error_string)
	end)
end

MissionBoard.fetch_character_campaign_skip_data = function (self, account_id, character_id)
	if not account_id or not character_id then
		Log.error("MissionBoard", "MissionBoard:fetch_character_allowed_to_skip_campaign: account_id or character_id is nil")

		return nil
	end

	local has_character_been_asked_to_skip_campaign_promise = self._promise_container:cancel_on_destroy(self:has_character_been_asked_to_skip_campaign(account_id, character_id))
	local is_character_eligible_to_skip_campaign_promise = self._promise_container:cancel_on_destroy(self:is_character_eligible_to_skip_campaign(account_id, character_id))

	Promise.all(has_character_been_asked_to_skip_campaign_promise, is_character_eligible_to_skip_campaign_promise):next(function (data)
		local has_been_asked_to_skip, is_eligible_to_skip = unpack(data)

		self._has_character_been_asked_to_skip = has_been_asked_to_skip
		self._is_character_eligible_to_skip_campaign = is_eligible_to_skip
	end)
end

MissionBoard._clear_cached_progression_data = function (self)
	self._cached_progression_data = false
	self._difficulty_progression_data = {}
	self._progression_unlock_data = {}
	self._filtered_progression_data = {}
end

MissionBoard.get_difficulty_progression_data = function (self)
	return self._difficulty_progression_data
end

MissionBoard.get_new_difficulty_unlocked = function (self, character_id)
	if self._difficulty_progression_data.current then
		return self._cached_highest_difficulty[character_id] and self._cached_highest_difficulty[character_id] ~= self._difficulty_progression_data.current.name
	end
end

MissionBoard.get_progression_unlock_data = function (self)
	return self._progression_unlock_data
end

MissionBoard.get_filtered_missions_data = function (self)
	return self._filtered_progression_data and self._filtered_progression_data.mission or {}
end

MissionBoard.get_filtered_game_modes_data = function (self)
	return self._filtered_progression_data and self._filtered_progression_data.game_mode or {}
end

MissionBoard.get_filtered_hub_facilities_data = function (self)
	return self._filtered_progression_data and self._filtered_progression_data.hub_facility or {}
end

MissionBoard.get_filtered_campaigns_data = function (self)
	return self._filtered_progression_data and self._filtered_progression_data.campaign or {}
end

MissionBoard.has_cached_progression_data = function (self)
	return self._cached_progression_data
end

MissionBoard.get_has_character_been_asked_to_skip_campaign = function (self)
	return self._has_character_been_asked_to_skip
end

MissionBoard.get_is_character_eligible_to_skip_campaign = function (self)
	return self._is_character_eligible_to_skip_campaign
end

MissionBoard.get_campaigns_data = function (self)
	return self._campaigns_data
end

implements(MissionBoard, Interface)

return MissionBoard
