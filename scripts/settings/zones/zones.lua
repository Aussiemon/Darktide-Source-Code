-- chunkname: @scripts/settings/zones/zones.lua

local zones = {
	dust = {
		map_node = "dust_01",
		name = "loc_zone_dust",
		name_short = "loc_zone_name_dust_short",
		images = {
			default = "content/ui/materials/icons/missions/zone_dust_standard",
			mission_board_details = "content/ui/materials/icons/zones/dust",
			mission_vote = "content/ui/materials/icons/missions/zone_dust_standard",
		},
	},
	entertainment = {
		map_node = "entertainment_01",
		name = "loc_zone_entertainment",
		name_short = "loc_zone_name_entertainment_short",
		images = {
			default = "content/ui/materials/icons/missions/zone_entertainment_standard",
			mission_board_details = "content/ui/materials/icons/zones/entertainment",
			mission_vote = "content/ui/materials/icons/missions/zone_entertainment_standard",
		},
	},
	operations = {
		map_node = "operations_01",
		name = "loc_zone_operations",
		name_short = "loc_zone_name_operations_short",
		images = {
			default = "content/ui/materials/icons/missions/zone_operations_standard",
			mission_board_details = "content/ui/materials/icons/zones/operations",
			mission_vote = "content/ui/materials/icons/missions/zone_operations_standard",
		},
	},
	hub = {
		name = "loc_zone_hub",
		not_needed_for_penance = true,
	},
	placeholder = {
		name = "loc_zone_placeholder",
		not_needed_for_penance = true,
	},
	prologue = {
		name = "loc_zone_prologue",
		not_needed_for_penance = true,
	},
	tank_foundry = {
		map_node = "tank_foundry_01",
		name = "loc_zone_tank_foundry",
		name_short = "loc_zone_name_tank_foundry_short",
		images = {
			default = "content/ui/materials/icons/missions/zone_tank_foundry_standard",
			mission_board_details = "content/ui/materials/icons/zones/tank_foundry",
			mission_vote = "content/ui/materials/icons/missions/zone_tank_foundry_standard",
		},
	},
	training_grounds = {
		name = "loc_zone_training_grounds",
		not_needed_for_penance = true,
	},
	throneside = {
		map_node = "throneside_01",
		name = "loc_zone_throneside",
		name_short = "loc_zone_name_throneside_short",
		images = {
			default = "content/ui/materials/icons/missions/zone_throneside_standard",
			mission_board_details = "content/ui/materials/icons/zones/throneside",
			mission_vote = "content/ui/materials/icons/missions/zone_throneside_standard",
		},
	},
	transit = {
		map_node = "transit_01",
		name = "loc_zone_transit",
		name_short = "loc_zone_name_transit_short",
		images = {
			default = "content/ui/materials/icons/missions/zone_transit_standard",
			mission_board_details = "content/ui/materials/icons/zones/transit",
			mission_vote = "content/ui/materials/icons/missions/zone_transit_standard",
		},
	},
	void = {
		map_node = "void_01",
		name = "loc_zone_void",
		name_short = "loc_zone_name_void_short",
		images = {
			default = "content/ui/materials/icons/missions/zone_void_standard",
			mission_board_details = "content/ui/materials/icons/zones/void",
			mission_vote = "content/ui/materials/icons/missions/zone_void_standard",
		},
	},
	horde = {
		map_node = "horde_01",
		name = "loc_horde_mission_breifing_zone",
		name_short = "loc_horde_mission_breifing_zone",
		images = {
			default = "content/ui/materials/icons/missions/zone_horde_standard",
			mission_board_details = "content/ui/materials/icons/zones/horde",
			mission_vote = "content/ui/materials/icons/missions/zone_horde_standard",
		},
	},
	watertown = {
		map_node = "watertown_01",
		name = "loc_zone_watertown",
		name_short = "loc_zone_name_watertown_short",
		images = {
			default = "content/ui/materials/icons/missions/zone_watertown_standard",
			mission_board_details = "content/ui/materials/icons/zones/watertown",
			mission_vote = "content/ui/materials/icons/missions/zone_watertown_standard",
		},
	},
}

return zones
