-- chunkname: @scripts/settings/item/item_source_settings.lua

local ItemSourceSettings = {
	{
		display_name = "loc_item_source_achievement",
		is_achievement = true,
	},
	{
		display_name = "loc_item_source_credits_cosmetics",
	},
	{
		display_name = "loc_item_source_premium_store",
	},
	{
		display_name = "loc_item_source_penance_track",
	},
}

return settings("ItemSourceSettings", ItemSourceSettings)
