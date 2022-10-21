local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local DefaultMeleeActionInputSetup = require("scripts/settings/equipment/weapon_templates/default_melee_action_input_setup")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeCombatswordP3 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combatsword_p3")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local WeaponTraitsMeleeCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_melee_common")
local damage_types = DamageSettings.damage_types
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local hit_zone_names = HitZone.hit_zone_names
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_types = DamageSettings.damage_types
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {}
local wounds_shapes = WoundsSettings.shapes
local combat_sword_action_inputs = table.clone(DefaultMeleeActionInputSetup.action_inputs)
combat_sword_action_inputs.parry = {
	buffer_time = 0
}
local combat_sword_action_input_hierarchy = table.clone(DefaultMeleeActionInputSetup.action_input_hierarchy)
combat_sword_action_input_hierarchy.parry = "base"
weapon_template.action_inputs = combat_sword_action_inputs
weapon_template.action_input_hierarchy = combat_sword_action_input_hierarchy
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
local default_weapon_box = {
	0.2,
	0.1,
	1.1
}
weapon_template.actions = {
	action_unwield = {
		continue_sprinting = true,
		allowed_during_sprint = true,
		start_input = "wield",
		uninterruptible = true,
		kind = "unwield",
		total_time = 0,
		allowed_chain_actions = {}
	},
	action_wield = {
		continue_sprinting = true,
		allowed_during_sprint = true,
		kind = "wield",
		uninterruptible = true,
		anim_event = "equip",
		sprint_ready_up_time = 0,
		total_time = 0.1,
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
				action_name = "action_attack_special"
			}
		}
	},
	action_melee_start_left = {
		anim_end_event = "attack_finished",
		start_input = "start_attack",
		kind = "windup",
		allowed_during_sprint = true,
		anim_event = "heavy_charge_stab_left",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.65,
				t = 0.05
			},
			{
				modifier = 0.7,
				t = 0.1
			},
			{
				modifier = 0.9,
				t = 0.25
			},
			{
				modifier = 0.85,
				t = 0.4
			},
			{
				modifier = 0.85,
				t = 0.5
			},
			{
				modifier = 0.835,
				t = 0.55
			},
			{
				modifier = 0.95,
				t = 3
			},
			start_modifier = 0.75
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
				chain_time = 0
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.75
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_attack_special"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_left_light = {
		damage_window_start = 0.2,
		hit_armor_anim = "attack_hit_shield",
		anim_end_event = "attack_finished",
		range_mod = 1.25,
		kind = "sweep",
		continue_sprinting = false,
		allowed_during_sprint = true,
		damage_window_end = 0.3,
		anim_event = "attack_left_diagonal_down",
		total_time = 1.5,
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
				modifier = 0.7,
				t = 0.5
			},
			{
				modifier = 0.65,
				t = 0.55
			},
			{
				modifier = 0.65,
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
			start_modifier = 1.3
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.4
			},
			block = {
				action_name = "action_block",
				chain_time = 0
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.35
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/sabre/attack_left_diagonal_down",
			anchor_point_offset = {
				0,
				0,
				-0.3
			}
		},
		damage_profile = DamageProfileTemplates.light_combat_knife_ninja_fencer,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.left_45_slash
	},
	action_left_heavy = {
		damage_window_start = 0.04,
		hit_armor_anim = "attack_hit_shield",
		anim_end_event = "attack_finished",
		range_mod = 1.25,
		kind = "sweep",
		continue_sprinting = false,
		allowed_during_sprint = true,
		damage_window_end = 0.12,
		anim_event = "heavy_attack_stab_left",
		total_time = 1.5,
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
				chain_time = 0.24
			},
			block = {
				chain_time = 0.4,
				action_name = "action_block",
				chain_until = 0.1
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.35
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/sabre/heavy_attack_stab_01",
			anchor_point_offset = {
				0,
				0,
				-0.15
			}
		},
		damage_profile = DamageProfileTemplates.heavy_combatsword,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.vertical_slash
	},
	action_melee_start_right = {
		anim_end_event = "attack_finished",
		kind = "windup",
		allowed_during_sprint = true,
		anim_event = "heavy_charge_right",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.65,
				t = 0.05
			},
			{
				modifier = 0.7,
				t = 0.1
			},
			{
				modifier = 0.9,
				t = 0.25
			},
			{
				modifier = 0.85,
				t = 0.4
			},
			{
				modifier = 0.85,
				t = 0.5
			},
			{
				modifier = 0.835,
				t = 0.55
			},
			{
				modifier = 0.95,
				t = 3
			},
			start_modifier = 0.75
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
				action_name = "action_right_light",
				chain_time = 0
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.54
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_attack_special"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_right_light = {
		damage_window_start = 0.19,
		hit_armor_anim = "attack_hit_shield",
		anim_end_event = "attack_finished",
		range_mod = 1.25,
		kind = "sweep",
		continue_sprinting = false,
		allowed_during_sprint = true,
		damage_window_end = 0.29,
		anim_event = "attack_right_diagonal_up",
		total_time = 1.5,
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
				modifier = 0.7,
				t = 0.5
			},
			{
				modifier = 0.65,
				t = 0.55
			},
			{
				modifier = 0.65,
				t = 0.6
			},
			{
				modifier = 0.9,
				t = 0.8
			},
			{
				modifier = 0.975,
				t = 0.85
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.3
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
				chain_time = 0.3
			},
			block = {
				action_name = "action_block",
				chain_time = 0
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.35
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/sabre/attack_right_diagonal_up",
			anchor_point_offset = {
				0,
				0,
				-0.2
			}
		},
		damage_profile = DamageProfileTemplates.light_combat_knife_ninja_fencer,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.right_45_slash
	},
	action_right_heavy = {
		damage_window_start = 0.18,
		hit_armor_anim = "attack_hit_shield",
		anim_end_event = "attack_finished",
		range_mod = 1.25,
		kind = "sweep",
		continue_sprinting = false,
		allowed_during_sprint = true,
		damage_window_end = 0.24,
		anim_event = "heavy_attack_right_diagonal_down",
		total_time = 1.5,
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
				action_name = "action_unwield",
				chain_time = 0.3
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.4
			},
			block = {
				chain_time = 0.45,
				action_name = "action_block",
				chain_until = 0.05
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.4
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/sabre/heavy_attack_right_diagonal_down",
			anchor_point_offset = {
				0,
				0,
				-0.2
			}
		},
		damage_profile = DamageProfileTemplates.heavy_combatsword,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.vertical_slash
	},
	action_melee_start_left_2 = {
		anim_end_event = "attack_finished",
		hit_armor_anim = "attack_hit_shield",
		kind = "windup",
		continue_sprinting = false,
		allowed_during_sprint = true,
		anim_event = "heavy_charge_stab_left",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.65,
				t = 0.05
			},
			{
				modifier = 0.7,
				t = 0.1
			},
			{
				modifier = 0.9,
				t = 0.25
			},
			{
				modifier = 0.85,
				t = 0.4
			},
			{
				modifier = 0.85,
				t = 0.5
			},
			{
				modifier = 0.835,
				t = 0.55
			},
			{
				modifier = 0.95,
				t = 3
			},
			start_modifier = 0.75
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
				action_name = "action_left_light_2",
				chain_time = 0
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.56
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.35
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_left_light_2 = {
		damage_window_start = 0.16,
		hit_armor_anim = "attack_hit_shield",
		anim_end_event = "attack_finished",
		range_mod = 1.25,
		kind = "sweep",
		attack_direction_override = "push",
		continue_sprinting = false,
		allowed_during_sprint = true,
		damage_window_end = 0.26,
		anim_event = "attack_left_diagonal_up",
		total_time = 1.5,
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2
			},
			{
				modifier = 1.05,
				t = 0.35
			},
			{
				modifier = 0.7,
				t = 0.5
			},
			{
				modifier = 0.65,
				t = 0.55
			},
			{
				modifier = 0.65,
				t = 0.6
			},
			{
				modifier = 0.9,
				t = 0.8
			},
			{
				modifier = 0.975,
				t = 0.85
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.3
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right_2",
				chain_time = 0.3
			},
			block = {
				action_name = "action_block",
				chain_time = 0
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.35
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/sabre/attack_left_diagonal_up",
			anchor_point_offset = {
				0,
				0,
				-0.1
			}
		},
		damage_profile = DamageProfileTemplates.light_combat_knife_ninja_fencer,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.left_45_slash
	},
	action_melee_start_right_2 = {
		anim_end_event = "attack_finished",
		kind = "windup",
		continue_sprinting = false,
		allowed_during_sprint = true,
		anim_event = "heavy_charge_right",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.65,
				t = 0.05
			},
			{
				modifier = 0.7,
				t = 0.1
			},
			{
				modifier = 0.9,
				t = 0.25
			},
			{
				modifier = 0.85,
				t = 0.4
			},
			{
				modifier = 0.85,
				t = 0.5
			},
			{
				modifier = 0.835,
				t = 0.55
			},
			{
				modifier = 0.95,
				t = 3
			},
			start_modifier = 0.75
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
				action_name = "action_right_light_2",
				chain_time = 0
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.54
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.35
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_right_light_2 = {
		damage_window_start = 0.2,
		hit_armor_anim = "attack_hit_shield",
		anim_end_event = "attack_finished",
		range_mod = 1.25,
		kind = "sweep",
		continue_sprinting = false,
		allowed_during_sprint = true,
		damage_window_end = 0.3,
		anim_event = "attack_right_diagonal_down",
		hit_stop_anim = "hit_stop",
		total_time = 1.5,
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
				modifier = 0.7,
				t = 0.5
			},
			{
				modifier = 0.65,
				t = 0.55
			},
			{
				modifier = 0.65,
				t = 0.6
			},
			{
				modifier = 0.9,
				t = 0.8
			},
			{
				modifier = 0.975,
				t = 0.85
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.3
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
				chain_time = 0.35
			},
			block = {
				action_name = "action_block",
				chain_time = 0
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.35
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/sabre/attack_right_diagonal_down",
			anchor_point_offset = {
				0,
				0,
				-0.2
			}
		},
		damage_profile = DamageProfileTemplates.light_combat_knife_ninja_fencer,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		wounds_shape = wounds_shapes.right_45_slash
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
				modifier = 0.82,
				t = 0.3
			},
			{
				modifier = 0.8,
				t = 0.325
			},
			{
				modifier = 0.81,
				t = 0.35
			},
			{
				modifier = 0.85,
				t = 0.5
			},
			{
				modifier = 0.85,
				t = 1
			},
			{
				modifier = 0.8,
				t = 2
			},
			start_modifier = 1
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield"
			},
			push = {
				action_name = "action_push"
			},
			special_action = {
				action_name = "action_attack_special"
			},
			grenade_ability = {
				action_name = "grenade_ability"
			}
		}
	},
	action_attack_special = {
		damage_window_start = 0.07,
		hit_armor_anim = "attack_hit_shield",
		start_input = "special_action",
		anim_end_event = "attack_finished",
		kind = "sweep",
		attack_direction_override = "push",
		range_mod = 1.25,
		damage_window_end = 0.12,
		anim_event = "attack_special_stab",
		total_time = 1,
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.15
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
				action_name = "action_unwield",
				chain_time = 0.3
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.3
			},
			block = {
				chain_time = 0.45,
				action_name = "action_block",
				chain_until = 0.05
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.7
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/sabre/attack_stab_special_01",
			anchor_point_offset = {
				0,
				0,
				-0.3
			}
		},
		damage_profile = DamageProfileTemplates.heavy_combatsword,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_right_light_pushfollow = {
		damage_window_start = 0.2,
		hit_armor_anim = "attack_hit_shield",
		range_mod = 1.25,
		anim_end_event = "attack_finished",
		kind = "sweep",
		damage_window_end = 0.3,
		anim_event = "attack_right_diagonal_down",
		total_time = 2,
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.2
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
				chain_time = 0.4
			},
			block = {
				action_name = "action_block",
				chain_time = 0.55
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.4
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/sabre/attack_right_diagonal_down",
			anchor_point_offset = {
				0,
				0,
				-0.2
			}
		},
		damage_profile = DamageProfileTemplates.light_combat_knife_ninja_fencer,
		damage_type = damage_types.metal_slashing_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_push = {
		push_radius = 2.5,
		block_duration = 0.5,
		kind = "push",
		anim_event = "attack_push",
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
				action_name = "action_right_light_pushfollow",
				chain_time = 0.25
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.5
			},
			block = {
				action_name = "action_block",
				chain_time = 0.3
			},
			special_action = {
				action_name = "action_attack_special",
				chain_time = 0.45
			}
		},
		inner_push_rad = math.pi * 0.1,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.ninja_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.physical
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

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/power_sword"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/sabre"
weapon_template.weapon_box = {
	0.1,
	0.7,
	0.02
}
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.3
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_block = "fx_block",
	_sweep = "fx_sweep"
}
weapon_template.crosshair_type = "dot"
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"melee",
	"combat_sword",
	"p3"
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "chainsword_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.overclocks = {
	cleave_damage_up_dps_down = {
		combatsword_p1_m1_cleave_damage_stat = 0.1,
		combatsword_p1_m1_dps_stat = -0.1
	},
	finesse_up_cleave_damage_down = {
		combatsword_p1_m1_cleave_damage_stat = -0.2,
		combatsword_p1_m1_finesse_stat = 0.2
	},
	cleave_targets_up_cleave_damage_down = {
		combatsword_p1_m1_cleave_targets_stat = 0.1,
		combatsword_p1_m1_cleave_damage_stat = -0.1
	},
	mobility_up_cleave_targets_down = {
		combatsword_p1_m1_cleave_targets_stat = -0.1,
		combatsword_p1_m1_mobility_stat = 0.1
	},
	dps_up_mobility_down = {
		combatsword_p1_m1_dps_stat = 0.1,
		combatsword_p1_m1_mobility_stat = -0.1
	}
}
weapon_template.base_stats = {
	combatsword_p1_m1_dps_stat = {
		description = "loc_trait_description_combatsword_p1_m1_dps_stat",
		display_name = "loc_trait_display_combatsword_p1_m1_dps_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
				damage_trait_templates.combatsword_dps_stat
			},
			action_left_heavy = {
				damage_trait_templates.combatsword_dps_stat
			},
			action_right_light = {
				damage_trait_templates.combatsword_dps_stat
			},
			action_right_heavy = {
				damage_trait_templates.combatsword_dps_stat
			},
			action_left_light_2 = {
				damage_trait_templates.combatsword_dps_stat
			},
			action_attack_special = {
				damage_trait_templates.combatsword_dps_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.combatsword_dps_stat
			}
		}
	},
	combatsword_p1_m1_cleave_damage_stat = {
		description = "loc_trait_description_combatsword_p1_m1_cleave_damage_stat",
		display_name = "loc_trait_display_combatsword_p1_m1_cleave_damage_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
				damage_trait_templates.combatsword_cleave_damage_stat
			},
			action_left_heavy = {
				damage_trait_templates.combatsword_cleave_damage_stat
			},
			action_right_light = {
				damage_trait_templates.combatsword_cleave_damage_stat
			},
			action_right_heavy = {
				damage_trait_templates.combatsword_cleave_damage_stat
			},
			action_left_light_2 = {
				damage_trait_templates.combatsword_cleave_damage_stat
			},
			action_attack_special = {
				damage_trait_templates.combatsword_cleave_damage_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.combatsword_cleave_damage_stat
			}
		}
	},
	combatsword_p1_m1_finesse_stat = {
		description = "loc_trait_description_combatsword_p1_m1_finesse_stat",
		display_name = "loc_trait_display_combatsword_p1_m1_finesse_stat",
		is_stat_trait = true
	},
	combatsword_p1_m1_cleave_targets_stat = {
		description = "loc_trait_description_combatsword_p1_m1_cleave_targets_stat",
		display_name = "loc_trait_display_combatsword_p1_m1_cleave_targets_stat",
		is_stat_trait = true,
		damage = {
			action_left_light = {
				damage_trait_templates.combatsword_cleave_targets_stat
			},
			action_left_heavy = {
				damage_trait_templates.combatsword_cleave_targets_stat
			},
			action_right_light = {
				damage_trait_templates.combatsword_cleave_targets_stat
			},
			action_right_heavy = {
				damage_trait_templates.combatsword_cleave_targets_stat
			},
			action_left_light_2 = {
				damage_trait_templates.combatsword_cleave_targets_stat
			},
			action_attack_special = {
				damage_trait_templates.combatsword_cleave_targets_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.combatsword_cleave_targets_stat
			}
		}
	},
	combatsword_p1_m1_mobility_stat = {
		description = "loc_trait_description_combatsword_p1_m1_mobility_stat",
		display_name = "loc_trait_display_combatsword_p1_m1_mobility_stat",
		is_stat_trait = true,
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat
			}
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_stat
			}
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_stat
			}
		}
	}
}
weapon_template.traits = {}
local melee_common_traits = table.keys(WeaponTraitsMeleeCommon)

