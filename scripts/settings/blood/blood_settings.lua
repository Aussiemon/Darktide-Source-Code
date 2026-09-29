-- chunkname: @scripts/settings/blood/blood_settings.lua

local blood_settings = {}

blood_settings.blood_ball = {
	max_per_frame = 16,
	ring_buffer_size = 64,
	damage_type_speed = {
		default = 15
	},
	blood_type_decal = {
		default = {
			"content/fx/units/blood_decal_dir_01",
			"content/fx/units/blood_decal_omni_01"
		},
		poxwalker = {
			"content/fx/units/fx_poxwalker_blood_decal_dir_01",
			"content/fx/units/fx_poxwalker_blood_decal_omni_01"
		}
	}
}
blood_settings.weapon_blood_amounts = {
	default = 0.05,
	full = 1
}

return settings("BloodSettings", blood_settings)
