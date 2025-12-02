-- chunkname: @scripts/settings/equipment/weapon_templates/missile_launchers/missile_launcher.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local ReloadTemplates = require("scripts/settings/equipment/reload_templates/reload_templates")
local ShotshellTemplates = require("scripts/settings/projectile/shotshell_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeThumperP2 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_thumper_p2")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local template_types = WeaponTweakTemplateSettings.template_types
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local ammo_trait_templates = WeaponTraitTemplates[template_types.ammo]
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local explosion_trait_templates = WeaponTraitTemplates[template_types.explosion]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local weapon_template = {}

weapon_template.is_grenade_ability_weapon = true
weapon_template.action_inputs = {
	shoot_charge = {
		buffer_time = 0.5,
		input_sequence = {
			{
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	charged_enough = {
		buffer_time = 0.3,
		input_sequence = nil,
	},
	shoot_charge_released = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "action_one_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	shoot_cancel = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "action_two_pressed",
				value = true,
			},
		},
	},
	brace_shoot = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	brace_charge = {
		buffer_time = 0,
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
	brace_cancel = {
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
	wield = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				inputs = wield_inputs,
			},
		},
	},
	unwield_to_previous = {
		buffer_time = 0,
		dont_queue = true,
		input_sequence = nil,
	},
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		input = "shoot_charge",
		transition = {
			{
				input = "charged_enough",
				transition = {
					{
						input = "shoot_charge_released",
						transition = "base",
					},
					{
						input = "unwield_to_previous",
						transition = "base",
					},
				},
			},
			{
				input = "shoot_cancel",
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
		input = "brace_charge",
		transition = {
			{
				input = "brace_shoot",
				transition = {
					{
						input = "shoot_charge_released",
						transition = "base",
					},
					{
						input = "unwield_to_previous",
						transition = "base",
					},
				},
			},
			{
				input = "brace_cancel",
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
		input = "wield",
		transition = "stay",
	},
	{
		input = "unwield_to_previous",
		transition = "base",
	},
}

ActionInputHierarchy.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
	action_wield = {
		abort_sprint = true,
		allowed_during_sprint = false,
		anim_event = "equip",
		kind = "wield",
		prevent_sprint = true,
		total_time = 0.5,
		uninterruptible = true,
		vo_tag = "broker_missile_launcher",
		wield_reload_anim_event = "equip_reload",
		action_movement_curve = {
			{
				modifier = 0.7,
				t = 0.2,
			},
			{
				modifier = 0.9,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.35,
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
				chain_time = 0.4,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
	},
	action_unwield = {
		allowed_during_sprint = true,
		kind = "unwield",
		start_input = "wield",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
	},
	action_unwield_to_previous = {
		allowed_during_sprint = true,
		kind = "unwield_to_previous",
		total_time = 0,
		uninterruptible = true,
		unwield_to_weapon = true,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
	},
	action_charge_direct = {
		abort_sprint = true,
		allowed_during_sprint = false,
		anim_end_event = "attack_charge_cancel",
		anim_event = "attack_charge",
		charge_template = "missile_launcher",
		hold_combo = true,
		kind = "charge_ammo",
		prevent_sprint = true,
		spread_template = "default_plasma_rifle_demolitions",
		sprint_ready_up_time = 0.1,
		start_input = "shoot_charge",
		stop_input = "shoot_cancel",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.4,
				t = 0.1,
			},
			{
				modifier = 0.4,
				t = 0.15,
			},
			{
				modifier = 0.6,
				t = 0.2,
			},
			{
				modifier = 0.4,
				t = 1,
			},
			start_modifier = 1,
		},
		charge_effects = {
			looping_sound_alias = "ranged_charging",
			sfx_parameter = "charge_level",
			sfx_source_name = "_muzzle",
		},
		running_action_state_to_action_input = {
			fully_charged = {
				input_name = "charged_enough",
			},
		},
		finish_reason_to_action_input = {
			stunned = {
				input_name = "charged_enough",
			},
		},
		allowed_chain_actions = {
			charged_enough = {
				action_name = "action_shoot_hip_blast",
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.4,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			if end_reason == "hold_input_released" or end_reason == "stunned" then
				return true
			end

			return false
		end,
	},
	action_charge_brace = {
		abort_sprint = true,
		allowed_during_sprint = false,
		anim_end_event = "attack_charge_cancel",
		anim_event = "attack_charge",
		charge_template = "missile_launcher",
		hold_combo = true,
		kind = "charge_ammo",
		prevent_sprint = true,
		recoil_template = "default_plasma_rifle_demolitions",
		spread_template = "default_plasma_rifle_demolitions",
		sprint_ready_up_time = 0.1,
		start_input = "brace_charge",
		stop_input = "brace_cancel",
		suppression_template = "plasmarifle_p1_m1_suppression_demolitions",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.4,
				t = 0.1,
			},
			{
				modifier = 0.4,
				t = 0.15,
			},
			{
				modifier = 0.6,
				t = 0.2,
			},
			{
				modifier = 0.4,
				t = 1,
			},
			start_modifier = 1,
		},
		charge_effects = {
			looping_sound_alias = "ranged_charging",
			sfx_parameter = "charge_level",
			sfx_source_name = "_muzzle",
		},
		finish_reason_to_action_input = {
			stunned = {
				input_name = "brace_shoot",
			},
		},
		allowed_chain_actions = {
			brace_shoot = {
				action_name = "action_shoot_hip_blast",
				chain_time = 0.5,
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.4,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			if end_reason == "hold_input_released" or end_reason == "stunned" then
				return true
			end

			return false
		end,
	},
	action_shoot_hip_blast = {
		abort_sprint = true,
		kind = "weapon_shout",
		prevent_sprint = true,
		reverse_direction = true,
		shout_at_time = 0,
		shout_time = 0.05,
		start_input = nil,
		uninterruptible = true,
		weapon_shout_template = "missile_launcher_knockback",
		total_time = math.huge,
		damage_profile = DamageProfileTemplates.missile_launcher_knockback,
		damage_type = damage_types.shield_push,
		fx = {
			weapon_shout_effect = "content/fx/particles/weapons/grenades/broker_boom_bringer_backblast_shout",
		},
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "shoot_charge_released",
			},
		},
		allowed_chain_actions = {
			shoot_charge_released = {
				action_name = "action_shoot_hip",
				chain_time = 0.2,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
	},
	action_shoot_hip = {
		abort_sprint = true,
		ammunition_usage = 1,
		anim_event = nil,
		kind = "shoot_projectile",
		prevent_sprint = true,
		projectile_locomotion_template = "broker_missile",
		start_input = nil,
		throw_type = "shoot",
		uninterruptible = true,
		weapon_handling_template = "immediate_single_shot",
		total_time = math.huge,
		action_movement_curve = {
			{
				modifier = 0.1,
				t = 0.2,
			},
			{
				modifier = 0.9,
				t = 0.4,
			},
			{
				modifier = 0.925,
				t = 1,
			},
			{
				modifier = 1,
				t = 1.2,
			},
			start_modifier = 0.01,
		},
		fire_configuration = {
			anim_event = "attack_shoot",
			inventory_item_name = "content/items/weapons/player/ranged/bullets/broker_missile",
			same_side_suppression_enabled = false,
			skip_aiming = true,
			use_charge = true,
			projectile = ProjectileTemplates.broker_missile,
			shotshell = ShotshellTemplates.default_thumper_assault,
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			muzzle_flash_effect = "content/fx/particles/weapons/grenades/broker_boom_bringer_muzzle_flash",
			pre_shoot_abort_sfx_alias = "ranged_abort",
			shoot_sfx_alias = "ranged_single_shot",
			shoot_tail_sfx_alias = "ranged_shot_tail",
		},
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "unwield_to_previous",
			},
		},
		allowed_chain_actions = {
			unwield_to_previous = {
				action_name = "action_unwield_to_previous",
				chain_time = 1.45,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.ranged_attack_speed,
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
		haptic_trigger_template = HapticTriggerTemplates.ranged.none,
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/missile_launcher"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/missile_launcher"
weapon_template.spread_template = "default_plasma_rifle_bfg"
weapon_template.reload_template = ReloadTemplates.ogryn_thumper
weapon_template.combo_reset_duration = 0.5
weapon_template.no_ammo_delay = 0.1
weapon_template.sprint_ready_up_time = 0.3
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.hud_configuration = {
	uses_ammunition = true,
	uses_overheat = false,
}
weapon_template.ammo_template = "ogryn_thumper_p1_m2"
weapon_template.fx_sources = {
	_muzzle = "fx_muzzle",
	_sweep = "fx_sweep",
	_weapon_shout = "fx_weapon_shout",
}
weapon_template.crosshair = {
	crosshair_type = "bfg",
}
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"ranged",
	"shotgun_grenade",
	"p1",
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.ogryn_thumper_p1_m2
weapon_template.movement_curve_modifier_template = "thumper_p1_m2"
weapon_template.smart_targeting_template = SmartTargetingTemplates.assault
weapon_template.haptic_trigger_template = HapticTriggerTemplates.ranged.thumper_p1_m2
weapon_template.overclocks = {}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	ogryn_thumper_p1_m2_ammo_stat = {
		display_name = "loc_stats_display_ammo_stat",
		is_stat_trait = true,
		ammo = {
			base = {
				ammo_trait_templates.default_explosive_ammo_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	ogryn_thumper_p1_m2_explosion_damage_stat = {
		display_name = "loc_stats_display_explosion_damage_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.ogryn_thumper_p1_m2_explosion_damage_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	ogryn_thumper_p1_m2_explosion_size_stat = {
		display_name = "loc_stats_display_explosion_stat",
		is_stat_trait = true,
		explosion = {
			action_shoot_hip = {
				explosion_trait_templates.default_explosion_size_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
	ogryn_thumper_p1_m2_mobility_stat = {
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
	ogryn_thumper_p1_m2_explosion_antiarmor_stat = {
		display_name = "loc_stats_display_explosion_ap_stat",
		is_stat_trait = true,
		damage = {
			action_shoot_hip = {
				damage_trait_templates.ogryn_thumper_p1_m2_explosion_antiarmor_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
}
weapon_template.traits = {}

local bespoke_traits = table.ukeys(WeaponTraitsBespokeThumperP2)

table.append(weapon_template.traits, bespoke_traits)

weapon_template.displayed_keywords = {
	{
		display_name = "loc_weapon_keyword_explosive",
	},
	{
		display_name = "loc_weapon_keyword_delayed_detonation",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_ranged_attack_primary",
		fire_mode = "projectile",
		type = "hipfire",
	},
}
weapon_template.weapon_card_data = {
	main = {
		{
			header = "hipfire",
			icon = "hipfire",
			sub_icon = "projectile",
			value_func = "primary_attack",
		},
		{
			header = "brace",
			icon = "brace",
			sub_icon = "projectile",
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
		"action_shoot_hip",
	},
}
weapon_template.displayed_weapon_stats = "ogryn_thumper_p1_m2"
weapon_template.hud_icon_small = "content/ui/materials/icons/throwables/hud/small/party_grenade"

return weapon_template
