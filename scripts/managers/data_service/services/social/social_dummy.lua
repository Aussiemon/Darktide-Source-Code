local PlatformSocialInterface = require("scripts/managers/data_service/services/social/platform_social_interface")
local Promise = require("scripts/foundation/utilities/promise")
local SocialDummy = class("SocialDummy")

SocialDummy.init = function (self)
	return
end

SocialDummy.destroy = function (self)
	return
end

SocialDummy.reset = function (self)
	return
end

SocialDummy.update = function (self, dt, t)
	return
end

SocialDummy.friends_list_has_changes = function (self)
	return false
end

local empty_list = {}

SocialDummy.fetch_friends_list = function (self)
	local promise = Promise:new()

	promise:resolve(empty_list)

	return promise
end

SocialDummy.blocked_list_has_changes = function (self)
	return false
end

SocialDummy.fetch_blocked_list = function (self)
	local promise = Promise:new()

	promise:resolve(empty_list)

	return promise
end

SocialDummy.fetch_blocked_list_ids_forced = function (self)
	local promise = Promise:new()

	promise:resolve(empty_list)

	return promise
end

SocialDummy.update_recent_players = function (self, account_id)
	return
end

implements(SocialDummy, PlatformSocialInterface)

return SocialDummy
