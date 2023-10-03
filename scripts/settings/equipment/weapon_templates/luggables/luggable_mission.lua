local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {
	action_inputs = {
		push = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					value = true,
					input = "action_two_pressed"
				}
			}
		},
		aim_luggable = {
			buffer_time = 0,
			input_sequence = {
				{
					value = true,
					input = "action_one_hold"
				}
			}
		},
		aim_cancel_push = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = true,
					hold_input = "action_one_hold",
					input = "action_two_pressed"
				}
			}
		},
		aim_cancel_push_release = {
			dont_queue = true,
			buffer_time = 0,
			input_sequence = {
				{
					input_mode = "all",
					inputs = {
						{
							value = false,
							input = "action_two_hold"
						}
					},
					time_window = math.huge
				}
			}
		},
		throw = {
			buffer_time = 0,
			clear_input_queue = true,
			max_queue = 2,
			input_sequence = {
				{
					value = false,
					input = "action_one_hold"
				}
			}
		},
		drop = {
			buffer_time = 0.2,
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
	drop = "stay",
	wield = "base",
	push = "stay",
	aim_luggable = {
		drop = "base",
		throw = "stay",
		aim_cancel_push = {
			aim_cancel_push_release = "base",
			drop = "base"
		}
	},
	inspect_start = {
		inspect_stop = "base"
	}
}

table.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
	action_wield = {
		kind = "wield",
		allowed_during_sprint = true,
		uninterruptible = true,
		anim_event = "equip",
		total_time = 0
	},
	action_drop = {
		sprint_requires_press_to_interrupt = true,
		allowed_during_sprint = false,
		start_input = "drop",
		uninterruptible = true,
		kind = "throw_luggable",
		throw_type = "drop",
		total_time = 0
	},
	action_throw = {
		kind = "throw_luggable",
		sprint_requires_press_to_interrupt = true,
		start_input = "throw",
		uninterruptible = true,
		anim_event = "throw",
		throw_type = "throw",
		allowed_during_sprint = false,
		total_time = 0.5
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
		allowed_chain_actions = {
			drop = {
				action_name = "action_drop",
				chain_time = 0.53
			}
		},
		inner_push_rad = math.pi * 0.25,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.default_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.physical
	},
	action_aim_luggable = {
		allowed_during_sprint = false,
		start_input = "aim_luggable",
		uninterruptible = false,
		kind = "aim_projectile",
		throw_type = "throw",
		total_time = math.huge,
		allowed_chain_actions = {
			drop = {
				action_name = "action_drop"
			},
			throw = {
				action_name = "action_throw"
			},
			aim_cancel_push = {
				action_name = "action_push"
			}
		}
	},
	action_inspect = {
		skip_3p_anims = false,
		lock_view = true,
		start_input = "inspect_start",
		anim_end_event = "inspect_end",
		kind = "inspect",
		crosshair_type = "inspect",
		anim_event = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge
	}
}
weapon_template.keywords = {
	"luggable"
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/lugging",
	ogryn = "content/characters/player/ogryn/third_person/animations/lugging"
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/lugging_mission",
	ogryn = "content/characters/player/ogryn/first_person/animations/lugging_mission"
}
weapon_template.ammo_template = "no_ammo"
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.breed_footstep_intervals = {
	human = {
		crouch_walking = 0.61,
		walking = 0.4,
		sprinting = 0.37
	},
	ogryn = {
		crouch_walking = 0.61,
		walking = 0.1,
		sprinting = 0.37
	}
}

return weapon_template
