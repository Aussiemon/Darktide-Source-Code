-- chunkname: @scripts/settings/equipment/weapon_templates/combat_abilities/broker_stimm_field.lua

local Deployables = require("scripts/settings/deployables/deployables")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {}

weapon_template.action_inputs = {
	ability_pressed = {
		buffer_time = 0.2,
		input_sequence = {
			{
				input = "combat_ability_pressed",
				value = true,
			},
		},
	},
	ability_released = {
		buffer_time = 0,
		dont_queue = true,
		input_sequence = nil,
	},
	unwield_to_previous = {
		buffer_time = 0,
		dont_queue = true,
		input_sequence = nil,
	},
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
weapon_template.action_input_hierarchy = {
	{
		input = "ability_pressed",
		transition = {
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "ability_released",
				transition = "base",
			},
		},
	},
	{
		input = "ability_released",
		transition = {
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "unwield_to_previous",
				transition = "base",
			},
		},
	},
	{
		input = "wield",
		transition = "stay",
	},
	{
		input = "unwield_to_previous",
		transition = "stay",
	},
}
weapon_template.actions = {
	action_unwield = {
		allowed_during_sprint = true,
		kind = "unwield",
		start_input = "wield",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
	},
	action_wield = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_event = "equip_crate",
		kind = "wield",
		prevent_sprint = true,
		start_input = "ability_pressed",
		total_time = 0,
		uninterruptible = true,
		conditional_state_to_action_input = {
			action_end = {
				input_name = "ability_released",
			},
		},
		allowed_chain_actions = {
			ability_released = {
				action_name = "action_release",
			},
			wield = {
				action_name = "action_unwield",
			},
		},
	},
	action_release = {
		ability_type = "combat_ability",
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_cancel_event = "action_finished",
		can_drop_anim_event = "drop",
		kind = "place_deployable",
		pause_ability_cooldown = true,
		place_time = 0.54,
		prevent_sprint = true,
		remove_item_from_inventory = false,
		start_input = nil,
		try_until_placed = true,
		uninterruptible = true,
		use_ability_charge = true,
		use_aim_date = false,
		vo_tag = "ability_stimm",
		total_time = math.huge,
		deployable_settings = Deployables.broker_stimm_field_crate,
		place_configuration = {
			allow_aim_upwards_deployment = true,
			distance = 2,
			force_place = true,
		},
		conditional_state_to_action_input = {
			deployable_placed = {
				input_name = "unwield_to_previous",
			},
		},
		allowed_chain_actions = {
			unwield_to_previous = {
				action_name = "action_unwield_to_previous",
			},
			wield = {
				action_name = "action_unwield",
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
