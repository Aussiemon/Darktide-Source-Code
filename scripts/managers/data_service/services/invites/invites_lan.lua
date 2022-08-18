local InvitesLAN = class("InvitesLAN")

InvitesLAN.init = function (self)
	self._has_invite = false
	self._invite_address = nil
end

InvitesLAN.update = function (self)
	return
end

InvitesLAN.has_invite = function (self)
	return self._has_invite
end

InvitesLAN.get_invite = function (self)
	if self._has_invite then
		local address = self._invite_address
		self._invite_address = nil
		self._has_invite = false

		return address
	end

	return nil
end

InvitesLAN.send_invite = function (self)
	return
end

InvitesLAN.destroy = function (self)
	return
end

return InvitesLAN
