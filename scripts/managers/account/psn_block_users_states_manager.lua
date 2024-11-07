-- chunkname: @scripts/managers/account/psn_block_users_states_manager.lua

local Promise = require("scripts/foundation/utilities/promise")

PsnBlockUsersStatesManager = class("PsnBlockUsersStatesManager")

local MAX_CALLS = 25
local MAX_TIME_INTERVAL = 900
local MIN_DELAY = 10
local INTERVAL_UPDATE = 1

PsnBlockUsersStatesManager.init = function (self)
	self._current_time = 0
	self._current_calls = 0
	self._current_waiting_time = 0
	self._current_update = 0
	self._blocked_by = {}
	self._requested_account = {}
	self._already_requested_account = {}
	self._wait_to_collect_accounts = false
	self._waiting_for_answer = false
end

PsnBlockUsersStatesManager.update = function (self, dt, t)
	self._current_update = self._current_update + dt

	if self._current_update < INTERVAL_UPDATE then
		return
	end

	if self._current_calls ~= 0 then
		self._current_time = self._current_time + self._current_update
		self._current_waiting_time = math.clamp(self._current_waiting_time - self._current_update, 0, math.huge)
	end

	self._current_update = 0

	if self._current_waiting_time == 0 and not self._wait_to_collect_accounts and not table.is_empty(self._requested_account) and not self._waiting_for_answer then
		self._waiting_for_answer = true

		self:fetch_block_users_states(self._requested_account)
	end

	if self._current_time >= MAX_TIME_INTERVAL then
		self._current_calls = 0
		self._current_time = 0
		self._current_waiting_time = 0
	end
end

PsnBlockUsersStatesManager.set_account_id = function (self, account_id)
	self._account_id = account_id
end

PsnBlockUsersStatesManager.set_wait_to_collect_accounts = function (self, new_value)
	self._wait_to_collect_accounts = new_value
end

PsnBlockUsersStatesManager.is_blocking_me = function (self, account_id)
	return self._blocked_by[account_id] or false
end

PsnBlockUsersStatesManager.add_requested_account = function (self, account_id)
	local current_value = self._blocked_by[account_id]

	if current_value == nil and not table.contains(self._requested_account, account_id) then
		table.insert(self._requested_account, account_id)
	end
end

PsnBlockUsersStatesManager.is_platform_id_already_requested = function (self, platform_id)
	return self._already_requested_account[platform_id] or false
end

PsnBlockUsersStatesManager.fetch_block_users_states = function (self, account_ids, result_promise, result_data_table)
	self:_get_platform_token():next(function (token)
		local local_player = Managers.player:local_player(1)
		local url = string.format("/social/%s/mutelist", tostring(local_player:account_id()))
		local in_header = {}

		in_header["platform-token"] = token

		return Managers.backend:title_request(url, {
			method = "POST",
			headers = in_header,
			body = {
				platformIds = account_ids,
			},
		}):next(function (response)
			local blocked_by = self._blocked_by
			local accounts = {
				response.body.accounts,
				response.body.platformAccounts,
			}

			for index, _ in pairs(accounts) do
				for _, account in pairs(accounts[index]) do
					local account_id = account and account.accountId
					local is_muting_me = account and (account.isMutedBy or account.isMuted)

					if account_id ~= nil and account_id ~= "" then
						blocked_by[account_id] = blocked_by[account_id] or is_muting_me
					end
				end
			end

			for _, requested_account in pairs(self._requested_account) do
				self._already_requested_account[requested_account] = true
			end

			self._requested_account = {}

			local new_waiting_time = self:_calculate_waiting_time()

			self._current_waiting_time = new_waiting_time
			self._current_calls = self._current_calls + 1
			self._waiting_for_answer = false

			Managers.event:trigger("event_new_block_user_states")
		end):catch(function (error)
			Log.error("Block User states", "Could not get Block User states, %s", error)

			for _, requested_account in pairs(self._requested_account) do
				self._already_requested_account[requested_account] = true
			end

			self._requested_account = {}

			local new_waiting_time = self:_calculate_waiting_time()

			self._current_waiting_time = new_waiting_time
			self._current_calls = self._current_calls + 1
			self._waiting_for_answer = false

			Managers.event:trigger("event_new_block_user_states")

			return Promise.resolved({})
		end)
	end)
end

PsnBlockUsersStatesManager._calculate_waiting_time = function (self)
	local remaining_time = MAX_TIME_INTERVAL - self._current_time
	local remaining_calls = MAX_CALLS - self._current_calls
	local max_delay = remaining_time / remaining_calls
	local waiting_time = MIN_DELAY + (max_delay - MIN_DELAY) * (self._current_calls / MAX_CALLS)

	return waiting_time
end

PsnBlockUsersStatesManager._get_platform_token = function (self)
	local request_id

	return Promise.until_value_is_true(function ()
		if not request_id then
			request_id = Playstation.request_auth_code()

			return false
		end

		local result, err = Playstation.get_auth_code_results(request_id)

		if err then
			Log.error("ExternalPayment", "get_auth_code_results() " .. "%s", err)

			return err
		end

		if result then
			return result.authorization_code
		end

		return false
	end)
end

PsnBlockUsersStatesManager._print_update_debug_information = function (self)
	if DevParameters.debug_print_ps5_block_users_states then
		local s_current_time = string.format("current time: %s", self._current_time)
		local s_current_waiting_time = string.format("current waiting time: %s", self._current_waiting_time)
		local s_number_requested_account = string.format("number requested account: %s", #self._requested_account)
		local s_current_calls = string.format("current calls: %s", self._current_calls)
		local s_requested_account = "{ "

		for i = 1, #self._requested_account do
			s_requested_account = s_requested_account .. self._requested_account[i] .. " "
		end

		s_requested_account = s_requested_account .. " }"

		local s_current_requested_accounts = string.format("current requested accounts: %s", s_requested_account)
		local s_divider = "-------------------------------------"

		Log.info("Print_update_debug_information", "\n%s\n%s\n%s\n%s\n%s\n%s\n", s_current_time, s_current_waiting_time, s_number_requested_account, s_current_calls, s_divider, s_current_requested_accounts)
	end
end

PsnBlockUsersStatesManager._print_waiting_time_debug_information = function (self, remaining_time, remaining_calls, max_delay, waiting_time)
	if DevParameters.debug_print_ps5_block_users_states then
		local s_remaining_time = string.format("remaining time: %s", remaining_time)
		local s_remaining_calls = string.format("remaining calls: %s", remaining_calls)
		local s_max_delay = string.format("max_delay: %s", max_delay)
		local s_waiting_time = string.format("waiting_time: %s", waiting_time)
		local s_divider = "-------------------------------------"

		Log.info("Print_waiting_time_debug_information", "\n%s\n%s\n%s\n%s\n%s", s_remaining_time, s_remaining_calls, s_max_delay, s_waiting_time, s_divider)
	end
end

return PsnBlockUsersStatesManager
