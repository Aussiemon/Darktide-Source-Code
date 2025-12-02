-- chunkname: @scripts/settings/equipment/weapon_templates/grenades/quick_flash_grenade.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local grenade_handleless_weapon_template_generator = require("scripts/settings/equipment/weapon_templates/weapon_template_generators/grenade_handleless_weapon_template_generator")
local weapon_template = grenade_handleless_weapon_template_generator()
local auto_input = {
	{
		inputs = {
			{
				input = "action_one_pressed",
				value = true,
			},
			{
				input = "action_one_pressed",
				value = false,
			},
		},
	},
}

weapon_template.action_inputs.aim_hold = {
	buffer_time = 0,
	input_sequence = auto_input,
}
weapon_template.action_inputs.aim_released = {
	buffer_time = 0,
	input_sequence = auto_input,
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.sprint_ready_up_time = 0
weapon_template.allowed_inputs_in_sprint = {
	aim_hold = true,
	aim_released = true,
	wield = true,
}
weapon_template.actions.action_aim.minimum_hold_time = 0
weapon_template.actions.action_aim.allowed_chain_actions.aim_released.chain_time = 0
weapon_template.actions.action_aim.anim_event = nil
weapon_template.actions.action_aim.anim_end_event = nil
weapon_template.actions.action_aim.sprint_ready_up_time = 0
weapon_template.actions.action_aim.allowed_during_sprint = true
weapon_template.actions.action_throw_grenade.anim_event = "attack_shoot_right"
weapon_template.actions.action_throw_grenade.anim_end_event = nil
weapon_template.actions.action_throw_grenade.allowed_during_sprint = true
weapon_template.actions.action_wield.anim_event = "equip_noammo"
weapon_template.actions.action_wield.anim_event_3p = nil
weapon_template.actions.action_wield.total_time = 0
weapon_template.actions.action_wield.allowed_during_sprint = true
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/psyker_smite"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/throwing_knives"
weapon_template.projectile_template = ProjectileTemplates.quick_flash_grenade
weapon_template.hud_icon_small = "content/ui/materials/icons/throwables/hud/small/party_grenade"

return weapon_template
