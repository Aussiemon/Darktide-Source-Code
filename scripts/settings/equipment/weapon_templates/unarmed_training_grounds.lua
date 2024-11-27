﻿-- chunkname: @scripts/settings/equipment/weapon_templates/unarmed_training_grounds.lua

local ActionInputHierarchyUtils = require("scripts/utilities/weapon/action_input_hierarchy")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {}

weapon_template.action_inputs = {
	wield = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				inputs = wield_inputs,
			},
		},
	},
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		input = "wield",
		transition = "stay",
	},
}

ActionInputHierarchyUtils.add_missing_ordered(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
	action_wield = {
		allowed_during_sprint = true,
		anim_event = "equip",
		kind = "wield",
		total_time = 0.5,
		uninterruptible = true,
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
		},
	},
	action_unwield = {
		allowed_during_sprint = true,
		kind = "unwield",
		start_input = "wield",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
	},
	action_warp_charge_explode = {
		anim_end_event = "explode_finished",
		anim_event = "explode_warp_start",
		death_on_explosion = true,
		kind = "overload_explosion",
		overload_type = "warp_charge",
		total_time = 3,
		timeline_anims = {
			[0.933] = {
				anim_event_1p = "explode_warp_end",
				anim_event_3p = "explode_warp_end",
			},
		},
		explosion_template = ExplosionTemplates.warp_charge_overload,
		death_damage_profile = DamageProfileTemplates.warp_charge_exploding_tick,
		death_damage_type = damage_types.warp_overload,
		dot_settings = {
			damage_frequency = 0.8,
			power_level = 1000,
			damage_profile = DamageProfileTemplates.warp_charge_exploding_tick,
			damage_type = damage_types.warp_overload,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.overheat_explosion_speed_modifier,
		},
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/unarmed",
	ogryn = "content/characters/player/ogryn/third_person/animations/unarmed",
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/unarmed",
	ogryn = "content/characters/player/ogryn/first_person/animations/unarmed",
}
weapon_template.keywords = {
	"unarmed",
}
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.fx_sources = {}
weapon_template.archetype_warp_explode_action_override = "action_warp_charge_explode"
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.breed_footstep_intervals = {
	human = FootstepIntervalsTemplates.unarmed_human,
	ogryn = FootstepIntervalsTemplates.unarmed_ogryn,
}
weapon_template.hide_slot = true

return weapon_template
