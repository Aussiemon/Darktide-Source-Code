local constant_element_notification_feed_settings = {
	entry_spacing = 10,
	text_height_spacing = 15,
	header_size = {
		470,
		44
	},
	events = {
		{
			"event_add_notification_message",
			"event_add_notification_message"
		},
		{
			"event_update_notification_message",
			"event_update_notification_message"
		},
		{
			"event_remove_notification",
			"event_remove_notification"
		}
	}
}

return settings("ConstantElementNotificationFeedSettings", constant_element_notification_feed_settings)
