﻿-- chunkname: @scripts/ui/hud/elements/area_notification_popup/hud_element_area_notification_popup_settings.lua

local hud_element_area_notification_popup_settings = {
	events = {
		{
			"event_player_set_new_location",
			"event_player_set_new_location",
		},
	},
}

return settings("HudElementAreaNotificationPopupSettings", hud_element_area_notification_popup_settings)
