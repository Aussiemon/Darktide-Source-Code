local BuffSettings = require("scripts/settings/buff/buff_settings")
local Keywords = BuffSettings.keywords
local FixedFrame = require("scripts/utilities/fixed_frame")
local stat_buffs = BuffSettings.stat_buffs
local meta_stat_buffs = BuffSettings.meta_stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}
local DISPLAY = table.enum("number", "percentage")
templates.gadget_coherency_aura_lingers = {
	class_name = "stepped_range_buff",
	predicted = false,
	keywords = {
		Keywords.no_coherency_stickiness_limit
	},
	stat_buffs = {
		[stat_buffs.coherency_stickiness_time_value] = {
			3,
			4,
			5,
			6,
			7,
			8,
			9,
			10
		}
	},
	localization_info = {
		[stat_buffs.coherency_stickiness_time_value] = DISPLAY.number
	}
}
templates.gadget_mission_xp_increase = {
	meta_buff = true,
	meta_stat_buffs = {
		[meta_stat_buffs.mission_reward_xp_modifier] = {
			max = 0.1,
			min = 0.01
		}
	},
	localization_info = {
		[meta_stat_buffs.mission_reward_xp_modifier] = DISPLAY.percentage
	}
}
templates.gadget_mission_credits_increase = {
	meta_buff = true,
	meta_stat_buffs = {
		[meta_stat_buffs.mission_reward_credit_modifier] = {
			max = 0.15,
			min = 0.02
		}
	},
	localization_info = {
		[meta_stat_buffs.mission_reward_credit_modifier] = DISPLAY.percentage
	}
}
templates.gadget_mission_reward_gear_instead_of_weapon_increase = {
	meta_buff = true,
	meta_stat_buffs = {
		[meta_stat_buffs.mission_reward_gear_instead_of_weapon_modifier] = {
			max = 0.25,
			min = 0.1
		}
	},
	localization_info = {
		[meta_stat_buffs.mission_reward_gear_instead_of_weapon_modifier] = DISPLAY.percentage
	}
}
templates.gadget_mission_reward_rare_loot_increase = {
	meta_buff = true,
	meta_stat_buffs = {
		[meta_stat_buffs.mission_reward_rare_loot_modifier] = {
			max = 0.1,
			min = 0.02
		}
	},
	localization_info = {
		[meta_stat_buffs.mission_reward_rare_loot_modifier] = DISPLAY.percentage
	}
}
templates.gadget_side_mission_double_reward = {
	meta_buff = true,
	meta_stat_buffs = {
		[meta_stat_buffs.side_mission_reward_xp_modifier] = 1,
		[meta_stat_buffs.side_mission_reward_credit_modifier] = 1
	},
	localization_info = {
		[meta_stat_buffs.side_mission_reward_xp_modifier] = DISPLAY.percentage,
		[meta_stat_buffs.side_mission_reward_credit_modifier] = DISPLAY.percentage
	}
}
templates.gadget_stamina_regeneration = {
	class_name = "limit_range_buff",
	predicted = false,
	keywords = {},
	stat_buffs = {
		[stat_buffs.stamina_regeneration_modifier] = {
			max = 0.25,
			min = 0.05
		}
	},
	localization_info = {
		[stat_buffs.stamina_regeneration_modifier] = DISPLAY.percentage
	}
}
templates.gadget_stamina_regeneration_in_coherency = {
	class_name = "limit_range_buff",
	predicted = false,
	keywords = {},
	stat_buffs = {
		[stat_buffs.stamina_regeneration_modifier] = {
			max = 0.15,
			min = 0.03
		}
	},
	conditional_limit_range_stat_buffs_func = function (template_data, template_context)
		local unit = template_context.unit
		local coherency_extension = ScriptUnit.has_extension(unit, "coherency_system")

		if not coherency_extension then
			return false
		end

		local num_coherency = coherency_extension:num_units_in_coherency()
		local in_coherency = num_coherency > 1

		return in_coherency
	end,
	localization_info = {
		[stat_buffs.stamina_regeneration_modifier] = DISPLAY.percentage
	}
}
templates.gadget_permanent_damage_resistance = {
	class_name = "limit_range_buff",
	predicted = false,
	keywords = {},
	stat_buffs = {
		[stat_buffs.permanent_damage_converter_resistance] = {
			max = 0.5,
			min = 0.1
		}
	},
	localization_info = {
		[stat_buffs.permanent_damage_converter_resistance] = DISPLAY.percentage
	}
}
templates.gadget_health_increase = {
	class_name = "limit_range_buff",
	predicted = false,
	keywords = {},
	stat_buffs = {
		[stat_buffs.max_health_modifier] = {
			max = 0.15,
			min = 0.02
		}
	},
	localization_info = {
		[stat_buffs.max_health_modifier] = DISPLAY.percentage
	}
}
templates.gadget_toughness_increase = {
	class_name = "limit_range_buff",
	predicted = false,
	keywords = {},
	stat_buffs = {
		[stat_buffs.toughness_bonus] = {
			max = 25,
			min = 5
		}
	},
	localization_info = {
		[stat_buffs.toughness_bonus] = DISPLAY.number
	}
}
templates.gadget_stamina_while_reviving = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.stamina_modifier] = 1
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local unit = template_context.unit
		local interactor_extension = ScriptUnit.extension(unit, "interactor_system")
		local is_interacting = interactor_extension:is_interacting()

		if is_interacting then
			local interaction = interactor_extension:interaction()
			local interaction_type = interaction:type()
			local is_reviving = interaction_type == "revive"

			return is_reviving
		end
	end,
	localization_info = {
		[stat_buffs.stamina_modifier] = DISPLAY.percentage
	}
}
templates.gadget_push_block_angle_increase = {
	class_name = "limit_range_buff",
	predicted = false,
	keywords = {},
	stat_buffs = {
		[stat_buffs.inner_push_angle_modifier] = {
			max = 0.15,
			min = 0.02
		},
		[stat_buffs.outer_push_angle_modifier] = {
			max = 0.25,
			min = 0.03
		},
		[stat_buffs.block_angle_modifier] = {
			max = 0.25,
			min = 0.03
		}
	},
	localization_info = {
		[stat_buffs.inner_push_angle_modifier] = DISPLAY.percentage,
		[stat_buffs.outer_push_angle_modifier] = DISPLAY.percentage,
		[stat_buffs.block_angle_modifier] = DISPLAY.percentage
	}
}
templates.gadget_mission_objective_complete_buff = {
	predicted = false,
	class_name = "proc_buff",
	keywords = {},
	proc_events = {
		[proc_events.on_side_mission_objective_complete] = 1
	},
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()
		local unit = params.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		buff_extension:add_externally_controlled_buff("gadget_health_buff", t)
	end,
	localization_info = {
		proc_buff_name = "gadget_health_buff"
	}
}
templates.gadget_all_grimoires_buff = {
	predicted = false,
	class_name = "proc_buff",
	keywords = {},
	proc_events = {
		[proc_events.on_all_grimoires_picked_up] = 1
	},
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()
		local unit = params.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		buff_extension:add_externally_controlled_buff("gadget_health_buff", t)
	end,
	localization_info = {
		proc_buff_name = "gadget_health_buff"
	}
}
templates.gadget_play_with_only_bots_buff = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.max_health_modifier] = 0.25
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local human_players = Managers.player:human_players()
		local num_human_players = table.size(human_players)
		local is_single_human_player = num_human_players == 1

		return is_single_human_player
	end,
	localization_info = {
		[stat_buffs.max_health_modifier] = DISPLAY.percentage
	}
}
templates.gadget_medical_healing_increase = {
	class_name = "limit_range_buff",
	predicted = false,
	keywords = {},
	stat_buffs = {
		[stat_buffs.medical_crate_healing_modifier] = {
			max = 0.25,
			min = 0.05
		}
	},
	localization_info = {
		[stat_buffs.medical_crate_healing_modifier] = DISPLAY.percentage
	}
}
templates.gadget_revive_speed_increase = {
	class_name = "limit_range_buff",
	predicted = false,
	keywords = {},
	stat_buffs = {
		[stat_buffs.revive_speed_modifier] = {
			max = 0.25,
			min = 0.05
		}
	},
	localization_info = {
		[stat_buffs.revive_speed_modifier] = DISPLAY.percentage
	}
}
templates.gadget_toughness_increase_on_revive = {
	predicted = false,
	class_name = "proc_buff",
	keywords = {},
	proc_events = {
		[proc_events.on_revive] = 1
	},
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()
		local unit = params.unit
		local unit_buff_extension = ScriptUnit.extension(unit, "buff_system")

		unit_buff_extension:add_internally_controlled_buff("gadget_toughness_buff", t)

		local revived_unit = params.revived_unit
		local revived_unit_buff_extension = ScriptUnit.extension(revived_unit, "buff_system")

		revived_unit_buff_extension:add_internally_controlled_buff("gadget_toughness_buff", t)
	end,
	localization_info = {
		proc_buff_name = "gadget_toughness_buff"
	}
}
templates.gadget_health_buff = {
	class_name = "buff",
	predicted = false,
	keywords = {},
	stat_buffs = {
		[stat_buffs.max_health_modifier] = 0.25
	},
	localization_info = {
		[stat_buffs.max_health_modifier] = DISPLAY.percentage
	}
}
templates.gadget_toughness_buff = {
	duration = 5,
	predicted = false,
	class_name = "buff",
	keywords = {},
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_modifier] = 0.5
	},
	localization_info = {
		[stat_buffs.toughness_damage_taken_modifier] = DISPLAY.percentage
	}
}

return templates
