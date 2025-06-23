-- chunkname: @scripts/settings/ability/ability_templates/veteran_stealth_combat_ability.lua

local TalentSettings = require("scripts/settings/talent/talent_settings")
local talent_settings = TalentSettings.veteran_3
local RADIUS = talent_settings.combat_ability.radius
local ability_template = {}

ability_template.action_inputs = {
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
}
ability_template.action_input_hierarchy = {
	{
		input = "combat_ability_pressed",
		transition = {
			{
				transition = "base",
				input = "combat_ability_released"
			},
			{
				transition = "base",
				input = "block_cancel"
			}
		}
	}
}
ability_template.actions = {
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
		shout_target_template = "veteran_shout",
		use_charge_at_start = true,
		uninterruptible = true,
		kind = "veteran_combat_ability",
		use_ability_charge = true,
		abort_sprint = false,
		allowed_during_sprint = true,
		ability_type = "combat_ability",
		has_husk_sound = true,
		prevent_sprint = false,
		total_time = 1,
		radius = RADIUS,
		vo_tags = {
			shock_trooper = "ability_shock_trooper",
			squad_leader = "ability_squad_leader",
			ranger = "ability_ranger",
			base = "ability_ranger"
		}
	}
}
ability_template.fx_sources = {}
ability_template.equipped_ability_effect_scripts = {
	"ShoutEffects",
	"StealthEffects"
}
ability_template.vfx = {
	delay = 0.2,
	name = "content/fx/particles/abilities/squad_leader_ability_shout_activate"
}
ability_template.ability_meta_data = {
	activation = {
		action_input = "stance_pressed"
	}
}

return ability_template
