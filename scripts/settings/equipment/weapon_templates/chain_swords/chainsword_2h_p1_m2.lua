local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ChainSpeedTemplates = require("scripts/settings/equipment/chain_speed_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MeleeActionInputSetupMid = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_mid")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsChainsword2hP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_chainsword_2h_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local hit_zone_names = HitZone.hit_zone_names
local template_types = WeaponTweakTemplateSettings.template_types
local wounds_shapes = WoundsSettings.shapes
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local toughness_trait_templates = WeaponTraitTemplates[template_types.toughness]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local weapon_template = {
	action_inputs = table.clone(MeleeActionInputSetupMid.action_inputs),
	action_input_hierarchy = table.clone(MeleeActionInputSetupMid.action_input_hierarchy)
}
local _force_abort_breed_tags_special_active = {
	"elite",
	"special",
	"monster",
	"captain"
}
local _force_abort_breed_tags_quick = {
	"elite",
	"special",
	"monster",
	"captain",
	"roamer"
}
local chain_sword_sweep_box = {
	0.1,
	0.1,
	1.15
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

local hit_stickyness_settings_light = {
	start_anim_event = "attack_hit_stick",
	stop_anim_event = "yank_out",
	sensitivity_modifier = 0.45,
	min_sticky_time = 0.25,
	disallow_chain_actions = true,
	duration = 0.55,
	always_sticky = true,
	damage = {
		instances = 2,
		damage_profile = DamageProfileTemplates.light_chainsword_sticky_2h,
		last_damage_profile = DamageProfileTemplates.light_chainsword_2h_sticky_last_quick,
		damage_type = damage_types.sawing_stuck
	},
	disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
	disallowed_armor_types = melee_sticky_heavy_attack_disallowed_armor_types,
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
}
local hit_stickyness_settings_light_special = {
	start_anim_event = "attack_hit_stick",
	stop_anim_event = "yank_out",
	sensitivity_modifier = 0.1,
	min_sticky_time = 0.25,
	disallow_chain_actions = true,
	duration = 1,
	always_sticky = true,
	damage = {
		instances = 3,
		damage_profile = DamageProfileTemplates.light_chainsword_sticky_2h,
		damage_type = damage_types.sawing_stuck,
		last_damage_profile = DamageProfileTemplates.light_chainsword_sticky_last_2h,
		dodge_damage_profile = DamageProfileTemplates.sticky_dodge_push
	},
	disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
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
}
local hit_stickyness_settings_heavy = {
	start_anim_event = "attack_hit_stick",
	stop_anim_event = "yank_out",
	sensitivity_modifier = 0.5,
	min_sticky_time = 0.25,
	disallow_chain_actions = true,
	duration = 0.4,
	always_sticky = true,
	damage = {
		instances = 3,
		damage_profile = DamageProfileTemplates.heavy_chainsword_smiter_sticky_quick_2h,
		damage_type = damage_types.sawing_stuck,
		last_damage_profile = DamageProfileTemplates.heavy_chainsword_smiter_sticky_quick_last_2h
	},
	disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
	disallowed_armor_types = melee_sticky_heavy_attack_disallowed_armor_types,
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
}
local hit_stickyness_settings_heavy_special = {
	start_anim_event = "attack_hit_stick",
	stop_anim_event = "yank_out",
	sensitivity_modifier = 0.1,
	min_sticky_time = 0.25,
	disallow_chain_actions = true,
	duration = 1,
	damage = {
		instances = 6,
		damage_profile = DamageProfileTemplates.heavy_chainsword_smiter_sticky_2h,
		damage_type = damage_types.sawing_stuck,
		last_damage_profile = DamageProfileTemplates.heavy_chainsword_smiter_sticky_last_2h,
		dodge_damage_profile = DamageProfileTemplates.sticky_dodge_push
	},
	disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
	disallowed_armor_types = melee_sticky_heavy_attack_disallowed_armor_types,
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
}
weapon_template.actions = {
	action_unwield = {
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
		allowed_during_sprint = true,
		anim_event = "equip",
		total_time = 0.3,
		powered_weapon_intensity = {
			start_intensity = 0.2
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
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
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
				action_name = "action_start_special"
			}
		}
	},
	action_melee_start_left = {
		chain_anim_event = "heavy_charge_down_left",
		start_input = "start_attack",
		kind = "windup",
		anim_end_event = "attack_finished",
		allowed_during_sprint = true,
		anim_event = "heavy_charge_down_left",
		hit_stop_anim = "hit_stop",
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
				intensity = 1,
				t = 0.15
			},
			{
				intensity = 0.25,
				t = 0.25
			},
			{
				intensity = 0.85,
				t = 0.3
			},
			{
				intensity = 0.9,
				t = 0.65
			},
			{
				intensity = 0.5,
				t = 1.25
			},
			{
				intensity = 0.8,
				t = 2
			},
			start_intensity = 0.3
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_light_1",
				chain_time = 0.1
			},
			heavy_attack = {
				action_name = "action_heavy_1",
				chain_time = 0.4
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_start_special"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_light_1 = {
		damage_window_start = 0.25,
		max_num_saved_entries = 20,
		kind = "sweep",
		first_person_hit_anim = "hit_left_shake",
		num_frames_before_process = 0,
		damage_window_end = 0.45,
		anim_end_event = "attack_finished",
		anim_event = "attack_left",
		range_mod = 1.25,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_1",
		attack_direction_override = "left",
		allowed_during_sprint = true,
		uninterruptible = true,
		hit_stop_anim = "hit_stop",
		total_time = 1.3,
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2
			},
			{
				modifier = 0.7,
				t = 0.35
			},
			{
				modifier = 0.4,
				t = 0.5
			},
			{
				modifier = 0.35,
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
				modifier = 0.7,
				t = 1.3
			},
			start_modifier = 0.2
		},
		powered_weapon_intensity = {
			{
				intensity = 0.75,
				t = 0.25
			},
			{
				intensity = 0.9,
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
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.76
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5
			},
			special_action = {
				action_name = "action_start_special",
				chain_time = 0.5
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_stickyness_settings_special_active = hit_stickyness_settings_light_special,
		hit_zone_priority = hit_zone_priority,
		weapon_box = chain_sword_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_chain_sword/attack_left",
			anchor_point_offset = {
				0,
				0,
				-0.05
			}
		},
		damage_profile = DamageProfileTemplates.light_chainsword_2h_tank,
		damage_type = damage_types.sawing_2h,
		damage_profile_on_abort = DamageProfileTemplates.light_chainsword_2h_tank,
		damage_type_on_abort = damage_types.sawing_2h,
		damage_profile_special_active = DamageProfileTemplates.light_chainsword_active_2h_cleave,
		damage_type_special_active = damage_types.sawing_stuck,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		herding_template = HerdingTemplates.linesman_left_heavy,
		wounds_shape_special_active = wounds_shapes.default,
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_heavy_1 = {
		damage_window_start = 0.2,
		range_mod = 1.25,
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		damage_window_end = 0.5,
		attack_direction_override = "down",
		anim_event = "heavy_attack_left_down",
		hit_stop_anim = "hit_stop",
		total_time = 1.5,
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15
			},
			{
				modifier = 1.2,
				t = 0.4
			},
			{
				modifier = 0.4,
				t = 0.6
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1
		},
		powered_weapon_intensity = {
			{
				intensity = 1,
				t = 0.25
			},
			{
				intensity = 1,
				t = 0.5
			},
			{
				intensity = 0.2,
				t = 0.7
			},
			start_intensity = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.6
			},
			block = {
				action_name = "action_block",
				chain_time = 0.96
			},
			special_action = {
				action_name = "action_start_special",
				chain_time = 0.4
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_stickyness_settings = hit_stickyness_settings_heavy,
		hit_stickyness_settings_special_active = hit_stickyness_settings_heavy_special,
		hit_zone_priority = hit_zone_priority,
		weapon_box = chain_sword_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_chain_sword/heavy_attack_left_down",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.heavy_chainsword_2h_smiter,
		damage_type = damage_types.sawing_2h,
		damage_profile_on_abort = DamageProfileTemplates.heavy_chainsword_2h_smiter,
		damage_type_on_abort = damage_types.sawing_2h,
		damage_profile_special_active = DamageProfileTemplates.heavy_chainsword_active_2h_smiter,
		damage_type_special_active = damage_types.sawing_stuck,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		wounds_shape_special_active = wounds_shapes.default,
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_melee_start_right = {
		anim_end_event = "attack_finished",
		kind = "windup",
		allowed_during_sprint = true,
		anim_event = "heavy_charge_down_right",
		hit_stop_anim = "hit_stop",
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
				intensity = 0.2,
				t = 0.1
			},
			{
				intensity = 1,
				t = 0.3
			},
			{
				intensity = 1,
				t = 1.25
			},
			{
				intensity = 0.5,
				t = 1.5
			},
			start_intensity = 0.2
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_light_2",
				chain_time = 0
			},
			heavy_attack = {
				action_name = "action_heavy_2",
				chain_time = 0.85
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_start_special",
				chain_time = 0.4
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_light_2 = {
		damage_window_start = 0.2,
		max_num_saved_entries = 20,
		kind = "sweep",
		first_person_hit_anim = "hit_right_shake",
		num_frames_before_process = 0,
		damage_window_end = 0.5,
		anim_end_event = "attack_finished",
		anim_event = "attack_right",
		range_mod = 1.25,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_0_9",
		attack_direction_override = "right",
		allowed_during_sprint = true,
		uninterruptible = true,
		hit_stop_anim = "hit_stop",
		total_time = 1.5,
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2
			},
			{
				modifier = 0.7,
				t = 0.35
			},
			{
				modifier = 0.6,
				t = 0.5
			},
			{
				modifier = 0.5,
				t = 0.55
			},
			{
				modifier = 0.65,
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
			start_modifier = 1
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
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.77
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_start_special",
				chain_time = 0.4
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_stickyness_settings_special_active = hit_stickyness_settings_light_special,
		hit_zone_priority = hit_zone_priority,
		weapon_box = chain_sword_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_chain_sword/attack_right",
			anchor_point_offset = {
				0,
				0,
				-0.1
			}
		},
		damage_profile = DamageProfileTemplates.light_chainsword_2h_tank,
		damage_type = damage_types.sawing_2h,
		damage_profile_on_abort = DamageProfileTemplates.light_chainsword_2h_tank,
		damage_type_on_abort = damage_types.sawing_2h,
		damage_profile_special_active = DamageProfileTemplates.smiter_light_chainsword_2h_active,
		damage_type_special_active = damage_types.sawing_stuck,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		herding_template = HerdingTemplates.linesman_right_heavy,
		wounds_shape_special_active = wounds_shapes.default,
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_heavy_2 = {
		allowed_during_sprint = true,
		kind = "sweep",
		max_num_saved_entries = 20,
		first_person_hit_anim = "hit_right_shake",
		num_frames_before_process = 0,
		hit_armor_anim = "attack_hit_shield",
		damage_window_start = 0.2,
		damage_window_end = 0.35,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_right_down",
		range_mod = 1.25,
		weapon_handling_template = "time_scale_1",
		attack_direction_override = "push",
		hit_stop_anim = "hit_stop",
		total_time = 1.5,
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15
			},
			{
				modifier = 1.1,
				t = 0.4
			},
			{
				modifier = 0.4,
				t = 0.6
			},
			{
				modifier = 1,
				t = 1
			},
			start_modifier = 1
		},
		powered_weapon_intensity = {
			{
				intensity = 1,
				t = 0.25
			},
			start_intensity = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.3
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.7
			},
			block = {
				action_name = "action_block",
				chain_time = 0.96
			},
			special_action = {
				action_name = "action_start_special",
				chain_time = 0.4
			}
		},
		hit_stickyness_settings = hit_stickyness_settings_heavy,
		hit_stickyness_settings_special_active = hit_stickyness_settings_heavy_special,
		hit_zone_priority = hit_zone_priority,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = chain_sword_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_chain_sword/heavy_attack_down_right",
			anchor_point_offset = {
				0,
				0,
				0
			}
		},
		damage_profile = DamageProfileTemplates.heavy_chainsword_2h_smiter,
		damage_type = damage_types.sawing_2h,
		damage_profile_on_abort = DamageProfileTemplates.heavy_chainsword_2h_smiter,
		damage_type_on_abort = damage_types.sawing_2h,
		damage_profile_special_active = DamageProfileTemplates.heavy_chainsword_active_2h_smiter,
		damage_type_special_active = damage_types.sawing_stuck,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		wounds_shape_special_active = wounds_shapes.default,
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_melee_start_left_2 = {
		chain_anim_event = "heavy_charge_down_left",
		anim_end_event = "attack_finished",
		kind = "windup",
		anim_event = "heavy_charge_down_left",
		hit_stop_anim = "hit_stop",
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
			start_intensity = 1
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_light_3",
				chain_time = 0
			},
			heavy_attack = {
				action_name = "action_heavy_1",
				chain_time = 0.76
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_start_special"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_light_3 = {
		damage_window_start = 0.25,
		max_num_saved_entries = 20,
		kind = "sweep",
		first_person_hit_anim = "hit_left_shake",
		num_frames_before_process = 0,
		damage_window_end = 0.45,
		anim_end_event = "attack_finished",
		anim_event = "attack_left",
		range_mod = 1.25,
		hit_armor_anim = "attack_hit_shield",
		weapon_handling_template = "time_scale_0_9",
		attack_direction_override = "left",
		uninterruptible = true,
		hit_stop_anim = "hit_stop",
		total_time = 1.3,
		action_movement_curve = {
			{
				modifier = 1.15,
				t = 0.2
			},
			{
				modifier = 0.7,
				t = 0.35
			},
			{
				modifier = 0.6,
				t = 0.5
			},
			{
				modifier = 0.55,
				t = 0.55
			},
			{
				modifier = 0.6,
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
			start_modifier = 1
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
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right_2",
				chain_time = 0.75
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_start_special",
				chain_time = 0.4
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_stickyness_settings_special_active = hit_stickyness_settings_light_special,
		hit_zone_priority = hit_zone_priority,
		weapon_box = chain_sword_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_chain_sword/attack_left",
			anchor_point_offset = {
				0,
				0,
				-0.05
			}
		},
		damage_profile = DamageProfileTemplates.light_chainsword_2h_tank,
		damage_type = damage_types.sawing_2h,
		damage_profile_on_abort = DamageProfileTemplates.light_chainsword_2h_tank,
		damage_type_on_abort = damage_types.sawing_2h,
		damage_profile_special_active = DamageProfileTemplates.light_chainsword_active_2h,
		damage_type_special_active = damage_types.sawing_stuck,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		herding_template = HerdingTemplates.linesman_left_heavy,
		wounds_shape_special_active = wounds_shapes.default,
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_melee_start_right_2 = {
		anim_end_event = "attack_finished",
		kind = "windup",
		anim_event = "heavy_charge_down_right",
		hit_stop_anim = "hit_stop",
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
			start_intensity = 0.2
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			light_attack = {
				action_name = "action_light_4",
				chain_time = 0
			},
			heavy_attack = {
				action_name = "action_heavy_2",
				chain_time = 0.6
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_start_special"
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end
	},
	action_light_4 = {
		kind = "sweep",
		max_num_saved_entries = 20,
		first_person_hit_anim = "hit_right_up_shake",
		range_mod = 1.25,
		num_frames_before_process = 0,
		hit_armor_anim = "attack_hit_shield",
		damage_window_start = 0.2,
		damage_window_end = 0.45,
		anim_end_event = "attack_finished",
		anim_event = "attack_right_diagonal_up",
		weapon_handling_template = "time_scale_0_8",
		attack_direction_override = "right",
		uninterruptible = true,
		hit_stop_anim = "hit_stop",
		total_time = 1.5,
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.2
			},
			{
				modifier = 1.15,
				t = 0.25
			},
			{
				modifier = 0.5,
				t = 0.35
			},
			{
				modifier = 0.6,
				t = 0.55
			},
			{
				modifier = 0.55,
				t = 0.6
			},
			{
				modifier = 0.6,
				t = 1
			},
			{
				modifier = 1,
				t = 1.3
			},
			start_modifier = 1
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
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.78
			},
			block = {
				action_name = "action_block"
			},
			special_action = {
				action_name = "action_start_special",
				chain_time = 0.4
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_stickyness_settings_special_active = hit_stickyness_settings_light_special,
		hit_zone_priority = hit_zone_priority,
		weapon_box = chain_sword_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_chain_sword/attack_right_up",
			anchor_point_offset = {
				-0.2,
				0,
				-0.16
			}
		},
		damage_profile = DamageProfileTemplates.default_light_chainsword_2h,
		damage_type = damage_types.sawing_2h,
		damage_profile_on_abort = DamageProfileTemplates.default_light_chainsword_2h,
		damage_type_on_abort = damage_types.sawing_2h,
		damage_profile_special_active = DamageProfileTemplates.light_chainsword_active_2h,
		damage_type_special_active = damage_types.sawing_stuck,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		wounds_shape_special_active = wounds_shapes.default,
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		time_scale_stat_buffs = {
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
				modifier = 0.7,
				t = 0.2
			},
			{
				modifier = 0.75,
				t = 0.5
			},
			{
				modifier = 0.65,
				t = 1.5
			},
			start_modifier = 0.9
		},
		powered_weapon_intensity = {
			start_intensity = 0
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			push = {
				action_name = "action_push"
			},
			special_action = {
				action_name = "action_start_special",
				chain_time = 0.4
			}
		}
	},
	action_right_light_pushfollow = {
		kind = "sweep",
		max_num_saved_entries = 20,
		first_person_hit_anim = "hit_right_up_shake",
		sprint_requires_press_to_interrupt = "true",
		num_frames_before_process = 0,
		hit_armor_anim = "attack_hit_shield",
		damage_window_start = 0.4,
		damage_window_end = 0.5,
		anim_end_event = "attack_finished",
		anim_event = "attack_stab_01",
		range_mod = 1.35,
		weapon_handling_template = "time_scale_1_2",
		attack_direction_override = "push",
		uninterruptible = true,
		hit_stop_anim = "hit_stop",
		total_time = 1.8,
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15
			},
			{
				modifier = 1.2,
				t = 0.4
			},
			{
				modifier = 0.4,
				t = 0.9
			},
			{
				modifier = 1,
				t = 1.65
			},
			start_modifier = 1
		},
		powered_weapon_intensity = {
			start_intensity = 0.2
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability"
			},
			grenade_ability = {
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right_2",
				chain_time = 0.8
			},
			block = {
				action_name = "action_block",
				chain_time = 1.5
			},
			special_action = {
				action_name = "action_start_special",
				chain_time = 0.8
			}
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_stickyness_settings = hit_stickyness_settings_light,
		hit_stickyness_settings_special_active = hit_stickyness_settings_light_special,
		hit_zone_priority = hit_zone_priority,
		weapon_box = chain_sword_sweep_box,
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/2h_chain_sword/attack_stab",
			anchor_point_offset = {
				0.07,
				0,
				-0.07
			}
		},
		damage_profile = DamageProfileTemplates.smiter_light_chainsword_2h,
		damage_type = damage_types.sawing_2h,
		damage_profile_on_abort = DamageProfileTemplates.light_chainsword_2h_push_follow,
		damage_type_on_abort = damage_types.sawing_2h,
		damage_profile_special_active = DamageProfileTemplates.light_chainsword_active_2h_push_follow,
		damage_type_special_active = damage_types.sawing_stuck,
		force_abort_breed_tags = _force_abort_breed_tags_quick,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		wounds_shape = wounds_shapes.default,
		wounds_shape_special_active = wounds_shapes.default,
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
				modifier = 1,
				t = 0.1
			},
			{
				modifier = 1,
				t = 0.25
			},
			{
				modifier = 1,
				t = 0.4
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
				{
					action_name = "grenade_ability"
				},
				{
					action_name = "grenade_ability_quick_throw"
				}
			},
			wield = {
				action_name = "action_unwield"
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.52
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
				action_name = "action_start_special",
				chain_time = 0.9
			}
		},
		inner_push_rad = math.pi * 0.25,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.default_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.physical,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed
		}
	},
	action_start_special = {
		deactivate_anim_event = "deactivate",
		total_time_deactivate = 0.45,
		activate_anim_event = "activate",
		activation_time = 0.3,
		kind = "toggle_special",
		start_input = "special_action",
		deactivation_time = 0.1,
		allowed_during_sprint = true,
		skip_3p_anims = false,
		total_time = 0.6
	},
	action_inspect = {
		skip_3p_anims = false,
		lock_view = true,
		start_input = "inspect_start",
		anim_end_event = "inspect_end",
		kind = "inspect",
		anim_event = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect"
		}
	}
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.traits = {}
local bespoke_chainsword_2h_p1_traits = table.ukeys(WeaponTraitsChainsword2hP1)

