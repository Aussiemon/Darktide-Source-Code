-- chunkname: @scripts/settings/campaign/campaign_settings.lua

local campaign_settings = {}

campaign_settings["player-journey"] = {
	display_name = "loc_player_journey_battle"
}
campaign_settings["no-mans-land"] = {
	display_name = "loc_nomansland_display_name"
}
campaign_settings.spillway = {
	display_name = "loc_spillway_campaign_display_name"
}
campaign_settings.parallel_requirements = {}
campaign_settings.parallel_requirements["player-journey"] = {
	[9] = true,
	[16] = true
}

return settings("CampaignSettings", campaign_settings)
