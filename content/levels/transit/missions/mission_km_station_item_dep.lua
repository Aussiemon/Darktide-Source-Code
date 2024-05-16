-- chunkname: @content/levels/transit/missions/mission_km_station_item_dep.lua

local item_dependencies = {
	minion_items = {},
	player_items = {
		["content/items/characters/player/human/gear_head/servitor_head_01"] = 5,
		["content/items/characters/player/human/gear_torso/servitor_torso_01"] = 5,
		["content/items/devices/auspex_scanner"] = 1,
		["content/items/devices/skull_decoder"] = 1,
	},
	weapon_items = {},
}

return item_dependencies
