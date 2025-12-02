-- chunkname: @scripts/settings/campaign/campaign_settings.lua

local CampaignSettings = {}

CampaignSettings["player-journey"] = {
	display_name = "loc_player_journey_battle",
}
CampaignSettings["no-mans-land"] = {
	display_name = "loc_nomansland_display_name",
}

return settings("CampaignSettings", CampaignSettings)
