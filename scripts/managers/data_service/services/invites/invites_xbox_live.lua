local InvitesXboxLive = class("InviteInvitesXboxLivesSteam")

local function _error_report(error)
	Log.error("InvitesXboxLive", tostring(error))
end

InvitesXboxLive.init = function (self)
	self._has_invite = false
	self._invites = {}
end

InvitesXboxLive.update = function (self)
	local invites = XboxLiveMPA.invites()

	for i = 1, #invites do
		local invite = invites[i]
		self._invites[#self._invites + 1] = invite
		self._has_invite = true
	end
end

InvitesXboxLive.has_invite = function (self)
	return self._has_invite
end

InvitesXboxLive.get_invite = function (self)
	if self._has_invite then
		local invite = table.remove(self._invites)
		local address = invite.connection_string
		self._has_invite = #self._invites > 0

		return address
	end

	return nil
end

InvitesXboxLive.send_invite = function (self, xuid, invite_address)
	if not Managers.account:user_detached() then
		local user_id = Managers.account:user_id()
		local async_block, error_code = XboxLiveMPA.send_invites(user_id, {
			xuid
		}, true, invite_address)

		if async_block then
			Managers.xasync:wrap(async_block, XboxLiveMPA.release_block):catch(_error_report)
		else
			_error_report(error_code)
		end
	end
end

InvitesXboxLive.reset = function (self)
	table.clear(self._invites)

	self._has_invite = false
end

InvitesXboxLive.xbox_profile_signed_in = function (self, xuid)
	local my_xuid = xuid and XboxLive.xuid_hex_to_dec(xuid)
	local invites = self._invites

	for i = #invites, 1, -1 do
		local invite = invites[i]
		local invited_user = invite.invited_user
		local joiner_xuid = invite.joiner_xuid
		local recipient_xuid = invited_user ~= "0" and invited_user or joiner_xuid ~= "0" and joiner_xuid

		if recipient_xuid and my_xuid and recipient_xuid ~= my_xuid then
			Log.info("InvitesXboxLive", "Clearing invite lingering from previous profile. my_xuid: %s, invite: %s", my_xuid, table.tostring(invite))
			table.remove(invites, i)
		end
	end

	self._has_invite = #invites > 0
end

InvitesXboxLive.destroy = function (self)
	return
end

return InvitesXboxLive
