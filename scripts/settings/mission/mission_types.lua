-- chunkname: @scripts/settings/mission/mission_types.lua

local MissionTypes = {
	["01"] = {
		icon = "content/ui/materials/icons/mission_types/mission_type_01",
		id = 1,
		name = "loc_mission_type_01_name",
	},
	["02"] = {
		icon = "content/ui/materials/icons/mission_types/mission_type_02",
		id = 2,
		name = "loc_mission_type_02_name",
	},
	["03"] = {
		icon = "content/ui/materials/icons/mission_types/mission_type_03",
		id = 3,
		name = "loc_mission_type_03_name",
	},
	["04"] = {
		icon = "content/ui/materials/icons/mission_types/mission_type_04",
		id = 4,
		name = "loc_mission_type_04_name",
	},
	["05"] = {
		icon = "content/ui/materials/icons/mission_types/mission_type_05",
		id = 5,
		name = "loc_mission_type_05_name",
	},
	["06"] = {
		icon = "content/ui/materials/icons/mission_types/mission_type_06",
		id = 6,
		name = "loc_mission_type_06_name",
	},
	["07"] = {
		icon = "content/ui/materials/icons/mission_types/mission_type_07",
		id = 7,
		name = "loc_mission_type_07_name",
	},
}

return settings("MissionTypes", MissionTypes)
