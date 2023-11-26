-- chunkname: @scripts/settings/ability/ability_templates/psyker_stance.lua

local ability_template = {}

ability_template.action_inputs = {
	stance_pressed = {
		buffer_time = 0.5,
		input_sequence = {
			{
				value = true,
				input = "combat_ability_pressed"
			}
		}
	}
}
ability_template.action_input_hierarchy = {
	stance_pressed = "stay"
}
ability_template.actions = {
	action_stance_change = {
		allowed_during_sprint = true,
		use_ability_charge = true,
		start_input = "stance_pressed",
		kind = "stance_change",
		sprint_ready_up_time = 0,
		vo_tag = "ability_buff_stance",
		uninterruptible = true,
		ability_type = "combat_ability",
		total_time = 0.1
	}
}
ability_template.fx_sources = {}

return ability_template
