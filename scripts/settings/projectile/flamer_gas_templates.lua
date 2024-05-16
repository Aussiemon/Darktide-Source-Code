-- chunkname: @scripts/settings/projectile/flamer_gas_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local flamer_gas_templates = {}

flamer_gas_templates.burst = {
	dot_buff_name = "flamer_assault",
	suppression_cone_dot = 0.75,
	suppression_radius = 5,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_flamer_assault_burst,
		},
	},
}
flamer_gas_templates.auto = {
	dot_buff_name = "flamer_assault",
	suppression_cone_dot = 0.75,
	suppression_radius = 6,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_flamer_assault,
		},
	},
}
flamer_gas_templates.warp_fire_burst = {
	dot_buff_name = "warp_fire",
	suppression_cone_dot = 0.75,
	suppression_radius = 5,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_warpfire_assault_burst,
		},
	},
}
flamer_gas_templates.warp_fire_auto = {
	dot_buff_name = "warp_fire",
	suppression_cone_dot = 0.75,
	suppression_radius = 6,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_warpfire_assault,
		},
	},
}

for name, template in pairs(flamer_gas_templates) do
	template.name = name
	template.same_side_suppression_enabled = false
end

return settings("FlamerGasTemplates", flamer_gas_templates)
