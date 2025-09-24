-- chunkname: @scripts/ui/view_elements/view_element_campaign_mission_list/view_element_campaign_mission_list_settings.lua

local Settings = {}

Settings.mission_tile_settings = {
	mission_tile = {
		blueprint_name = "replay_mission_tile_pass_templates",
		scenegraph_id = "list_anchor",
		size = {
			96,
			108.80000000000001,
		},
	},
}
Settings.debrief_settings = {
	size = {
		60,
		60,
	},
	icon_size = {
		60,
		60,
	},
}
Settings.debrief_videos = {
	player_journey_01 = "debriefing_01",
	player_journey_010 = "debriefing_12",
	player_journey_011_A = "debriefing_13",
	player_journey_011_B = "debriefing_16",
	player_journey_012_A = "debriefing_14",
	player_journey_013_A = "debriefing_15",
	player_journey_014 = "debriefing_17",
	player_journey_02 = "debriefing_02",
	player_journey_03 = "debriefing_03",
	player_journey_04 = "debriefing_04",
	player_journey_05 = "debriefing_05",
	player_journey_06_A = "debriefing_06",
	player_journey_06_B = "debriefing_08",
	player_journey_07_A = "debriefing_07",
	player_journey_07_B = "debriefing_09",
	player_journey_08 = "debriefing_10",
	player_journey_09 = "debriefing_11",
}

return settings("ViewElementCampaignMissionListSettings", Settings)
