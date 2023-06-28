local Promise = require("scripts/foundation/utilities/promise")
local BackendError = require("scripts/foundation/managers/backend/backend_error")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Interface = require("scripts/backend/social_interface")
local Social = class("Social")

Social.init = function (self)
	return
end

Social.fetch_friends = function (self)
	return BackendUtilities.build_account_path("friends", nil, "social"):next(function (link)
		return Managers.backend:title_request(link):next(function (data)
			return data.body
		end)
	end)
end

local _friend_request_options = {}

Social.send_friend_request = function (self, account_id, method)
	local options = _friend_request_options
	options.method = method or "POST"

	return BackendUtilities.make_account_title_request("friends", BackendUtilities.url_builder(account_id):path("/invite"), options, nil, "social"):next(function (data)
		return data.body
	end)
end

Social.unfriend_player = function (self, account_id)
	local options = _friend_request_options
	options.method = "DELETE"

	return BackendUtilities.make_account_title_request("friends", BackendUtilities.url_builder(account_id), options, nil, "social"):next(function (data)
		return data.body
	end)
end

Social.get_fatshark_id = function (self)
	return Managers.backend:authenticate():next(function (account)
		if not account.sub then
			local p = Promise:new()

			p:reject(BackendUtilities.create_error(BackendError.UnknownError, "Missing account sub"))

			return p
		end

		local url = string.format("/social/%s/friendcode", tostring(account.sub))

		return Managers.backend:title_request(url)
	end):next(function (data)
		return data.body.friendCode
	end)
end

Social.get_account_by_fatshark_id = function (self, fatshark_id)
	local url = string.format("/social/friendcode/%s", tostring(fatshark_id))

	return Managers.backend:title_request(url):next(function (data)
		return data.body
	end):catch(function (error)
		if error.status == 404 then
			return nil
		else
			return Promise.rejected(error)
		end
	end)
end

Social.fetch_recently_played = function (self, character_id)
	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/recentlyplayed"), nil, nil, "social"):next(function (data)
		return data.body
	end)
end

Social.fetch_blocked_accounts = function (self)
	return BackendUtilities.build_account_path("block", nil, "social"):next(function (link)
		return Managers.backend:title_request(link):next(function (data)
			return data.body
		end)
	end)
end

local _add_blocked_account_options = {
	method = "PUT"
}

Social.add_blocked_account = function (self, account_id)
	return BackendUtilities.make_account_title_request("block", BackendUtilities.url_builder(account_id), _add_blocked_account_options, nil, "social"):next(function (data)
		return data.body
	end)
end

local _remove_blocked_account_options = {
	method = "DELETE"
}

Social.remove_blocked_account = function (self, account_id)
	return BackendUtilities.make_account_title_request("block", BackendUtilities.url_builder(account_id), _remove_blocked_account_options, nil, "social"):next(function (data)
		return data.body
	end)
end

Social.suggested_names_by_archetype = function (self, archetype_name, gender, birthplace)
	local builder = BackendUtilities.url_builder():path("/social/names/"):path(archetype_name):query("gender", gender):query("planet", birthplace)

	return Managers.backend:title_request(builder:to_string()):next(function (response)
		return response.body.names
	end)
end

implements(Social, Interface)

return Social
