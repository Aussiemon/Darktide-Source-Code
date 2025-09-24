-- chunkname: @scripts/managers/progression/progression_manager.lua

local BackendInterface = require("scripts/backend/backend_interface")
local DummySessionReport = require("scripts/managers/progression/dummy_session_report")
local EndPlayerViewAnimations = require("scripts/ui/views/end_player_view/end_player_view_animations")
local EndPlayerViewSettings = require("scripts/ui/views/end_player_view/end_player_view_settings")
local EndViewSettings = require("scripts/ui/views/end_view/end_view_settings")
local Items = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Mastery = require("scripts/utilities/mastery")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local Progression = require("scripts/backend/progression")
local Promise = require("scripts/foundation/utilities/promise")
local WeaponUnlockSettings = require("scripts/settings/weapon_unlock/weapon_unlock_settings")

local function _info(...)
	Log.info("ProgressionManager", ...)
end

local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local ProgressionManager = class("ProgressionManager")
local FETCH_DUMMY_SESSION_REPORT = false
local FETCH_DUMMY_SESSION_REPORT_DELAY = {
	max = 5,
	min = 0,
}
local SESSION_REPORT_STATES = table.enum("none", "fetching", "success", "fail")
local SET_TRAITS_STATES = table.enum("none", "updating", "success", "fail")
local FAILED_FETCHING_SESSION_REPORT = false

ProgressionManager.init = function (self)
	self._backend_interface = BackendInterface:new()
	self._progression = Progression:new()
	self._session_report_state = SESSION_REPORT_STATES.none
	self._set_traits_state = SET_TRAITS_STATES.none
end

ProgressionManager.destroy = function (self)
	return
end

ProgressionManager.clear_session_report = function (self)
	self._session_report_state = SESSION_REPORT_STATES.none
	self._set_traits_state = SET_TRAITS_STATES.none
	self._session_report = {}
	self._game_score_end_time = nil
end

ProgressionManager.fetching_session_report_not_started = function (self)
	return self._session_report_state == SESSION_REPORT_STATES.none
end

ProgressionManager.is_fetching_session_report = function (self)
	return self._session_report_state == SESSION_REPORT_STATES.fetching
end

ProgressionManager.session_report_success = function (self)
	return self._session_report_state == SESSION_REPORT_STATES.success
end

ProgressionManager.session_report_fail = function (self)
	return self._session_report_state == SESSION_REPORT_STATES.fail
end

ProgressionManager.is_using_dummy_report = function (self)
	return self._session_report_is_dummy
end

ProgressionManager.fetch_session_report = function (self, session_id)
	self._session_report = {}
	self._session_report.team = {}
	self._session_report.character = {}
	self._session_report.character.rewards = {}
	self._session_report.account = {}
	self._session_report.account.rewards = {}
	self._game_score_end_time = nil
	self._session_report_is_dummy = false
	self._session_report_state = SESSION_REPORT_STATES.fetching

	if self:_should_use_dummy_session_report(session_id) then
		return self:_use_dummy_session_report()
	end

	local profile = self:_get_profile()
	local player = Managers.player:player(Network.peer_id(), 1)
	local participant = player:account_id() .. "|" .. profile.character_id
	local session_report_promise = self._backend_interface.gameplay_session:poll_for_end_of_round(session_id, participant)
	local character_xp_settings_promise = self._progression:get_xp_table("character")
	local account_xp_settings_promise = self._progression:get_xp_table("account")
	local account_wallet_promise = Managers.data_service.store:combined_wallets()

	_info("Fetching session report for session %s...", session_id)
	Promise.all(session_report_promise, character_xp_settings_promise, account_xp_settings_promise, account_wallet_promise):next(function (results)
		local session_report, character_xp_settings, account_xp_settings, account_wallets = unpack(results, 1, 4)
		local eor = session_report.eor

		self._session_report.eor = eor

		_info("Got session report, parsing it...")

		self._session_report.character.experience_settings = self:_parse_experience_settings(character_xp_settings)
		self._session_report.account.experience_settings = self:_parse_experience_settings(account_xp_settings)
		self._session_report.character.experience_settings_unparsed = character_xp_settings
		self._session_report.account.experience_settings_unparsed = account_xp_settings

		self:_parse_report(eor, account_wallets)
	end):catch(function (errors)
		local error_string

		if type(errors) == "table" then
			local session_report_error, character_xp_error, account_xp_error = unpack(errors)

			error_string = tostring(session_report_error) .. tostring(character_xp_error) .. tostring(account_xp_error)
		else
			error_string = errors
		end

		Log.error("ProgressionManager", "Error fetching session_report: %s", error_string)

		self._session_report_state = SESSION_REPORT_STATES.fail

		Managers.mechanism:trigger_event("failed_fetching_session_report", Network.peer_id(), FAILED_FETCHING_SESSION_REPORT)
		Managers.multiplayer_session:leave("failed_fetching_session_report")
	end)
