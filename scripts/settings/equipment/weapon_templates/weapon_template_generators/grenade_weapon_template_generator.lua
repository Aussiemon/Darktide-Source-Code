-- chunkname: @scripts/settings/equipment/weapon_templates/weapon_template_generators/grenade_weapon_template_generator.lua

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
					value = true,
					input = "action_one_pressed"
				}
			}
		},
		aim_released = {
			buffer_time = 0.5,
			input_sequence = {
				{
					value = false,
					input = "action_one_hold"
				}
			}
		},
		block_cancel = {
			buffer_time = 0.316,
			clear_input_queue = true,
			input_sequence = {
				{
					value = true,
					hold_input = "action_one_hold",
					input = "action_two_pressed"
				}
			}
		},
		block_cancel_release = {
			dont_queue = true,
			buffer_time = 0,
			input_sequence = {
				{
					input_mode = "all",
					inputs = {
						{
							value = false,
							input = "action_two_hold"
						}
					},
					time_window = math.huge
				}
			}
		},
		short_hand_aim_hold = {
			buffer_time = 0.91,
			input_sequence = {
				{
					value = true,
					input = "action_two_hold"
				}
			}
		},
		short_hand_throw = {
			buffer_time = 0.61,
			input_sequence = {
				{
					value = true,
					hold_input = "action_two_hold",
					input = "action_one_pressed"
				}
			}
		},
		short_hand_throw_release = {
			dont_queue = true,
			buffer_time = 0,
			input_sequence = {
				{
					input_mode = "all",
					inputs = {
						{
							value = false,
							input = "action_one_hold"
						}
					},
					time_window = math.huge
				}
			}
		},
		short_hand_aim_released = {
			buffer_time = 0.316,
			input_sequence = {
				{
					value = false,
					input = "action_two_hold"
				}
			}
		},
		wield = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					inputs = wield_inputs
				}
			}
		},
		unwield_to_previous = {
			dont_queue = true,
			buffer_time = 0
		},
		inspect_start = {
			buffer_time = 0,
			input_sequence = {
				{
					value = true,
					input = "weapon_inspect_hold"
				},
				{
					value = true,
					duration = 0.2,
					input = "weapon_inspect_hold"
				}
			}
		},
		inspect_stop = {
			buffer_time = 0.02,
			input_sequence = {
				{
					value = false,
					input = "weapon_inspect_hold",
					time_window = math.huge
				}
			}
		},
		combat_ability = {
			buffer_time = 0,
			clear_input_queue = true,
			input_sequence = {
				{
					value = true,
					input = "combat_ability_pressed"
				}
			}
		}
	}
	base_template.action_input_hierarchy = {
		wield = "stay",
		unwield_to_previous = "base",
		block_cancel = "stay",
		combat_ability = "base",
		aim_hold = {
			wield = "base",
			aim_released = "previous",
			combat_ability = "base",
			unwield_to_previous = "base",
			block_cancel = {
				wield = "base",
				block_cancel_release = "base",
				combat_ability = "base",
				unwield_to_previous = "base"
			}
		},
		short_hand_aim_hold = {
			combat_ability = "base",
			wield = "base",
			short_hand_aim_released = "previous",
			unwield_to_previous = "base",
			short_hand_throw = {
				short_hand_throw_release = "base",
				wield = "base",
				combat_ability = "base",
				unwield_to_previous = "base"
			}
		},
		inspect_start = {
			inspect_stop = "base"
		}
	}
	base_template.actions = {
		action_unwield = {
			allowed_during_sprint = true,
			start_input = "wield",
			uninterruptible = true,
			kind = "unwield",
			total_time = 0,
			allowed_chain_actions = {}
		},
		action_unwield_to_previous = {
			allowed_during_sprint = true,
			uninterruptible = true,
			kind = "unwield_to_previous",
			unwield_to_weapon = true,
			total_time = 0,
			allowed_chain_actions = {}
		},
		action_wield = {
			kind = "wield",
			weapon_handling_template = "time_scale_1_5",
			allowed_during_sprint = false,
			uninterruptible = true,
			anim_event = "to_grenade",
			total_time = 1.5,
			allowed_chain_actions = {
				combat_ability = {
					action_name = "combat_ability"
				},
				wield = {
					action_name = "action_unwield"
				},
				aim_hold = {
					action_name = "action_aim",
					chain_time = 1.4
				},
				short_hand_aim_hold = {
					action_name = "action_aim_underhand",
					chain_time = 0.9
				}
			}
		},
		action_aim = {
			arc_draw_delay = 0.15,
			start_input = "aim_hold",
			kind = "aim_projectile",
			throw_type = "throw",
			sprint_ready_up_time = 0.4,
			use_ability_charge = true,
			allowed_during_sprint = false,
			ability_type = "grenade_ability",
			minimum_hold_time = 0.3,
			anim_end_event = "to_unaim_arc",
			uninterruptible = true,
			anim_event = "to_aim_arc",
			stop_input = "block_cancel",
			total_time = math.huge,
			arc_configuration = {
				speed = 20,
				gravity = 9.82,
				distance = 20,
				angle = 0.35,
				collision_filter = "filter_dynamic"
			},
			allowed_chain_actions = {
				combat_ability = {
					action_name = "combat_ability"
				},
				aim_released = {
					action_name = "action_throw_grenade",
					chain_time = 0.1
				},
				wield = {
					action_name = "action_unwield"
				}
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason == "hold_input_released"
			end,
			arc_start_offset = Vector3Box(0.5, 1, 0.1)
		},
		action_throw_grenade = {
			weapon_handling_template = "grenade_throw",
			uninterruptible = true,
			recoil_template = "default_shotgun_killshot",
			kind = "throw_grenade",
			throw_type = "throw",
			anim_event = "throw",
			anim_end_event = "equip",
			use_ability_charge = true,
			spawn_at_time = 0.22,
			allowed_during_sprint = false,
			ability_type = "grenade_ability",
			total_time = 0.67,
			conditional_state_to_action_input = {
				unwield_from_grenade_slot = {
					input_name = "unwield_to_previous"
				}
			},
			allowed_chain_actions = {
				combat_ability = {
					action_name = "combat_ability"
				},
				unwield_to_previous = {
					action_name = "action_unwield_to_previous"
				},
				wield = {
					action_name = "action_unwield"
				}
			},
			arc_start_offset = Vector3Box(0.5, 1, 0.1),
			anim_end_event_condition_func = function (unit, data, end_reason)
				local ability_extension = ScriptUnit.has_extension(unit, "ability_system")
				local ability_type = "grenade_ability"

				return ability_extension and ability_extension:can_use_ability(ability_type)
			end
		},
		action_aim_underhand = {
			arc_draw_delay = 0.15,
			start_input = "short_hand_aim_hold",
			kind = "aim_projectile",
			throw_type = "underhand_throw",
			sprint_ready_up_time = 0.4,
			use_ability_charge = true,
			allowed_during_sprint = false,
			ability_type = "grenade_ability",
			minimum_hold_time = 0.3,
			anim_end_event = "to_unaim_arc",
			uninterruptible = true,
			anim_event = "prime_underhand",
			stop_input = "short_hand_aim_released",
			total_time = math.huge,
			arc_configuration = {
				speed = 20,
				gravity = 9.82,
				distance = 20,
				angle = 0.35,
				collision_filter = "filter_dynamic"
			},
			allowed_chain_actions = {
				combat_ability = {
					action_name = "combat_ability"
				},
				short_hand_throw = {
					action_name = "action_underhand_throw_grenade",
					chain_time = 0.1
				},
				wield = {
					action_name = "action_unwield"
				}
			},
			anim_end_event_condition_func = function (unit, data, end_reason)
				return end_reason == "hold_input_released"
			end,
			arc_start_offset = Vector3Box(0.5, 0.1, -0.3)
		},
		action_underhand_throw_grenade = {
			weapon_handling_template = "grenade_throw",
			uninterruptible = true,
			recoil_template = "default_shotgun_killshot",
			kind = "throw_grenade",
			throw_type = "underhand_throw",
			anim_event = "throw_underhand",
			anim_end_event = "equip",
			use_ability_charge = true,
			spawn_at_time = 0.22,
			allowed_during_sprint = false,
			ability_type = "grenade_ability",
			total_time = 0.67,
			conditional_state_to_action_input = {
				unwield_from_grenade_slot = {
					input_name = "unwield_to_previous"
				}
			},
			allowed_chain_actions = {
				combat_ability = {
					action_name = "combat_ability"
				},
				unwield_to_previous = {
					action_name = "action_unwield_to_previous"
				},
				wield = {
					action_name = "action_unwield"
				}
			},
			arc_start_offset = Vector3Box(0.5, 0.1, -0.3),
			anim_end_event_condition_func = function (unit, data, end_reason)
				local ability_extension = ScriptUnit.has_extension(unit, "ability_system")
				local ability_type = "grenade_ability"

				return ability_extension and ability_extension:can_use_ability(ability_type)
			end
		},
		action_inspect = {
			skip_3p_anims = false,
			lock_view = true,
			start_input = "inspect_start",
			anim_end_event = "inspect_end",
			kind = "inspect",
			anim_event = "inspect_start",
			stop_input = "inspect_stop",
			total_time = math.huge,
			crosshair = {
				crosshair_type = "inspect"
			}
		},
		combat_ability = {
			slot_to_wield = "slot_combat_ability",
			start_input = "combat_ability",
			uninterruptible = true,
			kind = "unwield_to_specific",
			total_time = 0,
			allowed_chain_actions = {}
		}
	}
	base_template.keywords = {
		"grenade"
	}
	base_template.smart_targeting_template = SmartTargetingTemplates.default_melee
	base_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/grenade"
	base_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/grenade_equipable"
	base_template.spread_template = "lasgun"
	base_template.ammo_template = "no_ammo"
	base_template.uses_ammunition = true
	base_template.uses_overheat = false
	base_template.sprint_ready_up_time = 0.1
	base_template.max_first_person_anim_movement_speed = 5.8
	base_template.fx_sources = {}
	base_template.dodge_template = "default"
	base_template.sprint_template = "default"
	base_template.stamina_template = "default"
	base_template.toughness_template = "default"
	base_template.footstep_intervals = {
		crouch_walking = 0.61,
		walking = 0.4,
		sprinting = 0.37
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
