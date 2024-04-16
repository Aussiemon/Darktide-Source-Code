local Attack = require("scripts/utilities/attack/attack")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BurningSettings = require("scripts/settings/burning/burning_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Vo = require("scripts/utilities/vo")
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_targets = BuffSettings.targets
local damage_types = DamageSettings.damage_types
local minion_burning_buff_effects = BurningSettings.buff_effects.minions
local PLAYER_KNOCKED_DOWN_POWER_LEVEL_MULTIPLIER = 0.25
local BOT_POWER_LEVEL_MULTIPLIER = 0.25

local function _scaled_damage_interval_function(template_data, template_context, template)
	local unit = template_context.unit

	if not HEALTH_ALIVE[unit] then
		return
	end

	local breed = template_context.breed
	local breed_type = breed.breed_type
	local power_level_by_breed_type = template.power_level
	local power_level_by_challenge = power_level_by_breed_type[breed_type] or power_level_by_breed_type.default
	local power_level = Managers.state.difficulty:get_table_entry_by_challenge(power_level_by_challenge)

	if template_context.is_player then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")
		local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_component)

		if is_knocked_down then
			power_level = power_level * PLAYER_KNOCKED_DOWN_POWER_LEVEL_MULTIPLIER
		end

		local player = Managers.state.player_unit_spawn:owner(unit)
		local is_bot = player and not player:is_human_controlled()

		if is_bot then
			power_level = power_level * BOT_POWER_LEVEL_MULTIPLIER
		end
	end

	if template.power_level_random then
		power_level = power_level * 0.5 + math.random() * power_level
	end

	local optional_owner_unit = template_context.is_server and template_context.owner_unit or nil
	local optional_source_item = template_context.is_server and template_context.source_item or nil
	local damage_template = template.damage_template
	local damage_type = template.damage_type

	Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_type, "attacking_unit", optional_owner_unit, "item", optional_source_item)
end

local function _scaled_increasing_damage_interval_function(template_data, template_context, template)
	local unit = template_context.unit

	if not HEALTH_ALIVE[unit] then
		return
	end

	local breed = template_context.breed
	local breed_type = breed.breed_type
	local power_level_by_breed_type = template.power_level
	local power_level_by_challenge = power_level_by_breed_type[breed_type] or power_level_by_breed_type.default
	local power_level = Managers.state.difficulty:get_table_entry_by_challenge(power_level_by_challenge)
	local num_ticks = template_data.num_ticks or 1
	local power_level_scale_per_tick = template.power_level_scale_per_tick[math.min(num_ticks, #template.power_level_scale_per_tick)]
	power_level = power_level * power_level_scale_per_tick

	if template_context.is_player then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")
		local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_component)

		if is_knocked_down then
			power_level = power_level * PLAYER_KNOCKED_DOWN_POWER_LEVEL_MULTIPLIER
		end

		local player = Managers.state.player_unit_spawn:owner(unit)
		local is_bot = player and not player:is_human_controlled()

		if is_bot then
			power_level = power_level * BOT_POWER_LEVEL_MULTIPLIER
		end
	end

	if template.power_level_random then
		power_level = power_level * 0.5 + math.random() * power_level
	end

	local optional_owner_unit = template_context.is_server and template_context.owner_unit or nil
	local optional_source_item = template_context.is_server and template_context.source_item or nil
	local damage_template = template.damage_template
	local damage_type = template.damage_type

	Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_type, "attacking_unit", optional_owner_unit, "item", optional_source_item)

	template_data.num_ticks = num_ticks + 1
end

local templates = {}

table.make_unique(templates)

