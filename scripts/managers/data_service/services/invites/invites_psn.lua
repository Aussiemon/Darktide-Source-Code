-- chunkname: @scripts/managers/data_service/services/invites/invites_psn.lua

local InvitesPSN = class("InvitesPSN")

InvitesPSN.init = function (self)
	self._has_invite = false
	self._invites = {}
end

InvitesPSN.update = function (self)
	return
end

InvitesPSN.has_invite = function (self)
	return false
end

InvitesPSN.get_invite = function (self)
	return nil
end

InvitesPSN.send_invite = function (self)
	return
end

InvitesPSN.reset = function (self)
	table.clear(self._invites)

	self._has_invite = false
end

InvitesPSN.on_profile_signed_in = function (self, account_id)
	return
end

InvitesPSN.destroy = function (self)
	return
end

return InvitesPSN
