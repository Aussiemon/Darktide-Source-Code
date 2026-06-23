-- chunkname: @scripts/settings/projectile/companion_servo_skull_flamer_gas_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local companion_servo_skull_flamer_gas_templates = {}

companion_servo_skull_flamer_gas_templates.auto = {
	burn_max_stacks = 16,
	dot_buff_name = "flamer_assault",
	dot_stack_application_rate = 0.375,
	initial_burn_delay = 0,
	suppression_cone_dot = 0.75,
	suppression_radius = 3,
	damage_times = {
		0.3,
		0.3,
		0.3,
		0.375,
		0.375,
		0.375,
		0.45,
	},
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.companion_servo_skull_flamer,
		},
	},
}

for name, template in pairs(companion_servo_skull_flamer_gas_templates) do
	template.name = name
	template.same_side_suppression_enabled = false
end

return settings("CompanionServoSkullFlamerGasTemplates", companion_servo_skull_flamer_gas_templates)
