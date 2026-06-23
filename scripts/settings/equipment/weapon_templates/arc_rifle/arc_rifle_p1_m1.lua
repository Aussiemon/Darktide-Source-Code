-- chunkname: @scripts/settings/equipment/weapon_templates/arc_rifle/arc_rifle_p1_m1.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitScanTemplates = require("scripts/settings/projectile/hit_scan_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")
local WeaponTraitsBespokeArcRifleP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_arc_rifle_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local attack_types = AttackSettings.attack_types
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local RELOAD_TEMPLATE = ReloadTemplates.arc_rifle
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local ammo_trait_templates = WeaponTraitTemplates[template_types.ammo]
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local weapon_chain_lightning_trait_templates = WeaponTraitTemplates[template_types.weapon_chain_lightning]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local weapon_chain_lightning_husk_visual_template = {
	extra_angle_stat_buff = "chain_lightning_arc_rifle_max_angle",
	jump_time = 0.01,
	jump_time_multiplier_stat_buff = "chain_lightning_jump_time_multiplier",
	max_jumps = 2,
	max_jumps_stat_buff = "chain_lightning_arc_rifle_max_jumps",
	max_radius_stat_buff = "chain_lightning_arc_rifle_max_radius",
	max_z_diff_stat_buff = "chain_lightning_max_z_diff",
	radius = 5.5,
	staff = false,
	max_targets = {
		num_targets = 1,
	},
	max_angle = math.degrees_to_radians(80),
}
local weapon_chain_lightning_braced_husk_visual_template = {
	extra_angle_stat_buff = "chain_lightning_arc_rifle_max_angle",
	jump_time = 0.01,
	jump_time_multiplier_stat_buff = "chain_lightning_jump_time_multiplier",
	max_jumps = 3,
	max_jumps_stat_buff = "chain_lightning_arc_rifle_max_jumps",
	max_radius_stat_buff = "chain_lightning_arc_rifle_max_radius",
	max_z_diff_stat_buff = "chain_lightning_max_z_diff",
	radius = 5.5,
	staff = false,
	max_targets = {
		num_targets = 1,
	},
	max_angle = math.degrees_to_radians(80),
}
local weapon_template = {}

weapon_template.action_inputs = {
	shoot = {
		buffer_time = 0.35,
		input_sequence = {
			{
				input = "action_one_hold",
				value = true,
			},
		},
	},
	shoot_release = {
		buffer_time = 0.36,
		input_sequence = {
			{
				input = "action_one_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	brace_shoot = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				input = "action_one_hold",
				value = true,
			},
		},
	},
	brace = {
		buffer_time = 0.4,
		max_queue = 1,
		input_sequence = {
			{
				input = "action_two_hold",
				value = true,
				input_setting = {
					input = "action_two_pressed",
					setting = "toggle_ads",
					setting_value = true,
					value = true,
				},
			},
		},
	},
	brace_release = {
		buffer_time = 0.3,
		input_sequence = {
			{
				input = "action_two_hold",
				value = false,
				time_window = math.huge,
				input_setting = {
					input = "action_two_pressed",
					setting = "toggle_ads",
					setting_value = true,
					value = true,
					time_window = math.huge,
				},
			},
		},
	},
	reload = {
		buffer_time = 0.2,
		input_sequence = {
			{
				input = "weapon_reload_pressed",
				value = true,
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
	special_action_release = {
		buffer_time = 0.2,
		input_sequence = {
			{
				hold_input = "weapon_extra_release",
				input = "weapon_extra_release",
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
				value = false,
			},
		},
	},
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		input = "shoot",
		transition = {
			{
				input = "shoot_release",
				transition = "base",
			},
			{
				input = "reload",
				transition = "base",
			},
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "combat_ability",
				transition = "base",
			},
			{
				input = "grenade_ability",
				transition = "base",
			},
			{
				input = "brace",
				transition = "base",
			},
			{
				input = "special_action_hold",
				transition = "base",
			},
		},
	},
	{
		input = "brace",
		transition = {
			{
				input = "brace_release",
				transition = "base",
			},
			{
				input = "brace_shoot",
				transition = {
					{
						input = "reload",
						transition = "base",
					},
					{
						input = "brace_release",
						transition = "base",
					},
					{
						input = "shoot_release",
						transition = "previous",
					},
					{
						input = "wield",
						transition = "base",
					},
				},
			},
			{
				input = "reload",
				transition = "base",
			},
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "combat_ability",
				transition = "base",
			},
			{
				input = "grenade_ability",
				transition = "base",
			},
		},
	},
	{
		input = "reload",
		transition = "base",
	},
	{
		input = "wield",
		transition = "stay",
	},
	{
		input = "special_action_hold",
		transition = {
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "special_action_light",
				transition = "base",
			},
			{
				input = "combat_ability",
				transition = "base",
			},
			{
				input = "grenade_ability",
				transition = "base",
			},
			{
				input = "reload",
				transition = "base",
			},
		},
	},
}

