-- chunkname: @scripts/settings/ability/ability_templates/ogryn_taunt_shout.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local RADIUS = 8
local ability_template = {}

ability_template.action_inputs = {
	shout_pressed = {
		buffer_time = 0.2,
		input_sequence = {
			{
				input = "combat_ability_pressed",
				value = true,
			},
		},
	},
	shout_released = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "combat_ability_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	block_cancel = {
		buffer_time = 0,
		input_sequence = {
			{
				hold_input = "combat_ability_hold",
				input = "action_two_pressed",
				value = true,
			},
		},
	},
}
ability_template.action_input_hierarchy = {
	{
		input = "shout_pressed",
		transition = {
			{
				input = "shout_released",
				transition = "base",
			},
			{
				input = "block_cancel",
				transition = "base",
			},
		},
	},
}
ability_template.actions = {
	action_aim = {
		ability_type = "combat_ability",
		allowed_during_lunge = true,
		allowed_during_sprint = true,
		kind = "shout_aim",
		minimum_hold_time = 0.075,
		shout_ready_up_time = 0,
		sprint_ready_up_time = 0,
		start_input = "shout_pressed",
		stop_input = "block_cancel",
		total_time = math.huge,
		radius = RADIUS,
		allowed_chain_actions = {
			shout_released = {
				action_name = "action_shout",
			},
		},
	},
	action_shout = {
		ability_type = "combat_ability",
		allowed_during_sprint = true,
		anim = "ability_shout",
		buff_to_add = "taunted",
		force_stagger_duration = 1,
		force_stagger_type = "light",
		has_husk_sound = true,
		kind = "ogryn_shout",
		power_level = 500,
		recover_toughness_effect = "content/fx/particles/abilities/squad_leader_ability_toughness_buff",
		special_rule_buff_enemy = "ogryn_taunt_increased_damage_taken_buff",
		sprint_ready_up_time = 0,
		target_enemies = true,
		total_time = 0.75,
		toughness_replenish_percent = 1,
		uninterruptible = true,
		use_ability_charge = true,
		use_charge_at_start = true,
		vo_tag = "ability_bullgryn",
		radius = RADIUS,
		damage_profile = DamageProfileTemplates.shout_stagger_ogryn_taunt,
		buff_ignored_breeds = {
			chaos_daemonhost = true,
		},
	},
}
ability_template.fx_sources = {}
ability_template.equipped_ability_effect_scripts = {
	"ShoutEffects",
}
ability_template.vfx = {
	delay = 0.2,
	name = "content/fx/particles/abilities/ogryn_ability_shout_activate",
}

return ability_template
