local zones = {
	hub = {
		name = "loc_zone_hub"
	},
	placeholder = {
		name = "loc_zone_placeholder"
	},
	tank_foundry = {
		map_node = "tank_foundry_01",
		name = "loc_zone_tank_foundry",
		images = {
			mission_vote = "content/ui/materials/icons/missions/zone_tank_foundry_standard",
			default = "content/ui/materials/icons/missions/zone_tank_foundry_standard",
			mission_board_details = "content/ui/materials/mission_board/zones/tank_foundry"
		}
	},
	transit = {
		map_node = "transit_01",
		name = "loc_zone_transit",
		images = {
			mission_vote = "content/ui/materials/icons/missions/zone_transit_standard",
			default = "content/ui/materials/icons/missions/zone_transit_standard",
			mission_board_details = "content/ui/materials/mission_board/zones/transit"
		}
	}
}

return zones
