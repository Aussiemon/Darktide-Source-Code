local Promise = require("scripts/foundation/utilities/promise")
local PrivilegesManager = require("scripts/managers/privileges/privileges_manager")
local PrivilegesManagerConstants = require("scripts/managers/privileges/privileges_manager_constants")
local Interface = {
	"fetch_queue_ticket_hub",
	"fetch_queue_ticket_mission",
	"start",
	"status",
	"cancel"
}
local Matchmaker = class("Matchmaker")

Matchmaker.init = function (self)
	self._privileges_manager = PrivilegesManager:new()
end

Matchmaker._get_xbox_live_sandbox_id = function (self)
	local async_job, error_code = XboxLive.get_sandbox_id_async()

	if not async_job then
		return Promise.rejected("load_sandbox_id returned error_code=" .. tostring(error_code))
	end

	return Promise.until_value_is_true(function ()
		local sandbox_id, error_code = XboxLive.get_sandbox_id_async_result(async_job)

		if sandbox_id then
			return sandbox_id
		end

		if error_code then
			return nil, "get_sandbox_id_async_result returned error_code=" .. tostring(error_code)
		end
	end)
end

Matchmaker._get_common_queue_ticket_data = function (self, type, alias_type, dedicated_alias_parameter)
	local platform_alias_promise = nil
	local authenticate_method = Managers.backend:get_auth_method()

	local function avoid_list_id_formatter(id)
		return id
	end

	if authenticate_method == Managers.backend.AUTH_METHOD_STEAM and HAS_STEAM then
		local beta_branch = Steam.beta_branch() or ""
		platform_alias_promise = Promise.resolved(alias_type .. ":steam:" .. beta_branch)

		function avoid_list_id_formatter(id)
			return Steam.id_hex_to_dec(id)
		end
	elseif authenticate_method == Managers.backend.AUTH_METHOD_XBOXLIVE and XboxLive and XboxLive.get_sandbox_id_async then
		platform_alias_promise = self:_get_xbox_live_sandbox_id():next(function (sandbox_id)
			return alias_type .. ":xbs:" .. sandbox_id
		end)

		function avoid_list_id_formatter(id)
			return XboxLive.xuid_hex_to_dec(id)
		end
	else
		Log.warning("Matchmaker", "Could not resolve a platform alias for authenticate_method: " .. authenticate_method)

		platform_alias_promise = Promise.resolved(nil)
	end

	local cross_play_promise = self._privileges_manager:cross_play():next(function ()
		return false
	end):catch(function (error)
		if error.message == "OK" then
			return Promise.resolved(true)
		else
			return Promise.rejected(error)
		end
	end)
	local platform_blocklist_promise = Managers.data_service.social:fetch_platform_block_list_ids_forced():catch(function (error)
		if type(error) == "table" then
			Log.error("Matchmaker", "could not get blocked platform ids, " .. table.tostring(error, 3))
		else
			Log.error("Matchmaker", "could not get blocked platform ids, " .. error)
		end

		Log.warning("Matchmaker", "could not get blocked platform ids, will return empty array")

		return Promise.resolved({})
	end)

	return Promise.all(platform_alias_promise, cross_play_promise, platform_blocklist_promise):catch(function (r)
		return Promise.rejected("unknown_error")
	end):next(function (results)
		local platform_alias = results[1]
		local cross_play_disabled = results[2]
		local avoid_platform_user_ids = results[3]

		for i = 1, #avoid_platform_user_ids do
			avoid_platform_user_ids[i] = avoid_list_id_formatter(avoid_platform_user_ids[i])
		end

		local dedicated_aliases = {}

		if dedicated_alias_parameter then
			table.insert(dedicated_aliases, dedicated_alias_parameter)
		end

		table.insert(dedicated_aliases, alias_type .. ":hash:" .. Managers.connection.combined_hash)

		if platform_alias then
			table.insert(dedicated_aliases, platform_alias)
		end

		table.insert(dedicated_aliases, alias_type .. ":default")
		Log.info("Matchmaker", "Resolved dedicated aliases: " .. table.tostring(dedicated_aliases, 3))

		return {
			matchmakerType = type,
			dedicatedAlias = dedicated_aliases[1],
			dedicatedAliases = dedicated_aliases,
			disableCrossPlay = cross_play_disabled,
			platformUserIdAvoidList = avoid_platform_user_ids,
			latencyList = Managers.backend.interfaces.region_latency:get_cached_region_latencies()
		}
	end)
end

Matchmaker.fetch_queue_ticket_hub = function (self)
	local data_promise = self:_get_common_queue_ticket_data("hub", "hub", GameParameters.aws_matchmaking_hub_server_alias)

	return data_promise:next(function (data)
		return Managers.backend:title_request("/matchmaker/queueticket", {
			method = "POST",
			body = data
		}):next(function (data)
			return data.body
		end)
	end)
end

Matchmaker.fetch_queue_ticket_mission = function (self, mission_id, character_id)
	local data_promise = self:_get_common_queue_ticket_data("mission", "mission", GameParameters.aws_matchmaking_mission_server_alias)

	return data_promise:next(function (data)
		data.missionId = mission_id
		data.characterId = character_id

		return Managers.backend:title_request("/matchmaker/queueticket", {
			method = "POST",
			body = data
		}):next(function (data)
			return data.body
		end)
	end)
end

Matchmaker.fetch_queue_ticket_mission_hotjoin = function (self, matched_game_session_id, character_id)
	local data_promise = self:_get_common_queue_ticket_data("mission-hot-join", "mission", GameParameters.aws_matchmaking_mission_server_alias)

	return data_promise:next(function (data)
		data.characterId = character_id
		data.missionSessionId = matched_game_session_id

		return Managers.backend:title_request("/matchmaker/queueticket", {
			method = "POST",
			body = data
		}):next(function (data)
			return data.body
		end)
	end)
end

Matchmaker.start = function (self, queue_tickets)
	assert(type(queue_tickets) == "table", "Missing or invalid queue_tickets")

	local data = {
		queueTickets = queue_tickets
	}

	return Managers.backend:title_request("/matchmaker/start", {
		method = "POST",
		body = data
	}):next(function (data)
		return data.body
	end)
end

Matchmaker.status = function (self, session_id)
	assert(type(session_id) == "string", "Missing or invalid matchmaking_session_id")

	return Managers.backend:title_request("/matchmaker/sessions/" .. session_id):next(function (data)
		return data.body
	end)
end

Matchmaker.cancel = function (self, session_id)
	assert(type(session_id) == "string", "Missing or invalid session_id")

	return Managers.backend:title_request("/matchmaker/sessions/" .. session_id .. "/cancel"):next(function (data)
		return data.body
	end)
end

implements(Matchmaker, Interface)

return Matchmaker
