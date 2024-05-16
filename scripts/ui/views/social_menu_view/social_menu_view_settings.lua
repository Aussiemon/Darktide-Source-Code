-- chunkname: @scripts/ui/views/social_menu_view/social_menu_view_settings.lua

local social_menu_view_settings = {
	max_num_party_members = 4,
	max_num_portraits = 50,
	party_list_refresh_time = 2,
	popup_start_layer = 300,
	roster_list_refresh_time = 2,
	tab_switch_start_update_delay_time = 0.4,
	widget_fade_delay = 0.35,
	widget_fade_time = 0.3,
}

return settings("SocialMenuViewSettings", social_menu_view_settings)
