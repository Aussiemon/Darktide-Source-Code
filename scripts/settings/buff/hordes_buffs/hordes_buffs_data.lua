-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_buffs_data.lua

local hordes_buffs_data = {}

local function _create_entry(path, is_family_buff)
	local entry_templates = require(path)

	for name, template in upairs(entry_templates) do
		hordes_buffs_data[name] = template
		template.name = name
		template.title = "loc_" .. name .. "_title"
		template.description = "loc_" .. name .. "_description"
		template.is_family_buff = is_family_buff
	end
end

hordes_buffs_data.hordes_buff_damage_immunity_after_game_end = {
	description = "",
	icon = "",
	is_family_buff = false,
	title = "",
}
hordes_buffs_data.hordes_buff_ogryn_basic_box_spawns_cluster = {
	description = "",
	icon = "",
	is_family_buff = false,
	title = "",
}

_create_entry("scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_family_buffs_data", true)
_create_entry("scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_buffs_data", false)
_create_entry("scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_adamant_buffs_data", false)
_create_entry("scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_ogryn_buffs_data", false)
_create_entry("scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_psyker_buffs_data", false)
_create_entry("scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_veteran_buffs_data", false)
_create_entry("scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_zealot_buffs_data", false)
_create_entry("scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_broker_buffs_data", false)

return settings("HordesBuffsData", hordes_buffs_data)
