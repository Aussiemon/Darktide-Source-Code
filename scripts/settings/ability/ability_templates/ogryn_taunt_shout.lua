-- chunkname: @scripts/settings/ability/ability_templates/ogryn_taunt_shout.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local RADIUS = 8
local ability_template = {}

ability_template.action_inputs = {
	shout_pressed = {
		buffer_time = 0.2,
		input_sequence = {
			{
				value = true,
				input = "combat_ability_pressed"
			}
		}
	},
	shout_released = {
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
	shout_pressed = {
		shout_released = "base",
		block_cancel = "base"
	}
}
ability_template.actions = {
	action_aim = {
		start_input = "shout_pressed",
		kind = "shout_aim",
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
			shout_released = {
				action_name = "action_shout"
			}
		}
	},
	action_shout = {
		buff_to_add = "taunted",
		force_stagger_duration = 1,
		target_enemies = true,
		kind = "ogryn_shout",
		sprint_ready_up_time = 0,
		anim = "ability_shout",
		uninterruptible = true,
		has_husk_sound = true,
		allowed_during_sprint = true,
		ability_type = "combat_ability",
		special_rule_buff_enemy = "ogryn_taunt_increased_damage_taken_buff",
		recover_toughness_effect = "content/fx/particles/abilities/squad_leader_ability_toughness_buff",
		toughness_replenish_percent = 1,
		use_charge_at_start = true,
		vo_tag = "ability_bullgryn",
		use_ability_charge = true,
		force_stagger_type = "light",
		power_level = 500,
		total_time = 0.75,
		radius = RADIUS,
		damage_profile = DamageProfileTemplates.shout_stagger_ogryn_taunt,
		buff_ignored_breeds = {
			chaos_daemonhost = true
		}
	}
}
ability_template.fx_sources = {}
ability_template.equipped_ability_effect_scripts = {
	"ShoutEffects"
}
ability_template.vfx = {
	delay = 0.2,
	name = "content/fx/particles/abilities/ogryn_ability_shout_activate"
}

return ability_template
