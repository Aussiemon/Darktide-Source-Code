local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local default_melee_action_input_setup = {
	action_inputs = {
		start_attack = {
			buffer_time = 0.3,
			max_queue = 1,
			reevaluation_time = 0.18,
			input_sequence = {
				{
					value = true,
					input = "action_one_hold"
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
					time_window = 0.2,
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
		attack_release = {
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
		block = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = true,
					input = "action_two_hold"
				}
			}
		},
		block_release = {
			buffer_time = 0.35,
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
		}
	}
}

table.add_missing(default_melee_action_input_setup.action_inputs, BaseTemplateSettings.action_inputs)

default_melee_action_input_setup.action_input_hierarchy = {
	special_action = "base",
	wield = "stay",
	grenade_ability = "base",
	combat_ability = "base",
	start_attack = {
		attack_cancel = "base",
		wield = "base",
		heavy_attack = "base",
		grenade_ability = "base",
		block = "base",
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
			special_action = "base",
			push_follow_up_early_release = "base",
			push_follow_up = {
				special_action = "base",
				grenade_ability = "base",
				push_follow_up_release = "base",
				wield = "base",
				block = "base",
				combat_ability = "base"
			}
		}
	}
}

table.add_missing(default_melee_action_input_setup.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

return default_melee_action_input_setup
