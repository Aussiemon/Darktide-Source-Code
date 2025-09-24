-- chunkname: @scripts/settings/decal/player_character_decal_names.lua

local player_character_decal_names_lookup = {}
local PlayerCharacterDecals = require("scripts/settings/decal/player_character_decals")

for decal_name, _ in pairs(PlayerCharacterDecals.decal_names) do
	player_character_decal_names_lookup[decal_name] = true
end

local player_character_decal_names = {}

for decal_name, _ in pairs(player_character_decal_names_lookup) do
	player_character_decal_names[#player_character_decal_names + 1] = decal_name
end

return player_character_decal_names
