﻿-- chunkname: @scripts/managers/data_service/services/invites/invites_dummy.lua

local InvitesDummy = class("InvitesDummy")

InvitesDummy.init = function (self)
	return
end

InvitesDummy.update = function (self)
	return
end

InvitesDummy.has_invite = function (self)
	return false
end

InvitesDummy.get_invite = function (self)
	return nil
end

InvitesDummy.send_invite = function (self)
	return
end

InvitesDummy.reset = function (self)
	return
end

InvitesDummy.destroy = function (self)
	return
end

InvitesDummy.on_profile_signed_in = function (self)
	return
end

return InvitesDummy
