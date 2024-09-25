-- chunkname: @scripts/settings/equipment/weapon_templates/force_staffs/forcestaff_p2_m1.lua

local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FlamerGasTemplates = require("scripts/settings/projectile/flamer_gas_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeForcestaffP2 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_forcestaff_p2")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local template_types = WeaponTweakTemplateSettings.template_types
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local burninating_trait_templates = WeaponTraitTemplates[template_types.burninating]
local charge_trait_templates = WeaponTraitTemplates[template_types.charge]
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local explosion_trait_templates = WeaponTraitTemplates[template_types.explosion]
local size_of_flame_trait_templates = WeaponTraitTemplates[template_types.size_of_flame]
local warp_charge_trait_templates = WeaponTraitTemplates[template_types.warp_charge]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local weapon_template = {}

weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.action_inputs = {
	shoot_pressed = {
		buffer_time = 0.15,
		max_queue = 2,
		input_sequence = {
			{
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	charge = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "action_two_hold",
				value = true,
			},
		},
	},
	charge_release = {
		buffer_time = 0.417,
		input_sequence = {
			{
				input = "action_two_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	keep_charging = {
		buffer_time = 0,
		input_sequence = {
			{
				input = "action_two_hold",
				value = true,
			},
		},
	},
	trigger_charge_flame = {
		buffer_time = 0.5,
		input_sequence = {
			{
				hold_input = "action_two_hold",
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	cancel_flame = {
		buffer_time = 0.5,
		input_sequence = {
			{
				input = "action_two_hold",
				value = false,
			},
		},
	},
	wield = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				inputs = wield_inputs,
			},
		},
	},
	vent = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				input = "weapon_reload_hold",
				value = true,
			},
		},
	},
	vent_release = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "weapon_reload_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	special_action = {
		buffer_time = 0.2,
		input_sequence = {
			{
				input = "weapon_extra_pressed",
				value = true,
			},
		},
	},
	special_action_hold = {
		buffer_time = 0.2,
		input_sequence = {
			{
				hold_input = "weapon_extra_hold",
				input = "weapon_extra_hold",
				value = true,
			},
		},
	},
	special_action_light = {
		buffer_time = 0.3,
		max_queue = 1,
		input_sequence = {
			{
				input = "weapon_extra_hold",
				time_window = 0.25,
				value = false,
			},
		},
	},
	special_action_heavy = {
		buffer_time = 0.5,
		max_queue = 1,
		input_sequence = {
			{
				duration = 0.25,
				input = "weapon_extra_hold",
				value = true,
			},
			{
				auto_complete = false,
				input = "weapon_extra_hold",
				time_window = 1.5,
				value = false,
			},
		},
	},
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	shoot_pressed = "stay",
	wield = "stay",
	charge = {
		charge_release = "base",
		combat_ability = "base",
		grenade_ability = "base",
		vent = "base",
		wield = "base",
		trigger_charge_flame = {
			cancel_flame = "base",
			keep_charging = "previous",
			vent = "base",
			wield = "base",
		},
	},
	vent = {
		combat_ability = "base",
		grenade_ability = "base",
		vent_release = "base",
		wield = "base",
	},
	special_action_hold = {
		combat_ability = "base",
		grenade_ability = "base",
		special_action = "base",
		special_action_heavy = "base",
		special_action_light = "base",
		wield = "base",
	},
}
weapon_template.burninating_template = "forcestaff_p2_m1"
weapon_template.size_of_flame_template = "forcestaff_p2_m1"