templates.leaving_liquid_fire_spread_increase = {
	unique_buff_id = "fire_spread_increase",
	predicted = false,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_fire_buff_hud",
	unique_buff_priority = 1,
	duration = 1.75,
	class_name = "buff",
	is_negative = true,
	lerped_stat_buffs = {
		[buff_stat_buffs.spread_modifier] = {
			max = 0,
			min = 1
		}
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return math.smoothstep(t, start_time, start_time + duration)
	end
}
templates.flame_grenade_liquid_area = {
	power_level_random = true,
	predicted = false,
	max_stacks = 1,
	class_name = "interval_buff",
	keywords = {
		buff_keywords.burning
	},
	power_level = {
		default = {
			500,
			625,
			750,
			875
		}
	},
	damage_template = DamageProfileTemplates.flame_grenade_liquid_area_fire_burning,
	damage_type = damage_types.burning,
	interval = {
		0.5,
		1.25
	},
	interval_func = _scaled_damage_interval_function,
	minion_effects = minion_burning_buff_effects.fire
}
templates.fire_burninating = {
	power_level_random = true,
	predicted = false,
	max_stacks = 10,
	duration = 1,
	class_name = "interval_buff",
	keywords = {
		buff_keywords.burning
	},
	power_level = {
		default = {
			250,
			375,
			625,
			750
		}
	},
	damage_template = DamageProfileTemplates.liquid_area_fire_burning,
	damage_type = damage_types.burning,
	interval = {
		0.5,
		1.5
	},
	interval_func = _scaled_damage_interval_function,
	minion_effects = minion_burning_buff_effects.fire
}
templates.prop_in_corruptor_liquid_corruption = {
	interval = 1,
	predicted = false,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_nurgle_eaten_buff_hud",
	max_stacks = 1,
	class_name = "interval_buff",
	is_negative = true,
	power_level = {
		default = {
			50,
			100,
			150,
			150,
			200
		}
	},
	damage_template = DamageProfileTemplates.corruptor_liquid_corruption,
	damage_type = damage_types.corruption,
	interval_func = _scaled_damage_interval_function
}
templates.prop_in_liquid_fire_burning_movement_slow = {
	class_name = "interval_buff",
	interval = 0.5,
	predicted = true,
	hud_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_fire_buff_hud",
	max_stacks = 1,
	is_negative = true,
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = -0.25
	},
	keywords = {
		buff_keywords.burning
	},
	power_level = {
		default = {
			500,
			600,
			750,
			850,
			1000
		},
		player = {
			100,
			200,
			300,
			400,
			500
		}
	},
	damage_template = DamageProfileTemplates.liquid_area_fire_burning_barrel,
	damage_type = damage_types.burning,
	interval_func = _scaled_damage_interval_function,
	minion_effects = minion_burning_buff_effects.fire
}
templates.renegade_grenadier_in_fire_liquid = {
	class_name = "interval_buff",
	predicted = false,
	hud_priority = 1,
	interval = 0.35,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_fire_buff_hud",
	max_stacks = 1,
	is_negative = true,
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = -0.19999999999999996,
		[buff_stat_buffs.toughness_regen_rate_multiplier] = 0
	},
	keywords = {
		buff_keywords.burning,
		buff_keywords.prevent_toughness_replenish_except_abilities
	},
	forbidden_keywords = {
		buff_keywords.renegade_grenadier_liquid_immunity
	},
	power_level = {
		default = {
			400,
			400,
			400,
			400,
			400
		},
		player = MinionDifficultySettings.power_level.renegade_grenadier_fire
	},
	damage_template = DamageProfileTemplates.grenadier_liquid_fire_burning,
	damage_type = damage_types.burning,
	interval_func = _scaled_increasing_damage_interval_function,
	power_level_scale_per_tick = {
		1,
		1,
		1,
		1.25,
		1.25,
		1.3,
		1.35,
		1.5,
		1.5,
		1.6,
		1.75,
		2,
		2.25,
		2.5,
		3,
		3,
		3.25
	},
	minion_effects = minion_burning_buff_effects.fire
}
templates.cultist_flamer_in_fire_liquid = {
	class_name = "interval_buff",
	predicted = false,
	hud_priority = 1,
	interval = 0.35,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_green_fire_buff_hud",
	max_stacks = 1,
	is_negative = true,
	stat_buffs = {
		[buff_stat_buffs.toughness_regen_rate_multiplier] = 0
	},
	keywords = {
		buff_keywords.burning,
		buff_keywords.prevent_toughness_replenish_except_abilities
	},
	forbidden_keywords = {
		buff_keywords.cultist_flamer_liquid_immunity
	},
	power_level = {
		default = {
			400,
			400,
			400,
			400,
			400
		},
		player = MinionDifficultySettings.power_level.cultist_flamer_fire
	},
	damage_template = DamageProfileTemplates.cultist_flamer_liquid_fire_burning,
	damage_type = damage_types.burning,
	interval_func = _scaled_increasing_damage_interval_function,
	power_level_scale_per_tick = {
		1,
		1,
		1,
		1.25,
		1.25,
		1.3,
		1.35,
		1.5,
		1.5,
		1.6,
		1.75,
		2,
		2.25,
		2.5,
		3,
		3,
		3.25
	},
	minion_effects = minion_burning_buff_effects.chemfire
}
templates.renegade_flamer_in_fire_liquid = {
	class_name = "interval_buff",
	predicted = false,
	hud_priority = 1,
	interval = 0.35,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_fire_buff_hud",
	max_stacks = 1,
	is_negative = true,
	stat_buffs = {
		[buff_stat_buffs.toughness_regen_rate_multiplier] = 0
	},
	keywords = {
		buff_keywords.burning,
		buff_keywords.prevent_toughness_replenish_except_abilities
	},
	forbidden_keywords = {
		buff_keywords.renegade_flamer_liquid_immunity
	},
	power_level = {
		default = {
			400,
			400,
			400,
			400,
			400
		},
		player = MinionDifficultySettings.power_level.renegade_flamer_fire
	},
	damage_template = DamageProfileTemplates.renegade_flamer_liquid_fire_burning,
	damage_type = damage_types.burning,
	interval_func = _scaled_increasing_damage_interval_function,
	power_level_scale_per_tick = {
		1,
		1,
		1,
		1.25,
		1.25,
		1.3,
		1.35,
		1.5,
		1.5,
		1.6,
		1.75,
		2,
		2.25,
		2.5,
		3,
		3,
		3.25
	},
	minion_effects = minion_burning_buff_effects.fire
}
local PLAYER_SLIDING_IN_SLIME_POWER_LEVEL_MULTIPLIER = 1.25
local PLAYER_SLIDING_INTERVAL_OVERRIDE = 0.25

