-- chunkname: @scripts/settings/ability/ability_templates/adamant_whistle.lua

local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local ability_template = {}

ability_template.action_inputs = {
	aim_pressed = {
		buffer_time = 0.1,
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
}
ability_template.action_input_hierarchy = {
	{
		input = "aim_pressed",
		transition = {
			{
				input = "aim_released",
				transition = "base",
			},
		},
	},
}
ability_template.actions = {
	action_aim = {
		ability_type = "grenade_ability",
		allowed_during_lunge = true,
		allowed_during_sprint = true,
		kind = "shout_aim",
		minimum_hold_time = 0.075,
		start_input = "aim_pressed",
		total_time = math.huge,
		radius = RADIUS,
		allowed_chain_actions = {
			aim_released = {
				action_name = "action_order_companion",
			},
		},
	},
	action_order_companion = {
		ability_type = "grenade_ability",
		allowed_during_sprint = true,
		kind = "order_companion",
		sprint_ready_up_time = 0,
		total_time = 1,
		trigger_time = 0.3,
		uninterruptible = true,
		use_ability_charge = true,
	},
}
ability_template.fx_sources = {}
ability_template.hud_configuration = {
	uses_ammunition = true,
	uses_overheat = false,
}
ability_template.keywords = {
	"adamant",
}
ability_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/psyker_smite"
ability_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/throwing_knives"
ability_template.smart_targeting_template = SmartTargetingTemplates.default_melee
ability_template.hud_icon = "content/ui/materials/icons/throwables/hud/adamant_whistle"

return ability_template
