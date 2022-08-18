local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {
	action_inputs = {
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
	action_input_hierarchy = {
		wield = "stay"
	},
	actions = {
		action_unwield = {
			continue_sprinting = true,
			allowed_during_sprint = true,
			start_input = "wield",
			uninterruptible = true,
			kind = "unwield",
			anim_event = "unequip",
			total_time = 0,
			allowed_chain_actions = {}
		},
		action_wield = {
			uninterruptible = true,
			anim_event = "scan_start",
			allowed_during_sprint = true,
			kind = "wield",
			total_time = 0.1
		}
	},
	keywords = {
		"devices"
	},
	breed_anim_state_machine_3p = {
		human = "content/characters/player/human/third_person/animations/unarmed",
		ogryn = "content/characters/player/ogryn/third_person/animations/unarmed"
	},
	breed_anim_state_machine_1p = {
		human = "content/characters/player/human/first_person/animations/scanner",
		ogryn = "content/characters/player/ogryn/first_person/animations/scanner"
	},
	ammo_template = "no_ammo",
	fx_sources = {
		_speaker = "fx_speaker"
	},
	dodge_template = "default",
	sprint_template = "default",
	stamina_template = "default",
	toughness_template = "auspex",
	look_delta_template = "auspex_scanner",
	hud_icon = "content/ui/materials/icons/pickups/default",
	require_minigame = true,
	not_player_wieldable = true
}

return weapon_template
