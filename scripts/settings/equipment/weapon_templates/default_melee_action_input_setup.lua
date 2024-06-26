﻿-- chunkname: @scripts/settings/equipment/weapon_templates/default_melee_action_input_setup.lua

local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local default_melee_action_input_setup = {}

default_melee_action_input_setup.action_inputs = {
	start_attack = {
		buffer_time = 0.3,
		max_queue = 1,
		reevaluation_time = 0.18,
		input_sequence = {
			{
				input = "action_one_hold",
				value = true,
			},
		},
	},
	attack_cancel = {
		buffer_time = 0.1,
		input_sequence = {
			{
				hold_input = "action_one_hold",
				input = "action_two_pressed",
				value = true,
			},
		},
	},
	light_attack = {
		buffer_time = 0.3,
		max_queue = 1,
		input_sequence = {
			{
				input = "action_one_hold",
				time_window = 0.2,
				value = false,
			},
		},
	},
	heavy_attack = {
		buffer_time = 0.5,
		max_queue = 1,
		input_sequence = {
			{
				duration = 0.25,
				input = "action_one_hold",
				value = true,
			},
			{
				auto_complete = true,
				input = "action_one_hold",
				time_window = 1.5,
				value = false,
			},
		},
	},
	attack_release = {
		buffer_time = 0,
		dont_queue = true,
		input_sequence = {
			{
				input = "action_one_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	block = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "action_two_hold",
				value = true,
			},
		},
	},
	block_release = {
		buffer_time = 0.35,
		max_queue = 1,
		input_sequence = {
			{
				input = "action_two_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	push = {
		buffer_time = 0.2,
		input_sequence = {
			{
				hold_input = "action_two_hold",
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	push_follow_up = {
		buffer_time = 0.3,
		input_sequence = {
			{
				duration = 0.25,
				hold_input = "action_two_hold",
				input = "action_one_hold",
				value = true,
			},
		},
	},
	push_follow_up_release = {
		buffer_time = 0,
		dont_queue = true,
		input_sequence = {
			{
				inputs = {
					{
						input = "action_one_hold",
						value = false,
					},
					{
						input = "action_two_hold",
						value = false,
					},
				},
				time_window = math.huge,
			},
		},
	},
	push_follow_up_early_release = {
		buffer_time = 0,
		dont_queue = true,
		input_sequence = {
			{
				input = "action_one_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	special_action = {
		buffer_time = 0.2,
		input_sequence = {
			{
				input = "weapon_extra_pressed",
				value = true,
			},
		},
	},
	special_action_hold = {
		buffer_time = 0.2,
		input_sequence = {
			{
				hold_input = "weapon_extra_hold",
				input = "weapon_extra_hold",
				value = true,
			},
		},
	},
	special_action_release = {
		buffer_time = 0.2,
		input_sequence = {
			{
				hold_input = "weapon_extra_release",
				input = "weapon_extra_release",
				value = true,
			},
		},
	},
}

table.add_missing(default_melee_action_input_setup.action_inputs, BaseTemplateSettings.action_inputs)

default_melee_action_input_setup.action_input_hierarchy = {
	combat_ability = "base",
	grenade_ability = "base",
	special_action = "base",
	wield = "stay",
	start_attack = {
		attack_cancel = "base",
		block = "base",
		combat_ability = "base",
		grenade_ability = "base",
		heavy_attack = "base",
		light_attack = "base",
		special_action = "base",
		wield = "base",
	},
	block = {
		block_release = "base",
		combat_ability = "base",
		grenade_ability = "base",
		special_action = "base",
		wield = "base",
		push = {
			push_follow_up_early_release = "base",
			special_action = "base",
			push_follow_up = {
				block = "base",
				combat_ability = "base",
				grenade_ability = "base",
				push_follow_up_release = "base",
				special_action = "base",
				wield = "base",
			},
		},
	},
}

table.add_missing(default_melee_action_input_setup.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

return default_melee_action_input_setup
