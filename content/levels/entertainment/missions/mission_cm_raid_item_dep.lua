-- chunkname: @content/levels/entertainment/missions/mission_cm_raid_item_dep.lua

local item_dependencies = {
	minion_items = {},
	player_items = {
		["content/items/characters/player/human/gear_head/servitor_head_01"] = 5,
		["content/items/characters/player/human/gear_torso/servitor_torso_01"] = 5,
		["content/items/devices/auspex_scanner"] = 29,
		["content/items/devices/auspex_scanner_equiped"] = 2,
		["content/items/devices/breach_charge"] = 2,
		["content/items/devices/servo_skull"] = 1,
		["content/items/devices/skull_decoder"] = 2,
	},
	weapon_items = {},
}

return item_dependencies
