-- chunkname: @scripts/settings/ability/ability_templates/cryptic_discharge_base.lua

local ability_template = {}

ability_template.action_inputs = {
	ability_pressed = {
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
		input = "ability_pressed",
		transition = "stay"
	}
}
ability_template.actions = {
	action_activate = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim = "ability_shout",
		base_ability = true,
		block_weapon_actions = false,
		consume_ability_usage_cost = true,
		consume_usage_cost_at_start = true,
		has_husk_sound = true,
		kind = "cryptic_discharge",
		prevent_sprint = true,
		sprint_ready_up_time = 0,
		start_input = "ability_pressed",
		total_time = 1,
		uninterruptible = true,
		vo_tag = "cryptic_ability_01_a"
	}
}
ability_template.fx_sources = {}
ability_template.ability_meta_data = {
	activation = {
		action_input = "ability_pressed"
	}
}

return ability_template
