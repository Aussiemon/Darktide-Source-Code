-- chunkname: @scripts/managers/account/player_session_psn.lua

local Promise = require("scripts/foundation/utilities/promise")
local PlayerSessionPSN = class("PlayerSessionPSN")

PlayerSessionPSN.create_session = function (web_api, user_id, max_players, join_disabled, is_private, has_crossplay_restriction)
	return Managers.party_immaterium:get_your_standing_invite_code():next(function (party_id_with_invite_code)
		local push_context_id = WebApi.create_push_context(user_id)
		local invite_code_base64 = string.encode_base64(party_id_with_invite_code)
		local joinable_user_type = is_private and "FRIENDS_OF_FRIENDS" or "ANYONE"
		local content = cjson.encode({
			playerSessions = {
				{
					maxSpectators = 0,
					swapSupported = false,
					invitableUserType = "MEMBER",
					joinDisabled = join_disabled,
					joinableUserType = joinable_user_type,
					exclusiveLeaderPrivileges = {
						"KICK",
						"UPDATE_JOINABLE_USER_TYPE",
						"UPDATE_INVITABLE_USER_TYPE",
						"PROMOTE_TO_LEADER"
					},
					maxPlayers = max_players,
					localizedSessionName = {
						defaultLanguage = "en-US",
						localizedText = {
							["en-US"] = "Join me NOW!"
						}
					},
					supportedPlatforms = {
						"PS5"
					},
					member = {
						players = {
							{
								platform = "PS5",
								accountId = "me",
								pushContexts = {
									{
										pushContextId = push_context_id
									}
								},
								customData1 = invite_code_base64
							}
						}
					},
					expirationTime = not has_crossplay_restriction and 86400 or nil,
					nonPsnSupported = not has_crossplay_restriction
				}
			}
		})
		local api_group = "sessionManager"
		local path = "/v1/playerSessions"
		local method = WebApi.POST

		return web_api:send_request(user_id, api_group, path, method, content):next(function (result)
			local session_id = result.playerSessions[1].sessionId

			return session_id
		end)
	end):catch(function (err)
		Log.error("PlayerSessionPSN", "Failed creating session: %s", table.tostring(err, 5))

		return Promise.rejected(err)
	end)
end

PlayerSessionPSN.join_session = function (web_api, user_id, session_id)
	return Managers.party_immaterium:get_your_standing_invite_code():next(function (party_id_with_invite_code)
		local push_context_id = WebApi.create_push_context(user_id)
		local invite_code_base64 = string.encode_base64(party_id_with_invite_code)
		local content = cjson.encode({
			players = {
				{
					platform = "PS5",
					accountId = "me",
					pushContexts = {
						{
							pushContextId = push_context_id
						}
					},
					customData1 = invite_code_base64
				}
			}
		})
		local api_group = "sessionManager"
		local path = string.format("/v1/playerSessions/%s/member/players", session_id)
		local method = WebApi.POST

		return web_api:send_request(user_id, api_group, path, method, content)
	end):catch(function (err)
		Log.error("PlayerSessionPSN", "Failed joining session: %s", table.tostring(err, 5))

		return Promise.rejected(err)
	end)
end

PlayerSessionPSN.leave_session = function (web_api, user_id, session_id)
	local api_group = "sessionManager"
	local path = string.format("/v1/playerSessions/%s/members/me", session_id)
	local method = WebApi.DELETE
	local content

	return web_api:send_request(user_id, api_group, path, method, content):catch(function (err)
		Log.error("PlayerSessionPSN", "Failed leaving session: %s", table.tostring(err, 5))

		return Promise.rejected(err)
	end)
end

PlayerSessionPSN.is_session_leader = function (web_api, user_id, session_id)
	local api_group = "sessionManager"
	local path = "/v1/playerSessions?fields=leader"
	local method = WebApi.GET
	local content
	local headers = {
		["X-PSN-SESSION-MANAGER-SESSION-IDS"] = tostring(session_id)
	}
	local response_format

	return web_api:send_request(user_id, api_group, path, method, content, headers, response_format):next(function (result)
		local session = result.playerSessions[1]

		if not session then
			return Promise.rejected({
				string.format("PSN session %s not found", session_id)
			})
		end

		local leader_account_id = session.leader.accountId
		local my_account_id_hex = Playstation.account_id()
		local my_account_id = Application.hex64_to_dec(my_account_id_hex)
		local is_leader = leader_account_id == my_account_id

		return is_leader
	end):catch(function (err)
		Log.error("PlayerSessionPSN", "Failed getting PSN session leader: %s", table.tostring(err, 5))

		return Promise.rejected(err)
	end)
