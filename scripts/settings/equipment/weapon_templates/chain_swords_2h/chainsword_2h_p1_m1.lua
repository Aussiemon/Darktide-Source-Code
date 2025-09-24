-- chunkname: @scripts/settings/equipment/weapon_templates/chain_swords_2h/chainsword_2h_p1_m1.lua

local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ChainSpeedTemplates = require("scripts/settings/equipment/chain_speed_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
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
local weapon_template = {}

weapon_template.action_inputs = table.clone(MeleeActionInputSetupMid.action_inputs)
weapon_template.action_input_hierarchy = table.clone(MeleeActionInputSetupMid.action_input_hierarchy)
weapon_template.action_inputs.start_attack.buffer_time = 0.5
weapon_template.action_inputs.wield.buffer_time = 0.4

local _force_abort_breed_tags_special_active = {
	"elite",
	"special",
	"monster",
	"captain",
}
local chain_sword_sweep_box = {
	0.1,
	0.1,
	1.15,
}
local melee_sticky_disallowed_hit_zones = {}
local melee_sticky_heavy_attack_disallowed_armor_types = {}
local hit_zone_priority = {
	[hit_zone_names.head] = 1,
	[hit_zone_names.torso] = 2,
	[hit_zone_names.upper_left_arm] = 2,
	[hit_zone_names.upper_right_arm] = 2,
	[hit_zone_names.upper_left_leg] = 2,
	[hit_zone_names.upper_right_leg] = 2,
}

table.add_missing(hit_zone_priority, default_hit_zone_priority)

local hit_stickyness_settings_light_special = {
	always_sticky = true,
	disallow_chain_actions = true,
	duration = 1,
	min_sticky_time = 0.25,
	sensitivity_modifier = 0.1,
	start_anim_event = "attack_hit_stick",
	stop_anim_event = "yank_out",
	damage = {
		instances = 3,
		damage_profile = DamageProfileTemplates.smiter_light_chainsword_2h_sticky,
		damage_type = damage_types.sawing_stuck,
		last_damage_profile = DamageProfileTemplates.smiter_light_chainsword_sticky_last_2h,
		dodge_damage_profile = DamageProfileTemplates.sticky_dodge_push,
	},
	disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
	movement_curve = {
		{
			modifier = 0.3,
			t = 0.5,
		},
		{
			modifier = 0.45,
			t = 0.55,
		},
		{
			modifier = 0.65,
			t = 0.6,
		},
		{
			modifier = 0.7,
			t = 1,
		},
		{
			modifier = 1,
			t = 1.3,
		},
		start_modifier = 0.1,
	},
}
local hit_stickyness_settings_heavy = {
	always_sticky = true,
	disable_vertical_force_view = true,
	disallow_chain_actions = true,
	duration = 0.3,
	min_sticky_time = 0.25,
	sensitivity_modifier = 0.5,
	start_anim_event = "attack_hit_stick",
	stop_anim_event = "yank_out",
	damage = {
		instances = 1,
		damage_profile = DamageProfileTemplates.heavy_chainsword_sticky_2h,
		damage_type = damage_types.sawing_stuck,
		last_damage_profile = DamageProfileTemplates.heavy_chainsword_sticky_quick_last_2h,
	},
	disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
	disallowed_armor_types = melee_sticky_heavy_attack_disallowed_armor_types,
	movement_curve = {
		{
			modifier = 0.3,
			t = 0.5,
		},
		{
			modifier = 0.45,
			t = 0.55,
		},
		{
			modifier = 0.5,
			t = 0.6,
		},
		{
			modifier = 0.6,
			t = 1,
		},
		{
			modifier = 0.5,
			t = 1.3,
		},
		start_modifier = 0.1,
	},
}
local hit_stickyness_settings_heavy_smiter = {
	always_sticky = true,
	disable_vertical_force_view = true,
	disallow_chain_actions = true,
	duration = 0.3,
	min_sticky_time = 0.25,
	sensitivity_modifier = 0.5,
	start_anim_event = "attack_hit_stick",
	stop_anim_event = "yank_out",
	damage = {
		instances = 1,
		damage_profile = DamageProfileTemplates.heavy_chainsword_smiter_sticky_quick_last_2h,
		damage_type = damage_types.sawing_stuck,
		last_damage_profile = DamageProfileTemplates.heavy_chainsword_smiter_sticky_quick_last_2h,
	},
	disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
	disallowed_armor_types = melee_sticky_heavy_attack_disallowed_armor_types,
	movement_curve = {
		{
			modifier = 0.3,
			t = 0.5,
		},
		{
			modifier = 0.45,
			t = 0.55,
		},
		{
			modifier = 0.5,
			t = 0.6,
		},
		{
			modifier = 0.6,
			t = 1,
		},
		{
			modifier = 0.5,
			t = 1.3,
		},
		start_modifier = 0.1,
	},
}
local hit_stickyness_settings_heavy_special = {
	disallow_chain_actions = true,
	duration = 1,
	min_sticky_time = 0.25,
	sensitivity_modifier = 0.1,
	start_anim_event = "attack_hit_stick",
	stop_anim_event = "yank_out",
	damage = {
		instances = 3,
		damage_profile = DamageProfileTemplates.heavy_chainsword_sticky_2h,
		damage_type = damage_types.sawing_stuck,
		last_damage_profile = DamageProfileTemplates.heavy_chainsword_sticky_last_2h,
		dodge_damage_profile = DamageProfileTemplates.sticky_dodge_push,
	},
	disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
	disallowed_armor_types = melee_sticky_heavy_attack_disallowed_armor_types,
	movement_curve = {
		{
			modifier = 0.3,
			t = 0.5,
		},
		{
			modifier = 0.45,
			t = 0.55,
		},
		{
			modifier = 0.5,
			t = 0.6,
		},
		{
			modifier = 0.6,
			t = 1,
		},
		{
			modifier = 0.5,
			t = 1.3,
		},
		start_modifier = 0.1,
	},
}
local hit_stickyness_settings_heavy_smiter_special = {
	disallow_chain_actions = true,
	duration = 1,
	min_sticky_time = 0.25,
	sensitivity_modifier = 0.1,
	start_anim_event = "attack_hit_stick",
	stop_anim_event = "yank_out",
	damage = {
		instances = 3,
		damage_profile = DamageProfileTemplates.heavy_chainsword_smiter_sticky_2h,
		damage_type = damage_types.sawing_stuck,
		last_damage_profile = DamageProfileTemplates.heavy_chainsword_smiter_sticky_last_2h,
		dodge_damage_profile = DamageProfileTemplates.sticky_dodge_push,
	},
	disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
	disallowed_armor_types = melee_sticky_heavy_attack_disallowed_armor_types,
	movement_curve = {
		{
			modifier = 0.3,
			t = 0.5,
		},
		{
			modifier = 0.45,
			t = 0.55,
		},
		{
			modifier = 0.5,
			t = 0.6,
		},
		{
			modifier = 0.6,
			t = 1,
		},
		{
			modifier = 0.5,
			t = 1.3,
		},
		start_modifier = 0.1,
	},
}

weapon_template.actions = {
	action_unwield = {
		allowed_during_sprint = true,
		kind = "unwield",
		start_input = "wield",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
	},
	action_wield = {
		allowed_during_sprint = true,
		anim_event = "equip",
		kind = "wield",
		sprint_ready_up_time = 0,
		total_time = 0.3,
		uninterruptible = true,
		powered_weapon_intensity = {
			start_intensity = 0.2,
		},
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.3,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left",
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_start_special",
			},
		},
	},
	action_melee_start_left = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left",
		chain_anim_event = "heavy_charge_left",
		hit_stop_anim = "hit_stop",
		kind = "windup",
		start_input = "start_attack",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.65,
				t = 0.1,
			},
			{
				modifier = 0.5,
				t = 0.25,
			},
			{
				modifier = 0.65,
				t = 0.4,
			},
			{
				modifier = 0.65,
				t = 0.5,
			},
			{
				modifier = 0.635,
				t = 0.55,
			},
			{
				modifier = 0.3,
				t = 1.2,
			},
			start_modifier = 1,
		},
		powered_weapon_intensity = {
			{
				intensity = 1,
				t = 0.15,
			},
			{
				intensity = 0.25,
				t = 0.25,
			},
			{
				intensity = 0.85,
				t = 0.3,
			},
			{
				intensity = 0.9,
				t = 0.65,
			},
			{
				intensity = 0.5,
				t = 1.25,
			},
			{
				intensity = 0.8,
				t = 2,
			},
			start_intensity = 0.3,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_left_down_light",
				chain_time = 0.1,
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_start_special",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_left_down_light = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_left_down",
		attack_direction_override = "push",
		damage_window_end = 0.4,
		damage_window_start = 0.26666666666666666,
		first_person_hit_anim = "hit_down_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.25,
		total_time = 1.3,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2,
			},
			{
				modifier = 0.7,
				t = 0.35,
			},
			{
				modifier = 0.4,
				t = 0.5,
			},
			{
				modifier = 0.35,
				t = 0.55,
			},
			{
				modifier = 1,
				t = 0.6,
			},
			start_modifier = 1.2,
		},
		powered_weapon_intensity = {
			{
				intensity = 0.75,
				t = 0.25,
			},
			{
				intensity = 0.9,
				t = 0.4,
			},
			{
				intensity = 0.3,
				t = 0.5,
			},
			{
				intensity = 0.2,
				t = 1,
			},
			start_intensity = 0.2,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
			},
			special_action = {
				action_name = "action_start_special",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = chain_sword_sweep_box,
		hit_stickyness_settings_special_active = hit_stickyness_settings_light_special,
		hit_zone_priority = hit_zone_priority,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/2h_chain_sword/attack_down_left",
				anchor_point_offset = {
					0.25,
					0,
					0.25,
				},
			},
		},
		damage_profile = DamageProfileTemplates.smiter_light_chainsword_2h,
		damage_type_on_abort = damage_types.sawing_2h,
		damage_type = damage_types.sawing_2h,
		damage_profile_special_active = DamageProfileTemplates.smiter_light_chainsword_2h_active,
		damage_type_special_active = damage_types.sawing_stuck,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		wounds_shape_special_active = wounds_shapes.vertical_slash_coarse,
		herding_template = HerdingTemplates.smiter_down,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_left_heavy = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left",
		damage_window_end = 0.36666666666666664,
		damage_window_start = 0.16666666666666666,
		first_person_hit_anim = "hit_left_shake",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.25,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15,
			},
			{
				modifier = 1.2,
				t = 0.4,
			},
			{
				modifier = 0.4,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.4,
		},
		powered_weapon_intensity = {
			{
				intensity = 1,
				t = 0.25,
			},
			{
				intensity = 1,
				t = 0.5,
			},
			{
				intensity = 0.2,
				t = 0.7,
			},
			start_intensity = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.45,
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.45,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6,
			},
			special_action = {
				action_name = "action_start_special",
				chain_time = 0.85,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_stickyness_settings = hit_stickyness_settings_heavy,
		hit_stickyness_settings_special_active = hit_stickyness_settings_heavy_special,
		hit_zone_priority = hit_zone_priority,
		weapon_box = chain_sword_sweep_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/2h_chain_sword/heavy_attack_left",
				anchor_point_offset = {
					0,
					0,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.heavy_chainsword_2h,
		damage_type = damage_types.sawing,
		damage_profile_on_abort = DamageProfileTemplates.heavy_chainsword_2h,
		damage_type_on_abort = damage_types.sawing,
		damage_profile_special_active = DamageProfileTemplates.heavy_chainsword_active_2h,
		damage_profile_special_active_on_abort = DamageProfileTemplates.heavy_chainsword_active_abort_2h,
		damage_type_special_active = damage_types.sawing_stuck,
		action_armor_hit_mass_mod = {
			[armor_types.berserker] = 3,
			[armor_types.armored] = 0.75,
		},
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		wounds_shape_special_active = wounds_shapes.horizontal_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_right = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down_right",
		hit_stop_anim = "hit_stop",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.65,
				t = 0.1,
			},
			{
				modifier = 0.5,
				t = 0.25,
			},
			{
				modifier = 0.65,
				t = 0.4,
			},
			{
				modifier = 0.65,
				t = 0.5,
			},
			{
				modifier = 0.635,
				t = 0.55,
			},
			{
				modifier = 0.3,
				t = 1.2,
			},
			start_modifier = 1,
		},
		powered_weapon_intensity = {
			{
				intensity = 0.2,
				t = 0.1,
			},
			{
				intensity = 1,
				t = 0.3,
			},
			{
				intensity = 1,
				t = 1.25,
			},
			{
				intensity = 0.5,
				t = 1.5,
			},
			start_intensity = 0.2,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_right_diagonal_light",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.65,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_start_special",
				chain_time = 0.4,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_right_diagonal_light = {
		anim_end_event = "attack_finished",
		anim_event = "attack_right_diagonal_down",
		attack_direction_override = "right",
		damage_window_end = 0.43333333333333335,
		damage_window_start = 0.3,
		first_person_hit_anim = "hit_right_down_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.25,
		total_time = 1.5,
		uninterruptible = true,
		weapon_handling_template = "time_scale_0_9",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2,
			},
			{
				modifier = 0.7,
				t = 0.35,
			},
			{
				modifier = 0.4,
				t = 0.5,
			},
			{
				modifier = 0.35,
				t = 0.55,
			},
			{
				modifier = 1,
				t = 0.6,
			},
			start_modifier = 1.2,
		},
		powered_weapon_intensity = {
			{
				intensity = 0.5,
				t = 0.25,
			},
			{
				intensity = 0.55,
				t = 0.4,
			},
			{
				intensity = 0.3,
				t = 0.5,
			},
			{
				intensity = 0.2,
				t = 1,
			},
			start_intensity = 0.2,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.71,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.55,
			},
			special_action = {
				action_name = "action_start_special",
				chain_time = 0.55,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_stickyness_settings_special_active = hit_stickyness_settings_light_special,
		hit_zone_priority = hit_zone_priority,
		weapon_box = chain_sword_sweep_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/2h_chain_sword/attack_right_diagonal_down",
				anchor_point_offset = {
					0,
					0,
					-0.15,
				},
			},
		},
		damage_profile = DamageProfileTemplates.default_light_chainsword_2h,
		damage_type = damage_types.sawing_2h,
		damage_profile_on_abort = DamageProfileTemplates.default_light_chainsword_2h,
		damage_type_on_abort = damage_types.sawing_2h,
		damage_profile_special_active = DamageProfileTemplates.light_chainsword_active_2h,
		damage_type_special_active = damage_types.sawing_stuck,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		wounds_shape = wounds_shapes.right_45_slash_coarse,
		wounds_shape_special_active = wounds_shapes.right_45_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_right_heavy = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_right_down",
		attack_direction_override = "push",
		damage_window_end = 0.3333333333333333,
		damage_window_start = 0.2,
		first_person_hit_anim = "hit_down_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		power_level = 525,
		range_mod = 1.25,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15,
			},
			{
				modifier = 1.1,
				t = 0.4,
			},
			{
				modifier = 0.4,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.25,
		},
		powered_weapon_intensity = {
			{
				intensity = 1,
				t = 0.25,
			},
			start_intensity = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.3,
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.7,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.7,
			},
			special_action = {
				action_name = "action_start_special",
				chain_time = 0.7,
			},
		},
		hit_stickyness_settings = hit_stickyness_settings_heavy_smiter,
		hit_stickyness_settings_special_active = hit_stickyness_settings_heavy_smiter_special,
		hit_zone_priority = hit_zone_priority,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = chain_sword_sweep_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/2h_chain_sword/heavy_attack_down_right",
				anchor_point_offset = {
					-0.1,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.heavy_chainsword_2h_smiter,
		damage_type = damage_types.sawing_2h,
		damage_profile_on_abort = DamageProfileTemplates.heavy_chainsword_2h_smiter,
		damage_type_on_abort = damage_types.sawing_2h,
		damage_profile_special_active = DamageProfileTemplates.heavy_chainsword_active_2h_smiter,
		damage_type_special_active = damage_types.sawing_stuck,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		wounds_shape_special_active = wounds_shapes.vertical_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_left_2 = {
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left",
		chain_anim_event = "heavy_charge_left",
		hit_stop_anim = "hit_stop",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2,
			},
			{
				modifier = 0.7,
				t = 0.35,
			},
			{
				modifier = 0.4,
				t = 0.5,
			},
			{
				modifier = 0.35,
				t = 0.55,
			},
			{
				modifier = 1,
				t = 0.6,
			},
			start_modifier = 1.2,
		},
		powered_weapon_intensity = {
			{
				intensity = 0.3,
				t = 0.15,
			},
			{
				intensity = 0.4,
				t = 0.25,
			},
			{
				intensity = 0.45,
				t = 0.3,
			},
			{
				intensity = 0.5,
				t = 0.65,
			},
			{
				intensity = 0.55,
				t = 1.25,
			},
			{
				intensity = 0.65,
				t = 2,
			},
			{
				intensity = 0.8,
				t = 2.5,
			},
			start_intensity = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_left_light",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_left_heavy",
				chain_time = 0.66,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_start_special",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_left_light = {
		anim_end_event = "attack_finished",
		anim_event = "attack_left",
		attack_direction_override = "left",
		damage_window_end = 0.4666666666666667,
		damage_window_start = 0.26666666666666666,
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		power_level = 525,
		range_mod = 1.25,
		total_time = 1.3,
		uninterruptible = true,
		action_movement_curve = {
			{
				modifier = 1.15,
				t = 0.2,
			},
			{
				modifier = 0.7,
				t = 0.35,
			},
			{
				modifier = 0.6,
				t = 0.5,
			},
			{
				modifier = 0.55,
				t = 0.55,
			},
			{
				modifier = 0.6,
				t = 0.6,
			},
			{
				modifier = 0.7,
				t = 1,
			},
			{
				modifier = 1,
				t = 1.3,
			},
			start_modifier = 1,
		},
		powered_weapon_intensity = {
			{
				intensity = 0.25,
				t = 0.2,
			},
			{
				intensity = 0.5,
				t = 0.25,
			},
			{
				intensity = 0.55,
				t = 0.5,
			},
			{
				intensity = 0.3,
				t = 0.65,
			},
			{
				intensity = 0.2,
				t = 1,
			},
			start_intensity = 0.2,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_right_2",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6,
			},
			special_action = {
				action_name = "action_start_special",
				chain_time = 0.4,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_stickyness_settings_special_active = hit_stickyness_settings_light_special,
		hit_zone_priority = hit_zone_priority,
		weapon_box = chain_sword_sweep_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/2h_chain_sword/attack_left",
				anchor_point_offset = {
					0,
					0,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.default_light_chainsword_2h,
		damage_type = damage_types.sawing_2h,
		damage_profile_on_abort = DamageProfileTemplates.default_light_chainsword_2h,
		damage_type_on_abort = damage_types.sawing_2h,
		damage_profile_special_active = DamageProfileTemplates.light_chainsword_active_2h,
		damage_type_special_active = damage_types.sawing_stuck,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		wounds_shape_special_active = wounds_shapes.horizontal_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_right_2 = {
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down_right",
		hit_stop_anim = "hit_stop",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.05,
			},
			{
				modifier = 0.65,
				t = 0.1,
			},
			{
				modifier = 0.5,
				t = 0.25,
			},
			{
				modifier = 0.65,
				t = 0.4,
			},
			{
				modifier = 0.65,
				t = 0.5,
			},
			{
				modifier = 0.635,
				t = 0.55,
			},
			{
				modifier = 0.3,
				t = 1.2,
			},
			start_modifier = 1,
		},
		powered_weapon_intensity = {
			{
				intensity = 0.3,
				t = 0.15,
			},
			{
				intensity = 0.4,
				t = 0.25,
			},
			{
				intensity = 0.45,
				t = 0.3,
			},
			{
				intensity = 0.5,
				t = 0.65,
			},
			{
				intensity = 0.55,
				t = 1.25,
			},
			{
				intensity = 0.65,
				t = 2,
			},
			{
				intensity = 0.8,
				t = 2.5,
			},
			start_intensity = 0.2,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_right_down_light",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_right_heavy",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_start_special",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_right_down_light = {
		anim_end_event = "attack_finished",
		anim_event = "attack_right_down",
		attack_direction_override = "push",
		damage_window_end = 0.5,
		damage_window_start = 0.3,
		first_person_hit_anim = "hit_right_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.25,
		total_time = 1.5,
		uninterruptible = true,
		weapon_handling_template = "time_scale_0_9",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2,
			},
			{
				modifier = 0.7,
				t = 0.35,
			},
			{
				modifier = 0.4,
				t = 0.5,
			},
			{
				modifier = 0.35,
				t = 0.55,
			},
			{
				modifier = 1,
				t = 0.6,
			},
			start_modifier = 1.2,
		},
		powered_weapon_intensity = {
			{
				intensity = 0.45,
				t = 0.25,
			},
			{
				intensity = 0.5,
				t = 0.4,
			},
			{
				intensity = 0.3,
				t = 0.5,
			},
			{
				intensity = 0.2,
				t = 1,
			},
			start_intensity = 0.2,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.55,
			},
			special_action = {
				action_name = "action_start_special",
				chain_time = 0.55,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_stickyness_settings_special_active = hit_stickyness_settings_light_special,
		hit_zone_priority = hit_zone_priority,
		weapon_box = chain_sword_sweep_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/2h_chain_sword/attack_down_right",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.smiter_light_chainsword_2h,
		damage_type = damage_types.sawing_2h,
		damage_profile_on_abort = DamageProfileTemplates.smiter_light_chainsword_2h,
		damage_type_on_abort = damage_types.sawing_2h,
		damage_profile_special_active = DamageProfileTemplates.smiter_light_chainsword_2h_active,
		damage_type_special_active = damage_types.sawing_stuck,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		herding_template = HerdingTemplates.smiter_down,
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		wounds_shape_special_active = wounds_shapes.vertical_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_block = {
		anim_end_event = "parry_finished",
		anim_event = "parry_pose",
		kind = "block",
		minimum_hold_time = 0.3,
		start_input = "block",
		stop_input = "block_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.7,
				t = 0.2,
			},
			{
				modifier = 0.75,
				t = 0.5,
			},
			{
				modifier = 0.65,
				t = 1.5,
			},
			start_modifier = 0.9,
		},
		powered_weapon_intensity = {
			start_intensity = 0,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			push = {
				action_name = "action_push",
			},
			special_action = {
				action_name = "action_start_special",
			},
		},
	},
	action_right_light_pushfollow = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right",
		attack_direction_override = "right",
		damage_window_end = 0.4666666666666667,
		damage_window_start = 0.2833333333333333,
		first_person_hit_anim = "hit_right_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.35,
		total_time = 1.8,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_2",
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15,
			},
			{
				modifier = 1.2,
				t = 0.4,
			},
			{
				modifier = 0.4,
				t = 0.9,
			},
			{
				modifier = 1,
				t = 1.65,
			},
			start_modifier = 1,
		},
		powered_weapon_intensity = {
			{
				intensity = 1,
				t = 0.1,
			},
			{
				intensity = 1,
				t = 0.5,
			},
			{
				intensity = 0.3,
				t = 0.7,
			},
			{
				intensity = 0.2,
				t = 1.5,
			},
			start_intensity = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.8,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.8,
			},
			special_action = {
				action_name = "action_start_special",
				chain_time = 0.8,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_stickyness_settings_special_active = hit_stickyness_settings_light_special,
		hit_zone_priority = hit_zone_priority,
		weapon_box = chain_sword_sweep_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/2h_chain_sword/attack_right",
				anchor_point_offset = {
					0,
					0,
					-0.07,
				},
			},
		},
		damage_profile = DamageProfileTemplates.default_light_chainsword_2h,
		damage_type = damage_types.sawing_2h,
		damage_profile_on_abort = DamageProfileTemplates.default_light_chainsword_2h,
		damage_type_on_abort = damage_types.sawing_2h,
		damage_profile_special_active = DamageProfileTemplates.light_chainsword_active_2h_push_follow,
		damage_type_special_active = damage_types.sawing_stuck,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		wounds_shape_special_active = wounds_shapes.horizontal_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_push = {
		anim_event = "attack_push",
		block_duration = 0.5,
		first_person_hit_anim = "shake_light",
		kind = "push",
		push_radius = 2.5,
		total_time = 1,
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.1,
			},
			{
				modifier = 1,
				t = 0.25,
			},
			{
				modifier = 1,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			push_follow_up = {
				action_name = "action_right_light_pushfollow",
				chain_time = 0.3,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
			start_attack = {
				action_name = "action_melee_start_right_2",
				chain_time = 0.4,
			},
			special_action = {
				action_name = "action_start_special",
				chain_time = 0.4,
			},
		},
		inner_push_rad = math.pi * 0.25,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.default_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.physical,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_start_special = {
		activate_anim_event = "activate",
		activation_time = 0.3,
		allowed_during_sprint = true,
		deactivate_anim_event = "deactivate",
		deactivation_time = 0.1,
		hold_combo = true,
		kind = "toggle_special",
		skip_3p_anims = false,
		start_input = "special_action",
		total_time = 1,
		total_time_deactivate = 0.8,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			block = {
				action_name = "action_block",
				chain_time = 0.65,
			},
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.65,
			},
		},
	},
	action_inspect = {
		anim_end_event = "inspect_end",
		anim_event = "inspect_start",
		kind = "inspect",
		lock_view = true,
		skip_3p_anims = false,
		start_input = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect",
		},
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.traits = {}

