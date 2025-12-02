-- chunkname: @scripts/settings/equipment/weapon_templates/weapon_template_generators/drone_weapon_template_generator.lua

local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local wield_inputs = PlayerCharacterConstants.wield_inputs

local function generate_base_template()
	local base_template = {}

	base_template.action_inputs = {
		combat_ability = {
			buffer_time = 0,
			input_sequence = nil,
		},
		aim_drone = {
			buffer_time = 0,
			input_sequence = {
				{
					input = "combat_ability_hold",
					value = true,
				},
			},
		},
		release_drone = {
			buffer_time = 0.6,
			input_sequence = {
				{
					input = "combat_ability_hold",
					value = false,
					time_window = math.huge,
				},
			},
		},
		instant_aim_drone = {
			buffer_time = 0.1,
			input_sequence = {
				{
					input = "combat_ability_hold",
					value = false,
					time_window = math.huge,
				},
			},
		},
		instant_release_drone = {
			buffer_time = 0,
			dont_queue = true,
			input_sequence = nil,
		},
		cancel = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					input = "action_two_pressed",
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
		unwield_to_previous = {
			buffer_time = 0,
			input_sequence = nil,
		},
		grenade_ability = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					input = "grenade_ability_pressed",
					value = true,
				},
			},
		},
	}

	table.add_missing(base_template.action_inputs, BaseTemplateSettings.action_inputs)

	base_template.action_input_hierarchy = {
		{
			input = "aim_drone",
			transition = {
				{
					input = "release_drone",
					transition = "base",
				},
				{
					input = "wield",
					transition = "base",
				},
				{
					input = "cancel",
					transition = "base",
				},
				{
					input = "grenade_ability",
					transition = "base",
				},
			},
		},
		{
			input = "instant_aim_drone",
			transition = {
				{
					input = "instant_release_drone",
					transition = "base",
				},
				{
					input = "wield",
					transition = "base",
				},
				{
					input = "cancel",
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
			transition = "base",
		},
		{
			input = "cancel",
			transition = "stay",
		},
		{
			input = "unwield_to_previous",
			transition = "stay",
		},
		{
			input = "grenade_ability",
			transition = "stay",
		},
	}
	base_template.actions = {
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
			allowed_chain_actions = {},
		},
		action_wield = {
			anim_event = "equip",
			anim_event_3p = "to_grenade_stumm",
			kind = "wield",
			total_time = 0.3,
			uninterruptible = true,
			weapon_handling_template = "time_scale_1",
			conditional_state_to_action_input = {
				action_end = {
					input_name = "aim_drone",
				},
			},
			allowed_chain_actions = {
				instant_aim_drone = {
					action_name = "action_instant_aim_drone",
				},
				aim_drone = {
					action_name = "action_aim_drone",
					chain_time = 0.2,
				},
			},
		},
		action_aim_drone = {
			abort_sprint = true,
			allowed_during_sprint = true,
			anim_end_event = "to_unaim_arc",
			anim_event = "to_aim_arc",
			kind = "position_finder",
			position_finder_module_class_name = "drone_position_finder",
			prevent_sprint = true,
			uninterruptible = true,
			total_time = math.huge,
			allowed_chain_actions = {
				wield = {
					action_name = "action_unwield",
				},
				release_drone = {
					action_name = "action_release_drone",
				},
				cancel = {
					action_name = "action_cancel",
				},
				grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason == "hold_input_released"
			end,
		},
		action_instant_aim_drone = {
			abort_sprint = true,
			allowed_during_sprint = true,
			anim_end_event = "to_unaim_arc",
			anim_event = "quick_throw",
			anim_event_3p = "throw_underhand",
			instant_cast = true,
			kind = "position_finder",
			position_finder_module_class_name = "drone_position_finder",
			prevent_sprint = true,
			total_time = 0,
			uninterruptible = true,
			conditional_state_to_action_input = {
				action_end = {
					input_name = "instant_release_drone",
				},
			},
			allowed_chain_actions = {
				wield = {
					action_name = "action_unwield",
				},
				instant_release_drone = {
					action_name = "action_instant_release_drone",
				},
				cancel = {
					action_name = "action_cancel",
				},
				grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason == "hold_input_released"
			end,
		},
		action_release_drone = {
			ability_type = "combat_ability",
			abort_sprint = true,
			allowed_during_sprint = true,
			anim_end_event = "equip",
			anim_event = "throw_underhand",
			fire_time = 0.4,
			kind = "spawn_projectile",
			position_finder_module_class_name = "drone_position_finder",
			prevent_sprint = true,
			recoil_template = "default_shotgun_killshot",
			spawn_at_time = 0.4,
			total_time = 1.3,
			track_towards_position = true,
			uninterruptible = true,
			use_ability_charge = true,
			vo_tag_release = "blitz_nuncio_a",
			weapon_handling_template = "grenade_throw",
			conditional_state_to_action_input = {
				action_end = {
					input_name = "unwield_to_previous",
				},
			},
			allowed_chain_actions = {
				unwield_to_previous = {
					action_name = "action_unwield_to_previous",
				},
				wield = {
					action_name = "action_unwield",
				},
			},
			spawn_offset = Vector3Box(0.5, -0.2, -0.2),
			anim_end_event_condition_func = function (unit, data, end_reason)
				local ability_extension = ScriptUnit.has_extension(unit, "ability_system")
				local ability_type = "combat_ability"

				return ability_extension and ability_extension:can_use_ability(ability_type)
			end,
		},
		action_instant_release_drone = {
			ability_type = "combat_ability",
			abort_sprint = true,
			allowed_during_sprint = true,
			anim_end_event = "equip",
			anim_event = "throw_underhand",
			fire_time = 0.25,
			kind = "spawn_projectile",
			position_finder_module_class_name = "drone_position_finder",
			prevent_sprint = true,
			recoil_template = "default_shotgun_killshot",
			spawn_at_time = 0.22,
			total_time = 1,
			track_towards_position = true,
			uninterruptible = true,
			use_ability_charge = true,
			vo_tag_release = "blitz_nuncio_a",
			weapon_handling_template = "grenade_throw",
			conditional_state_to_action_input = {
				action_end = {
					input_name = "unwield_to_previous",
				},
			},
			allowed_chain_actions = {
				unwield_to_previous = {
					action_name = "action_unwield_to_previous",
				},
				wield = {
					action_name = "action_unwield",
				},
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				local ability_extension = ScriptUnit.has_extension(unit, "ability_system")
				local ability_type = "combat_ability"

				return ability_extension and ability_extension:can_use_ability(ability_type)
			end,
		},
		action_cancel = {
			anim_time_scale = 1,
			kind = "dummy",
			start_input = "cancel",
			total_time = 0.22,
			uninterruptible = true,
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
				start_modifier = 0.8,
			},
			conditional_state_to_action_input = {
				action_end = {
					input_name = "unwield_to_previous",
				},
			},
			allowed_chain_actions = {
				unwield_to_previous = {
					action_name = "action_unwield_to_previous",
				},
			},
		},
	}

	table.add_missing(base_template.actions, BaseTemplateSettings.actions)

	base_template.keywords = {
		"adamant",
	}
	base_template.conditional_state_to_action_input = {
		{
			conditional_state = "no_running_action",
			input_name = "cancel",
		},
	}
	base_template.smart_targeting_template = SmartTargetingTemplates.default_melee
	base_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/grenade"
	base_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/adamant_drone"
	base_template.spread_template = "lasgun"
	base_template.ammo_template = "grenade"
	base_template.hud_configuration = {
		uses_ammunition = true,
		uses_overheat = false,
	}
	base_template.sprint_ready_up_time = 0.1
	base_template.max_first_person_anim_movement_speed = 5.8
	base_template.fx_sources = {}
	base_template.dodge_template = "default"
	base_template.sprint_template = "default"
	base_template.stamina_template = "default"
	base_template.toughness_template = "default"
	base_template.footstep_intervals = FootstepIntervalsTemplates.default

	base_template.action_aim_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
		return current_action_name == "action_aim"
	end

	base_template.action_aim_underhand_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
		return current_action_name == "action_aim_underhand"
	end

	base_template.action_none_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
		return not current_action_name or current_action_name == "none"
	end

	return base_template
end

return generate_base_template
