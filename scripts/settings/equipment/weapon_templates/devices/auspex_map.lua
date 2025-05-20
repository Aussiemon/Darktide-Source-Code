-- chunkname: @scripts/settings/equipment/weapon_templates/devices/auspex_map.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
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
	open_auspex = {
		anim_event = "scan_start",
		buffer_time = 0.4,
		input_sequence = {
			{
				input = "action_two_pressed",
				value = true,
			},
		},
	},
	push = {
		buffer_time = 0.4,
		input_sequence = {
			{
				input = "action_one_pressed",
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
	unwield = {
		anim_event = "unequip",
		buffer_time = 0,
		clear_input_queue = true,
	},
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		input = "wield",
		transition = "stay",
	},
	{
		input = "open_auspex",
		transition = "stay",
	},
	{
		input = "push",
		transition = "stay",
	},
	{
		input = "unwield",
		transition = "stay",
	},
}

ActionInputHierarchy.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

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
		anim_event = "equip_scanner",
		kind = "wield",
		total_time = 0,
		uninterruptible = true,
	},
	action_open_auspex = {
		allowed_during_sprint = true,
		kind = "use_auspex",
		remove_item_from_inventory = false,
		self_use = true,
		start_input = "open_auspex",
		total_time = 0,
		uninterruptible = true,
	},
	action_push = {
		anim_end_event = "attack_finished",
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
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			push = {
				action_name = "action_push",
				chain_time = 0.4,
			},
		},
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

weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_mission_zone",
		input_name = "unwield",
	},
}
weapon_template.crosshair = {
	crosshair_type = "ironsight",
}
weapon_template.keywords = {
	"pocketable",
}
weapon_template.ammo_template = "no_ammo"
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/pocketables_2h",
	ogryn = "content/characters/player/ogryn/third_person/animations/pocketables_2h",
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/scanner_equip",
	ogryn = "content/characters/player/ogryn/first_person/animations/scanner_equip",
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.fx_sources = {
	_speaker = "fx_speaker",
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.hud_icon = "content/ui/materials/icons/pocketables/hud/auspex_scanner"
weapon_template.require_minigame = true
weapon_template.auto_start_minigame = false
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default

weapon_template.action_push_on_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not current_action_name or current_action_name == "none"
end

return weapon_template
