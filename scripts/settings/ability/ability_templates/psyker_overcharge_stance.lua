-- chunkname: @scripts/settings/ability/ability_templates/psyker_overcharge_stance.lua

local TalentSettings = require("scripts/settings/talent/talent_settings")
local talent_settings = TalentSettings.psyker
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
		allowed_during_explode = true,
		allowed_during_sprint = true,
		anim = "ability_overcharge",
		anim_3p = "ability_buff",
		block_weapon_actions = false,
		consume_ability_usage_cost = true,
		consume_usage_cost_at_start = true,
		kind = "stance_change",
		refill_toughness = false,
		sprint_ready_up_time = 0,
		start_input = "stance_pressed",
		total_time = 1,
		uninterruptible = true,
		vent_warp_charge_special_rule = "psyker_overcharge_stance_quell_peril",
		vo_tag = "ability_buff_stance",
		vent_warp_charge = talent_settings.overcharge_stance.venting
	}
}
ability_template.fx_sources = {}
ability_template.ability_meta_data = {
	activation = {
		action_input = "stance_pressed"
	}
}

return ability_template
