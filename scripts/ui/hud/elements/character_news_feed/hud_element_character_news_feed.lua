-- chunkname: @scripts/ui/hud/elements/character_news_feed/hud_element_character_news_feed.lua

local BackendInterface = require("scripts/backend/backend_interface")
local Definitions = require("scripts/ui/hud/elements/character_news_feed/hud_element_character_news_feed_definitions")
local HudElementCharacterNewsFeedSettings = require("scripts/ui/hud/elements/character_news_feed/hud_element_character_news_feed_settings")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local HudElementCharacterNewsFeed = class("HudElementCharacterNewsFeed", "HudElementBase")
local character_cached_inventory = {}

HudElementCharacterNewsFeed.init = function (self, parent, draw_layer, start_scale, definitions)
	self._new_presentation_items = {}

	HudElementCharacterNewsFeed.super.init(self, parent, draw_layer, start_scale, Definitions)
	self:_register_event("event_resync_character_news_feed", "event_resync_character_news_feed")
	self:event_resync_character_news_feed()
end

HudElementCharacterNewsFeed.event_resync_character_news_feed = function (self)
	local new_item_notifications = ItemUtils.new_item_notification_ids()

	if new_item_notifications and not table.is_empty(new_item_notifications) then
		local local_player_id = 1
		local local_player = Managers.player:local_player(local_player_id)
		local character_id = local_player:character_id()

		if self._gear_promise then
			self._gear_promise:cancel()

			self._gear_promise = nil
		end

		self._gear_promise = Managers.data_service.gear:fetch_gear(character_id):next(function (gear_list)
			self._gear_promise = nil

			if self._destroyed then
				return
			end

			for gear_id, notification_data in pairs(new_item_notifications) do
				local gear = gear_list and gear_list[gear_id]

				if gear and type(notification_data) == "table" then
					local new_presentation_items = self._new_presentation_items
					local item_already_found = false

					for i = 1, #new_presentation_items do
						local new_presentation_item = new_presentation_items[i]

						if new_presentation_item and new_presentation_item.item_gear_id == gear_id then
							item_already_found = true

							break
						end
					end

					if not item_already_found then
						local show_notification = notification_data.show_notification

						if show_notification == nil then
							show_notification = false
						end

						self._new_presentation_items[#self._new_presentation_items + 1] = {
							item = MasterItems.get_item_instance(gear, gear_id),
							show_notification = show_notification,
							item_gear_id = gear_id,
						}
					end
				else
					ItemUtils.unmark_item_notification_id_as_new(gear_id)
				end
			end
		end)
	end
end

HudElementCharacterNewsFeed._present_next_new_item = function (self, dt)
	if self._item_presentation_delay then
		self._item_presentation_delay = self._item_presentation_delay - dt

		if self._item_presentation_delay <= 0 then
			self._item_presentation_delay = nil
		else
			return
		end
	end

	local item_data = table.remove(self._new_presentation_items, 1)

	if item_data.show_notification then
		local event_name = "event_add_notification_message"
		local message_type = "item_granted"

		Managers.event:trigger(event_name, message_type, item_data.item)
	end

	local gear_id = item_data.item.gear_id

	ItemUtils.unmark_item_notification_id_as_new(gear_id)

	if #self._new_presentation_items > 0 then
		self._item_presentation_delay = HudElementCharacterNewsFeedSettings.item_presentation_delay
	end
end

HudElementCharacterNewsFeed.destroy = function (self, ui_renderer)
	if self._gear_promise then
		self._gear_promise:cancel()

		self._gear_promise = nil
	end

	HudElementCharacterNewsFeed.super.destroy(self, ui_renderer)
end

HudElementCharacterNewsFeed.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementCharacterNewsFeed.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	if not table.is_empty(self._new_presentation_items) then
		self:_present_next_new_item(dt)
	end
end

return HudElementCharacterNewsFeed
