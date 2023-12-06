local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PocketableUtils = require("scripts/settings/equipment/weapon_templates/pocketables/pockatables_utils")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local pocketables_template_settings = {
	action_inputs = {
		push = {
			buffer_time = 0.4,
			input_sequence = {
				{
					value = true,
					input = "action_two_pressed"
				}
			}
		},
		place = {
			buffer_time = 0.2,
			input_sequence = {
				{
					value = true,
					input = "action_one_pressed"
				}
			}
		},
		wield = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					inputs = wield_inputs
				}
			}
		},
		aim_give = {
			buffer_time = 0.3,
			max_queue = 1,
			reevaluation_time = 0.18,
			input_sequence = {
				{
					value = true,
					hold_input = "weapon_extra_hold",
					input = "weapon_extra_hold"
				}
			}
		},
		aim_give_release = {
			buffer_time = 0.3,
			max_queue = 1,
			input_sequence = {
				{
					value = false,
					input = "weapon_extra_hold",
					time_window = math.huge
				}
			}
		}
	}
}

table.add_missing(pocketables_template_settings.action_inputs, BaseTemplateSettings.action_inputs)

pocketables_template_settings.action_input_hierarchy = {
	place = "base",
	wield = "base",
	push = "stay",
	aim_give = {
		wield = "base",
		aim_give_release = "previous",
		combat_ability = "base",
		grenade_ability = "base"
	}
}

table.add_missing(pocketables_template_settings.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

pocketables_template_settings.actions = {
	action_unwield = {
		allowed_during_sprint = true,
		start_input = "wield",
		uninterruptible = true,
		kind = "unwield",
		total_time = 0,
		allowed_chain_actions = {}
	},
	action_wield = {
		kind = "wield",
		allowed_during_sprint = true,
		uninterruptible = true,
		anim_event = "equip_crate",
		total_time = 0
	},
	action_push = {
		push_radius = 2.5,
		start_input = "push",
		block_duration = 0.32,
		kind = "push",
		anim_event = "attack_push",
		total_time = 0.67,
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.1
			},
			{
				modifier = 1.15,
				t = 0.25
			},
			{
				modifier = 0.5,
				t = 0.4
			},
			{
				modifier = 1,
				t = 0.67
			},
			start_modifier = 1
		},
		inner_push_rad = math.pi * 0.25,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.default_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.physical
	},
	action_aim_give = {
		aim_ready_up_time = 0,
		start_input = "aim_give",
		prevent_sprint = true,
		kind = "target_ally",
		sprint_ready_up_time = 0,
		allowed_during_lunge = true,
		allowed_during_sprint = true,
		minimum_hold_time = 0.01,
		anim_end_event = "share_aim_end",
		abort_sprint = true,
		clear_on_hold_release = true,
		uninterruptible = true,
		anim_event = "share_aim",
		stop_input = "aim_give_release",
		total_time = math.huge,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action"
		end,
		validate_target_func = PocketableUtils.validate_give_pocketable_target_func,
		smart_targeting_template = SmartTargetingTemplates.target_ally_close,
		allowed_chain_actions = {
			aim_give_release = {
				action_name = "action_give"
			},
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			}
		}
	},
	action_give = {
		anim_event = "share_ally",
		allowed_during_sprint = true,
		give_time = 0.7,
		anim_end_event = "share_aim_end",
		kind = "give_pocketable",
		assist_notification_type = "gifted",
		total_time = 0.7,
		smart_targeting_template = SmartTargetingTemplates.target_ally_close,
		validate_target_func = PocketableUtils.validate_give_pocketable_target_func
	},
	action_inspect = {
		skip_3p_anims = true,
		lock_view = true,
		start_input = "inspect_start",
		anim_end_event = "inspect_end",
		kind = "inspect",
		anim_event = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect"
		}
	}
}

table.add_missing(pocketables_template_settings.actions, BaseTemplateSettings.actions)

return pocketables_template_settings
