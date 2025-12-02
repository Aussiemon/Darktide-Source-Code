-- chunkname: @scripts/settings/mission/mission_types.lua

local mission_types = {
	raid = {
		icon = "content/ui/materials/icons/mission_types/mission_type_01",
		index = 1,
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_01",
		name = "loc_mission_type_01_name",
	},
	assassination = {
		icon = "content/ui/materials/icons/mission_types/mission_type_02",
		index = 2,
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_02",
		name = "loc_mission_type_02_name",
	},
	investigation = {
		icon = "content/ui/materials/icons/mission_types/mission_type_03",
		index = 3,
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_03",
		name = "loc_mission_type_03_name",
	},
	disruption = {
		icon = "content/ui/materials/icons/mission_types/mission_type_04",
		index = 4,
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_04",
		name = "loc_mission_type_04_name",
	},
	strike = {
		icon = "content/ui/materials/icons/mission_types/mission_type_05",
		index = 5,
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_05",
		name = "loc_mission_type_05_name",
	},
	espionage = {
		icon = "content/ui/materials/icons/mission_types/mission_type_06",
		index = 6,
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_06",
		name = "loc_mission_type_06_name",
	},
	repair = {
		icon = "content/ui/materials/icons/mission_types/mission_type_07",
		index = 7,
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_07",
		name = "loc_mission_type_07_name",
	},
	operations = {
		icon = "content/ui/materials/icons/mission_types/mission_type_operations",
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_operations",
		name = "loc_mission_type_operations_name",
	},
	horde = {
		icon = "content/ui/materials/icons/mission_types/mission_type_horde",
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_horde",
		name = "loc_horde_mission_type",
	},
	undefined = {
		icon = "content/ui/materials/icons/mission_types/mission_type_undefined",
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_undefined",
		name = "loc_mission_type_undefined_name",
	},
	hub = {
		icon = "content/ui/materials/icons/mission_types/mission_type_undefined",
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_undefined",
		name = "loc_mission_type_undefined_name",
	},
}

return settings("MissionTypes", mission_types)
