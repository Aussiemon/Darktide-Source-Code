-- chunkname: @content/levels/transit/missions/mission_dm_rise_item_dep.lua

local item_dependencies = {
	minion_items = {},
	player_items = {
		["content/items/characters/player/human/gear_head/servitor_head_01"] = 4,
		["content/items/characters/player/human/gear_torso/servitor_torso_01"] = 4,
		["content/items/devices/auspex_scanner"] = 2,
		["content/items/devices/skull_decoder"] = 2,
	},
	weapon_items = {},
}

return item_dependencies
