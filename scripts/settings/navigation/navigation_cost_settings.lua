local IGNORE_NAV_COST_MAP_LAYER = "ignore"
local default_nav_cost_maps_minions = {
	daemonhost = 1,
	fire = 1
}
local default_nav_cost_maps_bots = {
	daemonhost = 1,
	fire = 1
}
local default_nav_tag_layers_minions = {
	jumps = 10,
	cover_vaults = 0,
	bot_damage_drops = 0,
	monster_walls = 0,
	bot_ladders = 0,
	bot_jumps = 0,
	bot_leap_of_faith = 0,
	ledges_with_fence = 10,
	doors = 1.5,
	teleporters = 5,
	ledges = 10,
	cover_ledges = 10,
	bot_drops = 0
}
local default_nav_tag_layers_bots = {
	jumps = 0,
	cover_vaults = 0,
	bot_damage_drops = 10,
	monster_walls = 0,
	bot_ladders = 5,
	bot_jumps = 1,
	bot_leap_of_faith = 3,
	ledges_with_fence = 0,
	doors = 1.5,
	teleporters = 0,
	ledges = 0,
	cover_ledges = 0,
	bot_drops = 1
}

return settings("NavigationCostSettings", {
	IGNORE_NAV_COST_MAP_LAYER = IGNORE_NAV_COST_MAP_LAYER,
	default_nav_cost_maps_minions = default_nav_cost_maps_minions,
	default_nav_cost_maps_bots = default_nav_cost_maps_bots,
	default_nav_tag_layers_minions = default_nav_tag_layers_minions,
	default_nav_tag_layers_bots = default_nav_tag_layers_bots
})