local function _beast_of_nurgle_in_slime_interval_function(template_data, template_context, template)
	local unit = template_context.unit

	if not HEALTH_ALIVE[unit] then
		return
	end

	local side_system = Managers.state.extension:system("side_system")
	local optional_owner_unit = template_context.is_server and template_context.owner_unit or nil
	local is_ally = optional_owner_unit and side_system:is_ally(unit, optional_owner_unit)

	if is_ally then
		return
	end

	local breed = template_context.breed
	local breed_type = breed.breed_type
	local power_level_by_breed_type = template.power_level
	local power_level_by_challenge = power_level_by_breed_type[breed_type] or power_level_by_breed_type.default
	local power_level = Managers.state.difficulty:get_table_entry_by_challenge(power_level_by_challenge)

	if template_context.is_player then
		local player = Managers.state.player_unit_spawn:owner(unit)
		local is_human_controlled = player:is_human_controlled()
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")

		if character_state_component.state_name == "consumed" then
			return
		end

		local is_sliding_or_dodging = character_state_component.state_name == "sliding" or character_state_component.state_name == "dodging"

		if is_sliding_or_dodging then
			power_level = power_level * PLAYER_SLIDING_IN_SLIME_POWER_LEVEL_MULTIPLIER
			template_context.interval_override = PLAYER_SLIDING_INTERVAL_OVERRIDE
		elseif template_context.interval_override then
			template_context.interval_override = nil
		end

		local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_component)

		if is_knocked_down then
			power_level = power_level * PLAYER_KNOCKED_DOWN_POWER_LEVEL_MULTIPLIER
		end

		if not is_human_controlled then
			power_level = power_level * BOT_POWER_LEVEL_MULTIPLIER
		end
	end

	if template.power_level_random then
		power_level = power_level * 0.5 + math.random() * power_level
	end

	local optional_source_item = template_context.is_server and template_context.source_item or nil
	local damage_template = template.damage_template
	local damage_type = template.damage_type

	Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_type, "attacking_unit", optional_owner_unit, "item", optional_source_item)
end

