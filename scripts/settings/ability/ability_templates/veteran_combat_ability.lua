-- chunkname: @scripts/settings/ability/ability_templates/veteran_combat_ability.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local talent_settings = TalentSettings.veteran_3
local RADIUS = talent_settings.combat_ability.radius
local ability_template = {}

ability_template.action_inputs = {
	combat_ability_pressed = {
		buffer_time = 0.2,
		input_sequence = {
			{
				input = "combat_ability_pressed",
				value = true,
			},
		},
	},
	combat_ability_released = {
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
	combat_ability_pressed = {
		block_cancel = "base",
		combat_ability_released = "base",
	},
}
ability_template.actions = {
	action_aim = {
		ability_type = "combat_ability",
		allowed_during_lunge = true,
		allowed_during_sprint = true,
		kind = "veteran_shout_aim",
		minimum_hold_time = 0.075,
		shout_ready_up_time = 0,
		sprint_ready_up_time = 0,
		start_input = "combat_ability_pressed",
		stop_input = "block_cancel",
		total_time = math.huge,
		radius = RADIUS,
		allowed_chain_actions = {
			combat_ability_released = {
				action_name = "action_veteran_combat_ability",
			},
		},
	},
	action_immediate_use = {
		ability_type = "combat_ability",
		allowed_during_lunge = true,
		allowed_during_sprint = true,
		kind = "veteran_immediate_use",
		minimum_hold_time = 0,
		start_input = "combat_ability_pressed",
		total_time = 0,
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "combat_ability_released",
			},
		},
		allowed_chain_actions = {
			combat_ability_released = {
				action_name = "action_veteran_combat_ability",
			},
		},
	},
	action_veteran_combat_ability = {
		ability_type = "combat_ability",
		abort_sprint = true,
		allowed_during_sprint = true,
		has_husk_sound = true,
		kind = "veteran_combat_ability",
		prevent_sprint = true,
		sprint_ready_up_time = 0,
		total_time = 1,
		uninterruptible = true,
		use_ability_charge = true,
		use_charge_at_start = true,
		shout_settings = {
			force_stagger_type_if_not_staggered = "heavy",
			force_stagger_type_if_not_staggered_duration = 2.5,
			revive_allies = true,
			target_allies = true,
			target_enemies = true,
			radius = RADIUS,
			damage_profile = DamageProfileTemplates.shout_stagger_veteran,
			power_level = talent_settings.combat_ability.power_level,
			cone_dot = talent_settings.combat_ability.cone_dot,
			cone_range = talent_settings.combat_ability.cone_range,
		},
		vo_tags = {
			base = "ability_ranger",
			ranger = "ability_ranger",
			shock_trooper = "ability_shock_trooper",
			squad_leader = "ability_squad_leader",
		},
	},
}
ability_template.fx_sources = {}
ability_template.equipped_ability_effect_scripts = {
	"ShoutEffects",
	"StealthEffects",
}
ability_template.vfx = {
	delay = 0.2,
	name = "content/fx/particles/abilities/squad_leader_ability_shout_activate",
}
ability_template.ability_meta_data = {
	activation = {
		action_input = "stance_pressed",
	},
}

return ability_template
