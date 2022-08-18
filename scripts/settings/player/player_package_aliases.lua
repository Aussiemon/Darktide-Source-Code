local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local player_package_aliases = {
	"sound_dependencies",
	"particle_dependencies",
	"base_units"
}

for index, alias in ipairs(PlayerCharacterConstants.player_package_aliases) do
	fassert(table.find(player_package_aliases, alias), "[PlayerPackageAliases] - Trying to add package alias that has already been added: %s", alias)

	player_package_aliases[#player_package_aliases + 1] = alias
end

for slot_name, config in pairs(PlayerCharacterConstants.slot_configuration) do
	if not table.find(player_package_aliases, slot_name) then
		player_package_aliases[#player_package_aliases + 1] = slot_name
	end
end

for slot_name, config in pairs(ItemSlotSettings) do
	if not table.find(player_package_aliases, slot_name) then
		player_package_aliases[#player_package_aliases + 1] = slot_name
	end
end

return settings("PlayerPackageAliases", player_package_aliases)
