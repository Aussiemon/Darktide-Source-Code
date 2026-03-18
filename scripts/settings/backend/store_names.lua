-- chunkname: @scripts/settings/backend/store_names.lua

local ArchetypeSettings = require("scripts/settings/archetype/archetype_settings")
local archetype_names_array = ArchetypeSettings.archetype_names_array
local STORES_FORMAT_STRINGS = {
	credit = "get_%s_credits_store",
	credit_cosmetics = "get_%s_credits_cosmetics_store",
	credit_goods = "get_%s_credits_goods_store",
	credit_weapon_cosmetics = "get_%s_credits_weapon_cosmetics_store",
	mark = "get_%s_marks_store",
	premium = "premium_store_skins_%s",
}
local store_names = {
	by_archetype = {},
}

for store_name, format_string in pairs(STORES_FORMAT_STRINGS) do
	local store = {}

	for ii = 1, #archetype_names_array do
		local archetype_name = archetype_names_array[ii]

		store[archetype_name] = string.format(format_string, archetype_name)
	end

	store_names.by_archetype[store_name] = store
end

return settings("StoreNames", store_names)
