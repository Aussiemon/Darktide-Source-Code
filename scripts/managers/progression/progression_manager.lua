local BackendInterface = require("scripts/backend/backend_interface")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local DummySessionReport = require("scripts/managers/progression/dummy_session_report")
local Progression = require("scripts/backend/progression")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local ItemUtils = require("scripts/utilities/items")

local function _info(...)
	Log.info("ProgressManager", ...)
end

local ProgressionManager = class("ProgressionManager")
local FETCH_DUMMY_SESSION_REPORT = false
local FETCH_DUMMY_SESSION_REPORT_DELAY = {
	max = 5,
	min = 0
}
local SESSION_REPORT_STATES = table.enum("none", "fetching", "success", "fail")
local SET_TRAITS_STATES = table.enum("none", "updating", "success", "fail")

ProgressionManager.init = function (self)
	self._backend_interface = BackendInterface:new()
	self._progression = Progression:new()
	self._session_report_state = SESSION_REPORT_STATES.none
	self._set_traits_state = SET_TRAITS_STATES.none
end

ProgressionManager.destroy = function (self)
	return
end

ProgressionManager.is_fetching_session_report = function (self)
	return self._session_report_state == SESSION_REPORT_STATES.fetching
end

ProgressionManager.session_report_success = function (self)
	return self._session_report_state == SESSION_REPORT_STATES.success
end

ProgressionManager.fetch_session_report = function (self, session_id)
	self._session_report = {
		team = {},
		character = {}
	}
	self._session_report.character.rewards = {}
	self._session_report.account = {
		rewards = {}
	}
	self._session_report.weapon = {}
	self._session_report_state = SESSION_REPORT_STATES.fetching
	local host_type = Managers.multiplayer_session:host_type()

	if host_type ~= MatchmakingConstants.HOST_TYPES.mission_server then
		FETCH_DUMMY_SESSION_REPORT = true
	end

	if GameParameters.testify then
		FETCH_DUMMY_SESSION_REPORT = true
	end

	if not session_id then
		FETCH_DUMMY_SESSION_REPORT = true
	end

	if FETCH_DUMMY_SESSION_REPORT then
		return self:_use_dummy_session_report()
	end

	local profile = self:_get_profile()
	local player = Managers.player:player(Network.peer_id(), 1)
	local participant = player:account_id() .. "|" .. profile.character_id
	local session_report_promise = self._backend_interface.gameplay_session:poll_for_end_of_round(session_id, participant)
	local character_xp_settings_promise = self._progression:get_xp_table("character")
	local account_xp_settings_promise = self._progression:get_xp_table("account")

	_info("Fetching session report...")
	Promise.all(session_report_promise, character_xp_settings_promise, account_xp_settings_promise):next(function (results)
		local session_report, character_xp_settings, account_xp_settings = unpack(results)
		local eor = session_report.eor

		_info("Got session report, parsing it...")
		_info("full_session_report: %s", table.tostring(eor, 9))

		self._session_report.character.experience_settings = self:_parse_experience_settings(character_xp_settings)
		self._session_report.account.experience_settings = self:_parse_experience_settings(account_xp_settings)
		self._session_report.character.experience_settings_unparsed = character_xp_settings
		self._session_report.account.experience_settings_unparsed = account_xp_settings

		self:_parse_report(eor)

		return self._backend_interface.wallet:combined_wallets(player:character_id())
	end):next(function (wallets)
		self._session_report.character.wallets = wallets

		self:_parse_wallets(wallets)
	end):catch(function (errors)
		local error_string = nil

		if type(errors) == "table" then
			local session_report_error, character_xp_error, account_xp_error = unpack(errors)
			error_string = tostring(session_report_error) .. tostring(character_xp_error) .. tostring(account_xp_error)
		else
			error_string = errors
		end

		Log.error("ProgressionManager", "Error fetching session_report: %s", error_string)

		self._session_report_state = SESSION_REPORT_STATES.fail
	end)
