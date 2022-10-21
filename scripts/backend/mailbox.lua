local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local MailBox = class("MailBox")

local function _decorate_mail(mail, character_id)
	mail.mark_read = function (self)
		return Managers.backend.interfaces.mailbox:mark_mail_read(character_id, self.id)
	end

	mail.mark_unread = function (self)
		return Managers.backend.interfaces.mailbox:mark_mail_unread(character_id, self.id)
	end

	mail.mark_claimed = function (self, reward_idx)
		return Managers.backend.interfaces.mailbox:mark_mail_claimed(character_id, self.id, reward_idx)
	end
end

local function _patch_mail(character_id, mail_id, body)
	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/mail/"):path(mail_id), {
		method = "PATCH",
		body = body
	}):next(function (data)
		local result = data.body

		if result.reward then
			result.reward.gear_id = result.reward.gearId
			result.reward.gearId = nil
		end

		_decorate_mail(result.mail)

		return result
	end)
end

MailBox.get_mail_paged = function (self, character_id, limit, source)
	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/mail"):query("source", source):query("limit", limit or 50)):next(function (data)
		local result = BackendUtilities.wrap_paged_response(data.body)
		result.globals = data.body._embedded.globals

		for i, v in ipairs(result.items) do
			_decorate_mail(v, character_id)
		end

		for i, v in ipairs(result.globals) do
			_decorate_mail(v, character_id)
		end

		return result
	end)
end

MailBox.mark_mail_read = function (self, character_id, mail_id)
	return _patch_mail(character_id, mail_id, {
		read = true
	})
end

MailBox.mark_mail_unread = function (self, character_id, mail_id)
	return _patch_mail(character_id, mail_id, {
		read = false
	})
end

MailBox.mark_mail_claimed = function (self, character_id, mail_id, reward_idx)
	return _patch_mail(character_id, mail_id, {
		claimed = true,
		rewardIndex = reward_idx
	})
end

return MailBox
