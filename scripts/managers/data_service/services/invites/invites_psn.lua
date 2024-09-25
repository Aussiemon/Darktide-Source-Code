-- chunkname: @scripts/managers/data_service/services/invites/invites_psn.lua

local InvitesPSN = class("InvitesPSN")

InvitesPSN.init = function (self)
	self._invite_code_promise = nil
	self._invite = nil
end

InvitesPSN.update = function (self)
	if self._invite_code_promise then
		return
	end

	local session_id = NpPlayerSession.check_for_invite()

	if session_id then
		self._invite_code_promise = Managers.account:get_immaterium_invite_code_from_psn_session(session_id)

		self._invite_code_promise:next(function (invite_code)
			self._invite = {
				code = invite_code,
				recipient_account_id = Managers.account:platform_user_id(),
			}
			self._invite_code_promise = nil
		end):catch(function (err)
			self._invite = nil
			self._invite_code_promise = nil
		end)
	end
end

InvitesPSN.has_invite = function (self)
	return self._invite ~= nil
end

InvitesPSN.get_invite = function (self)
	if self._invite then
		local code = self._invite.code

		self._invite = nil

		return code
	end

	return nil
end

InvitesPSN.send_invite = function (self, invitee_psn_account_id, invite_code)
	Managers.account:send_psn_session_invite(invitee_psn_account_id)
end

InvitesPSN.reset = function (self)
	if self._invite_code_promise then
		self._invite_code_promise:cancel()

		self._invite_code_promise = nil
	end

	self._invite = nil
end

InvitesPSN.on_profile_signed_in = function (self, account_id)
	if self._invite and self._invite.recipient_account_id ~= account_id then
		self._invite = nil
	end
end

InvitesPSN.destroy = function (self)
	return
end

return InvitesPSN
