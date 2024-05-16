-- chunkname: @scripts/ui/constant_elements/elements/notification_feed/constant_element_notification_feed_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local constant_element_notification_feed_settings = {
	default_alpha_value = 0.75,
	entry_spacing = 10,
	max_visible_notifications = 5,
	text_height_spacing = 15,
	header_size = {
		470,
		44,
	},
	events = {
		{
			"event_add_notification_message",
			"event_add_notification_message",
		},
		{
			"event_update_notification_message",
			"event_update_notification_message",
		},
		{
			"event_remove_notification",
			"event_remove_notification",
		},
		{
			"event_clear_notifications",
			"event_clear_notifications",
		},
		{
			"event_update_assist_notification_type",
			"event_update_assist_notification_type",
		},
		{
			"event_update_crafting_pickup_notification_type",
			"event_update_crafting_pickup_notification_type",
		},
	},
	trait_sound_events_by_rarity = {
		UISoundEvents.notification_trait_received_rarity_1,
		UISoundEvents.notification_trait_received_rarity_2,
		UISoundEvents.notification_trait_received_rarity_3,
		UISoundEvents.notification_trait_received_rarity_4,
	},
}

return settings("ConstantElementNotificationFeedSettings", constant_element_notification_feed_settings)
