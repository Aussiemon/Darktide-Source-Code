local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local wield_inputs = PlayerCharacterConstants.wield_inputs
local forcesword_p1_m1_melee_action_input_setup = {
	action_inputs = {
		start_attack = {
			buffer_time = 0.75,
			max_queue = 1,
			input_sequence = {
				{
					value = true,
					input = "action_one_pressed"
				}
			}
		},
		attack_cancel = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = true,
					hold_input = "action_one_hold",
					input = "action_two_pressed"
				}
			}
		},
		light_attack = {
			buffer_time = 0.3,
			max_queue = 1,
			input_sequence = {
				{
					value = false,
					time_window = 0.25,
					input = "action_one_hold"
				}
			}
		},
		heavy_attack = {
			buffer_time = 0.5,
			max_queue = 1,
			input_sequence = {
				{
					value = true,
					duration = 0.25,
					input = "action_one_hold"
				},
				{
					value = false,
					time_window = 1.5,
					auto_complete = true,
					input = "action_one_hold"
				}
			}
		},
		block = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					value = true,
					input = "action_two_hold"
				}
			}
		},
		block_release = {
			buffer_time = 0.6,
			max_queue = 1,
			input_sequence = {
				{
					value = false,
					input = "action_two_hold",
					time_window = math.huge
				}
			}
		},
		push = {
			buffer_time = 0.2,
			input_sequence = {
				{
					value = true,
					hold_input = "action_two_hold",
					input = "action_one_pressed"
				}
			}
		},
		push_follow_up = {
			buffer_time = 0.3,
			input_sequence = {
				{
					value = true,
					duration = 0.25,
					hold_input = "action_two_hold",
					input = "action_one_hold"
				}
			}
		},
		push_follow_up_release = {
			dont_queue = true,
			buffer_time = 0,
			input_sequence = {
				{
					input_mode = "all",
					inputs = {
						{
							value = false,
							input = "action_one_hold"
						},
						{
							value = false,
							input = "action_two_hold"
						}
					},
					time_window = math.huge
				}
			}
		},
		push_follow_up_early_release = {
			dont_queue = true,
			buffer_time = 0,
			input_sequence = {
				{
					value = false,
					input = "action_one_hold",
					time_window = math.huge
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
		special_action = {
			buffer_time = 0.2,
			input_sequence = {
				{
					value = true,
					input = "weapon_extra_pressed"
				}
			}
		},
		special_action_hold = {
			buffer_time = 0.2,
			input_sequence = {
				{
					value = true,
					hold_input = "weapon_extra_hold",
					input = "weapon_extra_hold"
				}
			}
		},
		special_action_release = {
			buffer_time = 0.2,
			input_sequence = {
				{
					value = true,
					hold_input = "weapon_extra_release",
					input = "weapon_extra_release"
				}
			}
		},
		find_target = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = true,
					input = "action_one_hold"
				}
			}
		},
		find_target_release = {
			buffer_time = 0.3,
			input_sequence = {
				{
					value = false,
					input = "action_one_hold",
					time_window = math.huge
				}
			}
		},
		fling_target = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = true,
					input = "action_one_release"
				}
			}
		}
	}
}

table.add_missing(forcesword_p1_m1_melee_action_input_setup.action_inputs, BaseTemplateSettings.action_inputs)

forcesword_p1_m1_melee_action_input_setup.action_input_hierarchy = {
	special_action = "base",
	wield = "base",
	start_attack = {
		attack_cancel = "base",
		wield = "base",
		heavy_attack = "base",
		grenade_ability = "base",
		special_action = "base",
		light_attack = "base"
	},
	block = {
		block_release = "base",
		wield = "base",
		grenade_ability = "base",
		special_action = "base",
		combat_ability = "base",
		push = {
			push_follow_up_early_release = "base",
			push_follow_up = {
				special_action = "base",
				wield = "base",
				push_follow_up_release = "base",
				fling_target = "base",
				grenade_ability = "base",
				find_target_release = "base",
				combat_ability = "base"
			}
		}
	}
}

table.add_missing(forcesword_p1_m1_melee_action_input_setup.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

return forcesword_p1_m1_melee_action_input_setup
