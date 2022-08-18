local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {
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
		throw_start = {
			buffer_time = 0,
			input_sequence = {
				{
					value = true,
					input = "action_one_hold"
				}
			}
		},
		throw_stop = {
			buffer_time = 0.02,
			input_sequence = {
				{
					value = false,
					input = "action_one_hold",
					time_window = math.huge
				}
			}
		},
		throw_complete = {
			buffer_time = 0,
			input_sequence = {
				{
					value = true,
					input = "action_one_hold"
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
		}
	}
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	wield = "stay",
	push = "stay",
	throw_start = {
		throw_stop = "base",
		throw_complete = "base",
		wield = "base"
	}
}

table.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
	action_unwield = {
		continue_sprinting = true,
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
		anim_event = "equip",
		total_time = 0
	},
	action_push = {
		push_radius = 2.5,
		start_input = "push",
		block_duration = 0.4,
		kind = "push",
		anim_event = "attack_push",
		power_level = 500,
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
		inner_push_rad = math.pi * 0.6,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.push_test,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.push_test,
		outer_damage_type = damage_types.physical
	},
	action_throw = {
		start_input = "throw_start",
		anim_end_event = "action_finished",
		kind = "windup",
		allowed_during_sprint = false,
		anim_event = "grim_throw",
		stop_input = "throw_stop",
		total_time = 3,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			throw_complete = {
				action_name = "action_throw_complete",
				chain_time = 2.47
			}
		}
	},
	action_throw_complete = {
		uninterruptible = true,
		anim_event = "throw",
		allowed_during_sprint = false,
		kind = "discard",
		pickup_name = "grimoire",
		total_time = 0.5333333333333333
	},
	action_inspect = {
		skip_3p_anims = true,
		lock_view = true,
		start_input = "inspect_start",
		anim_end_event = "inspect_end",
		kind = "inspect",
		crosshair_type = "none",
		anim_event = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge
	}
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.keywords = {
	"pocketable",
	"grimoire"
}
weapon_template.ammo_template = "no_ammo"
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/pocketables",
	ogryn = "content/characters/player/ogryn/third_person/animations/pocketables"
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/grimoire",
	ogryn = "content/characters/player/ogryn/first_person/animations/grimoire"
}
weapon_template.fx_sources = {
	_passive = "fx_passive"
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.hud_icon = "content/ui/materials/icons/pickups/default"
weapon_template.swap_pickup_name = "grimoire"
weapon_template.footstep_intervals = {
	crouch_walking = 0.61,
	walking = 0.4,
	sprinting = 0.37
}

weapon_template.action_none_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not current_action_name or current_action_name == "none"
end

weapon_template.action_discard_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_throw"
end

return weapon_template
