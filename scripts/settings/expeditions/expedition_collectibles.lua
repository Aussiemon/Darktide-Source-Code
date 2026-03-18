-- chunkname: @scripts/settings/expeditions/expedition_collectibles.lua

local collect_modes = table.enum("individual", "team")
local consume_modes = table.enum("individual", "team", "never")
local expedition_collectible_settings = {
	common_key = {
		display_name = "loc_expedition_collectible_common_key",
		collect_mode = collect_modes.individual,
		consume_mode = consume_modes.individual,
	},
	deadsider_key = {
		display_name = "loc_expedition_collectible_deadsider_key",
		collect_mode = collect_modes.individual,
		consume_mode = consume_modes.individual,
	},
	dataslate_key = {
		display_name = "loc_expedition_collectible_dataslate_key",
		collect_mode = collect_modes.individual,
		consume_mode = consume_modes.individual,
	},
}

return settings("ExpeditionCollectibles", expedition_collectible_settings)
