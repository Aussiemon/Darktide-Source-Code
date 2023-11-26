-- chunkname: @scripts/backend/mailbox.lua

local Promise = require("scripts/foundation/utilities/promise")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local MailBox = class("MailBox")

local function _decorate_mail(mail)
	mail.mark_read = function (self)
		return Managers.backend.interfaces.mailbox:mark_mail_read(mail)
	end

	mail.mark_unread = function (self)
		return Managers.backend.interfaces.mailbox:mark_mail_unread(mail)
	end

	mail.mark_claimed = function (self, reward_idx)
		return Managers.backend.interfaces.mailbox:mark_mail_claimed(mail, reward_idx)
	end
end

local function _patch_mail(mail, body)
	local self_url = mail and mail._links and mail._links.self and mail._links.self.href

	return Managers.backend:title_request(BackendUtilities.url_builder(self_url):to_string(), {
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
	local promise

	if character_id then
		promise = BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/mail"):query("source", source):query("limit", limit))
	else
		promise = BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder("/mail"):query("source", source):query("limit", limit))
	end

	return promise:next(function (data)
		local result = BackendUtilities.wrap_paged_response(data.body)

		result.globals = data.body._embedded.globals

		for i, v in ipairs(result.items) do
			_decorate_mail(v)
		end

		for i, v in ipairs(result.globals) do
			_decorate_mail(v)
		end

		return result
	end)
end

MailBox.mark_mail_read = function (self, mail)
	if mail.isRead then
		return Promise.resolved()
	end

	return _patch_mail(mail, {
		read = true
	}):next(function ()
		mail.isRead = true
	end)
end

MailBox.mark_mail_unread = function (self, mail)
	if not mail.isRead then
		return Promise.resolved()
	end

	return _patch_mail(mail, {
		read = false
	}):next(function ()
		mail.isRead = false
	end)
end

MailBox.mark_mail_claimed = function (self, mail, reward_idx)
	if mail.claimed then
		return Promise.resolved()
	end

	return _patch_mail(mail, {
		claimed = true,
		rewardIndex = reward_idx
	}):next(function ()
		mail.claimed = true
		mail.rewardIndex = reward_idx
	end)
end

return MailBox