table.append(weapon_template.traits, bespoke_chainsword_2h_p1_traits)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/2h_power_sword"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/2h_chain_sword"
weapon_template.weapon_box = chain_sword_sweep_box
weapon_template.chain_speed_template = ChainSpeedTemplates.chainsword_2h
weapon_template.uses_ammunition = false
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
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
weapon_template.crosshair = {
	crosshair_type = "dot"
}
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"melee",
	"chain_sword_2h",
	"p1",
	"activated"
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.dodge_template = "smiter"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "smiter"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "chainsword_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")
weapon_template.base_stats = {
	chainsword_2h_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				damage_trait_templates.default_melee_dps_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						targets = {
							{
								power_distribution = {
									attack = {
										display_name = "loc_weapon_stats_display_base_damage"
									}
								}
							}
						}
					}
				}
			},
			action_heavy_1 = {
				damage_trait_templates.default_melee_dps_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								power_distribution = {
									attack = {
										display_name = "loc_weapon_stats_display_base_damage"
									}
								}
							}
						}
					}
				}
			},
			action_light_2 = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_heavy_2 = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_light_3 = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_light_4 = {
				damage_trait_templates.default_melee_dps_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_dps_stat
			}
		}
	},
	chainsword_2h_armor_pierce_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				damage_trait_templates.default_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						targets = {
							{
								armor_damage_modifier = {
									attack = WeaponBarUIDescriptionTemplates.armor_damage_modifiers
								}
							}
						}
					}
				}
			},
			action_heavy_1 = {
				damage_trait_templates.default_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								armor_damage_modifier = {
									attack = WeaponBarUIDescriptionTemplates.armor_damage_modifiers
								}
							}
						}
					}
				}
			},
			action_light_2 = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_heavy_2 = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_light_3 = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_light_4 = {
				damage_trait_templates.default_armor_pierce_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_armor_pierce_stat
			}
		}
	},
	chainsword_2h_cleave_targets_stat = {
		display_name = "loc_stats_display_cleave_targets_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				damage_trait_templates.combatsword_cleave_targets_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						__all_basic_stats = true
					}
				}
			},
			action_heavy_1 = {
				damage_trait_templates.combatsword_cleave_targets_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						__all_basic_stats = true
					}
				}
			},
			action_light_2 = {
				damage_trait_templates.combatsword_cleave_targets_stat
			},
			action_heavy_2 = {
				damage_trait_templates.combatsword_cleave_targets_stat
			},
			action_light_3 = {
				damage_trait_templates.combatsword_cleave_targets_stat
			},
			action_light_4 = {
				damage_trait_templates.combatsword_cleave_targets_stat
			},
			action_right_light_pushfollow = {
				damage_trait_templates.combatsword_cleave_targets_stat
			}
		}
	},
	chainsword_2h_sawing_stat = {
		display_name = "loc_stats_display_first_saw_damage",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				overrides = {
					light_chainsword_sticky_2h = {
						damage_trait_templates.default_melee_dps_stat,
						display_data = {
							prefix = "loc_weapon_action_title_light",
							damage_profile_path = {
								"hit_stickyness_settings_special_active",
								"damage",
								"damage_profile"
							},
							display_stats = {
								targets = {
									{
										power_distribution = {
											attack = {
												display_name = "loc_weapon_stats_display_sawing"
											}
										}
									}
								}
							}
						}
					},
					light_chainsword_sticky_last_2h = {
						damage_trait_templates.default_melee_dps_stat,
						display_data = {
							prefix = "loc_weapon_action_title_light",
							damage_profile_path = {
								"hit_stickyness_settings_special_active",
								"damage",
								"last_damage_profile"
							},
							display_stats = {
								targets = {
									{
										power_distribution = {
											attack = {
												display_name = "loc_weapon_stats_display_sawing_final"
											}
										}
									}
								}
							}
						}
					}
				}
			},
			action_heavy_1 = {
				overrides = {
					heavy_chainsword_smiter_sticky_quick_2h = {
						damage_trait_templates.default_melee_dps_stat
					},
					heavy_chainsword_smiter_sticky_quick_last_2h = {
						damage_trait_templates.default_melee_dps_stat
					},
					heavy_chainsword_smiter_sticky_2h = {
						damage_trait_templates.default_melee_dps_stat,
						display_data = {
							prefix = "loc_weapon_action_title_heavy",
							damage_profile_path = {
								"hit_stickyness_settings_special_active",
								"damage",
								"damage_profile"
							},
							display_stats = {
								targets = {
									{
										power_distribution = {
											attack = {
												display_name = "loc_weapon_stats_display_sawing"
											}
										}
									}
								}
							}
						}
					},
					heavy_chainsword_smiter_sticky_last_2h = {
						damage_trait_templates.default_melee_dps_stat,
						display_data = {
							prefix = "loc_weapon_action_title_heavy",
							damage_profile_path = {
								"hit_stickyness_settings_special_active",
								"damage",
								"last_damage_profile"
							},
							display_stats = {
								targets = {
									{
										power_distribution = {
											attack = {
												display_name = "loc_weapon_stats_display_sawing_final"
											}
										}
									}
								}
							}
						}
					}
				}
			},
			action_light_2 = {
				overrides = {
					light_chainsword_sticky_2h = {
						damage_trait_templates.default_melee_dps_stat
					},
					light_chainsword_sticky_last_2h = {
						damage_trait_templates.default_melee_dps_stat
					}
				}
			},
			action_heavy_2 = {
				overrides = {
					heavy_chainsword_smiter_sticky_quick_2h = {
						damage_trait_templates.default_melee_dps_stat
					},
					heavy_chainsword_smiter_sticky_quick_last_2h = {
						damage_trait_templates.default_melee_dps_stat
					},
					heavy_chainsword_smiter_sticky_2h = {
						damage_trait_templates.default_melee_dps_stat
					},
					heavy_chainsword_smiter_sticky_last_2h = {
						damage_trait_templates.default_melee_dps_stat
					}
				}
			},
			action_light_3 = {
				overrides = {
					light_chainsword_sticky_2h = {
						damage_trait_templates.default_melee_dps_stat
					},
					light_chainsword_sticky_last_2h = {
						damage_trait_templates.default_melee_dps_stat
					}
				}
			},
			action_light_4 = {
				overrides = {
					light_chainsword_sticky_2h = {
						damage_trait_templates.default_melee_dps_stat
					},
					light_chainsword_sticky_last_2h = {
						damage_trait_templates.default_melee_dps_stat
					}
				}
			},
			action_right_light_pushfollow = {
				overrides = {
					light_chainsword_sticky_2h = {
						damage_trait_templates.default_melee_dps_stat
					},
					light_chainsword_sticky_last_2h = {
						damage_trait_templates.default_melee_dps_stat
					}
				}
			}
		}
	},
	chainsword_2h_mobility_stat = {
		display_name = "loc_stats_display_mobility_stat",
		is_stat_trait = true,
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats
			}
		}
	}
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_heavy_charge"
	},
	{
		display_name = "loc_weapon_keyword_sawing",
		description = "loc_weapon_stats_display_sawing_desc"
	}
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_tank",
		type = "tank",
		attack_chain = {
			"tank",
			"tank",
			"tank",
			"linesman"
		}
	},
	secondary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"smiter",
			"smiter"
		}
	},
	special = {
		desc = "loc_stats_special_action_powerup_desc",
		display_name = "loc_weapon_special_activate",
		type = "activate"
	}
}

return weapon_template
