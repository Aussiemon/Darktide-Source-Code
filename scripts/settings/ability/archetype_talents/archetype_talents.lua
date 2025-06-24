-- chunkname: @scripts/settings/ability/archetype_talents/archetype_talents.lua

local ArchetypeSettings = require("scripts/settings/archetype/archetype_settings")
local archetype_talents_name = "ArchetypeTalents"
local talents = {}

local function _include_talents_definition(file_name, base_talents)
	local definition = require(file_name)
	local player_archetype = definition.archetype

	if not talents[player_archetype] then
		talents[player_archetype] = {}
	end

	local archetype_talents = talents[player_archetype]

	if base_talents then
		for talent_name, talent in pairs(base_talents) do
			archetype_talents[talent_name] = talent
		end
	end

	for talent_name, entry_data in pairs(definition.talents) do
		local entry = entry_data

		archetype_talents[talent_name] = entry
	end

	return archetype_talents
end

local base_talents = _include_talents_definition("scripts/settings/ability/archetype_talents/talents/base_talents")

for archetype_name, _ in pairs(ArchetypeSettings.archetype_names) do
	local path = string.format("scripts/settings/ability/archetype_talents/talents/%s_talents", archetype_name)
	local exists = Application.can_get_resource("lua", path)

	_include_talents_definition(path, base_talents)
end

return settings(archetype_talents_name, talents)
