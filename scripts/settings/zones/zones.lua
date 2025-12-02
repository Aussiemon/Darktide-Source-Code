-- chunkname: @scripts/settings/zones/zones.lua

local zones = {
	dust = {
		name = "loc_zone_dust",
		name_short = "loc_zone_name_dust_short",
		images = {
			default = "content/ui/textures/icons/zones/zone_dust",
			mission_vote = "content/ui/textures/icons/zones/zone_dust",
		},
	},
	entertainment = {
		name = "loc_zone_entertainment",
		name_short = "loc_zone_name_entertainment_short",
		images = {
			default = "content/ui/textures/icons/zones/zone_entertainment",
			mission_vote = "content/ui/textures/icons/zones/zone_entertainment",
		},
	},
	operations = {
		name = "loc_zone_operations",
		name_short = "loc_zone_name_operations_short",
		images = {
			default = "content/ui/textures/icons/zones/zone_operations",
			mission_vote = "content/ui/textures/icons/zones/zone_operations",
		},
	},
	hub = {
		name = "loc_zone_hub",
		not_available_on_mission_board = true,
		not_needed_for_penance = true,
	},
	placeholder = {
		name = "loc_zone_placeholder",
		not_available_on_mission_board = true,
		not_needed_for_penance = true,
	},
	prologue = {
		name = "loc_zone_prologue",
		not_available_on_mission_board = true,
		not_needed_for_penance = true,
	},
	tank_foundry = {
		name = "loc_zone_tank_foundry",
		name_short = "loc_zone_name_tank_foundry_short",
		images = {
			default = "content/ui/textures/icons/zones/zone_tank_foundry",
			mission_vote = "content/ui/textures/icons/zones/zone_tank_foundry",
		},
	},
	training_grounds = {
		name = "loc_zone_training_grounds",
		not_available_on_mission_board = true,
		not_needed_for_penance = true,
	},
	throneside = {
		name = "loc_zone_throneside",
		name_short = "loc_zone_name_throneside_short",
		images = {
			default = "content/ui/textures/icons/zones/zone_throneside",
			mission_vote = "content/ui/textures/icons/zones/zone_throneside",
		},
	},
	transit = {
		name = "loc_zone_transit",
		name_short = "loc_zone_name_transit_short",
		images = {
			default = "content/ui/textures/icons/zones/zone_transit",
			mission_vote = "content/ui/textures/icons/zones/zone_transit",
		},
	},
	void = {
		name = "loc_zone_void",
		name_short = "loc_zone_name_void_short",
		images = {
			default = "content/ui/textures/icons/zones/zone_void",
			mission_vote = "content/ui/textures/icons/zones/zone_void",
		},
	},
	horde = {
		name = "loc_horde_mission_breifing_zone",
		name_short = "loc_horde_mission_breifing_zone",
		images = {
			default = "content/ui/textures/icons/zones/zone_horde",
			mission_vote = "content/ui/textures/icons/zones/zone_horde",
		},
	},
	watertown = {
		name = "loc_zone_watertown",
		name_short = "loc_zone_name_watertown_short",
		images = {
			default = "content/ui/textures/icons/zones/zone_watertown",
			mission_vote = "content/ui/textures/icons/zones/zone_watertown",
		},
	},
}

return settings("Zones", zones)
