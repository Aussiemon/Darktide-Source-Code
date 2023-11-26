-- chunkname: @scripts/ui/views/social_menu_view/social_menu_view_settings.lua

local social_menu_view_settings = {
	widget_fade_delay = 0.35,
	max_num_portraits = 50,
	popup_start_layer = 300,
	max_num_party_members = 4,
	widget_fade_time = 0.3,
	party_list_refresh_time = 2,
	roster_list_refresh_time = 1
}

return settings("SocialMenuViewSettings", social_menu_view_settings)
