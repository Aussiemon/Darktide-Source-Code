-- chunkname: @scripts/settings/ability/ability_templates/adamant_stance.lua

local ability_template = {}

ability_template.action_inputs = {
	stance_pressed = {
		buffer_time = 0.5,
		input_sequence = {
			{
				input_alias = "wielded_input_pressed",
				value = true
			}
		}
	}
}
ability_template.action_input_hierarchy = {
	{
		input = "stance_pressed",
		transition = "stay"
	}
}
ability_template.actions = {
	action_stance_change = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim = "ability_cloak",
		anim_3p = "ability_cloak",
		block_weapon_actions = false,
		consume_ability_usage_cost = true,
		consume_usage_cost_at_start = true,
		kind = "stance_change",
		prevent_sprint = true,
		refill_toughness = true,
		sprint_ready_up_time = 0,
		start_input = "stance_pressed",
		total_time = 1,
		uninterruptible = true,
		vo_tag = "ability_stance_a"
	}
}
ability_template.fx_sources = {}
ability_template.ability_meta_data = {
	activation = {
		action_input = "stance_pressed"
	}
}

return ability_template