end

ProgressionManager._parse_experience_settings = function (self, unparsed_xp_settings)
	for i, level_sum_xp in ipairs(unparsed_xp_settings) do
		local previous_level = i - 1
		local previous_level_sum_xp = previous_level and unparsed_xp_settings[previous_level] or 0
		local level_xp = level_sum_xp - previous_level_sum_xp
	end

	local max_level = #unparsed_xp_settings
	local experience_settings = {
		experience_table = unparsed_xp_settings,
		max_level_experience = unparsed_xp_settings[max_level],
		max_level = max_level
	}

	return experience_settings
end

ProgressionManager._parse_report = function (self, eor)
	local player = Managers.player:player(Network.peer_id(), 1)
	local my_account_id = player:account_id()
	local account_data = self:_get_account_data(eor, my_account_id)

	if not account_data then
		Log.error("ProgressManager", "No account data found for me in session report, account_id: %s", my_account_id)

		self._session_report_state = SESSION_REPORT_STATES.fail

		return
	end

	local progression = self:_get_progression(account_data)

	if not progression then
		Log.error("ProgressionManager", "No progression found for me in session report, account_id: %s", my_account_id)

		self._session_report_state = SESSION_REPORT_STATES.fail

		return
	end

	local inventory = self:_get_inventory(account_data)

	if not inventory then
		Log.error("ProgressionManager", "No inventory found for me in session report, account_id: %s", my_account_id)

		self._session_report_state = SESSION_REPORT_STATES.fail

		return
	end

	self._session_report.character.inventory = inventory
	local character_stats = self:_get_progression_stats(progression, "character")

	if not character_stats then
		Log.error("ProgressionManager", "No character_stats found for me in session report, account_id: %s", my_account_id)

		self._session_report_state = SESSION_REPORT_STATES.fail

		return
	end

	local account_stats = self:_get_progression_stats(progression, "account")

	if not account_stats then
		Log.warning("ProgressionManager", "No account_stats found for me in session report, account_id: %s", my_account_id)

		self._session_report_state = SESSION_REPORT_STATES.fail

		return
	end

	self:_parse_stats(character_stats)
	self:_parse_stats(account_stats)
	self:_parse_mission_stats(eor)
	self:_parse_team_stats(eor)
	self:_parse_reward_cards(account_data)

	local credits_reward = self:_get_credits_reward(account_data.missionRewards)
	self._session_report.credits_reward = credits_reward
	local promise_list = {}
	local character_level_up_promise = self:_check_level_up(character_stats)

	table.insert(promise_list, character_level_up_promise)

	local account_level_up_promise = self:_check_level_up(account_stats)

	table.insert(promise_list, account_level_up_promise)
	Promise.all(unpack(promise_list)):next(function (data)
		if FETCH_DUMMY_SESSION_REPORT then
			self._session_report_state = SESSION_REPORT_STATES.success

			_info("Dummmy session_report fetched and parsed successfully")

			return
		end

		local profile = self:_get_profile()
		local character_id = profile.character_id

		Promise.all(Managers.backend.interfaces.gear:fetch(), Managers.backend.interfaces.progression:get_progression("character", character_id), MasterItems.refresh()):next(function (results)
			local gear_list, character_progression, result = unpack(results)
			profile.current_level = character_progression.currentLevel or 1
			self._session_report_state = SESSION_REPORT_STATES.success

			_info("session_report fetched and parsed successfully")
			_info("session_report: %s", table.tostring(self._session_report, 9))
		end)
	end):catch(function (errors)
		local error_string = nil

		if type(errors) == "table" then
			error_string = table.tostring(errors, 5)
		else
			error_string = errors
		end

		Log.error("ProgressionManager", "Error parsing session_report: %s", error_string)

		self._session_report_state = SESSION_REPORT_STATES.fail
	end)
end

