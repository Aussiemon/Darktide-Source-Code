-- chunkname: @scripts/settings/player_character/player_character_creator_presets.lua

local player_character_creator_presets = {
	adamant = require("scripts/settings/player_character/character_creator_presets/character_creator_presets_human"),
	broker = require("scripts/settings/player_character/character_creator_presets/character_creator_presets_broker"),
	cryptic = require("scripts/settings/player_character/character_creator_presets/character_creator_presets_cryptic"),
	ogryn = require("scripts/settings/player_character/character_creator_presets/character_creator_presets_ogryn"),
	psyker = require("scripts/settings/player_character/character_creator_presets/character_creator_presets_human"),
	veteran = require("scripts/settings/player_character/character_creator_presets/character_creator_presets_human"),
	zealot = require("scripts/settings/player_character/character_creator_presets/character_creator_presets_human"),
}

return settings("PlayerCharacterCreatorPresets", player_character_creator_presets)
