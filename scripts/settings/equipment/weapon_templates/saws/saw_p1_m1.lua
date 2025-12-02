-- chunkname: @scripts/settings/equipment/weapon_templates/saws/saw_p1_m1.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MeleeActionInputSetupMid = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_mid")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeSawP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_saw_p1")
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
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local weapon_template = {}
local action_inputs = table.clone(MeleeActionInputSetupMid.action_inputs)
local action_input_hierarchy = table.clone(MeleeActionInputSetupMid.action_input_hierarchy)

weapon_template.action_inputs = action_inputs
weapon_template.action_input_hierarchy = action_input_hierarchy

local new_start_attack_action_transition = {
	{
		input = "attack_cancel",
		transition = "base",
	},
	{
		input = "light_attack",
		transition = "base",
	},
	{
		input = "heavy_attack",
		transition = "base",
	},
	{
		input = "wield",
		transition = "base",
	},
	{
		input = "grenade_ability",
		transition = "base",
	},
	{
		input = "block",
		transition = "base",
	},
}

ActionInputHierarchy.update_hierarchy_entry(weapon_template.action_input_hierarchy, "start_attack", new_start_attack_action_transition)

weapon_template.action_inputs.start_attack.buffer_time = 0.4
weapon_template.action_inputs.special_action.buffer_time = 0.5
weapon_template.action_inputs.block.buffer_time = 0.1
weapon_template.action_inputs.block_release.buffer_time = 0.35

local default_weapon_box = {
	0.2,
	0.1,
	1.1,
}
local hit_zone_priority = {
	[hit_zone_names.head] = 1,
	[hit_zone_names.torso] = 2,
	[hit_zone_names.upper_left_arm] = 3,
	[hit_zone_names.upper_right_arm] = 3,
	[hit_zone_names.upper_left_leg] = 3,
	[hit_zone_names.upper_right_leg] = 3,
}

table.add_missing(hit_zone_priority, default_hit_zone_priority)

