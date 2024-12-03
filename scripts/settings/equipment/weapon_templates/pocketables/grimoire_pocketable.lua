-- chunkname: @scripts/settings/equipment/weapon_templates/pocketables/grimoire_pocketable.lua

local ActionInputHierarchy = require("scripts/utilities/weapon/action_input_hierarchy")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {}

weapon_template.action_inputs = {
	push = {
		buffer_time = 0.4,
		input_sequence = {
			{
				input = "action_two_pressed",
				value = true,
			},
		},
	},
	throw_start = {
		buffer_time = 0,
		input_sequence = {
			{
				input = "action_one_hold",
				value = true,
			},
		},
	},
	throw_stop = {
		buffer_time = 0.02,
		input_sequence = {
			{
				input = "action_one_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	throw_complete = {
		buffer_time = 0,
		input_sequence = {
			{
				input = "action_one_hold",
				value = true,
			},
		},
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

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		input = "push",
		transition = "stay",
	},
	{
		input = "throw_start",
		transition = {
			{
				input = "throw_stop",
				transition = "base",
			},
			{
				input = "throw_complete",
				transition = "base",
			},
			{
				input = "wield",
				transition = "base",
			},
		},
	},
	{
		input = "wield",
		transition = "stay",
	},
}

ActionInputHierarchy.add_missing_ordered(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

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
		allowed_during_sprint = true,
		anim_event = "equip",
		kind = "wield",
		total_time = 0,
		uninterruptible = true,
	},
	action_push = {
		anim_event = "attack_push",
		block_duration = 0.4,
		kind = "push",
		push_radius = 2.5,
		start_input = "push",
		total_time = 0.67,
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.1,
			},
			{
				modifier = 1.15,
				t = 0.25,
			},
			{
				modifier = 0.5,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 0.67,
			},
			start_modifier = 1,
		},
		inner_push_rad = math.pi * 0.25,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.default_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.physical,
	},
	action_throw = {
		allowed_during_sprint = false,
		anim_end_event = "action_finished",
		anim_event = "grim_throw",
		kind = "windup",
		start_input = "throw_start",
		stop_input = "throw_stop",
		total_time = 3,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			throw_complete = {
				action_name = "action_throw_complete",
				chain_time = 2.47,
			},
		},
	},
	action_throw_complete = {
		allowed_during_sprint = false,
		anim_event = "throw",
		kind = "discard",
		pickup_name = "grimoire",
		total_time = 0.5333333333333333,
		uninterruptible = true,
	},
	action_inspect = {
		anim_end_event = "inspect_end",
		anim_event = "inspect_start",
		kind = "inspect",
		lock_view = true,
		skip_3p_anims = false,
		start_input = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect",
		},
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.keywords = {
	"pocketable",
	"grimoire",
}
weapon_template.ammo_template = "no_ammo"
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
	uses_weapon_special_charges = false,
}
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/pocketables",
	ogryn = "content/characters/player/ogryn/third_person/animations/pocketables",
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/grimoire",
	ogryn = "content/characters/player/ogryn/first_person/animations/grimoire",
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.fx_sources = {
	_passive = "fx_passive",
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.hud_icon = "content/ui/materials/icons/pocketables/hud/grimoire"
weapon_template.hud_icon_small = "content/ui/materials/icons/pocketables/hud/small/party_grimoire"
weapon_template.swap_pickup_name = "grimoire"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default

weapon_template.action_none_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not current_action_name or current_action_name == "none"
end

weapon_template.action_discard_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_throw"
end

return weapon_template
