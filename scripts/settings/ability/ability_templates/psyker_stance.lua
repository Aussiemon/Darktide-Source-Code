-- chunkname: @scripts/settings/ability/ability_templates/psyker_stance.lua

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
		allowed_during_sprint = true,
		kind = "stance_change",
		sprint_ready_up_time = 0,
		start_input = "stance_pressed",
		total_time = 0.1,
		uninterruptible = true,
		use_ability_charge = true,
		vo_tag = "ability_buff_stance",
	},
}
ability_template.fx_sources = {}

return ability_template
