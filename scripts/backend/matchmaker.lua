-- chunkname: @scripts/backend/matchmaker.lua

local PrivilegesManager = require("scripts/managers/privileges/privileges_manager")
local PrivilegesManagerConstants = require("scripts/managers/privileges/privileges_manager_constants")
local Promise = require("scripts/foundation/utilities/promise")
local Interface = {
	"fetch_queue_ticket_hub",
	"fetch_queue_ticket_mission",
	"fetch_queue_ticket_single_player",
	"start",
	"status",
	"cancel",
}
local Matchmaker = class("Matchmaker")

Matchmaker.init = function (self)
	self._privileges_manager = PrivilegesManager:new()
end

Matchmaker._get_xbox_live_sandbox_id = function (self)
	local promise = Promise:new()
	local sandbox_id = Managers.account:sandbox_id()

	promise:resolve(sandbox_id)

	return promise
end

Matchmaker._get_common_queue_ticket_data = function (self, matchmaker_type, alias_type, dedicated_alias_parameter)
	local platform_alias_promise
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
	elseif authenticate_method == Managers.backend.AUTH_METHOD_PSN then
		platform_alias_promise = Promise.resolved(alias_type .. ":psn")

		function avoid_list_id_formatter(id)
			return Application.hex64_to_dec(id)
		end
	else
		Log.warning("Matchmaker", "Could not resolve a platform alias for authenticate_method: " .. authenticate_method)

		platform_alias_promise = Promise.resolved(nil)
	end

	local cross_play_promise = self._privileges_manager:cross_play():next(function (result)
		local cross_play_disabled = not result.has_privilege

		return Promise.resolved(cross_play_disabled)
	end)
	local platform_blocklist_promise = Managers.data_service.social:fetch_platform_block_list_ids_forced():catch(function (error)
		if type(error) == "table" then
			Log.error("Matchmaker", "could not get blocked platform ids, %s", table.tostring(error, 3))
		else
			Log.error("Matchmaker", "could not get blocked platform ids, %s", error)
		end

		Log.warning("Matchmaker", "could not get blocked platform ids, will return empty array")

		return Promise.resolved({})
	end)
	local latencies_promise = Managers.backend.interfaces.region_latency:get_region_latencies()

	return Promise.all(platform_alias_promise, cross_play_promise, platform_blocklist_promise, latencies_promise):catch(function (r)
		return Promise.rejected("unknown_error")
	end):next(function (results)
		local platform_alias = results[1]
		local cross_play_disabled = results[2]
		local avoid_platform_user_ids = results[3]
		local latency_list = results[4]

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
		Log.info("Matchmaker", "Resolved dedicated aliases: %s", table.tostring(dedicated_aliases, 3))

		return {
			matchmakerType = matchmaker_type,
			dedicatedAlias = dedicated_aliases[1],
			dedicatedAliases = dedicated_aliases,
			disableCrossPlay = cross_play_disabled,
			platformUserIdAvoidList = avoid_platform_user_ids,
			latencyList = latency_list,
		}
	end)
end

Matchmaker.fetch_queue_ticket_hub = function (self)
	local data_promise = self:_get_common_queue_ticket_data("hub", "hub", GameParameters.aws_matchmaking_hub_server_alias)

	return data_promise:next(function (data)
		return Managers.backend:title_request("/matchmaker/queueticket", {
			method = "POST",
			body = data,
		}):next(function (data)
			return data.body
		end)
	end)
end

Matchmaker.fetch_queue_ticket_mission = function (self, mission_id, character_id, private_session)
	local type = "mission"

	if private_session then
		type = "mission-private-session"
	end

	local data_promise = self:_get_common_queue_ticket_data(type, "mission", GameParameters.aws_matchmaking_mission_server_alias)

	return data_promise:next(function (data)
		data.missionId = mission_id
		data.characterId = character_id

		return Managers.backend:title_request("/matchmaker/queueticket", {
			method = "POST",
			body = data,
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
			body = data,
		}):next(function (data)
			return data.body
		end)
	end)
end

Matchmaker.fetch_queue_ticket_single_player = function (self, mission_id, character_id)
	local data_promise = self:_get_common_queue_ticket_data("single-player", "mission", GameParameters.aws_matchmaking_mission_server_alias)

	return data_promise:next(function (data)
		data.missionId = mission_id
		data.characterId = character_id

		return Managers.backend:title_request("/matchmaker/queueticket", {
			method = "POST",
			body = data,
		}):next(function (data)
			return data.body
		end)
	end)
end

Matchmaker.start = function (self, queue_tickets)
	local data = {
		queueTickets = queue_tickets,
	}

	return Managers.backend:title_request("/matchmaker/start", {
		method = "POST",
		body = data,
	}):next(function (data)
		return data.body
	end)
end

Matchmaker.status = function (self, session_id)
	return Managers.backend:title_request("/matchmaker/sessions/" .. session_id):next(function (data)
		return data.body
	end)
end

Matchmaker.cancel = function (self, session_id)
	return Managers.backend:title_request("/matchmaker/sessions/" .. session_id .. "/cancel"):next(function (data)
		return data.body
	end)
end

implements(Matchmaker, Interface)

return Matchmaker
