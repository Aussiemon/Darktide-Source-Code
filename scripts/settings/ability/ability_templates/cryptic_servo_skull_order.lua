-- chunkname: @scripts/settings/ability/ability_templates/cryptic_servo_skull_order.lua

local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
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
	aim_released = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "grenade_ability_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	block_cancel = {
		buffer_time = 0,
		input_sequence = {
			{
				hold_input = "grenade_ability_hold",
				input = "action_two_pressed",
				value = true,
			},
		},
	},
}
ability_template.action_input_hierarchy = {
	{
		input = "aim_pressed",
		transition = {
			{
				input = "aim_released",
				transition = "base",
			},
			{
				input = "block_cancel",
				transition = "base",
			},
		},
	},
}
ability_template.actions = {
	action_aim = {
		ability_type = "grenade_ability",
		aim_ready_up_time = 0,
		allowed_during_lunge = true,
		allowed_during_sprint = true,
		effect_template_name = "companion_servo_skull_aim_on_ground_effect",
		kind = "servo_skull_order_target_finder",
		minimum_hold_time = 0.025,
		reset_smart_targeting_on_start = true,
		sprint_ready_up_time = 0,
		start_input = "aim_pressed",
		sticky_targeting = false,
		stop_input = "block_cancel",
		target_finder_module_class_name = "multi_targeting",
		total_time = math.huge,
		smart_targeting_template = SmartTargetingTemplates.target_servo_skull_target,
		can_target_unit_validate_func = CompanionServoSkullAbility.can_target_unit,
		select_animation_event_func = CompanionServoSkullAbility.select_animation_event,
		place_configuration = {
			key_input = "action_one_pressed",
			on_input_action_func = CompanionServoSkullAbility.on_input_action_func,
		},
		aim_on_ground_validate_function = CompanionServoSkullAbility.can_aim_on_ground,
		allowed_chain_actions = {
			aim_released = {
				action_name = "action_companion_start_ability",
			},
		},
	},
	action_companion_start_ability = {
		ability_type = "grenade_ability",
		allowed_during_sprint = true,
		kind = "companion_start_ability",
		sprint_ready_up_time = 0,
		total_time = 0.1,
		uninterruptible = true,
		use_ability_charge = false,
		ability_function = CompanionServoSkullAbility.start_order_ability,
	},
}
ability_template.fx_sources = {}
ability_template.equipped_ability_effect_scripts = {
	"TargetedAllyEffects",
}
ability_template.equipped_ability_effect_scripts_tweak_data = {
	targeting = {
		effect_validate_target_func = CompanionServoSkullAbility.effect_validate_target_func,
		select_aim_on_ground_effect = CompanionServoSkullAbility.select_aim_on_ground_effect,
		spawn_effect_validate_func = CompanionServoSkullAbility.can_aim_on_ground,
		select_target_outline_func = CompanionServoSkullAbility.select_target_outline_func,
	},
}
ability_template.module_target_component_name = "action_module_ability_target_finder"

return ability_template
