local player_abilities_name = "PlayerAbilities"
local player_abilities = {}

local function _include_ability_definition(file_name)
	local definition = require(file_name)

	for ability_name, entry_data in pairs(definition) do
		fassert(not player_abilities[ability_name], "%s failed adding ability %q from file %q. Key already exists.", player_abilities_name, ability_name, file_name)

		entry_data.name = ability_name

		fassert(entry_data.max_charges, "PlayerAbility %q does not have max_charges defined.", ability_name)

		local entry = entry_data
		player_abilities[ability_name] = entry
	end
end

_include_ability_definition("scripts/settings/ability/player_abilities/shared_abilities")
_include_ability_definition("scripts/settings/ability/player_abilities/veteran_abilities")
_include_ability_definition("scripts/settings/ability/player_abilities/zealot_abilities")
_include_ability_definition("scripts/settings/ability/player_abilities/ogryn_abilities")
_include_ability_definition("scripts/settings/ability/player_abilities/psyker_abilities")

return settings(player_abilities_name, player_abilities)
