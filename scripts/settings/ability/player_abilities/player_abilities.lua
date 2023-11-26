-- chunkname: @scripts/settings/ability/player_abilities/player_abilities.lua

local player_abilities_name = "PlayerAbilities"
local player_abilities = {}

local function _include_ability_definition(file_name)
	local definition = require(file_name)

	for ability_name, entry_data in pairs(definition) do
		entry_data.name = ability_name

		local entry = entry_data

		player_abilities[ability_name] = entry
	end
end

_include_ability_definition("scripts/settings/ability/player_abilities/veteran_abilities_new")
_include_ability_definition("scripts/settings/ability/player_abilities/zealot_abilities_new")
_include_ability_definition("scripts/settings/ability/player_abilities/ogryn_abilities_new")
_include_ability_definition("scripts/settings/ability/player_abilities/psyker_abilities_new")

return settings(player_abilities_name, player_abilities)
