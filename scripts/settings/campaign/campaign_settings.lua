-- chunkname: @scripts/settings/campaign/campaign_settings.lua

local CampaignSettings = {}

CampaignSettings["player-journey"] = {
	display_name = "loc_player_journey_battle",
}

return settings("CampaignSettings", CampaignSettings)
