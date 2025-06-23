-- chunkname: @scripts/settings/circumstance/templates/assault_circumstance_template.lua

local MissionOverrides = require("scripts/settings/circumstance/mission_overrides")
local circumstance_templates = {
	assault_01 = {
		wwise_state = "assault_01",
		theme_tag = "default",
		mission_overrides = MissionOverrides.merge("no_empty_hazards", "no_health_station_charges", "more_grenade_pickups", "extra_ammo_pickups", "less_healing_pocketables"),
		mutators = {
			"mutator_more_hordes",
			"mutator_more_specials"
		},
		ui = {
			description = "loc_circumstance_assault_description",
			happening_display_name = "loc_happening_assault",
			display_name = "loc_circumstance_assault_title",
			favourable_to_players = true,
			mission_board_icon = "content/ui/materials/mission_board/circumstances/assault_01",
			icon = "content/ui/materials/icons/circumstances/assault_01"
		}
	}
}

return circumstance_templates
