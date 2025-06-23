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
				value = true,
				input = "grenade_ability_pressed"
			}
		}
	},
	aim_released = {
		buffer_time = 0.1,
		input_sequence = {
			{
				value = false,
				input = "grenade_ability_hold",
				time_window = math.huge
			}
		}
	}
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		input = "aim_pressed",
		transition = {
			{
				transition = "base",
				input = "aim_released"
			}
		}
	}
}

ActionInputHierarchy.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
	action_wield = {
		kind = "wield",
		sprint_requires_press_to_interrupt = false,
		allowed_during_sprint = true,
		uninterruptible = true,
		anim_event = "equip_noammo",
		total_time = 0
	},
	action_aim = {
		start_input = "aim_pressed",
		total_time = 0.5,
		target_finder_module_class_name = "adamant_whistle_targeting",
		kind = "ability_target_finder",
		soft_sticky_targeting = true,
		sprint_ready_up_time = 0,
		sticky_targeting = false,
		allowed_during_sprint = true,
		allowed_during_lunge = true,
		ability_type = "grenade_ability",
		aim_ready_up_time = 0,
		minimum_hold_time = 0.025,
		smart_targeting_template = SmartTargetingTemplates.default_melee,
		allowed_chain_actions = {
			aim_released = {
				action_name = "action_order_companion"
			}
		}
	},
	action_order_companion = {
		ability_type = "grenade_ability",
		uninterruptible = true,
		allowed_during_sprint = true,
		kind = "windup",
		sprint_ready_up_time = 0,
		total_time = 0.05
	}
}
weapon_template.fx_sources = {}
weapon_template.targeting_fx = {
	effect_name = "content/fx/particles/abilities/adamant/adamant_charge_aim"
}
weapon_template.hud_configuration = {
	uses_overheat = false,
	uses_ammunition = true
}
weapon_template.keywords = {
	"adamant"
}
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/psyker_smite"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/throwing_knives"
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.hud_icon = "content/ui/materials/icons/throwables/hud/adamant_whistle"

return weapon_template
