-- chunkname: @scripts/settings/item/item_source_settings.lua

local item_source_settings = {
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
	{
		display_name = "loc_item_source_live_event",
		is_live_event = true,
	},
	{
		display_name = "loc_dlc_adamant_name",
		dlc_name = "adamant",
	},
	{
		display_name = "loc_dlc_adamant_name_deluxe",
		dlc_name = "adamant_deluxe",
	},
	{
		display_name = "loc_dlc_broker_name",
		dlc_name = "broker",
	},
	{
		display_name = "loc_dlc_broker_name_deluxe",
		dlc_name = "broker_deluxe",
	},
	{
		display_name = "loc_dlc_broker_name_cosmetic_upgrade",
		dlc_name = "broker_cosmetic",
	},
}

return settings("ItemSourceSettings", item_source_settings)