table.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
	action_unwield = {
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
		total_time = 0.2,
		uninterruptible = true,
		allowed_chain_actions = {
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.4,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			shoot_pressed = {
				action_name = "action_shoot_flame",
				chain_time = 0.2,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0,
			},
		},
	},
	action_shoot_flame = {
		abort_sprint = true,
		allowed_during_sprint = true,
		charge_template = "forcestaff_p2_m1_flame_burst",
		delay_explosion_to_finish = true,
		first_shot_only_sound_reflection = true,
		ignore_shooting_look_delta_anim_control = true,
		increase_combo = true,
		kind = "flamer_gas_burst",
		sprint_ready_up_time = 0,
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot_pressed",
		total_time = 1,
		uninterruptible = true,
		uses_warp_charge = true,
		weapon_handling_template = "forcestaff_p2_m1_burst",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2,
			},
			{
				modifier = 1.1,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.8,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			shoot_pressed = {
				action_name = "action_shoot_flame",
				chain_time = 0.65,
			},
			charge = {
				action_name = "action_charge_flame",
				chain_time = 0.65,
				reset_combo = true,
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.3,
				reset_combo = true,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.3,
			},
		},
		fx = {
			duration = 0.3,
			impact_effect = "content/fx/particles/weapons/flame_staff/psyker_flame_staff_impact_delay",
			looping_3d_sound_effect = "wwise/events/weapon/play_forcestaff_warp_fire_loop_3d",
			looping_shoot_sfx_alias = "ranged_shooting",
			move_after_stop = true,
			stop_looping_3d_sound_effect = "wwise/events/weapon/stop_forcestaff_warp_fire_loop_3d",
			stream_effect = {
				name = "content/fx/particles/weapons/flame_staff/psyker_flame_staff_code_control",
				name_3p = "content/fx/particles/weapons/flame_staff/psyker_flame_staff_code_control_3p",
				speed = 33,
			},
		},
		fire_configuration = {
			anim_event = "attack_burst",
			anim_event_3p = "orb_shoot",
			flamer_gas_template = FlamerGasTemplates.warp_fire_burst,
			damage_type = damage_types.warpfire,
		},
		buff_keywords = {
			buff_keywords.allow_hipfire_during_sprint,
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_charge_flame = {
		allowed_during_sprint = true,
		anim_end_event = "attack_cancel",
		anim_event = "attack_charge_flame_start",
		anim_event_3p = "attack_charge_flame_start",
		charge_template = "forcestaff_p2_m1_charge",
		hold_combo = true,
		kind = "overload_charge",
		minimum_hold_time = 0.4,
		overload_module_class_name = "warp_charge",
		sprint_ready_up_time = 0,
		sprint_requires_press_to_interrupt = false,
		start_input = "charge",
		stop_input = "charge_release",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "charge_up",
		},
		action_movement_curve = {
			{
				modifier = 0.3,
				t = 0.1,
			},
			{
				modifier = 0.3,
				t = 0.15,
			},
			{
				modifier = 0.6,
				t = 0.25,
			},
			{
				modifier = 0.6,
				t = 0.5,
			},
			{
				modifier = 0.4,
				t = 1,
			},
			{
				modifier = 0.3,
				t = 2,
			},
			start_modifier = 1,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			trigger_charge_flame = {
				action_name = "action_shoot_charged_flame",
				chain_time = 0.5,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.3,
			},
		},
		charge_effects = {
			looping_effect_alias = "ranged_charging",
			looping_sound_alias = "ranged_charging",
			sfx_parameter = "charge_level",
			sfx_source_name = "_overheat",
			vfx_source_name = "_muzzle",
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			if end_reason == "hold_input_released" or end_reason == "stunned" then
				return true
			end

			return false
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.charge_up_time,
		},
	},
	action_shoot_charged_flame = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_cancel",
		anim_event = "attack_shoot_flame",
		anim_event_3p = "attack_shoot_flame",
		charge_template = "forcestaff_p2_m1_flamer_gas",
		delay_explosion_to_finish = true,
		first_shot_only_sound_reflection = true,
		ignore_shooting_look_delta_anim_control = true,
		increase_combo = true,
		kind = "flamer_gas",
		minimum_hold_time = 0.4,
		sprint_ready_up_time = 0,
		sprint_requires_press_to_interrupt = true,
		stop_input = "cancel_flame",
		uninterruptible = true,
		uses_warp_charge = true,
		weapon_handling_template = "forcestaff_p2_m1_auto",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "charge_up",
		},
		action_movement_curve = {
			{
				modifier = 0.1,
				t = 0.35,
			},
			{
				modifier = 0.1,
				t = 0.55,
			},
			{
				modifier = 0.2,
				t = 0.75,
			},
			start_modifier = 0.1,
		},
		running_action_state_to_action_input = {
			charge_depleted = {
				input_name = "cancel_flame",
			},
		},
		fx = {
			impact_effect = "content/fx/particles/weapons/flame_staff/psyker_flame_staff_impact_delay",
			looping_3d_sound_effect = "wwise/events/weapon/play_forcestaff_warp_fire_loop_3d",
			looping_shoot_sfx_alias = "ranged_shooting",
			stop_looping_3d_sound_effect = "wwise/events/weapon/stop_forcestaff_warp_fire_loop_3d",
			stream_effect = {
				name = "content/fx/particles/weapons/flame_staff/psyker_flame_staff_code_control",
				name_3p = "content/fx/particles/weapons/flame_staff/psyker_flame_staff_code_control_3p",
				speed = 35,
			},
		},
		fire_configuration = {
			charge_cost = true,
			flamer_gas_template = FlamerGasTemplates.warp_fire_auto,
			damage_type = damage_types.warpfire,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
			},
			keep_charging = {
				action_name = "action_charge_flame",
				running_action_state_requirement = {
					charge_depleted = true,
				},
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_stab_start = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_special_charge",
		kind = "windup",
		start_input = "special_action_hold",
		total_time = 1.1,
		crosshair = {
			crosshair_type = "dot",
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.9,
			},
			shoot_pressed = {
				action_name = "action_shoot_flame",
				chain_time = 1,
				reset_combo = true,
			},
			charge = {
				action_name = "action_charge_flame",
				chain_time = 1,
				reset_combo = true,
			},
			vent = {
				action_name = "action_vent",
			},
			special_action_light = {
				action_name = "action_stab",
				chain_time = 0.2,
			},
			special_action_heavy = {
				action_name = "action_stab_heavy",
				chain_time = 0.4,
			},
		},
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "special_action_heavy",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_swipe_start = {
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_special_swipe_charge",
		kind = "windup",
		total_time = 1.1,
		crosshair = {
			crosshair_type = "dot",
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			shoot_pressed = {
				action_name = "action_shoot_flame",
				chain_time = 1,
				reset_combo = true,
			},
			special_action_light = {
				action_name = "action_swipe",
				chain_time = 0.1,
			},
			special_action_heavy = {
				action_name = "action_swipe_heavy",
				chain_time = 0.6,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.3,
			},
		},
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "special_action_heavy",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
	},
	action_stab = {
		allowed_during_sprint = true,
		anim_event = "attack_special",
		damage_window_end = 0.26666666666666666,
		damage_window_start = 0.11666666666666667,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.15,
		total_time = 0.6,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_3",
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.1,
			},
			{
				modifier = 1.75,
				t = 0.25,
			},
			{
				modifier = 1.35,
				t = 0.3,
			},
			{
				modifier = 1.2,
				t = 0.35,
			},
			{
				modifier = 1.1,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 0.6,
			},
			{
				modifier = 0.95,
				t = 1,
			},
			start_modifier = 0.8,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			shoot_pressed = {
				action_name = "action_shoot_flame",
				chain_time = 0.5,
				reset_combo = true,
			},
			charge = {
				action_name = "action_charge_flame",
				chain_time = 0.5,
				reset_combo = true,
			},
			special_action_hold = {
				action_name = "action_swipe_start",
				chain_time = 0.4,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.5,
			},
		},
		weapon_box = {
			0.08,
			2.4,
			0.08,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/force_staff/attack_special_stab_sweep_bake",
			anchor_point_offset = {
				0.1,
				1.1,
				0,
			},
		},
		damage_type = damage_types.blunt_light,
		damage_profile = DamageProfileTemplates.force_staff_bash,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_stab_heavy = {
		allowed_during_sprint = true,
		anim_event = "attack_special",
		damage_window_end = 0.21666666666666667,
		damage_window_start = 0.13333333333333333,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		power_level = 800,
		range_mod = 1.15,
		total_time = 0.75,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_2",
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			{
				modifier = 0.8,
				t = 0.1,
			},
			{
				modifier = 1.75,
				t = 0.25,
			},
			{
				modifier = 1.35,
				t = 0.3,
			},
			{
				modifier = 1.2,
				t = 0.35,
			},
			{
				modifier = 1.1,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 0.6,
			},
			{
				modifier = 0.95,
				t = 1,
			},
			start_modifier = 0.8,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			shoot_pressed = {
				action_name = "action_shoot_flame",
				chain_time = 0.5,
				reset_combo = true,
			},
			charge = {
				action_name = "action_charge_flame",
				chain_time = 0.5,
				reset_combo = true,
			},
			special_action_hold = {
				action_name = "action_swipe_start",
				chain_time = 0.4,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.5,
			},
		},
		weapon_box = {
			0.08,
			2.75,
			0.08,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/force_staff/attack_special_stab_sweep_bake",
			anchor_point_offset = {
				0.1,
				1.1,
				0,
			},
		},
		damage_type = damage_types.blunt_heavy,
		damage_profile = DamageProfileTemplates.force_staff_bash_stab_heavy,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_swipe = {
		allowed_during_sprint = true,
		anim_event = "attack_special_swipe",
		attack_direction_override = "left",
		damage_window_end = 0.7,
		damage_window_start = 0.6333333333333333,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		power_level = 650,
		range_mod = 1.15,
		total_time = 0.75,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1_2",
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			{
				modifier = 0.3,
				t = 0.1,
			},
			{
				modifier = 0.5,
				t = 0.25,
			},
			{
				modifier = 0.5,
				t = 0.3,
			},
			{
				modifier = 1.5,
				t = 0.35,
			},
			{
				modifier = 1.5,
				t = 0.4,
			},
			{
				modifier = 1.05,
				t = 0.6,
			},
			{
				modifier = 0.75,
				t = 1,
			},
			start_modifier = 0.8,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.7,
			},
			shoot_pressed = {
				action_name = "action_shoot_flame",
				chain_time = 1,
				reset_combo = true,
			},
			charge = {
				action_name = "action_charge_flame",
				chain_time = 1,
				reset_combo = true,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.6,
			},
		},
		weapon_box = {
			0.15,
			0.15,
			1.2,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/force_staff/attack_special_swipe_sweep_bake",
			anchor_point_offset = {
				0,
				-0.2,
				0,
			},
		},
		damage_type = damage_types.blunt_light,
		damage_profile = DamageProfileTemplates.force_staff_bash,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_swipe_heavy = {
		allowed_during_sprint = true,
		anim_event = "attack_special_swipe_heavy",
		attack_direction_override = "left",
		damage_window_end = 0.35,
		damage_window_start = 0.31666666666666665,
		first_person_hit_anim = "hit_right_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		power_level = 800,
		range_mod = 1.15,
		total_time = 1.1,
		uninterruptible = true,
		crosshair = {
			crosshair_type = "dot",
		},
		action_movement_curve = {
			{
				modifier = 0.3,
				t = 0.1,
			},
			{
				modifier = 0.5,
				t = 0.25,
			},
			{
				modifier = 0.5,
				t = 0.3,
			},
			{
				modifier = 1.5,
				t = 0.35,
			},
			{
				modifier = 1.5,
				t = 0.4,
			},
			{
				modifier = 1.05,
				t = 0.6,
			},
			{
				modifier = 0.75,
				t = 1,
			},
			start_modifier = 0.8,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.6,
			},
			shoot_pressed = {
				action_name = "action_shoot_flame",
				chain_time = 0.7,
				reset_combo = true,
			},
			charge = {
				action_name = "action_charge_flame",
				chain_time = 0.7,
				reset_combo = true,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.6,
			},
		},
		weapon_box = {
			0.15,
			0.15,
			1.2,
		},
		spline_settings = {
			matrices_data_location = "content/characters/player/human/first_person/animations/force_staff/attack_special_swipe_heavy_sweep_bake",
			anchor_point_offset = {
				0,
				-0.2,
				0,
			},
		},
		damage_type = damage_types.blunt_heavy,
		damage_profile = DamageProfileTemplates.heavy_force_staff_bash,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
	},
	action_vent = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_end_event = "vent_end",
		anim_event = "vent_start",
		kind = "vent_warp_charge",
		prevent_sprint = true,
		start_input = "vent",
		stop_input = "vent_release",
		uninterruptible = true,
		vent_source_name = "fx_left_hand",
		vent_vfx = "content/fx/particles/abilities/psyker_venting",
		vo_tag = "ability_venting",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.5,
				t = 0.1,
			},
			{
				modifier = 0.6,
				t = 0.15,
			},
			{
				modifier = 0.7,
				t = 0.4,
			},
			{
				modifier = 0.85,
				t = 5,
			},
			start_modifier = 1,
		},
		running_action_state_to_action_input = {
			fully_vented = {
				input_name = "vent_release",
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = {
				{
					action_name = "grenade_ability",
				},
				{
					action_name = "grenade_ability_quick_throw",
				},
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
			special_action_hold = {
				action_name = "action_stab_start",
				chain_time = 0.4,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.vent_warp_charge_multiplier,
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

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/force_staff"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/force_staff"
weapon_template.spread_template = "default_force_staff_killshot"
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_muzzle = "j_leftweaponattach",
	_overheat = "fx_overheat",
}
weapon_template.charge_effects = {
	sfx_parameter = "charge_level",
	sfx_source_name = "_overheat",
}
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"ranged",
	"force_staff",
	"p2",
}
weapon_template.dodge_template = "killshot"
weapon_template.sprint_template = "support"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.warp_charge_template = "forcestaff_p2_m1"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	forcestaff_p2_m1_damage_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		weapon_handling = {
			action_shoot_flame = {
				weapon_handling_trait_templates.forcestaff_p2_m1_ramp_up_stat,
				display_data = {
					prefix = "loc_ingame_action_one",
					display_stats = {
						__all_basic_stats = true,
					},
					display_group_stats = {
						flamer_ramp_up_times = {},
					},
				},
			},
			action_shoot_charged_flame = {
				weapon_handling_trait_templates.forcestaff_p2_m1_ramp_up_stat,
				display_data = {
					prefix = "loc_ingame_action_two",
					display_stats = {
						__all_basic_stats = true,
					},
					display_group_stats = {
						flamer_ramp_up_times = {},
					},
				},
			},
		},
		damage = {
			action_shoot_flame = {
				damage_trait_templates.forcestaff_p2_m1_braced_dps_stat,
				display_data = {
					prefix = "loc_ingame_action_one",
					display_stats = {
						targets = {
							default_target = {
								power_distribution = {
									attack = {},
								},
							},
						},
					},
				},
			},
			action_shoot_charged_flame = {
				damage_trait_templates.forcestaff_p2_m1_braced_dps_stat,
				display_data = {
					prefix = "loc_ingame_action_two",
					display_stats = {
						targets = {
							{
								power_distribution = {
									attack = {},
								},
							},
						},
					},
				},
			},
		},
	},
	forcestaff_p2_m1_burninating_stat = {
		display_name = "loc_stats_display_burn_stat",
		is_stat_trait = true,
		burninating = {
			base = {
				burninating_trait_templates.forcestaff_p2_m1_burninating_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	forcestaff_p1_m1_vent_speed_stat = {
		display_name = "loc_stats_display_vent_speed",
		is_stat_trait = true,
		warp_charge = {
			base = {
				warp_charge_trait_templates.forcestaff_p2_m1_vent_speed_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	forcestaff_p2_m1_size_of_flame_stat = {
		display_name = "loc_stats_display_flame_size_stat",
		is_stat_trait = true,
		size_of_flame = {
			base = {
				size_of_flame_trait_templates.forcestaff_p2_m1_size_of_flame_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	forcestaff_p2_m1_warp_charge_cost_stat = {
		display_name = "loc_stats_display_warp_resist_stat",
		is_stat_trait = true,
		charge = {
			action_shoot_flame = {
				charge_trait_templates.forcestaff_p2_m1_warp_charge_cost_stat,
				display_data = {
					prefix = "loc_ingame_action_one",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_charge_flame = {
				charge_trait_templates.forcestaff_p2_m1_warp_charge_cost_stat,
				display_data = {
					prefix = "loc_glossary_term_charge",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
			action_shoot_charged_flame = {
				charge_trait_templates.forcestaff_p2_m1_warp_charge_cost_stat,
				display_data = {
					prefix = "loc_ingame_action_two",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
		},
	},
}
weapon_template.traits = {}

local bespoke_forcestaff_p2_traits = table.ukeys(WeaponTraitsBespokeForcestaffP2)

table.append(weapon_template.traits, bespoke_forcestaff_p2_traits)

weapon_template.hipfire_inputs = {
	shoot_pressed = true,
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_warp_weapon",
	},
	{
		display_name = "loc_weapon_keyword_charged_attack",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_forcestaff_p2_m1_attack_primary",
		fire_mode = "semi_auto",
		type = "hipfire",
	},
	secondary = {
		display_name = "loc_forcestaff_p2_m1_attack_primary",
		type = "charge",
	},
	special = {
		desc = "loc_stats_special_action_melee_weapon_bash_forcestaff_desc",
		display_name = "loc_forcestaff_p1_m1_attack_special",
		type = "melee_hand",
	},
}
weapon_template.weapon_card_data = {
	main = {
		{
			header = "primary_attack",
			icon = "charge",
			sub_icon = "semi_auto",
			value_func = "primary_attack",
		},
		{
			header = "secondary_attack",
			icon = "charge",
			value_func = "secondary_attack",
		},
	},
	weapon_special = {
		header = "weapon_bash",
		icon = "melee_hand",
	},
}
weapon_template.special_action_name = "action_stab"

return weapon_template
