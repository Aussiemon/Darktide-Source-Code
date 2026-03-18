-- chunkname: @scripts/settings/campaign/campaign_settings.lua

local campaign_settings = {}

campaign_settings["player-journey"] = {
	display_name = "loc_player_journey_battle",
}
campaign_settings["no-mans-land"] = {
	display_name = "loc_nomansland_display_name",
}

return settings("CampaignSettings", campaign_settings)
