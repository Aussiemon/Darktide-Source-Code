-- chunkname: @scripts/settings/equipment/weapon_templates/combat_abilities/broker_stimm_field.lua

local Deployables = require("scripts/settings/deployables/deployables")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local talent_settings = TalentSettings.broker
local weapon_template = {}

weapon_template.action_inputs = {
	ability_pressed = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "combat_ability_hold",
				value = true,
			},
		},
	},
	ability_released = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "combat_ability_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	unwield_to_previous = {
		buffer_time = 0,
		dont_queue = true,
		input_sequence = nil,
	},
}
weapon_template.action_input_hierarchy = {
	{
		input = "ability_pressed",
		transition = {
			{
				input = "ability_released",
				transition = "base",
			},
			{
				input = "unwield_to_previous",
				transition = "base",
			},
		},
	},
	{
		input = "unwield_to_previous",
		transition = "base",
	},
}

local SETTINGS = talent_settings.combat_ability.stimm_field

weapon_template.actions = {
	action_wield = {
		allowed_during_sprint = true,
		anim_event = "equip_crate",
		kind = "wield",
		start_input = "ability_pressed",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {
			ability_released = {
				action_name = "action_release",
			},
		},
	},
	action_release = {
		ability_type = "combat_ability",
		allowed_during_sprint = true,
		anim_cancel_event = "action_finished",
		anim_event = "drop",
		kind = "place_deployable",
		remove_item_from_inventory = false,
		start_input = "ability_released",
		total_time = 0.54,
		uninterruptible = true,
		use_ability_charge = true,
		use_aim_date = false,
		vo_tag = "ability_stimm",
		deployable_settings = Deployables.broker_stimm_field_crate,
		place_configuration = {
			allow_aim_upwards_deployment = true,
			distance = 2,
		},
		conditional_state_to_action_input = {
			action_end = {
				input_name = "unwield_to_previous",
			},
		},
		allowed_chain_actions = {
			unwield_to_previous = {
				action_name = "action_unwield_to_previous",
			},
		},
	},
	action_unwield_to_previous = {
		allowed_during_sprint = true,
		kind = "unwield_to_previous",
		total_time = 0,
		uninterruptible = true,
		unwield_to_weapon = true,
	},
}
weapon_template.keywords = {
	"pocketable",
}
weapon_template.ammo_template = "no_ammo"
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/pocketables",
	ogryn = "content/characters/player/ogryn/third_person/animations/pocketables",
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/pocketables",
	ogryn = "content/characters/player/ogryn/first_person/animations/pocketables",
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.fx_sources = {}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default

return weapon_template
