-- chunkname: @scripts/settings/cinematic_video/hub_location_introduction_settings.lua

local hub_location_introduction_settings = {
	mission_board_view = {
		narrative_event_name = "hli_mission_board_viewed",
		video_template = "hli_mission_board",
		video_template_by_archetype = {
			adamant = "hli_mission_board_adamant",
		},
	},
	barber_vendor_background_view = {
		narrative_event_name = "hli_barbershop_viewed",
		video_template = "hli_barbershop",
	},
	contracts_background_view = {
		narrative_event_name = "hli_contracts_viewed",
		video_template = "hli_contracts",
	},
	crafting_view = {
		narrative_event_name = "hli_crafting_station_underground_viewed",
		video_template = "hli_crafting_station_underground",
	},
	credits_vendor_background_view = {
		narrative_event_name = "hli_gun_shop_viewed",
		video_template = "hli_gun_shop",
	},
	penance_overview_view = {
		narrative_event_name = "hli_penances_viewed",
		video_template = "hli_penances",
	},
}

return settings("HubLocationIntroductionSettings", hub_location_introduction_settings)
