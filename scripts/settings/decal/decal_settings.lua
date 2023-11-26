-- chunkname: @scripts/settings/decal/decal_settings.lua

local decal_settings = {
	blood = {
		sort_order_base = 6000000,
		units = {
			"content/fx/units/blood_decal_dir_01",
			"content/fx/units/blood_decal_omni_01",
			"content/fx/units/fx_poxwalker_blood_decal_dir_01",
			"content/fx/units/fx_poxwalker_blood_decal_omni_01"
		}
	},
	impact = {
		sort_order_base = 1000000,
		units = {
			"content/fx/units/weapons/vfx_decal_metal_bullethole",
			"content/fx/units/weapons/small_caliber_concrete_small_01",
			"content/fx/units/weapons/small_caliber_concrete_medium_01",
			"content/fx/units/weapons/small_caliber_concrete_large_01",
			"content/fx/units/weapons/small_caliber_metal_large_01",
			"content/fx/units/weapons/small_caliber_metal_medium_01",
			"content/fx/units/weapons/small_caliber_metal_small_01",
			"content/fx/units/weapons/small_caliber_glass_large_01",
			"content/fx/units/weapons/small_caliber_glass_medium_01",
			"content/fx/units/weapons/small_caliber_glass_small_01",
			"content/fx/units/weapons/small_caliber_wood_large_01",
			"content/fx/units/weapons/small_caliber_wood_medium_01",
			"content/fx/units/weapons/small_caliber_wood_small_01",
			"content/fx/units/weapons/small_caliber_cloth_large_01",
			"content/fx/units/weapons/small_caliber_cloth_medium_01"
		}
	}
}

return settings("DecalSettings", decal_settings)
