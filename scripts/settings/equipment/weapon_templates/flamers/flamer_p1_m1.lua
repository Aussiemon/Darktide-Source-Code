-- chunkname: @scripts/settings/equipment/weapon_templates/flamers/flamer_p1_m1.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FlamerGasTemplates = require("scripts/settings/projectile/flamer_gas_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeFlamerP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_flamer_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local ammo_trait_templates = WeaponTraitTemplates[template_types.ammo]
local burninating_trait_templates = WeaponTraitTemplates[template_types.burninating]
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local size_of_flame_trait_templates = WeaponTraitTemplates[template_types.size_of_flame]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local weapon_template = {}

weapon_template.action_inputs = {
	shoot_pressed = {
		buffer_time = 0.5,
		max_queue = 2,
		input_sequence = {
			{
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	brace_pressed = {
		buffer_time = 0.1,
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
		buffer_time = 0.1,
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
	shoot_braced = {
		buffer_time = 0.25,
		input_sequence = {
			{
				input = "action_one_hold",
				value = true,
			},
		},
	},
	shoot_braced_release = {
		buffer_time = 0.41,
		input_sequence = {
			{
				input = "action_one_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	reload = {
		buffer_time = 0,
		clear_input_queue = true,
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
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		input = "shoot_pressed",
		transition = "stay",
	},
	{
		input = "brace_pressed",
		transition = {
			{
				input = "brace_release",
				transition = "base",
			},
			{
				input = "shoot_braced",
				transition = {
					{
						input = "brace_release",
						transition = "base",
					},
					{
						input = "shoot_braced_release",
						transition = "previous",
					},
					{
						input = "wield",
						transition = "base",
					},
					{
						input = "reload",
						transition = "base",
					},
					{
						input = "special_action",
						transition = "previous",
					},
				},
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
				input = "reload",
				transition = "base",
			},
			{
				input = "special_action",
				transition = "stay",
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
		input = "special_action",
		transition = "base",
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
		kind = "ranged_wield",
		total_time = 1.7,
		uninterruptible = true,
		wield_anim_event = "equip",
		wield_reload_anim_event = "equip_reload",
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
			reload = {
				action_name = "action_reload",
				chain_time = 0.8,
			},
			brace_pressed = {
				action_name = "action_brace",
				chain_time = 1.35,
			},
			shoot_pressed = {
				action_name = "action_shoot",
				chain_time = 1.35,
			},
		},
	},
	action_shoot = {
		abort_sprint = false,
		allowed_during_sprint = false,
		ammunition_usage = 1,
		anim_event = "attack_shoot_start",
		first_shot_only_sound_reflection = true,
		ignore_shooting_look_delta_anim_control = true,
		kind = "flamer_gas_burst",
		sensitivity_modifier = 0.5,
		sprint_ready_up_time = 0.25,
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot_pressed",
		total_time = 0.75,
		weapon_handling_template = "flamer_burst",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.2,
			},
			{
				modifier = 0.9,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.5,
		},
		fx = {
			duration = 0.3,
			impact_effect = "content/fx/particles/weapons/rifles/zealot_flamer/zealot_flamer_impact_delay",
			looping_3d_sound_effect = "wwise/events/weapon/play_flamethrower_fire_loop_3d",
			looping_shoot_sfx_alias = "ranged_shooting",
			out_of_ammo_sfx_alias = "ranged_out_of_ammo",
			pre_shoot_abort_sfx_alias = "ranged_abort",
			pre_shoot_sfx_alias = "ranged_pre_shoot",
			stop_looping_3d_sound_effect = "wwise/events/weapon/stop_flamethrower_fire_loop_3d",
			stream_effect = {
				name = "content/fx/particles/weapons/rifles/player_flamer/flamer_code_control_burst",
				name_3p = "content/fx/particles/weapons/rifles/player_flamer/flamer_code_control_3p",
				speed = 35,
			},
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			flamer_gas_template = FlamerGasTemplates.burst,
			damage_type = damage_types.burning,
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			wield = {
				action_name = "action_unwield",
			},
			brace_pressed = {
				action_name = "action_brace",
			},
			reload = {
				action_name = "action_reload",
			},
			special_action = {
				action_name = "push",
				chain_time = 0.5,
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return false
		end,
	},
	action_shoot_braced = {
		action_prevents_jump = true,
		allowed_during_sprint = true,
		ammunition_usage = 1,
		anim_end_event = "attack_finished",
		anim_event = "attack_shoot",
		first_shot_only_sound_reflection = true,
		ignore_shooting_look_delta_anim_control = true,
		kind = "flamer_gas",
		minimum_hold_time = 0.4,
		sprint_ready_up_time = 0,
		start_input = "shoot_braced",
		stop_input = "shoot_braced_release",
		weapon_handling_template = "flamer_auto",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.1,
				t = 0.35,
			},
			{
				modifier = 0.2,
				t = 0.55,
			},
			{
				modifier = 0.25,
				t = 0.75,
			},
			{
				modifier = 0.5,
				t = 5,
			},
			start_modifier = 0.5,
		},
		fx = {
			impact_effect = "content/fx/particles/weapons/rifles/zealot_flamer/zealot_flamer_impact_delay",
			looping_3d_sound_effect = "wwise/events/weapon/play_flamethrower_fire_loop_3d",
			looping_shoot_sfx_alias = "ranged_shooting",
			pre_shoot_abort_sfx_alias = "ranged_abort",
			pre_shoot_sfx_alias = "ranged_pre_shoot",
			stop_looping_3d_sound_effect = "wwise/events/weapon/stop_flamethrower_fire_loop_3d",
			stream_effect = {
				name = "content/fx/particles/weapons/rifles/player_flamer/flamer_code_control",
				name_3p = "content/fx/particles/weapons/rifles/player_flamer/flamer_code_control_3p",
				speed = 45,
			},
		},
		fire_configuration = {
			flamer_gas_template = FlamerGasTemplates.auto,
			damage_type = damage_types.burning,
		},
		running_action_state_to_action_input = {
			clip_empty = {
				input_name = "reload",
			},
			reserve_empty = {
				input_name = "shoot_braced_release",
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
			reload = {
				action_name = "action_reload",
			},
			brace_release = {
				action_name = "action_unbrace",
				chain_time = 0,
			},
			special_action = {
				action_name = "push",
				chain_time = 0.4,
			},
		},
		action_keywords = {
			"braced",
			"braced_shooting",
		},
	},
	action_brace = {
		action_prevents_jump = true,
		kind = "aim",
		start_input = "brace_pressed",
		total_time = 1.35,
		smart_targeting_template = SmartTargetingTemplates.alternate_fire_slow_brace,
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
				chain_time = 0.2,
			},
			shoot_braced = {
				action_name = "action_shoot_braced",
				chain_time = 0.6,
			},
			brace_release = {
				action_name = "action_unbrace",
				chain_time = 0.5,
			},
			special_action = {
				action_name = "push",
				chain_time = 0.4,
			},
		},
		action_keywords = {
			"braced",
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
			brace_pressed = {
				action_name = "action_brace",
				chain_time = 0.45,
			},
			special_action = {
				action_name = "push",
				chain_time = 0.25,
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
		total_time = 4,
		crosshair = {
			crosshair_type = "none",
		},
		action_movement_curve = {
			{
				modifier = 0.75,
				t = 0.5,
			},
			{
				modifier = 0.95,
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
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.reload_speed,
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	push = {
		anim_event = "attack_push",
		block_duration = 0.5,
		damage_time = 0.2,
		kind = "push",
		push_radius = 1.5,
		start_input = "special_action",
		total_time = 1,
		crosshair = {
			crosshair_type = "dot",
		},
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
			special_action = {
				action_name = "push",
				chain_time = 0.9,
			},
			brace_pressed = {
				action_name = "action_brace",
				chain_time = 0.6,
			},
			brace_release = {
				action_name = "action_unbrace",
				chain_time = 0.4,
			},
			reload = {
				action_name = "action_reload",
				chain_time = 0.4,
			},
			shoot_pressed = {
				action_name = "action_shoot",
				chain_time = 0.6,
			},
		},
		inner_push_rad = math.pi * 0.1,
		outer_push_rad = math.pi * 0.2,
		inner_damage_profile = DamageProfileTemplates.weapon_special_push,
		inner_damage_type = damage_types.weapon_butt,
		outer_damage_profile = DamageProfileTemplates.weapon_special_push_outer,
		outer_damage_type = damage_types.weapon_butt,
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
	action_inspect = {
		anim_end_event = "inspect_end",
		anim_event = "inspect_start",
		kind = "inspect",
		lock_view = true,
		skip_3p_anims = true,
		start_input = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect",
		},
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/flamer_rifle"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/flamer_rifle"
weapon_template.reload_template = ReloadTemplates.flamer_rifle
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
weapon_template.no_ammo_delay = 0.4
weapon_template.hud_configuration = {
	uses_ammunition = true,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.ammo_template = "flamer_p1_m1"
weapon_template.burninating_template = "flamer_p1_m1"
weapon_template.size_of_flame_template = "flamer_p1_m1"
weapon_template.fx_sources = {
	_muzzle = "fx_muzzle_02",
	_pilot = "fx_pilot",
}
weapon_template.crosshair = {
	crosshair_type = "flamer",
}
weapon_template.hit_marker_type = "center"
weapon_template.alternate_fire_settings = {
	look_delta_template = "lasgun_brace_light",
	start_anim_event = "to_braced",
	stop_anim_event = "to_unaim_braced",
	sway_template = "default_lasgun_killshot",
	uninterruptible = false,
	crosshair = {
		crosshair_type = "flamer",
	},
	movement_speed_modifier = {
		{
			modifier = 0.85,
			t = 0.05,
		},
		{
			modifier = 0.75,
			t = 0.075,
		},
		{
			modifier = 0.6,
			t = 0.25,
		},
		{
			modifier = 0.3,
			t = 0.3,
		},
		{
			modifier = 0.4,
			t = 0.4,
		},
		{
			modifier = 0.5,
			t = 0.5,
		},
		{
			modifier = 0.55,
			t = 2,
		},
	},
}
weapon_template.keywords = {
	"ranged",
	"flamer",
	"p1",
}
weapon_template.dodge_template = "plasma_rifle"
weapon_template.sprint_template = "support"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.haptic_trigger_template = HapticTriggerTemplates.ranged.flamer
weapon_template.overclocks = {
	ammo_up_size_of_flame_down = {
		flamer_p1_m1_ammo_stat = 0.1,
		flamer_p1_m1_size_of_flame_stat = -0.1,
	},
	mobility_up_ammo_down = {
		flamer_p1_m1_ammo_stat = -0.2,
		flamer_p1_m1_mobility_stat = 0.2,
	},
	damage_up_size_of_flame_down = {
		flamer_p1_m1_damage_stat = 0.1,
		flamer_p1_m1_size_of_flame_stat = -0.2,
	},
	burninating_up_damage_down = {
		flamer_p1_m1_burninating_stat = 0.2,
		flamer_p1_m1_damage_stat = -0.1,
	},
	size_of_flame_up_mobility_down = {
		flamer_p1_m1_mobility_stat = -0.1,
		flamer_p1_m1_size_of_flame_stat = 0.1,
	},
}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	flamer_p1_m1_ammo_stat = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.flamer_p1_m1_ammo_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	flamer_p1_m1_mobility_stat = {
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
	flamer_p1_m1_burninating_stat = {
		display_name = "loc_stats_display_burn_stat",
		is_stat_trait = true,
		burninating = {
			base = {
				burninating_trait_templates.flamer_p1_m1_burninating_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	flamer_p1_m1_damage_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		weapon_handling = {
			action_shoot = {
				weapon_handling_trait_templates.flamer_p1_m1_ramp_up_stat,
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
			action_shoot_braced = {
				weapon_handling_trait_templates.flamer_p1_m1_ramp_up_stat,
				display_data = {
					prefix = "loc_weapon_stats_display_braced",
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
			action_shoot = {
				damage_trait_templates.flamer_p1_m1_braced_dps_stat,
				display_data = {
					display_stats = {
						targets = {
							{
								power_distribution = {
									attack = {
										display_name = "loc_weapon_stats_display_hip_fire",
									},
								},
							},
						},
					},
				},
			},
			action_shoot_braced = {
				damage_trait_templates.flamer_p1_m1_braced_dps_stat,
				display_data = {
					display_stats = {
						targets = {
							{
								power_distribution = {
									attack = {
										display_name = "loc_weapon_stats_display_braced_damage",
									},
								},
							},
						},
					},
				},
			},
		},
	},
	flamer_p1_m1_size_of_flame_stat = {
		display_name = "loc_stats_display_flame_size_stat",
		is_stat_trait = true,
		size_of_flame = {
			base = {
				size_of_flame_trait_templates.flamer_p1_m1_size_of_flame_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
}
weapon_template.traits = {}

local bespoke_forcestaff_p1_traits = table.ukeys(WeaponTraitsBespokeFlamerP1)

table.append(weapon_template.traits, bespoke_forcestaff_p1_traits)

weapon_template.perks = {
	flamer_p1_m1_ammo_perk = {
		display_name = "loc_trait_display_flamer_p1_m1_ammo_perk",
		ammo = {
			base = {
				ammo_trait_templates.default_ammo_perk,
			},
		},
	},
	flamer_p1_m1_mobility_perk = {
		display_name = "loc_trait_display_flamer_p1_m1_mobility_perk",
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_perk,
			},
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_perk,
			},
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_perk,
			},
		},
	},
	flamer_p1_m1_burninating_perk = {
		display_name = "loc_trait_display_flamer_p1_m1_burninating_perk",
		burninating = {
			base = {
				burninating_trait_templates.flamer_p1_m1_burninating_perk,
			},
		},
	},
	flamer_p1_m1_damage_perk = {
		display_name = "loc_trait_display_flamer_p1_m1_damage_perk",
		weapon_handling = {
			action_shoot_braced = {
				weapon_handling_trait_templates.flamer_p1_m1_ramp_up_perk,
			},
		},
		damage = {
			action_shoot_braced = {
				damage_trait_templates.flamer_p1_m1_braced_dps_perk,
			},
		},
	},
	flamer_p1_m1_range_perk = {
		display_name = "loc_trait_display_flamer_p1_m1_range_perk",
		size_of_flame = {
			base = {
				size_of_flame_trait_templates.flamer_p1_m1_range_perk,
			},
		},
	},
	flamer_p1_m1_spread_angle_perk = {
		display_name = "loc_trait_display_flamer_p1_m1_spread_angle_perk",
		size_of_flame = {
			base = {
				size_of_flame_trait_templates.flamer_p1_m1_spread_angle_perk,
			},
		},
	},
}
weapon_template.weapon_temperature_settings = {
	barrel_threshold = 0.4,
	decay_rate = 0.025,
	grace_time = 0.4,
	increase_rate = 0.035,
	use_charge = false,
}
weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_spray_n_pray",
	},
	{
		display_name = "loc_weapon_keyword_close_combat",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_ranged_attack_primary",
		fire_mode = "semi_auto",
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
			icon = "hipfire",
			sub_icon = "semi_auto",
			value_func = "primary_attack",
		},
		{
			header = "brace",
			icon = "brace",
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
weapon_template.explicit_combo = {
	{
		"action_shoot",
	},
	{
		"action_shoot_braced",
	},
}
weapon_template.special_action_name = "push"

return weapon_template
