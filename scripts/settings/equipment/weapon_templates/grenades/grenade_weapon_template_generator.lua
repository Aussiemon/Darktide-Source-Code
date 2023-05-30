local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local wield_inputs = PlayerCharacterConstants.wield_inputs

local function generate_base_template()
	local base_template = {
		action_inputs = {
			aim_hold = {
				buffer_time = 0.5,
				input_sequence = {
					{
						value = true,
						input = "action_one_hold"
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
				buffer_time = 0,
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
						input = "action_one_hold"
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
			}
		},
		action_input_hierarchy = {
			wield = "stay",
			unwield_to_previous = "base",
			block_cancel = "stay",
			aim_hold = {
				unwield_to_previous = "base",
				wield = "base",
				aim_released = "previous",
				block_cancel = {
					wield = "base",
					block_cancel_release = "base",
					unwield_to_previous = "base"
				}
			},
			short_hand_aim_hold = {
				wield = "base",
				short_hand_aim_released = "previous",
				unwield_to_previous = "base",
				short_hand_throw = {
					short_hand_throw_release = "base",
					wield = "base",
					unwield_to_previous = "base"
				}
			},
			inspect_start = {
				inspect_stop = "base"
			}
		},
		actions = {
			action_unwield = {
				continue_sprinting = true,
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
				anim_event = "to_aim_arc",
				start_input = "aim_hold",
				sprint_ready_up_time = 0.4,
				kind = "aim_projectile",
				throw_type = "throw",
				use_ability_charge = true,
				allowed_during_sprint = false,
				ability_type = "grenade_ability",
				minimum_hold_time = 0.3,
				anim_end_event = "to_unaim_arc",
				uninterruptible = true,
				arc_draw_delay = 0.15,
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
				height_anim_settings = {
					variable_name = "grenade_throw_height",
					min_pitch = -0.5,
					max_pitch = 0.5,
					max_value = 2,
					min_value = 0
				},
				arc_start_offset = Vector3Box(0.5, 1, 0.1)
			},
			action_throw_grenade = {
				weapon_handling_template = "grenade_throw",
				uninterruptible = true,
				recoil_template = "default_shotgun_killshot",
				kind = "throw_grenade",
				throw_type = "throw",
				anim_event = "throw",
				use_ability_charge = true,
				spawn_at_time = 0.22,
				allowed_during_sprint = false,
				ability_type = "grenade_ability",
				total_time = 0.67,
				conditional_state_to_action_input = {
					auto_chain = {
						input_name = "unwield_to_previous"
					}
				},
				allowed_chain_actions = {
					unwield_to_previous = {
						action_name = "action_unwield_to_previous"
					},
					wield = {
						action_name = "action_unwield"
					}
				},
				anim_end_event_condition_func = function (unit, data, end_reason)
					return false
				end
			},
			action_aim_underhand = {
				anim_event = "prime_underhand",
				start_input = "short_hand_aim_hold",
				sprint_ready_up_time = 0.4,
				kind = "aim_projectile",
				throw_type = "underhand_throw",
				use_ability_charge = true,
				allowed_during_sprint = false,
				ability_type = "grenade_ability",
				minimum_hold_time = 0.3,
				anim_end_event = "to_unaim_arc",
				uninterruptible = true,
				arc_draw_delay = 0.15,
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
				height_anim_settings = {
					variable_name = "grenade_throw_height",
					min_pitch = -0.5,
					max_pitch = 0.5,
					max_value = 2,
					min_value = 0
				},
				arc_start_offset = Vector3Box(0.5, 0.1, -0.3)
			},
			action_underhand_throw_grenade = {
				weapon_handling_template = "grenade_throw",
				uninterruptible = true,
				recoil_template = "default_shotgun_killshot",
				kind = "throw_grenade",
				throw_type = "throw",
				anim_event = "throw_underhand",
				use_ability_charge = true,
				spawn_at_time = 0.22,
				allowed_during_sprint = false,
				ability_type = "grenade_ability",
				total_time = 0.67,
				conditional_state_to_action_input = {
					auto_chain = {
						input_name = "unwield_to_previous"
					}
				},
				allowed_chain_actions = {
					unwield_to_previous = {
						action_name = "action_unwield_to_previous"
					},
					wield = {
						action_name = "action_unwield"
					}
				},
				anim_end_event_condition_func = function (unit, data, end_reason)
					return false
				end
			},
			action_inspect = {
				skip_3p_anims = false,
				lock_view = true,
				start_input = "inspect_start",
				anim_end_event = "inspect_end",
				kind = "inspect",
				crosshair_type = "none",
				anim_event = "inspect_start",
				stop_input = "inspect_stop",
				total_time = math.huge
			}
		},
		keywords = {
			"grenade"
		},
		smart_targeting_template = SmartTargetingTemplates.default_melee,
		anim_state_machine_3p = "content/characters/player/human/third_person/animations/grenade",
		anim_state_machine_1p = "content/characters/player/human/first_person/animations/grenade_equipable",
		spread_template = "lasgun",
		ammo_template = "no_ammo",
		uses_ammunition = true,
		uses_overheat = false,
		sprint_ready_up_time = 0.1,
		max_first_person_anim_movement_speed = 5.8,
		fx_sources = {},
		dodge_template = "default",
		sprint_template = "default",
		stamina_template = "default",
		toughness_template = "default",
		footstep_intervals = {
			crouch_walking = 0.61,
			walking = 0.4,
			sprinting = 0.37
		},
		action_aim_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
			return current_action_name == "action_aim"
		end,
		action_aim_underhand_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
			return current_action_name == "action_aim_underhand"
		end,
		action_none_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
			return not current_action_name or current_action_name == "none"
		end
	}

	return base_template
end

return generate_base_template
