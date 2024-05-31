-- chunkname: @scripts/settings/equipment/item_material_overrides/player_material_overrides_emissive.lua

local material_overrides = {
	emissive_red_01 = {
		property_overrides = {
			emissive_color_intensity = {
				1,
				1,
				0,
				0,
			},
		},
	},
	emissive_green_01 = {
		property_overrides = {
			emissive_color_intensity = {
				1,
				0,
				1,
				0,
			},
		},
	},
	emissive_blue_01 = {
		property_overrides = {
			emissive_color_intensity = {
				1,
				0,
				0,
				1,
			},
		},
	},
	emissive_orange_01 = {
		property_overrides = {
			emissive_color_intensity = {
				1,
				0.2,
				0,
				1,
			},
		},
	},
	emissive_orange_02 = {
		property_overrides = {
			emissive_color_intensity = {
				0.55,
				0.2,
				0.05,
				0.75,
			},
		},
	},
	emissive_orange_03 = {
		property_overrides = {
			emissive_color_intensity = {
				1,
				0.02,
				0.003,
				5,
			},
		},
	},
}

return material_overrides
