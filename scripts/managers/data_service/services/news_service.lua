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
		self._cached_data[category] = news

		return filter_news(news)
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

return NewsService
