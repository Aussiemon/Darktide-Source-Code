local Text = require("scripts/utilities/ui/text")
local VotingNotificationHandler = class("VotingNotificationHandler")

VotingNotificationHandler.init = function (self)
	self._notifications = {}
end

VotingNotificationHandler.destroy = function (self)
	return
end

local function _verify_data(data)
	return
end

VotingNotificationHandler._format_time = function (self, seconds)
	return Text.format_time_span_long_form_localized(seconds)
end

VotingNotificationHandler._get_text = function (self, voting_id)
	local notification = self._notifications[voting_id]
	local data = notification.data
	local text_cache = notification.text_cache

	if text_cache then
		if data.show_timer then
			local t = notification.time_left
			text_cache[#text_cache] = self:_format_time(t)
		end

		return text_cache
	end

	local texts = {
		data.title
	}

	table.append(texts, data.lines)

	if data.show_timer then
		local t = notification.time_left
		texts[#texts + 1] = self:_format_time(t)
	end

	notification.text_cache = texts

	return texts
end

VotingNotificationHandler.create = function (self, voting_id, data)
	_verify_data(data)

	local notification = {}
	self._notifications[voting_id] = notification
	notification.data = data

	if data.show_timer then
		notification.time_left = math.ceil(Managers.voting:time_left(voting_id) or 0)
	end

	Managers.event:trigger("event_add_notification_message", "voting", {
		texts = self:_get_text(voting_id)
	}, function (id)
		notification.id = id
	end)
end

VotingNotificationHandler.modify = function (self, voting_id, data, optional_clear_cache)
	_verify_data(data)

	local notification = self._notifications[voting_id]

	if not notification then
		return
	end

	if optional_clear_cache ~= false then
		notification.text_cache = nil
	end

	notification.data = data

	if data.show_timer then
		notification.time_left = math.ceil(Managers.voting:time_left(voting_id) or 0)
	end

	Managers.event:trigger("event_update_notification_message", notification.id, self:_get_text(voting_id))
end

VotingNotificationHandler.remove = function (self, voting_id)
	local notification = self._notifications[voting_id]

	if notification then
		self._notifications[voting_id] = nil
		local id = notification.id

		Managers.event:trigger("event_remove_notification", id)
	end
end

VotingNotificationHandler.update = function (self, dt, t)
	local input_service = Managers.ui:input_service()

	for voting_id, notification in pairs(self._notifications) do
		local notification_data = notification.data
		local inputs = notification_data.inputs

		for alias, input_callback in pairs(inputs) do
			if input_service:get(alias) then
				input_callback()
			end
		end

		if notification_data.show_timer then
			local real_time_left = math.ceil(Managers.voting:time_left(voting_id) or 0)
			local recorded_time_left = notification.time_left

			if real_time_left ~= recorded_time_left then
				self:modify(voting_id, notification.data, false)
			end
		end
	end
end

return VotingNotificationHandler
