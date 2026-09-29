-- chunkname: @scripts/settings/equipment/weapon_templates/devices/servo_skull.lua

local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {}

weapon_template.action_inputs = {
	wield = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				inputs = wield_inputs,
			},
		},
	},
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		input = "wield",
		transition = "stay",
	},
}
weapon_template.actions = {
	action_wield = {
		allowed_during_sprint = true,
		anim_event = "servo_deploy",
		kind = "wield",
		total_time = 0.9,
		uninterruptible = true,
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.ammo_template = "no_ammo"
weapon_template.keywords = {
	"devices",
}
weapon_template.breed_anim_state_machine_3p = {
	cryptic = "content/characters/player/human/third_person/animations/unarmed",
	human = "content/characters/player/human/third_person/animations/unarmed",
	ogryn = "content/characters/player/ogryn/third_person/animations/unarmed",
}
weapon_template.breed_anim_state_machine_1p = {
	cryptic = "content/characters/player/human/first_person/animations/unarmed",
	human = "content/characters/player/human/first_person/animations/unarmed",
	ogryn = "content/characters/player/ogryn/first_person/animations/unarmed",
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.fx_sources = {
	_antigrav = "fx_source",
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.hud_icon = "content/ui/materials/icons/pickups/default"
weapon_template.hide_slot = true
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.not_player_wieldable = true

return weapon_template
