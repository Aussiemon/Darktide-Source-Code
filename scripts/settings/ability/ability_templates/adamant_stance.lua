-- chunkname: @scripts/settings/ability/ability_templates/adamant_stance.lua

local ability_template = {}

ability_template.action_inputs = {
	stance_pressed = {
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
		input = "stance_pressed",
		transition = "stay",
	},
}
ability_template.actions = {
	action_stance_change = {
		ability_type = "combat_ability",
		abort_sprint = true,
		allowed_during_sprint = true,
		anim = "ability_cloak",
		anim_3p = "ability_cloak",
		block_weapon_actions = false,
		kind = "stance_change",
		prevent_sprint = true,
		refill_toughness = true,
		sprint_ready_up_time = 0,
		start_input = "stance_pressed",
		total_time = 1,
		uninterruptible = true,
		use_ability_charge = true,
		use_charge_at_start = true,
		vo_tag = "ability_stance_a",
	},
}
ability_template.fx_sources = {}
ability_template.ability_meta_data = {
	activation = {
		action_input = "stance_pressed",
	},
}

return ability_template
