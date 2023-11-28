-- chunkname: @content/levels/tank_foundry/missions/mission_lm_cooling_item_dep.lua

local item_dependencies = {
	minion_items = {},
	player_items = {
		["content/items/characters/player/human/gear_head/servitor_head_01"] = 4,
		["content/items/characters/player/human/gear_torso/servitor_torso_01"] = 4,
		["content/items/devices/auspex_scanner"] = 6,
		["content/items/devices/skull_decoder"] = 6
	},
	weapon_items = {}
}

return item_dependencies