local bespoke_chainsword_2h_p1_traits = table.ukeys(WeaponTraitsChainsword2hP1)

table.append(weapon_template.traits, bespoke_chainsword_2h_p1_traits)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/2h_chain_sword"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/2h_chain_sword"
weapon_template.weapon_box = chain_sword_sweep_box
weapon_template.chain_speed_template = ChainSpeedTemplates.chainsword_2h
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.ammo_template = "no_ammo"
weapon_template.weapon_special_class = "WeaponSpecialDeactivateAfterNumActivations"
weapon_template.weapon_special_tweak_data = {
	active_duration = 4,
	keep_active_on_sprint = true,
	keep_active_on_stun = true,
	keep_active_on_vault = true,
	keep_buff_ability_active_on_special = true,
	num_activations = 1,
}
weapon_template.fx_sources = {
	_block = "fx_block",
	_melee_idling = "fx_engine",
	_special_active = "fx_weapon_special",
	_sticky = "fx_sawing",
	_sweep = "fx_sweep",
}
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"melee",
	"chain_sword_2h",
	"p1",
	"activated",
}
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.dodge_template = "smiter"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "smiter"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "chainsword_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.haptic_trigger_template = HapticTriggerTemplates.melee.chainsword_2h

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	chainsword_2h_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_melee_dps_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						targets = {
							{
								power_distribution = {
									attack = {
										display_name = "loc_weapon_stats_display_base_damage",
									},
								},
							},
						},
					},
				},
			},
			action_left_heavy = {
				damage_trait_templates.default_melee_dps_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								power_distribution = {
									attack = {
										display_name = "loc_weapon_stats_display_base_damage",
									},
								},
							},
						},
					},
				},
			},
			action_right_diagonal_light = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_right_heavy = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_left_light = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_right_down_light = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_dps_stat,
			},
		},
	},
	chainsword_2h_armor_pierce_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				damage_trait_templates.default_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						targets = {
							{
								armor_damage_modifier = {
									attack = WeaponBarUIDescriptionTemplates.armor_damage_modifiers,
								},
							},
						},
					},
				},
			},
			action_left_heavy = {
				damage_trait_templates.default_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								armor_damage_modifier = {
									attack = WeaponBarUIDescriptionTemplates.armor_damage_modifiers,
								},
							},
						},
					},
				},
			},
			action_right_diagonal_light = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_right_heavy = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_left_light = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_right_down_light = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_armor_pierce_stat,
			},
		},
	},
	chainsword_2h_cleave_targets_stat = {
		display_name = "loc_stats_display_cleave_targets_stat",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				damage_trait_templates.combatsword_cleave_targets_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_left_heavy = {
				damage_trait_templates.combatsword_cleave_targets_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_right_diagonal_light = {
				damage_trait_templates.combatsword_cleave_targets_stat,
			},
			action_right_heavy = {
				damage_trait_templates.combatsword_cleave_targets_stat,
			},
			action_left_light = {
				damage_trait_templates.combatsword_cleave_targets_stat,
			},
			action_right_down_light = {
				damage_trait_templates.combatsword_cleave_targets_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.combatsword_cleave_targets_stat,
			},
		},
	},
	chainsword_2h_sawing_stat = {
		display_name = "loc_stats_display_first_saw_damage",
		is_stat_trait = true,
		damage = {
			action_left_down_light = {
				overrides = {
					smiter_light_chainsword_2h_sticky = {
						damage_trait_templates.default_melee_dps_stat,
						display_data = {
							prefix = "loc_weapon_action_title_light",
							damage_profile_path = {
								"hit_stickyness_settings_special_active",
								"damage",
								"damage_profile",
							},
							display_stats = {
								targets = {
									{
										power_distribution = {
											attack = {
												display_name = "loc_weapon_stats_display_sawing",
											},
										},
									},
								},
							},
						},
					},
					smiter_light_chainsword_sticky_last_2h = {
						damage_trait_templates.default_melee_dps_stat,
						display_data = {
							prefix = "loc_weapon_action_title_light",
							damage_profile_path = {
								"hit_stickyness_settings_special_active",
								"damage",
								"last_damage_profile",
							},
							display_stats = {
								targets = {
									{
										power_distribution = {
											attack = {
												display_name = "loc_weapon_stats_display_sawing_final",
											},
										},
									},
								},
							},
						},
					},
				},
			},
			action_left_heavy = {
				overrides = {
					heavy_chainsword_sticky_2h = {
						damage_trait_templates.default_melee_dps_stat,
						display_data = {
							prefix = "loc_weapon_action_title_heavy",
							damage_profile_path = {
								"hit_stickyness_settings_special_active",
								"damage",
								"damage_profile",
							},
							display_stats = {
								targets = {
									{
										power_distribution = {
											attack = {
												display_name = "loc_weapon_stats_display_sawing",
											},
										},
									},
								},
							},
						},
					},
					heavy_chainsword_sticky_last_2h = {
						damage_trait_templates.default_melee_dps_stat,
						display_data = {
							prefix = "loc_weapon_action_title_heavy",
							damage_profile_path = {
								"hit_stickyness_settings_special_active",
								"damage",
								"last_damage_profile",
							},
							display_stats = {
								targets = {
									{
										power_distribution = {
											attack = {
												display_name = "loc_weapon_stats_display_sawing_final",
											},
										},
									},
								},
							},
						},
					},
					heavy_chainsword_sticky_quick_last_2h = {
						damage_trait_templates.default_melee_dps_stat,
					},
					heavy_chainsword_smiter_sticky_quick_last_2h = {
						damage_trait_templates.default_melee_dps_stat,
					},
					heavy_chainsword_smiter_sticky_2h = {
						damage_trait_templates.default_melee_dps_stat,
					},
					heavy_chainsword_smiter_sticky_last_2h = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_right_diagonal_light = {
				overrides = {
					smiter_light_chainsword_2h_sticky = {
						damage_trait_templates.default_melee_dps_stat,
					},
					smiter_light_chainsword_sticky_last_2h = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_right_heavy = {
				overrides = {
					heavy_chainsword_sticky_2h = {
						damage_trait_templates.default_melee_dps_stat,
					},
					heavy_chainsword_sticky_last_2h = {
						damage_trait_templates.default_melee_dps_stat,
					},
					heavy_chainsword_sticky_quick_last_2h = {
						damage_trait_templates.default_melee_dps_stat,
					},
					heavy_chainsword_smiter_sticky_quick_last_2h = {
						damage_trait_templates.default_melee_dps_stat,
					},
					heavy_chainsword_smiter_sticky_2h = {
						damage_trait_templates.default_melee_dps_stat,
					},
					heavy_chainsword_smiter_sticky_last_2h = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_left_light = {
				overrides = {
					smiter_light_chainsword_2h_sticky = {
						damage_trait_templates.default_melee_dps_stat,
					},
					smiter_light_chainsword_sticky_last_2h = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_right_down_light = {
				overrides = {
					smiter_light_chainsword_2h_sticky = {
						damage_trait_templates.default_melee_dps_stat,
					},
					smiter_light_chainsword_sticky_last_2h = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
			action_right_light_pushfollow = {
				overrides = {
					smiter_light_chainsword_2h_sticky = {
						damage_trait_templates.default_melee_dps_stat,
					},
					smiter_light_chainsword_sticky_last_2h = {
						damage_trait_templates.default_melee_dps_stat,
					},
				},
			},
		},
	},
	chainsword_2h_mobility_stat = {
		display_name = "loc_stats_display_mobility_stat",
		is_stat_trait = true,
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_heavy_charge",
	},
	{
		description = "loc_weapon_stats_display_sawing_desc",
		display_name = "loc_weapon_keyword_sawing",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"smiter",
			"linesman",
			"linesman",
			"smiter",
		},
	},
	secondary = {
		display_name = "loc_gestalt_linesman",
		type = "linesman",
		attack_chain = {
			"linesman",
			"smiter",
		},
	},
	special = {
		desc = "loc_stats_special_action_powerup_desc",
		display_name = "loc_weapon_special_activate",
		type = "activate",
	},
}
weapon_template.weapon_card_data = {
	main = {
		{
			header = "light",
			icon = "smiter",
			value_func = "primary_attack",
		},
		{
			header = "heavy",
			icon = "linesman",
			value_func = "secondary_attack",
		},
	},
	weapon_special = {
		header = "activate",
		icon = "activate",
	},
}

return weapon_template
