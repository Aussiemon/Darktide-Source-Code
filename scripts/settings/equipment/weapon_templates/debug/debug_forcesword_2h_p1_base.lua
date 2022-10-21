local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
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
	}
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	grenade_ability = "base",
	wield = "stay",
	combat_ability = "base"
}
local chain_sword_sweep_box = {
	0.05,
	0.05,
	1.1
}
weapon_template.actions = {
	action_unwield = {
		start_input = "wield",
		uninterruptible = true,
		kind = "unwield",
		total_time = 0,
		allowed_chain_actions = {}
	},
	action_wield = {
		kind = "wield",
		allowed_during_sprint = true,
		uninterruptible = true,
		anim_event = "equip",
		total_time = 0.5,
		allowed_chain_actions = {}
	}
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/force_sword"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/force_sword"
weapon_template.weapon_box = chain_sword_sweep_box
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.fx_sources = {}
weapon_template.keywords = {}
weapon_template.ammo_template = "no_ammo"
weapon_template.crosshair_type = "dot"
weapon_template.hit_marker_type = "center"
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.warp_charge_template = "default"
weapon_template.overclocks = {}
weapon_template.base_stats = {}
weapon_template.traits = {}
weapon_template.perks = {}

return weapon_template
