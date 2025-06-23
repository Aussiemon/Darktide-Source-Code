-- chunkname: @scripts/settings/item/item_source_settings.lua

local ItemSourceSettings = {
	{
		display_name = "loc_item_source_achievement",
		is_achievement = true
	},
	{
		display_name = "loc_item_source_credits_cosmetics"
	},
	{
		display_name = "loc_item_source_premium_store"
	},
	{
		display_name = "loc_item_source_penance_track"
	},
	{
		display_name = "loc_item_source_live_event",
		is_live_event = true
	},
	{
		display_name = "loc_dlc_adamant_name",
		is_dlc = true
	},
	{
		display_name = "loc_dlc_adamant_name_deluxe",
		is_dlc = true
	}
}

return settings("ItemSourceSettings", ItemSourceSettings)
