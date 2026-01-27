-- chunkname: @scripts/settings/equipment/item_material_overrides/player_material_overrides_gear_decals.lua

local decal_table = {
	decal_atlas_adamant_01 = "content/textures/gear_decals/decal_atlas_adamant_01",
	decal_atlas_adamant_02 = "content/textures/gear_decals/decal_atlas_adamant_02",
	decal_atlas_adamant_precincts_01 = "content/textures/gear_decals/decal_atlas_adamant_precincts_01",
	decal_atlas_atoma_01 = "content/textures/gear_decals/decal_atlas_atoma_01",
	decal_atlas_broker_01 = "content/textures/gear_decals/decal_atlas_broker_01",
	decal_atlas_broker_02 = "content/textures/gear_decals/decal_atlas_broker_02",
	decal_atlas_broker_03 = "content/textures/gear_decals/decal_atlas_broker_03",
	decal_atlas_broker_04 = "content/textures/gear_decals/decal_atlas_broker_04",
	decal_atlas_broker_gang_01 = "content/textures/gear_decals/decal_atlas_broker_gang_01",
	decal_atlas_broker_gang_02 = "content/textures/gear_decals/decal_atlas_broker_gang_02",
	decal_atlas_broker_gang_03 = "content/textures/gear_decals/decal_atlas_broker_gang_03",
	decal_atlas_broker_gang_04 = "content/textures/gear_decals/decal_atlas_broker_gang_04",
	decal_atlas_cadia_01 = "content/textures/gear_decals/decal_atlas_cadia_01",
	decal_atlas_cadia_02 = "content/textures/gear_decals/decal_atlas_cadia_02",
	decal_atlas_christmas_01 = "content/textures/gear_decals/decal_atlas_christmas_01",
	decal_atlas_common_01 = "content/textures/gear_decals/decal_atlas_common_01",
	decal_atlas_d7 = "content/textures/gear_decals/decal_atlas_d7",
	decal_atlas_death_korps_of_krieg_01 = "content/textures/gear_decals/decal_atlas_death_korps_of_krieg_01",
	decal_atlas_death_korps_of_krieg_02 = "content/textures/gear_decals/decal_atlas_death_korps_of_krieg_02",
	decal_atlas_death_korps_of_krieg_03 = "content/textures/gear_decals/decal_atlas_death_korps_of_krieg_03",
	decal_atlas_enforcer_01 = "content/textures/gear_decals/decal_atlas_enforcer_01",
	decal_atlas_hive_scum_01 = "content/textures/gear_decals/decal_atlas_hive_scum_01",
	decal_atlas_holidays_01 = "content/textures/gear_decals/decal_atlas_holidays_01",
	decal_atlas_holidays_02 = "content/textures/gear_decals/decal_atlas_holidays_02",
	decal_atlas_mechanicus_01 = "content/textures/gear_decals/decal_atlas_mechanicus_01",
	decal_atlas_mechanicus_01_inv = "content/textures/gear_decals/decal_atlas_mechanicus_01_inv",
	decal_atlas_moebian_01 = "content/textures/gear_decals/decal_atlas_moebian_01",
	decal_atlas_npc_01 = "content/textures/gear_decals/decal_atlas_npc_01",
	decal_atlas_o_brawler_lugger_01 = "content/textures/gear_decals/decal_atlas_o_brawler_lugger_01",
	decal_atlas_ogryn_01 = "content/textures/gear_decals/decal_atlas_ogryn_01",
	decal_atlas_ogryn_02 = "content/textures/gear_decals/decal_atlas_ogryn_02",
	decal_atlas_ogryn_03 = "content/textures/gear_decals/decal_atlas_ogryn_03",
	decal_atlas_ogryn_04 = "content/textures/gear_decals/decal_atlas_ogryn_04",
	decal_atlas_p_biomancer_protector_01 = "content/textures/gear_decals/decal_atlas_p_biomancer_protector_01",
	decal_atlas_psyker_01 = "content/textures/gear_decals/decal_atlas_psyker_01",
	decal_atlas_psyker_02 = "content/textures/gear_decals/decal_atlas_psyker_02",
	decal_atlas_skulls_edition = "content/textures/gear_decals/decal_atlas_skulls_edition",
	decal_atlas_special_events_01 = "content/textures/gear_decals/decal_atlas_special_events_01",
	decal_atlas_steel_legion_01 = "content/textures/gear_decals/decal_atlas_steel_legion_01",
	decal_atlas_tanith_01 = "content/textures/gear_decals/decal_atlas_tanith_01",
	decal_atlas_v_leader_grunt_01 = "content/textures/gear_decals/decal_atlas_v_leader_grunt_01",
	decal_atlas_veteran_01 = "content/textures/gear_decals/decal_atlas_veteran_01",
	decal_atlas_veteran_02 = "content/textures/gear_decals/decal_atlas_veteran_02",
	decal_atlas_winter_01 = "content/textures/gear_decals/decal_atlas_winter_01",
	decal_atlas_z_preacher_maniac_01 = "content/textures/gear_decals/decal_atlas_z_preacher_maniac_01",
	decal_atlas_zealot_01 = "content/textures/gear_decals/decal_atlas_zealot_01",
	decal_atlas_zola = "content/textures/gear_decals/decal_atlas_zola",
}
local material_types = {
	false,
	"coated",
	"oxidized",
}
local decal_amount = 16
local slot_amount = 4
local material_overrides = {
	decal_debug = {
		texture_overrides = {
			decal_atlas = {
				resource = "content/textures/gear_decals/decal_debug",
			},
			decal_atlas_coated = {
				resource = "content/textures/gear_decals/decal_debug",
			},
			decal_atlas_oxidized = {
				resource = "content/textures/gear_decals/decal_debug",
			},
		},
	},
}
local material_override_name, texture_override_name, property_override_name, material_override, slot_and_decal_string, decal_index, slot_index

for _, m_type in pairs(material_types) do
	for atlas, res in pairs(decal_table) do
		slot_index = 1

		while slot_index <= slot_amount do
			decal_index = 1

			while decal_index <= decal_amount do
				material_override = {
					texture_overrides = {},
					property_overrides = {},
				}

				if m_type then
					texture_override_name = "decal_atlas" .. "_" .. m_type
				else
					texture_override_name = "decal_atlas"
				end

				material_override.texture_overrides[texture_override_name] = {
					resource = res,
				}
				slot_and_decal_string = "_slot_" .. string.format("%02d", slot_index) .. "_decal_" .. string.format("%02d", decal_index)

				if m_type then
					material_override_name = m_type .. "_" .. atlas .. slot_and_decal_string
					property_override_name = "decal_index_" .. m_type .. "_" .. string.format("%02d", slot_index)
				else
					material_override_name = atlas .. slot_and_decal_string
					property_override_name = "decal_index_" .. string.format("%02d", slot_index)
				end

				material_override.property_overrides[property_override_name] = {
					decal_index,
				}
				material_overrides[material_override_name] = material_override
				decal_index = decal_index + 1
			end

			slot_index = slot_index + 1
		end
	end
end

return material_overrides
