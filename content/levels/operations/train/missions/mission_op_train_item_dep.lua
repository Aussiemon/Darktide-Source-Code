-- chunkname: @content/levels/operations/train/missions/mission_op_train_item_dep.lua

local item_dependencies = {
	minion_items = {},
	player_items = {
		["content/items/characters/player/human/gear_head/servitor_head_01"] = 1,
		["content/items/characters/player/human/gear_torso/servitor_torso_01"] = 1,
		["content/items/devices/auspex_scanner"] = 5,
		["content/items/devices/skull_decoder"] = 5,
	},
	weapon_items = {},
}

return item_dependencies
