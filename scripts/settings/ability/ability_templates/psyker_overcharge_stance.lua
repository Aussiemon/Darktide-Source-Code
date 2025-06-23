-- chunkname: @scripts/settings/ability/ability_templates/psyker_overcharge_stance.lua

local TalentSettings = require("scripts/settings/talent/talent_settings")
local talent_settings = TalentSettings.overcharge_stance
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
	{
		transition = "stay",
		input = "stance_pressed"
	}
}
ability_template.actions = {
	action_stance_change = {
		anim_3p = "ability_buff",
		anim = "ability_overcharge",
		start_input = "stance_pressed",
		allowed_during_explode = true,
		kind = "stance_change",
		sprint_ready_up_time = 0,
		refill_toughness = false,
		uninterruptible = true,
		allowed_during_sprint = true,
		ability_type = "combat_ability",
		block_weapon_actions = false,
		use_charge_at_start = true,
		vo_tag = "ability_buff_stance",
		abort_sprint = true,
		use_ability_charge = true,
		prevent_sprint = true,
		total_time = 1,
		vent_warp_charge = talent_settings.venting
	}
}
ability_template.fx_sources = {}
ability_template.ability_meta_data = {
	activation = {
		action_input = "stance_pressed"
	}
}

return ability_template
