-- chunkname: @scripts/settings/navigation/navigation_cost_settings.lua

local IGNORE_NAV_COST_MAP_LAYER = "ignore"
local default_nav_cost_maps_minions = {
	daemonhost = 1,
	fire = 1,
}
local default_nav_cost_maps_bots = {
	daemonhost = 1,
	fire = 1,
}
local default_nav_tag_layers_minions = {
	bot_damage_drops = 0,
	bot_drops = 0,
	bot_jumps = 0,
	bot_ladders = 0,
	bot_leap_of_faith = 0,
	cover_ledges = 10,
	cover_vaults = 0,
	doors = 1.5,
	jumps = 10,
	ledges = 10,
	ledges_with_fence = 10,
	monster_walls = 0,
	teleporters = 5,
}
local default_nav_tag_layers_bots = {
	bot_damage_drops = 10,
	bot_drops = 1,
	bot_jumps = 1,
	bot_ladders = 5,
	bot_leap_of_faith = 3,
	cover_ledges = 0,
	cover_vaults = 0,
	doors = 1.5,
	jumps = 0,
	ledges = 0,
	ledges_with_fence = 0,
	monster_walls = 0,
	teleporters = 0,
}

return settings("NavigationCostSettings", {
	IGNORE_NAV_COST_MAP_LAYER = IGNORE_NAV_COST_MAP_LAYER,
	default_nav_cost_maps_minions = default_nav_cost_maps_minions,
	default_nav_cost_maps_bots = default_nav_cost_maps_bots,
	default_nav_tag_layers_minions = default_nav_tag_layers_minions,
	default_nav_tag_layers_bots = default_nav_tag_layers_bots,
})
