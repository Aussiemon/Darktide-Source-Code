local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local talent_settings = TalentSettings.veteran_3
local RADIUS = talent_settings.combat_ability.radius
local ability_template = {
	action_inputs = {
		combat_ability_pressed = {
			buffer_time = 0.2,
			input_sequence = {
				{
					value = true,
					input = "combat_ability_pressed"
				}
			}
		},
		combat_ability_released = {
			buffer_time = 0.1,
			input_sequence = {
				{
					value = false,
					input = "combat_ability_hold",
					time_window = math.huge
				}
			}
		},
		block_cancel = {
			buffer_time = 0,
			input_sequence = {
				{
					value = true,
					hold_input = "combat_ability_hold",
					input = "action_two_pressed"
				}
			}
		}
	},
	action_input_hierarchy = {
		combat_ability_pressed = {
			block_cancel = "base",
			combat_ability_released = "base"
		}
	},
	actions = {
		action_aim = {
			start_input = "combat_ability_pressed",
			kind = "veteran_shout_aim",
			sprint_ready_up_time = 0,
			shout_ready_up_time = 0,
			allowed_during_lunge = true,
			allowed_during_sprint = true,
			ability_type = "combat_ability",
			stop_input = "block_cancel",
			minimum_hold_time = 0.075,
			total_time = math.huge,
			radius = RADIUS,
			allowed_chain_actions = {
				combat_ability_released = {
					action_name = "action_veteran_combat_ability"
				}
			}
		},
		action_immediate_use = {
			total_time = 0,
			start_input = "combat_ability_pressed",
			kind = "veteran_immediate_use",
			allowed_during_lunge = true,
			allowed_during_sprint = true,
			ability_type = "combat_ability",
			minimum_hold_time = 0,
			conditional_state_to_action_input = {
				auto_chain = {
					input_name = "combat_ability_released"
				}
			},
			allowed_chain_actions = {
				combat_ability_released = {
					action_name = "action_veteran_combat_ability"
				}
			}
		},
		action_veteran_combat_ability = {
			use_ability_charge = true,
			use_charge_at_start = true,
			allowed_during_sprint = true,
			kind = "veteran_combat_ability",
			uninterruptible = true,
			ability_type = "combat_ability",
			has_husk_sound = true,
			total_time = 1,
			shout_settings = {
				target_enemies = true,
				revive_allies = true,
				force_stagger_type_if_not_staggered_duration = 2.5,
				force_stagger_type_if_not_staggered = "heavy",
				target_allies = true,
				radius = RADIUS,
				damage_profile = DamageProfileTemplates.shout_stagger_veteran,
				power_level = talent_settings.combat_ability.power_level,
				cone_dot = talent_settings.combat_ability.cone_dot,
				cone_range = talent_settings.combat_ability.cone_range
			},
			vo_tags = {
				shock_trooper = "ability_shock_trooper",
				squad_leader = "ability_squad_leader",
				ranger = "ability_ranger",
				base = "ability_ranger"
			}
		}
	},
	fx_sources = {},
	equipped_ability_effect_scripts = {
		"ShoutEffects",
		"StealthEffects"
	},
	vfx = {
		delay = 0.2,
		name = "content/fx/particles/abilities/squad_leader_ability_shout_activate"
	},
	ability_meta_data = {
		activation = {
			action_input = "stance_pressed"
		}
	}
}

return ability_template
