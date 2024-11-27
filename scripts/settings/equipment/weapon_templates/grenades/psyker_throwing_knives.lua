-- chunkname: @scripts/settings/equipment/weapon_templates/grenades/psyker_throwing_knives.lua

local ActionInputHierarchyUtils = require("scripts/utilities/weapon/action_input_hierarchy")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {}

local function _projectile_template_func(unit, action_settings)
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if buff_extension and buff_extension:has_keyword(buff_keywords.psyker_empowered_grenade) then
		return ProjectileTemplates.psyker_throwing_knives_piercing
	end

	return ProjectileTemplates.psyker_throwing_knives
end

local function _aimed_projectile_template_func(unit, action_settings)
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if buff_extension and buff_extension:has_keyword(buff_keywords.psyker_empowered_grenade) then
		return ProjectileTemplates.psyker_throwing_knives_aimed_piercing
	end

	return ProjectileTemplates.psyker_throwing_knives_aimed
end

local function _select_throw_anim(action_settings, condition_func_params)
	local ability_extension = condition_func_params.ability_extension
	local ability_type = action_settings.ability_type
	local charges_left = ability_extension:remaining_ability_charges(ability_type)
	local has_charges_left = charges_left > 1
	local anim_option_1 = action_settings.anim_event_non_last
	local anim_option_2 = action_settings.anim_event_last

	return has_charges_left and anim_option_1 or anim_option_2
end

