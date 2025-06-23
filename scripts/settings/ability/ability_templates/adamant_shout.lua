-- chunkname: @scripts/settings/ability/ability_templates/adamant_shout.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local RADIUS = 8
local talent_settings = TalentSettings.adamant
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
	{
		input = "shout_pressed",
		transition = {
			{
				transition = "base",
				input = "shout_released"
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
		shout_target_template = "adamant_shout",
		sprint_ready_up_time = 0,
		toughness_replenish_percent = 1,
		kind = "adamant_shout",
		shout_dot = 0.75,
		refill_toughness = true,
		uninterruptible = true,
		has_husk_sound = true,
		recover_toughness_effect = "content/fx/particles/abilities/squad_leader_ability_toughness_buff",
		power_level = 500,
		allowed_during_sprint = true,
		ability_type = "combat_ability",
		anim = "ability_shout",
		use_charge_at_start = true,
		vo_tag = "ability_howl_a",
		use_ability_charge = true,
		shape = "cone",
		total_time = 0.75,
		radius = talent_settings.combat_ability.shout.range,
		far_radius = talent_settings.combat_ability.shout.far_range,
		damage_profile = DamageProfileTemplates.adamant_shout
	}
}
ability_template.fx_sources = {}
ability_template.equipped_ability_effect_scripts = {
	"ShoutEffects"
}
ability_template.vfx = {
	delay = 0.2,
	name = "content/fx/particles/abilities/adamant/adamant_shout"
}

return ability_template
