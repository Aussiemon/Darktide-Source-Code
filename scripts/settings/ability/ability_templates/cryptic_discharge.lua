-- chunkname: @scripts/settings/ability/ability_templates/cryptic_discharge.lua

local ability_template = {}

ability_template.action_inputs = {
	ability_pressed = {
		buffer_time = 0.5,
		input_sequence = {
			{
				input = "combat_ability_pressed",
				value = true,
			},
		},
	},
}
ability_template.action_input_hierarchy = {
	{
		input = "ability_pressed",
		transition = "stay",
	},
}
ability_template.actions = {
	action_activate = {
		ability_type = "combat_ability",
		abort_sprint = true,
		allowed_during_sprint = true,
		anim = "ability_shout",
		block_weapon_actions = false,
		has_husk_sound = true,
		kind = "cryptic_discharge",
		prevent_sprint = true,
		sprint_ready_up_time = 0,
		start_input = "ability_pressed",
		total_time = 1,
		uninterruptible = true,
		use_ability_charge = true,
		use_charge_at_start = true,
		vo_tag = "cryptic_ability_01_a",
	},
}
ability_template.fx_sources = {}
ability_template.ability_meta_data = {
	activation = {
		action_input = "ability_pressed",
	},
}

return ability_template
