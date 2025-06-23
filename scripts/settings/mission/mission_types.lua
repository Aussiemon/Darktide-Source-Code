-- chunkname: @scripts/settings/mission/mission_types.lua

local MissionTypes = {
	raid = {
		index = 1,
		name = "loc_mission_type_01_name",
		icon = "content/ui/materials/icons/mission_types/mission_type_01",
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_01"
	},
	assassination = {
		index = 2,
		name = "loc_mission_type_02_name",
		icon = "content/ui/materials/icons/mission_types/mission_type_02",
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_02"
	},
	investigation = {
		index = 3,
		name = "loc_mission_type_03_name",
		icon = "content/ui/materials/icons/mission_types/mission_type_03",
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_03"
	},
	disruption = {
		index = 4,
		name = "loc_mission_type_04_name",
		icon = "content/ui/materials/icons/mission_types/mission_type_04",
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_04"
	},
	strike = {
		index = 5,
		name = "loc_mission_type_05_name",
		icon = "content/ui/materials/icons/mission_types/mission_type_05",
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_05"
	},
	espionage = {
		index = 6,
		name = "loc_mission_type_06_name",
		icon = "content/ui/materials/icons/mission_types/mission_type_06",
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_06"
	},
	repair = {
		index = 7,
		name = "loc_mission_type_07_name",
		icon = "content/ui/materials/icons/mission_types/mission_type_07",
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_07"
	},
	operations = {
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_operations",
		name = "loc_mission_type_operations_name",
		icon = "content/ui/materials/icons/mission_types/mission_type_operations"
	},
	horde = {
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_horde",
		name = "loc_horde_mission_type",
		icon = "content/ui/materials/icons/mission_types/mission_type_horde"
	},
	undefined = {
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_undefined",
		name = "loc_mission_type_undefined_name",
		icon = "content/ui/materials/icons/mission_types/mission_type_undefined"
	},
	hub = {
		mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_undefined",
		name = "loc_mission_type_undefined_name",
		icon = "content/ui/materials/icons/mission_types/mission_type_undefined"
	}
}

return settings("MissionTypes", MissionTypes)
