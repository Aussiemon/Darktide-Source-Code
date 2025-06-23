-- chunkname: @scripts/ui/hud/elements/combat_feed/hud_element_combat_feed_settings.lua

local hud_element_combat_feed_settings = {
	max_messages = 8,
	message_duration = 5,
	entry_spacing = 10,
	text_height_spacing = 15,
	header_size = {
		470,
		44
	},
	events = {
		{
			"event_add_combat_feed_message",
			"event_add_combat_feed_message"
		},
		{
			"event_combat_feed_kill",
			"event_combat_feed_kill"
		},
		{
			"event_add_notification_message",
			"event_add_notification_message"
		},
		{
			"event_update_combat_feed_enabled",
			"event_update_combat_feed_enabled"
		},
		{
			"event_update_combat_feed_max_messages",
			"event_update_combat_feed_max_messages"
		},
		{
			"event_update_combat_feed_message_duration",
			"event_update_combat_feed_message_duration"
		},
		{
			"event_update_combat_feed_enabled",
			"event_update_combat_feed_enabled"
		},
		{
			"event_update_assist_notification_type",
			"event_update_assist_notification_type"
		},
		{
			"event_update_crafting_pickup_notification_type",
			"event_update_crafting_pickup_notification_type"
		}
	},
	colors_by_enemy_type = {
		witch = {
			255,
			238,
			221,
			136
		},
		lord = {
			255,
			238,
			221,
			136
		},
		nemesis = {
			255,
			238,
			221,
			136
		},
		elite = {
			255,
			238,
			221,
			136
		},
		special = {
			255,
			238,
			221,
			136
		},
		monster = {
			255,
			213,
			94,
			0
		}
	}
}

return settings("HudElementCombatFeedSettings", hud_element_combat_feed_settings)
