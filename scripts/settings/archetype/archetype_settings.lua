-- chunkname: @scripts/settings/archetype/archetype_settings.lua

local archetype_names = table.enum("adamant", "broker", "ogryn", "psyker", "veteran", "zealot")
local ui_selection_order = {
	archetype_names.veteran,
	archetype_names.zealot,
	archetype_names.psyker,
	archetype_names.ogryn,
	archetype_names.adamant,
	archetype_names.broker,
}
local ui_selection_order_lookup = {}

for ii = 1, #ui_selection_order do
	ui_selection_order_lookup[ui_selection_order[ii]] = ii
end

table.append(ui_selection_order_lookup, ui_selection_order)

local archetype_names_array = {}

for archetype_name, archetype_template in pairs(archetype_names) do
	archetype_names_array[#archetype_names_array + 1] = archetype_name
end

table.sort(archetype_names_array)

archetype_settings = {
	archetype_names = archetype_names,
	archetype_names_array = archetype_names_array,
	archetype_cosmetics_whitelist = {
		[archetype_names.ogryn] = true,
		[archetype_names.psyker] = true,
		[archetype_names.veteran] = true,
		[archetype_names.zealot] = true,
	},
	archetype_ui_selection_order = ui_selection_order_lookup,
}

return settings("ArchetypeSettings", archetype_settings)
