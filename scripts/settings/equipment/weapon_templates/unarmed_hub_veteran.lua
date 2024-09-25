﻿-- chunkname: @scripts/settings/equipment/weapon_templates/unarmed_hub_veteran.lua

local weapon_template = {}

weapon_template.action_inputs = {}
weapon_template.action_input_hierarchy = {}
weapon_template.actions = {
	action_wield = {
		allowed_during_sprint = true,
		kind = "wield",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
	},
}
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/hub_veteran",
	ogryn = "content/characters/player/ogryn/third_person/animations/unarmed",
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/unarmed",
	ogryn = "content/characters/player/ogryn/first_person/animations/unarmed",
}
weapon_template.keywords = {
	"unarmed",
}
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.crosshair = {
	crosshair_type = "ironsight",
}
weapon_template.sprint_ready_up_time = 0
weapon_template.max_first_person_anim_movement_speed = 6
weapon_template.smart_targeting_template = false
weapon_template.fx_sources = {}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"

return weapon_template