templates.beast_of_nurgle_in_slime = {
	predicted = false,
	interval = 0.35,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_nurgle_slime_buff_hud",
	max_stacks = 1,
	class_name = "interval_buff",
	is_negative = true,
	keywords = {
		buff_keywords.zero_slide_friction
	},
	forbidden_keywords = {
		buff_keywords.beast_of_nurgle_liquid_immunity
	},
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = -0.19999999999999996,
		[buff_stat_buffs.dodge_speed_multiplier] = 0.9
	},
	power_level = {
		default = {
			10,
			20,
			30,
			40,
			50
		}
	},
	damage_template = DamageProfileTemplates.beast_of_nurgle_slime_liquid,
	damage_type = damage_types.minion_vomit,
	interval_func = _beast_of_nurgle_in_slime_interval_function,
	player_effects = {
		looping_wwise_stop_event = "wwise/events/player/play_player_vomit_exit",
		looping_wwise_start_event = "wwise/events/player/play_player_vomit_enter",
		wwise_state = {
			group = "swamped",
			on_state = "on",
			off_state = "none"
		}
	}
}
templates.cm_habs_tree_in_slime = {
	predicted = false,
	interval = 0.35,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_nurgle_slime_buff_hud",
	max_stacks = 1,
	class_name = "interval_buff",
	is_negative = true,
	keywords = {
		buff_keywords.zero_slide_friction
	},
	forbidden_keywords = {
		buff_keywords.beast_of_nurgle_liquid_immunity
	},
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = -0.19999999999999996,
		[buff_stat_buffs.dodge_speed_multiplier] = 0.9
	},
	power_level = {
		default = {
			20,
			40,
			60,
			80,
			100
		}
	},
	damage_template = DamageProfileTemplates.beast_of_nurgle_slime_liquid,
	damage_type = damage_types.minion_vomit,
	interval_func = _beast_of_nurgle_in_slime_interval_function,
	player_effects = {
		looping_wwise_stop_event = "wwise/events/player/play_player_vomit_exit",
		looping_wwise_start_event = "wwise/events/player/play_player_vomit_enter",
		wwise_state = {
			group = "swamped",
			on_state = "on",
			off_state = "none"
		}
	}
}

local function _toxic_gas_interval_function(template_data, template_context, template)
	local unit = template_context.unit

	if not HEALTH_ALIVE[unit] or not template_context.is_player then
		return
	end

	local breed = template_context.breed
	local breed_type = breed.breed_type
	local power_level_by_breed_type = template.power_level
	local power_level_by_challenge = power_level_by_breed_type[breed_type] or power_level_by_breed_type.default
	local power_level = Managers.state.difficulty:get_table_entry_by_challenge(power_level_by_challenge)

	if template_context.is_player then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")
		local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_component)

		if is_knocked_down then
			power_level = power_level * PLAYER_KNOCKED_DOWN_POWER_LEVEL_MULTIPLIER
		end

		local player = Managers.state.player_unit_spawn:owner(unit)
		local is_bot = player and not player:is_human_controlled()

		if is_bot then
			power_level = power_level * BOT_POWER_LEVEL_MULTIPLIER
		end
	end

	if template.power_level_random then
		power_level = power_level * 0.5 + math.random() * power_level
	end

	local player_health_extension = ScriptUnit.extension(unit, "health_system")
	local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")
	local has_toughness = toughness_extension and toughness_extension:current_toughness_percent() > 0
	local should_apply_damage = has_toughness or player_health_extension:damage_taken() > player_health_extension:permanent_damage_taken() + 5

	if should_apply_damage then
		local optional_owner_unit = template_context.is_server and template_context.owner_unit or nil
		local optional_source_item = template_context.is_server and template_context.source_item or nil
		local damage_template = template.damage_template
		local damage_type = template.damage_type

		Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_type, "attacking_unit", optional_owner_unit, "item", optional_source_item)
	end
end

local function _toxic_gas_scaled_damage_interval_function(template_data, template_context, template)
	local unit = template_context.unit

	if not HEALTH_ALIVE[unit] or not template_context.is_player then
		return
	end

	local breed = template_context.breed
	local breed_type = breed.breed_type
	local power_level_by_breed_type = template.power_level
	local power_level_by_challenge = power_level_by_breed_type[breed_type] or power_level_by_breed_type.default
	local power_level = Managers.state.difficulty:get_table_entry_by_challenge(power_level_by_challenge)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")
	local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_component)

	if is_knocked_down then
		power_level = power_level * PLAYER_KNOCKED_DOWN_POWER_LEVEL_MULTIPLIER
	end

	local player = Managers.state.player_unit_spawn:owner(unit)
	local is_bot = player and not player:is_human_controlled()

	if is_bot then
		power_level = power_level * BOT_POWER_LEVEL_MULTIPLIER
	end

	if template.power_level_random then
		power_level = power_level * 0.5 + math.random() * power_level
	end

	local optional_owner_unit = template_context.is_server and template_context.owner_unit or nil
	local optional_source_item = template_context.is_server and template_context.source_item or nil
	local damage_template = template.damage_template
	local damage_type = template.damage_type

	Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_type, "attacking_unit", optional_owner_unit, "item", optional_source_item)
end

