-- chunkname: @scripts/settings/expeditions/expedition_collectibles.lua

local collect_modes = table.enum("individual", "team")
local consume_modes = table.enum("individual", "team", "never")
local expedition_collectible_settings = {}

return settings("ExpeditionCollectibles", expedition_collectible_settings)