weapon_template.action_inputs = {
	combat_ability = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				input = "combat_ability_pressed",
				value = true,
			},
		},
	},
	shoot = {
		buffer_time = 0.2,
		max_queue = 1,
		input_sequence = {
			{
				input = "action_one_pressed",
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
	rewield = {
		buffer_time = 0,
		clear_input_queue = true,
	},
	force_vent = {
		buffer_time = 0,
		clear_input_queue = true,
	},
	force_vent_release = {
		buffer_time = 2,
		input_sequence = {
			{
				input = "weapon_reload_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	vent = {
		buffer_time = 0,
		input_sequence = {
			{
				input = "weapon_reload_hold",
				value = true,
			},
		},
	},
	vent_release = {
		buffer_time = 0.2,
		input_sequence = {
			{
				input = "weapon_reload_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	zoom_shoot = {
		buffer_time = 0.51,
		max_queue = 2,
		input_sequence = {
			{
				hold_input = "action_two_hold",
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	zoom = {
		buffer_time = 0.4,
		input_sequence = {
			{
				input = "action_two_hold",
				value = true,
			},
		},
	},
	zoom_release = {
		buffer_time = 0.3,
		input_sequence = {
			{
				input = "action_two_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	inspect_start = {
		buffer_time = 0,
		input_sequence = {
			{
				input = "weapon_inspect_hold",
				value = true,
			},
			{
				duration = 0.2,
				input = "weapon_inspect_hold",
				value = true,
			},
		},
	},
	inspect_stop = {
		buffer_time = 0.02,
		input_sequence = {
			{
				input = "weapon_inspect_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		input = "vent",
		transition = {
			{
				input = "vent_release",
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
		},
	},
	{
		input = "force_vent",
		transition = {
			{
				input = "force_vent_release",
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
		},
	},
	{
		input = "zoom",
		transition = {
			{
				input = "zoom_release",
				transition = "base",
			},
			{
				input = "zoom_shoot",
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
				input = "force_vent",
				transition = "base",
			},
		},
	},
	{
		input = "shoot",
		transition = "stay",
	},
	{
		input = "wield",
		transition = "stay",
	},
	{
		input = "rewield",
		transition = "stay",
	},
	{
		input = "combat_ability",
		transition = "stay",
	},
	{
		input = "inspect_start",
		transition = {
			{
				input = "inspect_stop",
				transition = "base",
			},
		},
	},
}

ActionInputHierarchyUtils.add_missing_ordered(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
	action_unwield = {
		allowed_during_sprint = true,
		kind = "unwield",
		start_input = "wield",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
	},
	action_rewield = {
		allowed_during_sprint = true,
		kind = "wield",
		start_input = "rewield",
		total_time = 0.5,
		uninterruptible = true,
		anim_event_func = function (action_settings, condition_func_params)
			local ability_extension = condition_func_params.ability_extension
			local ability_type = "grenade_ability"
			local anim_event = "toggle_flashlight"
			local anim_event_3p = "to_noammo"

			if ability_type and ability_extension:can_use_ability(ability_type) then
				anim_event = "to_ammo"
				anim_event_3p = "to_ammo"
			end

			return anim_event, anim_event_3p
		end,
		timeline_anims = {
			[0.05] = {
				anim_event_1p = "equip",
				anim_event_3p = "equip_shard",
			},
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			shoot = {
				action_name = "action_rapid_right",
			},
		},
	},
	action_wield = {
		allowed_during_sprint = true,
		kind = "wield",
		total_time = 0.5,
		uninterruptible = true,
		anim_event_func = function (action_settings, condition_func_params)
			local ability_extension = condition_func_params.ability_extension
			local ability_type = "grenade_ability"
			local anim_event = "to_noammo"
			local anim_event_3p = "to_noammo"

			if ability_type and ability_extension:can_use_ability(ability_type) then
				anim_event = "equip"
				anim_event_3p = "to_ammo"
			end

			return anim_event, anim_event_3p
		end,
		timeline_anims = {
			[0.05] = {
				anim_event_1p = "equip",
				anim_event_3p = "equip_shard",
			},
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			shoot = {
				action_name = "action_rapid_right",
			},
			vent = {
				action_name = "action_vent",
			},
		},
	},
	action_rapid_right = {
		ability_type = "grenade_ability",
		anim_event_last = "attack_shoot_last",
		anim_event_non_last = "attack_shoot",
		charge_template = "psyker_throwing_knives",
		extra_projectile_on_crit = true,
		fire_time = 0.25,
		kind = "spawn_projectile",
		psyker_smite = true,
		should_crit = true,
		sprint_requires_press_to_interrupt = true,
		start_input = "shoot",
		target_finder_module_class_name = "smart_target_targeting",
		target_position_distance = 50,
		total_time = 1,
		uninterruptible = true,
		use_ability_charge = true,
		use_target = true,
		use_target_position = false,
		vo_tag = "ability_gunslinger",
		weapon_handling_template = "time_scale_1_5",
		action_movement_curve = {
			{
				modifier = 0.5,
				t = 0.2,
			},
			{
				modifier = 0.4,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.6,
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			shoot = {
				action_name = "action_rapid_left",
				chain_time = 0.5,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.5,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.3,
			},
			force_vent = {
				action_name = "action_force_vent",
			},
		},
		spawn_offset = Vector3Box(0.1, -0.2, -0.22),
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_sfx_alias = "ranged_single_shot",
		},
		anim_event_func = _select_throw_anim,
		projectile_template = ProjectileTemplates.psyker_throwing_knives,
		projectile_template_func = _projectile_template_func,
		smart_targeting_template = SmartTargetingTemplates.throwing_knives_default,
		time_scale_stat_buffs = {
			buff_stat_buffs.psyker_throwing_knife_speed_modifier,
		},
	},
	action_rapid_left = {
		ability_type = "grenade_ability",
		anim_event_last = "attack_shoot_last",
		anim_event_non_last = "attack_shoot",
		charge_template = "psyker_throwing_knives",
		extra_projectile_on_crit = true,
		fire_time = 0.25,
		kind = "spawn_projectile",
		psyker_smite = true,
		should_crit = true,
		sprint_requires_press_to_interrupt = true,
		target_finder_module_class_name = "smart_target_targeting",
		target_position_distance = 50,
		total_time = 1,
		uninterruptible = true,
		use_ability_charge = true,
		use_target = true,
		use_target_position = false,
		vo_tag = "ability_gunslinger",
		weapon_handling_template = "time_scale_1_5",
		action_movement_curve = {
			{
				modifier = 0.5,
				t = 0.2,
			},
			{
				modifier = 0.4,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.6,
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			shoot = {
				action_name = "action_rapid_right",
				chain_time = 0.9,
			},
			zoom = {
				action_name = "action_zoom",
				chain_time = 0.9,
			},
			vent = {
				action_name = "action_vent",
				chain_time = 0.3,
			},
			force_vent = {
				action_name = "action_force_vent",
			},
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_sfx_alias = "ranged_single_shot",
		},
		spawn_offset = Vector3Box(0.1, -0.5, -0.37),
		anim_event_func = _select_throw_anim,
		projectile_template = ProjectileTemplates.psyker_throwing_knives,
		projectile_template_func = _projectile_template_func,
		smart_targeting_template = SmartTargetingTemplates.throwing_knives_default,
		time_scale_stat_buffs = {
			buff_stat_buffs.psyker_throwing_knife_speed_modifier,
		},
	},
	action_rapid_zoomed = {
		ability_type = "grenade_ability",
		anim_event_last = "attack_shoot_last",
		anim_event_non_last = "attack_shoot_zoomed",
		charge_template = "psyker_throwing_knives_homing",
		extra_projectile_on_crit = true,
		fire_time = 0.25,
		kind = "spawn_projectile",
		prefer_previous_action_targeting_result = true,
		psyker_smite = true,
		should_crit = true,
		sprint_requires_press_to_interrupt = true,
		sticky_targeting = true,
		target_finder_module_class_name = "smart_target_targeting",
		target_position_distance = 100,
		total_time = 1.5,
		uninterruptible = true,
		use_ability_charge = true,
		use_target = true,
		use_target_position = false,
		vo_tag = "ability_gunslinger",
		weapon_handling_template = "time_scale_1_5",
		action_movement_curve = {
			{
				modifier = 0.5,
				t = 0.2,
			},
			{
				modifier = 0.4,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.75,
		},
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			zoom_shoot = {
				action_name = "action_rapid_zoomed",
				chain_time = 1.2,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.3,
			},
		},
		fx = {
			crit_shoot_sfx_alias = "critical_shot_extra",
			shoot_sfx_alias = "ranged_single_shot",
		},
		spawn_offset = Vector3Box(0.045, -0.3, 0.2),
		anim_event_func = _select_throw_anim,
		projectile_template = ProjectileTemplates.psyker_throwing_knives_aimed_piercing,
		projectile_template_func = _aimed_projectile_template_func,
		smart_targeting_template = SmartTargetingTemplates.throwing_knifes_single_target,
		time_scale_stat_buffs = {
			buff_stat_buffs.psyker_throwing_knife_speed_modifier,
		},
	},
	action_zoom = {
		ability_type = "grenade_ability",
		kind = "target_finder",
		must_have_ammo_or_charge = true,
		soft_sticky_targeting = true,
		start_input = "zoom",
		sticky_targeting = false,
		target_finder_module_class_name = "smart_target_targeting",
		use_alternate_fire = true,
		total_time = math.huge,
		crosshair = {
			crosshair_type = "dot",
		},
		smart_targeting_template = SmartTargetingTemplates.throwing_knifes_single_target,
		targeting_fx = {
			effect_name = "content/fx/particles/weapons/force_staff/force_staff_channel_charge",
			has_husk_events = true,
			husk_effect_name = "content/fx/particles/weapons/force_staff/force_staff_channel_charge",
			wwise_event_start = "wwise/events/weapon/play_psyker_throwing_knife_aim_target_loop",
			wwise_event_stop = "wwise/events/weapon/stop_psyker_throwing_knife_aim_target_loop",
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			wield = {
				action_name = "action_unwield",
			},
			zoom_shoot = {
				action_name = "action_rapid_zoomed",
				chain_time = 0.5,
			},
			zoom_release = {
				action_name = "action_unzoom",
				chain_time = 0.3,
			},
		},
		time_scale_stat_buffs = {
			buff_stat_buffs.psyker_throwing_knife_speed_modifier,
		},
	},
	action_unzoom = {
		kind = "unaim",
		total_time = 0.2,
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			wield = {
				action_name = "action_unwield",
			},
			zoom = {
				action_name = "action_zoom",
			},
		},
	},
	action_force_vent = {
		additional_vent_source_name = "fx_right_hand",
		additional_vent_vfx = "content/fx/particles/abilities/psyker_venting_2",
		anim_end_event = "vent_end",
		anim_event = "vent_start",
		kind = "vent_warp_charge",
		minimum_hold_time = 1.5,
		stop_input = "force_vent_release",
		uninterruptible = true,
		vent_source_name = "fx_left_hand",
		vent_vfx = "content/fx/particles/abilities/psyker_venting",
		vo_tag = "ability_venting",
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
		running_action_state_to_action_input = {
			fully_vented = {
				input_name = "vent_release",
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
		},
	},
	action_vent = {
		anim_end_event = "vent_end",
		anim_event = "vent_start",
		kind = "vent_warp_charge",
		start_input = "vent",
		stop_input = "vent_release",
		uninterruptible = true,
		vent_source_name = "fx_left_hand",
		vent_vfx = "content/fx/particles/abilities/psyker_venting",
		vo_tag = "ability_venting",
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
		running_action_state_to_action_input = {
			fully_vented = {
				input_name = "vent_release",
			},
		},
		allowed_chain_actions = {
			combat_ability = {
				action_name = "combat_ability",
			},
			wield = {
				action_name = "action_unwield",
				chain_time = 0.15,
			},
		},
	},
	combat_ability = {
		kind = "unwield_to_specific",
		slot_to_wield = "slot_combat_ability",
		start_input = "combat_ability",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
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
	},
}
weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_grenades_and_got_grenade",
		input_name = "rewield",
	},
}
weapon_template.keywords = {
	"psyker",
}
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/psyker_smite",
	ogryn = "content/characters/player/ogryn/third_person/animations/unarmed",
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/throwing_knives",
	ogryn = "content/characters/player/ogryn/first_person/animations/unarmed",
}
weapon_template.alternate_fire_settings = {
	spread_template = "no_spread",
	start_anim_event = "to_ironsight",
	stop_anim_event = "to_unaim_ironsight",
	crosshair = {
		crosshair_type = "dot",
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
	camera = {
		custom_vertical_fov = 60,
		near_range = 0.025,
		vertical_fov = 60,
	},
}
weapon_template.spread_template = "no_spread"
weapon_template.ammo_template = "no_ammo"
weapon_template.psyker_smite = true
weapon_template.hud_configuration = {
	uses_ammunition = true,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.smart_targeting_template = SmartTargetingTemplates.throwing_knives_default
weapon_template.fx_sources = {
	_muzzle = "fx_right",
	_right = "fx_right",
	_shard_01 = "fx_shard_01",
	_shard_02 = "fx_shard_02",
	_shard_03 = "fx_shard_03",
	_shard_04 = "fx_shard_04",
}
weapon_template.wieldable_slot_scripts = {
	"PsykerSingleTargetEffects",
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.hud_icon = "content/ui/materials/icons/throwables/hud/throwing_knives"

weapon_template.action_none_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not current_action_name or current_action_name == "none"
end

weapon_template.overheated_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	local player_unit = player.player_unit
	local unit_data_ext = ScriptUnit.extension(player_unit, "unit_data_system")
	local warp_charge = unit_data_ext:read_component("warp_charge")
	local has_warp_charge = warp_charge.current_percentage >= 0.1

	return has_warp_charge
end

weapon_template.action_one_charging_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_charge_heavy"
end

weapon_template.action_two_charging_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_zoom"
end

weapon_template.action_two_firing_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_shoot_charged"
end

return weapon_template
