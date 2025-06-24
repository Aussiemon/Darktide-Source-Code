-- chunkname: @scripts/settings/archetype/archetypes.lua

local ArchetypeSettings = require("scripts/settings/archetype/archetype_settings")
local archetypes = {}

local function _create_archetype_entry(archetype_name)
	local path = string.format("scripts/settings/archetype/archetypes/%s_archetype", archetype_name)
	local exists = Application.can_get_resource("lua", path)
	local archetype = require(path)

	archetype.name = archetype_name
	archetype.base_talents = archetype.base_talents or {}

	local entry = archetype

	archetypes[archetype_name] = entry
end

for archetype_name, _ in pairs(ArchetypeSettings.archetype_names) do
	_create_archetype_entry(archetype_name)
end

return settings("Archetypes", archetypes)
