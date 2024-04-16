local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
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
			allowed_during_sprint = true,
			anim_event = "unequip",
			start_input = "wield",
			uninterruptible = true,
			kind = "unwield",
			total_time = 0,
			allowed_chain_actions = {}
		},
		action_wield = {
			uninterruptible = true,
			anim_event = "deploy",
			allowed_during_sprint = true,
			kind = "wield",
			total_time = 0.1
		}
	},
	ammo_template = "no_ammo",
	keywords = {
		"devices"
	},
	breed_anim_state_machine_3p = {
		human = "content/characters/player/human/third_person/animations/pocketables",
		ogryn = "content/characters/player/ogryn/third_person/animations/pocketables"
	},
	breed_anim_state_machine_1p = {
		human = "content/characters/player/human/first_person/animations/breach_charge",
		ogryn = "content/characters/player/ogryn/first_person/animations/breach_charge"
	},
	smart_targeting_template = SmartTargetingTemplates.default_melee,
	fx_sources = {
		_source = "fx_source"
	},
	dodge_template = "default",
	sprint_template = "default",
	stamina_template = "default",
	toughness_template = "default",
	hud_icon = "content/ui/materials/icons/pickups/default",
	hide_slot = true,
	not_player_wieldable = true
}

return weapon_template