local EMPOWERED_BREEDS = {
	chaos_poxwalker = true
}
templates.in_toxic_gas = {
	predicted = false,
	hud_priority = 1,
	interval = 0.75,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_toxic_cloud_buff_hud",
	max_stacks = 1,
	class_name = "interval_buff",
	is_negative = true,
	stat_buffs = {
		[buff_stat_buffs.toughness_coherency_regen_rate_multiplier] = 0,
		[buff_stat_buffs.toughness_replenish_multiplier] = 0.5,
		[buff_stat_buffs.toughness_regen_rate_multiplier] = 0
	},
	keywords = {
		buff_keywords.concealed,
		buff_keywords.in_toxic_gas
	},
	power_level = {
		default = {
			8,
			10,
			12,
			15,
			20
		}
	},
	damage_template = DamageProfileTemplates.toxic_gas,
	damage_type = damage_types.corruption,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		if template_context.is_server then
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local breed = unit_data_extension:breed()
			local is_player_character = Breed.is_player(breed)

			if not is_player_character then
				local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

				if buff_extension and not buff_extension:has_keyword("empowered") then
					local t = Managers.time:time("gameplay")
					local _, buff_id = buff_extension:add_externally_controlled_buff("empowered_poxwalker", t)
					template_data.empowered_buff_id = buff_id
				end
			end
		end

		if DEDICATED_SERVER then
			return
		end

		local is_local_unit = template_context.is_local_unit

		if not is_local_unit then
			return
		end

		if template_context.is_player then
			local player = Managers.state.player_unit_spawn:owner(unit)
			local is_bot = player and not player:is_human_controlled()

			if not is_bot then
				local outline_system = Managers.state.extension:system("outline_system")

				outline_system:set_global_visibility(false)
			end

			Vo.coughing_event(unit)
		end
	end,
	stop_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		if template_context.is_server and template_data.empowered_buff_id then
			local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

			if buff_extension then
				buff_extension:remove_externally_controlled_buff(template_data.empowered_buff_id)

				local t = Managers.time:time("gameplay")

				buff_extension:add_internally_controlled_buff("empowered_poxwalker_with_duration", t)
			end
		end

		if DEDICATED_SERVER then
			return
		end

		local is_local_unit = template_context.is_local_unit

		if not is_local_unit then
			return
		end

		if template_context.is_player then
			local player = Managers.state.player_unit_spawn:owner(unit)
			local is_bot = player and not player:is_human_controlled()

			if not is_bot then
				local outline_system = Managers.state.extension:system("outline_system")

				outline_system:set_global_visibility(true)
			end

			Vo.coughing_ends_event(unit)
		end
	end,
	interval_func = _toxic_gas_scaled_damage_interval_function,
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/player_screen_twins_gas",
		looping_wwise_stop_event = "wwise/events/player/play_player_gas_exit",
		looping_wwise_start_event = "wwise/events/player/play_player_gas_enter",
		stop_type = "destroy",
		wwise_state = {
			group = "swamped",
			on_state = "on",
			off_state = "none"
		}
	}
}
templates.left_toxic_gas = {
	predicted = false,
	hud_priority = 1,
	interval = 0.5,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_toxic_cloud_buff_hud",
	max_stacks = 1,
	duration = 0.5,
	class_name = "interval_buff",
	is_negative = true,
	target = buff_targets.player_only,
	stat_buffs = {
		[buff_stat_buffs.toughness_coherency_regen_rate_multiplier] = 0,
		[buff_stat_buffs.toughness_replenish_multiplier] = 0.5,
		[buff_stat_buffs.toughness_regen_rate_multiplier] = 0
	},
	keywords = {
		buff_keywords.concealed,
		buff_keywords.in_toxic_gas
	},
	power_level = {
		default = {
			1,
			2,
			4,
			6,
			8
		}
	},
	damage_template = DamageProfileTemplates.toxic_gas_mutator,
	damage_type = damage_types.corruption,
	interval_func = _toxic_gas_scaled_damage_interval_function,
	player_effects = {
		looping_wwise_stop_event = "wwise/events/player/play_player_gas_exit",
		looping_wwise_start_event = "wwise/events/player/play_player_gas_enter",
		stop_type = "destroy",
		wwise_state = {
			group = "swamped",
			on_state = "on",
			off_state = "none"
		}
	}
}
local TWIN_GAS_BUILDUP_BY_CHALLENGE = {
	20,
	20,
	20,
	15,
	12
}

