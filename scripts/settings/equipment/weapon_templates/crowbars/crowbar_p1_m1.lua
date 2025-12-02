-- chunkname: @scripts/settings/equipment/weapon_templates/crowbars/crowbar_p1_m1.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MeleeActionInputSetupMid = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_mid")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeCrowbarP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_crowbar_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local hit_zone_names = HitZone.hit_zone_names
local template_types = WeaponTweakTemplateSettings.template_types
local wounds_shapes = WoundsSettings.shapes
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local NIL_VALUE = BaseTemplateSettings.NIL_VALUE_OVERRIDE
local _generate_action_overrides = BaseTemplateSettings.generate_action_overrides
local weapon_template = {}

weapon_template.action_inputs = table.clone(MeleeActionInputSetupMid.action_inputs)
weapon_template.action_input_hierarchy = table.clone(MeleeActionInputSetupMid.action_input_hierarchy)

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

local default_weapon_box = {
	0.225,
	0.225,
	1.1,
}
local special_weapon_box = {
	0.15,
	0.15,
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

weapon_template.action_inputs.start_attack.buffer_time = 0.4
weapon_template.action_inputs.special_action.buffer_time = 0.35

local _force_abort_breed_tags_special_active = {
	"elite",
	"special",
	"monster",
	"captain",
	"roamer",
}
local melee_sticky_disallowed_hit_zones = {
	hit_zone_names.shield,
}
local special_light_hit_stickyness_settings = {
	disable_vertical_force_view = true,
	disallow_chain_actions = true,
	disallow_dodging = false,
	dodge_stamina_drain_percentage = 0.2,
	duration = 0.315,
	min_sticky_time = 0.2,
	sensitivity_modifier = 0.1,
	start_anim_event = "attack_hit_stick",
	stop_anim_event = "yank_out",
	damage = {
		instances = 1,
		damage_profile = DamageProfileTemplates.light_crowbar_sticky,
		damage_type = damage_types.crowbar_rip_light,
		dodge_damage_profile = DamageProfileTemplates.sticky_dodge_push,
	},
	disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
	movement_curve = {
		{
			modifier = 0.4,
			t = 0.2,
		},
		{
			modifier = 0.6,
			t = 0.4,
		},
		{
			modifier = 0.7,
			t = 0.5,
		},
		{
			modifier = 0.9,
			t = 0.6,
		},
		{
			modifier = 1,
			t = 1,
		},
		start_modifier = 0.2,
	},
}
local special_heavy_hit_stickyness_settings = {
	disable_vertical_force_view = true,
	disallow_chain_actions = true,
	disallow_dodging = false,
	dodge_stamina_drain_percentage = 0.2,
	duration = 0.55,
	min_sticky_time = 0.2,
	sensitivity_modifier = 0.1,
	start_anim_event = "attack_hit_stick",
	stop_anim_event = "yank_out",
	damage = {
		instances = 1,
		damage_profile = DamageProfileTemplates.heavy_crowbar_sticky,
		damage_type = damage_types.crowbar_rip_heavy,
		dodge_damage_profile = DamageProfileTemplates.sticky_dodge_push,
	},
	disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
	movement_curve = {
		{
			modifier = 0.4,
			t = 0.2,
		},
		{
			modifier = 0.6,
			t = 0.4,
		},
		{
			modifier = 0.7,
			t = 0.5,
		},
		{
			modifier = 0.9,
			t = 0.6,
		},
		{
			modifier = 1,
			t = 1,
		},
		start_modifier = 0.2,
	},
}
local BASE_ACTIONS = {
	melee_start_left = {
		action_priority = 1,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left_diagonal_up",
		anim_event_3p = "attack_swing_charge_left",
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
				modifier = 0.8,
				t = 0.5,
			},
			{
				modifier = 0.9,
				t = 0.55,
			},
			{
				modifier = 1,
				t = 1.2,
			},
			start_modifier = 1,
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	light_1 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_left_diagonal_up",
		anim_event_3p = "attack_swing_up_left",
		attack_direction_override = "up",
		damage_window_end = 0.3333333333333333,
		damage_window_start = 0.26666666666666666,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		power_level = 500,
		range_mod = 1.25,
		start_input = nil,
		total_time = 2,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_1",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2,
			},
			{
				modifier = 0.8,
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
				modifier = 0.75,
				t = 0.6,
			},
			{
				modifier = 0.8,
				t = 1,
			},
			{
				modifier = 1,
				t = 1.3,
			},
			start_modifier = 1.1,
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
				chain_time = 0.5,
			},
			special_action = {
				action_name = "action_special_activate_2",
				chain_time = 0.48,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = default_hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/crowbar/attack_left_diagonal_up",
				anchor_point_offset = {
					-0.15,
					0,
					-0.2,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_crowbar_smiter,
		damage_type = damage_types.blunt_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.vertical_slash_coarse,
	},
	heavy_1 = {
		action_priority = 2,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left_diagonal_up",
		anim_event_3p = "attack_swing_heavy_left",
		attack_direction_override = "up",
		damage_window_end = 0.23333333333333334,
		damage_window_start = 0.16666666666666666,
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "attack_hit",
		kind = "sweep",
		power_level = 500,
		ragdoll_push_force = 800,
		range_mod = 1.25,
		start_input = nil,
		total_time = 2,
		weapon_handling_template = "time_scale_1_1",
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
				chain_time = 0.4,
			},
			start_attack = {
				action_name = "action_melee_start_right",
				chain_time = 0.47,
			},
			special_action = {
				action_name = "action_special_activate_2",
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = default_hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/crowbar/heavy_attack_left_diagonal_up",
				anchor_point_offset = {
					0,
					0,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.heavy_crowbar_smiter,
		damage_type = damage_types.blunt_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.vertical_slash_coarse,
	},
	melee_start_right = {
		action_priority = 1,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_diagonal_down",
		anim_event_3p = "attack_swing_charge_right",
		kind = "windup",
		start_input = nil,
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
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	light_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right_down",
		anim_event_3p = "attack_swing_down",
		attack_direction_override = "down",
		damage_window_end = 0.5,
		damage_window_start = 0.3333333333333333,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		power_level = 500,
		range_mod = 1.25,
		start_input = nil,
		total_time = 2,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_2",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2,
			},
			{
				modifier = 0.8,
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
				modifier = 0.75,
				t = 0.6,
			},
			{
				modifier = 0.8,
				t = 1,
			},
			{
				modifier = 1,
				t = 1.3,
			},
			start_modifier = 1.1,
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
				chain_time = 0.57,
			},
			special_action = {
				action_name = "action_special_activate_1",
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = default_hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/axe/attack_right_down",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_crowbar_smiter,
		damage_type = damage_types.blunt_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.vertical_slash_coarse,
	},
	heavy_2 = {
		action_priority = 2,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_right_diagonal_down",
		anim_event_3p = "attack_swing_heavy_down_right",
		attack_direction_override = "right",
		damage_window_end = 0.2916666666666667,
		damage_window_start = 0.19166666666666668,
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "attack_hit",
		kind = "sweep",
		power_level = 500,
		range_mod = 1.285,
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		start_input = nil,
		total_time = 2,
		weapon_handling_template = "time_scale_1",
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
				chain_time = 0.45,
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.58,
			},
			special_action = {
				action_name = "action_special_activate_1",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = default_hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/axe/heavy_attack_right_diagonal_down",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.heavy_crowbar_tank,
		damage_type = damage_types.blunt_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
	},
	melee_start_left_special = {
		action_priority = 2,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left_diagonal_down_sticky",
		anim_event_3p = "attack_swing_charge_left",
		invalid_start_action_for_stat_calculation = true,
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
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	light_1_special = {
		action_priority = 2,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_down_sticky",
		anim_event_3p = "attack_swing_down_folded",
		attack_direction_override = "pull",
		damage_window_end = 0.325,
		damage_window_start = 0.25833333333333336,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		range_mod = 1.25,
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		start_input = nil,
		total_time = 2,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2,
			},
			{
				modifier = 0.8,
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
				modifier = 0.7,
				t = 1,
			},
			{
				modifier = 1,
				t = 1.3,
			},
			start_modifier = 1.1,
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
				{
					action_name = "action_melee_start_right_special",
					chain_time = 0.75,
				},
				{
					action_name = "action_melee_start_right_2",
					chain_time = 0.75,
				},
			},
			special_action = {
				action_name = "action_special_activate_2",
				chain_time = 0.67,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.7,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = default_hit_zone_priority,
		weapon_box = special_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/shovel/attack_down_folded",
				anchor_point_offset = {
					0.2,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_crowbar_special,
		damage_type = damage_types.crowbar_stick_light,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		hit_stickyness_settings = special_light_hit_stickyness_settings,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	heavy_1_special = {
		action_priority = 2,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left_diagonal_down_sticky",
		anim_event_3p = "attack_swing_heavy_down_left_folded",
		attack_direction_override = "pull",
		damage_window_end = 0.23333333333333334,
		damage_window_start = 0.13333333333333333,
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "attack_hit",
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		power_level = 500,
		range_mod = 1.25,
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		start_input = nil,
		total_time = 2,
		weapon_handling_template = "time_scale_1",
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
			},
			start_attack = {
				{
					action_name = "action_melee_start_right_special",
					chain_time = 0.65,
				},
				{
					action_name = "action_melee_start_right",
					chain_time = 0.65,
				},
			},
			special_action = {
				action_name = "action_special_activate_2",
				chain_time = 0.66,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.7,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = default_hit_zone_priority,
		weapon_box = special_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/shovel/heavy_attack_left_diagonal_down_folded",
				anchor_point_offset = {
					0,
					0,
					-0.2,
				},
			},
		},
		damage_profile = DamageProfileTemplates.heavy_crowbar_special,
		damage_type = damage_types.crowbar_stick_heavy,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		hit_stickyness_settings = special_heavy_hit_stickyness_settings,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	melee_start_right_special = {
		action_priority = 2,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_down_sticky_pose",
		anim_event_3p = "attack_swing_charge_down",
		invalid_start_action_for_stat_calculation = true,
		kind = "windup",
		start_input = nil,
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
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	light_2_special = {
		action_priority = 2,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right_down_sticky",
		anim_event_3p = "attack_swing_right_diagonal",
		attack_direction_override = "pull",
		damage_window_end = 0.5,
		damage_window_start = 0.3333333333333333,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		power_level = 500,
		range_mod = 1.25,
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		start_input = nil,
		total_time = 2,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.15,
			},
			{
				modifier = 0.8,
				t = 0.3,
			},
			{
				modifier = 0.5,
				t = 0.45,
			},
			{
				modifier = 0.45,
				t = 0.5,
			},
			{
				modifier = 0.65,
				t = 0.55,
			},
			{
				modifier = 0.7,
				t = 0.85,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.1,
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
				{
					action_name = "action_melee_start_left_special",
					chain_time = 0.75,
				},
				{
					action_name = "action_melee_start_left",
					chain_time = 0.75,
				},
			},
			special_action = {
				action_name = "action_special_activate_1",
				chain_time = 0.67,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.7,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = default_hit_zone_priority,
		weapon_box = special_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/axe/attack_right_down",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_crowbar_special,
		damage_type = damage_types.crowbar_stick_light,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		hit_stickyness_settings = special_light_hit_stickyness_settings,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	heavy_2_special = {
		action_priority = 2,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_down_sticky",
		anim_event_3p = "attack_swing_heavy_down_folded",
		attack_direction_override = "pull",
		damage_window_end = 0.2833333333333333,
		damage_window_start = 0.18333333333333332,
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "attack_hit",
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		power_level = 500,
		range_mod = 1.28,
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		start_input = nil,
		total_time = 2,
		weapon_handling_template = "time_scale_0_9",
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
			},
			start_attack = {
				{
					action_name = "action_melee_start_left_special",
					chain_time = 0.66,
				},
				{
					action_name = "action_melee_start_right_2",
					chain_time = 0.66,
				},
			},
			special_action = {
				action_name = "action_special_activate_1",
				chain_time = 0.66,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.7,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = default_hit_zone_priority,
		weapon_box = special_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/shovel/heavy_attack_down_folded",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.heavy_crowbar_special,
		damage_type = damage_types.crowbar_stick_heavy,
		force_abort_breed_tags_special_active = _force_abort_breed_tags_special_active,
		hit_stickyness_settings = special_heavy_hit_stickyness_settings,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
}
local BASE_ALLOWED_CHAIN_ACTIONS = {
	melee_start = {
		combat_ability = {
			action_name = "combat_ability",
		},
		grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		wield = {
			action_name = "action_unwield",
		},
		block = {
			action_name = "action_block",
		},
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
		kind = "wield",
		sprint_ready_up_time = 0,
		total_time = 0.3,
		uninterruptible = true,
		anim_event_func = function (action_settings, condition_func_params, is_chain_action, previous_action)
			local inventory_slot_component = condition_func_params.inventory_slot_component
			local special_active = inventory_slot_component.special_active
			local anim_event = special_active and "equip_activated" or "equip"
			local anim_event_3p = special_active and "equip_activated" or "equip_shovel"

			return anim_event, anim_event_3p
		end,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			start_attack = {
				{
					action_name = "action_melee_start_left_special",
				},
				{
					action_name = "action_melee_start_left",
				},
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_special_activate_1",
			},
		},
	},
	action_melee_start_left = _generate_action_overrides(BASE_ACTIONS.melee_start_left, "allowed_chain_actions", _generate_action_overrides(BASE_ALLOWED_CHAIN_ACTIONS.melee_start, "light_attack", {
		action_name = "action_light_1",
		chain_time = 0,
	}, "heavy_attack", {
		action_name = "action_heavy_1",
		chain_time = 0.52,
	})),
	action_light_1 = _generate_action_overrides(BASE_ACTIONS.light_1),
	action_heavy_1 = _generate_action_overrides(BASE_ACTIONS.heavy_1),
	action_melee_start_right = _generate_action_overrides(BASE_ACTIONS.melee_start_right, "allowed_chain_actions", _generate_action_overrides(BASE_ALLOWED_CHAIN_ACTIONS.melee_start, "light_attack", {
		action_name = "action_light_2",
		chain_time = 0,
	}, "heavy_attack", {
		action_name = "action_heavy_2",
		chain_time = 0.45,
	})),
	action_light_2 = _generate_action_overrides(BASE_ACTIONS.light_2),
	action_heavy_2 = _generate_action_overrides(BASE_ACTIONS.heavy_2),
	action_melee_start_left_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left_flatside",
		anim_event_3p = "attack_swing_charge_left",
		kind = "windup",
		start_input = nil,
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
				chain_time = 0.52,
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
		anim_event = "attack_left_diagonal_down",
		anim_event_3p = "attack_swing_left",
		attack_direction_override = "left",
		damage_window_end = 0.375,
		damage_window_start = 0.3,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		range_mod = 1.25,
		start_input = nil,
		total_time = 2,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_1",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2,
			},
			{
				modifier = 0.8,
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
				modifier = 0.75,
				t = 0.6,
			},
			{
				modifier = 0.8,
				t = 1,
			},
			{
				modifier = 1,
				t = 1.3,
			},
			start_modifier = 1.1,
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
				chain_time = 0.43,
			},
			special_action = {
				action_name = "action_special_activate_2",
				chain_time = 0.43,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = default_hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/axe/attack_left_diagonal_down",
				anchor_point_offset = {
					0.15,
					0,
					-0.15,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_crowbar_tank,
		damage_type = damage_types.blunt_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
	},
	action_melee_start_right_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_diagonal_down",
		anim_event_3p = "attack_swing_charge_right",
		kind = "windup",
		start_input = nil,
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
				chain_time = 0.42,
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
		anim_event_3p = "attack_swing_right_diagonal",
		attack_direction_override = "right",
		damage_window_end = 0.48333333333333334,
		damage_window_start = 0.4083333333333333,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.28,
		start_input = nil,
		total_time = 2,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2,
			},
			{
				modifier = 0.8,
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
				modifier = 0.75,
				t = 0.6,
			},
			{
				modifier = 0.8,
				t = 1,
			},
			{
				modifier = 1,
				t = 1.3,
			},
			start_modifier = 1.1,
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
				chain_time = 0.57,
			},
			special_action = {
				action_name = "action_special_activate_1",
				chain_time = 0.55,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = default_hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/shovel/attack_right_diagonal_down",
				anchor_point_offset = {
					-0.1,
					0,
					0.05,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_crowbar_tank,
		damage_type = damage_types.blunt_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.right_45_slash_coarse,
	},
	action_special_activate_1 = {
		activate_anim_event = "stance_sticky",
		activation_time = 0,
		allowed_during_sprint = true,
		deactivate_anim_event = "stance_blunt",
		deactivation_time = 0.1,
		kind = "toggle_special",
		skip_3p_anims = false,
		start_input = "special_action",
		total_time = 1,
		total_time_deactivate = 1,
		weapon_handling_template = "time_scale_1_1",
		allowed_chain_actions = {
			block = {
				action_name = "action_block",
				chain_time = 0.5,
			},
			start_attack = {
				{
					action_name = "action_melee_start_left_special_from_activate",
					chain_time = 0.5,
				},
				{
					action_name = "action_melee_start_left_from_activate",
					chain_time = 0.5,
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			special_action = {
				action_name = "action_special_activate_2",
				chain_time = 0.7,
			},
		},
	},
	action_special_activate_2 = {
		activate_anim_event = "stance_sticky",
		activation_time = 0,
		allowed_during_sprint = true,
		deactivate_anim_event = "stance_blunt",
		deactivation_time = 0.1,
		kind = "toggle_special",
		skip_3p_anims = false,
		start_input = nil,
		total_time = 1,
		total_time_deactivate = 1,
		weapon_handling_template = "time_scale_1_1",
		allowed_chain_actions = {
			block = {
				action_name = "action_block",
				chain_time = 0.5,
			},
			start_attack = {
				{
					action_name = "action_melee_start_right_special_from_activate",
					chain_time = 0.5,
				},
				{
					action_name = "action_melee_start_right_from_activate",
					chain_time = 0.5,
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			special_action = {
				action_name = "action_special_activate_1",
				chain_time = 0.7,
			},
		},
	},
	action_melee_start_left_special = _generate_action_overrides(BASE_ACTIONS.melee_start_left_special, "allowed_chain_actions", _generate_action_overrides(BASE_ALLOWED_CHAIN_ACTIONS.melee_start, "light_attack", {
		action_name = "action_light_1_special",
		chain_time = 0,
	}, "heavy_attack", {
		action_name = "action_heavy_1_special",
		chain_time = 0.44,
	})),
	action_light_1_special = _generate_action_overrides(BASE_ACTIONS.light_1_special),
	action_heavy_1_special = _generate_action_overrides(BASE_ACTIONS.heavy_1_special),
	action_melee_start_right_special = _generate_action_overrides(BASE_ACTIONS.melee_start_right_special, "allowed_chain_actions", _generate_action_overrides(BASE_ALLOWED_CHAIN_ACTIONS.melee_start, "light_attack", {
		action_name = "action_light_2_special",
		chain_time = 0,
	}, "heavy_attack", {
		action_name = "action_heavy_2_special",
		chain_time = 0.44,
	})),
	action_light_2_special = _generate_action_overrides(BASE_ACTIONS.light_2_special),
	action_heavy_2_special = _generate_action_overrides(BASE_ACTIONS.heavy_2_special, "power_level", 550),
	action_melee_start_left_from_activate = _generate_action_overrides(BASE_ACTIONS.melee_start_left, "start_input", NIL_VALUE, "invalid_start_action_for_stat_calculation", false, "allowed_chain_actions", _generate_action_overrides(BASE_ALLOWED_CHAIN_ACTIONS.melee_start, "light_attack", {
		action_name = "action_light_1_from_activate",
		chain_time = 0,
	}, "heavy_attack", {
		action_name = "action_heavy_1_from_activate",
		chain_time = 0.52,
	})),
	action_light_1_from_activate = _generate_action_overrides(BASE_ACTIONS.light_1, "power_level", 550),
	action_heavy_1_from_activate = _generate_action_overrides(BASE_ACTIONS.heavy_1, "power_level", 550),
	action_melee_start_right_from_activate = _generate_action_overrides(BASE_ACTIONS.melee_start_right, "start_input", NIL_VALUE, "invalid_start_action_for_stat_calculation", false, "allowed_chain_actions", _generate_action_overrides(BASE_ALLOWED_CHAIN_ACTIONS.melee_start, "light_attack", {
		action_name = "action_light_2_from_activate",
		chain_time = 0,
	}, "heavy_attack", {
		action_name = "action_heavy_2_from_activate",
		chain_time = 0.45,
	})),
	action_light_2_from_activate = _generate_action_overrides(BASE_ACTIONS.light_2, "power_level", 550),
	action_heavy_2_from_activate = _generate_action_overrides(BASE_ACTIONS.heavy_2, "power_level", 550),
	action_melee_start_left_special_from_activate = _generate_action_overrides(BASE_ACTIONS.melee_start_left_special, "start_input", NIL_VALUE, "allowed_chain_actions", _generate_action_overrides(BASE_ALLOWED_CHAIN_ACTIONS.melee_start, "light_attack", {
		action_name = "action_light_1_special_from_activate",
		chain_time = 0,
	}, "heavy_attack", {
		action_name = "action_heavy_1_special_from_activate",
		chain_time = 0.44,
	})),
	action_light_1_special_from_activate = _generate_action_overrides(BASE_ACTIONS.light_1_special, "power_level", 550),
	action_heavy_1_special_from_activate = _generate_action_overrides(BASE_ACTIONS.heavy_1_special, "power_level", 550),
	action_melee_start_right_special_from_activate = _generate_action_overrides(BASE_ACTIONS.melee_start_right_special, "start_input", NIL_VALUE, "allowed_chain_actions", _generate_action_overrides(BASE_ALLOWED_CHAIN_ACTIONS.melee_start, "light_attack", {
		action_name = "action_light_2_special_from_activate",
		chain_time = 0,
	}, "heavy_attack", {
		action_name = "action_heavy_2_special_from_activate",
		chain_time = 0.44,
	})),
	action_light_2_special_from_activate = _generate_action_overrides(BASE_ACTIONS.light_2_special, "power_level", 550),
	action_heavy_2_special_from_activate = _generate_action_overrides(BASE_ACTIONS.heavy_2_special, "power_level", 600),
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
				modifier = 0.75,
				t = 0.2,
			},
			{
				modifier = 0.32,
				t = 0.3,
			},
			{
				modifier = 0.3,
				t = 0.325,
			},
			{
				modifier = 0.31,
				t = 0.35,
			},
			{
				modifier = 0.55,
				t = 0.5,
			},
			{
				modifier = 0.75,
				t = 1,
			},
			{
				modifier = 0.7,
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
				action_name = "action_special_activate_2",
				chain_time = 0.3,
			},
		},
	},
	action_push = {
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
				{
					action_name = "action_pushfollow_special",
					chain_time = 0.3,
				},
				{
					action_name = "action_pushfollow",
					chain_time = 0.3,
				},
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
			start_attack = {
				{
					action_name = "action_melee_start_right_special",
					chain_time = 0.45,
				},
				{
					action_name = "action_melee_start_left",
					chain_time = 0.45,
				},
			},
			special_action = {
				action_name = "action_special_activate_1",
				chain_time = 0.4,
			},
		},
		inner_push_rad = math.pi * 0.25,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.default_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.physical,
		haptic_trigger_template = HapticTriggerTemplates.melee.push,
	},
	action_pushfollow = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_push_followup",
		anim_event_3p = "attack_swing_right",
		attack_direction_override = "right",
		damage_window_end = 0.4166666666666667,
		damage_window_start = 0.3333333333333333,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		power_level = 550,
		range_mod = 1.35,
		start_input = nil,
		total_time = 2,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.2,
			},
			{
				modifier = 1.15,
				t = 0.4,
			},
			{
				modifier = 0.45,
				t = 0.45,
			},
			{
				modifier = 0.6,
				t = 0.65,
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
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.55,
			},
			special_action = {
				action_name = "action_special_activate_1",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.55,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = default_hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/crowbar/attack_right_followup",
				anchor_point_offset = {
					0,
					0,
					-0.15,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_crowbar_tank,
		damage_type = damage_types.blunt,
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_pushfollow_special = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_push_followup",
		anim_event_3p = "attack_swing_right",
		attack_direction_override = "right",
		damage_window_end = 0.4166666666666667,
		damage_window_start = 0.3333333333333333,
		kind = "sweep",
		power_level = 550,
		range_mod = 1.35,
		special_active_hit_stop_anim = "hit_stop",
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		start_input = nil,
		total_time = 2,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.2,
			},
			{
				modifier = 1.15,
				t = 0.4,
			},
			{
				modifier = 0.45,
				t = 0.45,
			},
			{
				modifier = 0.6,
				t = 0.65,
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
			start_attack = {
				action_name = "action_melee_start_left_special",
				chain_time = 0.55,
			},
			special_action = {
				action_name = "action_special_activate_1",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.55,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = default_hit_zone_priority,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/crowbar/attack_right_followup",
				anchor_point_offset = {
					0,
					0,
					-0.15,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_crowbar_tank,
		damage_type = damage_types.blunt,
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	action_inspect = {
		anim_end_event = "inspect_end",
		anim_event = "inspect_start",
		kind = "inspect",
		lock_view = true,
		start_input = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect",
		},
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/crowbar"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/crowbar"
weapon_template.sprint_ready_up_time = 0.1
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.ammo_template = "no_ammo"
weapon_template.weapon_special_class = "WeaponSpecialActivateToggle"
weapon_template.weapon_special_tweak_data = {
	deactivation_animation = "deactivate_automatic",
	deactivation_animation_delay = 0.4,
	deactivation_animation_on_abort = true,
	set_inactive_func = function (inventory_slot_component, reason, tweak_data)
		local disable_special_active = reason == "manual_toggle"

		if disable_special_active then
			inventory_slot_component.special_active = false
			inventory_slot_component.num_special_charges = 0
		end

		return true
	end,
}
weapon_template.fx_sources = {
	_block = "fx_block",
	_sweep = "fx_sweep",
}
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.buffs = {
	on_equip = {
		"windup_increases_power_default_parent",
	},
}
weapon_template.keywords = {
	"melee",
	"crowbar",
	"p1",
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "linesman_plus"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "combataxe_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.haptic_trigger_template = HapticTriggerTemplates.melee.heavy

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	crowbar_p1_m1_dps_stat = {
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
			action_pushfollow_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_1_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_2_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_1_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_2_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_1_from_activate = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_2_from_activate = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_1_from_activate = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_2_from_activate = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_1_special_from_activate = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_2_special_from_activate = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_1_special_from_activate = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_heavy_2_special_from_activate = {
				damage_trait_templates.default_melee_dps_stat,
			},
		},
	},
	crowbar_p1_m1_defence_stat = {
		display_name = "loc_stats_display_defense_stat",
		is_stat_trait = true,
		stamina = {
			base = {
				stamina_trait_templates.thunderhammer_p1_m1_defence_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	crowbar_p1_m1_armor_pierce_stat = {
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
									attack = WeaponBarUIDescriptionTemplates.armor_damage_modifiers,
								},
							},
						},
					},
				},
			},
			action_heavy_1 = {
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
			action_light_2 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_heavy_2 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_3 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_4 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_pushfollow = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_pushfollow_special = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_1_special = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_2_special = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_heavy_1_special = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_heavy_2_special = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_1_from_activate = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_2_from_activate = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_heavy_1_from_activate = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_heavy_2_from_activate = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_1_special_from_activate = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_2_special_from_activate = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_heavy_1_special_from_activate = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_heavy_2_special_from_activate = {
				damage_trait_templates.default_armor_pierce_stat,
			},
		},
	},
	crowbar_p1_m1_first_target_stat = {
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
			action_pushfollow_special = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_1_special = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_2_special = {
				damage_trait_templates.default_first_target_stat,
			},
			action_heavy_1_special = {
				damage_trait_templates.default_first_target_stat,
			},
			action_heavy_2_special = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_1_from_activate = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_2_from_activate = {
				damage_trait_templates.default_first_target_stat,
			},
			action_heavy_1_from_activate = {
				damage_trait_templates.default_first_target_stat,
			},
			action_heavy_2_from_activate = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_1_special_from_activate = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_2_special_from_activate = {
				damage_trait_templates.default_first_target_stat,
			},
			action_heavy_1_special_from_activate = {
				damage_trait_templates.default_first_target_stat,
			},
			action_heavy_2_special_from_activate = {
				damage_trait_templates.default_first_target_stat,
			},
		},
	},
	crowbar_p1_m1_mobility_stat = {
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
weapon_template.traits = {}

local bespoke_crowbar_p1_traits = table.ukeys(WeaponTraitsBespokeCrowbarP1)

table.append(weapon_template.traits, bespoke_crowbar_p1_traits)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_smiter",
	},
	{
		display_name = "loc_weapon_keyword_heavy_windup",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"smiter",
			"smiter",
			"tank",
			"tank",
		},
	},
	secondary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"smiter",
			"tank",
		},
	},
	special = {
		desc = "loc_weapon_special_mode_switch_grip_crowbar_desc",
		display_name = "loc_weapon_special_mode_switch",
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
			icon = "smiter",
			value_func = "secondary_attack",
		},
	},
	weapon_special = {
		header = "special_attack",
		icon = "special_attack",
	},
}

return weapon_template
