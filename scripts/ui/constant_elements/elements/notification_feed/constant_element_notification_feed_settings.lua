-- chunkname: @scripts/ui/constant_elements/elements/notification_feed/constant_element_notification_feed_settings.lua

local UiSoundEvents = require("scripts/settings/ui/ui_sound_events")
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
		{
			"event_update_notification_progress",
			"event_update_notification_progress",
		},
	},
	trait_sound_events_by_rarity = {
		UiSoundEvents.notification_trait_received_rarity_1,
		UiSoundEvents.notification_trait_received_rarity_2,
		UiSoundEvents.notification_trait_received_rarity_3,
		UiSoundEvents.notification_trait_received_rarity_4,
	},
	sound_event_by_item_type = {
		WEAPON_SKIN = UiSoundEvents.notification_weapon_skin_received,
		WEAPON_TRINKET = UiSoundEvents.notification_weapon_skin_received,
		GEAR_EXTRA_COSMETIC = UiSoundEvents.notification_cosmetic_received,
		GEAR_HEAD = UiSoundEvents.notification_cosmetic_received,
		GEAR_UPPERBODY = UiSoundEvents.notification_cosmetic_received,
		GEAR_LOWERBODY = UiSoundEvents.notification_cosmetic_received,
		COMPANION_GEAR_FULL = UiSoundEvents.notification_cosmetic_received,
		FACE = UiSoundEvents.notification_cosmetic_received,
		FACE_TATTOO = UiSoundEvents.notification_cosmetic_received,
		FACE_SCAR = UiSoundEvents.notification_cosmetic_received,
		FACE_MAKEUP = UiSoundEvents.notification_cosmetic_received,
		HAIR = UiSoundEvents.notification_cosmetic_received,
		BODY_TATTOO = UiSoundEvents.notification_cosmetic_received,
		BODY = UiSoundEvents.notification_cosmetic_received,
		ARMS = UiSoundEvents.notification_cosmetic_received,
		LEGS = UiSoundEvents.notification_cosmetic_received,
		CRYPTIC_ARMS = UiSoundEvents.notification_cosmetic_received,
		CRYPTIC_LEGS = UiSoundEvents.notification_cosmetic_received,
		SKIN_COLOR = UiSoundEvents.notification_cosmetic_received,
		HAIR_COLOR = UiSoundEvents.notification_cosmetic_received,
		EYE_COLOR = UiSoundEvents.notification_cosmetic_received,
		LENS_COLOR = UiSoundEvents.notification_cosmetic_received,
		METAL_COLOR = UiSoundEvents.notification_cosmetic_received,
	},
}

return settings("ConstantElementNotificationFeedSettings", constant_element_notification_feed_settings)