table.append(weapon_template.traits, melee_common_traits)

local bespoke_combatsword_p3_traits = table.keys(WeaponTraitsBespokeCombatswordP3)

table.append(weapon_template.traits, bespoke_combatsword_p3_traits)

weapon_template.perks = {
	combatsword_p1_m1_dps_perk = {
		description = "loc_trait_description_combatsword_p1_m1_dps_perk",
		display_name = "loc_trait_display_combatsword_p1_m1_dps_perk",
		damage = {
			action_left_light = {
				damage_trait_templates.combatsword_dps_perk
			},
			action_left_heavy = {
				damage_trait_templates.combatsword_dps_perk
			},
			action_right_light = {
				damage_trait_templates.combatsword_dps_perk
			},
			action_right_heavy = {
				damage_trait_templates.combatsword_dps_perk
			},
			action_right_light_pushfollow = {
				damage_trait_templates.combatsword_dps_perk
			}
		}
	},
	combatsword_p1_m1_cleave_damage_perk = {
		description = "loc_trait_description_combatsword_p1_m1_cleave_damage_perk",
		display_name = "loc_trait_display_combatsword_p1_m1_cleave_damage_perk",
		damage = {
			action_left_light = {
				damage_trait_templates.combatsword_cleave_damage_perk
			},
			action_left_heavy = {
				damage_trait_templates.combatsword_cleave_damage_perk
			},
			action_right_light = {
				damage_trait_templates.combatsword_cleave_damage_perk
			},
			action_right_heavy = {
				damage_trait_templates.combatsword_cleave_damage_perk
			},
			action_right_light_pushfollow = {
				damage_trait_templates.combatsword_cleave_damage_perk
			}
		}
	},
	combatsword_p1_m1_finesse_perk = {
		display_name = "loc_trait_display_combatsword_p1_m1_finesse_perk",
		description = "loc_trait_description_combatsword_p1_m1_finesse_perk"
	},
	combatsword_p1_m1_cleave_targets_perk = {
		description = "loc_trait_description_combatsword_p1_m1_cleave_targets_perk",
		display_name = "loc_trait_display_combatsword_p1_m1_cleave_targets_perk",
		damage = {
			action_left_light = {
				damage_trait_templates.combatsword_cleave_targets_perk
			},
			action_left_heavy = {
				damage_trait_templates.combatsword_cleave_targets_perk
			},
			action_right_light = {
				damage_trait_templates.combatsword_cleave_targets_perk
			},
			action_right_heavy = {
				damage_trait_templates.combatsword_cleave_targets_perk
			},
			action_right_light_pushfollow = {
				damage_trait_templates.combatsword_cleave_targets_perk
			}
		}
	},
	combatsword_p1_m1_mobility_perk = {
		description = "loc_trait_description_combatsword_p1_m1_mobility_perk",
		display_name = "loc_trait_display_combatsword_p1_m1_mobility_perk",
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_perk
			}
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_perk
			}
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_perk
			}
		}
	}
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_very_fast_attack"
	},
	{
		display_name = "loc_weapon_keyword_ninja_fencer"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_ninja_fencer",
		type = "ninja_fencer",
		attack_chain = {
			"ninja_fencer",
			"ninja_fencer",
			"ninja_fencer",
			"ninja_fencer"
		}
	},
	secondary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"smiter",
			"linsman"
		}
	},
	special = {
		display_name = "loc_weapon_special_special_attack",
		type = "melee"
	}
}

return weapon_template
