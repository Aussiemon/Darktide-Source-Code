-- chunkname: @scripts/settings/equipment/weapon_templates/weapon_template_generators/force_field_weapon_template_generator.lua

local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local wield_inputs = PlayerCharacterConstants.wield_inputs

local function generate_base_template(functional_unit, visual_unit, allow_rotation)
	local base_template = {}

	base_template.action_inputs = {
		combat_ability = {
			buffer_time = 0,
		},
		aim_force_field = {
			buffer_time = 0,
			input_sequence = {
				{
					input = "combat_ability_hold",
					value = true,
				},
			},
		},
		place_force_field = {
			buffer_time = 0.6,
			input_sequence = {
				{
					input = "combat_ability_hold",
					value = false,
					time_window = math.huge,
				},
			},
		},
		instant_aim_force_field = {
			buffer_time = 0.1,
			input_sequence = {
				{
					input = "combat_ability_hold",
					value = false,
					time_window = math.huge,
				},
			},
		},
		instant_place_force_field = {
			buffer_time = 0,
			dont_queue = true,
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
	base_template.action_input_hierarchy = {
		{
			input = "aim_force_field",
			transition = {
				{
					input = "place_force_field",
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
			input = "instant_aim_force_field",
			transition = {
				{
					input = "instant_place_force_field",
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
			unwield_to_weapon = false,
			allowed_chain_actions = {},
		},
		action_wield = {
			anim_event = "equip",
			anim_event_3p = "equip_shield",
			kind = "wield",
			total_time = 0.25,
			uninterruptible = true,
			conditional_state_to_action_input = {
				auto_chain = {
					input_name = "aim_force_field",
				},
			},
			allowed_chain_actions = {
				instant_aim_force_field = {
					action_name = "action_instant_aim_force_field",
				},
				aim_force_field = {
					action_name = "action_aim_force_field",
					chain_time = 0.1,
				},
			},
		},
		action_aim_force_field = {
			abort_sprint = true,
			allowed_during_sprint = true,
			kind = "aim_force_field",
			prevent_sprint = true,
			uninterruptible = true,
			total_time = math.huge,
			visual_unit = visual_unit,
			place_configuration = {
				anim_rotate_event = "ability_rotate_shield",
				distance = 10,
				rotate_sound_event = "wwise/events/player/play_ability_psyker_protectorate_shield_rotate",
				rotation_input = "action_one_pressed",
				rotation_steps = 4,
				allow_rotation = allow_rotation,
				sound_position_offset = Vector3Box(Vector3.up() * 1.5),
			},
			allowed_chain_actions = {
				wield = {
					action_name = "action_unwield",
				},
				place_force_field = {
					action_name = "action_place_force_field",
					chain_time = 0.1,
				},
				cancel = {
					action_name = "action_cancel",
				},
				grenade_ability = {
					{
						action_name = "grenade_ability",
					},
					{
						action_name = "grenade_ability_quick_throw",
					},
				},
			},
		},
		action_instant_aim_force_field = {
			abort_sprint = true,
			allowed_during_sprint = true,
			kind = "aim_force_field",
			prevent_sprint = true,
			total_time = 0,
			uninterruptible = true,
			visual_unit = visual_unit,
			place_configuration = {
				allow_rotation = false,
				distance = 10,
				sound_position_offset = Vector3Box(Vector3.up() * 1.5),
			},
			conditional_state_to_action_input = {
				auto_chain = {
					input_name = "instant_place_force_field",
				},
			},
			allowed_chain_actions = {
				wield = {
					action_name = "action_unwield",
				},
				instant_place_force_field = {
					action_name = "action_instant_place_force_field",
				},
				cancel = {
					action_name = "action_cancel",
				},
			},
		},
		action_place_force_field = {
			ability_type = "combat_ability",
			abort_sprint = true,
			allowed_during_sprint = true,
			anim_event = "attack_shoot",
			kind = "place_force_field",
			place_time = 0.05,
			prevent_sprint = true,
			total_time = 0.6,
			uninterruptible = true,
			unwield_slot = true,
			use_ability_charge = true,
			use_aim_data = true,
			vo_tag = "ability_protectorate_start",
			weapon_handling_template = "time_scale_1_4",
			functional_unit = functional_unit,
			action_movement_curve = {
				{
					modifier = 0.4,
					t = 0.1,
				},
				{
					modifier = 0.6,
					t = 0.2,
				},
				{
					modifier = 0.8,
					t = 0.3,
				},
				{
					modifier = 1,
					t = 0.4,
				},
				start_modifier = 0.3,
			},
			conditional_state_to_action_input = {
				auto_chain = {
					input_name = "unwield_to_previous",
				},
			},
			allowed_chain_actions = {
				unwield_to_previous = {
					action_name = "action_unwield_to_previous",
				},
			},
		},
		action_cancel = {
			anim_end_event = "attack_finished",
			anim_event = "attack_charge_cancel",
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
				auto_chain = {
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
	base_template.actions.action_instant_place_force_field = table.clone(base_template.actions.action_place_force_field)
	base_template.actions.action_instant_place_force_field.total_time = 0.1
	base_template.actions.action_instant_place_force_field.place_time = 0
	base_template.actions.action_instant_place_force_field.anim_event = nil

	table.add_missing(base_template.actions, BaseTemplateSettings.actions)

	base_template.keywords = {
		"psyker",
	}
	base_template.conditional_state_to_action_input = {
		{
			conditional_state = "no_running_action",
			input_name = "cancel",
		},
	}
	base_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/psyker_smite"
	base_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/psyker_shield"
	base_template.smart_targeting_template = SmartTargetingTemplates.default_melee
	base_template.spread_template = "no_spread"
	base_template.ammo_template = "no_ammo"
	base_template.hud_configuration = {
		uses_ammunition = false,
		uses_overheat = false,
		uses_weapon_special_charges = false,
	}
	base_template.sprint_ready_up_time = 0.1
	base_template.max_first_person_anim_movement_speed = 5.8
	base_template.crosshair = {
		crosshair_type = "dot",
	}
	base_template.hit_marker_type = "center"
	base_template.fx_sources = {
		_muzzle = "fx_right",
	}
	base_template.dodge_template = "default"
	base_template.sprint_template = "default"
	base_template.stamina_template = "default"
	base_template.toughness_template = "default"
	base_template.footstep_intervals = FootstepIntervalsTemplates.default

	base_template.action_aim_force_field_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
		return not current_action_name or current_action_name == "action_aim_force_field"
	end

	return base_template
end

return generate_base_template