end

ProgressionManager.fetch_session_report_server = function (self, session_id)
	self._session_report = {}
	self._game_score_end_time = nil
	self._session_report_state = SESSION_REPORT_STATES.fetching

	if self:_should_use_dummy_session_report(session_id) then
		self:_use_dummy_session_report_server()
		self:_calculate_game_score_end()
		self:_sync_game_score_end_time()

		return
	end

	_info("Fetching session report server...")
	self._backend_interface.gameplay_session:poll_for_end_of_round(session_id):next(function (session_report)
		local eor = session_report.eor

		self._session_report.eor = eor

		_info("Got session report, parsing it...")
		_info("full_session_report: %s", table.tostring(eor, 9))

		self._session_report_state = SESSION_REPORT_STATES.success

		self:_calculate_and_sync_game_score_end()
	end):catch(function (error)
		Log.error("ProgressionManager", "Error fetching session_report_server: %s", error)

		self._session_report_state = SESSION_REPORT_STATES.fail

		local t = Managers.time:time("main")
		local server_time = math.floor(Managers.backend:get_server_time(t) / 1000)

		self._game_score_end_time = server_time + EndViewSettings.max_duration

		self:_sync_game_score_end_time()
	end)
end

ProgressionManager._should_use_dummy_session_report = function (self, session_id)
	local use_dummy_session_report = FETCH_DUMMY_SESSION_REPORT
	local host_type = Managers.multiplayer_session:host_type()
	local valid_host_type = host_type == HOST_TYPES.mission_server or host_type == HOST_TYPES.singleplay_backend_session

	if not valid_host_type then
		_info("invalid host_type %s", host_type)

		use_dummy_session_report = true
	end

	if GameParameters.testify then
		use_dummy_session_report = true
	end

	if not session_id then
		use_dummy_session_report = true
	end

	if session_id == "NO_SESSION_ID" then
		use_dummy_session_report = true
	end

	return use_dummy_session_report
end

ProgressionManager._parse_experience_settings = function (self, unparsed_xp_settings)
	local max_level = #unparsed_xp_settings
	local experience_settings = {
		experience_table = unparsed_xp_settings,
		max_level_experience = unparsed_xp_settings[max_level],
		max_level = max_level,
	}

	return experience_settings
end

