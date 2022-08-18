local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local DefaultMeleeActionInputSetup = require("scripts/settings/equipment/weapon_templates/default_melee_action_input_setup")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTraitsMeleeActivated = require("scripts/settings/equipment/weapon_traits/weapon_traits_melee_activated")
local WeaponTraitsMeleeCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_melee_common")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local hit_zone_names = HitZone.hit_zone_names
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
local wounds_shapes = WoundsSettings.shapes
local weapon_template = {
	action_inputs = table.clone(DefaultMeleeActionInputSetup.action_inputs),
	action_input_hierarchy = table.clone(DefaultMeleeActionInputSetup.action_input_hierarchy)
}
local chain_sword_sweep_box = {
	0.1,
	0.1,
	1.1
}
local melee_sticky_disallowed_hit_zones = {}
local melee_sticky_heavy_attack_disallowed_armor_types = {}
local hit_zone_priority = {
	[hit_zone_names.head] = 1,
	[hit_zone_names.torso] = 1,
	[hit_zone_names.upper_left_arm] = 2,
	[hit_zone_names.upper_right_arm] = 2,
	[hit_zone_names.upper_left_leg] = 2,
	[hit_zone_names.upper_right_leg] = 2
}

table.add_missing(hit_zone_priority, default_hit_zone_priority)

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
		uninterruptible = true,
		kind = "wield",
		sprint_ready_up_time = 0,
		continue_sprinting = true,
		allowed_during_sprint = true,
		anim_event = "equip",
		total_time = 0.3,
		powered_weapon_intensity = {
			start_intensity = 0.1
		},
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.3
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
				action_name = "action_melee_start_left"
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_toggle_special"
			}
		}
	},
	action_melee_start_left = {
		chain_anim_event = "heavy_charge_left_diagonal_down",
		start_input = "start_attack",
		kind = "windup",
		anim_event_3p = "attack_swing_charge_down_left",
		chain_anim_event_3p = "attack_swing_charge_down_left",
		anim_end_event = "attack_finished",
		allowed_during_sprint = true,
		anim_event = "heavy_charge_left_diagonal_down",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05
			},
			{
				modifier = 0.65,
				t = 0.1
			},
			{
				modifier = 0.5,
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
			start_modifier = 1
		},
		powered_weapon_intensity = {
			{
				intensity = 0.3,
				t = 0.15
			},
			{
				intensity = 0.4,
				t = 0.25
			},
			{
				intensity = 0.45,
				t = 0.3
			},
			{
				intensity = 0.5,
				t = 0.65
			},
			{
				intensity = 0.55,
				t = 1.25
			},
			{
				intensity = 0.65,
				t = 2
			},
			{
				intensity = 0.8,
				t = 2.5
			},
			start_intensity = 0.3
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
				chain_time = 0
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.6
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_toggle_special"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_left_down_light = {
		damage_window_start = 0.3,
		power_level = 500,
		allowed_during_sprint = true,
		kind = "sweep",
		max_num_saved_entries = 20,
		range_mod = 1.25,
		first_person_hit_anim = "hit_left_shake",
		num_frames_before_process = 0,
		hit_armor_anim = "attack_hit_shield",
		damage_window_end = 0.4,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_left_diagonal",
		anim_event = "attack_left_down",
		weapon_handling_template = "time_scale_1",
		attack_direction_override = "push",
		uninterruptible = true,
		hit_stop_anim = "hit_stop",
		total_time = 1.3,
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2
			},
			{
				modifier = 0.8,
				t = 0.35
			},
			{
				modifier = 0.5,
				t = 0.5
			},
			{
				modifier = 0.45,
				t = 0.55
			},
			{
				modifier = 0.65,
				t = 0.6
			},
			{
				modifier = 0.7,
				t = 1
			},
			{
				modifier = 1,
				t = 1.3
			},
			start_modifier = 1.1
		},
		powered_weapon_intensity = {
			{
				intensity = 0.5,
				t = 0.25
			},
			{
				intensity = 0.6,
				t = 0.4
			},
			{
				intensity = 0.3,
				t = 0.5
			},
			{
				intensity = 0.2,
				t = 1
			},
			start_intensity = 0.2
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
				chain_time = 0.45
			},
			special_action = {
				action_name = "action_toggle_special",
				chain_time = 0.45
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = chain_sword_sweep_box,
		hit_stickyness_settings = {
			stickyness_vfx_loop_alias = "melee_sticky_loop",
			start_anim_event = "attack_hit_stick",
			stop_anim_event = "yank_out",
			stickyness_sfx_loop_alias = "melee_sticky_loop",
			sensitivity_modifier = 0.1,
			disallow_chain_actions = true,
			duration = 1,
			damage = {
				instances = 3,
				damage_profile = DamageProfileTemplates.light_chainsword_sticky,
				damage_type = damage_types.sawing_stuck,
				last_damage_profile = DamageProfileTemplates.light_chainsword_sticky_last
			},
			disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
			disallow_dodging = {},
			movement_curve = {
				{
					modifier = 0.3,
					t = 0.5
				},
				{
					modifier = 0.45,
					t = 0.55
				},
				{
					modifier = 0.65,
					t = 0.6
				},
				{
					modifier = 0.7,
					t = 1
				},
				{
					modifier = 1,
					t = 1.3
				},
				start_modifier = 0.1
			}
		},
		hit_zone_priority = hit_zone_priority,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/chain_sword/attack_left_down",
			anchor_point_offset = {
				0.1,
				0,
				0
			}
		},
		damage_profile_on_abort = DamageProfileTemplates.default_light_chainsword,
		damage_type_on_abort = damage_types.sawing,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		},
		damage_profile = DamageProfileTemplates.default_light_chainsword,
		damage_type = damage_types.sawing,
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		wounds_shape_special_active = wounds_shapes.default,
		damage_profile_special_active = DamageProfileTemplates.light_chainsword_active,
		damage_type_special_active = damage_types.sawing_stuck
	},
	action_left_heavy = {
		power_level = 500,
		kind = "sweep",
		max_num_saved_entries = 20,
		allowed_during_sprint = true,
		num_frames_before_process = 0,
		first_person_hit_anim = "hit_left_shake",
		range_mod = 1.25,
		hit_armor_anim = "attack_hit_shield",
		damage_window_start = 0.2,
		damage_window_end = 0.4,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_heavy_down_left",
		anim_event = "heavy_attack_left_diagonal_down",
		weapon_handling_template = "time_scale_0_9",
		hit_stop_anim = "hit_stop",
		total_time = 1,
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
		powered_weapon_intensity = {
			{
				intensity = 0,
				t = 0.25
			},
			start_intensity = 1
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
				chain_time = 0.5
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_toggle_special"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_stickyness_settings = {
			stickyness_vfx_loop_alias = "melee_sticky_loop",
			start_anim_event = "attack_hit_stick",
			stickyness_sfx_loop_alias = "melee_sticky_loop",
			stop_anim_event = "yank_out",
			sensitivity_modifier = 0.1,
			disallow_chain_actions = true,
			duration = 1,
			damage = {
				instances = 3,
				damage_profile = DamageProfileTemplates.heavy_chainsword_sticky,
				damage_type = damage_types.sawing_stuck,
				last_damage_profile = DamageProfileTemplates.heavy_chainsword_sticky_last
			},
			disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
			disallowed_armor_types = melee_sticky_heavy_attack_disallowed_armor_types,
			disallow_dodging = {},
			movement_curve = {
				{
					modifier = 0.3,
					t = 0.5
				},
				{
					modifier = 0.45,
					t = 0.55
				},
				{
					modifier = 0.5,
					t = 0.6
				},
				{
					modifier = 0.6,
					t = 1
				},
				{
					modifier = 0.5,
					t = 1.3
				},
				start_modifier = 0.1
			}
		},
		hit_zone_priority = hit_zone_priority,
		weapon_box = chain_sword_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/chain_sword/heavy_attack_left_diagonal_down",
			anchor_point_offset = {
				0,
				0,
				-0.075
			}
		},
		damage_profile = DamageProfileTemplates.heavy_chainsword,
		damage_type = damage_types.sawing,
		damage_profile_on_abort = DamageProfileTemplates.heavy_chainsword,
		damage_type_on_abort = damage_types.sawing,
		damage_profile_special_active = DamageProfileTemplates.heavy_chainsword_active,
		damage_type_special_active = damage_types.sawing_stuck,
		wounds_shape_special_active = wounds_shapes.default,
		wounds_shape = wounds_shapes.left_45_slash_coarse,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_melee_start_right = {
		anim_end_event = "attack_finished",
		kind = "windup",
		anim_event_3p = "attack_swing_charge_right",
		anim_event = "heavy_charge_right",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05
			},
			{
				modifier = 0.65,
				t = 0.1
			},
			{
				modifier = 0.5,
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
			start_modifier = 1
		},
		powered_weapon_intensity = {
			{
				intensity = 0.3,
				t = 0.15
			},
			{
				intensity = 0.4,
				t = 0.25
			},
			{
				intensity = 0.45,
				t = 0.3
			},
			{
				intensity = 0.5,
				t = 0.65
			},
			{
				intensity = 0.55,
				t = 1.25
			},
			{
				intensity = 0.65,
				t = 2
			},
			{
				intensity = 0.8,
				t = 2.5
			},
			start_intensity = 0.3
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
				action_name = "action_right_diagonal_light",
				chain_time = 0
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.4
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_toggle_special"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_right_diagonal_light = {
		power_level = 500,
		kind = "sweep",
		max_num_saved_entries = 20,
		first_person_hit_anim = "hit_right_shake",
		num_frames_before_process = 0,
		range_mod = 1.25,
		hit_armor_anim = "attack_hit_shield",
		damage_window_start = 0.43,
		damage_window_end = 0.55,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_right_diagonal",
		anim_event = "attack_right_diagonal_down",
		weapon_handling_template = "time_scale_1_1",
		uninterruptible = true,
		hit_stop_anim = "hit_stop",
		total_time = 1.5,
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2
			},
			{
				modifier = 0.8,
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
				modifier = 0.75,
				t = 0.6
			},
			{
				modifier = 0.8,
				t = 1
			},
			{
				modifier = 1,
				t = 1.3
			},
			start_modifier = 1.1
		},
		powered_weapon_intensity = {
			{
				intensity = 0.5,
				t = 0.25
			},
			{
				intensity = 0.55,
				t = 0.4
			},
			{
				intensity = 0.3,
				t = 0.5
			},
			{
				intensity = 0.2,
				t = 1
			},
			start_intensity = 0.2
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
				chain_time = 0.5
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_toggle_special"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_stickyness_settings = {
			stickyness_vfx_loop_alias = "melee_sticky_loop",
			start_anim_event = "attack_hit_stick",
			stop_anim_event = "yank_out",
			stickyness_sfx_loop_alias = "melee_sticky_loop",
			sensitivity_modifier = 0.1,
			disallow_chain_actions = true,
			duration = 1,
			damage = {
				instances = 3,
				damage_profile = DamageProfileTemplates.light_chainsword_sticky,
				damage_type = damage_types.sawing_stuck,
				last_damage_profile = DamageProfileTemplates.light_chainsword_sticky_last
			},
			disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
			disallow_dodging = {},
			movement_curve = {
				{
					modifier = 0.3,
					t = 0.5
				},
				{
					modifier = 0.45,
					t = 0.55
				},
				{
					modifier = 0.65,
					t = 0.6
				},
				{
					modifier = 0.7,
					t = 1
				},
				{
					modifier = 1,
					t = 1.3
				},
				start_modifier = 0.1
			}
		},
		hit_zone_priority = hit_zone_priority,
		weapon_box = chain_sword_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/chain_sword/attack_right_diagonal_down",
			anchor_point_offset = {
				0.05,
				0,
				-0.05
			}
		},
		damage_profile = DamageProfileTemplates.default_light_chainsword,
		damage_type = damage_types.sawing,
		damage_profile_on_abort = DamageProfileTemplates.default_light_chainsword,
		damage_type_on_abort = damage_types.sawing,
		damage_profile_special_active = DamageProfileTemplates.light_chainsword_active,
		damage_type_special_active = damage_types.sawing_stuck,
		wounds_shape_special_active = wounds_shapes.default,
		wounds_shape = wounds_shapes.right_45_slash_coarse,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_right_heavy = {
		damage_window_start = 0.2,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1",
		range_mod = 1.25,
		kind = "sweep",
		first_person_hit_anim = "hit_left_shake",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		damage_window_end = 0.35,
		anim_end_event = "attack_finished",
		power_level = 500,
		anim_event_3p = "attack_swing_heavy_right",
		anim_event = "heavy_attack_right",
		hit_stop_anim = "hit_stop",
		total_time = 1,
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
		powered_weapon_intensity = {
			{
				intensity = 0,
				t = 0.25
			},
			start_intensity = 1
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
				chain_time = 0.35
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.35
			},
			special_action = {
				action_name = "action_toggle_special",
				chain_time = 0.35
			}
		},
		hit_stickyness_settings = {
			stickyness_vfx_loop_alias = "melee_sticky_loop",
			start_anim_event = "attack_hit_stick",
			stickyness_sfx_loop_alias = "melee_sticky_loop",
			stop_anim_event = "yank_out",
			sensitivity_modifier = 0.1,
			disallow_chain_actions = true,
			duration = 1,
			damage = {
				instances = 3,
				damage_profile = DamageProfileTemplates.heavy_chainsword_sticky,
				damage_type = damage_types.sawing_stuck,
				last_damage_profile = DamageProfileTemplates.heavy_chainsword_sticky_last
			},
			disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
			disallowed_armor_types = melee_sticky_heavy_attack_disallowed_armor_types,
			disallow_dodging = {},
			movement_curve = {
				{
					modifier = 0.3,
					t = 0.5
				},
				{
					modifier = 0.45,
					t = 0.55
				},
				{
					modifier = 0.65,
					t = 0.6
				},
				{
					modifier = 0.7,
					t = 1
				},
				{
					modifier = 1,
					t = 1.3
				},
				start_modifier = 0.1
			}
		},
		hit_zone_priority = hit_zone_priority,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = chain_sword_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/chain_sword/heavy_attack_right",
			anchor_point_offset = {
				0,
				0,
				-0.075
			}
		},
		damage_profile = DamageProfileTemplates.heavy_chainsword,
		damage_type = damage_types.sawing,
		damage_profile_on_abort = DamageProfileTemplates.heavy_chainsword,
		damage_type_on_abort = damage_types.sawing,
		damage_profile_special_active = DamageProfileTemplates.heavy_chainsword_active,
		damage_type_special_active = damage_types.sawing_stuck,
		wounds_shape_special_active = wounds_shapes.default,
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_melee_start_left_2 = {
		chain_anim_event = "heavy_charge_left_diagonal_down",
		chain_anim_event_3p = "attack_swing_charge_left",
		kind = "windup",
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_charge_left",
		anim_event = "heavy_charge_left_diagonal_down",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05
			},
			{
				modifier = 0.65,
				t = 0.1
			},
			{
				modifier = 0.5,
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
			start_modifier = 1
		},
		powered_weapon_intensity = {
			{
				intensity = 0.3,
				t = 0.15
			},
			{
				intensity = 0.4,
				t = 0.25
			},
			{
				intensity = 0.45,
				t = 0.3
			},
			{
				intensity = 0.5,
				t = 0.65
			},
			{
				intensity = 0.55,
				t = 1.25
			},
			{
				intensity = 0.65,
				t = 2
			},
			{
				intensity = 0.8,
				t = 2.5
			},
			start_intensity = 0.3
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
				chain_time = 0.6
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_toggle_special"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_left_light = {
		power_level = 500,
		kind = "sweep",
		max_num_saved_entries = 20,
		first_person_hit_anim = "hit_left_shake",
		num_frames_before_process = 0,
		range_mod = 1.25,
		hit_armor_anim = "attack_hit_shield",
		damage_window_start = 0.32,
		damage_window_end = 0.45,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_left",
		anim_event = "attack_left",
		weapon_handling_template = "time_scale_1_1",
		uninterruptible = true,
		hit_stop_anim = "hit_stop",
		total_time = 1.3,
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2
			},
			{
				modifier = 0.8,
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
				modifier = 0.75,
				t = 0.6
			},
			{
				modifier = 0.8,
				t = 1
			},
			{
				modifier = 1,
				t = 1.3
			},
			start_modifier = 1.1
		},
		powered_weapon_intensity = {
			{
				intensity = 0.25,
				t = 0.2
			},
			{
				intensity = 0.5,
				t = 0.25
			},
			{
				intensity = 0.55,
				t = 0.5
			},
			{
				intensity = 0.3,
				t = 0.65
			},
			{
				intensity = 0.2,
				t = 1
			},
			start_intensity = 0.2
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
				chain_time = 0.45
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_toggle_special"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_stickyness_settings = {
			stickyness_vfx_loop_alias = "melee_sticky_loop",
			start_anim_event = "attack_hit_stick",
			stop_anim_event = "yank_out",
			stickyness_sfx_loop_alias = "melee_sticky_loop",
			sensitivity_modifier = 0.1,
			disallow_chain_actions = true,
			duration = 1,
			damage = {
				instances = 3,
				damage_profile = DamageProfileTemplates.light_chainsword_sticky,
				damage_type = damage_types.sawing_stuck,
				last_damage_profile = DamageProfileTemplates.light_chainsword_sticky_last
			},
			disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
			disallow_dodging = {},
			movement_curve = {
				{
					modifier = 0.3,
					t = 0.5
				},
				{
					modifier = 0.45,
					t = 0.55
				},
				{
					modifier = 0.65,
					t = 0.6
				},
				{
					modifier = 0.7,
					t = 1
				},
				{
					modifier = 1,
					t = 1.3
				},
				start_modifier = 0.1
			}
		},
		hit_zone_priority = hit_zone_priority,
		weapon_box = chain_sword_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/chain_sword/attack_left",
			anchor_point_offset = {
				0,
				0,
				-0.1
			}
		},
		damage_profile = DamageProfileTemplates.default_light_chainsword,
		damage_type = damage_types.sawing,
		damage_profile_on_abort = DamageProfileTemplates.default_light_chainsword,
		damage_type_on_abort = damage_types.sawing,
		damage_profile_special_active = DamageProfileTemplates.light_chainsword_active,
		damage_type_special_active = damage_types.sawing_stuck,
		wounds_shape_special_active = wounds_shapes.default,
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_melee_start_right_2 = {
		anim_end_event = "attack_finished",
		kind = "windup",
		anim_event_3p = "attack_swing_charge_down_right",
		anim_event = "heavy_charge_right_diagonal_down",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05
			},
			{
				modifier = 0.65,
				t = 0.1
			},
			{
				modifier = 0.5,
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
			start_modifier = 1
		},
		powered_weapon_intensity = {
			{
				intensity = 0.3,
				t = 0.15
			},
			{
				intensity = 0.4,
				t = 0.25
			},
			{
				intensity = 0.45,
				t = 0.3
			},
			{
				intensity = 0.5,
				t = 0.65
			},
			{
				intensity = 0.55,
				t = 1.25
			},
			{
				intensity = 0.65,
				t = 2
			},
			{
				intensity = 0.8,
				t = 2.5
			},
			start_intensity = 0.3
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
				chain_time = 0
			},
			heavy_attack = {
				action_name = "action_right_heavy_2",
				chain_time = 0.65
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_toggle_special"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_right_down_light = {
		power_level = 500,
		kind = "sweep",
		max_num_saved_entries = 20,
		first_person_hit_anim = "hit_left_shake",
		num_frames_before_process = 0,
		hit_armor_anim = "attack_hit_shield",
		damage_window_start = 0.32,
		damage_window_end = 0.5,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_right_diagonal",
		anim_event = "attack_right_down",
		range_mod = 1.25,
		weapon_handling_template = "time_scale_1_1",
		attack_direction_override = "push",
		uninterruptible = true,
		hit_stop_anim = "hit_stop",
		total_time = 1.5,
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2
			},
			{
				modifier = 1.3,
				t = 0.25
			},
			{
				modifier = 0.5,
				t = 0.35
			},
			{
				modifier = 0.7,
				t = 0.55
			},
			{
				modifier = 0.65,
				t = 0.6
			},
			{
				modifier = 0.7,
				t = 1
			},
			{
				modifier = 1,
				t = 1.3
			},
			start_modifier = 1.25
		},
		powered_weapon_intensity = {
			{
				intensity = 0.45,
				t = 0.25
			},
			{
				intensity = 0.5,
				t = 0.4
			},
			{
				intensity = 0.3,
				t = 0.5
			},
			{
				intensity = 0.2,
				t = 1
			},
			start_intensity = 0.2
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
				chain_time = 0.65
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_toggle_special"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_stickyness_settings = {
			stickyness_vfx_loop_alias = "melee_sticky_loop",
			start_anim_event = "attack_hit_stick",
			stop_anim_event = "yank_out",
			stickyness_sfx_loop_alias = "melee_sticky_loop",
			sensitivity_modifier = 0.1,
			disallow_chain_actions = true,
			duration = 1,
			damage = {
				instances = 3,
				damage_profile = DamageProfileTemplates.light_chainsword_sticky,
				damage_type = damage_types.sawing_stuck,
				last_damage_profile = DamageProfileTemplates.light_chainsword_sticky_last
			},
			disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
			disallow_dodging = {},
			movement_curve = {
				{
					modifier = 0.3,
					t = 0.5
				},
				{
					modifier = 0.45,
					t = 0.55
				},
				{
					modifier = 0.65,
					t = 0.6
				},
				{
					modifier = 0.7,
					t = 1
				},
				{
					modifier = 1,
					t = 1.3
				},
				start_modifier = 0.1
			}
		},
		hit_zone_priority = hit_zone_priority,
		weapon_box = chain_sword_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/chain_sword/attack_right_down",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.default_light_chainsword,
		damage_type = damage_types.sawing,
		damage_profile_on_abort = DamageProfileTemplates.default_light_chainsword,
		damage_type_on_abort = damage_types.sawing,
		damage_profile_special_active = DamageProfileTemplates.light_chainsword_active,
		damage_type_special_active = damage_types.sawing_stuck,
		wounds_shape_special_active = wounds_shapes.default,
		wounds_shape = wounds_shapes.right_45_slash_coarse,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_right_heavy_2 = {
		damage_window_start = 0.2,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_0_8",
		range_mod = 1.25,
		kind = "sweep",
		first_person_hit_anim = "hit_left_shake",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		damage_window_end = 0.35,
		anim_end_event = "attack_finished",
		power_level = 500,
		anim_event_3p = "attack_swing_heavy_down_right",
		anim_event = "heavy_attack_right_diagonal_down",
		hit_stop_anim = "hit_stop",
		total_time = 1,
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
		powered_weapon_intensity = {
			{
				intensity = 0,
				t = 0.25
			},
			start_intensity = 1
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
				action_name = "action_melee_start_left",
				chain_time = 0.7
			},
			block = {
				action_name = "action_block",
				chain_time = 0.3
			},
			special_action = {
				action_name = "action_toggle_special",
				chain_time = 0.3
			}
		},
		hit_stickyness_settings = {
			stickyness_vfx_loop_alias = "melee_sticky_loop",
			start_anim_event = "attack_hit_stick",
			stickyness_sfx_loop_alias = "melee_sticky_loop",
			stop_anim_event = "yank_out",
			sensitivity_modifier = 0.1,
			disallow_chain_actions = true,
			duration = 1,
			damage = {
				instances = 3,
				damage_profile = DamageProfileTemplates.heavy_chainsword_sticky,
				damage_type = damage_types.sawing_stuck,
				last_damage_profile = DamageProfileTemplates.heavy_chainsword_sticky_last
			},
			disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
			disallowed_armor_types = melee_sticky_heavy_attack_disallowed_armor_types,
			disallow_dodging = {},
			movement_curve = {
				{
					modifier = 0.3,
					t = 0.5
				},
				{
					modifier = 0.45,
					t = 0.55
				},
				{
					modifier = 0.65,
					t = 0.6
				},
				{
					modifier = 0.7,
					t = 1
				},
				{
					modifier = 1,
					t = 1.3
				},
				start_modifier = 0.1
			}
		},
		hit_zone_priority = hit_zone_priority,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = chain_sword_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/chain_sword/heavy_attack_right_diagonal_down",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.heavy_chainsword,
		damage_type = damage_types.sawing,
		damage_profile_on_abort = DamageProfileTemplates.heavy_chainsword,
		damage_type_on_abort = damage_types.sawing,
		damage_profile_special_active = DamageProfileTemplates.heavy_chainsword_active,
		damage_type_special_active = damage_types.sawing_stuck,
		wounds_shape_special_active = wounds_shapes.default,
		wounds_shape = wounds_shapes.right_45_slash_coarse,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
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
		powered_weapon_intensity = {
			start_intensity = 0
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
				action_name = "action_push"
			},
			special_action = {
				action_name = "action_toggle_special"
			}
		}
	},
	action_right_light_pushfollow = {
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		first_person_hit_anim = "hit_left_shake",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		hit_armor_anim = "attack_hit_shield",
		damage_window_start = 0.27,
		damage_window_end = 0.33,
		anim_end_event = "attack_finished",
		anim_event_3p = "attack_swing_stab",
		anim_event = "attack_stab_01",
		range_mod = 1.35,
		weapon_handling_template = "time_scale_1_1",
		attack_direction_override = "push",
		uninterruptible = true,
		power_level = 500,
		total_time = 1.5,
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
				modifier = 0.45,
				t = 0.45
			},
			{
				modifier = 0.6,
				t = 0.65
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1.4
		},
		powered_weapon_intensity = {
			{
				intensity = 0.5,
				t = 0.1
			},
			{
				intensity = 0.5,
				t = 0.5
			},
			{
				intensity = 0.3,
				t = 0.7
			},
			{
				intensity = 0.2,
				t = 1.5
			},
			start_intensity = 0.4
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
				chain_time = 0.4
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_stickyness_settings = {
			stickyness_vfx_loop_alias = "melee_sticky_loop",
			start_anim_event = "attack_hit_stick",
			stop_anim_event = "yank_out",
			stickyness_sfx_loop_alias = "melee_sticky_loop",
			sensitivity_modifier = 0.1,
			disallow_chain_actions = true,
			duration = 1,
			damage = {
				instances = 3,
				damage_profile = DamageProfileTemplates.default_light_chainsword_stab_sticky,
				damage_type = damage_types.sawing_stuck,
				last_damage_profile = DamageProfileTemplates.default_light_chainsword_stab_sticky_last
			},
			disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
			disallow_dodging = {},
			movement_curve = {
				{
					modifier = 0.3,
					t = 0.5
				},
				{
					modifier = 0.45,
					t = 0.55
				},
				{
					modifier = 0.65,
					t = 0.6
				},
				{
					modifier = 0.7,
					t = 1
				},
				{
					modifier = 1,
					t = 1.3
				},
				start_modifier = 0.1
			}
		},
		hit_zone_priority = hit_zone_priority,
		weapon_box = chain_sword_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/chain_sword/attack_stab",
			anchor_point_offset = {
				0.2,
				0,
				-0.125
			}
		},
		damage_profile = DamageProfileTemplates.default_light_chainsword_stab,
		damage_type = damage_types.sawing,
		damage_profile_on_abort = DamageProfileTemplates.default_light_chainsword_stab,
		damage_type_on_abort = damage_types.sawing,
		damage_profile_special_active = DamageProfileTemplates.light_chainsword_stab_active,
		damage_type_special_active = damage_types.sawing_stuck,
		herding_template = HerdingTemplates.uppercut,
		wounds_shape_special_active = wounds_shapes.default,
		wounds_shape = wounds_shapes.default,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_push = {
		push_radius = 2.5,
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
				action_name = "action_right_light_pushfollow",
				chain_time = 0.3
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4
			},
			special_action = {
				action_name = "action_toggle_special",
				chain_time = 0.4
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.5
			}
		},
		inner_push_rad = math.pi * 0.6,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.push_test,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.push_test,
		outer_damage_type = damage_types.physical,
		stat_buff_keywords = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_toggle_special = {
		kind = "toogle_special",
		anim_event = "activate",
		start_input = "special_action",
		allowed_during_sprint = true,
		activation_time = 0.3,
		skip_3p_anims = false,
		total_time = 0.6
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
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/chain_sword"
weapon_template.weapon_box = chain_sword_sweep_box
weapon_template.chain_speed_settings = {
	time_until_max_throttle = 0.3,
	time_until_min_throttle = 2.1,
	intensity_epsilon = 0.01,
	animation = {
		max = 100,
		min = 1
	},
	sound = {
		max = 1,
		min = 0
	}
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.ammo_template = "no_ammo"
weapon_template.allow_sprinting_with_special = true
weapon_template.weapon_special_class = "WeaponSpecialDeactivateAfterNumActivations"
weapon_template.weapon_special_tweak_data = {
	active_duration = 4,
	num_activations = 1
}
weapon_template.fx_sources = {
	_sticky = "fx_sawing",
	_special_active = "fx_weapon_special",
	_engine = "fx_engine",
	_block = "fx_block",
	_sweep = "fx_sweep"
}
weapon_template.crosshair_type = "dot"
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"melee",
	"chain_sword",
	"p1"
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "chainsword_p1_m1"
weapon_template.footstep_intervals = {
	crouch_walking = 0.4,
	walking = 0.34,
	sprinting = 0.35
}
weapon_template.overclocks = {
	armor_pierce_up_dps_down = {
		chainsword_p1_m1_armor_pierce_stat = 0.1,
		chainsword_p1_m1_dps_stat = -0.1
	},
	finesse_up_armor_pierce_down = {
		chainsword_p1_m1_finesse_stat = 0.2,
		chainsword_p1_m1_armor_pierce_stat = -0.2
	},
	first_target_up_armor_pierce_down = {
		chainsword_p1_m1_armor_pierce_stat = -0.1,
		chainsword_p1_m1_first_target_stat = 0.1
	},
	mobility_up_first_target_down = {
		chainsword_p1_m1_first_target_stat = -0.1,
		chainsword_p1_m1_mobility_stat = 0.1
	},
	dps_up_mobility_down = {
		chainsword_p1_m1_mobility_stat = -0.1,
		chainsword_p1_m1_dps_stat = 0.1
	}
}
weapon_template.base_stats = {
	chainsword_p1_m1_dps_stat = {
		description = "loc_trait_description_chainsword_p1_m1_dps_stat",
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_left_heavy = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_right_diagonal_light = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_left_light = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_right_down_light = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_right_heavy_2 = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_dps_stat
			}
		}
	},
	chainsword_p1_m1_armor_pierce_stat = {
		description = "loc_trait_description_chainsword_p1_m1_armor_pierce_stat",
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_left_heavy = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_diagonal_light = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_heavy = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_left_light = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_down_light = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_heavy_2 = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_armor_pierce_stat
			}
		}
	},
	chainsword_p1_m1_finesse_stat = {
		description = "loc_trait_description_chainsword_p1_m1_finesse_stat",
		display_name = "loc_stats_display_finesse_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_left_heavy = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_right_diagonal_light = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_left_light = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_right_down_light = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_right_heavy_2 = {
				damage_trait_templates.default_melee_finesse_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_finesse_stat
			}
		},
		weapon_handling = {
			action_left_down_light = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_left_heavy = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_right_diagonal_light = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_right_heavy = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_left_light = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_right_down_light = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_right_heavy_2 = {
				weapon_handling_trait_templates.default_finesse_stat
			},
			action_right_light_pushfollow = {
				weapon_handling_trait_templates.default_finesse_stat
			}
		}
	},
	chainsword_p1_m1_first_target_stat = {
		description = "loc_trait_description_chainsword_p1_m1_first_target_stat",
		display_name = "loc_stats_display_first_target_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_first_target_stat
			},
			action_left_heavy = {
				damage_trait_templates.default_first_target_stat
			},
			action_right_diagonal_light = {
				damage_trait_templates.default_first_target_stat
			},
			action_right_heavy = {
				damage_trait_templates.default_first_target_stat
			},
			action_left_light = {
				damage_trait_templates.default_first_target_stat
			},
			action_right_down_light = {
				damage_trait_templates.default_first_target_stat
			},
			action_right_heavy_2 = {
				damage_trait_templates.default_first_target_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_first_target_stat
			}
		}
	},
	chainsword_p1_m1_mobility_stat = {
		description = "loc_trait_description_chainsword_p1_m1_mobility_stat",
		display_name = "loc_stats_display_mobility_stat",
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

local melee_activated_traits = table.keys(WeaponTraitsMeleeActivated)

table.append(weapon_template.traits, melee_activated_traits)

weapon_template.perks = {
	chainsword_p1_m1_dps_perk = {
		description = "loc_trait_description_chainsword_p1_m1_dps_perk",
		display_name = "loc_trait_display_chainsword_p1_m1_dps_perk",
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_melee_dps_perk
			},
			action_left_heavy = {
				damage_trait_templates.default_melee_dps_perk
			},
			action_right_diagonal_light = {
				damage_trait_templates.default_melee_dps_perk
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_dps_perk
			},
			action_left_light = {
				damage_trait_templates.default_melee_dps_perk
			},
			action_right_down_light = {
				damage_trait_templates.default_melee_dps_perk
			},
			action_right_heavy_2 = {
				damage_trait_templates.default_melee_dps_perk
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_dps_perk
			}
		}
	},
	chainsword_p1_m1_armor_pierce_perk = {
		description = "loc_trait_description_chainsword_p1_m1_armor_pierce_perk",
		display_name = "loc_trait_display_chainsword_p1_m1_armor_pierce_perk",
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_armor_pierce_perk
			},
			action_left_heavy = {
				damage_trait_templates.default_armor_pierce_perk
			},
			action_right_diagonal_light = {
				damage_trait_templates.default_armor_pierce_perk
			},
			action_right_heavy = {
				damage_trait_templates.default_armor_pierce_perk
			},
			action_left_light = {
				damage_trait_templates.default_armor_pierce_perk
			},
			action_right_down_light = {
				damage_trait_templates.default_armor_pierce_perk
			},
			action_right_heavy_2 = {
				damage_trait_templates.default_armor_pierce_perk
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_armor_pierce_perk
			}
		}
	},
	chainsword_p1_m1_finesse_perk = {
		description = "loc_trait_description_chainsword_p1_m1_finesse_perk",
		display_name = "loc_trait_display_chainsword_p1_m1_finesse_perk",
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_melee_finesse_perk
			},
			action_left_heavy = {
				damage_trait_templates.default_melee_finesse_perk
			},
			action_right_diagonal_light = {
				damage_trait_templates.default_melee_finesse_perk
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_finesse_perk
			},
			action_left_light = {
				damage_trait_templates.default_melee_finesse_perk
			},
			action_right_down_light = {
				damage_trait_templates.default_melee_finesse_perk
			},
			action_right_heavy_2 = {
				damage_trait_templates.default_melee_finesse_perk
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_finesse_perk
			}
		},
		weapon_handling = {
			action_left_down_light = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_left_heavy = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_right_diagonal_light = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_right_heavy = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_left_light = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_right_down_light = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_right_heavy_2 = {
				weapon_handling_trait_templates.default_finesse_perk
			},
			action_right_light_pushfollow = {
				weapon_handling_trait_templates.default_finesse_perk
			}
		}
	},
	chainsword_p1_m1_first_target_perk = {
		description = "loc_trait_description_chainsword_p1_m1_first_target_perk",
		display_name = "loc_trait_display_chainsword_p1_m1_first_target_perk",
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_left_heavy = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_right_diagonal_light = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_left_light = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_right_down_light = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_right_heavy_2 = {
				damage_trait_templates.default_melee_first_target_perk
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_first_target_perk
			}
		}
	},
	chainsword_p1_m1_mobility_perk = {
		description = "loc_trait_description_chainsword_p1_m1_mobility_perk",
		display_name = "loc_trait_display_chainsword_p1_m1_mobility_perk",
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
		display_name = "loc_weapon_keyword_chainsword_p1_m1_description_1",
		icon_type = "crosshair"
	},
	{
		display_name = "loc_weapon_keyword_chainsword_p1_m1_description_2",
		icon_type = "shield"
	},
	{
		display_name = "loc_weapon_keyword_chainsword_p1_m1_description_3",
		icon_type = "shield"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_chainsword_p1_m1_attack_primary",
		type = "ninja_fencer"
	},
	secondary = {
		display_name = "loc_chainsword_p1_m1_attack_secondary",
		type = "ninja_fencer"
	},
	special = {
		display_name = "loc_chainsword_p1_m1_attack_special",
		type = "ninja_fencer"
	}
}

return weapon_template