ProgressionManager._parse_wallets = function (self, wallets)
	local session_report_rewards = self._session_report.character.rewards
	local salary_card = nil

	for i = 1, #session_report_rewards do
		local reward_card = session_report_rewards[i]

		if reward_card.kind == "salary" then
			salary_card = reward_card

			break
		end
	end

	local salary_rewards = salary_card and salary_card.rewards

	if salary_rewards then
		for i = 1, #salary_rewards do
			local salary_reward = salary_rewards[i]
			local currency = salary_reward.currency
			local wallet = wallets:by_type(currency)

			if wallet then
				salary_reward.current_amount = wallet.balance.amount
			end
		end
	end
end

ProgressionManager._get_account_data = function (self, eor, my_account_id)
	local team = eor.team
	local participants = team.participants

	for _, participant in ipairs(participants) do
		local participant_account_id = participant.accountId

		if participant_account_id == my_account_id then
			return participant
		end
	end
end

ProgressionManager._get_progression = function (self, account_data)
	return account_data.progression
end

ProgressionManager._get_inventory = function (self, account_data)
	local character_details = account_data.characterDetails

	return character_details and character_details.inventory
end

ProgressionManager._get_credits_reward = function (self, reward_cards)
	if not reward_cards then
		return 0
	end

	local len = #reward_cards

	for i = 1, len do
		local card = reward_cards[i]

		if card.kind == "salary" then
			local rewards = card.rewards
			local reward_len = #rewards

			for j = 1, reward_len do
				local reward = rewards[j]

				if reward.rewardType == "currency" and reward.currency == "credits" then
					return reward.amount
				end

				j = j + 1
			end
		end

		i = i + 1
	end

	return 0
end

ProgressionManager._parse_stats = function (self, stats)
	local start_xp = stats.startXp
	local current_xp = stats.currentXp
	local experience_gained = current_xp - start_xp
	local report_sheet = self._session_report[stats.type]
	report_sheet.starting_experience = start_xp
	report_sheet.current_experience = current_xp
	report_sheet.experience_gained = experience_gained
end

ProgressionManager._get_profile = function (self)
	local profile = Managers.player:local_player_backend_profile()

	if FETCH_DUMMY_SESSION_REPORT and not profile then
		local player = Managers.player:player(Network.peer_id(), 1)
		profile = player:profile()
	end

	return profile
end

ProgressionManager._get_progression_stats = function (self, progression, stat_type)
	for _, stats in ipairs(progression) do
		if stats.type == stat_type then
			return stats
		end
	end
end

ProgressionManager._parse_team_stats = function (self, eor)
	local team = eor.team
	local session_statistics = team.sessionStatistics
	local total_kills = self:_get_session_stat(session_statistics, "stat/minion_kills") or 0
	local total_deaths = self:_get_session_stat(session_statistics, "stat/player_deaths") or 0
	self._session_report.team.total_kills = total_kills
	self._session_report.team.total_deaths = total_deaths
end

ProgressionManager._get_session_stat = function (self, session_statistics, stat_type)
	for i, stat in ipairs(session_statistics) do
		local type_path = stat.typePath

		if type_path == stat_type then
			local value = stat.sessionValue

			return value
		end
	end
end

ProgressionManager._parse_mission_stats = function (self, eor)
	local mission = eor.mission
	local play_time_seconds = mission.playTimeSeconds
	self._session_report.team.play_time_seconds = play_time_seconds
end

