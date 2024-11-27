-- chunkname: @scripts/settings/equipment/weapon_templates/weapon_template_generators/syringe_pocketable_weapon_template_generator.lua

local ActionInputHierarchyUtils = require("scripts/utilities/weapon/action_input_hierarchy")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PocketableUtils = require("scripts/settings/equipment/weapon_templates/pocketables/pockatables_utils")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local wield_inputs = PlayerCharacterConstants.wield_inputs

local function generate_base_template(buff_name, validate_target_func, hud_icon, hud_icon_small, pickup_name, assist_notification_type)
	local base_template = {}

	base_template.action_inputs = {
		use_self = {
			buffer_time = 0.4,
			input_sequence = {
				{
					input = "action_one_pressed",
					value = true,
				},
			},
		},
		aim = {
			buffer_time = 0.4,
			input_sequence = {
				{
					input = "action_two_hold",
					value = true,
				},
			},
		},
		aim_release = {
			buffer_time = 0.3,
			input_sequence = {
				{
					input = "action_two_hold",
					value = false,
					time_window = math.huge,
				},
			},
		},
		use_ally = {
			buffer_time = 0.4,
			input_sequence = {
				{
					input = "action_one_pressed",
					value = true,
				},
			},
		},
		wield = {
			buffer_time = 0.65,
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
		aim_give = {
			buffer_time = 0.3,
			max_queue = 1,
			reevaluation_time = 0.18,
			input_sequence = {
				{
					hold_input = "weapon_extra_hold",
					input = "weapon_extra_hold",
					value = true,
				},
			},
		},
		aim_give_release = {
			buffer_time = 0.3,
			max_queue = 1,
			input_sequence = {
				{
					input = "weapon_extra_hold",
					value = false,
					time_window = math.huge,
				},
			},
		},
	}

	table.add_missing(base_template.action_inputs, BaseTemplateSettings.action_inputs)

	base_template.action_input_hierarchy = {
		{
			input = "wield",
			transition = "base",
		},
		{
			input = "use_self",
			transition = "base",
		},
		{
			input = "special_action",
			transition = "base",
		},
		{
			input = "aim",
			transition = {
				{
					input = "use_ally",
					transition = "base",
				},
				{
					input = "aim_release",
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
			input = "aim_give",
			transition = {
				{
					input = "aim_give_release",
					transition = "previous",
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
	}

	ActionInputHierarchyUtils.add_missing_ordered(base_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

	base_template.actions = {
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
			anim_event_3p = "equip_syringe",
			kind = "wield",
			total_time = 0,
			uninterruptible = true,
		},
		action_use_self = {
			abort_sprint = false,
			action_priority = 2,
			allowed_during_sprint = true,
			has_target_anim_event = "use_self",
			has_target_anim_event_3p = "syringe_use_self",
			hit_reaction_anim_event = "shake_light",
			kind = "use_syringe",
			prevent_sprint = false,
			remove_item_from_inventory = true,
			self_use = true,
			self_use_if_no_target = false,
			start_input = "use_self",
			total_time = 1.9,
			uninterruptible = true,
			use_time = 0.8,
			weapon_handling_template = "time_scale_1_3",
			action_movement_curve = {
				{
					modifier = 1,
					t = 0.7,
				},
				{
					modifier = 0.3,
					t = 0.8,
				},
				{
					modifier = 0.7,
					t = 0.9,
				},
				{
					modifier = 1,
					t = 1.2,
				},
				start_modifier = 1,
			},
			allowed_chain_actions = {
				wield = {
					action_name = "action_unwield",
					chain_time = 0.81,
				},
			},
			buff_name = buff_name,
			validate_target_func = validate_target_func,
		},
		action_flair = {
			abort_sprint = false,
			action_priority = 1,
			allowed_during_sprint = true,
			anim_event = "flair",
			kind = "dummy",
			prevent_sprint = false,
			start_input = "use_self",
			total_time = 0.7,
			allowed_chain_actions = {
				wield = {
					action_name = "action_unwield",
				},
				aim = {
					action_name = "action_aim",
				},
				use_self = {
					action_name = "action_use_self",
				},
			},
		},
		action_aim = {
			aim_ready_up_time = 0.4,
			allowed_during_sprint = false,
			anim_end_event = "to_unaim",
			anim_event = "to_aim",
			clear_on_hold_release = true,
			has_target_anim_event = "target_on",
			kind = "target_ally",
			minimum_hold_time = 0.01,
			no_target_anim_event = "target_off",
			prevent_sprint = true,
			sprint_ready_up_time = 0.4,
			start_input = "aim",
			stop_input = "aim_release",
			uninterruptible = true,
			total_time = math.huge,
			action_movement_curve = {
				{
					modifier = 0.95,
					t = 0.2,
				},
				{
					modifier = 0.85,
					t = 0.4,
				},
				{
					modifier = 0.8,
					t = 0.5,
				},
				start_modifier = 1,
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason ~= "new_interrupting_action"
			end,
			validate_target_func = validate_target_func,
			smart_targeting_template = SmartTargetingTemplates.target_ally_close,
			allowed_chain_actions = {
				use_ally = {
					action_name = "action_use_ally",
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
			},
		},
		action_use_ally = {
			aim_ready_up_time = 0.4,
			allowed_during_sprint = false,
			exit_without_target = true,
			has_target_anim_event = "use_ally",
			has_target_anim_event_3p = "syringe_use_ally",
			hit_reaction_anim_event = "shake_light",
			hit_reaction_anim_event_3p = "hit_stun",
			hit_reaction_sound_event = "wwise/events/player/play_syringe_healed_by_ally",
			kind = "use_syringe",
			minimum_time = 0.8,
			no_target_cast_anim_event = "use_ally_miss",
			no_target_cast_anim_event_3p = "syringe_use_ally_miss",
			prevent_sprint = true,
			remove_item_from_inventory = true,
			self_use = false,
			self_use_if_no_target = false,
			sprint_ready_up_time = 0.4,
			start_input = "use_ally",
			total_time = 1.2,
			uninterruptible = true,
			use_time = 0.1,
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
					modifier = 0.8,
					t = 0.6,
				},
				{
					modifier = 0.9,
					t = 0.7,
				},
				{
					modifier = 1,
					t = 1.2,
				},
				start_modifier = 1.3,
			},
			allowed_chain_actions = {
				wield = {
					action_name = "action_unwield",
					chain_time = 0.11,
				},
			},
			buff_name = buff_name,
			validate_target_func = validate_target_func,
			assist_notification_type = assist_notification_type,
		},
		action_aim_give = {
			aim_ready_up_time = 0,
			allowed_during_lunge = true,
			allowed_during_sprint = true,
			anim_end_event = "share_aim_end",
			anim_event = "share_aim",
			clear_on_hold_release = true,
			kind = "target_ally",
			minimum_hold_time = 0.01,
			sprint_ready_up_time = 0,
			start_input = "aim_give",
			stop_input = "aim_give_release",
			uninterruptible = true,
			total_time = math.huge,
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason ~= "new_interrupting_action"
			end,
			validate_target_func = PocketableUtils.validate_give_pocketable_small_target_func,
			smart_targeting_template = SmartTargetingTemplates.target_ally_close,
			allowed_chain_actions = {
				aim_give_release = {
					action_name = "action_give",
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
			},
		},
		action_give = {
			allowed_during_sprint = true,
			anim_end_event = "share_aim_end",
			anim_event = "share_ally",
			assist_notification_type = "gifted",
			give_time = 0.7,
			kind = "give_pocketable",
			total_time = 0.7,
			smart_targeting_template = SmartTargetingTemplates.target_ally_close,
			validate_target_func = PocketableUtils.validate_give_pocketable_small_target_func,
			voice_event_data = {
				voice_tag_concept = "on_demand_com_wheel",
				voice_tag_id = "com_take_this",
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

	table.add_missing(base_template.actions, BaseTemplateSettings.actions)

	base_template.keywords = {
		"pocketable",
		"syringe",
	}
	base_template.ammo_template = "no_ammo"
	base_template.hud_configuration = {
		uses_ammunition = false,
		uses_overheat = false,
	}
	base_template.breed_anim_state_machine_3p = {
		human = "content/characters/player/human/third_person/animations/pocketables",
		ogryn = "content/characters/player/ogryn/third_person/animations/pocketables",
	}
	base_template.breed_anim_state_machine_1p = {
		human = "content/characters/player/human/first_person/animations/syringe",
		ogryn = "content/characters/player/ogryn/first_person/animations/syringe",
	}
	base_template.smart_targeting_template = SmartTargetingTemplates.default_melee
	base_template.fx_sources = {
		_passive = "fx_passive",
	}
	base_template.dodge_template = "default"
	base_template.sprint_template = "default"
	base_template.stamina_template = "default"
	base_template.toughness_template = "default"
	base_template.hud_icon = hud_icon
	base_template.hud_icon_small = hud_icon_small
	base_template.swap_pickup_name = pickup_name
	base_template.give_pickup_name = pickup_name
	base_template.breed_footstep_intervals = {
		human = FootstepIntervalsTemplates.default,
		ogryn = FootstepIntervalsTemplates.pocketable_ogryn,
	}

	base_template.action_none_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
		return not current_action_name or current_action_name == "none"
	end

	base_template.action_is_aiming_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
		return current_action_name == "action_aim"
	end

	base_template.action_can_use_self_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player, condition_func_params)
		return not current_action_name or current_action_name == "none" and validate_target_func(player.player_unit)
	end

	base_template.action_can_use_ally_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player, condition_func_params)
		local action_module_targeting_component = condition_func_params.action_module_targeting_component
		local target_unit = action_module_targeting_component.target_unit_1

		return current_action_name == "action_aim" and target_unit ~= nil
	end

	base_template.action_none_gift_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
		return not current_action_name or current_action_name == "none"
	end

	base_template.action_can_give_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player, condition_func_params)
		local action_module_targeting_component = condition_func_params.action_module_targeting_component
		local target_unit = action_module_targeting_component.target_unit_1

		return current_action_name == "action_aim_give" and target_unit ~= nil
	end

	base_template.action_cant_give_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player, condition_func_params)
		local action_module_targeting_component = condition_func_params.action_module_targeting_component
		local target_unit = action_module_targeting_component.target_unit_1

		return current_action_name == "action_aim_give" and target_unit == nil
	end

	return base_template
end

return generate_base_template
