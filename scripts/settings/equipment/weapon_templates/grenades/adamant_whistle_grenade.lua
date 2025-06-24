-- chunkname: @scripts/settings/equipment/weapon_templates/grenades/adamant_whistle_grenade.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local weapon_template = {}

weapon_template.action_inputs = {
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

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
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

ActionInputHierarchy.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
	action_wield = {
		allowed_during_sprint = true,
		anim_event = "equip_noammo",
		kind = "wield",
		sprint_requires_press_to_interrupt = false,
		total_time = 0,
		uninterruptible = true,
	},
	action_aim = {
		ability_type = "grenade_ability",
		aim_ready_up_time = 0,
		allowed_during_lunge = true,
		allowed_during_sprint = true,
		kind = "ability_target_finder",
		minimum_hold_time = 0.025,
		soft_sticky_targeting = true,
		sprint_ready_up_time = 0,
		start_input = "aim_pressed",
		sticky_targeting = false,
		target_finder_module_class_name = "adamant_whistle_targeting",
		total_time = 0.5,
		smart_targeting_template = SmartTargetingTemplates.default_melee,
		allowed_chain_actions = {
			aim_released = {
				action_name = "action_order_companion",
			},
		},
	},
	action_order_companion = {
		ability_type = "grenade_ability",
		allowed_during_sprint = true,
		kind = "windup",
		sprint_ready_up_time = 0,
		total_time = 0.05,
		uninterruptible = true,
	},
}
weapon_template.fx_sources = {}
weapon_template.targeting_fx = {
	effect_name = "content/fx/particles/abilities/adamant/adamant_charge_aim",
}
weapon_template.hud_configuration = {
	uses_ammunition = true,
	uses_overheat = false,
}
weapon_template.keywords = {
	"adamant",
}
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/psyker_smite"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/throwing_knives"
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.hud_icon = "content/ui/materials/icons/throwables/hud/adamant_whistle"

return weapon_template
