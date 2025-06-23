-- chunkname: @scripts/managers/live_event/live_event_manager.lua

local Items = require("scripts/utilities/items")
local LiveEvents = require("scripts/settings/live_event/live_events")
local Promise = require("scripts/foundation/utilities/promise")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local LiveEventManager = class("LiveEventManager")
local REFRESH_TIMER_SUCCESS = 300
local REFRESH_TIMER_FAILURE = 60
local STATE_FAIL_DELAY = 60
local CLIENT_RPCS = {
	"rpc_live_event_trigger_combat_feed"
}

LiveEventManager.init = function (self, is_host, event_delegate)
	self._events = {}
	self._active_event_id = nil
	self._is_host = not not is_host
	self._event_delegate = event_delegate

	if not is_host then
		self._event_delegate:register_connection_events(self, unpack(CLIENT_RPCS))
	end

	self._players = {}
	self._time_since_update = 0
end

LiveEventManager.destroy = function (self)
	local refresh_promise = self._refresh_promise

	if refresh_promise and refresh_promise:is_pending() then
		refresh_promise:cancel()
	end

	self:_stop_current_event()

	if not self._is_host then
		self._event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

LiveEventManager.add_player = function (self, id, account_id, is_local)
	self._players[id] = {
		id = id,
		account_id = account_id,
		is_local = is_local,
		progress = {}
	}
end

LiveEventManager.has_player = function (self, id)
	return self._players[id] ~= nil
end

LiveEventManager.remove_player = function (self, id)
	local promise = Promise.resolved()
	local player_data = self._players[id]
	local event_id = self:active_event_id()
	local account_id = player_data.account_id
	local is_host = self._is_host
	local has_data = player_data.progress[event_id] ~= nil

	if is_host and event_id and account_id and has_data then
		self:_update_player_xp(id, event_id)

		local active_event_xp = table.nested_get(player_data, "progress", event_id, "xp")

		if active_event_xp and active_event_xp ~= 0 then
			promise = Managers.backend.interfaces.tracks:modify_track_account_state(account_id, event_id, active_event_xp):catch(function (error)
				if type(error) == "string" then
					Log.error("LiveEventManager", "Failed to modify track account state:\n%s\n-------", error)
				else
					Log.error("LiveEventManager", "Failed to modify track account state:\n%s\n-------", table.tostring(error, 5))
				end
			end)
		end
	end

	self._players[id] = nil

	return promise
end

