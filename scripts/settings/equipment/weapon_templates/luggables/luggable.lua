-- chunkname: @scripts/settings/equipment/weapon_templates/luggables/luggable.lua

local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {}

weapon_template.action_inputs = {
	push = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				input = "action_two_pressed",
				value = true,
			},
		},
	},
	aim_luggable = {
		buffer_time = 0,
		input_sequence = {
			{
				input = "action_one_hold",
				value = true,
			},
		},
	},
	aim_cancel_push = {
		buffer_time = 0.1,
		input_sequence = {
			{
				hold_input = "action_one_hold",
				input = "action_two_pressed",
				value = true,
			},
		},
	},
	aim_cancel_push_release = {
		buffer_time = 0,
		dont_queue = true,
		input_sequence = {
			{
				input_mode = "all",
				inputs = {
					{
						input = "action_two_hold",
						value = false,
					},
				},
				time_window = math.huge,
			},
		},
	},
	throw = {
		buffer_time = 0,
		clear_input_queue = true,
		max_queue = 2,
		input_sequence = {
			{
				input = "action_one_hold",
				value = false,
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
	push = "stay",
	wield = "stay",
	aim_luggable = {
		throw = "stay",
		wield = "base",
		aim_cancel_push = {
			aim_cancel_push_release = "base",
		},
	},
	inspect_start = {
		inspect_stop = "base",
		wield = "base",
	},
}

table.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

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
		total_time = 1.5,
		uninterruptible = true,
		action_movement_curve = {
			{
				modifier = 0.1,
				t = 0.1,
			},
			{
				modifier = 0.1,
				t = 0.25,
			},
			{
				modifier = 0.2,
				t = 0.4,
			},
			{
				modifier = 0.5,
				t = 0.5,
			},
			{
				modifier = 0.85,
				t = 0.75,
			},
			{
				modifier = 0.95,
				t = 0.9,
			},
			{
				modifier = 1,
				t = 1.5,
			},
			start_modifier = 0.25,
		},
		allowed_chain_actions = {
			push = {
				action_name = "action_push",
				chain_time = 0.5,
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.5,
			},
			aim_luggable = {
				action_name = "action_aim_luggable",
				chain_time = 0.5,
			},
		},
	},
	action_throw = {
		allowed_during_sprint = false,
		anim_event = "throw",
		kind = "throw_luggable",
		sprint_requires_press_to_interrupt = true,
		start_input = "throw",
		throw_time = 0.32,
		throw_type = "throw",
		total_time = 0.5,
		uninterruptible = true,
		action_movement_curve = {
			{
				modifier = 0.15,
				t = 0.1,
			},
			{
				modifier = 0,
				t = 0.2,
			},
			{
				modifier = 0.2,
				t = 0.3,
			},
			{
				modifier = 0.8,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.1,
		},
	},
	action_push = {
		anim_event = "attack_push",
		block_duration = 0.4,
		kind = "push",
		push_radius = 2.5,
		start_input = "push",
		total_time = 0.6,
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
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
				chain_time = 0.5,
			},
		},
		inner_push_rad = math.pi * 0.25,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.default_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.physical,
	},
	action_aim_luggable = {
		allowed_during_sprint = false,
		anim_end_event = "to_unaim_ironsight",
		anim_event = "to_ironsight",
		kind = "aim_projectile",
		locomotion_template = "battery_luggable",
		skip_3p_anims = false,
		start_input = "aim_luggable",
		throw_type = "throw",
		uninterruptible = false,
		total_time = math.huge,
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			throw = {
				action_name = "action_throw",
			},
			aim_cancel_push = {
				action_name = "action_push",
			},
		},
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.25,
			},
			{
				modifier = 0.6,
				t = 0.5,
			},
			{
				modifier = 0.5,
				t = 1.5,
			},
			start_modifier = 0.5,
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
weapon_template.keywords = {
	"luggable",
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/lugging",
	ogryn = "content/characters/player/ogryn/third_person/animations/lugging",
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/lugging",
	ogryn = "content/characters/player/ogryn/first_person/animations/lugging",
}
weapon_template.ammo_template = "no_ammo"
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {}
weapon_template.dodge_template = "luggable"
weapon_template.sprint_template = "luggable"
weapon_template.stamina_template = "luggable"
weapon_template.toughness_template = "luggable"
weapon_template.static_speed_reduction_mod = 0.7
weapon_template.breed_footstep_intervals = {
	human = FootstepIntervalsTemplates.luggable_human,
	ogryn = FootstepIntervalsTemplates.luggable_ogryn,
}

weapon_template.action_none_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not current_action_name or current_action_name == "none"
end

weapon_template.action_aim_luggable_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_aim_luggable"
end

return weapon_template
