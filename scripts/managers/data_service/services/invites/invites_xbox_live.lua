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

		table.insert(self._invites, invite.connection_string)

		self._has_invite = true
	end
end

InvitesXboxLive.has_invite = function (self)
	return self._has_invite
end

InvitesXboxLive.get_invite = function (self)
	if self._has_invite then
		local address = table.remove(self._invites)
		self._has_invite = #self._invites > 0

		return address
	end

	return nil
end

InvitesXboxLive.send_invite = function (self, xuid, invite_address)
	local num_users = XUser.num_users()

	if num_users > 0 then
		local users = XUser.users()
		local user_id = users[1].id
		local async_block, error = XboxLiveMPA.send_invites(user_id, {
			xuid
		}, true, invite_address)

		if async_block then
			Managers.xasync:wrap(async_block):catch(_error_report)
		else
			_error_report(error)
		end
	end
end

InvitesXboxLive.destroy = function (self)
	return
end

return InvitesXboxLive