local function _twin_toxic_gas_interval_function(template_data, template_context, template)
	local unit = template_context.unit

	if not HEALTH_ALIVE[unit] then
		return
	end

	local breed = template_context.breed
	local breed_type = breed.breed_type
	local power_level_by_breed_type = template.power_level
	local power_level_by_challenge = power_level_by_breed_type[breed_type] or power_level_by_breed_type.default
	local power_level = Managers.state.difficulty:get_table_entry_by_challenge(power_level_by_challenge)

	if template_context.is_player then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")
		local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_component)

		if is_knocked_down then
			power_level = power_level * PLAYER_KNOCKED_DOWN_POWER_LEVEL_MULTIPLIER
		end

		local player = Managers.state.player_unit_spawn:owner(unit)
		local is_bot = player and not player:is_human_controlled()

		if is_bot then
			power_level = power_level * BOT_POWER_LEVEL_MULTIPLIER
		end
	end

	local start_t = template_data.start_t

	if start_t then
		local t = Managers.time:time("gameplay")
		local duration = t - start_t
		local max_duration = Managers.state.difficulty:get_table_entry_by_challenge(TWIN_GAS_BUILDUP_BY_CHALLENGE)
		local percentage = math.min(duration / max_duration, 1)
		power_level = power_level * percentage
	end

	local optional_owner_unit = template_context.is_server and template_context.owner_unit or nil
	local optional_source_item = template_context.is_server and template_context.source_item or nil
	local damage_template = template.damage_template
	local damage_type = template.damage_type

	Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_type, "attacking_unit", optional_owner_unit, "item", optional_source_item)
end

