local Deployables = require("scripts/settings/deployables/deployables")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PocketablesTemplateSettings = require("scripts/settings/equipment/weapon_templates/pocketables/settings_templates/pocketables_template_settings")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local weapon_template = {
	action_inputs = {}
}

table.add_missing(weapon_template.action_inputs, PocketablesTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {}

table.add_missing(weapon_template.action_input_hierarchy, PocketablesTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
	action_place_complete = {
		allowed_during_sprint = true,
		start_input = "place",
		remove_item_from_inventory = true,
		kind = "place_deployable",
		use_aim_date = false,
		anim_cancel_event = "action_finished",
		uninterruptible = true,
		anim_event = "drop",
		total_time = 0.54,
		deployable_settings = Deployables.medical_crate,
		place_configuration = {
			distance = 2
		}
	}
}

table.add_missing(weapon_template.actions, PocketablesTemplateSettings.actions)

weapon_template.keywords = {
	"pocketable"
}
weapon_template.ammo_template = "no_ammo"
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/pocketables",
	ogryn = "content/characters/player/ogryn/third_person/animations/pocketables"
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/pocketables",
	ogryn = "content/characters/player/ogryn/first_person/animations/pocketables"
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.fx_sources = {}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.swap_pickup_name = "medical_crate_pocketable"
weapon_template.give_pickup_name = "medical_crate_pocketable"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.hud_icon = "content/ui/materials/icons/pocketables/hud/medical_crate"
weapon_template.hud_icon_small = "content/ui/materials/icons/pocketables/hud/small/party_medic_crate"

weapon_template.action_none_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not current_action_name or current_action_name == "none"
end

weapon_template.action_place_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_place"
end

weapon_template.action_none_gift_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not current_action_name or current_action_name == "none"
end

weapon_template.action_can_give_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player, condition_func_params)
	local action_module_targeting_component = condition_func_params.action_module_targeting_component
	local target_unit = action_module_targeting_component.target_unit_1

	return current_action_name == "action_aim_give" and target_unit ~= nil
end

weapon_template.action_cant_give_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player, condition_func_params)
	local action_module_targeting_component = condition_func_params.action_module_targeting_component
	local target_unit = action_module_targeting_component.target_unit_1

	return current_action_name == "action_aim_give" and target_unit == nil
end

return weapon_template
