-- chunkname: @scripts/settings/player/player_package_aliases.lua

local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local player_package_aliases = {
	"sound_dependencies",
	"particle_dependencies",
	"decal_dependencies",
	"base_units",
}

for index, alias in ipairs(PlayerCharacterConstants.player_package_aliases) do
	player_package_aliases[#player_package_aliases + 1] = alias
end

local sorted_slot_names = table.keys(PlayerCharacterConstants.slot_configuration)

table.sort(sorted_slot_names)

for sorted_slot_name_key = 1, #sorted_slot_names do
	local slot_name = sorted_slot_names[sorted_slot_name_key]

	if not table.find(player_package_aliases, slot_name) then
		player_package_aliases[#player_package_aliases + 1] = slot_name
	end
end

table.clear(sorted_slot_names)

sorted_slot_names = table.keys(ItemSlotSettings)

table.sort(sorted_slot_names)

for sorted_slot_name_key = 1, #sorted_slot_names do
	local slot_name = sorted_slot_names[sorted_slot_name_key]

	if not table.find(player_package_aliases, slot_name) then
		player_package_aliases[#player_package_aliases + 1] = slot_name
	end
end

return settings("PlayerPackageAliases", player_package_aliases)
