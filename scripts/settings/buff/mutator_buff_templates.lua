local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local Health = require("scripts/utilities/health")
local attack_types = AttackSettings.attack_types
local buff_keywords = BuffSettings.keywords
local buff_proc_events = BuffSettings.proc_events
local buff_targets = BuffSettings.targets
local buff_stat_buffs = BuffSettings.stat_buffs
local templates = {
	mutator_minion_nurgle_blessing_tougher = {
		class_name = "buff",
		target = buff_targets.minion_only,
		stat_buffs = {
			[buff_stat_buffs.unarmored_damage] = -0.5,
			[buff_stat_buffs.resistant_damage] = -0.5,
			[buff_stat_buffs.disgustingly_resilient_damage] = -0.5,
			[buff_stat_buffs.berserker_damage] = -0.5,
			[buff_stat_buffs.armored_damage] = -0.5,
			[buff_stat_buffs.super_armor_damage] = -0.75,
			[buff_stat_buffs.consumed_hit_mass_modifier] = 10,
			[buff_stat_buffs.impact_modifier] = -1
		},
		minion_effects = {
			node_effects = {
				{
					node_name = "j_spine",
					vfx = {
						orphaned_policy = "destroy",
						particle_effect = "content/fx/particles/enemies/buff_nurgle_blessing",
						stop_type = "stop"
					}
				}
			},
			material_vector = {
				name = "stimmed_color",
				value = {
					0.1,
					0.3,
					0.1
				}
			}
		}
	}
}
local CORRUPTION_DAMAGE_TYPE = "corruption"
local CORRUPTION_PERMANENT_POWER_LEVEL = {
	2,
	2,
	2,
	2,
	2
}
templates.mutator_corruption_over_time = {
	interval = 7,
	class_name = "interval_buff",
	target = buff_targets.player_only,
	interval_func = function (template_data, template_context)
		local unit = template_context.unit

		if template_context.is_server and HEALTH_ALIVE[unit] then
			local power_level = Managers.state.difficulty:get_table_entry_by_challenge(CORRUPTION_PERMANENT_POWER_LEVEL)
			local damage_profile = DamageProfileTemplates.mutator_corruption

			Attack.execute(unit, damage_profile, "power_level", power_level, "damage_type", CORRUPTION_DAMAGE_TYPE, "attack_type", attack_types.buff)
		end
	end
}
local CORRUPTION_PERMANENT_POWER_LEVEL_2 = {
	5,
	8,
	10,
	12,
	15
}
templates.mutator_corruption_over_time_2 = {
	interval = 7,
	class_name = "interval_buff",
	target = buff_targets.player_only,
	interval_func = function (template_data, template_context)
		local unit = template_context.unit

		if template_context.is_server and HEALTH_ALIVE[unit] then
			local power_level = Managers.state.difficulty:get_table_entry_by_challenge(CORRUPTION_PERMANENT_POWER_LEVEL_2)
			local damage_profile = DamageProfileTemplates.mutator_corruption

			Attack.execute(unit, damage_profile, "power_level", power_level, "damage_type", CORRUPTION_DAMAGE_TYPE, "attack_type", attack_types.buff)
		end
	end
}
templates.mutator_player_cooldown_reduction = {
	class_name = "buff",
	target = buff_targets.player_only,
	stat_buffs = {
		[buff_stat_buffs.ability_cooldown_modifier] = -0.5
	}
}
templates.mutator_movement_speed_on_spawn = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/states_sprint_buff_hud",
	duration = 30,
	target = buff_targets.player_only,
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = 2
	},
	hud_priority = math.huge
}
templates.mutator_player_enhanced_grenade_abilities = {
	class_name = "buff",
	target = buff_targets.player_only,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local template = template_context.template
		local stat_buffs = template.stat_buffs.extra_max_amount_of_grenades
		local extra_grenades = stat_buffs
		local grenade_ability_component = unit_data_extension:write_component("grenade_ability")
		template_context.initial_num_charges = grenade_ability_component.num_charges
		grenade_ability_component.num_charges = grenade_ability_component.num_charges + extra_grenades
	end,
	stop_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local grenade_ability_component = unit_data_extension:write_component("grenade_ability")
		local initial_num_charges = template_context.initial_num_charges
		grenade_ability_component.num_charges = math.min(grenade_ability_component.num_charges, initial_num_charges)
	end,
	stat_buffs = {
		[buff_stat_buffs.extra_max_amount_of_grenades] = 2,
		[buff_stat_buffs.warp_charge_amount_smite] = 0.5
	}
}
local BLUE_STIM_COLOR = {
	0,
	0.75,
	0.75
}
local GREEN_STIM_COLOR = {
	0,
	0.75,
	0.005
}
local RED_STIM_COLOR = {
	0.9,
	0,
	0.005
}
local YELLOW_STIM_COLOR = {
	0.358,
	0.786,
	0.22
}
local PURPLE_STIM_COLOR = {
	0.75,
	0,
	0.75
}
templates.mutator_stimmed_minion_blue = {
	class_name = "buff",
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.stimmed,
		buff_keywords.super_armor_override
	},
	stat_buffs = {
		[buff_stat_buffs.unarmored_damage] = -0.8,
		[buff_stat_buffs.resistant_damage] = -0.8,
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.8,
		[buff_stat_buffs.berserker_damage] = -0.8,
		[buff_stat_buffs.armored_damage] = -0.6,
		[buff_stat_buffs.super_armor_damage] = -0.6,
		[buff_stat_buffs.consumed_hit_mass_modifier] = 10,
		[buff_stat_buffs.impact_modifier] = -2
	},
	minion_effects = {
		node_effects = {
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							variable_name = "material_variable_21872256",
							material_name = "eye_socket",
							value = BLUE_STIM_COLOR
						},
						{
							variable_name = "trail_color",
							material_name = "eye_glow",
							value = BLUE_STIM_COLOR
						},
						{
							variable_name = "material_variable_21872256_69bf7e2a",
							material_name = "eye_glow",
							value = BLUE_STIM_COLOR
						}
					}
				}
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							variable_name = "material_variable_21872256",
							material_name = "eye_socket",
							value = BLUE_STIM_COLOR
						},
						{
							variable_name = "trail_color",
							material_name = "eye_glow",
							value = BLUE_STIM_COLOR
						},
						{
							variable_name = "material_variable_21872256_69bf7e2a",
							material_name = "eye_glow",
							value = BLUE_STIM_COLOR
						}
					}
				}
			}
		},
		material_vector = {
			name = "stimmed_color",
			value = BLUE_STIM_COLOR
		}
	}
}
templates.mutator_stimmed_minion_green = {
	class_name = "proc_buff",
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.stimmed
	},
	proc_events = {
		[buff_proc_events.on_hit] = 1
	},
	proc_func = function (params, template_data, template_context)
		local attacked_unit = params.attacked_unit

		if ALIVE[attacked_unit] and Breed.is_player(ScriptUnit.extension(attacked_unit, "unit_data_system"):breed()) and params.attack_type == "melee" then
			local damage = params.damage
			local power_level = nil

			if damage == 0 then
				power_level = 500
			else
				power_level = 100 + params.damage * 20
			end

			local attacking_unit = template_context.unit
			local position = POSITION_LOOKUP[attacking_unit]
			local attack_direction = Vector3.normalize(POSITION_LOOKUP[attacked_unit] - position)
			local damage_profile = DamageProfileTemplates.mutator_green_corruption

			Attack.execute(attacked_unit, damage_profile, "power_level", power_level, "attacking_unit", attacking_unit, "attack_direction", attack_direction, "hit_zone_name", "torso", "damage_type", CORRUPTION_DAMAGE_TYPE)
		end
	end,
	stat_buffs = {
		[buff_stat_buffs.impact_modifier] = -1
	},
	minion_effects = {
		node_effects = {
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							variable_name = "material_variable_21872256",
							material_name = "eye_socket",
							value = GREEN_STIM_COLOR
						},
						{
							variable_name = "trail_color",
							material_name = "eye_glow",
							value = GREEN_STIM_COLOR
						},
						{
							variable_name = "material_variable_21872256_69bf7e2a",
							material_name = "eye_glow",
							value = GREEN_STIM_COLOR
						}
					}
				}
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							variable_name = "material_variable_21872256",
							material_name = "eye_socket",
							value = GREEN_STIM_COLOR
						},
						{
							variable_name = "trail_color",
							material_name = "eye_glow",
							value = GREEN_STIM_COLOR
						},
						{
							variable_name = "material_variable_21872256_69bf7e2a",
							material_name = "eye_glow",
							value = GREEN_STIM_COLOR
						}
					}
				}
			}
		},
		material_vector = {
			name = "stimmed_color",
			value = GREEN_STIM_COLOR
		}
	}
}
templates.mutator_stimmed_minion_red = {
	class_name = "buff",
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.stimmed,
		buff_keywords.despawn_on_death
	},
	start_func = function (template_data, template_context)
		return
	end,
	stop_func = function (template_data, template_context)
		local unit = template_context.unit
		local blackboard = BLACKBOARDS[unit]

		if blackboard and Vector3.is_valid(POSITION_LOOKUP[unit]) then
			local explode_position_node_name = "j_spine"
			local position = Unit.world_position(unit, Unit.node(unit, explode_position_node_name)) + Vector3(0, 0, 0.0025)
			local spawn_component = blackboard.spawn
			local world = spawn_component.world
			local physics_world = spawn_component.physics_world
			local impact_normal = Vector3.up()
			local charge_level = 1
			local attack_type = nil
			local power_level = 25
			local explosion_template = ExplosionTemplates.poxwalker_bomber

			Explosion.create_explosion(world, physics_world, position, impact_normal, unit, explosion_template, power_level, charge_level, attack_type)
		end
	end,
	conditional_exit_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return true
		end
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							variable_name = "material_variable_21872256",
							material_name = "eye_socket",
							value = RED_STIM_COLOR
						},
						{
							variable_name = "trail_color",
							material_name = "eye_glow",
							value = RED_STIM_COLOR
						},
						{
							variable_name = "material_variable_21872256_69bf7e2a",
							material_name = "eye_glow",
							value = RED_STIM_COLOR
						}
					}
				}
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							variable_name = "material_variable_21872256",
							material_name = "eye_socket",
							value = RED_STIM_COLOR
						},
						{
							variable_name = "trail_color",
							material_name = "eye_glow",
							value = RED_STIM_COLOR
						},
						{
							variable_name = "material_variable_21872256_69bf7e2a",
							material_name = "eye_glow",
							value = RED_STIM_COLOR
						}
					}
				}
			}
		},
		material_vector = {
			name = "stimmed_color",
			value = RED_STIM_COLOR
		}
	}
}
templates.mutator_stimmed_minion_yellow = {
	class_name = "proc_buff",
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.stimmed
	},
	stat_buffs = {
		[buff_stat_buffs.unarmored_damage] = -0.4,
		[buff_stat_buffs.resistant_damage] = -0.4,
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.4,
		[buff_stat_buffs.berserker_damage] = -0.4,
		[buff_stat_buffs.armored_damage] = -0.4,
		[buff_stat_buffs.super_armor_damage] = -0.4,
		[buff_stat_buffs.consumed_hit_mass_modifier] = 8,
		[buff_stat_buffs.impact_modifier] = -1,
		[buff_stat_buffs.ranged_attack_speed] = 0.3,
		[buff_stat_buffs.minion_num_shots_modifier] = 5
	},
	proc_events = {
		[buff_proc_events.on_hit] = 1
	},
	proc_func = function (params, template_data, template_context)
		local attacked_unit = params.attacked_unit

		if ALIVE[attacked_unit] and Breed.is_player(ScriptUnit.extension(attacked_unit, "unit_data_system"):breed()) and params.attack_type == "melee" then
			-- Nothing
		end
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							variable_name = "material_variable_21872256",
							material_name = "eye_socket",
							value = YELLOW_STIM_COLOR
						},
						{
							variable_name = "trail_color",
							material_name = "eye_glow",
							value = YELLOW_STIM_COLOR
						},
						{
							variable_name = "material_variable_21872256_69bf7e2a",
							material_name = "eye_glow",
							value = YELLOW_STIM_COLOR
						}
					}
				}
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							variable_name = "material_variable_21872256",
							material_name = "eye_socket",
							value = YELLOW_STIM_COLOR
						},
						{
							variable_name = "trail_color",
							material_name = "eye_glow",
							value = YELLOW_STIM_COLOR
						},
						{
							variable_name = "material_variable_21872256_69bf7e2a",
							material_name = "eye_glow",
							value = YELLOW_STIM_COLOR
						}
					}
				}
			}
		},
		material_vector = {
			name = "stimmed_color",
			value = YELLOW_STIM_COLOR
		}
	}
}
local TWIN_SPLIT_BREED_LIST = {
	renegade_flamer = "renegade_shocktrooper",
	chaos_hound = "chaos_hound_mutator",
	renegade_assault = "chaos_newly_infected",
	renegade_rifleman = "chaos_newly_infected",
	cultist_mutant = "cultist_berzerker",
	cultist_assault = "chaos_newly_infected",
	chaos_daemonhost = "chaos_spawn",
	chaos_plague_ogryn = "chaos_ogryn_executor",
	cultist_melee = "chaos_poxwalker",
	chaos_poxwalker_bomber = "renegade_executor",
	chaos_ogryn_executor = "renegade_executor",
	cultist_shocktrooper = "cultist_assault",
	chaos_ogryn_gunner = "renegade_gunner",
	renegade_berzerker = "renegade_melee",
	renegade_netgunner = "renegade_berzerker",
	renegade_sniper = "renegade_gunner",
	chaos_beast_of_nurgle = "chaos_ogryn_bulwark",
	renegade_shocktrooper = "renegade_assault",
	renegade_gunner = "renegade_rifleman",
	renegade_grenadier = "renegade_gunner",
	cultist_berzerker = "cultist_melee",
	cultist_grenadier = "renegade_gunner",
	renegade_captain = "chaos_daemonhost",
	chaos_spawn = "cultist_mutant",
	chaos_ogryn_bulwark = "renegade_berzerker",
	cultist_gunner = "cultist_assault",
	renegade_melee = "chaos_newly_infected",
	renegade_executor = "renegade_melee",
	cultist_flamer = "cultist_shocktrooper"
}
templates.mutator_stimmed_minion_purple = {
	class_name = "buff",
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.stimmed,
		buff_keywords.despawn_on_death
	},
	start_func = function (template_data, template_context)
		return
	end,
	stop_func = function (template_data, template_context)
		local unit = template_context.unit
		local blackboard = BLACKBOARDS[unit]

		if blackboard then
			local breed_name = ScriptUnit.extension(unit, "unit_data_system"):breed_name()
			local split_breed_name = TWIN_SPLIT_BREED_LIST[breed_name]

			if split_breed_name then
				for i = 1, 2 do
					local position = Unit.world_position(unit, 1)
					local rotation = Unit.local_rotation(unit, 1)
					local right = Quaternion.right(Unit.local_rotation(unit, 1))

					if i % 2 == 0 then
						position = position + right
					else
						position = position + -right
					end

					local perception_component = blackboard.perception

					if ALIVE[perception_component.target_unit] then
						local mutator_manager = Managers.state.mutator
						local purple_stimmed_mutator = mutator_manager:mutator("mutator_stimmed_minions_purple")
						local buff_to_add = TWIN_SPLIT_BREED_LIST[split_breed_name] and "mutator_stimmed_minion_purple" or nil

						purple_stimmed_mutator:add_split_spawn(position, rotation, split_breed_name, buff_to_add, perception_component.target_unit)

						local spawn_component = blackboard.spawn
						local world = spawn_component.world
						local physics_world = spawn_component.physics_world
						local impact_normal = Vector3.up()
						local charge_level = 1
						local attack_type = nil
						local power_level = 0
						local explosion_template = ExplosionTemplates.purple_stimmed_explosion

						Explosion.create_explosion(world, physics_world, POSITION_LOOKUP[unit], impact_normal, unit, explosion_template, power_level, charge_level, attack_type)

						local minion_death_manager = Managers.state.minion_death
						local minion_ragdoll = minion_death_manager:minion_ragdoll()

						minion_ragdoll:remove_ragdoll_safe(unit)
					end
				end
			end
		end
	end,
	conditional_exit_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return true
		end
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							variable_name = "material_variable_21872256",
							material_name = "eye_socket",
							value = PURPLE_STIM_COLOR
						},
						{
							variable_name = "trail_color",
							material_name = "eye_glow",
							value = PURPLE_STIM_COLOR
						},
						{
							variable_name = "material_variable_21872256_69bf7e2a",
							material_name = "eye_glow",
							value = PURPLE_STIM_COLOR
						}
					}
				}
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							variable_name = "material_variable_21872256",
							material_name = "eye_socket",
							value = PURPLE_STIM_COLOR
						},
						{
							variable_name = "trail_color",
							material_name = "eye_glow",
							value = PURPLE_STIM_COLOR
						},
						{
							variable_name = "material_variable_21872256_69bf7e2a",
							material_name = "eye_glow",
							value = PURPLE_STIM_COLOR
						}
					}
				}
			}
		},
		material_vector = {
			name = "stimmed_color",
			value = PURPLE_STIM_COLOR
		}
	}
}

return templates
