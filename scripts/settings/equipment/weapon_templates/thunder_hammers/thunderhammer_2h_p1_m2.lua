local AimAssistTemplates = require("scripts/settings/equipment/aim_assist_templates")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local MeleeActionInputSetupMid = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_mid")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PushSettings = require("scripts/settings/damage/push_settings")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeThunderhammerP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_thunderhammer_2h_p1")
local WeaponTraitsMeleeActivated = require("scripts/settings/equipment/weapon_traits/weapon_traits_melee_activated")
local WeaponTraitsMeleeCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_melee_common")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
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
	action_inputs = table.clone(MeleeActionInputSetupMid.action_inputs),
	action_input_hierarchy = table.clone(MeleeActionInputSetupMid.action_input_hierarchy)
}
weapon_template.action_inputs.block.buffer_time = 0.1
weapon_template.action_inputs.block_release.buffer_time = 0.35
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
			},
			grenade_ability = {
				action_name = "grenade_ability"
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left"
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_activate_special_left"
			}
		}
	},
	action_melee_start_left = {
		start_input = "start_attack",
		allowed_during_sprint = true,
		kind = "windup",
		anim_event = "attack_swing_charge_left_down",
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
		}
	},
	action_left_down_light = {
		damage_window_start = 0.36666666666666664,
		hit_armor_anim = "attack_hit",
		kind = "sweep",
		weapon_handling_template = "time_scale_0_9",
		stagger_duration_modifier_template = "default",
		attack_direction_override = "left",
		anim_event = "attack_swing_left",
		allowed_during_sprint = true,
		range_mod = 1.15,
		first_person_hit_anim = "hit_left_shake",
		special_active_hit_stop_anim_3p = "attack_hit_power",
		damage_window_end = 0.43333333333333335,
		special_active_hit_stop_anim = "attack_hit_power",
		anim_event_3p = "attack_swing_left_diagonal",
		hit_stop_anim = "attack_hit",
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
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing
	},
	action_left_heavy = {
		damage_window_start = 0.36666666666666664,
		hit_armor_anim = "attack_hit",
		stagger_duration_modifier_template = "default",
		weapon_handling_template = "time_scale_1_1",
		first_person_hit_anim = "hit_left_shake",
		anim_event = "attack_swing_heavy_left_down",
		allowed_during_sprint = true,
		kind = "sweep",
		range_mod = 1.25,
		special_active_hit_stop_anim_3p = "attack_hit_power",
		damage_window_end = 0.43333333333333335,
		special_active_hit_stop_anim = "attack_hit_power",
		uninterruptible = true,
		hit_stop_anim = "attack_hit",
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
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/thunder_hammer/heavy_swing_left_down",
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
		herding_template = HerdingTemplates.thunder_hammer_left_down_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing_heavy
	},
	action_melee_start_right = {
		anim_event = "attack_swing_charge_right_down",
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
		}
	},
	action_melee_start_right_2 = {
		anim_event = "attack_swing_charge_right_down",
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
				action_name = "action_left_down_light",
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
		}
	},
	action_right_down_light = {
		damage_window_start = 0.38,
		hit_armor_anim = "attack_hit",
		kind = "sweep",
		weapon_handling_template = "time_scale_0_95",
		stagger_duration_modifier_template = "default",
		attack_direction_override = "push",
		range_mod = 1.15,
		first_person_hit_anim = "hit_right_shake",
		special_active_hit_stop_anim_3p = "attack_hit_power",
		damage_window_end = 0.5,
		special_active_hit_stop_anim = "attack_hit_power",
		anim_event_3p = "attack_swing_right_diagonal",
		anim_event = "attack_swing_right_down",
		hit_stop_anim = "attack_hit",
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
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing
	},
	action_right_heavy = {
		damage_window_start = 0.26666666666666666,
		hit_armor_anim = "attack_hit",
		kind = "sweep",
		stagger_duration_modifier_template = "default",
		first_person_hit_anim = "hit_right_shake",
		weapon_handling_template = "time_scale_1_1",
		anim_event = "attack_swing_heavy_right_down",
		anim_event_3p = "attack_swing_heavy_right_down",
		range_mod = 1.25,
		special_active_hit_stop_anim_3p = "attack_hit_power",
		damage_window_end = 0.4666666666666667,
		special_active_hit_stop_anim = "attack_hit_power",
		uninterruptible = true,
		hit_stop_anim = "attack_hit",
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
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/thunder_hammer/heavy_swing_right_down",
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
		herding_template = HerdingTemplates.thunder_hammer_right_down_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing_heavy
	},
	action_melee_start_left_2 = {
		anim_event = "attack_swing_charge_left_down",
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
		}
	},
	action_left_light = {
		hit_armor_anim = "attack_hit",
		range_mod = 1.15,
		kind = "sweep",
		stagger_duration_modifier_template = "default",
		first_person_hit_anim = "hit_left_shake",
		damage_window_start = 0.2,
		weapon_handling_template = "time_scale_0_8",
		special_active_hit_stop_anim_3p = "attack_hit_power",
		damage_window_end = 0.3,
		special_active_hit_stop_anim = "attack_hit_power",
		anim_event = "attack_swing_left_diagonal",
		hit_stop_anim = "attack_hit",
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
				action_name = "action_melee_start_right_2",
				chain_time = 0.86
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
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/thunder_hammer/swing_left_diagonal",
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
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing
	},
	action_left_heavy_2 = {
		damage_window_start = 0.36666666666666664,
		hit_armor_anim = "attack_hit",
		kind = "sweep",
		range_mod = 1.15,
		weapon_handling_template = "time_scale_1_1",
		first_person_hit_anim = "hit_left_shake",
		stagger_duration_modifier_template = "default",
		special_active_hit_stop_anim_3p = "attack_hit_power",
		damage_window_end = 0.43333333333333335,
		special_active_hit_stop_anim = "attack_hit_power",
		uninterruptible = true,
		anim_event = "attack_swing_heavy_left_down",
		hit_stop_anim = "attack_hit",
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
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/thunder_hammer/heavy_swing_left_down",
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
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing
	},
	action_block = {
		minimum_hold_time = 0.3,
		start_input = "block",
		anim_end_event = "parry_finished",
		kind = "block",
		anim_event = "parry_pose",
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
		hit_armor_anim = "attack_hit",
		kind = "sweep",
		stagger_duration_modifier_template = "default",
		first_person_hit_anim = "hit_left_shake",
		damage_window_start = 0.3333333333333333,
		range_mod = 1.15,
		weapon_handling_template = "time_scale_1",
		special_active_hit_stop_anim_3p = "attack_hit_power",
		damage_window_end = 0.5333333333333333,
		special_active_hit_stop_anim = "attack_hit_power",
		anim_event = "attack_swing_left_down",
		hit_stop_anim = "attack_hit",
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
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/thunder_hammer/swing_left_down",
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
		herding_template = HerdingTemplates.linesman_left_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		aim_assist_ramp_template = AimAssistTemplates.tank_swing
	},
	action_push = {
		block_duration = 0.5,
		push_radius = 2.75,
		anim_event = "attack_push",
		kind = "push",
		activation_cooldown = 0.2,
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
				chain_time = 0.45
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
		inner_push_rad = math.pi * 0.35,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.default_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.light_push,
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
weapon_template.footstep_intervals = FootstepIntervalsTemplates.thunderhammer
weapon_template.damage_window_start_sweep_trail_offset = -0.2
weapon_template.damage_window_end_sweep_trail_offset = 0.2
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
	thunderhammer_p1_m2_dps_stat = {
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
	thunderhammer_p1_m2_armor_pierce_stat = {
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
	thunderhammer_p1_m2_control_stat = {
		display_name = "loc_stats_display_control_stat_melee",
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
	thunderhammer_p1_m2_first_target_stat = {
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
	thunderhammer_p1_m2_defence_stat = {
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

local bespoke_thunderhammer_2h_p1_traits = table.keys(WeaponTraitsBespokeThunderhammerP1)

table.append(weapon_template.traits, bespoke_thunderhammer_2h_p1_traits)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_crowd_control"
	},
	{
		display_name = "loc_weapon_keyword_thunder_hammer"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_smiter",
		type = "tank",
		attack_chain = {
			"tank",
			"smiter",
			"smiter"
		}
	},
	secondary = {
		display_name = "loc_gestalt_tank",
		type = "smiter",
		attack_chain = {
			"smiter",
			"smiter"
		}
	},
	special = {
		display_name = "loc_weapon_special_activate",
		type = "activate"
	}
}

return weapon_template
