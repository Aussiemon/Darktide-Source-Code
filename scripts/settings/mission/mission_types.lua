-- chunkname: @scripts/settings/mission/mission_types.lua

local MissionTypes = {
	raid = {
		icon = "content/ui/materials/icons/mission_types/mission_type_01",
		index = 1,
		name = "loc_mission_type_01_name",
	},
	assassination = {
		icon = "content/ui/materials/icons/mission_types/mission_type_02",
		index = 2,
		name = "loc_mission_type_02_name",
	},
	investigation = {
		icon = "content/ui/materials/icons/mission_types/mission_type_03",
		index = 3,
		name = "loc_mission_type_03_name",
	},
	disruption = {
		icon = "content/ui/materials/icons/mission_types/mission_type_04",
		index = 4,
		name = "loc_mission_type_04_name",
	},
	strike = {
		icon = "content/ui/materials/icons/mission_types/mission_type_05",
		index = 5,
		name = "loc_mission_type_05_name",
	},
	espionage = {
		icon = "content/ui/materials/icons/mission_types/mission_type_06",
		index = 6,
		name = "loc_mission_type_06_name",
	},
	repair = {
		icon = "content/ui/materials/icons/mission_types/mission_type_07",
		index = 7,
		name = "loc_mission_type_07_name",
	},
	operations = {
		icon = "content/ui/materials/icons/mission_types/mission_type_operations",
		name = "loc_mission_type_operations_name",
	},
	undefined = {
		icon = "content/ui/materials/icons/mission_types/mission_type_operations",
		name = "loc_mission_type_undefined_name",
	},
	hub = {
		icon = "content/ui/materials/icons/mission_types/mission_type_operations",
		name = "loc_mission_type_undefined_name",
	},
}

return settings("MissionTypes", MissionTypes)
