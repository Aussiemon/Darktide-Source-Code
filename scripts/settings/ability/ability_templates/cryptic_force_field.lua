-- chunkname: @scripts/settings/ability/ability_templates/cryptic_force_field.lua

local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local talent_settings = TalentSettings.cryptic.force_field
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
}
ability_template.action_input_hierarchy = {
	{
		input = "aim_pressed",
		transition = "stay",
	},
}
ability_template.actions = {
	action_activate = {
		ability_type = "grenade_ability",
		allowed_during_sprint = true,
		kind = "activate_force_shield",
		sprint_ready_up_time = 0,
		start_input = "aim_pressed",
		trigger_time = 0.3,
		uninterruptible = true,
		use_ability_charge = true,
		use_charge_at_start = true,
		vo_tag = "cryptic_blitz_03_a",
		total_time = talent_settings.duration,
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			return not condition_func_params.talent_extension:has_special_rule("cryptic_force_field_increased_duration_and_extra_explosion")
		end,
	},
	action_activate_increased_duration = {
		ability_type = "grenade_ability",
		allowed_during_sprint = true,
		kind = "activate_force_shield",
		sprint_ready_up_time = 0,
		start_input = "aim_pressed",
		trigger_time = 0.3,
		uninterruptible = true,
		use_ability_charge = true,
		use_charge_at_start = true,
		vo_tag = "cryptic_blitz_03_a",
		total_time = talent_settings.increased_duration,
		action_condition_func = function (action_settings, condition_func_params, used_input, t, time_in_action)
			return condition_func_params.talent_extension:has_special_rule("cryptic_force_field_increased_duration_and_extra_explosion")
		end,
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
ability_template.hud_icon_small = "content/ui/materials/icons/throwables/hud/small/party_non_grenade"

return ability_template
