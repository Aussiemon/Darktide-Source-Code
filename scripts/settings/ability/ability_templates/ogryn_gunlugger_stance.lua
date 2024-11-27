-- chunkname: @scripts/settings/ability/ability_templates/ogryn_gunlugger_stance.lua

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
		anim = "mid_reload_finished",
		anim_3p = "ability_shout",
		auto_wield_slot = "slot_secondary",
		kind = "stance_change",
		refill_toughness = false,
		reload_secondary = true,
		sprint_ready_up_time = 0,
		start_input = "stance_pressed",
		stop_current_action = true,
		target_enemies = true,
		total_time = 0,
		uninterruptible = true,
		use_ability_charge = true,
		vo_tag = "ability_gun_lugger",
	},
}
ability_template.fx_sources = {}
ability_template.ability_meta_data = {
	activation = {
		action_input = "stance_pressed",
	},
}

return ability_template
