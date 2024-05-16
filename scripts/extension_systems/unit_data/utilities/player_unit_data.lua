-- chunkname: @scripts/extension_systems/unit_data/utilities/player_unit_data.lua

local PlayerCharacterLoopingSoundAliases = require("scripts/settings/sound/player_character_looping_sound_aliases")
local PlayerUnitData = {}

PlayerUnitData.looping_sound_component_name = function (looping_sound_alias)
	return string.format("looping_sound_%s", looping_sound_alias)
end

return PlayerUnitData
