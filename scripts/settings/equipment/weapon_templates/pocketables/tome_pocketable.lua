-- chunkname: @scripts/settings/equipment/weapon_templates/pocketables/tome_pocketable.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PocketableUtils = require("scripts/settings/equipment/weapon_templates/pocketables/pockatables_utils")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {}

weapon_template.action_inputs = {
	push = {
		buffer_time = 0.4,
		input_sequence = {
			{
				value = true,
				input = "action_two_pressed"
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

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		transition = "stay",
		input = "push"
	},
	{
		transition = "stay",
		input = "wield"
	},
	{
		input = "aim_give",
		transition = {
			{
				transition = "previous",
				input = "aim_give_release"
			},
			{
				transition = "base",
				input = "wield"
			},
			{
				transition = "base",
				input = "combat_ability"
			},
			{
				transition = "base",
				input = "grenade_ability"
			}
		}
	}
}

ActionInputHierarchy.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
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
		anim_event = "equip_tome",
		total_time = 0
	},
	action_push = {
		push_radius = 2.5,
		start_input = "push",
		block_duration = 0.4,
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
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
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
		validate_target_func = PocketableUtils.validate_give_pocketable_target_func,
		voice_event_data = {
			voice_tag_concept = "on_demand_com_wheel",
			voice_tag_id = "com_take_this"
		}
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

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.keywords = {
	"pocketable"
}
weapon_template.ammo_template = "no_ammo"
weapon_template.hud_configuration = {
	uses_overheat = false,
	uses_ammunition = false
}
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/pocketables",
	ogryn = "content/characters/player/ogryn/third_person/animations/pocketables"
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/grimoire",
	ogryn = "content/characters/player/ogryn/first_person/animations/grimoire"
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.fx_sources = {}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.hud_icon = "content/ui/materials/icons/pocketables/hud/scripture"
weapon_template.hud_icon_small = "content/ui/materials/icons/pocketables/hud/small/party_scripture"
weapon_template.swap_pickup_name = "tome"
weapon_template.give_pickup_name = "tome"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default

weapon_template.action_none_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not current_action_name or current_action_name == "none"
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