local melee_sticky_disallowed_hit_zones = {
	hit_zone_names.shield,
}
local hit_stickyness_settings_light = {
	always_sticky = true,
	disable_vertical_force_view = true,
	disallow_chain_actions = true,
	disallow_dodging = false,
	dodge_stamina_drain_percentage = 0.2,
	duration = 0.25,
	sensitivity_modifier = 0.1,
	start_anim_event = "attack_hit_stick",
	stop_anim_event = "yank_out",
	damage = {
		instances = 1,
		damage_profile = DamageProfileTemplates.saw_light_sticky_rip,
		damage_type = damage_types.saw_rip_light,
		damage_profile_special_active = DamageProfileTemplates.saw_light_sticky_ap_rip,
		damage_type_special_active = damage_types.saw_rip_light,
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
		start_modifier = 0.15,
	},
}
local hit_stickyness_settings_heavy = {
	always_sticky = true,
	disable_vertical_force_view = true,
	disallow_chain_actions = true,
	disallow_dodging = false,
	dodge_stamina_drain_percentage = 0.35,
	duration = 0.425,
	sensitivity_modifier = 0.1,
	start_anim_event = "attack_hit_stick",
	stop_anim_event = "yank_out",
	damage = {
		instances = 1,
		damage_profile = DamageProfileTemplates.saw_heavy_sticky_rip,
		damage_type = damage_types.saw_rip_heavy,
		damage_profile_special_active = DamageProfileTemplates.saw_heavy_sticky_ap_rip,
		damage_type_special_active = damage_types.saw_rip_heavy,
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
		start_modifier = 0.15,
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
		total_time = 0.5,
		uninterruptible = true,
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
				action_name = "action_special_coating_toggle",
			},
		},
	},
	action_melee_start_left = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down_left",
		anim_event_3p = "attack_swing_charge_left",
		kind = "windup",
		start_input = "start_attack",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.65,
				t = 0.05,
			},
			{
				modifier = 0.7,
				t = 0.1,
			},
			{
				modifier = 0.9,
				t = 0.25,
			},
			{
				modifier = 0.85,
				t = 0.4,
			},
			{
				modifier = 0.85,
				t = 0.5,
			},
			{
				modifier = 0.835,
				t = 0.55,
			},
			{
				modifier = 0.95,
				t = 3,
			},
			start_modifier = 0.75,
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
				action_name = "action_light_1",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_heavy_1",
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_1 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_left_diagonal_down",
		anim_event_3p = "attack_swing_left_diagonal",
		attack_direction_override = "left",
		damage_window_end = 0.4,
		damage_window_start = 0.33,
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.25,
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		start_input = nil,
		total_time = 2,
		weapon_handling_template = "time_scale_1_saw",
		action_movement_curve = {
			{
				modifier = 1.15,
				t = 0.2,
			},
			{
				modifier = 1.05,
				t = 0.35,
			},
			{
				modifier = 0.7,
				t = 0.5,
			},
			{
				modifier = 0.65,
				t = 0.55,
			},
			{
				modifier = 0.65,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 0.7,
			},
			{
				modifier = 1.05,
				t = 0.75,
			},
			{
				modifier = 1.04,
				t = 0.8,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.3,
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
				chain_time = 0,
			},
			special_action = {
				action_name = "action_special_coating_toggle",
				chain_time = 0.65,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/saw/swing_left_diagonal",
				anchor_point_offset = {
					0.35,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.saw_light_linesman,
		damage_type = damage_types.saw_light,
		damage_profile_special_active = DamageProfileTemplates.saw_light_linesman_ap,
		damage_type_special_active = damage_types.saw_light,
		wounds_shape = wounds_shapes.left_45_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_heavy_1 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_down_left",
		anim_event_3p = "attack_swing_heavy_down_left",
		attack_direction_override = "down",
		damage_window_end = 0.34,
		damage_window_start = 0.23,
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.3,
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_saw",
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15,
			},
			{
				modifier = 1.25,
				t = 0.4,
			},
			{
				modifier = 0.5,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.5,
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
				action_name = "action_melee_start_right",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6,
				chain_until = 0.1,
			},
			special_action = {
				action_name = "action_special_coating_toggle",
				chain_time = 0.65,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/saw/heavy_swing_down_left",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		hit_stickyness_settings = hit_stickyness_settings_heavy,
		damage_profile = DamageProfileTemplates.saw_heavy_sticky,
		damage_type = damage_types.saw_heavy,
		damage_profile_special_active = DamageProfileTemplates.saw_heavy_sticky_ap,
		damage_type_special_active = damage_types.saw_heavy,
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_right = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_diagonal",
		anim_event_3p = "attack_swing_charge_right",
		hit_stop_anim = "attack_hit",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.65,
				t = 0.05,
			},
			{
				modifier = 0.7,
				t = 0.1,
			},
			{
				modifier = 0.9,
				t = 0.25,
			},
			{
				modifier = 0.85,
				t = 0.4,
			},
			{
				modifier = 0.85,
				t = 0.5,
			},
			{
				modifier = 0.835,
				t = 0.55,
			},
			{
				modifier = 0.95,
				t = 3,
			},
			start_modifier = 0.75,
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
				action_name = "action_light_2",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_heavy_2",
				chain_time = 0.54,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_down_right",
		anim_event_3p = "attack_swing_right",
		attack_direction_override = "down",
		damage_window_end = 0.36,
		damage_window_start = 0.27,
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.27,
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		start_input = nil,
		total_time = 2,
		weapon_handling_template = "time_scale_1_saw",
		action_movement_curve = {
			{
				modifier = 1.15,
				t = 0.2,
			},
			{
				modifier = 1.05,
				t = 0.35,
			},
			{
				modifier = 0.7,
				t = 0.5,
			},
			{
				modifier = 0.65,
				t = 0.55,
			},
			{
				modifier = 0.65,
				t = 0.6,
			},
			{
				modifier = 0.9,
				t = 0.8,
			},
			{
				modifier = 0.975,
				t = 0.85,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.3,
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
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
				chain_time = 0,
			},
			special_action = {
				action_name = "action_special_coating_toggle",
				chain_time = 0.65,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/saw/swing_down_right",
				anchor_point_offset = {
					0.1,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.saw_light_smiter,
		damage_type = damage_types.saw_light,
		damage_profile_special_active = DamageProfileTemplates.saw_light_smiter_ap,
		damage_type_special_active = damage_types.saw_light,
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_heavy_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_right_diagonal_down",
		anim_event_3p = "attack_swing_heavy_right",
		attack_direction_override = "right",
		damage_window_end = 0.32,
		damage_window_start = 0.21,
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.35,
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_saw",
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15,
			},
			{
				modifier = 1.25,
				t = 0.4,
			},
			{
				modifier = 0.5,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.5,
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
				action_name = "action_melee_start_left",
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45,
				chain_until = 0.05,
			},
			special_action = {
				action_name = "action_special_coating_toggle",
				chain_time = 0.65,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/saw/heavy_swing_right_diagonal",
				anchor_point_offset = {
					0,
					0,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.saw_heavy_linesman,
		damage_type = damage_types.saw_heavy,
		damage_profile_special_active = DamageProfileTemplates.saw_heavy_linesman_ap,
		damage_type_special_active = damage_types.saw_heavy,
		wounds_shape = wounds_shapes.right_45_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_left_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down_left",
		anim_event_3p = "attack_swing_charge_left",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.65,
				t = 0.05,
			},
			{
				modifier = 0.7,
				t = 0.1,
			},
			{
				modifier = 0.9,
				t = 0.25,
			},
			{
				modifier = 0.85,
				t = 0.4,
			},
			{
				modifier = 0.85,
				t = 0.5,
			},
			{
				modifier = 0.835,
				t = 0.55,
			},
			{
				modifier = 0.95,
				t = 3,
			},
			start_modifier = 0.75,
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
				action_name = "action_light_3",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_heavy_1",
				chain_time = 0.56,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_3 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_down_left",
		anim_event_3p = "attack_swing_down_left",
		attack_direction_override = "down",
		damage_window_end = 0.48,
		damage_window_start = 0.36,
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		power_level = 550,
		range_mod = 1.23,
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		start_input = nil,
		total_time = 2,
		weapon_handling_template = "time_scale_1_saw",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2,
			},
			{
				modifier = 1.05,
				t = 0.35,
			},
			{
				modifier = 0.5,
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
				modifier = 0.9,
				t = 0.8,
			},
			{
				modifier = 0.975,
				t = 0.85,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.3,
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
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
				chain_time = 0,
			},
			special_action = {
				action_name = "action_special_coating_toggle",
				chain_time = 0.6,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/saw/swing_down_left",
				anchor_point_offset = {
					0.2,
					0,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.saw_light_smiter,
		damage_type = damage_types.saw_light,
		damage_profile_special_active = DamageProfileTemplates.saw_light_smiter_ap,
		damage_type_special_active = damage_types.saw_light,
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_right_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_diagonal",
		anim_event_3p = "attack_swing_charge_right",
		hit_stop_anim = "attack_hit",
		kind = "windup",
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.65,
				t = 0.05,
			},
			{
				modifier = 0.7,
				t = 0.1,
			},
			{
				modifier = 0.9,
				t = 0.25,
			},
			{
				modifier = 0.85,
				t = 0.4,
			},
			{
				modifier = 0.85,
				t = 0.5,
			},
			{
				modifier = 0.835,
				t = 0.55,
			},
			{
				modifier = 0.95,
				t = 3,
			},
			start_modifier = 0.75,
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
				action_name = "action_light_4",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_heavy_2",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_light_4 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right_diagonal_down",
		anim_event_3p = "attack_swing_right",
		attack_direction_override = "right",
		damage_window_end = 0.5,
		damage_window_start = 0.42,
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		power_level = 550,
		range_mod = 1.3,
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		start_input = nil,
		total_time = 2,
		weapon_handling_template = "time_scale_1_saw",
		action_movement_curve = {
			{
				modifier = 1.15,
				t = 0.2,
			},
			{
				modifier = 1.05,
				t = 0.35,
			},
			{
				modifier = 0.7,
				t = 0.5,
			},
			{
				modifier = 0.65,
				t = 0.55,
			},
			{
				modifier = 0.65,
				t = 0.6,
			},
			{
				modifier = 0.9,
				t = 0.8,
			},
			{
				modifier = 0.975,
				t = 0.85,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.3,
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
				action_name = "action_melee_start_pushfollow_combo",
				chain_time = 0.6,
			},
			block = {
				action_name = "action_block",
				chain_time = 0,
			},
			special_action = {
				action_name = "action_special_coating_toggle",
				chain_time = 0.65,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/saw/swing_right_diagonal",
				anchor_point_offset = {
					-0.15,
					0.2,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.saw_light_linesman,
		damage_type = damage_types.saw_light,
		damage_profile_special_active = DamageProfileTemplates.saw_light_linesman_ap,
		damage_type_special_active = damage_types.saw_light,
		wounds_shape = wounds_shapes.right_45_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_block = {
		anim_end_event = "parry_finished",
		anim_event = "parry_pose",
		kind = "block",
		minimum_hold_time = 0.275,
		start_input = "block",
		stop_input = "block_release",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.2,
			},
			{
				modifier = 0.82,
				t = 0.3,
			},
			{
				modifier = 0.8,
				t = 0.325,
			},
			{
				modifier = 0.81,
				t = 0.35,
			},
			{
				modifier = 0.85,
				t = 0.5,
			},
			{
				modifier = 0.85,
				t = 1,
			},
			{
				modifier = 0.8,
				t = 2,
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
			push = {
				action_name = "action_push",
			},
			special_action = {
				action_name = "action_special_coating_toggle",
				chain_time = 0.2,
			},
		},
	},
	action_push = {
		activation_cooldown = 0.2,
		anim_event = "attack_push",
		block_duration = 0.5,
		kind = "push",
		push_radius = 2.5,
		start_input = nil,
		total_time = 1,
		action_movement_curve = {
			{
				modifier = 1.4,
				t = 0.1,
			},
			{
				modifier = 0.5,
				t = 0.25,
			},
			{
				modifier = 0.5,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.4,
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
				action_name = "action_pushfollow",
				chain_time = 0.25,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.3,
			},
			start_attack = {
				action_name = "action_melee_start_push_combo",
				chain_time = 0.25,
			},
			special_action = {
				action_name = "action_special_coating_toggle",
				chain_time = 0.45,
			},
		},
		inner_push_rad = math.pi * 0.25,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.default_push,
		inner_damage_type = damage_types.punch,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.punch,
		haptic_trigger_template = HapticTriggerTemplates.melee.push,
	},
	action_pushfollow = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right_diagonal_down",
		anim_event_3p = "attack_swing_right_diagonal",
		attack_direction_override = "right",
		damage_window_end = 0.2916666666666667,
		damage_window_start = 0.18333333333333332,
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		power_level = 535,
		range_mod = 1.35,
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		start_input = nil,
		total_time = 2,
		weapon_handling_template = "time_scale_1_saw",
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.2,
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
				action_name = "action_melee_start_pushfollow_combo",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
			},
			special_action = {
				action_name = "action_special_coating_toggle",
				chain_time = 0.6,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/saw/swing_right_diagonal_pushfollow",
				anchor_point_offset = {
					0,
					0.2,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.saw_light_linesman,
		damage_type = damage_types.saw_light,
		damage_profile_special_active = DamageProfileTemplates.saw_light_linesman_ap,
		damage_type_special_active = damage_types.saw_light,
		wounds_shape = wounds_shapes.right_45_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_pushfollow_combo = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left_diagonal_down",
		anim_event_3p = "attack_swing_charge_left",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		invalid_start_action_for_stat_calculation = true,
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.65,
				t = 0.05,
			},
			{
				modifier = 0.7,
				t = 0.1,
			},
			{
				modifier = 0.9,
				t = 0.25,
			},
			{
				modifier = 0.85,
				t = 0.4,
			},
			{
				modifier = 0.85,
				t = 0.5,
			},
			{
				modifier = 0.835,
				t = 0.55,
			},
			{
				modifier = 0.95,
				t = 3,
			},
			start_modifier = 0.75,
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
				action_name = "action_light_1",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_heavy_pushfollow_combo",
				chain_time = 0.56,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_heavy_pushfollow_combo = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left_diagonal_down",
		anim_event_3p = "attack_swing_heavy_left",
		attack_direction_override = "left",
		damage_window_end = 0.325,
		damage_window_start = 0.19,
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.33,
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_saw",
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15,
			},
			{
				modifier = 1.25,
				t = 0.4,
			},
			{
				modifier = 0.5,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.5,
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
				action_name = "action_melee_start_right",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.45,
				chain_until = 0.05,
			},
			special_action = {
				action_name = "action_special_coating_toggle",
				chain_time = 0.6,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/saw/heavy_swing_left_diagonal",
				anchor_point_offset = {
					0,
					0.05,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.saw_heavy_linesman,
		damage_type = damage_types.saw_heavy,
		damage_profile_special_active = DamageProfileTemplates.saw_heavy_linesman_ap,
		damage_type_special_active = damage_types.saw_heavy,
		wounds_shape = wounds_shapes.left_45_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_push_combo = {
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down_right",
		anim_event_3p = "attack_swing_charge_down_right",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		invalid_start_action_for_stat_calculation = true,
		kind = "windup",
		start_input = nil,
		stop_input = "attack_cancel",
		total_time = 3,
		action_movement_curve = {
			{
				modifier = 0.65,
				t = 0.05,
			},
			{
				modifier = 0.7,
				t = 0.1,
			},
			{
				modifier = 0.9,
				t = 0.25,
			},
			{
				modifier = 0.85,
				t = 0.4,
			},
			{
				modifier = 0.85,
				t = 0.5,
			},
			{
				modifier = 0.835,
				t = 0.55,
			},
			{
				modifier = 0.95,
				t = 3,
			},
			start_modifier = 0.75,
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
				action_name = "action_light_2",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_heavy_push_combo",
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_heavy_push_combo = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_down_right",
		anim_event_3p = "attack_swing_heavy_down_right",
		attack_direction_override = "down",
		damage_window_end = 0.36,
		damage_window_start = 0.235,
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.3,
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		start_input = nil,
		total_time = 1.5,
		weapon_handling_template = "time_scale_1_saw",
		action_movement_curve = {
			{
				modifier = 1.3,
				t = 0.15,
			},
			{
				modifier = 1.25,
				t = 0.4,
			},
			{
				modifier = 0.5,
				t = 0.6,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.5,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
				chain_time = 0.6,
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.6,
				chain_until = 0.05,
			},
			special_action = {
				action_name = "action_special_coating_toggle",
				chain_time = 0.65,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/saw/heavy_swing_down_right",
				anchor_point_offset = {
					0,
					0,
					-0.1,
				},
			},
		},
		hit_stickyness_settings = hit_stickyness_settings_heavy,
		damage_profile = DamageProfileTemplates.saw_heavy_sticky,
		damage_type = damage_types.saw_heavy,
		damage_profile_special_active = DamageProfileTemplates.saw_heavy_sticky_ap,
		damage_type_special_active = damage_types.saw_heavy,
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_special_coating_toggle = {
		activate_anim_event = "coat_special",
		activation_time = 0.85,
		allowed_during_sprint = true,
		deactivate_anim_event = "coat_special",
		deactivation_time = 0.85,
		kind = "toggle_special",
		skip_3p_anims = false,
		start_input = "special_action",
		total_time = 1.3,
		total_time_deactivate = 1.3,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			start_attack = {
				action_name = "action_melee_start_left",
				chain_time = 0.875,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.875,
			},
			wield = {
				action_name = "action_unwield",
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

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/saw"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/saw"
weapon_template.weapon_box = {
	0.1,
	0.7,
	0.02,
}
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.3
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.weapon_special_class = "WeaponSpecialActivateToggle"
weapon_template.weapon_special_tweak_data = {
	deactivation_animation = "parry_special",
	set_inactive_func = function (inventory_slot_component, reason, tweak_data)
		local disable_special_active = reason == "manual_toggle"

		if disable_special_active then
			inventory_slot_component.special_active = false
			inventory_slot_component.num_special_charges = 0
		end

		return true
	end,
}
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_block = "fx_block",
	_idle_drips = "j_idle_drips",
	_slash_drips = "j_slash_drips",
	_sweep = "fx_sweep",
}
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.buffs = {
	on_equip = {
		"saw_p1_coating_poison_brittleness",
	},
}
weapon_template.keywords = {
	"melee",
	"saw",
	"p1",
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "linesman_plus"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "chainsword_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.haptic_trigger_template = HapticTriggerTemplates.melee.medium

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	saw_p1_m1_dps_stat = {
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
										display_name = "loc_weapon_stats_display_base_damage",
									},
								},
							},
						},
					},
				},
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
										display_name = "loc_weapon_stats_display_base_damage",
									},
								},
							},
						},
					},
				},
			},
			action_light_2 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_2 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_3 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_4 = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_pushfollow = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_push_combo = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_pushfollow_combo = {
				damage_trait_templates.default_melee_dps_stat,
			},
		},
	},
	saw_p1_m1_crit_stat = {
		display_name = "loc_stats_display_crit_stat",
		is_stat_trait = true,
		weapon_handling = {
			action_light_1 = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_heavy_1 = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_light_2 = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_heavy_2 = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_light_3 = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_light_4 = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_pushfollow = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_heavy_push_combo = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
			action_heavy_pushfollow_combo = {
				weapon_handling_trait_templates.stubrevolver_crit_stat,
			},
		},
		damage = {
			action_light_1 = {
				damage_trait_templates.saw_p1_m1_crit_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_heavy_1 = {
				damage_trait_templates.saw_p1_m1_crit_stat,
			},
			action_light_2 = {
				damage_trait_templates.saw_p1_m1_crit_stat,
			},
			action_heavy_2 = {
				damage_trait_templates.saw_p1_m1_crit_stat,
			},
			action_light_3 = {
				damage_trait_templates.saw_p1_m1_crit_stat,
			},
			action_light_4 = {
				damage_trait_templates.saw_p1_m1_crit_stat,
			},
			action_pushfollow = {
				damage_trait_templates.saw_p1_m1_crit_stat,
			},
			action_heavy_push_combo = {
				damage_trait_templates.saw_p1_m1_crit_stat,
			},
			action_heavy_pushfollow_combo = {
				damage_trait_templates.saw_p1_m1_crit_stat,
			},
		},
	},
	saw_p1_m1_first_target_stat = {
		display_name = "loc_stats_display_first_target_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				damage_trait_templates.default_first_target_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						targets = {
							{
								power_level_multiplier = {},
							},
						},
					},
				},
			},
			action_heavy_1 = {
				damage_trait_templates.default_first_target_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								power_level_multiplier = {},
							},
						},
					},
				},
			},
			action_light_2 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_heavy_2 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_3 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_4 = {
				damage_trait_templates.default_first_target_stat,
			},
			action_pushfollow = {
				damage_trait_templates.default_first_target_stat,
			},
			action_heavy_push_combo = {
				damage_trait_templates.default_first_target_stat,
			},
			action_heavy_pushfollow_combo = {
				damage_trait_templates.default_first_target_stat,
			},
		},
	},
	saw_p1_m1_mobility_stat = {
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
	saw_p1_m1_finesse_stat = {
		display_name = "loc_stats_display_finesse_stat",
		is_stat_trait = true,
		damage = {
			action_light_1 = {
				damage_trait_templates.saw_p1_m1_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						targets = {
							{
								boost_curve_multiplier_finesse = {},
							},
						},
					},
				},
			},
			action_heavy_1 = {
				damage_trait_templates.saw_p1_m1_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								boost_curve_multiplier_finesse = {},
							},
						},
					},
				},
			},
			action_light_2 = {
				damage_trait_templates.saw_p1_m1_finesse_stat,
			},
			action_heavy_2 = {
				damage_trait_templates.saw_p1_m1_finesse_stat,
			},
			action_light_3 = {
				damage_trait_templates.saw_p1_m1_finesse_stat,
			},
			action_light_4 = {
				damage_trait_templates.saw_p1_m1_finesse_stat,
			},
			action_pushfollow = {
				damage_trait_templates.saw_p1_m1_finesse_stat,
			},
			action_heavy_push_combo = {
				damage_trait_templates.saw_p1_m1_finesse_stat,
			},
			action_heavy_pushfollow_combo = {
				damage_trait_templates.saw_p1_m1_finesse_stat,
			},
		},
		weapon_handling = {
			action_light_1 = {
				weapon_handling_trait_templates.saw_p1_m1_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_light",
					display_stats = {
						time_scale = {},
					},
				},
			},
			action_heavy_1 = {
				weapon_handling_trait_templates.saw_p1_m1_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						time_scale = {},
					},
				},
			},
			action_light_2 = {
				weapon_handling_trait_templates.saw_p1_m1_finesse_stat,
			},
			action_heavy_2 = {
				weapon_handling_trait_templates.saw_p1_m1_finesse_stat,
			},
			action_light_3 = {
				weapon_handling_trait_templates.saw_p1_m1_finesse_stat,
			},
			action_light_4 = {
				weapon_handling_trait_templates.saw_p1_m1_finesse_stat,
			},
			action_pushfollow = {
				weapon_handling_trait_templates.saw_p1_m1_finesse_stat,
			},
			action_heavy_push_combo = {
				weapon_handling_trait_templates.saw_p1_m1_finesse_stat,
			},
			action_heavy_pushfollow_combo = {
				weapon_handling_trait_templates.saw_p1_m1_finesse_stat,
			},
		},
	},
}
weapon_template.traits = {}

local bespoke_saw_p1_traits = table.ukeys(WeaponTraitsBespokeSawP1)

table.append(weapon_template.traits, bespoke_saw_p1_traits)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_versatile",
	},
	{
		display_name = "loc_weapon_keyword_chem",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_linesman",
		type = "linesman",
		attack_chain = {
			"linesman",
			"smiter",
			"smiter",
			"linesman",
		},
	},
	secondary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"smiter",
			"linesman",
		},
	},
	special = {
		desc = "loc_stats_special_action_chem_coating_alt2_saw_p1_m1_desc",
		display_name = "loc_weapon_special_mode_switch",
		type = "activate",
	},
}
weapon_template.weapon_card_data = {
	main = {
		{
			header = "light",
			icon = "linesman",
			value_func = "primary_attack",
		},
		{
			header = "heavy",
			icon = "smiter",
			value_func = "secondary_attack",
		},
	},
	weapon_special = {
		header = "activate",
		icon = "activate",
	},
}

return weapon_template
