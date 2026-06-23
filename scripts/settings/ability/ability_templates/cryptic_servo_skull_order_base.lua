-- chunkname: @scripts/settings/ability/ability_templates/cryptic_servo_skull_order_base.lua

local CompanionServoSkullAbility = require("scripts/utilities/companion/companion_servo_skull_ability")
local ability_template = {}

ability_template.allowed_inputs_in_sprint = {
	grenade_ability = true,
}
ability_template.action_inputs = {
	aim_pressed = {
		buffer_time = 0.2,
		input_sequence = {
			{
				input = "grenade_ability_pressed",
				value = true,
			},
		},
	},
}
ability_template.action_input_hierarchy = {
	{
		input = "aim_pressed",
		transition = "base",
	},
}
ability_template.actions = {
	action_companion_start_ability = {
		ability_type = "grenade_ability",
		allowed_during_sprint = true,
		kind = "companion_start_ability",
		sprint_ready_up_time = 0,
		start_input = "aim_pressed",
		total_time = 0.1,
		uninterruptible = true,
		use_ability_charge = true,
		use_charge_at_start = true,
		ability_function = CompanionServoSkullAbility.start_order_ability_base,
	},
}
ability_template.module_target_component_name = "action_module_ability_target_finder"

return ability_template
