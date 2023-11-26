-- chunkname: @scripts/settings/equipment/item_material_overrides/item_material_overrides_debug.lua

local material_overrides = {
	wear_sand_01 = {
		property_overrides = {
			environment_mask = {
				1,
				2.9,
				0.1
			},
			environment_mask_properties = {
				0.1,
				0.06,
				0.03,
				1.12
			}
		},
		texture_overrides = {
			environment_noise_map = {
				resource = "content/environment/textures/shader_masks/grunge/grunge_mask_08"
			}
		}
	},
	wear_snow_01 = {
		property_overrides = {
			environment_mask = {
				1,
				2,
				0.1
			},
			environment_mask_properties = {
				0.35,
				0.35,
				0.45,
				0.95
			}
		},
		texture_overrides = {
			environment_noise_map = {
				resource = "content/environment/textures/shader_masks/grunge/grunge_mask_02"
			}
		}
	},
	wear_dirt_01 = {
		property_overrides = {
			environment_mask = {
				1,
				2.7,
				0.1
			},
			environment_mask_properties = {
				0.015,
				0.01,
				0.004,
				1.05
			}
		},
		texture_overrides = {
			environment_noise_map = {
				resource = "content/environment/textures/shader_masks/grunge/grunge_mask_08"
			}
		}
	}
}

return material_overrides
