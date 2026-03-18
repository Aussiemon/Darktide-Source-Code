-- chunkname: @scripts/managers/voting/voting_notification_handler.lua

local Text = require("scripts/utilities/ui/text")
local VotingNotificationHandler = class("VotingNotificationHandler")

local function _verify_config(config)
	return
end

local function _get_time_left(voting_id)
	local vote_is_ongoing = not Managers.voting:voting_result(voting_id)
	local current_time = vote_is_ongoing and Managers.voting:time_left(voting_id) or 0

	return math.max(math.ceil(current_time), 0)
end

VotingNotificationHandler.init = function (self)
	self._notifications = {}
end

VotingNotificationHandler.destroy = function (self)
	return
end

VotingNotificationHandler._empty_notification = function (self, voting_id, config)
	return {
		grace_time = nil,
		notification_id = nil,
		time_left = nil,
		config = table.clone(config),
		voting_id = voting_id,
		text_cache = {},
	}
end

VotingNotificationHandler._get_dynamic_text = function (self, voting_id)
	local notification = self._notifications[voting_id]
	local time_left = _get_time_left(voting_id)

	if time_left == notification.time_left then
		return notification.text_cache[#notification.text_cache]
	end

	local config = notification.config

	notification.time_left = time_left

	local entries = {}
	local show_timer = config.show_timer

	if show_timer then
		entries[#entries + 1] = Text.format_time_span_long_form_localized(time_left)
	end

	local voting_exists = time_left > 0
	local show_vote_count = voting_exists and config.show_votes and #config.show_votes or 0
	local votes = show_vote_count > 0 and Managers.voting:votes(voting_id)

	if show_vote_count > 0 and votes then
		local vote_count = {}

		for _, answer in pairs(votes) do
			vote_count[answer] = (vote_count[answer] or 0) + 1
		end

		for i = 1, show_vote_count do
			local entry = config.show_votes[i]

			entries[#entries + 1] = string.format("%s: %s", Localize(entry.loc_key), vote_count[entry.key] or 0)
		end
	end

	return table.concat(entries, "  ")
end

VotingNotificationHandler._update_text_cache = function (self, voting_id)
	local notification = self._notifications[voting_id]
	local config = notification.config
	local text_cache = notification.text_cache
	local index = 1

	text_cache[index] = config.title
	index = index + 1

	if config.description then
		text_cache[index] = config.description
		index = index + 1
	end

	local is_dynamic = config.show_timer or config.show_votes and #config.show_votes > 0

	if is_dynamic then
		text_cache[index] = self:_get_dynamic_text(voting_id)
		index = index + 1
	end

	for i = index, 3 do
		text_cache[i] = nil
	end
end

VotingNotificationHandler._create = function (self, voting_id, config, sound_event)
	_verify_config(config)

	local notification = self:_empty_notification(voting_id, config)

	self._notifications[voting_id] = notification

	self:_update_text_cache(voting_id)
	Managers.event:trigger("event_add_notification_message", "voting", {
		texts = notification.text_cache,
	}, function (id)
		notification.notification_id = id
	end, sound_event)
end

VotingNotificationHandler._refresh = function (self, voting_id)
	local notification = self._notifications[voting_id]

	self:_update_text_cache(voting_id)
	Managers.event:trigger("event_update_notification_message", notification.notification_id, notification.text_cache)
end

VotingNotificationHandler.set = function (self, voting_id, config, sound_event)
	local old_notification = self._notifications[voting_id]

	if not old_notification then
		return self:_create(voting_id, config, sound_event)
	end

	local notification_id = old_notification.notification_id

	_verify_config(config)

	self._notifications[voting_id] = self:_empty_notification(voting_id, config)
	self._notifications[voting_id].notification_id = notification_id

	if sound_event then
		Managers.ui:play_2d_sound(sound_event)
	end

	self:_refresh(voting_id)
end

VotingNotificationHandler.unset = function (self, voting_id)
	local notification = self._notifications[voting_id]

	if not notification then
		Log.warning("VotingNotificationHandler", "Attempting to unset non-existent notification w. id: %s.", voting_id)

		return
	end

	self._notifications[voting_id] = nil

	local notification_id = notification.notification_id

	Managers.event:trigger("event_remove_notification", notification_id)
end

VotingNotificationHandler._update_notification = function (self, voting_id, dt, t, input_service)
	local notification = self._notifications[voting_id]
	local config = notification.config
	local inputs = config.inputs

	if inputs then
		for alias, input_callback in pairs(inputs) do
			if input_service:get(alias) then
				input_callback()
			end
		end
	end

	local real_time_left = _get_time_left(voting_id)
	local is_dynamic = config.show_votes and #config.show_votes > 0 or config.show_timer

	if is_dynamic then
		local recorded_time_left = notification.time_left

		if real_time_left ~= recorded_time_left then
			self:_refresh(voting_id)
		end
	end

	local voting_exists = real_time_left > 0 and Managers.voting:voting_exists(voting_id)

	if not voting_exists and config.keep_alive then
		notification.keep_alive = notification.keep_alive or config.keep_alive
	end

	local keep_alive = notification.keep_alive

	if keep_alive and keep_alive ~= true then
		notification.keep_alive = notification.keep_alive - dt

		if notification.keep_alive <= 0 then
			keep_alive = false
		end
	end

	return voting_exists or keep_alive
end

VotingNotificationHandler.update = function (self, dt, t)
	local input_service = Managers.ui:input_service()

	for voting_id, _ in pairs(self._notifications) do
		local should_keep = self:_update_notification(voting_id, dt, t, input_service)

		if not should_keep then
			self:unset(voting_id)
		end
	end
end

return VotingNotificationHandler
