local BackendInterface = require("scripts/backend/backend_interface")
local Definitions = require("scripts/ui/hud/elements/character_news_feed/hud_element_character_news_feed_definitions")
local HudElementCharacterNewsFeedSettings = require("scripts/ui/hud/elements/character_news_feed/hud_element_character_news_feed_settings")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local HudElementCharacterNewsFeed = class("HudElementCharacterNewsFeed", "HudElementBase")

HudElementCharacterNewsFeed.init = function (self, parent, draw_layer, start_scale, definitions)
	HudElementCharacterNewsFeed.super.init(self, parent, draw_layer, start_scale, Definitions)
	self:_fetch_inventory_items()
	self:_register_event("event_resync_character_news_feed", "event_resync_character_news_feed")
end

HudElementCharacterNewsFeed._fetch_inventory_items = function (self)
	if self._gear_promise then
		self._gear_promise:cancel()

		self._gear_promise = nil
	end

	self._inventory_items = nil
	self._new_presentation_items = nil
	local gear_promise = nil

	if Managers.backend:authenticated() then
		local backend_interface = BackendInterface:new()
		gear_promise = Promise.all(backend_interface.gear:fetch())

		local function next_function(results)
			if self._destroyed then
				return
			end

			local gear_list = unpack(results)
			local inventory = {}

			for gear_id, gear in pairs(gear_list) do
				local gear_item = MasterItems.get_item_instance(gear, gear_id)
				inventory[gear_id] = gear_item
			end

			self._inventory_items = inventory
			self._new_presentation_items = self:_fetch_new_items()
			self._gear_promise = nil
		end

		local next_promise = gear_promise:next(next_function)

		local function catch_function(errors)
			local error_string = nil

			if type(errors) == "table" then
				local gear_list_error = unpack(errors)
				error_string = tostring(gear_list_error)
			else
				error_string = errors
			end

			Log.error("HudElementCharacterNewsFeed", "Error fetching inventory: %s", error_string)

			self._gear_promise = nil
		end

		next_promise:catch(catch_function)
	end

	self._gear_promise = gear_promise
end

HudElementCharacterNewsFeed.event_resync_character_news_feed = function (self)
	self:_fetch_inventory_items()
end

HudElementCharacterNewsFeed.destroy = function (self)
	if self._gear_promise then
		self._gear_promise:cancel()

		self._gear_promise = nil
	end

	HudElementCharacterNewsFeed.super.destroy(self)
end

HudElementCharacterNewsFeed._fetch_new_items = function (self)
	local new_item_notifications = ItemUtils.new_item_notification_ids()

	if new_item_notifications and not table.is_empty(new_item_notifications) then
		local new_items_by_inventory = {}
		local show_item_notification = {}

		for gear_id, notification_data in pairs(new_item_notifications) do
			local has_item, item = self:_has_item_in_inventory(gear_id)

			if has_item then
				new_items_by_inventory[#new_items_by_inventory + 1] = {
					item = item,
					show_notification = notification_data.show_notification
				}
			else
				ItemUtils.unmark_item_notification_id_as_new(gear_id)
			end
		end

		if #new_items_by_inventory > 0 then
			return new_items_by_inventory
		end
	end
end

HudElementCharacterNewsFeed._present_next_new_item = function (self, dt)
	local new_presentation_items = self._new_presentation_items

	if not new_presentation_items then
		return
	end

	if self._item_presentation_delay then
		self._item_presentation_delay = self._item_presentation_delay - dt

		if self._item_presentation_delay < 0 then
			self._item_presentation_delay = nil
		else
			return
		end
	end

	local item_data = table.remove(new_presentation_items, 1)

	if item_data.show_notification then
		local event_name = "event_add_notification_message"
		local message_type = "item_granted"

		Managers.event:trigger(event_name, message_type, item_data.item)
	end

	local gear_id = item_data.item.gear_id

	ItemUtils.unmark_item_notification_id_as_new(gear_id)

	if #new_presentation_items > 0 then
		self._item_presentation_delay = HudElementCharacterNewsFeedSettings.item_presentation_delay
	else
		self._new_presentation_items = nil
	end
end

HudElementCharacterNewsFeed._has_item_in_inventory = function (self, gear_id)
	local item = self._inventory_items[gear_id]
	local has_item = item ~= nil

	return has_item, item
end

HudElementCharacterNewsFeed.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementCharacterNewsFeed.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	if self._new_presentation_items and self._inventory_items then
		self:_present_next_new_item(dt)
	end
end

return HudElementCharacterNewsFeed
