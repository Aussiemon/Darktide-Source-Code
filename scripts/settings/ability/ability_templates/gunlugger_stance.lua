local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local ability_template = {
	action_inputs = {
		stance_pressed = {
			buffer_time = 0.5,
			input_sequence = {
				{
					value = true,
					input = "combat_ability_pressed"
				}
			}
		}
	},
	action_input_hierarchy = {
		stance_pressed = "stay"
	},
	actions = {
		action_stance_change = {
			max_radius = 8.75,
			radius = 5,
			start_input = "stance_pressed",
			min_radius = 5,
			kind = "shout",
			sprint_ready_up_time = 0.5,
			attack_type = "shout",
			shout_dot = 0.45,
			stop_reload = true,
			refill_toughness = true,
			anim = "reload_end",
			allowed_during_sprint = true,
			ability_type = "combat_ability",
			block_weapon_actions = false,
			target_enemies = true,
			auto_wield_slot = "slot_secondary",
			uninterruptible = true,
			override_min_radius = 5,
			use_charge_at_start = true,
			vo_tag = "ability_gun_lugger",
			override_max_radius = 12.5,
			shout_shape = "cone",
			override_radius = 5,
			use_ability_charge = true,
			power_level = 500,
			total_time = 0.75,
			damage_profile = DamageProfileTemplates.shout_stagger
		}
	},
	fx_sources = {},
	ability_meta_data = {
		activation = {
			action_input = "stance_pressed"
		}
	}
}

return ability_template
