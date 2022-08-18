local AimAssistTemplates = require("scripts/settings/equipment/aim_assist_templates")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local DefaultMeleeActionInputSetup = require("scripts/settings/equipment/weapon_templates/default_melee_action_input_setup")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PushSettings = require("scripts/settings/damage/push_settings")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTraitsMeleeActivated = require("scripts/settings/equipment/weapon_traits/weapon_traits_melee_activated")
local WeaponTraitsMeleeCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_melee_common")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local damage_types = DamageSettings.damage_types
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local hit_zone_names = HitZone.hit_zone_names
local push_templates = PushSettings.push_templates
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local recoil_trait_templates = WeaponTraitTemplates[template_types.recoil]
local spread_trait_templates = WeaponTraitTemplates[template_types.spread]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local ammo_trait_templates = WeaponTraitTemplates[template_types.ammo]
local sway_trait_templates = WeaponTraitTemplates[template_types.sway]
local toughness_trait_templates = WeaponTraitTemplates[template_types.toughness]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local stagger_duration_modifier_trait_templates = WeaponTraitTemplates[template_types.stagger_duration_modifier]
local wounds_shapes = WoundsSettings.shapes
local weapon_template = {
	action_inputs = table.clone(DefaultMeleeActionInputSetup.action_inputs),
	action_input_hierarchy = table.clone(DefaultMeleeActionInputSetup.action_input_hierarchy)
}
local default_weapon_box = {
	0.2,
	0.15,
	1.2
}
weapon_template.actions = {
	action_unwield = {
		continue_sprinting = true,
		allowed_during_sprint = true,
		start_input = "wield",
		uninterruptible = true,
		kind = "unwield",
		total_time = 0,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			}
		}
	},
	action_wield = {
		continue_sprinting = true,
		allowed_during_sprint = true,
		kind = "wield",
		uninterruptible = true,
		anim_event = "equip",
		sprint_ready_up_time = 0.2,
		total_time = 0.3,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			}
		}
	},
	action_melee_start_left = {
		anim_end_event = "attack_finished",
		start_input = "start_attack",
		kind = "windup",
		allowed_during_sprint = true,
		anim_event = "attack_swing_charge_left_pose",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.05
			},
			{
				modifier = 0.95,
				t = 0.1
			},
			{
				modifier = 0.68,
				t = 0.25
			},
			{
				modifier = 0.65,
				t = 0.4
			},
			{
				modifier = 0.65,
				t = 0.5
			},
			{
				modifier = 0.635,
				t = 0.55
			},
			{
				modifier = 0.3,
				t = 1.2
			},
			{
				modifier = 0.1,
				t = 3
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_left_down_light"
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.6
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_activate_special_left"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_left_down_light = {
		damage_window_start = 0.3333333333333333,
		hit_armor_anim = "attack_hit",
		weapon_handling_template = "time_scale_0_9",
		stagger_duration_modifier_template = "default",
		attack_direction_override = "push",
		range_mod = 1.15,
		allowed_during_sprint = true,
		damage_window_end = 0.5333333333333333,
		special_active_hit_stop_anim = "attack_hit_power",
		hit_stop_anim = "attack_hit",
		anim_end_event = "attack_finished",
		first_person_hit_anim = "hit_left_shake",
		special_active_hit_stop_anim_3p = "attack_hit_power",
		kind = "sweep",
		anim_event_3p = "attack_swing_left_diagonal",
		anim_event = "attack_swing_left_down",
		power_level = 500,
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 1.15,
				t = 0.2
			},
			{
				modifier = 1.05,
				t = 0.35
			},
			{
				modifier = 0.65,
				t = 0.4
			},
			{
				modifier = 0.6,
				t = 0.45
			},
			{
				modifier = 0.6,
				t = 0.6
			},
			{
				modifier = 1,
				t = 0.7
			},
			{
				modifier = 1.05,
				t = 0.75
			},
			{
				modifier = 1.04,
				t = 0.8
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.65
			},
			block = {
				chain_time = 0.5,
				action_name = "action_block",
				chain_until = 0.2
			},
			special_action = {
				action_name = "action_activate_special_right",
				chain_time = 0.5
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/thunder_hammer/swing_left_down",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.thunderhammer_light,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.thunderhammer_light_active,
		damage_type_special_active = damage_types.blunt_thunder,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing
	},
	action_left_heavy = {
		damage_window_start = 0.3333333333333333,
		hit_armor_anim = "attack_hit",
		stagger_duration_modifier_template = "default",
		weapon_handling_template = "time_scale_1_1",
		first_person_hit_anim = "hit_left_shake",
		range_mod = 1.25,
		allowed_during_sprint = true,
		damage_window_end = 0.5333333333333333,
		special_active_hit_stop_anim = "attack_hit_power",
		hit_stop_anim = "attack_hit",
		anim_end_event = "attack_finished",
		kind = "sweep",
		special_active_hit_stop_anim_3p = "attack_hit_power",
		uninterruptible = true,
		anim_event = "attack_swing_heavy_left",
		power_level = 500,
		total_time = 1.75,
		action_movement_curve = {
			{
				modifier = 0.5,
				t = 0.1
			},
			{
				modifier = 1.15,
				t = 0.15
			},
			{
				modifier = 1.25,
				t = 0.25
			},
			{
				modifier = 1.3,
				t = 0.35
			},
			{
				modifier = 1.25,
				t = 0.45
			},
			{
				modifier = 0.5,
				t = 0.47
			},
			{
				modifier = 0.45,
				t = 0.6
			},
			{
				modifier = 0.45,
				t = 0.65
			},
			{
				modifier = 0.9,
				t = 0.8
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 0.4
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.65
			},
			block = {
				chain_time = 0.65,
				action_name = "action_block",
				chain_until = 0.2
			},
			special_action = {
				action_name = "action_activate_special_right",
				chain_time = 0.65
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/thunder_hammer/heavy_swing_left",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.thunderhammer_heavy,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.thunderhammer_heavy_active,
		damage_type_special_active = damage_types.blunt_thunder,
		herding_template = HerdingTemplates.thunder_hammer_left_heavy,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing_heavy
	},
	action_melee_start_right = {
		anim_event = "attack_swing_charge_right_pose",
		anim_end_event = "attack_finished",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.05
			},
			{
				modifier = 0.95,
				t = 0.1
			},
			{
				modifier = 0.68,
				t = 0.25
			},
			{
				modifier = 0.65,
				t = 0.4
			},
			{
				modifier = 0.65,
				t = 0.5
			},
			{
				modifier = 0.635,
				t = 0.55
			},
			{
				modifier = 0.3,
				t = 1.2
			},
			{
				modifier = 0.3,
				t = 3
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_right_down_light",
				chain_time = 0.15
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.6
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_activate_special_right"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_right_down_light = {
		damage_window_start = 0.38,
		hit_armor_anim = "attack_hit",
		weapon_handling_template = "time_scale_0_95",
		stagger_duration_modifier_template = "default",
		attack_direction_override = "push",
		range_mod = 1.15,
		kind = "sweep",
		damage_window_end = 0.5,
		special_active_hit_stop_anim = "attack_hit_power",
		hit_stop_anim = "attack_hit",
		anim_end_event = "attack_finished",
		special_active_hit_stop_anim_3p = "attack_hit_power",
		first_person_hit_anim = "hit_right_shake",
		anim_event_3p = "attack_swing_right_diagonal",
		anim_event = "attack_swing_right_down",
		power_level = 500,
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 1.15,
				t = 0.2
			},
			{
				modifier = 1.05,
				t = 0.35
			},
			{
				modifier = 0.65,
				t = 0.4
			},
			{
				modifier = 0.6,
				t = 0.45
			},
			{
				modifier = 0.6,
				t = 0.6
			},
			{
				modifier = 0.9,
				t = 0.7
			},
			{
				modifier = 0.95,
				t = 0.75
			},
			{
				modifier = 0.94,
				t = 0.8
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.75
			},
			block = {
				chain_time = 0.5,
				action_name = "action_block",
				chain_until = 0.2
			},
			special_action = {
				action_name = "action_activate_special_left_2",
				chain_time = 0.5
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/thunder_hammer/swing_right_down",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.thunderhammer_light,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.thunderhammer_light_active,
		damage_type_special_active = damage_types.blunt_thunder,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing
	},
	action_right_heavy = {
		damage_window_start = 0.35,
		hit_armor_anim = "attack_hit",
		range_mod = 1.25,
		stagger_duration_modifier_template = "default",
		first_person_hit_anim = "hit_right_shake",
		weapon_handling_template = "time_scale_1_1",
		damage_window_end = 0.5,
		special_active_hit_stop_anim = "attack_hit_power",
		hit_stop_anim = "attack_hit",
		anim_end_event = "attack_finished",
		special_active_hit_stop_anim_3p = "attack_hit_power",
		kind = "sweep",
		uninterruptible = true,
		anim_event = "attack_swing_heavy_right",
		power_level = 500,
		total_time = 1.75,
		action_movement_curve = {
			{
				modifier = 0.5,
				t = 0.1
			},
			{
				modifier = 1.15,
				t = 0.15
			},
			{
				modifier = 1.25,
				t = 0.25
			},
			{
				modifier = 1.3,
				t = 0.35
			},
			{
				modifier = 1.25,
				t = 0.45
			},
			{
				modifier = 0.5,
				t = 0.47
			},
			{
				modifier = 0.45,
				t = 0.6
			},
			{
				modifier = 0.45,
				t = 0.65
			},
			{
				modifier = 0.9,
				t = 0.8
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 0.4
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.75
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.65
			},
			block = {
				chain_time = 0.65,
				action_name = "action_block",
				chain_until = 0.2
			},
			special_action = {
				action_name = "action_activate_special_left",
				chain_time = 0.65
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/thunder_hammer/heavy_swing_right",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.thunderhammer_heavy,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.thunderhammer_heavy_active,
		damage_type_special_active = damage_types.blunt_thunder,
		herding_template = HerdingTemplates.thunder_hammer_right_heavy,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing_heavy
	},
	action_melee_start_left_2 = {
		anim_event = "attack_swing_charge_left_pose",
		anim_end_event = "attack_finished",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.05
			},
			{
				modifier = 0.95,
				t = 0.1
			},
			{
				modifier = 0.68,
				t = 0.25
			},
			{
				modifier = 0.65,
				t = 0.4
			},
			{
				modifier = 0.65,
				t = 0.5
			},
			{
				modifier = 0.635,
				t = 0.55
			},
			{
				modifier = 0.3,
				t = 1.2
			},
			{
				modifier = 0.3,
				t = 3
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_left_light",
				chain_time = 0.15
			},
			heavy_attack = {
				action_name = "action_left_heavy_2",
				chain_time = 0.6
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_activate_special_left_2"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_left_light = {
		damage_window_start = 0.3,
		hit_armor_anim = "attack_hit",
		kind = "sweep",
		stagger_duration_modifier_template = "default",
		first_person_hit_anim = "hit_left_shake",
		range_mod = 1.15,
		weapon_handling_template = "time_scale_1_1",
		damage_window_end = 0.4,
		special_active_hit_stop_anim = "attack_hit_power",
		special_active_hit_stop_anim_3p = "attack_hit_power",
		anim_end_event = "attack_finished",
		hit_stop_anim = "attack_hit",
		anim_event = "attack_swing_left",
		power_level = 500,
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 1.15,
				t = 0.21
			},
			{
				modifier = 1.05,
				t = 0.35
			},
			{
				modifier = 0.65,
				t = 0.4
			},
			{
				modifier = 0.6,
				t = 0.45
			},
			{
				modifier = 0.5,
				t = 0.7
			},
			{
				modifier = 1,
				t = 0.9
			},
			{
				modifier = 1.05,
				t = 0.95
			},
			{
				modifier = 1.04,
				t = 1.1
			},
			{
				modifier = 1,
				t = 1.3
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.75
			},
			block = {
				chain_time = 0.5,
				action_name = "action_block",
				chain_until = 0.2
			},
			special_action = {
				action_name = "action_activate_special_left",
				chain_time = 0.5
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/thunder_hammer/swing_left",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.thunderhammer_light,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.thunderhammer_light_active,
		damage_type_special_active = damage_types.blunt_thunder,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing
	},
	action_left_heavy_2 = {
		damage_window_start = 0.3,
		hit_armor_anim = "attack_hit",
		range_mod = 1.15,
		stagger_duration_modifier_template = "default",
		first_person_hit_anim = "hit_left_shake",
		weapon_handling_template = "time_scale_1_1",
		kind = "sweep",
		damage_window_end = 0.45,
		special_active_hit_stop_anim = "attack_hit_power",
		special_active_hit_stop_anim_3p = "attack_hit_power",
		anim_end_event = "attack_finished",
		hit_stop_anim = "attack_hit",
		uninterruptible = true,
		anim_event = "attack_swing_heavy_left",
		power_level = 500,
		total_time = 1.75,
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15
			},
			{
				modifier = 1.25,
				t = 0.4
			},
			{
				modifier = 0.5,
				t = 0.6
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.5
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.65
			},
			block = {
				chain_time = 0.65,
				action_name = "action_block",
				chain_until = 0.2
			},
			special_action = {
				action_name = "action_activate_special_right",
				chain_time = 0.65
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/thunder_hammer/heavy_swing_left",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.thunderhammer_heavy,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.thunderhammer_heavy_active,
		damage_type_special_active = damage_types.blunt_thunder,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing
	},
	action_block = {
		anim_event = "parry_pose",
		start_input = "block",
		anim_end_event = "parry_finished",
		kind = "block",
		stop_input = "block_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.2
			},
			{
				modifier = 0.32,
				t = 0.3
			},
			{
				modifier = 0.3,
				t = 0.325
			},
			{
				modifier = 0.31,
				t = 0.35
			},
			{
				modifier = 0.55,
				t = 0.5
			},
			{
				modifier = 0.75,
				t = 1
			},
			{
				modifier = 0.7,
				t = 2
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			push = {
				action_name = "action_push",
				chain_time = 0.15
			}
		}
	},
	action_left_light_pushfollow = {
		damage_window_start = 0.2,
		hit_armor_anim = "attack_hit",
		kind = "sweep",
		stagger_duration_modifier_template = "default",
		first_person_hit_anim = "hit_left_shake",
		range_mod = 1.15,
		weapon_handling_template = "time_scale_0_8",
		damage_window_end = 0.3,
		special_active_hit_stop_anim = "attack_hit_power",
		special_active_hit_stop_anim_3p = "attack_hit_power",
		anim_end_event = "attack_finished",
		hit_stop_anim = "attack_hit",
		anim_event = "attack_swing_left_diagonal",
		power_level = 500,
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.2
			},
			{
				modifier = 1.15,
				t = 0.4
			},
			{
				modifier = 0.55,
				t = 0.45
			},
			{
				modifier = 0.7,
				t = 0.65
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.4
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.55
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5
			},
			special_action = {
				action_name = "action_activate_special_right",
				chain_time = 0.5
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/thunder_hammer/swing_left_diagonal",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.thunderhammer_pushfollow,
		damage_type = damage_types.blunt,
		damage_profile_special_active = DamageProfileTemplates.thunderhammer_pushfollow_active,
		damage_type_special_active = damage_types.blunt_thunder,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing
	},
	action_push = {
		push_radius = 2.75,
		block_duration = 0.5,
		kind = "push",
		anim_event = "attack_push",
		power_level = 500,
		total_time = 1,
		action_movement_curve = {
			{
				modifier = 1.4,
				t = 0.1
			},
			{
				modifier = 0.5,
				t = 0.25
			},
			{
				modifier = 0.5,
				t = 0.4
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.4
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			push_follow_up = {
				action_name = "action_left_light_pushfollow",
				chain_time = 0.4
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.4
			},
			special_action = {
				action_name = "action_activate_special_left",
				chain_time = 0.4
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45
			},
			push = {
				action_name = "action_block",
				chain_time = 0.4
			}
		},
		inner_push_rad = math.pi * 0.6,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.push_test,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.push_test,
		outer_damage_type = damage_types.physical
	},
	action_activate_special_left = {
		kind = "activate_special",
		start_input = "special_action",
		anim_end_event = "activate_out",
		activation_time = 0.3,
		abort_sound_alias = "weapon_special_abort",
		allowed_during_sprint = true,
		anim_event = "activate",
		abort_fx_source_name = "_special_active",
		skip_3p_anims = false,
		total_time = 1.5,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.85
			},
			block = {
				action_name = "action_block",
				chain_time = 0.85
			}
		}
	},
	action_activate_special_right = {
		anim_end_event = "activate_out",
		activation_time = 0.3,
		abort_sound_alias = "weapon_special_abort",
		kind = "activate_special",
		allowed_during_sprint = true,
		anim_event = "activate",
		abort_fx_source_name = "_special_active",
		skip_3p_anims = false,
		total_time = 1.5,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.85
			},
			block = {
				action_name = "action_block",
				chain_time = 0.85
			}
		}
	},
	action_activate_special_left_2 = {
		anim_end_event = "activate_out",
		activation_time = 0.3,
		abort_sound_alias = "weapon_special_abort",
		kind = "activate_special",
		allowed_during_sprint = true,
		anim_event = "activate",
		abort_fx_source_name = "_special_active",
		skip_3p_anims = false,
		total_time = 1.5,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.85
			},
			block = {
				action_name = "action_block",
				chain_time = 0.85
			}
		}
	},
	action_inspect = {
		skip_3p_anims = false,
		lock_view = true,
		start_input = "inspect_start",
		anim_end_event = "inspect_end",
		kind = "inspect",
		crosshair_type = "none",
		anim_event = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge
	}
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/thunder_hammer"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/thunder_hammer"
weapon_template.weapon_box = {
	0.2,
	1,
	0.25
}
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
weapon_template.fx_sources = {
	_sweep = "fx_sweep",
	_special_active = "fx_special_active",
	_block = "fx_block"
}
weapon_template.crosshair_type = "dot"
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"melee",
	"thunder_hammer",
	"p1"
}
weapon_template.dodge_template = "support"
weapon_template.sprint_template = "support"
weapon_template.stamina_template = "thunderhammer_2h_p1_m1"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.allow_sprinting_with_special = true
weapon_template.footstep_intervals = {
	crouch_walking = 0.61,
	walking = 0.37,
	sprinting = 0.33
}
weapon_template.ammo_template = "no_ammo"
weapon_template.smart_targeting_template = SmartTargetingTemplates.tank
weapon_template.sprint_ready_up_time = 0.3
weapon_template.max_first_person_anim_movement_speed = 4.8
weapon_template.weapon_special_class = "WeaponSpecialSelfDisorientation"
weapon_template.weapon_special_tweak_data = {
	disorientation_type = "thunder_hammer",
	special_active_hit_extra_time = 0.5,
	active_duration = 4,
	push_template = push_templates.medium
}
weapon_template.overclocks = {
	armor_pierce_up_dps_down = {
		thunderhammer_p1_m1_dps_stat = -0.1,
		thunderhammer_p1_m1_armor_pierce_stat = 0.1
	},
	control_up_armor_pierce_down = {
		thunderhammer_p1_m1_armor_pierce_stat = -0.2,
		thunderhammer_p1_m1_control_stat = 0.2
	},
	first_target_up_armor_pierce_down = {
		thunderhammer_p1_m1_armor_pierce_stat = -0.1,
		thunderhammer_p1_m1_first_target_stat = 0.1
	},
	defence_up_first_target_down = {
		thunderhammer_p1_m1_first_target_stat = -0.1,
		thunderhammer_p1_m1_defence_stat = 0.1
	},
	dps_up_defence_down = {
		thunderhammer_p1_m1_defence_stat = -0.1,
		thunderhammer_p1_m1_dps_stat = 0.1
	}
}
weapon_template.base_stats = {
	thunderhammer_p1_m1_dps_stat = {
		description = "loc_trait_description_thunderhammer_p1_m1_dps_stat",
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				damage_trait_templates.thunderhammer_dps_stat
			},
			action_left_heavy = {
				damage_trait_templates.thunderhammer_dps_stat
			},
			action_right_down_light = {
				damage_trait_templates.thunderhammer_dps_stat
			},
			action_right_heavy = {
				damage_trait_templates.thunderhammer_dps_stat
			},
			action_left_light = {
				damage_trait_templates.thunderhammer_dps_stat
			},
			action_left_heavy_2 = {
				damage_trait_templates.thunderhammer_dps_stat
			},
			action_left_light_pushfollow = {
				damage_trait_templates.thunderhammer_dps_stat
			}
		}
	},
	thunderhammer_p1_m1_armor_pierce_stat = {
		description = "loc_trait_description_thunderhammer_p1_m1_armor_pierce_stat",
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				damage_trait_templates.thunderhammer_armor_pierce_stat
			},
			action_left_heavy = {
				damage_trait_templates.thunderhammer_armor_pierce_stat
			},
			action_right_down_light = {
				damage_trait_templates.thunderhammer_armor_pierce_stat
			},
			action_right_heavy = {
				damage_trait_templates.thunderhammer_armor_pierce_stat
			},
			action_left_light = {
				damage_trait_templates.thunderhammer_armor_pierce_stat
			},
			action_left_heavy_2 = {
				damage_trait_templates.thunderhammer_armor_pierce_stat
			},
			action_left_light_pushfollow = {
				damage_trait_templates.thunderhammer_armor_pierce_stat
			}
		}
	},
	thunderhammer_p1_m1_control_stat = {
		description = "loc_trait_description_thunderhammer_p1_m1_control_stat",
		display_name = "loc_stats_display_control_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				damage_trait_templates.thunderhammer_control_stat
			},
			action_left_heavy = {
				damage_trait_templates.thunderhammer_control_stat
			},
			action_right_down_light = {
				damage_trait_templates.thunderhammer_control_stat
			},
			action_right_heavy = {
				damage_trait_templates.thunderhammer_control_stat
			},
			action_left_light = {
				damage_trait_templates.thunderhammer_control_stat
			},
			action_left_heavy_2 = {
				damage_trait_templates.thunderhammer_control_stat
			},
			action_left_light_pushfollow = {
				damage_trait_templates.thunderhammer_control_stat
			}
		},
		weapon_handling = {
			action_left_down_light = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_left_heavy = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_right_down_light = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_right_heavy = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_left_light = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_left_heavy_2 = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_left_light_pushfollow = {
				weapon_handling_trait_templates.default_finesse_stat
			}
		},
		stagger_duration_modifier = {
			action_left_down_light = {
				stagger_duration_modifier_trait_templates.thunderhammer_p1_m1_control_stat
			},
			action_left_heavy = {
				stagger_duration_modifier_trait_templates.thunderhammer_p1_m1_control_stat
			},
			action_right_down_light = {
				stagger_duration_modifier_trait_templates.thunderhammer_p1_m1_control_stat
			},
			action_right_heavy = {
				stagger_duration_modifier_trait_templates.thunderhammer_p1_m1_control_stat
			},
			action_left_light = {
				stagger_duration_modifier_trait_templates.thunderhammer_p1_m1_control_stat
			},
			action_left_heavy_2 = {
				stagger_duration_modifier_trait_templates.thunderhammer_p1_m1_control_stat
			},
			action_left_light_pushfollow = {
				stagger_duration_modifier_trait_templates.thunderhammer_p1_m1_control_stat
			}
		}
	},
	thunderhammer_p1_m1_first_target_stat = {
		description = "loc_trait_description_thunderhammer_p1_m1_first_target_stat",
		display_name = "loc_stats_display_first_target_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_first_target_stat
			},
			action_left_heavy = {
				damage_trait_templates.default_first_target_stat
			},
			action_right_down_light = {
				damage_trait_templates.default_first_target_stat
			},
			action_right_heavy = {
				damage_trait_templates.default_first_target_stat
			},
			action_left_light = {
				damage_trait_templates.default_first_target_stat
			},
			action_left_heavy_2 = {
				damage_trait_templates.default_first_target_stat
			},
			action_left_light_pushfollow = {
				damage_trait_templates.default_first_target_stat
			}
		}
	},
	thunderhammer_p1_m1_defence_stat = {
		description = "loc_trait_description_thunderhammer_p1_m1_defence_stat",
		display_name = "loc_stats_display_defense_stat",
		is_stat_trait = true,
		stamina = {
			base = {
				stamina_trait_templates.thunderhammer_p1_m1_defence_stat
			}
		},
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat
			}
		}
	}
}
weapon_template.traits = {}
local melee_common_traits = table.keys(WeaponTraitsMeleeCommon)

