local Promise = require("scripts/foundation/utilities/promise")
local BackendError = require("scripts/foundation/managers/backend/backend_error")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Interface = {
	"fetch",
	"create",
	"complete",
	"events"
}
local game_session_poll_interval_s = 2
local max_events_per_batch = 20
local GameplaySession = class("GameplaySession")

GameplaySession.poll_for_end_of_round = function (self, session_id, participant, game_session_timeout_s)
	return self:_poll_for_end_of_round_internal(session_id, participant, game_session_timeout_s or 30, nil)
end

GameplaySession._poll_for_end_of_round_internal = function (self, session_id, participant, game_session_timeout_s, start_time)
	start_time = start_time or Managers.time:time("main")

	return self:fetch(session_id):next(function (data)
		if data.session.state.completed then
			local ok_to_fetch = true

			if participant == nil then
				for id, char in pairs(data.session.participants) do
					if (not char or not char.rewarded) and (not char or not char.disconnected) then
						ok_to_fetch = false
					end
				end
			else
				local character_data = data.session.participants[participant]
				ok_to_fetch = character_data and character_data.rewarded
			end

			if ok_to_fetch then
				return Managers.backend:title_request(BackendUtilities.fetch_link(data, "eor")):next(function (data)
					return data.body
				end)
			end
		end

		local now = Managers.time:time("main")

		Log.debug("GamePlaySession", "Not complete yet")

		if game_session_timeout_s < now - start_time then
			Log.warning("GamePlaySession", "Timeout reached waiting for eor")

			return Promise.rejected(BackendUtilities.create_error(BackendError.NoIdentifier, "Timeout reached waiting for eor"))
		end

		return Promise.delay(game_session_poll_interval_s):next(function ()
			return self:_poll_for_end_of_round_internal(session_id, participant, game_session_timeout_s, start_time)
		end)
	end)
end

GameplaySession.fetch = function (self, session_id)
	return Managers.backend:title_request("/gameplay/sessions/" .. session_id):next(function (data)
		return data.body
	end)
end

GameplaySession.remaining_solo_rewards = function (self, account_id)
	return Managers.backend:title_request(BackendUtilities.url_builder("/data/"):path(account_id):path("/account/untrusted/state"):to_string()):next(function (data)
		return data.body
	end)
end

GameplaySession.fetch_server_details = function (self, session_id)
	return Managers.backend:title_request("/gameplay/sessions/" .. session_id .. "/serverdetails"):next(function (data)
		return data.body
	end)
end

GameplaySession.create = function (self, server_id, ip_address)
	local data = {
		info = {
			serverDetails = {
				type = "dedicated",
				properties = {
					serverId = server_id,
					ipAddress = ip_address
				}
			}
		}
	}

	return Managers.backend:title_request("/gameplay/sessions", {
		method = "POST",
		body = data
	}):next(function (data)
		return data.body
	end):next(function (results)
		if results.sessionId then
			return results.sessionId
		else
			local p = Promise:new()

			p:reject(BackendUtilities.create_error(BackendError.InvalidResponse, "Missing session_id"))

			return p
		end
	end)
end

GameplaySession.update = function (self, session_id, participants, kicked_participants_account_ids, backfill_wanted)
	local data = {
		info = {
			participants = participants,
			kickedParticipants = kicked_participants_account_ids,
			backfillWanted = backfill_wanted
		}
	}

	Log.info("GameplaySession", "Posting gameplay session update (%s) with participant_count=%s, kicked_participants_count=%s, backfill_wanted=%s", session_id, #participants, kicked_participants_account_ids and #kicked_participants_account_ids or -1, backfill_wanted and "true" or "false")

	return Managers.backend:title_request("/gameplay/sessions/" .. session_id .. "/update", {
		method = "POST",
		body = data
	}):next(function (data)
		return data.body
	end)
end

local function to_backend_modifier(reward_modifier)
	return {
		xp = reward_modifier.mission_reward_xp_modifier,
		credits = reward_modifier.mission_reward_credit_modifier,
		rareLoot = reward_modifier.mission_reward_rare_loot_modifier,
		gearInsteadOfWeapon = reward_modifier.mission_reward_gear_instead_of_weapon_modifier,
		sideMissionXp = reward_modifier.side_mission_reward_xp_modifier,
		sideMissionCredit = reward_modifier.side_mission_reward_credit_modifier
	}
end

local function to_backend_modifiers(reward_modifiers)
	local backend_modifiers = {}
	local at_least_one = false

	for character, modifier in pairs(reward_modifiers) do
		backend_modifiers[character] = to_backend_modifier(modifier)
		at_least_one = true
	end

	return at_least_one and backend_modifiers or nil
end

GameplaySession.complete = function (self, session_id, participants, mission_result, reward_modifiers)
	local modifiers = to_backend_modifiers(reward_modifiers)

	if modifiers then
		mission_result.rewardModifiers = modifiers
	end

	local data = {
		info = {
			participants = participants,
			missionResult = mission_result
		}
	}

	return Managers.backend:title_request("/gameplay/sessions/" .. session_id .. "/complete", {
		method = "POST",
		body = data
	}):next(function (data)
		return data.body
	end)
end

GameplaySession.get_config = function (self)
	return Managers.backend:title_request("/gameplay/config/sessions"):next(function (data)
		return data.body
	end)
end

local function _events_batched(session_id, events, from)
	return function ()
		local to = from + #events - 1

		Log.info("GameplaySession", "Sending events: %d - %d", from, to)

		local url = string.format("/gameplay/sessions/%s", session_id)

		return Managers.backend:title_request(url, {
			method = "POST",
			body = {
				updates = events
			}
		}):next(function (data)
			return data.body
		end)
	end
end

GameplaySession.events = function (self, session_id, events)
	if #events == 0 then
		return Promise.resolved({
			sessionId = session_id
		})
	end

	local batches = {}
	local from = {}

	for position = 1, #events, max_events_per_batch do
		local remaining_size = math.min(#events - position + 1, max_events_per_batch)
		local batch = table.slice(events, position, remaining_size)
		batches[#batches + 1] = batch
		from[#from + 1] = position
	end

	local promise = _events_batched(session_id, batches[1], 1)()

	for i = 2, #batches do
		promise = promise:next(_events_batched(session_id, batches[i], from[i]))
	end

	return promise
end

implements(GameplaySession, Interface)

return GameplaySession
