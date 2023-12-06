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
		keywords = {
			buff_keywords.empowered
		},
		stat_buffs = {
			[buff_stat_buffs.unarmored_damage] = -0.35,
			[buff_stat_buffs.resistant_damage] = -0.35,
			[buff_stat_buffs.disgustingly_resilient_damage] = -0.35,
			[buff_stat_buffs.berserker_damage] = -0.35,
			[buff_stat_buffs.armored_damage] = -0.35,
			[buff_stat_buffs.super_armor_damage] = -0.35,
			[buff_stat_buffs.consumed_hit_mass_modifier] = 10,
			[buff_stat_buffs.impact_modifier] = -1,
			[buff_stat_buffs.ranged_attack_speed] = 0.2,
			[buff_stat_buffs.minion_num_shots_modifier] = 2,
			[buff_stat_buffs.movement_speed] = 0.25
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
					0.358,
					0.786,
					0.22
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
		[buff_stat_buffs.ability_cooldown_modifier] = -0.2
	}
}
templates.mutator_movement_speed_on_spawn = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/states_sprint_buff_hud",
	duration = 30,
	target = buff_targets.player_only,
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = 1
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
local YELLOW_STIM_COLOR = {
	0.358,
	0.786,
	0.22
}
local RED_STIM_COLOR = {
	0.9,
	0,
	0.005
}
templates.empowered_poxwalker = {
	class_name = "buff",
	keywords = {
		buff_keywords.stimmed,
		buff_keywords.empowered
	},
	stat_buffs = {
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.35,
		[buff_stat_buffs.melee_attack_speed] = 0.5,
		[buff_stat_buffs.movement_speed] = 0.3500000000000001
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local hit_mass = breed.hit_mass

		if type(hit_mass) == "table" then
			hit_mass = Managers.state.difficulty:get_table_entry_by_challenge(hit_mass)
		end

		template_data.old_hit_mass = hit_mass
		local new_hit_mass = hit_mass * 2.5
		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:set_hit_mass(new_hit_mass)

		local variable_name = "anim_move_speed"

		if breed.animation_variable_init and breed.animation_variable_init[variable_name] then
			local animation_extension = ScriptUnit.extension(unit, "animation_system")

			animation_extension:set_variable(variable_name, 1.25)
		end
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:set_hit_mass(template_data.old_hit_mass)

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local variable_name = "anim_move_speed"

		if breed.animation_variable_init and breed.animation_variable_init[variable_name] then
			local animation_extension = ScriptUnit.extension(unit, "animation_system")

			animation_extension:set_variable(variable_name, 1)
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
							material_name = "eye_flash_init",
							value = YELLOW_STIM_COLOR
						},
						{
							variable_name = "trail_color",
							material_name = "eye_glow",
							value = YELLOW_STIM_COLOR
						},
						{
							variable_name = "material_variable_21872256",
							material_name = "eye_socket",
							value = YELLOW_STIM_COLOR
						}
					}
				}
			},
			{
				node_name = "j_lefteyesocket",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							variable_name = "material_variable_21872256",
							material_name = "eye_flash_init",
							value = YELLOW_STIM_COLOR
						},
						{
							variable_name = "trail_color",
							material_name = "eye_glow",
							value = YELLOW_STIM_COLOR
						},
						{
							variable_name = "material_variable_21872256",
							material_name = "eye_socket",
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
							material_name = "eye_flash_init",
							value = YELLOW_STIM_COLOR
						},
						{
							variable_name = "trail_color",
							material_name = "eye_glow",
							value = YELLOW_STIM_COLOR
						},
						{
							variable_name = "material_variable_21872256",
							material_name = "eye_socket",
							value = YELLOW_STIM_COLOR
						}
					}
				}
			}
		}
	}
}
templates.empowered_poxwalker_with_duration = table.clone(templates.empowered_poxwalker)
templates.empowered_poxwalker_with_duration.duration = 30
templates.empowered_twin = {
	class_name = "buff",
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.stimmed,
		buff_keywords.empowered
	},
	stat_buffs = {
		[buff_stat_buffs.weakspot_damage_taken] = 1,
		[buff_stat_buffs.unarmored_damage] = -0.3,
		[buff_stat_buffs.resistant_damage] = -0.5,
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.5,
		[buff_stat_buffs.berserker_damage] = -0.5,
		[buff_stat_buffs.armored_damage] = -0.5,
		[buff_stat_buffs.super_armor_damage] = -0.5,
		[buff_stat_buffs.impact_modifier] = -3,
		[buff_stat_buffs.ranged_attack_speed] = 0.5,
		[buff_stat_buffs.melee_attack_speed] = 0.5
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local hit_mass = breed.hit_mass

		if type(hit_mass) == "table" then
			hit_mass = Managers.state.difficulty:get_table_entry_by_challenge(hit_mass)
		end

		template_data.old_hit_mass = hit_mass
		local new_hit_mass = hit_mass * 3
		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:set_hit_mass(new_hit_mass)
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:set_hit_mass(template_data.old_hit_mass)
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_head",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/enrage_head_outline",
					stop_type = "destroy"
				}
			}
		}
	}
}

return templates
