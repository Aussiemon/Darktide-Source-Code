-- chunkname: @scripts/settings/archetype/archetype_settings.lua

local archetype_names = table.enum("adamant", "ogryn", "psyker", "veteran", "zealot")
local archetype_names_array = {}

for archetype_name, archetype_template in pairs(archetype_names) do
	archetype_names_array[#archetype_names_array + 1] = archetype_name
end

table.sort(archetype_names_array)

archetype_settings = {
	archetype_names = archetype_names,
	archetype_names_array = archetype_names_array,
	archetype_cosmetics_whitelist = {
		"ogryn",
		"psyker",
		"veteran",
		"zealot",
	},
}

return settings("ArchetypeSettings", archetype_settings)
