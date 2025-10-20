-- chunkname: @scripts/managers/data_service/services/news_service.lua

local Items = require("scripts/utilities/items")
local Promise = require("scripts/foundation/utilities/promise")
local NewsService = class("NewsService")

local function to_news_item(mail)
	local news = {
		id = mail.id,
		message = mail.message,
		created = mail.created,
		attachments = mail.attachments,
		mark_claimed = mail.mark_claimed,
		mark_read = mail.mark_read,
		mark_mail_read_and_claimed = mail.mark_mail_read_and_claimed,
		mark_unread = mail.mark_unread,
		is_read = function ()
			return mail.isRead
		end,
	}
	local properties = mail.properties

	if properties then
		table.merge(news, properties)
	end

	return news
end

local function filter_news(news)
	local filtered_news = {}

	for i = 1, #news do
		local news_item = news[i]
		local platform = news_item.platform

		if not platform or platform == "xbox" and IS_XBS or platform == "pc" and IS_WINDOWS or platform == "ps5" and IS_PLAYSTATION then
			table.insert(filtered_news, news_item)
		end
	end

	return filtered_news
end

NewsService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
	self._cached_data = {}
	self._cached_promise = {}
end

NewsService._get_category = function (self, category, use_cache)
	local cached_promise = self._cached_promise[category]

	if cached_promise then
		return cached_promise
	end

	local cached_data = self._cached_data[category]

	if use_cache ~= false and cached_data then
		return Promise.resolved(cached_data)
	end

	local promise = self._backend_interface.mailbox:get_mail_paged(nil, 100, true, true, category):next(function (data)
		local news = {}

		for i = 1, #data.globals do
			table.insert(news, to_news_item(data.globals[i]))
		end

		for i = 1, #data.items do
			table.insert(news, to_news_item(data.items[i]))
		end

		return news
	end):catch(function (error)
		local error_string = tostring(error)

		Log.error("NewsService", "Error fetching news: %s", error_string)

		return {}
	end):next(function (news)
		self._cached_promise[category] = nil

		local filtered = filter_news(news)

		self._cached_data[category] = filtered

		return filtered
	end)

	self._cached_promise[category] = promise

	return promise
end

NewsService.get_news = function (self)
	return self:_get_category("news", true)
end

NewsService.get_events = function (self)
	return self:_get_category("event", false)
end

NewsService.get_rewards = function (self)
	return self:_get_category("compensation", false)
end

NewsService.claim_rewards = function (self)
	return self:get_rewards():next(function (news_items)
		return Promise.chain(news_items, function (news_item)
			if news_item.is_read() then
				return nil
			end

			local attachments = news_item.attachments

			if not attachments or #attachments ~= 1 then
				return nil
			end

			local attached_item = attachments[1].item

			if not attached_item then
				return nil
			end

			local reason = news_item.message or ""
			local master_item_id = attached_item.id

			return news_item:mark_mail_read_and_claimed(0):next(function (result)
				if not result then
					return nil
				end

				local gear_id = result and result.reward and result.reward.gear_id

				if not gear_id or not master_item_id then
					return nil
				end

				Items.advertise_reward(reason, master_item_id, gear_id)

				return result and result.mail
			end)
		end)
	end)
end

return NewsService
