-- chunkname: @scripts/settings/ability/player_abilities/player_abilities.lua

local ArchetypeSettings = require("scripts/settings/archetype/archetype_settings")
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

for archetype_name, _ in pairs(ArchetypeSettings.archetype_names) do
	local path = string.format("scripts/settings/ability/player_abilities/abilities/%s_abilities", archetype_name)
	local exists = Application.can_get_resource("lua", path)

	_include_ability_definition(path)
end

return settings(player_abilities_name, player_abilities)
