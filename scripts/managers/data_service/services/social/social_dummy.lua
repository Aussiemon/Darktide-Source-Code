local PlatformSocialInterface = require("scripts/managers/data_service/services/social/platform_social_interface")
local Promise = require("scripts/foundation/utilities/promise")
local SocialSteam = class("SocialSteam")

SocialSteam.init = function (self)
	return
end

SocialSteam.destroy = function (self)
	return
end

SocialSteam.friends_list_has_changes = function (self)
	return false
end

local empty_list = {}

SocialSteam.fetch_friends_list = function (self)
	local promise = Promise:new()

	promise:resolve(empty_list)

	return promise
end

SocialSteam.blocked_list_has_changes = function (self)
	return false
end

SocialSteam.fetch_blocked_list = function (self)
	local promise = Promise:new()

	promise:resolve(empty_list)

	return promise
end

SocialSteam.fetch_blocked_list_ids_forced = function (self)
	local promise = Promise:new()

	promise:resolve(empty_list)

	return promise
end

implements(SocialSteam, PlatformSocialInterface)

return SocialSteam
