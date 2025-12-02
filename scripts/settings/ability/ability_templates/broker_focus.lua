-- chunkname: @scripts/settings/ability/ability_templates/broker_focus.lua

local Ammo = require("scripts/utilities/ammo")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local talent_settings = TalentSettings.broker
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
		abort_sprint = false,
		allowed_during_sprint = true,
		anim_3p = "ability_buff",
		auto_wield_slot = "slot_secondary",
		block_weapon_actions = false,
		kind = "stance_change",
		prevent_sprint = false,
		refill_toughness = true,
		sprint_ready_up_time = 0,
		start_input = "stance_pressed",
		stop_current_action = true,
		total_time = 1,
		uninterruptible = true,
		use_ability_charge = true,
		use_charge_at_start = true,
		vo_tag = "ability_focus",
		anim = function (player_unit)
			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
			local inventory_component = unit_data_extension:read_component("inventory")
			local wielded_slot = inventory_component.wielded_slot

			return Ammo.uses_ammo(player_unit, wielded_slot) and "reload_end" or nil
		end,
	},
}
ability_template.fx_sources = {}
ability_template.ability_meta_data = {
	activation = {
		action_input = "stance_pressed",
	},
}

return ability_template
