-- chunkname: @scripts/managers/data_service/services/news_service.lua

local Promise = require("scripts/foundation/utilities/promise")
local NewsService = class("NewsService")

local function to_news_item(mail)
	local properties = mail.properties
	local news = {
		id = mail.id,
		message = mail.message,
		created = mail.created,
		mark_claimed = mail.mark_claimed,
		mark_read = mail.mark_read,
		mark_unread = mail.mark_unread,
		is_read = function ()
			return mail.isRead
		end,
	}

	table.merge(news, properties)

	return news
end

local function filter_news(news)
	local filtered_news = {}

	for i = 1, #news do
		local news_item = news[i]
		local platform = news_item.platform

		if not platform or platform == "xbox" and IS_XBS then
			table.insert(filtered_news, news_item)
		end
	end

	return filtered_news
end

NewsService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
	self._cached_news = nil
end

NewsService.get_news = function (self)
	local promise

	if self._cached_news then
		promise = Promise.resolved(self._cached_news)
	else
		promise = self._backend_interface.mailbox:get_mail_paged(nil, 100, true, true, "news"):next(function (data)
			local news = {}

			for i = 1, #data.globals do
				table.insert(news, to_news_item(data.globals[i]))
			end

			for i = 1, #data.items do
				table.insert(news, to_news_item(data.items[i]))
			end

			self._cached_news = news

			return news
		end):catch(function (error)
			local error_string = tostring(error)

			Log.error("NewsService", "Error fetching news: %s", error_string)

			return {}
		end)
	end

	return promise:next(function (news)
		return filter_news(news)
	end)
end

return NewsService