ProgressionManager._parse_reward_cards = function (self, account_data)
	local reward_cards = account_data.rewardCards

	if not reward_cards then
		return
	end

	local character_rewards = self._session_report.character.rewards

	assert(character_rewards)
	table.create_copy(character_rewards, reward_cards)

	for i = 1, #character_rewards do
		local reward_card = character_rewards[i]
		local reward_card_rewards = reward_card.rewards

		for j = 1, #reward_card_rewards do
			local reward = reward_card_rewards[j]
			reward.amount_gained = reward.amount or 0
			reward.amount = nil
			reward.reward_type = reward.rewardType
			reward.rewardType = nil
			reward.master_id = reward.masterId
			reward.masterId = nil
			reward.gear_id = reward.gearId
			reward.gearId = nil
			local details = reward.details

			if details then
				details.from_circumstance = details.fromCircumstance
				details.fromCircumstance = nil
				details.from_side_mission = details.fromSideMission
				details.fromSideMission = nil
				details.from_side_mission_bonus = details.fromSideMissionBonus
				details.fromSideMissionBonus = nil
				details.from_total_bonus = details.fromTotalBonus
				details.fromTotalBonus = nil
			end
		end
	end
end

ProgressionManager.session_report = function (self)
	assert(self._session_report_state == SESSION_REPORT_STATES.success, "trying to use session_report before its successfully fetched from the backend")
	_info("Parsed session report has been returned")

	return self._session_report
end

ProgressionManager._check_level_up = function (self, stats)
	if FETCH_DUMMY_SESSION_REPORT then
		_info("Dummy Session report level up completed")

		return Promise.resolved()
	end

	local needed_xp_for_next_level = stats.neededXpForNextLevel

	if needed_xp_for_next_level == 0 then
		local current_level = stats.currentLevel
		local next_level = current_level + 1

		return self:_level_up(stats, next_level)
	end

	if needed_xp_for_next_level == -1 then
		self:_cap_xp(stats)
	end

	_info("Session report " .. stats.type .. " level up completed [id:%s]", stats.id)

	return Promise.resolved()
end

ProgressionManager._level_up = function (self, stats, target_level)
	_info("Leveling up " .. stats.type .. " to %s ...", target_level)

	return self._progression:level_up(stats.type, stats.id, target_level):next(function (data)
		_info("level_up %s: %s", stats.type, table.tostring(data, 6))
		self:_parse_rewards(stats.type, data)

		local progression_info = data.progressionInfo

		return self:_check_level_up(progression_info)
	end):catch(function (error)
		self._session_report_state = SESSION_REPORT_STATES.fail

		_info("Failed level_up, error: %s", error)

		return Promise.rejected(error)
	end)
end

ProgressionManager._parse_rewards = function (self, type, data)
	local rewards = self._session_report[type].rewards
	local reward_info = data.rewardInfo
	local reward_list = reward_info.rewards
	local display_duration = 0.8

	for i, reward in ipairs(reward_list) do
		local reward_type = reward.rewardType

		if reward_type == "item" then
			local reward_item_id = reward.masterId

			if MasterItems.item_exists(reward_item_id) then
				local reward_data = {
					text = "testing testing",
					type = reward_type,
					reward_item_id = reward_item_id,
					duration = display_duration,
					level = reward_info.level
				}

				table.insert(rewards, reward_data)
				ItemUtils.mark_item_id_as_new(reward.gearId)
			else
				Log.error("ProgressionManager", "Recieved invalid item %s as reward from backend", reward_item_id)
			end
		end
	end

	local level_up_to_level = reward_info.level

	self:_add_level_up_reward_to_card(reward_list, level_up_to_level)
end

ProgressionManager._add_level_up_reward_to_card = function (self, reward_list, level_up_to_level)
	local reward_cards = self._session_report.reward_cards

	if not reward_cards then
		return
	end

	for i, card in ipairs(reward_cards) do
		repeat
			local kind = card.kind

			if kind ~= "levelUp" then
				break
			end

			local level = card.level

			if level ~= level_up_to_level then
				break
			end

			card.rewards = reward_list
		until true
	end
end

