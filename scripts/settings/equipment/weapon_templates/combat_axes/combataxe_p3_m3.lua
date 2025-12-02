-- chunkname: @scripts/settings/equipment/weapon_templates/combat_axes/combataxe_p3_m3.lua

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
local WeaponTraitsBespokeCombataxeP3 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combataxe_p3")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local hit_zone_names = HitZone.hit_zone_names
local template_types = WeaponTweakTemplateSettings.template_types
local wounds_shapes = WoundsSettings.shapes
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
local weapon_template = {}

weapon_template.action_inputs = table.clone(MeleeActionInputSetupMid.action_inputs)
weapon_template.action_input_hierarchy = table.clone(MeleeActionInputSetupMid.action_input_hierarchy)

local combat_axe_sweep_box = {
	0.2,
	0.2,
	1,
}
local hit_zone_priority = {
	[hit_zone_names.head] = 1,
	[hit_zone_names.torso] = 1,
	[hit_zone_names.upper_left_arm] = 2,
	[hit_zone_names.upper_right_arm] = 2,
	[hit_zone_names.upper_left_leg] = 2,
	[hit_zone_names.upper_right_leg] = 2,
}

table.add_missing(hit_zone_priority, default_hit_zone_priority)

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
	duration = 0.24,
	min_sticky_time = 0.2,
	sensitivity_modifier = 0.1,
	start_anim_event = "attack_hit_stick",
	stop_anim_event = "yank_out",
	damage = {
		instances = 1,
		damage_profile = DamageProfileTemplates.light_shovel_sticky,
		damage_type = damage_types.metal_slashing_medium,
	},
	disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
	disallow_dodging = {},
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
local special_heavy_hit_stickyness_settings = {
	disable_vertical_force_view = true,
	disallow_chain_actions = true,
	duration = 0.72,
	min_sticky_time = 0.2,
	sensitivity_modifier = 0.1,
	start_anim_event = "attack_hit_stick",
	stop_anim_event = "yank_out",
	damage = {
		instances = 1,
		damage_profile = DamageProfileTemplates.heavy_shovel_sticky,
		damage_type = damage_types.metal_slashing_medium,
	},
	disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
	disallow_dodging = {},
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
		action_movement_curve = {
			{
				modifier = 1,
				t = 0.3,
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
				},
				{
					action_name = "action_melee_start_left",
				},
			},
			block = {
				action_name = "action_block",
			},
			special_action = {
				action_name = "action_special_activate",
			},
		},
	},
	action_melee_start_left_special = {
		action_priority = 2,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left_diagonal_down_folded",
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
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			light_attack = {
				action_name = "action_left_down_light_special",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_left_heavy_special",
				chain_time = 0.44,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		action_condition_func = function (action_settings, condition_func_params, used_input)
			return condition_func_params.inventory_slot_component.special_active
		end,
	},
	action_left_down_light_special = {
		action_priority = 2,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_down_folded",
		anim_event_3p = "attack_swing_down_folded",
		damage_window_end = 0.3333333333333333,
		damage_window_start = 0.23333333333333334,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.25,
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		start_input = nil,
		total_time = 1,
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
					action_name = "action_melee_start_left_special",
					chain_time = 0.75,
				},
				{
					action_name = "action_melee_start_left_2",
					chain_time = 0.75,
				},
			},
			special_action = {
				action_name = "action_special_activate",
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
		weapon_box = combat_axe_sweep_box,
		hit_zone_priority = default_hit_zone_priority,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/shovel/attack_down_folded",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_shovel_special,
		damage_type = damage_types.shovel_light,
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
	action_left_heavy_special = {
		action_priority = 2,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left_diagonal_down_folded",
		anim_event_3p = "attack_swing_heavy_down_left_folded",
		attack_direction_override = "down",
		damage_window_end = 0.23333333333333334,
		damage_window_start = 0.13333333333333333,
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "attack_hit",
		invalid_start_action_for_stat_calculation = true,
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.25,
		special_active_hit_stop_armor_anim = "attack_hit_shield",
		start_input = nil,
		total_time = 1,
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
					chain_time = 0.63,
				},
				{
					action_name = "action_melee_start_left",
					chain_time = 0.63,
				},
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.63,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = default_hit_zone_priority,
		weapon_box = combat_axe_sweep_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/shovel/heavy_attack_left_diagonal_down_folded",
				anchor_point_offset = {
					0,
					0.1,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.heavy_shovel_special,
		damage_type = damage_types.shovel_light,
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
	action_melee_start_left = {
		action_priority = 1,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_left_flatside",
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
				action_name = "action_light_1",
				chain_time = 0,
			},
			heavy_attack = {
				action_name = "action_heavy_1",
				chain_time = 0.4,
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
		anim_event = "attack_left_flatside",
		anim_event_3p = "attack_swing_left",
		attack_direction_override = "left",
		damage_window_end = 0.4,
		damage_window_start = 0.3,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.25,
		start_input = nil,
		total_time = 1.3,
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
				action_name = "action_melee_start_right",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.45,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = combat_axe_sweep_box,
		hit_zone_priority = hit_zone_priority,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/axe/attack_left",
				anchor_point_offset = {
					0,
					0,
					-0.15,
				},
			},
		},
		damage_profile = DamageProfileTemplates.default_light_shovel_tank,
		damage_type = damage_types.shovel_smack,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
	},
	action_heavy_1 = {
		action_priority = 2,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_left_flatside",
		anim_event_3p = "attack_swing_heavy_left",
		attack_direction_override = "left",
		damage_window_end = 0.23333333333333334,
		damage_window_start = 0.16666666666666666,
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "attack_hit",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.25,
		start_input = nil,
		total_time = 1,
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
				action_name = "action_melee_start_right",
				chain_time = 0.44,
			},
			special_action = {
				action_name = "action_special_activate",
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
		hit_zone_priority = hit_zone_priority,
		weapon_box = combat_axe_sweep_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/axe/heavy_attack_left",
				anchor_point_offset = {
					0,
					0,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.heavy_shovel_tank,
		damage_type = damage_types.shovel_smack,
		herding_template = HerdingTemplates.thunder_hammer_left_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
	},
	action_melee_start_right = {
		action_priority = 1,
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_flatside",
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
				action_name = "action_light_2",
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
	action_light_2 = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_right_flatside",
		anim_event_3p = "attack_swing_right",
		attack_direction_override = "right",
		damage_window_end = 0.4,
		damage_window_start = 0.3,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.25,
		start_input = nil,
		total_time = 1.5,
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
				action_name = "action_melee_start_left_2",
				chain_time = 0.57,
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.5,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = combat_axe_sweep_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/axe/attack_right",
				anchor_point_offset = {
					-0.05,
					0,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.default_light_shovel_tank,
		damage_type = damage_types.shovel_smack,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
	},
	action_heavy_2 = {
		anim_end_event = "attack_finished",
		anim_event = "heavy_attack_right_flatside",
		anim_event_3p = "attack_swing_heavy_right",
		attack_direction_override = "right",
		damage_window_end = 0.26666666666666666,
		damage_window_start = 0.13333333333333333,
		first_person_hit_anim = "hit_left_shake",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "attack_hit",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.25,
		start_input = nil,
		total_time = 1,
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
				chain_time = 0.3,
			},
			start_attack = {
				action_name = "action_melee_start_left_2",
				chain_time = 0.44,
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.4,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.35,
			},
		},
		hit_zone_priority = hit_zone_priority,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = combat_axe_sweep_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/axe/heavy_attack_right",
				anchor_point_offset = {
					0,
					0,
					-0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.heavy_shovel_tank,
		damage_type = damage_types.shovel_smack,
		herding_template = HerdingTemplates.thunder_hammer_right_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.horizontal_slash_coarse,
	},
	action_melee_start_left_2 = {
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
	action_light_3 = {
		anim_end_event = "attack_finished",
		anim_event = "attack_left_diagonal_down",
		anim_event_3p = "attack_swing_left_diagonal",
		attack_direction_override = "left",
		damage_window_end = 0.4,
		damage_window_start = 0.3,
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		hit_stop_anim = "hit_stop",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.25,
		start_input = nil,
		total_time = 1.3,
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
				action_name = "action_special_activate",
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
		weapon_box = combat_axe_sweep_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/axe/attack_left_diagonal_down",
				anchor_point_offset = {
					0,
					0,
					-0.15,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_shovel_marks_single_target,
		damage_type = damage_types.shovel_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.left_45_slash_coarse,
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
				action_name = "action_special_activate",
				chain_time = 0.3,
			},
		},
	},
	action_right_light_pushfollow = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_left_down",
		anim_event_3p = "attack_swing_down",
		attack_direction_override = "down",
		damage_window_end = 0.4,
		damage_window_start = 0.26666666666666666,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.35,
		start_input = nil,
		total_time = 1.5,
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
				action_name = "action_special_activate",
				chain_time = 0.3,
			},
			block = {
				action_name = "action_block",
				chain_time = 0.55,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = hit_zone_priority,
		weapon_box = combat_axe_sweep_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/axe/attack_left_down",
				anchor_point_offset = {
					0.05,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.default_light_shovel_smack,
		damage_type = damage_types.shovel_light,
		wounds_shape = wounds_shapes.vertical_slash_coarse,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_melee_start_right_2 = {
		anim_end_event = "attack_finished",
		anim_event = "heavy_charge_right_flatside",
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
		anim_end_event = "attack_finished",
		anim_event = "attack_right_down",
		anim_event_3p = "attack_swing_down",
		attack_direction_override = "down",
		damage_window_end = 0.4666666666666667,
		damage_window_start = 0.3,
		first_person_hit_stop_anim = "hit_stop",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		max_num_saved_entries = 20,
		num_frames_before_process = 0,
		range_mod = 1.25,
		start_input = nil,
		total_time = 1.5,
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
				action_name = "action_melee_start_left",
				chain_time = 0.71,
			},
			special_action = {
				action_name = "action_special_activate",
				chain_time = 0.45,
			},
			block = {
				action_name = "action_block",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		hit_zone_priority = default_hit_zone_priority,
		weapon_box = combat_axe_sweep_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/axe/attack_right_down",
				anchor_point_offset = {
					0.05,
					0,
					-0.05,
				},
			},
		},
		damage_profile = DamageProfileTemplates.light_shovel_marks_single_target,
		damage_type = damage_types.shovel_light,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.right_45_slash_coarse,
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
					action_name = "action_left_down_light_special",
					chain_time = 0.3,
				},
				{
					action_name = "action_right_light_pushfollow",
					chain_time = 0.3,
				},
			},
			block = {
				action_name = "action_block",
				chain_time = 0.4,
			},
			start_attack = {
				{
					action_name = "action_melee_start_left_special",
					chain_time = 0.45,
				},
				{
					action_name = "action_melee_start_left",
					chain_time = 0.45,
				},
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
	action_special_activate = {
		activate_anim_event = "fold",
		activation_time = 0,
		allowed_during_sprint = true,
		deactivate_anim_event = "unfold",
		deactivation_time = 0.1,
		kind = "toggle_special",
		skip_3p_anims = false,
		start_input = "special_action",
		total_time = 1,
		total_time_deactivate = 1,
		allowed_chain_actions = {
			block = {
				action_name = "action_block",
				chain_time = 0.5,
			},
			start_attack = {
				{
					action_name = "action_melee_start_left_special",
					chain_time = 0.5,
				},
				{
					action_name = "action_melee_start_left",
					chain_time = 0.5,
				},
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
		start_input = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect",
		},
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/power_sword"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/shovel"
weapon_template.weapon_box = combat_axe_sweep_box
weapon_template.sprint_ready_up_time = 0.1
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.45
weapon_template.ammo_template = "no_ammo"
weapon_template.weapon_special_class = "WeaponSpecialShovels"
weapon_template.weapon_special_tweak_data = {
	deactivation_animation = "deactivate_automatic",
	deactivation_animation_delay = 0.4,
	deactivation_animation_on_abort = true,
	set_inactive_func = function (inventory_slot_component, reason, tweak_data)
		local disable_special_active = reason == "max_activations" or reason == "manual_toggle"

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
weapon_template.keywords = {
	"melee",
	"combat_axe",
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "combataxe_p1_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.haptic_trigger_template = HapticTriggerTemplates.melee.heavy
weapon_template.overclocks = {
	armor_pierce_up_dps_down = {
		combataxe_p1_m1_armor_pierce_stat = 0.1,
		combataxe_p1_m1_dps_stat = -0.1,
	},
	finesse_up_armor_pierce_down = {
		combataxe_p1_m1_armor_pierce_stat = -0.2,
		combataxe_p1_m1_finesse_stat = 0.2,
	},
	first_target_up_armor_pierce_down = {
		combataxe_p1_m1_armor_pierce_stat = -0.1,
		combataxe_p1_m1_first_target_stat = 0.1,
	},
	mobility_up_first_target_down = {
		combataxe_p1_m1_first_target_stat = -0.1,
		combataxe_p1_m1_mobility_stat = 0.1,
	},
	dps_up_mobility_down = {
		combataxe_p1_m1_dps_stat = 0.1,
		combataxe_p1_m1_mobility_stat = -0.1,
	},
}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	combataxe_p3_m3_dps_stat = {
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
			action_left_down_light_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_left_heavy_special = {
				damage_trait_templates.default_melee_dps_stat,
			},
			action_light_4 = {
				damage_trait_templates.default_melee_dps_stat,
			},
		},
	},
	combataxe_p3_m3_defence_stat = {
		display_name = "loc_stats_display_defense_stat",
		is_stat_trait = true,
		stamina = {
			base = {
				stamina_trait_templates.thunderhammer_p1_m1_defence_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	combataxe_p3_m3_armor_pierce_stat = {
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
			action_left_heavy_special = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_left_down_light_special = {
				damage_trait_templates.default_armor_pierce_stat,
			},
			action_light_4 = {
				damage_trait_templates.default_armor_pierce_stat,
			},
		},
	},
	combataxe_p3_m3_first_target_stat = {
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
			action_left_down_light_special = {
				damage_trait_templates.default_first_target_stat,
			},
			action_right_light_pushfollow = {
				damage_trait_templates.default_first_target_stat,
			},
			action_left_heavy_special = {
				damage_trait_templates.default_first_target_stat,
			},
			action_light_4 = {
				damage_trait_templates.default_first_target_stat,
			},
		},
	},
	combataxe_p3_m3_mobility_stat = {
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

local bespoke_combataxe_p3_traits = table.ukeys(WeaponTraitsBespokeCombataxeP3)

table.append(weapon_template.traits, bespoke_combataxe_p3_traits)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_crowd_control",
	},
	{
		display_name = "loc_weapon_keyword_smiter",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_tank",
		type = "tank",
		attack_chain = {
			"tank",
			"tank",
			"smiter",
			"smiter",
		},
	},
	secondary = {
		display_name = "loc_gestalt_tank",
		type = "tank",
		attack_chain = {
			"tank",
			"tank",
		},
	},
	special = {
		desc = "loc_weapon_special_mode_switch_foldable_desc",
		display_name = "loc_weapon_special_mode_switch",
		type = "activate",
	},
}
weapon_template.weapon_card_data = {
	main = {
		{
			header = "light",
			icon = "tank",
			value_func = "primary_attack",
		},
		{
			header = "heavy",
			icon = "tank",
			value_func = "secondary_attack",
		},
	},
	weapon_special = {
		header = "special_attack",
		icon = "special_attack",
	},
}
weapon_template.special_action_name = "action_special_activate"

return weapon_template
