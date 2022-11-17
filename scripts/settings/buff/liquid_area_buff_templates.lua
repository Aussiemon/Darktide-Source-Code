local AilmentSettings = require("scripts/settings/ailments/ailment_settings")
local Attack = require("scripts/utilities/attack/attack")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local ailment_effects = AilmentSettings.effects
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
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

local templates = {
	leaving_liquid_fire_spread_increase = {
		unique_buff_id = "fire_spread_increase",
		unique_buff_priority = 1,
		duration = 1.75,
		class_name = "buff",
		lerped_stat_buffs = {
			[buff_stat_buffs.spread_modifier] = {
				max = 0,
				min = 1
			}
		},
		lerp_t_func = function (t, start_time, duration, template_data, template_context)
			return math.smoothstep(t, start_time, start_time + duration)
		end
	},
	in_liquid_fire_burning_movement_slow = {
		class_name = "interval_buff",
		power_level_random = true,
		max_stacks = 1,
		stat_buffs = {
			[buff_stat_buffs.movement_speed] = 0.75
		},
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
		minion_effects = {
			ailment_effect = ailment_effects.burning,
			node_effects = {
				{
					node_name = "j_spine",
					vfx = {
						material_emission = true,
						particle_effect = "content/fx/particles/enemies/buff_burning",
						orphaned_policy = "destroy",
						stop_type = "stop"
					},
					sfx = {
						looping_wwise_stop_event = "wwise/events/weapon/stop_enemy_on_fire",
						looping_wwise_start_event = "wwise/events/weapon/play_enemy_on_fire"
					}
				}
			}
		}
	},
	fire_burninating = {
		duration = 1,
		power_level_random = true,
		predicted = false,
		max_stacks = 10,
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
		minion_effects = {
			ailment_effect = ailment_effects.burning,
			node_effects = {
				{
					node_name = "j_spine",
					vfx = {
						material_emission = true,
						particle_effect = "content/fx/particles/enemies/buff_burning",
						orphaned_policy = "destroy",
						stop_type = "stop"
					},
					sfx = {
						looping_wwise_stop_event = "wwise/events/weapon/stop_enemy_on_fire",
						looping_wwise_start_event = "wwise/events/weapon/play_enemy_on_fire"
					}
				}
			}
		}
	},
	fire_burninating_long = {
		interval = 1,
		predicted = false,
		max_stacks = 10,
		duration = 7.5,
		class_name = "interval_buff",
		keywords = {
			buff_keywords.burning
		},
		power_level = {
			default = {
				500,
				500,
				500,
				500,
				500
			}
		},
		damage_template = DamageProfileTemplates.liquid_area_fire_burning,
		damage_type = damage_types.burning,
		interval_func = _scaled_damage_interval_function,
		minion_effects = {
			ailment_effect = ailment_effects.burning,
			node_effects = {
				{
					node_name = "j_spine",
					vfx = {
						material_emission = true,
						particle_effect = "content/fx/particles/enemies/buff_burning",
						orphaned_policy = "destroy",
						stop_type = "stop"
					},
					sfx = {
						looping_wwise_stop_event = "wwise/events/weapon/stop_enemy_on_fire",
						looping_wwise_start_event = "wwise/events/weapon/play_enemy_on_fire"
					}
				}
			}
		}
	},
	prop_in_corruptor_liquid_corruption = {
		interval = 1,
		max_stacks = 1,
		class_name = "interval_buff",
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
	},
	prop_in_liquid_fire_burning_movement_slow = {
		interval = 1,
		class_name = "interval_buff",
		hud_priority = 1,
		hud_icon = "content/ui/textures/icons/buffs/hud/states_knocked_down_buff_hud",
		max_stacks = 1,
		stat_buffs = {
			[buff_stat_buffs.movement_speed] = 0.75
		},
		keywords = {
			buff_keywords.burning
		},
		power_level = {
			default = {
				500,
				500,
				500,
				500,
				500
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
		minion_effects = {
			ailment_effect = ailment_effects.burning,
			node_effects = {
				{
					node_name = "j_spine",
					vfx = {
						material_emission = true,
						particle_effect = "content/fx/particles/enemies/buff_burning",
						orphaned_policy = "destroy",
						stop_type = "stop"
					},
					sfx = {
						looping_wwise_stop_event = "wwise/events/weapon/stop_enemy_on_fire",
						looping_wwise_start_event = "wwise/events/weapon/play_enemy_on_fire"
					}
				}
			}
		}
	},
	renegade_grenadier_in_fire_liquid = {
		class_name = "interval_buff",
		interval = 0.2,
		max_stacks = 1,
		stat_buffs = {
			[buff_stat_buffs.movement_speed] = 0.8
		},
		keywords = {
			buff_keywords.burning
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
		interval_func = _scaled_damage_interval_function,
		minion_effects = {
			ailment_effect = ailment_effects.burning,
			node_effects = {
				{
					node_name = "j_spine",
					vfx = {
						material_emission = true,
						particle_effect = "content/fx/particles/enemies/buff_burning",
						orphaned_policy = "destroy",
						stop_type = "stop"
					},
					sfx = {
						looping_wwise_stop_event = "wwise/events/weapon/stop_enemy_on_fire",
						looping_wwise_start_event = "wwise/events/weapon/play_enemy_on_fire"
					}
				}
			}
		}
	},
	cultist_flamer_in_fire_liquid = {
		interval = 0.25,
		max_stacks = 1,
		class_name = "interval_buff",
		keywords = {
			buff_keywords.burning
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
		interval_func = _scaled_damage_interval_function,
		minion_effects = {
			ailment_effect = ailment_effects.chem_burning,
			node_effects = {
				{
					node_name = "j_spine",
					vfx = {
						material_emission = true,
						particle_effect = "content/fx/particles/enemies/buff_burning_green",
						orphaned_policy = "destroy",
						stop_type = "stop"
					},
					sfx = {
						looping_wwise_stop_event = "wwise/events/weapon/stop_enemy_on_fire",
						looping_wwise_start_event = "wwise/events/weapon/play_enemy_on_fire"
					}
				}
			}
		}
	},
	renegade_flamer_in_fire_liquid = {
		interval = 0.25,
		max_stacks = 1,
		class_name = "interval_buff",
		keywords = {
			buff_keywords.burning
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
		interval_func = _scaled_damage_interval_function,
		minion_effects = {
			ailment_effect = ailment_effects.burning,
			node_effects = {
				{
					node_name = "j_spine",
					vfx = {
						material_emission = true,
						particle_effect = "content/fx/particles/enemies/buff_burning",
						orphaned_policy = "destroy",
						stop_type = "stop"
					},
					sfx = {
						looping_wwise_stop_event = "wwise/events/weapon/stop_enemy_on_fire",
						looping_wwise_start_event = "wwise/events/weapon/play_enemy_on_fire"
					}
				}
			}
		}
	}
}
local PLAYER_SLIDING_IN_SLIME_POWER_LEVEL_MULTIPLIER = 4
local BOT_POWER_LEVEL_MULTIPLIER = 0.25
local PLAYER_SLIDING_INTERVAL_OVERRIDE = 0.15

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
	interval = 0.5,
	max_stacks = 1,
	class_name = "interval_buff",
	keywords = {
		buff_keywords.zero_slide_friction
	},
	forbidden_keywords = {
		buff_keywords.beast_of_nurgle_liquid_immunity
	},
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = 0.6,
		[buff_stat_buffs.dodge_speed_multiplier] = 0.9
	},
	power_level = {
		default = {
			3,
			6,
			15,
			20,
			25
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
local cultist_flamer_leaving_liquid_fire_spread_increase = table.clone(templates.leaving_liquid_fire_spread_increase)
cultist_flamer_leaving_liquid_fire_spread_increase.forbidden_keywords = {
	buff_keywords.cultist_flamer_liquid_immunity
}
templates.cultist_flamer_leaving_liquid_fire_spread_increase = cultist_flamer_leaving_liquid_fire_spread_increase
cultist_flamer_leaving_liquid_fire_spread_increase.hud_priority = 1
cultist_flamer_leaving_liquid_fire_spread_increase.hud_icon = "content/ui/textures/icons/buffs/hud/states_knocked_down_buff_hud"
local renegade_flamer_leaving_liquid_fire_spread_increase = table.clone(templates.cultist_flamer_leaving_liquid_fire_spread_increase)
renegade_flamer_leaving_liquid_fire_spread_increase.forbidden_keywords = {
	buff_keywords.renegade_flamer_liquid_immunity
}
templates.renegade_flamer_leaving_liquid_fire_spread_increase = renegade_flamer_leaving_liquid_fire_spread_increase
local renegade_grenadier_leaving_liquid_fire_spread_increase = table.clone(templates.leaving_liquid_fire_spread_increase)
renegade_grenadier_leaving_liquid_fire_spread_increase.hud_priority = 1
renegade_grenadier_leaving_liquid_fire_spread_increase.hud_icon = "content/ui/textures/icons/buffs/hud/states_knocked_down_buff_hud"
renegade_grenadier_leaving_liquid_fire_spread_increase.forbidden_keywords = {
	buff_keywords.renegade_grenadier_liquid_immunity
}
templates.renegade_grenadier_leaving_liquid_fire_spread_increase = renegade_grenadier_leaving_liquid_fire_spread_increase

return templates