ActionInputHierarchy.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

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
		total_time = 0.45,
		uninterruptible = true,
		conditional_state_to_action_input = {
			started_reload = {
				input_name = "reload",
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			special_action_hold = {
				action_name = "action_bash_start",
				chain_time = 0.25,
			},
		},
	},
	action_shoot_hip = {
		ammunition_usage = 1,
		anim_end_event = nil,
		anim_event = nil,
		chain_visual_jump_validation_function_name = "target_alive_and_arc_electrocuted",
		kind = "shoot_hit_scan",
		prevent_sprint = true,
		recoil_template = "arc_rifle_p1_m1_recoil_hip",
		spread_template = "arc_rifle_p1_m1_spread_hip",
		sprint_ready_up_time = 0.4,
		start_input = "shoot",
		stop_input = "shoot_release",
		suppression_template = "arc_rifle_p1_m1_supression",
		weapon_chain_lightning_template = "arc_rifle_p1_arc",
		weapon_handling_template = "arc_rifle_p1_m1_full_auto",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.65,
				t = 0.2,
			},
			{
				modifier = 0.7,
				t = 0.3,
			},
			{
				modifier = 0.65,
				t = 0.5,
			},
			start_modifier = 0.75,
		},
		fx = {
			auto_fire_time_parameter_name = "wpn_fire_interval",
			crit_shoot_sfx_alias = "critical_shot_extra",
			looping_shoot_sfx_alias = "ranged_shooting",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			num_pre_loop_events = 1,
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			post_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			pre_loop_shoot_sfx_alias = "ranged_pre_loop_shot",
			pre_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			line_effect = LineEffects.arc_beam,
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			hit_scan_template = HitScanTemplates.arc_rifle_p1_m1_hitscan,
			damage_type = damage_types.arc_rifle,
		},
		husk_chain_lightning_template = weapon_chain_lightning_husk_visual_template,
		chain_damage_settings = {
			damage_profile = DamageProfileTemplates.arc_rifle_arc_chain_lightning_link_damage,
			damage_type = damage_types.arc_chain,
			attack_type = attack_types.arc,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			brace = {
				action_name = "action_brace",
			},
			reload = {
				action_name = "action_reload",
			},
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 0.45,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return false
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_shoot_braced = {
		ammunition_usage = 1,
		anim_end_event = nil,
		anim_event = nil,
		chain_visual_jump_validation_function_name = "target_alive_and_arc_electrocuted",
		kind = "shoot_hit_scan",
		prevent_sprint = true,
		recoil_template = "arc_rifle_p1_m1_recoil_ads",
		spread_template = "arc_rifle_p1_m1_spread_ads",
		sprint_ready_up_time = 0.3,
		start_input = "brace_shoot",
		stop_input = "shoot_release",
		suppression_template = "arc_rifle_p1_m1_supression",
		weapon_chain_lightning_template = "arc_rifle_p1_arc_braced",
		weapon_handling_template = "arc_rifle_p1_m1_braced",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.2,
			},
			{
				modifier = 0.8,
				t = 0.3,
			},
			{
				modifier = 0.85,
				t = 0.5,
			},
			start_modifier = 0.75,
		},
		fx = {
			auto_fire_time_parameter_name = "wpn_fire_interval",
			crit_shoot_sfx_alias = "critical_shot_extra",
			looping_shoot_sfx_alias = "ranged_shooting",
			no_ammo_shoot_sfx_alias = "ranged_no_ammo",
			num_pre_loop_events = 1,
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			post_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			pre_loop_shoot_sfx_alias = "ranged_pre_loop_shot",
			pre_loop_shoot_tail_sfx_alias = "ranged_shot_tail",
			line_effect = LineEffects.arc_beam,
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			hit_scan_template = HitScanTemplates.arc_rifle_p1_m1_hitscan,
			damage_type = damage_types.arc_rifle,
		},
		husk_chain_lightning_template = weapon_chain_lightning_braced_husk_visual_template,
		chain_damage_settings = {
			damage_profile = DamageProfileTemplates.arc_rifle_arc_chain_lightning_link_damage,
			damage_type = damage_types.arc_chain,
			attack_type = attack_types.arc,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
			},
			brace_shoot = {
				action_name = "action_shoot_braced",
				chain_time = 0.195,
			},
			brace_release = {
				action_name = "action_unbrace",
				chain_time = 0,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return false
		end,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_brace = {
		kind = "aim",
		start_input = "brace",
		total_time = 0.75,
		smart_targeting_template = SmartTargetingTemplates.ogryn_heavystubber_p2_braced,
		haptic_trigger_template = HapticTriggerTemplates.ranged.heavy_stubber_braced,
		action_movement_curve = {
			{
				modifier = 0.7,
				t = 0.35,
			},
			{
				modifier = 0.8,
				t = 0.55,
			},
			{
				modifier = 1,
				t = 0.75,
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
			reload = {
				action_name = "action_reload",
				chain_time = 0.1,
			},
			brace_shoot = {
				action_name = "action_shoot_braced",
				chain_time = 0.25,
			},
			brace_release = {
				action_name = "action_unbrace",
				chain_time = 0.1,
			},
		},
		action_keywords = {
			"braced",
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
		},
	},
	action_unbrace = {
		kind = "unaim",
		start_input = "brace_release",
		total_time = 0.5,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.25,
			},
			brace = {
				action_name = "action_brace",
				chain_time = 0.15,
			},
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 0.15,
			},
		},
	},
	action_reload = {
		abort_sprint = true,
		allowed_during_sprint = true,
		kind = "reload_state",
		sprint_requires_press_to_interrupt = true,
		start_input = "reload",
		stop_alternate_fire = true,
		total_time = 6,
		weapon_handling_template = "time_scale_1",
		crosshair = {
			crosshair_type = "none",
		},
		anim_end_event_func = function (time_in_action, action_settings, end_reason, condition_func_params)
			local anim_end_event, anim_end_event_3p

			if condition_func_params then
				local time_scale = condition_func_params.weapon_action_component.time_scale

				time_scale = time_scale ~= 0 and time_scale or 1

				local reload_state = ReloadStates.reload_state(RELOAD_TEMPLATE, condition_func_params.inventory_slot_component)
				local abort_anims = reload_state.abort_anims

				if abort_anims then
					for ii = #abort_anims, 1, -1 do
						local data = abort_anims[ii]

						if time_in_action > data.t / time_scale then
							anim_end_event = data.anim_1p
							anim_end_event_3p = data.anim_3p

							break
						end
					end
				else
					anim_end_event = "reload_cancel"
				end
			else
				anim_end_event = "reload_cancel"
			end

			local should_skip_anim = end_reason == "action_complete"

			if should_skip_anim then
				return nil
			else
				return anim_end_event, anim_end_event_3p
			end
		end,
		action_movement_curve = {
			{
				modifier = 0.775,
				t = 0.05,
			},
			{
				modifier = 0.75,
				t = 2.075,
			},
			{
				modifier = 0.59,
				t = 3.25,
			},
			{
				modifier = 0.6,
				t = 4.3,
			},
			{
				modifier = 0.85,
				t = 5.8,
			},
			{
				modifier = 0.9,
				t = 6.9,
			},
			{
				modifier = 1,
				t = 7,
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
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 5.85,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_bash_start = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_end_event = "attack_finished",
		anim_event = "attack_charge_stab",
		anim_event_3p = "attack_charge_stab",
		kind = "windup",
		prevent_sprint = true,
		sprint_requires_press_to_interrupt = true,
		start_input = "special_action_hold",
		stop_alternate_fire = true,
		uninterruptible = true,
		total_time = math.huge,
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
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			special_action_light = {
				action_name = "action_bash",
				chain_time = 0.25,
			},
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 0.275,
			},
			brace = {
				action_name = "action_brace",
				chain_time = 0.15,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_bash = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_event = "attack_left_diagonal_up",
		anim_event_3p = "attack_left_diagonal_up",
		damage_window_end = 0.3,
		damage_window_start = 0.13333333333333333,
		first_person_hit_anim = "hit_left_shake",
		first_person_hit_stop_anim = "attack_hit",
		hit_armor_anim = "attack_hit",
		hit_stop_anim = nil,
		kind = "sweep",
		range_mod = 1.15,
		sprint_requires_press_to_interrupt = true,
		start_input = nil,
		stop_alternate_fire = true,
		total_time = 1.1,
		uninterruptible = true,
		weapon_handling_template = "time_scale_1",
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
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			reload = {
				action_name = "action_reload",
			},
			shoot = {
				action_name = "action_shoot_hip",
				chain_time = 0.85,
			},
			brace = {
				action_name = "action_brace",
				chain_time = 0.6,
			},
		},
		weapon_box = {
			0.25,
			1,
			0.7,
		},
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/double_barrel/attack_left_diagonal_up_bash",
				anchor_point_offset = {
					0,
					1.25,
					-0.1,
				},
			},
		},
		damage_type = damage_types.weapon_butt,
		damage_profile = DamageProfileTemplates.shotgun_weapon_special_bash_light,
		herding_template = HerdingTemplates.uppercut,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_inspect_3p = {
		action_prevents_jump = true,
		block_first_person_rotation = true,
		can_crouch = false,
		can_jump = false,
		force_look = true,
		kind = "inspect_3p",
		lock_view = false,
		skip_3p_anims = false,
		stop_input = "inspect_stop",
		total_time = math.huge,
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		crosshair = {
			crosshair_type = "inspect",
		},
		allowed_chain_actions = {
			inspect_3p_stop = {
				action_name = "action_inspect",
				chain_time = 1.1,
			},
		},
		action_movement_curve = {
			{
				modifier = 0,
				t = 0,
			},
			start_modifier = 0,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
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
		allowed_chain_actions = {
			inspect_3p_start = {
				action_name = "action_inspect_3p",
				chain_time = 0.75,
			},
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
}
weapon_template.base_stats = {
	arc_rifle_p1_m1_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.default_dps_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_shoot_braced = {
				damage_trait_templates.default_dps_stat,
			},
		},
	},
	arc_rifle_p1_m1_reload_speed_stat = {
		display_name = "loc_stats_display_reload_speed_stat",
		is_stat_trait = true,
		weapon_handling = {
			action_reload = {
				weapon_handling_trait_templates.default_reload_speed_modify,
				display_data = {
					display_stats = {
						__all_basic_stats = true,
						time_scale = {
							display_name = "loc_weapon_stats_display_reload_speed",
						},
					},
				},
			},
		},
	},
	arc_rifle_p1_m1_arc_stat = {
		description = "loc_stats_display_arc_stat_desc",
		display_name = "loc_stats_display_arc_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				overrides = {
					arc_rifle_arc_chain_lightning_link_damage = {
						damage_trait_templates.arc_rifle_p1_arc_stat,
						display_data = {
							damage_profile_path = {
								"chain_damage_settings",
								"damage_profile",
							},
							display_stats = {
								targets = {
									{
										power_distribution = {
											attack = {
												display_name = "loc_weapon_stats_display_arc_damage",
											},
										},
									},
								},
							},
						},
					},
				},
			},
			action_shoot_braced = {
				overrides = {
					arc_rifle_arc_chain_lightning_link_damage = {
						damage_trait_templates.arc_rifle_p1_arc_stat,
					},
				},
			},
		},
		weapon_chain_lightning = {
			action_shoot_hip = {
				weapon_chain_lightning_trait_templates.arc_rifle_p1_arc_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
			action_shoot_braced = {
				weapon_chain_lightning_trait_templates.arc_rifle_p1_arc_stat,
			},
		},
	},
	arc_rifle_p1_m1_mobility_stat = {
		display_name = "loc_stats_display_mobility_stat",
		is_stat_trait = true,
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_dodge"),
			},
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_sprint"),
			},
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_stat,
				display_data = WeaponBarUIDescriptionTemplates.create_template("mobility_curve"),
			},
		},
	},
	arc_rifle_p1_m1_ammo_stat = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_stat,
				display_data = {
					display_stats = WeaponBarUIDescriptionTemplates.default_bar_stats.ammo.display_stats,
				},
			},
		},
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/arc_rifle"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/arc_rifle"
weapon_template.reload_template = ReloadTemplates.arc_rifle
weapon_template.spread_template = "arc_rifle_p1_m1_spread_hip"
weapon_template.recoil_template = "arc_rifle_p1_m1_recoil_hip"
weapon_template.suppression_template = "arc_rifle_p1_m1_supression"
weapon_template.combo_reset_duration = 0.5
weapon_template.ammo_template = "arc_rifle_p1_m1"
weapon_template.semi_auto_chain_factor = 0.15
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_ammo_and_started_reload",
		input_name = "reload",
	},
	{
		conditional_state = "no_ammo_with_delay",
		input_name = "reload",
	},
}
weapon_template.no_ammo_delay = 0.45
weapon_template.hud_configuration = {
	uses_ammunition = true,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5
weapon_template.chain_settings = {
	left_fx_source_name = "_muzzle",
	right_fx_source_name = "_muzzle",
	skip_link_to_player_effect = true,
	skip_no_target_effect = true,
	triggering_action_kind = "shoot_hit_scan",
	chain_damage_settings = {
		damage_profile = DamageProfileTemplates.arc_rifle_arc_chain_lightning_link_damage,
		damage_type = damage_types.arc_chain,
	},
}
weapon_template.fx_sources = {
	_mag_well = "fx_reload",
	_muzzle = "fx_muzzle",
	_overheat = "fx_overheat",
	_vent = "fx_stock_01",
}
weapon_template.crosshair = {
	crosshair_type = "bfg",
}
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	look_delta_template = "lasgun_brace_light",
	recoil_template = "arc_rifle_p1_m1_recoil_ads",
	spread_template = "arc_rifle_p1_m1_spread_ads",
	start_anim_event = "to_braced",
	start_anim_event_3p = nil,
	stop_anim_event = "to_unaim_braced",
	stop_anim_event_3p = nil,
	suppression_template = "arc_rifle_p1_m1_supression",
	sway_template = "ogyn_heavy_stubber_sway",
	uninterruptible = true,
	crosshair = {
		crosshair_type = "bfg",
	},
	camera = {
		custom_vertical_fov = 60,
		near_range = 0.025,
		vertical_fov = 60,
	},
	movement_speed_modifier = {
		{
			modifier = 0.775,
			t = 0.05,
		},
		{
			modifier = 0.74,
			t = 0.075,
		},
		{
			modifier = 0.89,
			t = 0.25,
		},
		{
			modifier = 0.8,
			t = 0.3,
		},
		{
			modifier = 0.7,
			t = 0.4,
		},
		{
			modifier = 0.72,
			t = 0.5,
		},
		{
			modifier = 0.75,
			t = 2,
		},
	},
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_high_damage",
	},
	{
		display_name = "loc_weapon_keyword_arc_weapon",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_ranged_attack_primary",
		fire_mode = "full_auto",
		type = "hipfire",
	},
	secondary = {
		display_name = "loc_ranged_attack_secondary_braced",
		fire_mode = "full_auto",
		type = "brace",
	},
	special = {
		desc = "loc_stats_special_action_melee_weapon_bash_desc",
		display_name = "loc_weapon_special_weapon_bash",
		type = "melee_hand",
	},
}
weapon_template.weapon_card_data = {
	main = {
		{
			header = "hipfire",
			icon = "charge",
			sub_icon = "full_auto",
			value_func = "primary_attack",
		},
		{
			header = "brace",
			icon = "charge",
			sub_icon = "full_auto",
			value_func = "secondary_attack",
		},
		{
			header = "ammo",
			value_func = "ammo",
		},
	},
	weapon_special = {
		header = "weapon_bash",
		icon = "melee_hand",
	},
}
weapon_template.displayed_attack_ranges = {
	max = 0,
	min = 0,
}
weapon_template.keywords = {
	"ranged",
	"arc_rifle",
	"p1",
}
weapon_template.can_use_while_vaulting = false
weapon_template.dodge_template = "plasma_rifle"
weapon_template.sprint_template = "support"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.arc_rifle
weapon_template.smart_targeting_template = SmartTargetingTemplates.assault
weapon_template.haptic_trigger_template = HapticTriggerTemplates.ranged.arc_rifle
weapon_template.traits = {}

local bespoke_arc_rifle_p1_traits = table.ukeys(WeaponTraitsBespokeArcRifleP1)

table.append(weapon_template.traits, bespoke_arc_rifle_p1_traits)

weapon_template.displayed_weapon_stats = "arc_rifle_p1_m1"

weapon_template.action_inspect_3p_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_inspect_3p"
end

weapon_template.action_inspect_3p_base_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_inspect"
end

return weapon_template