ProgressionManager._cap_xp = function (self, stats)
	local report_sheet = self._session_report[stats.type]
	local experience_settings = report_sheet.experience_settings_unparsed
	local level = stats.currentLevel
	local max_experience = experience_settings[level]
	local session_starting_experience = report_sheet.starting_experience
	local starting_experience = math.min(session_starting_experience, max_experience)
	local current_experience = math.min(stats.currentXp, max_experience)
	local experience_gained = current_experience - starting_experience
	report_sheet.starting_experience = starting_experience
	report_sheet.current_experience = current_experience
	report_sheet.experience_gained = experience_gained
	report_sheet.max_level_reached = true

	_info("%s is capped at level: %s, xp: %s ", stats.type, level, max_experience)
end

ProgressionManager.get_item_rank = function (self, item)
	return item.weapon_level or 1
end

ProgressionManager.get_traits = function (self, item)
	if not item.bound_traits then
		return
	end

	local bound_traits = table.clone(item.bound_traits)

	return bound_traits
end

ProgressionManager.is_trait_slot_unlocked = function (self, item, slot_index)
	local bound_traits = item.bound_traits

	if not bound_traits then
		return false, 1
	end

	local trait_unlocked_at = slot_index
	local weapon_level = item.weapon_level or math.huge
	local trait_slot_unlocked = trait_unlocked_at <= weapon_level

	return trait_slot_unlocked, trait_unlocked_at
end

ProgressionManager._use_dummy_session_report = function (self)
	self._dummy_session_promise = Promise.new()

	if FETCH_DUMMY_SESSION_REPORT_DELAY.max > 0 then
		local t = Managers.time:time("main")
		local delay = math.random_range(FETCH_DUMMY_SESSION_REPORT_DELAY.min, FETCH_DUMMY_SESSION_REPORT_DELAY.max)

		_info("Fetching dummy session report with delay %s sec", delay)

		self._fetch_session_report_at = t + delay
	else
		self:_fetch_dummy_session_report()
	end

	return self._dummy_session_promise
end

ProgressionManager._fetch_dummy_session_report = function (self)
	local player = Managers.player:player(Network.peer_id(), 1)
	local my_account_id = player and player:account_id()
	local session_report = DummySessionReport.fetch_session_report(my_account_id)
	local character_xp = DummySessionReport.fetch_xp_table("character")
	local account_xp = DummySessionReport.fetch_xp_table("account")
	local inventory = DummySessionReport.fetch_inventory(session_report)
	self._session_report.character.inventory = inventory
	self._session_report.character.experience_settings = self:_parse_experience_settings(character_xp)
	self._session_report.account.experience_settings = self:_parse_experience_settings(account_xp)

	self:_parse_report(session_report)

	self._session_report_state = SESSION_REPORT_STATES.success
	local dummy_wallet = {
		wallets = {
			{
				balance = {
					amount = 12345,
					type = "credits"
				}
			},
			{
				balance = {
					amount = 2345,
					type = "plasteel"
				}
			},
			{
				balance = {
					amount = 25,
					type = "diamantine"
				}
			}
		},
		by_type = function (self, wallet_type)
			if wallet_type == "credits" then
				return self.wallets[1]
			elseif wallet_type == "plasteel" then
				return self.wallets[2]
			elseif wallet_type == "diamantine" then
				return self.wallets[3]
			end
		end
	}
	self._session_report.character.wallets = dummy_wallet

	self:_parse_wallets(dummy_wallet)

	if self._dummy_session_promise then
		self._dummy_session_promise:resolve()
	end
end

ProgressionManager.fetch_dummy_session_report = function (self)
	self._session_report = {
		team = {},
		character = {}
	}
	self._session_report.character.rewards = {}
	self._session_report.account = {
		rewards = {}
	}
	self._session_report.weapon = {}

	self:_fetch_dummy_session_report()

	return self._session_report
end

ProgressionManager.update = function (self, dt, t)
	local fetch_session_report_at = self._fetch_session_report_at

	if fetch_session_report_at and fetch_session_report_at <= t then
		self:_fetch_dummy_session_report()
		_info("Fetch dummy session report completed")

		self._fetch_session_report_at = nil
	end
end

return ProgressionManager
