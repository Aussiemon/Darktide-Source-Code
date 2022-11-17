local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local flamer_gas_templates = {
	burst = {
		suppression_radius = 5,
		dot_buff_name = "flamer_assault",
		suppression_cone_dot = 0.75,
		damage = {
			impact = {
				damage_profile = DamageProfileTemplates.default_flamer_assault_burst
			}
		}
	},
	auto = {
		suppression_radius = 6,
		dot_buff_name = "flamer_assault",
		suppression_cone_dot = 0.75,
		damage = {
			impact = {
				damage_profile = DamageProfileTemplates.default_flamer_assault
			}
		}
	},
	warp_fire_burst = {
		suppression_radius = 5,
		dot_buff_name = "warp_fire",
		suppression_cone_dot = 0.75,
		damage = {
			impact = {
				damage_profile = DamageProfileTemplates.default_warpfire_assault_burst
			}
		}
	},
	warp_fire_auto = {
		suppression_radius = 6,
		dot_buff_name = "warp_fire",
		suppression_cone_dot = 0.75,
		damage = {
			impact = {
				damage_profile = DamageProfileTemplates.default_warpfire_assault
			}
		}
	}
}

for name, template in pairs(flamer_gas_templates) do
	template.name = name
	template.same_side_suppression_enabled = false
end

return settings("FlamerGasTemplates", flamer_gas_templates)
