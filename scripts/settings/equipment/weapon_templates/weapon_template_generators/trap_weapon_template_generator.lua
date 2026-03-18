-- chunkname: @scripts/settings/equipment/weapon_templates/weapon_template_generators/trap_weapon_template_generator.lua

local ActionInputHierarchy = require("scripts/utilities/action/action_input_hierarchy")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local wield_inputs = PlayerCharacterConstants.wield_inputs

local function generate_base_template(ability_type)
	local base_template = {}

	base_template.action_inputs = {
		deploy = {
			buffer_time = 0.4,
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
		unwield_to_previous = {
			buffer_time = 0,
			dont_queue = true,
			input_sequence = nil,
		},
	}

	table.add_missing(base_template.action_inputs, BaseTemplateSettings.action_inputs)

	base_template.action_input_hierarchy = {
		{
			input = "wield",
			transition = "stay",
		},
		{
			input = "deploy",
			transition = "stay",
		},
		{
			input = "unwield_to_previous",
			transition = "base",
		},
	}

	ActionInputHierarchy.add_missing(base_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

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
			allowed_during_sprint = true,
			anim_event = "equip",
			anim_event_3p = "equip",
			kind = "wield",
			total_time = 0,
			uninterruptible = true,
			allowed_chain_actions = {
				grenade_ability = BaseTemplateSettings.generate_grenade_ability_chain_actions(),
			},
		},
		action_deploy = {
			allowed_during_sprint = true,
			ammunition_usage = 1,
			anim_end_event = "action_finished",
			anim_event = "drop",
			anim_event_3p = "throw",
			kind = "deploy_mine",
			lock_view = false,
			place_time = 0.5,
			remove_item_from_inventory = true,
			start_input = "deploy",
			throw_type = "underhand_throw",
			total_time = 0.6,
			uninterruptible = true,
			use_aim_data = false,
			place_configuration = {
				distance = 2,
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
			end,
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
			action_condition_func = function (action_settings, condition_func_params, used_input)
				local game_mode_manager = Managers.state.game_mode
				local game_mode = game_mode_manager:game_mode()

				if game_mode.in_safe_zone then
					return not game_mode:in_safe_zone()
				end

				return true
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

	table.add_missing(base_template.actions, BaseTemplateSettings.actions)

	base_template.keywords = {
		"pocketable",
		"grenade",
	}
	base_template.hud_configuration = {
		uses_ammunition = true,
		uses_overheat = false,
	}
	base_template.breed_anim_state_machine_3p = {
		human = "content/characters/player/human/third_person/animations/traps",
		ogryn = "content/characters/player/ogryn/third_person/animations/traps",
	}
	base_template.breed_anim_state_machine_1p = {
		human = "content/characters/player/human/first_person/animations/traps",
		ogryn = "content/characters/player/ogryn/first_person/animations/traps",
	}
	base_template.smart_targeting_template = SmartTargetingTemplates.default_melee
	base_template.fx_sources = {
		_passive = "fx_passive",
	}
	base_template.dodge_template = "default"
	base_template.sprint_template = "default"
	base_template.stamina_template = "default"
	base_template.toughness_template = "default"
	base_template.spread_template = "lasgun"
	base_template.ammo_template = "grenade"
	base_template.sprint_ready_up_time = 0.1
	base_template.max_first_person_anim_movement_speed = 5.8
	base_template.crosshair = {
		crosshair_type = "none",
	}
	base_template.footstep_intervals = FootstepIntervalsTemplates.default

	base_template.action_none_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
		return not current_action_name or current_action_name == "none"
	end

	base_template.action_discard_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
		return current_action_name == "action_throw"
	end

	return base_template
end

return generate_base_template
