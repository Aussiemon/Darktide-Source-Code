-- chunkname: @scripts/settings/ability/ability_templates/zealot_invisibility.lua

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
		anim = "ability_cloak",
		kind = "stance_change",
		sprint_ready_up_time = 0,
		start_input = "stance_pressed",
		total_time = 0.1,
		uninterruptible = true,
		use_ability_charge = true,
		vo_tag = "ability_pious_stabber",
	},
}
ability_template.equipped_ability_effect_scripts = {
	"StealthEffects",
}
ability_template.fx_sources = {}

return ability_template