end

PlayerSessionPSN.update_session_max_players = function (web_api, user_id, session_id, max_players)
	local api_group = "sessionManager"
	local path = string.format("/v1/playerSessions/%s", session_id)
	local method = WebApi.PATCH
	local content = cjson.encode({
		maxPlayers = max_players
	})

	return web_api:send_request(user_id, api_group, path, method, content):catch(function (err)
		Log.error("PlayerSessionPSN", "Failed updating session maxPlayers: %s", table.tostring(err, 5))

		return Promise.rejected(err)
	end)
end

PlayerSessionPSN.update_session_join_disabled = function (web_api, user_id, session_id, disabled)
	local api_group = "sessionManager"
	local path = string.format("/v1/playerSessions/%s", session_id)
	local method = WebApi.PATCH
	local content = cjson.encode({
		joinDisabled = disabled
	})

	return web_api:send_request(user_id, api_group, path, method, content):catch(function (err)
		Log.error("PlayerSessionPSN", "Failed updating session joinDisabled: %s", table.tostring(err, 5))

		return Promise.rejected(err)
	end)
end

PlayerSessionPSN.update_session_privacy = function (web_api, user_id, session_id, is_private)
	local api_group = "sessionManager"
	local path = string.format("/v1/playerSessions/%s", session_id)
	local method = WebApi.PATCH

	return web_api:send_request(user_id, api_group, path, method, cjson.encode({
		exclusiveLeaderPrivileges = {
			"KICK",
			"UPDATE_INVITABLE_USER_TYPE",
			"PROMOTE_TO_LEADER"
		}
	})):next(function ()
		return web_api:send_request(user_id, api_group, path, method, cjson.encode({
			joinableUserType = is_private and "FRIENDS_OF_FRIENDS" or "ANYONE"
		}))
	end):next(function ()
		return web_api:send_request(user_id, api_group, path, method, cjson.encode({
			exclusiveLeaderPrivileges = {
				"KICK",
				"UPDATE_JOINABLE_USER_TYPE",
				"UPDATE_INVITABLE_USER_TYPE",
				"PROMOTE_TO_LEADER"
			}
		}))
	end):catch(function (err)
		Log.error("PlayerSessionPSN", "Failed updating session joinableUserType: %s", table.tostring(err, 5))

		return Promise.rejected(err)
	end)
end

PlayerSessionPSN.get_session_invite_code = function (web_api, user_id, session_id)
	local api_group = "sessionManager"
	local path = "/v1/playerSessions?fields=leader,member(players),member(players(customData1))"
	local method = WebApi.GET
	local content
	local headers = {
		["X-PSN-SESSION-MANAGER-SESSION-IDS"] = tostring(session_id)
	}
	local response_format

	return web_api:send_request(user_id, api_group, path, method, content, headers, response_format):next(function (result)
		local session = result.playerSessions[1]

		if not session then
			Promise.rejected({
				string.format("PSN session %s not found", session_id)
			})
		end

		local leader_account_id = session.leader.accountId
		local players = session.member.players

		for i = 1, #players do
			local player = players[i]

			if player.accountId == leader_account_id then
				local invite_code = string.decode_base64(player.customData1)

				return invite_code
			end
		end
	end):catch(function (err)
		Log.error("PlayerSessionPSN", "Failed getting session invite code: %s", table.tostring(err, 5))

		return Promise.rejected(err)
	end)
end

PlayerSessionPSN.send_session_invite = function (web_api, user_id, session_id, invitee_account_id)
	local content = cjson.encode({
		invitations = {
			{
				to = {
					accountId = invitee_account_id
				}
			}
		}
	})
	local api_group = "sessionManager"
	local path = string.format("/v1/playerSessions/%s/invitations", session_id)
	local method = WebApi.POST

	return web_api:send_request(user_id, api_group, path, method, content):catch(function (err)
		Log.error("PlayerSessionPSN", "Failed sending session invite: %s", table.tostring(err, 5))

		return Promise.rejected(err)
	end)
end

return PlayerSessionPSN
