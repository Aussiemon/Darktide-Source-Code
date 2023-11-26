-- chunkname: @scripts/settings/ability/ability_templates/ogryn_gunlugger_stance.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
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
		reload_secondary = true,
		refill_toughness = false,
		start_input = "stance_pressed",
		target_enemies = true,
		kind = "stance_change",
		sprint_ready_up_time = 0,
		auto_wield_slot = "slot_secondary",
		allowed_during_sprint = true,
		stop_current_action = true,
		uninterruptible = true,
		vo_tag = "ability_gun_lugger",
		use_ability_charge = true,
		ability_type = "combat_ability",
		total_time = 0
	}
}
ability_template.fx_sources = {}
ability_template.ability_meta_data = {
	activation = {
		action_input = "stance_pressed"
	}
}

return ability_template