table.append(weapon_template.traits, melee_common_traits)

local melee_activated_traits = table.keys(WeaponTraitsMeleeActivated)

table.append(weapon_template.traits, melee_activated_traits)

weapon_template.perks = {
	thunderhammer_p1_m1_dps_perk = {
		description = "loc_trait_description_thunderhammer_p1_m1_dps_perk",
		display_name = "loc_trait_display_thunderhammer_p1_m1_dps_perk",
		damage = {
			action_left_down_light = {
				damage_trait_templates.thunderhammer_dps_perk
			},
			action_left_heavy = {
				damage_trait_templates.thunderhammer_dps_perk
			},
			action_right_down_light = {
				damage_trait_templates.thunderhammer_dps_perk
			},
			action_right_heavy = {
				damage_trait_templates.thunderhammer_dps_perk
			},
			action_left_light = {
				damage_trait_templates.thunderhammer_dps_perk
			},
			action_left_heavy_2 = {
				damage_trait_templates.thunderhammer_dps_perk
			},
			action_left_light_pushfollow = {
				damage_trait_templates.thunderhammer_dps_perk
			}
		}
	},
	thunderhammer_p1_m1_armor_pierce_perk = {
		description = "loc_trait_description_thunderhammer_p1_m1_armor_pierce_perk",
		display_name = "loc_trait_display_thunderhammer_p1_m1_armor_pierce_perk",
		damage = {
			action_left_down_light = {
				damage_trait_templates.thunderhammer_armor_pierce_perk
			},
			action_left_heavy = {
				damage_trait_templates.thunderhammer_armor_pierce_perk
			},
			action_right_down_light = {
				damage_trait_templates.thunderhammer_armor_pierce_perk
			},
			action_right_heavy = {
				damage_trait_templates.thunderhammer_armor_pierce_perk
			},
			action_left_light = {
				damage_trait_templates.thunderhammer_armor_pierce_perk
			},
			action_left_heavy_2 = {
				damage_trait_templates.thunderhammer_armor_pierce_perk
			},
			action_left_light_pushfollow = {
				damage_trait_templates.thunderhammer_armor_pierce_perk
			}
		}
	},
	thunderhammer_p1_m1_control_perk = {
		description = "loc_trait_description_thunderhammer_p1_m1_control_perk",
		display_name = "loc_trait_display_thunderhammer_p1_m1_control_perk",
		damage = {
			action_left_down_light = {
				damage_trait_templates.thunderhammer_control_perk
			},
			action_left_heavy = {
				damage_trait_templates.thunderhammer_control_perk
			},
			action_right_down_light = {
				damage_trait_templates.thunderhammer_control_perk
			},
			action_right_heavy = {
				damage_trait_templates.thunderhammer_control_perk
			},
			action_left_light = {
				damage_trait_templates.thunderhammer_control_perk
			},
			action_left_heavy_2 = {
				damage_trait_templates.thunderhammer_control_perk
			},
			action_left_light_pushfollow = {
				damage_trait_templates.thunderhammer_control_perk
			}
		},
		weapon_handling = {
			action_left_down_light = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_left_heavy = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_right_down_light = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_right_heavy = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_left_light = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_left_heavy_2 = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_left_light_pushfollow = {
				weapon_handling_trait_templates.default_finesse_perk
			}
		}
	},
	thunderhammer_p1_m1_first_target_perk = {
		description = "loc_trait_description_thunderhammer_p1_m1_first_target_perk",
		display_name = "loc_trait_display_thunderhammer_p1_m1_first_target_perk",
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_left_heavy = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_right_down_light = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_left_light = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_left_heavy_2 = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_left_light_pushfollow = {
				damage_trait_templates.default_melee_first_target_perk
			}
		}
	},
	thunderhammer_p1_m1_defence_perk = {
		description = "loc_trait_description_thunderhammer_p1_m1_defence_perk",
		display_name = "loc_trait_display_thunderhammer_p1_m1_defence_perk",
		stamina = {
			base = {
				stamina_trait_templates.thunderhammer_p1_m1_defence_perk
			}
		},
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_perk
			}
		}
	}
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_thunderhammer_p1_m1_description_1",
		icon_type = "crosshair"
	},
	{
		display_name = "loc_weapon_keyword_thunderhammer_p1_m1_description_2",
		icon_type = "shield"
	},
	{
		display_name = "loc_weapon_keyword_thunderhammer_p1_m1_description_3",
		icon_type = "shield"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_thunderhammer_p1_m1_attack_primary",
		type = "ninja_fencer"
	},
	secondary = {
		display_name = "loc_thunderhammer_p1_m1_attack_secondary",
		type = "ninja_fencer"
	},
	special = {
		display_name = "loc_thunderhammer_p1_m1_attack_special",
		type = "ninja_fencer"
	}
}

return weapon_template
