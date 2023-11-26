-- chunkname: @scripts/settings/ability/ability_templates/zealot_invisibility.lua

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
		use_ability_charge = true,
		uninterruptible = true,
		start_input = "stance_pressed",
		kind = "stance_change",
		sprint_ready_up_time = 0,
		vo_tag = "ability_pious_stabber",
		allowed_during_sprint = true,
		ability_type = "combat_ability",
		anim = "ability_cloak",
		total_time = 0.1
	}
}
ability_template.equipped_ability_effect_scripts = {
	"StealthEffects"
}
ability_template.fx_sources = {}

return ability_template