ProgressionManager._parse_report = function (self, eor, account_wallets)
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

	local item_rewards = {}

	self:_parse_stats(character_stats)
	self:_parse_stats(account_stats)
	self:_parse_mission_stats(eor)
	self:_parse_team_stats(account_data)
	self:_parse_reward_cards(account_data, item_rewards)

	local credits_reward = self:_get_credits_reward(account_data.missionRewards)

	self._session_report.character.mastery_rewards = self:_get_mastery_rewards(account_data)
	self._session_report.credits_reward = credits_reward

	if not self._session_report.character.mastery_rewards and not self._session_report_is_dummy then
		local dummy_session_report = DummySessionReport.fetch_session_report(player:account_id())
		local dummy_account_data = dummy_session_report.team.participants[1]
		local dummy_mastery_rewards = self:_get_mastery_rewards(account_data)

		self._session_report.character.mastery_rewards = dummy_mastery_rewards
	end

	if account_wallets then
		self._session_report.character.wallets = account_wallets

		self:_parse_wallets(account_wallets)
	end

	local promise_list = {}
	local character_level_up_promise = self:_check_level_up(character_stats, item_rewards)

	table.insert(promise_list, character_level_up_promise)

	local account_level_up_promise = self:_check_level_up(account_stats, item_rewards)

	table.insert(promise_list, account_level_up_promise)

	local is_owner, rank_played

	if self._session_report.eor.mission.gameModeDetails and self._session_report.eor.mission.gameModeDetails.type == "havoc" then
		is_owner = self._session_report.eor.mission.gameModeDetails.ownerId == account_data.accountId
		rank_played = self._session_report.eor.mission.gameModeDetails.rankPlayed
		self._session_report.character.havoc_highest_rank = self:_get_havoc_highest_rank(account_data)
		self._session_report.character.havoc_week_rank = self:_get_havoc_week_rank(account_data)

		local havoc_history_promise = Managers.data_service.havoc:history() or Promise.resolved()

		table.insert(promise_list, havoc_history_promise)
	end

	return Promise.all(unpack(promise_list)):next(function (results)
		local havoc_data = results[3]

		if havoc_data and havoc_data.items then
			local promises = {
				Managers.data_service.havoc:order_by_id(havoc_data.items[1].orderId),
			}

			if havoc_data.items[2] then
				promises[#promises + 1] = Managers.data_service.havoc:order_by_id(havoc_data.items[2].orderId)
			end

			return Promise.all(unpack(promises)):next(function (orders)
				local cached_havoc_settings = Managers.data_service.havoc:get_settings()
				local havoc_settings = {
					min_charges = 1,
					min_rank = 1,
					max_rank = cached_havoc_settings.max_rank or 40,
					max_charges = cached_havoc_settings.max_charges or 3,
				}
				local havoc_order_reward, havoc_session = self:_get_havoc_order_rewards(account_data, havoc_data, orders, havoc_settings, is_owner, rank_played)
				local rank_changed = havoc_order_reward.current_rank ~= havoc_order_reward.previous_rank or false
				local charges_changed = havoc_order_reward.current_charges ~= havoc_order_reward.previous_charges or false
				local should_present_reward = charges_changed or rank_changed

				if should_present_reward then
					self._session_report.character.havoc_order_reward = havoc_order_reward

					Managers.data_service.havoc:set_show_promotion_info(havoc_session)
				end

				return Promise.resolved()
			end)
		end

		return Promise.resolved()
	end):catch(function ()
		return Promise.resolved()
	end):next(function ()
		if GameParameters.testify or self._session_report_is_dummy then
			return Promise.resolved()
		end

		local weapon_slots = {
			slot_primary = true,
			slot_secondary = true,
		}
		local has_mastery_rewards = false
		local promises = {}

		for i = 1, #self._session_report.character.mastery_rewards do
			has_mastery_rewards = true

			local mastery_reward = self._session_report.character.mastery_rewards[i]
			local mastery_data = Managers.data_service.mastery:get_mastery(mastery_reward.trackId)

			weapon_slots[mastery_reward.weapon_slot] = nil

			table.insert(promises, mastery_data)
		end

		if has_mastery_rewards then
			local profile = self:_get_profile()

			for slot, _ in pairs(weapon_slots) do
				local item = profile.loadout[slot]
				local pattern = item and item.parent_pattern
				local missing_weapon_promise = Managers.data_service.mastery:get_mastery_by_pattern(pattern):next(function (mastery_data)
					local mastery_rewards = self._session_report.character.mastery_rewards

					self._session_report.character.mastery_rewards[#mastery_rewards + 1] = {
						gainedXp = 0,
						weapon_slot = slot,
						startXp = mastery_data.current_xp,
						trackId = mastery_data.id,
						masteryId = item.trait_category,
					}

					return Promise.resolved(mastery_data)
				end)

				table.insert(promises, missing_weapon_promise)
			end
		end

		return Promise.all(unpack(promises)):next(function (masteries_data)
			local claim_promises = {}

			for i = 1, #masteries_data do
				local mastery_data = masteries_data[i]

				if mastery_data then
					local exp_per_level = Mastery.get_weapon_xp_per_level(mastery_data)
					local mastery_reward = self._session_report.character.mastery_rewards[i]

					mastery_reward.exp_per_level = exp_per_level

					local gained_xp = mastery_reward.gainedXp

					if gained_xp == 0 then
						mastery_reward.startXp = mastery_data.current_xp or 0
					end

					claim_promises[#claim_promises + 1] = Managers.data_service.mastery:claim_levels_by_new_exp(mastery_data)
				end
			end

			return Promise.all(unpack(claim_promises))
		end)
	end):next(function ()
		if self._session_report_is_dummy then
			self._session_report_state = SESSION_REPORT_STATES.success

			_info("Dummmy session_report fetched and parsed successfully")
			self:_calculate_game_score_end()
			Managers.data_service.gear:invalidate_gear_cache()

			return
		end

		local profile = self:_get_profile()
		local character_id = profile.character_id

		Managers.backend.interfaces.progression:get_progression("character", character_id):next(function (character_progression)
			self._session_report.character.start_character_level = profile.current_level or 1
			profile.current_level = character_progression.currentLevel or 1
			self._session_report.character.current_character_level = profile.current_level
			self._session_report_state = SESSION_REPORT_STATES.success

			_info("session_report fetched and parsed successfully")

			local is_host = Managers.connection:is_host()

			if is_host then
				self:_calculate_and_sync_game_score_end()
			end
		end):catch(function ()
			self._session_report_state = SESSION_REPORT_STATES.fail
		end)

		if #item_rewards > 0 then
			Managers.data_service.gear:invalidate_gear_cache()

			for i = 1, #item_rewards do
				local reward = item_rewards[i]

				Items.mark_item_id_as_new(reward)
			end
		end
	end):catch(function (errors)
		local error_string

		if type(errors) == "table" then
			error_string = table.tostring(errors, 5)
		else
			error_string = errors
		end

		Log.error("ProgressionManager", "Error parsing session_report: %s", error_string)

		self._session_report_state = SESSION_REPORT_STATES.fail

		if #item_rewards > 0 then
			Managers.data_service.gear:invalidate_gear_cache()

			for i = 1, #item_rewards do
				local reward = item_rewards[i]

				Items.mark_item_id_as_new(reward)
			end
		end
	end)
end

ProgressionManager._get_mastery_rewards = function (self, account_data)
	local reward_cards = account_data.rewardCards
	local weapons = {}

	if not reward_cards then
		return weapons
	end

	for i = 1, #reward_cards do
		local reward_card = reward_cards[i]

		if reward_card.kind == "track" then
			local rewards = reward_card.rewards

			for f = 1, #rewards do
				local reward = rewards[f]

				if reward.trackType == "mastery" then
					local trackId = reward.trackId
					local masteryId = reward.trackDetails and reward.trackDetails.mastery
					local slot = reward.trackDetails and reward.trackDetails.slot

					weapons[#weapons + 1] = {
						weapon_slot = slot,
						gainedXp = reward.reward.xp or 0,
						startXp = reward.current.xp or 0,
						trackId = trackId,
						masteryId = masteryId,
					}
				end
			end
		end
	end

	return weapons
end

ProgressionManager._has_won_mission = function (self, account_data)
	local session_statistics = account_data.sessionStatistics
	local mission_data

	for i, stat in ipairs(session_statistics) do
		local type_path = stat.typePath

		if type_path == "mission" then
			local session_value = stat.sessionValue

			for data_name, data_value in pairs(session_value) do
				mission_data = data_name

				break
			end
		end
	end

	if mission_data then
		local split = string.split(mission_data, "|")

		for i = 1, #split do
			local split_string = split[i]
			local found_string = string.find(split_string, "win")

			if found_string then
				local found_string_split = string.split(split_string, ":")

				return found_string_split[2] == "true"
			end
		end
	end

	return false
end

ProgressionManager._get_havoc_order_rewards = function (self, account_data, havoc_data, orders, havoc_settings, is_owner, rank_played)
	local min_rank = havoc_settings.min_rank
	local max_rank = havoc_settings.max_rank
	local min_charges = havoc_settings.min_charges
	local max_charges = havoc_settings.max_charges
	local havoc_session = {
		current = {
			rank = havoc_data.items[1].rank,
			charges = orders[1].charges,
		},
		previous = {
			rank = havoc_data.items[2] and havoc_data.items[2].rank or havoc_settings.min_rank,
			charges = orders[2] and orders[2].charges or havoc_settings.max_charges,
		},
	}
	local round_won = self:_has_won_mission(account_data)
	local reward_cards = account_data.rewardCards
	local received_new_order = false

	for i = 1, #reward_cards do
		local reward_card = reward_cards[i]

		if reward_card.kind == "havocOrder" then
			local rewards = reward_card.rewards
			local reward = rewards[1]

			if reward and reward.rewardType == "havocOrder" then
				received_new_order = true

				break
			end
		end
	end

	if not received_new_order then
		havoc_session.previous.rank = havoc_session.current.rank

		if not round_won and havoc_session.current.rank == min_rank then
			havoc_session.previous.charges = math.clamp(havoc_session.current.charges, min_charges, max_charges)
		elseif not round_won and havoc_session.current_rank == max_rank then
			havoc_session.previous.charges = math.clamp(havoc_session.current.charges, min_charges, max_charges)
		elseif not round_won and not is_owner and rank_played < havoc_session.current.rank then
			havoc_session.previous.charges = math.clamp(havoc_session.current.charges, min_charges, max_charges)
		elseif not round_won and min_charges <= havoc_session.current.charges and max_charges > havoc_session.current.charges then
			havoc_session.previous.charges = math.clamp(havoc_session.current.charges + 1, min_charges, max_charges)
		elseif round_won and not is_owner and rank_played < havoc_session.current.rank then
			havoc_session.previous.charges = math.clamp(havoc_session.current.charges, min_charges, max_charges)
		elseif round_won and havoc_session.current_rank == max_rank then
			Log.exception("ProgressionManager", "Despite winning a max rank Havoc mission, it appears no new Havoc order was assigned.")

			havoc_session.previous.charges = math.clamp(havoc_session.current.charges, min_charges, max_charges)
		else
			local error_message = string.format("ProgressionManager:_get_havoc_order_rewards ended up in a state unaccounted for:\nhavoc_info: %s\nhavoc_session: %s\nround_won: %s\nreward_cards: %s\n", table.tostring(havoc_settings), table.tostring(havoc_session), tostring(round_won), table.tostring(reward_cards))

			Log.exception("ProgressionManager", error_message)

			havoc_session.previous.charges = math.clamp(havoc_session.current.charges, min_charges, max_charges)
		end
	end

	local current_rank = havoc_session.current.rank
	local current_charges = havoc_session.current.charges
	local previous_charges = havoc_session.previous.charges
	local previous_rank = havoc_session.previous.rank
	local havoc_order_reward = {
		previous_charges = previous_charges,
		current_charges = current_charges,
		previous_rank = previous_rank,
		current_rank = current_rank,
		min_rank = min_rank,
		max_rank = max_rank,
		max_charges = max_charges,
	}

	return havoc_order_reward, havoc_session
end

ProgressionManager._get_havoc_highest_rank = function (self, account_data)
	local round_won = self:_has_won_mission(account_data)

	if round_won then
		local reward_cards = account_data.rewardCards

		for i = 1, #reward_cards do
			local reward_card = reward_cards[i]

			if reward_card.kind == "havocOrder" then
				local rewards = reward_card.rewards
				local reward = rewards[1]

				if reward and reward.statType == "all-time" and reward.rewardType == "havocHighestRank" then
					return {
						rank = reward.rank,
					}
				end
			end
		end
	end
end

ProgressionManager._get_havoc_week_rank = function (self, account_data)
	local round_won = self:_has_won_mission(account_data)

	if round_won then
		local reward_cards = account_data.rewardCards

		for i = 1, #reward_cards do
			local reward_card = reward_cards[i]

			if reward_card.kind == "havocOrder" then
				local rewards = reward_card.rewards
				local reward = rewards[1]

				if reward and reward.statType == "week" and reward.rewardType == "havocHighestRank" then
					return {
						rank = reward.rank,
					}
				end
			end
		end
	end
end

ProgressionManager._parse_wallets = function (self, wallets)
	local session_report_rewards = self._session_report.character.rewards
	local salary_card

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

	if self._session_report_is_dummy and not profile then
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

ProgressionManager._parse_team_stats = function (self, account_data)
	local session_statistics = account_data.sessionStatistics
	local total_kills = self:_get_session_stat(session_statistics, "team_kills") or 0
	local total_deaths = self:_get_session_stat(session_statistics, "team_deaths") or 0

	self._session_report.team.total_kills = total_kills
	self._session_report.team.total_deaths = total_deaths
end

ProgressionManager._get_session_stat = function (self, session_statistics, stat_type)
	for i, stat in ipairs(session_statistics) do
		local type_path = stat.typePath

		if type_path == stat_type then
			local session_value = stat.sessionValue

			if not session_value then
				Log.error("ProgressionManager", "Missing sessionValue for %s", stat_type)

				return
			end

			local value = session_value.none

			if not value then
				Log.error("ProgressionManager", "Missing sessionValue.none for %s", stat_type)

				return
			end

			return value
		end
	end
end

ProgressionManager._parse_mission_stats = function (self, eor)
	local mission = eor.mission
	local play_time_seconds = mission.playTimeSeconds

	self._session_report.team.play_time_seconds = play_time_seconds

	if mission.additionalData and mission.additionalData.hordeData then
		self._session_report.team.game_mode_completion_time_seconds = mission.additionalData.hordeData.completionTime
	end
end

ProgressionManager._parse_reward_cards = function (self, account_data, item_rewards)
	local reward_cards = account_data.rewardCards

	if not reward_cards then
		return
	end

	local character_rewards = self._session_report.character.rewards

	table.create_copy(character_rewards, reward_cards)

	for i = 1, #character_rewards do
		local reward_card = character_rewards[i]
		local reward_card_rewards = reward_card.rewards

		for j = 1, #reward_card_rewards do
			local reward = reward_card_rewards[j]

			reward.amount_gained = reward.amount or 0
			reward.amount = nil

			local reward_type = reward.rewardType

			reward.reward_type = reward_type
			reward.rewardType = nil

			local master_id = reward.masterId

			reward.master_id = master_id
			reward.masterId = nil

			local gear_id = reward.gearId

			if gear_id then
				reward.gear_id = gear_id
				reward.gearId = nil
				item_rewards[#item_rewards + 1] = {
					gear_id = gear_id,
					item_type = reward_type,
				}
			end

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

		if reward_card.kind == "levelUp" and reward_card.target == "character" then
			self:_add_level_up_unlocks_to_card(reward_card)
		end
	end
end

ProgressionManager.session_report = function (self)
	_info("Parsed session report has been returned")

	return self._session_report
end

ProgressionManager._check_level_up = function (self, stats, item_rewards)
	if self._session_report_is_dummy then
		_info("Dummy Session report level up completed")

		return Promise.resolved()
	end

	local needed_xp_for_next_level = stats.neededXpForNextLevel

	if needed_xp_for_next_level == 0 then
		local current_level = stats.currentLevel
		local next_level = current_level + 1

		return self:_level_up(stats, next_level, item_rewards)
	end

	if needed_xp_for_next_level == -1 then
		self:_cap_xp(stats)
	end

	_info("Session report " .. stats.type .. " level up completed [id:%s]", stats.id)

	return Promise.resolved()
end

ProgressionManager._add_unlocked_weapons_to_card = function (self, reward_card, archetype_name, target_level)
	local archetype_weapon_unlocks = WeaponUnlockSettings[archetype_name]
	local weapons_unlocks_at_level = archetype_weapon_unlocks[target_level]

	if weapons_unlocks_at_level then
		for i = 1, #weapons_unlocks_at_level do
			self:_append_reward_to_card(reward_card, {
				reward_type = "weapon_unlock",
				master_id = weapons_unlocks_at_level[i],
			})
		end
	end
end

ProgressionManager._add_level_up_unlocks_to_card = function (self, reward_card)
	local target_level = reward_card.level
	local profile = self:_get_profile()
	local profile_archetype = profile.archetype
	local archetype_name = profile_archetype.name

	self:_add_unlocked_weapons_to_card(reward_card, archetype_name, target_level)
end

ProgressionManager._level_up = function (self, stats, target_level, item_rewards)
	_info("Leveling up %s to %s...", stats.type, target_level)

	return self._progression:level_up(stats.type, stats.id, target_level):next(function (data)
		_info("level_up %s: %s", stats.type, table.tostring(data, 6))

		local reward_card = self:_find_level_up_card(target_level, stats.type)

		self:_parse_level_up_rewards(reward_card, stats.type, data, item_rewards)

		local progression_info = data.progressionInfo

		return self:_check_level_up(progression_info, item_rewards)
	end):catch(function (error)
		_info("Failed level_up, error: %s", error)

		return Promise.resolved()
	end)
end

ProgressionManager._parse_level_up_rewards = function (self, reward_card, type, data, item_rewards)
	local rewards = self._session_report[type].rewards
	local reward_info = data.rewardInfo
	local reward_list = reward_info.rewards

	for _, reward in ipairs(reward_list) do
		self:_append_reward_to_card(reward_card, reward)

		local reward_type = reward.rewardType

		if reward_type == "item" then
			local reward_item_id = reward.masterId

			if MasterItems.item_exists(reward_item_id) then
				local reward_data = {
					text = "testing testing",
					type = reward_type,
					reward_item_id = reward_item_id,
					level = reward_info.level,
				}

				table.insert(rewards, reward_data)

				local item = MasterItems.get_store_item_instance(reward)

				if item then
					local gear_id = item.gear_id

					if gear_id then
						local item_type = item.item_type

						item_rewards[#item_rewards + 1] = {
							gear_id = gear_id,
							item_type = item_type,
						}
					end
				end
			else
				Log.error("ProgressionManager", "Recieved invalid item %s as reward from backend", reward_item_id)
			end
		end
	end
end

ProgressionManager._find_level_up_card = function (self, target_level, experience_type)
	experience_type = experience_type or "character"

	local reward_cards = self._session_report.character.rewards

	if not reward_cards then
		return
	end

	for i = 1, #reward_cards do
		local reward_card = reward_cards[i]
		local kind = reward_card.kind

		if kind == "levelUp" then
			local level = reward_card.level
			local target = reward_card.target

			if level == target_level and target == experience_type then
				return reward_card
			end
		end
	end
end

ProgressionManager._append_reward_to_card = function (self, reward_card, reward)
	if not reward_card then
		return
	end

	local rewards = reward_card.rewards

	rewards[#rewards + 1] = reward
	reward_card.rewards = rewards
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

ProgressionManager.set_game_score_end_time = function (self, end_time)
	self._game_score_end_time = end_time
end

ProgressionManager.game_score_end_time = function (self)
	if not self._game_score_end_time then
		return
	end

	local game_score_end_time_in_ms = self._game_score_end_time * 1000

	return game_score_end_time_in_ms
end

ProgressionManager._calculate_game_score_end = function (self)
	local t = Managers.time:time("main")
	local server_time = math.floor(Managers.backend:get_server_time(t) / 1000)
	local max_report_time = 0
	local dummy = self._session_report.dummy

	if dummy then
		Log.info("ProgressionManager", "Calculating length of EoR from Dummy Session Report")
	end

	local eor = self._session_report.eor
	local participant_reports = eor.team.participants

	for i = 1, #participant_reports do
		local report = participant_reports[i]
		local character_id, associated_profile = report.characterId

		for _, player in pairs(Managers.player:human_players()) do
			if player:character_id() == character_id then
				associated_profile = player:profile()

				break
			end
		end

		local report_time = self:_calculate_report_time(associated_profile, report)

		if max_report_time < report_time then
			max_report_time = report_time
		end
	end

	max_report_time = max_report_time + EndViewSettings.delay_before_summary + EndViewSettings.delay_after_summary

	local end_time = server_time + max_report_time

	self._game_score_end_time = end_time
end

ProgressionManager._calculate_and_sync_game_score_end = function (self)
	self:_calculate_game_score_end()
	self:_sync_game_score_end_time()
end

ProgressionManager._sync_game_score_end_time = function (self)
	local mechanism_name = Managers.mechanism:mechanism_name()
	local is_valid_mechanism = mechanism_name == "adventure"

	if is_valid_mechanism then
		local game_score_end_time = self._game_score_end_time

		Managers.mechanism:trigger_event("game_score_end_time", game_score_end_time)
	end
end

local _card_animations = {
	xp = EndPlayerViewAnimations.experience_card_show_content,
	levelUp = EndPlayerViewAnimations.level_up_show_content,
	salary = EndPlayerViewAnimations.salary_card_show_content,
	weaponDrop = EndPlayerViewAnimations.item_reward_show_content,
}

ProgressionManager._calculate_report_time = function (self, profile, participant_report)
	if profile == nil then
		Log.info("ProgressionManager", "No profile found for '%s' in session report.", table.tostring(participant_report, 3))

		return 0
	end

	local report_time = 0
	local card_animations = _card_animations
	local reward_cards = participant_report.rewardCards

	for i = 1, #reward_cards do
		local reward_card = reward_cards[i]
		local card_kind = reward_card.kind

		if card_kind == "levelUp" then
			report_time = report_time + self:_get_level_up_card_time(profile, reward_card)
		elseif card_animations[card_kind] ~= nil then
			report_time = report_time + self:_get_duration_for_reward_card_animation(card_animations[card_kind])
		else
			Log.warning("ProgressManager", "Unknown card kind '%s'.", card_kind)
		end
	end

	return report_time
end

ProgressionManager._get_level_up_card_time = function (self, profile, reward_card)
	local level = reward_card.level
	local total_time = 0
	local profile_archetype = profile.archetype
	local archetype_name = profile_archetype.name
	local archetype_weapon_unlocks = WeaponUnlockSettings[archetype_name]
	local weapons_unlocks_at_level = archetype_weapon_unlocks[level]

	if weapons_unlocks_at_level then
		total_time = total_time + self:_get_duration_for_reward_card_animation(EndPlayerViewAnimations.unlocked_weapon_show_content) * #weapons_unlocks_at_level
	end

	for i = 1, #reward_card.rewards do
		local reward = reward_card.rewards[i]
		local reward_type = reward.rewardType

		if reward_type == "gear" then
			total_time = total_time + self:_get_duration_for_reward_card_animation(EndPlayerViewAnimations.level_up_show_content)
		else
			Log.warning("Progression", "Unknown reward type '%s' recieved from backend.", reward_type)
		end
	end

	return total_time
end

local _fixed_card_time = EndPlayerViewSettings.animation_times.fixed_card_time

ProgressionManager._get_duration_for_reward_card_animation = function (self, animation)
	if not animation then
		return 0
	end

	local end_time = animation[#animation].end_time

	return end_time + _fixed_card_time
end

ProgressionManager._use_dummy_session_report = function (self)
	self._session_report_is_dummy = true
	self._dummy_session_promise = Promise.new()
	self._session_report_state = SESSION_REPORT_STATES.fetching

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
	local session_report = DummySessionReport.fetch_session_report(player:account_id())
	local character_xp = DummySessionReport.fetch_xp_table("character")
	local account_xp = DummySessionReport.fetch_xp_table("account")
	local inventory = DummySessionReport.fetch_inventory(session_report)

	self._session_report.eor = session_report
	self._session_report.dummy = true

	local dummy_character_data = session_report.team.participants and session_report.team.participants[1]
	local start_level = dummy_character_data and dummy_character_data.progression[1].startLevel
	local current_level = dummy_character_data and dummy_character_data.progression[1].currentLevel

	self._session_report.character.start_character_level = start_level or 1
	self._session_report.character.current_character_level = current_level or 1
	self._session_report.character.inventory = inventory
	self._session_report.character.experience_settings = self:_parse_experience_settings(character_xp)
	self._session_report.account.experience_settings = self:_parse_experience_settings(account_xp)

	local dummy_wallet = {
		wallets = {
			{
				balance = {
					amount = 12345,
					type = "credits",
				},
			},
			{
				balance = {
					amount = 2345,
					type = "plasteel",
				},
			},
			{
				balance = {
					amount = 25,
					type = "diamantine",
				},
			},
		},
		by_type = function (self, wallet_type)
			if wallet_type == "credits" then
				return self.wallets[1]
			elseif wallet_type == "plasteel" then
				return self.wallets[2]
			elseif wallet_type == "diamantine" then
				return self.wallets[3]
			end
		end,
	}

	self._session_report.character.havoc_order_reward = {
		current_charges = 3,
		current_rank = 13,
		max_charges = 3,
		max_rank = 40,
		min_rank = 1,
		previous_charges = 1,
		previous_rank = 12,
	}
	self._session_report.character.havoc_week_rank = {
		rank = 13,
	}
	self._session_report.character.havoc_highest_rank = {
		rank = 13,
	}

	self:_parse_report(session_report, dummy_wallet)

	if self._dummy_session_promise then
		self._dummy_session_promise:resolve()
	end
end

ProgressionManager.fetch_dummy_session_report = function (self)
	self._session_report = {}
	self._session_report.team = {}
	self._session_report.character = {}
	self._session_report.character.rewards = {}
	self._session_report.account = {}
	self._session_report.account.rewards = {}
	self._session_report_is_dummy = true

	self:_fetch_dummy_session_report()

	return self._session_report
end

ProgressionManager._use_dummy_session_report_server = function (self)
	local session_report = DummySessionReport.fetch_session_report()

	self._session_report.eor = session_report
	self._session_report.dummy = true
	self._session_report_state = SESSION_REPORT_STATES.success
end

ProgressionManager.update = function (self, dt, t)
	local fetch_session_report_at = self._fetch_session_report_at

	if fetch_session_report_at and fetch_session_report_at <= t then
		self:_fetch_dummy_session_report()
		_info("Fetch dummy session report completed")

		self._fetch_session_report_at = nil
	end
end

ProgressionManager.check_level_up_pending = function (self)
	local local_player_id = 1
	local local_player = Managers.player:local_player(local_player_id)
	local character_id = local_player:character_id()

	self._backend_interface.progression:get_entity_type_progression("character"):next(function (characters_progression)
		for i, stats in ipairs(characters_progression) do
			local id = stats.id

			if id == character_id and self:_have_level_up_pending(stats) then
				self:_do_level_up_pending(stats)
			end
		end
	end):catch(function (error)
		_info("Failed check_level_up_pending, error: %s", error)
	end)
end

ProgressionManager._have_level_up_pending = function (self, stats)
	local needed_xp_for_next_level = stats.neededXpForNextLevel
	local have_level_up_pending = needed_xp_for_next_level == 0

	return have_level_up_pending
end

ProgressionManager._do_level_up_pending = function (self, stats)
	local current_level = stats.currentLevel
	local target_level = current_level + 1

	_info("Leveling up pending level " .. stats.type .. " to %s ...", target_level)

	return self._progression:level_up(stats.type, stats.id, target_level):next(function (data)
		_info("level_up pending level %s: %s", stats.type, table.tostring(data, 6))

		local progression_info = data.progressionInfo

		if self:_have_level_up_pending(progression_info) then
			self:_do_level_up_pending(progression_info)
		else
			self:_refresh_profiles()
		end
	end):catch(function (error)
		_info("Failed level_up pending level, error: %s", error)
	end)
end

ProgressionManager._refresh_profiles = function (self)
	Managers.data_service.profiles:fetch_all_profiles():next(function (profile_data)
		local selected_profile = profile_data.selected_profile
		local local_player_id = 1
		local local_player = Managers.player:local_player(local_player_id)

		local_player:set_profile(selected_profile)
	end):catch(function (error)
		_info("Failed refresh_profiles, error: %s", error)
	end)
end

return ProgressionManager
