-- chunkname: @scripts/settings/zones/zones.lua

local zones = {
	dust = {
		name_short = "loc_zone_name_dust_short",
		name = "loc_zone_dust",
		map_node = "dust_01",
		images = {
			mission_vote = "content/ui/materials/icons/missions/zone_dust_standard",
			default = "content/ui/materials/icons/missions/zone_dust_standard",
			mission_board_details = "content/ui/materials/icons/zones/dust"
		}
	},
	entertainment = {
		name_short = "loc_zone_name_entertainment_short",
		name = "loc_zone_entertainment",
		map_node = "entertainment_01",
		images = {
			mission_vote = "content/ui/materials/icons/missions/zone_entertainment_standard",
			default = "content/ui/materials/icons/missions/zone_entertainment_standard",
			mission_board_details = "content/ui/materials/icons/zones/entertainment"
		}
	},
	hub = {
		name = "loc_zone_hub"
	},
	placeholder = {
		name = "loc_zone_placeholder"
	},
	prologue = {
		name = "loc_zone_prologue"
	},
	tank_foundry = {
		name_short = "loc_zone_name_tank_foundry_short",
		name = "loc_zone_tank_foundry",
		map_node = "tank_foundry_01",
		images = {
			mission_vote = "content/ui/materials/icons/missions/zone_tank_foundry_standard",
			default = "content/ui/materials/icons/missions/zone_tank_foundry_standard",
			mission_board_details = "content/ui/materials/icons/zones/tank_foundry"
		}
	},
	throneside = {
		name_short = "loc_zone_name_throneside_short",
		name = "loc_zone_throneside",
		map_node = "throneside_01",
		images = {
			mission_vote = "content/ui/materials/icons/missions/zone_throneside_standard",
			default = "content/ui/materials/icons/missions/zone_throneside_standard",
			mission_board_details = "content/ui/materials/icons/zones/throneside"
		}
	},
	transit = {
		name_short = "loc_zone_name_transit_short",
		name = "loc_zone_transit",
		map_node = "transit_01",
		images = {
			mission_vote = "content/ui/materials/icons/missions/zone_transit_standard",
			default = "content/ui/materials/icons/missions/zone_transit_standard",
			mission_board_details = "content/ui/materials/icons/zones/transit"
		}
	},
	watertown = {
		name_short = "loc_zone_name_watertown_short",
		name = "loc_zone_watertown",
		map_node = "watertown_01",
		images = {
			mission_vote = "content/ui/materials/icons/missions/zone_watertown_standard",
			default = "content/ui/materials/icons/missions/zone_watertown_standard",
			mission_board_details = "content/ui/materials/icons/zones/watertown"
		}
	}
}

return zones