LiveEventManager.remove_all = function (self)
	local promises = {}

	for id, _ in pairs(self._players) do
		local promise = self:remove_player(id)

		if promise then
			promises[#promises + 1] = promise
		end
	end

	if #promises == 0 then
		return Promise.resolved()
	end

	return Promise.all(unpack(promises))
end

LiveEventManager._on_tier_claimed_success = function (self, id, event_id, completed_tier, result)
	local event_data = self._events[event_id]
	local player_data = self._players[id]

	if not event_data or not player_data then
		return Promise.resolved()
	end

	local progress_data = table.nested_get(player_data, "progress", event_id)

	if not progress_data then
		return Promise.resolved()
	end

	local rewards = result.body.rewards

	for _, reward in pairs(rewards) do
		if reward.type == "currency" then
			local reason = Localize("loc_event_tier_completed")

			Managers.event:trigger("event_add_notification_message", "currency", {
				reason = reason,
				currency = reward.currency,
				amount = reward.amount
			})
		elseif reward.type == "item" then
			local rewarded_master_item = Items.register_track_reward(reward)
			local sound_event = UISoundEvents.character_news_feed_new_item
			local reason = Localize("loc_item_rewarded_from_live_event")

			Managers.event:trigger("event_add_notification_message", "item_granted", {
				reason = reason,
				item = rewarded_master_item
			}, nil, sound_event)
		end
	end

	progress_data.tier = progress_data.tier + 1

	return Managers.data_service.store:on_event_tier_completed(result):next(callback(self, "_claim_next_tier", id, event_id))
end

LiveEventManager._on_tier_claimed_fail = function (self, id, event_id, completed_tier, error)
	Log.warning("LiveEventManager", "Failed to claim reward for tier %s with error: %s", completed_tier, type(error) == "table" and table.tostring(error, 3) or error)
	Managers.data_service.store:invalidate_wallets_cache()

	return Promise.rejected(error)
end

LiveEventManager._claim_next_tier = function (self, id, event_id)
	local event_data = self._events[event_id]
	local player_data = self._players[id]

	if not event_data or not player_data then
		return Promise.resolved()
	end

	local progress_data = table.nested_get(player_data, "progress", event_id)

	if not progress_data then
		return Promise.resolved()
	end

	local tier = progress_data.tier
	local value = progress_data.value
	local tier_data = event_data.tiers[tier + 2]

	if not tier_data or value < tier_data.target then
		return Promise.resolved()
	end

	local account_id = player_data.account_id

	if not account_id then
		return
	end

	return Managers.backend.interfaces.tracks:claim_track_tier(event_id, tier + 1, account_id):next(callback(self, "_on_tier_claimed_success", id, event_id, tier + 1), callback(self, "_on_tier_claimed_fail", id, event_id, tier + 1))
end

LiveEventManager._on_track_state_success = function (self, id, event_id, backend_data)
	if backend_data == nil then
		backend_data = {
			state = {
				xpTracked = 0,
				rewarded = -1
			}
		}
	end

	local player_data = self._players[id]

	if not player_data then
		return
	end

	local progress_data = player_data.progress[event_id]

	if not progress_data then
		return
	end

	progress_data.promise = nil
	progress_data.backend_data = backend_data

	local backend_state = backend_data.state

	if not backend_state.rewarded then
		Log.warning("LiveEventManager", "on_track_state_success bad data")
		table.dump(backend_data, "backend_data", 10)
	end

	progress_data.value = backend_state.xpTracked
	progress_data.tier = backend_state.rewarded
	progress_data.update_timer = nil

	return self:_claim_next_tier(id, event_id)
end

LiveEventManager._on_track_state_fail = function (self, id, event_id, error)
	if error.code == 404 then
		Log.info("LiveEventManager", "Backend failed with error 404 for user '%s' and event '%s'. Using dummy data.", id, event_id)

		return self:_on_track_state_success(id, event_id)
	end

	local player_data = self._players[id]
	local progress_data = player_data and player_data.progress[event_id]

	if progress_data then
		progress_data.promise = nil
		progress_data.update_timer = 0
	end

	return Promise.rejected(error)
end

LiveEventManager._update_player_xp = function (self, id, event_id)
	local is_host = self._is_host

	if not is_host then
		return
	end

	local player_data = self._players[id]
	local event_data = player_data.progress[event_id]

	event_data.xp = math.max(self:_get_current_xp(id, event_id), event_data.xp or 0)
end

LiveEventManager._update_player = function (self, dt, id)
	local player_data = self._players[id]
	local account_id = player_data.account_id

	for event_id, _ in pairs(self._events) do
		if not player_data.progress[event_id] then
			player_data.progress[event_id] = {}
		end

		local event_data = player_data.progress[event_id]
		local has_timer = event_data.update_timer ~= nil

		if has_timer then
			event_data.update_timer = event_data.update_timer + dt
		end

		local should_write = account_id and player_data.is_local
		local has_data = event_data.value ~= nil
		local can_write = not event_data.promise and (not has_timer or event_data.update_timer >= STATE_FAIL_DELAY)
		local should_update = should_write and not has_data and can_write

		if should_update then
			event_data.promise = Managers.backend.interfaces.tracks:get_track_state(event_id, account_id):next(callback(self, "_on_track_state_success", id, event_id), callback(self, "_on_track_state_fail", id, event_id))
		end

		self:_update_player_xp(id, event_id)
	end
end

LiveEventManager.refresh_progress = function (self)
	for _, player_data in pairs(self._players) do
		local progress = player_data.progress

		for event_id, _ in pairs(self._events) do
			if progress[event_id] and not progress[event_id].promise then
				progress[event_id] = nil
			end
		end
	end
end

LiveEventManager._needs_update = function (self, dt, t)
	return self._time_since_update > REFRESH_TIMER_SUCCESS
end

LiveEventManager._stop_current_event = function (self)
	self._active_event_id = nil

	if self._listener_id then
		Managers.stats:remove_listener(self._listener_id)

		self._listener_id = nil
	end
end

LiveEventManager._start_event = function (self, event_id)
	local event_data = self._events[event_id]
	local template = LiveEvents[event_data.template_name]
	local combat_feed = template.combat_feed

	if combat_feed and self._is_host then
		self._listener_id = Managers.stats:add_listener("TEAM", {
			combat_feed.stat_id
		}, callback(self, "_trigger_combat_feed", event_id))
	end

	self._active_event_id = event_id
end

LiveEventManager._update_active_event = function (self, dt, t)
	local active_event_id, lowest_time = nil, math.huge
	local server_time = Managers.backend:get_server_time(t)

	for event_id, event_data in pairs(self._events) do
		local starts_at, ends_at = event_data.starts_at, event_data.ends_at
		local has_values = starts_at and ends_at
		local is_active = has_values and starts_at <= server_time and server_time <= ends_at

		if is_active and starts_at < lowest_time then
			active_event_id = event_id
		end
	end

	if active_event_id ~= self._active_event_id then
		self:_stop_current_event()
	end

	if active_event_id ~= self._active_event_id then
		self:_start_event(active_event_id)
	end
end

LiveEventManager.update = function (self, dt, t)
	local is_refreshing = self._refresh_promise

	if not is_refreshing then
		self._time_since_update = self._time_since_update + dt
	end

	local needs_update = self:_needs_update(dt, t)

	if needs_update and not is_refreshing then
		self:refresh()
	end

	for id, _ in pairs(self._players) do
		self:_update_player(dt, id)
	end

	self:_update_active_event(dt, t)
end

local function get_template_name_from_old_category(str)
	if type(str) ~= "string" then
		return
	end

	local parts = string.split(str, "-")

	if #parts < 2 or parts[1] ~= "event" then
		return
	end

	return table.concat(table.slice(parts, 2, #parts - 2), "-")
end

local function get_template_name_from_track_name(str)
	if type(str) ~= "string" then
		return
	end

	local parts = string.split(str, "-")

	return table.concat(table.slice(parts, 1, #parts - 1), "-")
end

LiveEventManager._clear_events = function (self)
	local events = self._events

	table.clear(events)
end

LiveEventManager._add_event = function (self, backend_data)
	local id = backend_data.id
	local category = backend_data.category
	local name = backend_data.name

	Log.info("LiveEventManager", "Category: %s, name: %s", category, backend_data.name)

	local template_name = get_template_name_from_track_name(name)

	Log.info("LiveEventManager", "template-name: %s", template_name)

	if not LiveEvents[template_name] then
		template_name = get_template_name_from_old_category(category)

		Log.info("LiveEventManager", "template-name: %s", template_name)
	end

	if not LiveEvents[template_name] then
		Log.warning("LiveEventManager", "No template for event '%s' with category '%s'.", id, category)

		return
	else
		Log.info("LiveEventManager", "Added live event '%s', id '%s' with category '%s'.", template_name, id, category)
	end

	local tiers = {}
	local backend_tiers = backend_data.tiers
	local tier_count = backend_tiers and #backend_tiers

	for i = 1, tier_count do
		local tier = backend_tiers[i]
		local rewards = {}

		for _, reward in pairs(tier.rewards) do
			rewards[#rewards + 1] = {
				id = reward.id,
				type = reward.type,
				amount = reward.amount,
				currency = reward.currency
			}
		end

		tiers[i] = {
			backend_index = i - 1,
			target = tier.xpLimit,
			rewards = rewards
		}
	end

	local starts_at = tonumber(backend_data.validFrom)
	local ends_at = tonumber(backend_data.validTo)
	local events = self._events

	events[id] = {
		is_active = false,
		id = id,
		template_name = template_name,
		starts_at = starts_at,
		ends_at = ends_at,
		tiers = tiers
	}
end

LiveEventManager._on_refresh_success = function (self, backend_events)
	self._refresh_promise = nil
	self._time_since_update = 0

	self:_clear_events()

	for i = 1, #backend_events do
		local event_data = backend_events[i]

		self:_add_event(event_data)
	end
end

LiveEventManager._on_refresh_fail = function (self, error)
	self._refresh_promise = nil
	self._time_since_update = REFRESH_TIMER_SUCCESS - REFRESH_TIMER_FAILURE

	return Promise.rejected(error)
end

LiveEventManager.refresh = function (self)
	if self._refresh_promise then
		return self._refresh_promise
	end

	self._refresh_promise = Managers.backend.interfaces.tracks:get_event_tracks():next(callback(self, "_on_refresh_success"), callback(self, "_on_refresh_fail"))
end

LiveEventManager._active_event = function (self)
	return self._events[self._active_event_id]
end

LiveEventManager.active_template = function (self)
	local active_event = self:_active_event()

	return active_event and LiveEvents[active_event.template_name]
end

LiveEventManager.active_tiers = function (self)
	local active_event = self:_active_event()

	return active_event and active_event.tiers
end

LiveEventManager.active_event_id = function (self)
	return self._events[self._active_event_id] and self._active_event_id or nil
end

LiveEventManager._get_current_xp = function (self, id, event_id)
	local event = self._events[event_id]
	local template = LiveEvents[event.template_name]
	local stat_id = template.stat

	if not stat_id then
		return 0
	end

	return Managers.stats:read_user_stat(id, stat_id)
end

LiveEventManager.active_progress = function (self, optional_id)
	local id = optional_id or 1
	local player_data = self._players[id]

	if not player_data then
		return 0
	end

	local event_id = self:active_event_id()
	local progress_data = player_data.progress[event_id]

	if not progress_data or not progress_data.value then
		return 0
	end

	return (progress_data.value or 0) + self:_get_current_xp(id, event_id)
end

LiveEventManager.active_time_left = function (self, optional_t)
	local event_data = self:_active_event()

	if not event_data or not event_data.ends_at then
		return 0
	end

	local t = Managers.backend:get_server_time(optional_t or Managers.time:time("main"))

	return (event_data.ends_at - t) / 1000
end

LiveEventManager._show_combat_feed_message = function (self, amount)
	local event_data = self:_active_event()

	if not event_data then
		return
	end

	local template = LiveEvents[event_data.template_name]
	local combat_feed = template.combat_feed

	if not combat_feed then
		return
	end

	local loc_key = combat_feed.loc_key
	local message = Localize(loc_key, true, {
		amount = amount
	})
	local notification_type = table.nested_get(Managers.save:account_data(), "interface_settings", "crafting_pickup_notification_type")

	if notification_type == "combat_feed" then
		Managers.event:trigger("event_add_combat_feed_message", message)
	elseif notification_type == "notification" then
		Managers.event:trigger("event_add_notification_message", "default", message)
	end
end

LiveEventManager.rpc_live_event_trigger_combat_feed = function (self, channel_id, amount)
	self:_show_combat_feed_message(amount)
end

LiveEventManager._trigger_combat_feed = function (self, event_id, listener_id, stat_id, amount)
	if self._is_host then
		Managers.state.game_session:send_rpc_clients("rpc_live_event_trigger_combat_feed", amount)
	end
end

return LiveEventManager
