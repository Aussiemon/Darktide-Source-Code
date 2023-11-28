-- chunkname: @content/levels/throneside/missions/mission_hm_complex_item_dep.lua

local item_dependencies = {
	minion_items = {},
	player_items = {
		["content/items/characters/player/human/gear_head/servitor_head_01"] = 5,
		["content/items/characters/player/human/gear_torso/servitor_torso_01"] = 5,
		["content/items/devices/auspex_scanner"] = 7,
		["content/items/devices/skull_decoder"] = 7
	},
	weapon_items = {}
}

return item_dependencies
