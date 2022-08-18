local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local wield_inputs = PlayerCharacterConstants.wield_inputs
local base_template_settings = {
	action_inputs = {
		combat_ability = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					value = true,
					input = "combat_ability_pressed"
				}
			}
		},
		grenade_ability = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					value = true,
					input = "grenade_ability_pressed"
				}
			}
		},
		inspect = {
			dont_queue = true,
			input_sequence = {
				{
					value = true,
					input = "weapon_inspect_hold"
				}
			}
		},
		inspect_start = {
			buffer_time = 0,
			input_sequence = {
				{
					value = true,
					duration = 0.2,
					input = "weapon_inspect_hold"
				}
			}
		},
		inspect_stop = {
			buffer_time = 0.02,
			input_sequence = {
				{
					value = false,
					input = "weapon_inspect_hold",
					time_window = math.huge
				}
			}
		},
		wield = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					inputs = wield_inputs
				}
			}
		}
	},
	actions = {
		combat_ability = {
			slot_to_wield = "slot_combat_ability",
			start_input = "combat_ability",
			uninterruptible = true,
			kind = "unwield_to_specific",
			sprint_ready_up_time = 0,
			total_time = 0,
			allowed_chain_actions = {}
		},
		grenade_ability = {
			continue_sprinting = true,
			slot_to_wield = "slot_grenade_ability",
			start_input = "grenade_ability",
			uninterruptible = true,
			kind = "unwield_to_specific",
			allowed_during_sprint = true,
			total_time = 0,
			allowed_chain_actions = {}
		}
	},
	action_input_hierarchy = {
		grenade_ability = "stay",
		combat_ability = "stay",
		inspect = {
			wield = "base",
			inspect_start = {
				inspect_stop = "base"
			}
		}
	}
}

return base_template_settings
