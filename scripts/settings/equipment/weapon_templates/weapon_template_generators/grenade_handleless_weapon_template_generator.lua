-- chunkname: @scripts/settings/equipment/weapon_templates/weapon_template_generators/grenade_handleless_weapon_template_generator.lua

local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local wield_inputs = PlayerCharacterConstants.wield_inputs

local function generate_base_template()
	local base_template = {}

	base_template.action_inputs = {
		aim_hold = {
			buffer_time = 1.6,
			input_sequence = {
				{
					input = "action_one_pressed",
					value = true,
				},
			},
		},
		aim_released = {
			buffer_time = 0.5,
			input_sequence = {
				{
					input = "action_one_hold",
					value = false,
				},
			},
		},
		block_cancel = {
			buffer_time = 0.316,
			clear_input_queue = true,
			input_sequence = {
				{
					hold_input = "action_one_hold",
					input = "action_two_pressed",
					value = true,
				},
			},
		},
		block_cancel_release = {
			buffer_time = 0,
			dont_queue = true,
			input_sequence = {
				{
					input_mode = "all",
					inputs = {
						{
							input = "action_two_hold",
							value = false,
						},
					},
					time_window = math.huge,
				},
			},
		},
		short_hand_aim_hold = {
			buffer_time = 0,
			input_sequence = {
				{
					input = "action_two_hold",
					value = true,
				},
			},
		},
		short_hand_throw = {
			buffer_time = 0.91,
			input_sequence = {
				{
					hold_input = "action_two_hold",
					input = "action_one_pressed",
					value = true,
				},
			},
		},
		short_hand_throw_release = {
			buffer_time = 0,
			dont_queue = true,
			input_sequence = {
				{
					input_mode = "all",
					inputs = {
						{
							input = "action_one_hold",
							value = false,
						},
					},
					time_window = math.huge,
				},
			},
		},
		short_hand_aim_released = {
			buffer_time = 0.316,
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
		unwield_to_previous = {
			buffer_time = 0,
			dont_queue = true,
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
	}
	base_template.action_input_hierarchy = {
		{
			input = "aim_hold",
			transition = {
				{
					input = "aim_released",
					transition = "previous",
				},
				{
					input = "block_cancel",
					transition = {
						{
							input = "block_cancel_release",
							transition = "base",
						},
						{
							input = "wield",
							transition = "base",
						},
						{
							input = "unwield_to_previous",
							transition = "base",
						},
						{
							input = "combat_ability",
							transition = "base",
						},
					},
				},
				{
					input = "wield",
					transition = "base",
				},
				{
					input = "unwield_to_previous",
					transition = "base",
				},
				{
					input = "combat_ability",
					transition = "base",
				},
			},
		},
		{
			input = "short_hand_aim_hold",
			transition = {
				{
					input = "short_hand_aim_released",
					transition = "previous",
				},
				{
					input = "short_hand_throw",
					transition = {
						{
							input = "short_hand_throw_release",
							transition = "base",
						},
						{
							input = "wield",
							transition = "base",
						},
						{
							input = "unwield_to_previous",
							transition = "base",
						},
						{
							input = "combat_ability",
							transition = "base",
						},
					},
				},
				{
					input = "wield",
					transition = "base",
				},
				{
					input = "unwield_to_previous",
					transition = "base",
				},
				{
					input = "combat_ability",
					transition = "base",
				},
			},
		},
		{
			input = "block_cancel",
			transition = "stay",
		},
		{
			input = "wield",
			transition = "stay",
		},
		{
			input = "unwield_to_previous",
			transition = "base",
		},
		{
			input = "combat_ability",
			transition = "base",
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
			allowed_during_sprint = false,
			anim_event = "to_grenade",
			anim_event_3p = "to_grenade_stumm",
			kind = "wield",
			total_time = 0.3,
			uninterruptible = true,
			weapon_handling_template = "time_scale_1_5",
			allowed_chain_actions = {
				combat_ability = {
					action_name = "combat_ability",
				},
				wield = {
					action_name = "action_unwield",
				},
				aim_hold = {
					action_name = "action_aim",
					chain_time = 1.4,
				},
				short_hand_aim_hold = {
					action_name = "action_aim_underhand",
					chain_time = 0.9,
				},
			},
		},
		action_aim = {
			ability_type = "grenade_ability",
			allowed_during_sprint = false,
			anim_end_event = "to_unaim_arc",
			anim_event = "to_aim_arc",
			arc_draw_delay = 0.15,
			kind = "aim_projectile",
			minimum_hold_time = 0.3,
			sprint_ready_up_time = 0.4,
			start_input = "aim_hold",
			stop_input = "block_cancel",
			throw_type = "throw",
			uninterruptible = true,
			use_ability_charge = true,
			total_time = math.huge,
			arc_configuration = {
				angle = 0.35,
				collision_filter = "filter_dynamic",
				distance = 20,
				gravity = 9.82,
				speed = 20,
			},
			allowed_chain_actions = {
				combat_ability = {
					action_name = "combat_ability",
				},
				aim_released = {
					action_name = "action_throw_grenade",
					chain_time = 0.8,
				},
				wield = {
					action_name = "action_unwield",
				},
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason == "hold_input_released"
			end,
			arc_start_offset = Vector3Box(0.5, 1, 0.1),
		},
		action_throw_grenade = {
			ability_type = "grenade_ability",
			allowed_during_sprint = false,
			anim_end_event = "equip",
			anim_event = "throw",
			kind = "throw_grenade",
			recoil_template = "default_shotgun_killshot",
			spawn_at_time = 0.22,
			throw_type = "throw",
			total_time = 0.67,
			uninterruptible = true,
			use_ability_charge = true,
			weapon_handling_template = "grenade_throw",
			conditional_state_to_action_input = {
				auto_chain = {
					input_name = "unwield_to_previous",
				},
			},
			allowed_chain_actions = {
				combat_ability = {
					action_name = "combat_ability",
				},
				unwield_to_previous = {
					action_name = "action_unwield_to_previous",
				},
				wield = {
					action_name = "action_unwield",
				},
			},
			arc_start_offset = Vector3Box(0.5, 1, 0.1),
			anim_end_event_condition_func = function (unit, data, end_reason)
				local ability_extension = ScriptUnit.has_extension(unit, "ability_system")
				local ability_type = "grenade_ability"

				return ability_extension and ability_extension:can_use_ability(ability_type)
			end,
		},
		action_aim_underhand = {
			ability_type = "grenade_ability",
			allowed_during_sprint = false,
			anim_end_event = "to_unaim_arc",
			anim_event = "prime_underhand",
			arc_draw_delay = 0.15,
			kind = "aim_projectile",
			minimum_hold_time = 0.3,
			sprint_ready_up_time = 0.4,
			start_input = "short_hand_aim_hold",
			stop_input = "short_hand_aim_released",
			throw_type = "underhand_throw",
			uninterruptible = true,
			use_ability_charge = true,
			total_time = math.huge,
			arc_configuration = {
				angle = 0.35,
				collision_filter = "filter_dynamic",
				distance = 20,
				gravity = 9.82,
				speed = 20,
			},
			allowed_chain_actions = {
				combat_ability = {
					action_name = "combat_ability",
				},
				short_hand_throw = {
					action_name = "action_underhand_throw_grenade",
					chain_time = 0.8,
				},
				wield = {
					action_name = "action_unwield",
				},
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason == "hold_input_released"
			end,
			arc_start_offset = Vector3Box(0.5, 0.1, -0.3),
		},
		action_underhand_throw_grenade = {
			ability_type = "grenade_ability",
			allowed_during_sprint = false,
			anim_end_event = "equip",
			anim_event = "throw_underhand",
			kind = "throw_grenade",
			recoil_template = "default_shotgun_killshot",
			spawn_at_time = 0.22,
			throw_type = "underhand_throw",
			total_time = 0.67,
			uninterruptible = true,
			use_ability_charge = true,
			weapon_handling_template = "grenade_throw",
			conditional_state_to_action_input = {
				auto_chain = {
					input_name = "unwield_to_previous",
				},
			},
			allowed_chain_actions = {
				combat_ability = {
					action_name = "combat_ability",
				},
				unwield_to_previous = {
					action_name = "action_unwield_to_previous",
				},
				wield = {
					action_name = "action_unwield",
				},
			},
			arc_start_offset = Vector3Box(0.5, 0.1, -0.3),
			anim_end_event_condition_func = function (unit, data, end_reason)
				local ability_extension = ScriptUnit.has_extension(unit, "ability_system")
				local ability_type = "grenade_ability"

				return ability_extension and ability_extension:can_use_ability(ability_type)
			end,
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
		combat_ability = {
			kind = "unwield_to_specific",
			slot_to_wield = "slot_combat_ability",
			start_input = "combat_ability",
			total_time = 0,
			uninterruptible = true,
			allowed_chain_actions = {},
		},
	}
	base_template.keywords = {
		"grenade",
	}
	base_template.smart_targeting_template = SmartTargetingTemplates.default_melee
	base_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/grenade"
	base_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/grenade_equipable_stumm"
	base_template.spread_template = "lasgun"
	base_template.ammo_template = "no_ammo"
	base_template.hud_configuration = {
		uses_ammunition = true,
		uses_overheat = false,
		uses_weapon_special_charges = false,
	}
	base_template.sprint_ready_up_time = 0.1
	base_template.max_first_person_anim_movement_speed = 5.8
	base_template.fx_sources = {}
	base_template.dodge_template = "default"
	base_template.sprint_template = "default"
	base_template.stamina_template = "default"
	base_template.toughness_template = "default"
	base_template.footstep_intervals = {
		crouch_walking = 0.61,
		sprinting = 0.37,
		walking = 0.4,
	}

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
