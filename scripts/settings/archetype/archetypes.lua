-- chunkname: @scripts/settings/archetype/archetypes.lua

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

_create_archetype_entry("ogryn")
_create_archetype_entry("psyker")
_create_archetype_entry("veteran")
_create_archetype_entry("zealot")

return settings("Archetypes", archetypes)