templates.in_cultist_grenadier_gas = {
	predicted = false,
	hud_priority = 1,
	interval = 0.75,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_toxic_cloud_buff_hud",
	max_stacks = 1,
	class_name = "interval_buff",
	is_negative = true,
	stat_buffs = {
		[buff_stat_buffs.toughness_coherency_regen_rate_multiplier] = 0,
		[buff_stat_buffs.toughness_replenish_multiplier] = 0.3,
		[buff_stat_buffs.toughness_regen_rate_multiplier] = 0
	},
	keywords = {
		buff_keywords.concealed,
		buff_keywords.in_toxic_gas
	},
	power_level = {
		default = {
			8,
			10,
			12,
			15,
			20
		}
	},
	damage_template = DamageProfileTemplates.cultist_grenadier_gas,
	damage_type = damage_types.corruption,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		if template_context.is_server then
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local breed = unit_data_extension:breed()
			local is_player_character = Breed.is_player(breed)

			if not is_player_character then
				local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

				if buff_extension and not buff_extension:has_keyword("empowered") then
					local t = Managers.time:time("gameplay")
					local _, buff_id = buff_extension:add_externally_controlled_buff("empowered_poxwalker", t)
					template_data.empowered_buff_id = buff_id
				end
			end
		end

		if DEDICATED_SERVER then
			return
		end

		local is_local_unit = template_context.is_local_unit

		if not is_local_unit then
			return
		end

		if template_context.is_player then
			local player = Managers.state.player_unit_spawn:owner(unit)
			local is_bot = player and not player:is_human_controlled()

			if not is_bot then
				local outline_system = Managers.state.extension:system("outline_system")

				outline_system:set_global_visibility(false)
			end

			Vo.coughing_event(unit)
		end
	end,
	stop_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		if template_context.is_server and template_data.empowered_buff_id then
			local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

			if buff_extension then
				buff_extension:remove_externally_controlled_buff(template_data.empowered_buff_id)

				local t = Managers.time:time("gameplay")

				buff_extension:add_internally_controlled_buff("empowered_poxwalker_with_duration", t)
			end
		end

		if DEDICATED_SERVER then
			return
		end

		local is_local_unit = template_context.is_local_unit

		if not is_local_unit then
			return
		end

		if template_context.is_player then
			local player = Managers.state.player_unit_spawn:owner(unit)
			local is_bot = player and not player:is_human_controlled()

			if not is_bot then
				local outline_system = Managers.state.extension:system("outline_system")

				outline_system:set_global_visibility(true)
			end

			Vo.coughing_ends_event(unit)
		end
	end,
	interval_func = _toxic_gas_scaled_damage_interval_function,
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/player_screen_twins_gas",
		looping_wwise_stop_event = "wwise/events/player/play_player_gas_exit",
		looping_wwise_start_event = "wwise/events/player/play_player_gas_enter",
		stop_type = "destroy",
		wwise_state = {
			group = "swamped",
			on_state = "on",
			off_state = "none"
		}
	}
}
templates.in_twin_toxic_gas = {
	predicted = false,
	hud_priority = 1,
	interval = 0.25,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_toxic_cloud_buff_hud",
	max_stacks = 1,
	class_name = "interval_buff",
	is_negative = true,
	stat_buffs = {
		[buff_stat_buffs.toughness_regen_rate_multiplier] = 0
	},
	keywords = {
		buff_keywords.concealed,
		buff_keywords.in_toxic_gas,
		buff_keywords.prevent_toughness_replenish_except_abilities
	},
	power_level = {
		default = {
			5,
			8,
			12.5,
			15,
			20
		}
	},
	damage_template = DamageProfileTemplates.toxic_gas_mutator,
	damage_type = damage_types.corruption,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		if template_context.is_server then
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local breed = unit_data_extension:breed()

			if EMPOWERED_BREEDS[breed.name] then
				local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

				if buff_extension and not buff_extension:has_keyword("empowered") then
					local t = Managers.time:time("gameplay")
					local _, buff_id = buff_extension:add_externally_controlled_buff("empowered_poxwalker", t)
					template_data.empowered_buff_id = buff_id
				end
			end
		end

		if DEDICATED_SERVER then
			return
		end

		local is_local_unit = template_context.is_local_unit

		if not is_local_unit then
			return
		end

		if template_context.is_player then
			local player = Managers.state.player_unit_spawn:owner(unit)
			local is_bot = player and not player:is_human_controlled()

			if not is_bot then
				local outline_system = Managers.state.extension:system("outline_system")

				outline_system:set_global_visibility(false)
			end

			Vo.coughing_event(unit)
		end

		local t = Managers.time:time("gameplay")
		template_data.start_t = t
	end,
	stop_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		if template_context.is_server and template_data.empowered_buff_id then
			local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

			if buff_extension then
				buff_extension:remove_externally_controlled_buff(template_data.empowered_buff_id)

				local t = Managers.time:time("gameplay")

				buff_extension:add_internally_controlled_buff("empowered_poxwalker_with_duration", t)
			end
		end

		if DEDICATED_SERVER then
			return
		end

		local is_local_unit = template_context.is_local_unit

		if not is_local_unit then
			return
		end

		if template_context.is_player then
			local player = Managers.state.player_unit_spawn:owner(unit)
			local is_bot = player and not player:is_human_controlled()

			if not is_bot then
				local outline_system = Managers.state.extension:system("outline_system")

				outline_system:set_global_visibility(true)
			end

			Vo.coughing_ends_event(unit)
		end
	end,
	interval_func = _twin_toxic_gas_interval_function,
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/player_screen_twins_gas",
		looping_wwise_stop_event = "wwise/events/player/play_player_gas_exit",
		looping_wwise_start_event = "wwise/events/player/play_player_gas_enter",
		stop_type = "destroy",
		wwise_state = {
			group = "swamped",
			on_state = "on",
			off_state = "none"
		}
	}
}
templates.left_twin_toxic_gas = {
	predicted = false,
	hud_priority = 1,
	interval = 0.5,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_toxic_cloud_buff_hud",
	max_stacks = 1,
	duration = 0.5,
	class_name = "interval_buff",
	is_negative = true,
	target = buff_targets.player_only,
	stat_buffs = {
		[buff_stat_buffs.toughness_regen_rate_multiplier] = 0
	},
	keywords = {
		buff_keywords.concealed
	},
	power_level = {
		default = {
			1,
			2,
			4,
			6,
			8
		}
	},
	damage_template = DamageProfileTemplates.toxic_gas_mutator,
	damage_type = damage_types.corruption,
	interval_func = _twin_toxic_gas_interval_function
}
templates.in_buildup_twin_toxic_gas = {
	predicted = false,
	hud_priority = 1,
	interval = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_toxic_cloud_buff_hud",
	max_stacks = 1,
	class_name = "interval_buff",
	is_negative = true,
	stat_buffs = {
		[buff_stat_buffs.toughness_regen_rate_multiplier] = 0
	},
	keywords = {
		buff_keywords.concealed,
		buff_keywords.in_toxic_gas
	},
	power_level = {
		default = {
			6,
			8,
			10,
			12.5,
			15
		}
	},
	damage_template = DamageProfileTemplates.toxic_gas_mutator,
	damage_type = damage_types.corruption,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		if DEDICATED_SERVER then
			return
		end

		local is_local_unit = template_context.is_local_unit

		if not is_local_unit then
			return
		end

		if template_context.is_player then
			local player = Managers.state.player_unit_spawn:owner(unit)
			local is_bot = player and not player:is_human_controlled()

			if not is_bot then
				local outline_system = Managers.state.extension:system("outline_system")

				outline_system:set_global_visibility(false)
			end

			Vo.coughing_event(unit)
		end

		local t = Managers.time:time("gameplay")
		template_data.start_t = t
	end,
	stop_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		if DEDICATED_SERVER then
			return
		end

		local is_local_unit = template_context.is_local_unit

		if not is_local_unit then
			return
		end

		if template_context.is_player then
			local player = Managers.state.player_unit_spawn:owner(unit)
			local is_bot = player and not player:is_human_controlled()

			if not is_bot then
				local outline_system = Managers.state.extension:system("outline_system")

				outline_system:set_global_visibility(true)
			end

			Vo.coughing_ends_event(unit)
		end
	end,
	interval_func = _twin_toxic_gas_interval_function,
	player_effects = {
		looping_wwise_stop_event = "wwise/events/player/play_player_gas_exit",
		looping_wwise_start_event = "wwise/events/player/play_player_gas_enter",
		stop_type = "stop",
		wwise_state = {
			group = "swamped",
			on_state = "on",
			off_state = "none"
		}
	}
}
templates.left_buildup_twin_toxic_gas = {
	predicted = false,
	hud_priority = 1,
	interval = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_toxic_cloud_buff_hud",
	max_stacks = 1,
	duration = 0.5,
	class_name = "interval_buff",
	is_negative = true,
	target = buff_targets.player_only,
	stat_buffs = {
		[buff_stat_buffs.toughness_regen_rate_multiplier] = 0
	},
	keywords = {
		buff_keywords.concealed
	},
	power_level = {
		default = {
			1,
			2,
			4,
			6,
			8
		}
	},
	damage_template = DamageProfileTemplates.toxic_gas_mutator,
	damage_type = damage_types.corruption,
	interval_func = _twin_toxic_gas_interval_function
}
templates.prop_in_druglab_tank_goo = {
	interval = 1,
	predicted = false,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_nurgle_eaten_buff_hud",
	max_stacks = 1,
	class_name = "interval_buff",
	is_negative = true,
	power_level = {
		default = {
			15,
			30,
			50,
			50,
			75
		}
	},
	damage_template = DamageProfileTemplates.corruptor_liquid_corruption,
	damage_type = damage_types.corruption,
	interval_func = _scaled_damage_interval_function
}
local cultist_flamer_leaving_liquid_fire_spread_increase = table.clone(templates.leaving_liquid_fire_spread_increase)
cultist_flamer_leaving_liquid_fire_spread_increase.forbidden_keywords = {
	buff_keywords.cultist_flamer_liquid_immunity
}
templates.cultist_flamer_leaving_liquid_fire_spread_increase = cultist_flamer_leaving_liquid_fire_spread_increase
cultist_flamer_leaving_liquid_fire_spread_increase.hud_priority = 1
cultist_flamer_leaving_liquid_fire_spread_increase.hud_icon = "content/ui/textures/icons/buffs/hud/states_green_fire_buff_hud"
cultist_flamer_leaving_liquid_fire_spread_increase.is_negative = true
local renegade_flamer_leaving_liquid_fire_spread_increase = table.clone(templates.cultist_flamer_leaving_liquid_fire_spread_increase)
renegade_flamer_leaving_liquid_fire_spread_increase.hud_icon = "content/ui/textures/icons/buffs/hud/states_fire_buff_hud"
renegade_flamer_leaving_liquid_fire_spread_increase.forbidden_keywords = {
	buff_keywords.renegade_flamer_liquid_immunity
}
templates.renegade_flamer_leaving_liquid_fire_spread_increase = renegade_flamer_leaving_liquid_fire_spread_increase
local renegade_grenadier_leaving_liquid_fire_spread_increase = table.clone(templates.leaving_liquid_fire_spread_increase)
renegade_grenadier_leaving_liquid_fire_spread_increase.hud_priority = 1
renegade_grenadier_leaving_liquid_fire_spread_increase.hud_icon = "content/ui/textures/icons/buffs/hud/states_fire_buff_hud"
renegade_grenadier_leaving_liquid_fire_spread_increase.is_negative = true
renegade_grenadier_leaving_liquid_fire_spread_increase.forbidden_keywords = {
	buff_keywords.renegade_grenadier_liquid_immunity
}
templates.renegade_grenadier_leaving_liquid_fire_spread_increase = renegade_grenadier_leaving_liquid_fire_spread_increase

return templates
