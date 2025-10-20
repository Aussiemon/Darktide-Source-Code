-- chunkname: @scripts/settings/buff/mutator_buff_templates.lua

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SharedBuffFunctions = require("scripts/settings/buff/helper_functions/shared_buff_functions")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local RoamerSlotPlacementFunctions = require("scripts/settings/roamer/roamer_slot_placement_functions")
local Promise = require("scripts/foundation/utilities/promise")
local attack_types = AttackSettings.attack_types
local buff_keywords = BuffSettings.keywords
local buff_proc_events = BuffSettings.proc_events
local buff_targets = BuffSettings.targets
local buff_stat_buffs = BuffSettings.stat_buffs
local minion_effects_priorities = BuffSettings.minion_effects_priorities
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local templates = {}

table.make_unique(templates)

local nurgle_parasite_settings = {
	specific_head_gib_settings = {
		random_radius = 2,
		hit_zones = {
			"head",
		},
		damage_profile = DamageProfileTemplates.havoc_self_gib,
	},
}

local function _parasite_head_stop_function(template_data, template_context)
	local unit = template_context.unit
	local position = POSITION_LOOKUP[unit]
	local world, physics_world, impact_normal, charge_level, attack_type = template_context.world, template_context.physics_world, Vector3.up(), 1
	local explosion_template = ExplosionTemplates.nurgle_head_parasite

	Explosion.create_explosion(world, physics_world, position, impact_normal, unit, explosion_template, DEFAULT_POWER_LEVEL, charge_level, attack_type)

	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

	Attack.execute(unit, DamageProfileTemplates.default, "power_level", 2000, "attack_direction", Vector3.up(), "instakill", true)

	local unit_tags = template_context.breed.tags

	if not unit_tags.monster then
		local gib_settings = nurgle_parasite_settings.specific_head_gib_settings
		local damage_profile = gib_settings.damage_profile
		local random_radius = gib_settings.random_radius
		local hit_zones = gib_settings.hit_zones

		for i = 1, #hit_zones do
			local x = math.random() * 2 - 1
			local y = math.random() * 2 - 1
			local random_offset = Vector3(x * random_radius, y * random_radius, 1)
			local direction = Vector3.normalize(random_offset)
			local gib_hit_zone = hit_zones[i]

			if visual_loadout_extension:can_gib(gib_hit_zone) then
				visual_loadout_extension:gib(gib_hit_zone, direction, damage_profile)
			end
		end
	end
end

templates.headshot_parasite_enemies = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[buff_proc_events.on_minion_damage_taken] = 1,
	},
	keywords = {
		buff_keywords.infested_head_armor_override,
		buff_keywords.has_nurgle_parasite,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.health_extension = ScriptUnit.extension(template_context.unit, "health_system")

		if not template_context.is_server then
			return
		end

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local hit_mass = breed.hit_mass

		if type(hit_mass) == "table" then
			hit_mass = Managers.state.difficulty:get_table_entry_by_challenge(hit_mass)
		end

		template_data.old_hit_mass = hit_mass

		local new_hit_mass = hit_mass * 1.5
		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:set_hit_mass(new_hit_mass)

		local variable_name = "anim_move_speed"

		if breed.animation_variable_init and breed.animation_variable_init[variable_name] then
			local animation_extension = ScriptUnit.extension(unit, "animation_system")

			animation_extension:set_variable(variable_name, 1.25)
		end

		local suppression_extension = ScriptUnit.has_extension(unit, "suppression_system")

		if suppression_extension then
			suppression_extension:add_suppression_immunity_duration(999)
		end

		local attack_intensity_extension = ScriptUnit.has_extension(unit, "attack_intensity_system")

		if attack_intensity_extension then
			attack_intensity_extension:set_allow_all_attacks_duration(999)
		end
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local attack_type = params.attack_type

		if attack_type ~= "ranged" then
			return
		end

		local hit_zone = params.hit_zone_name_or_nil

		if hit_zone == "head" then
			local unit = template_context.unit
			local health_extension = ScriptUnit.extension(unit, "health_system")
			local current_health_percent = health_extension:current_health_percent()

			if current_health_percent <= 0.3 then
				_parasite_head_stop_function(template_data, template_context)
			end
		end
	end,
}
templates.mutator_minion_nurgle_blessing_tougher = {
	class_name = "buff",
	predicted = false,
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.empowered,
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
		[buff_stat_buffs.movement_speed] = 0.25,
	},
	minion_effects = {
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_nurgle_blessing",
					stop_type = "stop",
				},
			},
		},
		material_vector = {
			name = "stimmed_color",
			value = {
				0.358,
				0.786,
				0.22,
			},
			priority = minion_effects_priorities.mutators,
		},
	},
}

local CORRUPTION_DAMAGE_TYPE = "corruption"
local CORRUPTION_PERMANENT_POWER_LEVEL = {
	2,
	2,
	2,
	2,
	2,
}

templates.mutator_corruption_over_time = {
	class_name = "interval_buff",
	interval = 7,
	predicted = false,
	target = buff_targets.player_only,
	interval_func = function (template_data, template_context)
		local unit = template_context.unit

		if template_context.is_server and HEALTH_ALIVE[unit] then
			local power_level = Managers.state.difficulty:get_table_entry_by_challenge(CORRUPTION_PERMANENT_POWER_LEVEL)
			local damage_profile = DamageProfileTemplates.mutator_corruption

			Attack.execute(unit, damage_profile, "power_level", power_level, "damage_type", CORRUPTION_DAMAGE_TYPE, "attack_type", attack_types.buff)
		end
	end,
}

local CORRUPTION_PERMANENT_POWER_LEVEL_2 = {
	5,
	8,
	10,
	12,
	15,
}

templates.mutator_corruption_over_time_2 = {
	class_name = "interval_buff",
	interval = 7,
	predicted = false,
	target = buff_targets.player_only,
	interval_func = function (template_data, template_context)
		local unit = template_context.unit

		if template_context.is_server and HEALTH_ALIVE[unit] then
			local power_level = Managers.state.difficulty:get_table_entry_by_challenge(CORRUPTION_PERMANENT_POWER_LEVEL_2)
			local damage_profile = DamageProfileTemplates.mutator_corruption

			Attack.execute(unit, damage_profile, "power_level", power_level, "damage_type", CORRUPTION_DAMAGE_TYPE, "attack_type", attack_types.buff)
		end
	end,
}
templates.mutator_player_cooldown_reduction = {
	class_name = "buff",
	predicted = false,
	target = buff_targets.player_only,
	stat_buffs = {
		[buff_stat_buffs.ability_cooldown_modifier] = -0.2,
	},
}
templates.mutator_movement_speed_on_spawn = {
	class_name = "buff",
	duration = 30,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_sprint_buff_hud",
	predicted = false,
	target = buff_targets.player_only,
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = 1,
	},
	hud_priority = math.huge,
}
templates.mutator_player_enhanced_grenade_abilities = {
	class_name = "buff",
	predicted = false,
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
		[buff_stat_buffs.warp_charge_amount_smite] = 0.5,
	},
}

local BLUE_STIM_COLOR = {
	0,
	0.75,
	0.75,
}
local GREEN_STIM_COLOR = {
	0,
	0.75,
	0.005,
}
local RED_STIM_COLOR = {
	0.9,
	0,
	0.005,
}
local YELLOW_STIM_COLOR = {
	0.7843137254901961,
	0.8745098039215686,
	0.0784313725490196,
}
local PURPLE_STIM_COLOR = {
	0.75,
	0,
	0.75,
}

templates.mutator_stimmed_minion_blue = {
	class_name = "buff",
	predicted = false,
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.stimmed,
		buff_keywords.super_armor_override,
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

		local new_hit_mass = hit_mass * 2
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
	stat_buffs = {
		[buff_stat_buffs.unarmored_damage] = -0.8,
		[buff_stat_buffs.resistant_damage] = -0.8,
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.8,
		[buff_stat_buffs.berserker_damage] = -0.8,
		[buff_stat_buffs.armored_damage] = -0.6,
		[buff_stat_buffs.super_armor_damage] = -0.6,
		[buff_stat_buffs.impact_modifier] = -2,
	},
	minion_effects = {
		node_effects_priotity = minion_effects_priorities.mutators + 3,
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/buff_stimmed_speed",
					stop_type = "destroy",
				},
			},
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = BLUE_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = BLUE_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "material_variable_21872256_69bf7e2a",
							value = BLUE_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = BLUE_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = BLUE_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "material_variable_21872256_69bf7e2a",
							value = BLUE_STIM_COLOR,
						},
					},
				},
			},
		},
	},
}
templates.mutator_stimmed_minion_green = {
	class_name = "proc_buff",
	duration = 100,
	predicted = false,
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.stimmed,
	},
	stat_buffs = {
		[buff_stat_buffs.damage_taken_from_burning] = -0.5,
		[buff_stat_buffs.damage_taken_from_bleeding] = -0.5,
		[buff_stat_buffs.damage_taken_from_electrocution] = -0.5,
		[buff_stat_buffs.warp_damage] = -0.5,
		[buff_stat_buffs.impact_modifier] = -1,
	},
	proc_events = {
		[buff_proc_events.on_minion_damage_taken] = 1,
	},
	start_func = function (template_data, template_context)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		if not Managers.state.difficulty then
			return
		end

		local heal_multipliers = {
			0.5,
			0.6,
			0.7,
			0.8,
			1,
		}
		local heal_multiplier_scaled_by_challange = Managers.state.difficulty:get_table_entry_by_challenge(heal_multipliers)
		local unit = template_context.unit
		local health_extension = ScriptUnit.extension(unit, "health_system")
		local max_health = health_extension:max_health()

		template_data.health_pool = max_health * heal_multiplier_scaled_by_challange
	end,
	proc_func = function (params, template_data, template_context)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		if HEALTH_ALIVE[template_context.unit] then
			local unit = template_context.unit
			local health_pool = template_data.health_pool
			local damage_amount = params.damage_amount

			if health_pool > 0 then
				local heal_amount = math.min(health_pool, damage_amount)
				local health_extension = ScriptUnit.extension(unit, "health_system")

				health_extension:add_heal(heal_amount)

				template_data.health_pool = template_data.health_pool - heal_amount
			end
		end
	end,
	conditional_exit_func = function (template_data, template_context)
		if template_data.health_pool == 0 then
			return true
		else
			return false
		end
	end,
	minion_effects = {
		node_effects_priotity = minion_effects_priorities.mutators + 3,
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/buff_stimmed_heal",
					stop_type = "destroy",
				},
			},
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = GREEN_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = GREEN_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "material_variable_21872256_69bf7e2a",
							value = GREEN_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = GREEN_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = GREEN_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "material_variable_21872256_69bf7e2a",
							value = GREEN_STIM_COLOR,
						},
					},
				},
			},
		},
	},
}
templates.mutator_stimmed_minion_red = {
	class_name = "buff",
	predicted = false,
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.stimmed,
	},
	stat_buffs = {
		[buff_stat_buffs.melee_attack_speed] = 0.4,
		[buff_stat_buffs.stagger_duration_multiplier] = 0.1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local attack_intensity_extension = ScriptUnit.has_extension(unit, "attack_intensity_system")

		if attack_intensity_extension then
			attack_intensity_extension:set_allow_all_attacks_duration(999)
		end
	end,
	stop_func = function (template_data, template_context)
		return
	end,
	conditional_exit_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return true
		end
	end,
	minion_effects = {
		node_effects_priotity = minion_effects_priorities.mutators + 3,
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/buff_stimmed_power",
					stop_type = "destroy",
				},
			},
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = RED_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = RED_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "material_variable_21872256_69bf7e2a",
							value = RED_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = RED_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = RED_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "material_variable_21872256_69bf7e2a",
							value = RED_STIM_COLOR,
						},
					},
				},
			},
		},
	},
}
templates.mutator_stimmed_minion_yellow = {
	class_name = "buff",
	predicted = false,
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.stimmed,
	},
	stat_buffs = {
		[buff_stat_buffs.weakspot_damage_taken] = 4,
		[buff_stat_buffs.unarmored_damage] = -0.35,
		[buff_stat_buffs.resistant_damage] = -0.35,
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.35,
		[buff_stat_buffs.berserker_damage] = -0.35,
		[buff_stat_buffs.armored_damage] = -0.35,
		[buff_stat_buffs.super_armor_damage] = -0.35,
		[buff_stat_buffs.impact_modifier] = -0.5,
		[buff_stat_buffs.ranged_attack_speed] = 0.3,
		[buff_stat_buffs.minion_num_shots_modifier] = 5,
		[buff_stat_buffs.melee_attack_speed] = 0.3,
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

		local new_hit_mass = hit_mass * 1.5
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
		node_effects_priotity = minion_effects_priorities.mutators + 3,
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/buff_stimmed_ability",
					stop_type = "destroy",
				},
			},
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "material_variable_21872256_69bf7e2a",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "material_variable_21872256_69bf7e2a",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
		},
	},
}
templates.ogryn_mutator_stimmed_minion_red = table.clone(templates.mutator_stimmed_minion_red)
templates.ogryn_mutator_stimmed_minion_red.minion_effects = {
	node_effects_priotity = minion_effects_priorities.mutators + 3,
	node_effects = {
		{
			node_name = "j_spine",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/buff_stimmed_ogryn_power",
				stop_type = "destroy",
			},
		},
		{
			node_name = "j_lefteye",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
				stop_type = "destroy",
				material_variables = {
					{
						material_name = "eye_socket",
						variable_name = "material_variable_21872256",
						value = RED_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "trail_color",
						value = RED_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "material_variable_21872256_69bf7e2a",
						value = RED_STIM_COLOR,
					},
				},
			},
		},
		{
			node_name = "j_righteye",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
				stop_type = "destroy",
				material_variables = {
					{
						material_name = "eye_socket",
						variable_name = "material_variable_21872256",
						value = RED_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "trail_color",
						value = RED_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "material_variable_21872256_69bf7e2a",
						value = RED_STIM_COLOR,
					},
				},
			},
		},
	},
}
templates.ogryn_mutator_stimmed_minion_green = table.clone(templates.mutator_stimmed_minion_green)
templates.ogryn_mutator_stimmed_minion_green.minion_effects = {
	node_effects_priotity = minion_effects_priorities.mutators + 3,
	node_effects = {
		{
			node_name = "j_spine",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/buff_stimmed_ogryn_heal",
				stop_type = "destroy",
			},
		},
		{
			node_name = "j_lefteye",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
				stop_type = "destroy",
				material_variables = {
					{
						material_name = "eye_socket",
						variable_name = "material_variable_21872256",
						value = GREEN_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "trail_color",
						value = GREEN_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "material_variable_21872256_69bf7e2a",
						value = GREEN_STIM_COLOR,
					},
				},
			},
		},
		{
			node_name = "j_righteye",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
				stop_type = "destroy",
				material_variables = {
					{
						material_name = "eye_socket",
						variable_name = "material_variable_21872256",
						value = GREEN_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "trail_color",
						value = GREEN_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "material_variable_21872256_69bf7e2a",
						value = GREEN_STIM_COLOR,
					},
				},
			},
		},
	},
}
templates.ogryn_mutator_stimmed_minion_blue = table.clone(templates.mutator_stimmed_minion_blue)
templates.ogryn_mutator_stimmed_minion_blue.minion_effects = {
	node_effects_priotity = minion_effects_priorities.mutators + 3,
	node_effects = {
		{
			node_name = "j_spine",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/buff_stimmed_ogryn_speed",
				stop_type = "destroy",
			},
		},
		{
			node_name = "j_lefteye",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
				stop_type = "destroy",
				material_variables = {
					{
						material_name = "eye_socket",
						variable_name = "material_variable_21872256",
						value = BLUE_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "trail_color",
						value = BLUE_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "material_variable_21872256_69bf7e2a",
						value = BLUE_STIM_COLOR,
					},
				},
			},
		},
		{
			node_name = "j_righteye",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
				stop_type = "destroy",
				material_variables = {
					{
						material_name = "eye_socket",
						variable_name = "material_variable_21872256",
						value = BLUE_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "trail_color",
						value = BLUE_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "material_variable_21872256_69bf7e2a",
						value = BLUE_STIM_COLOR,
					},
				},
			},
		},
	},
}
templates.ogryn_mutator_stimmed_minion_yellow = table.clone(templates.mutator_stimmed_minion_yellow)
templates.ogryn_mutator_stimmed_minion_yellow.minion_effects = {
	node_effects_priotity = minion_effects_priorities.mutators + 3,
	node_effects = {
		{
			node_name = "j_spine",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/buff_stimmed_ogryn_ability",
				stop_type = "destroy",
			},
		},
		{
			node_name = "j_lefteye",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
				stop_type = "destroy",
				material_variables = {
					{
						material_name = "eye_socket",
						variable_name = "material_variable_21872256",
						value = YELLOW_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "trail_color",
						value = YELLOW_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "material_variable_21872256_69bf7e2a",
						value = YELLOW_STIM_COLOR,
					},
				},
			},
		},
		{
			node_name = "j_righteye",
			vfx = {
				orphaned_policy = "stop",
				particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
				stop_type = "destroy",
				material_variables = {
					{
						material_name = "eye_socket",
						variable_name = "material_variable_21872256",
						value = YELLOW_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "trail_color",
						value = YELLOW_STIM_COLOR,
					},
					{
						material_name = "eye_glow",
						variable_name = "material_variable_21872256_69bf7e2a",
						value = YELLOW_STIM_COLOR,
					},
				},
			},
		},
	},
}

local TWIN_SPLIT_BREED_LIST = {
	chaos_beast_of_nurgle = "chaos_ogryn_bulwark",
	chaos_daemonhost = "chaos_spawn",
	chaos_hound = "chaos_hound_mutator",
	chaos_ogryn_bulwark = "renegade_berzerker",
	chaos_ogryn_executor = "renegade_executor",
	chaos_ogryn_gunner = "renegade_gunner",
	chaos_plague_ogryn = "chaos_ogryn_executor",
	chaos_poxwalker_bomber = "renegade_executor",
	chaos_spawn = "cultist_mutant",
	cultist_assault = "chaos_newly_infected",
	cultist_berzerker = "cultist_melee",
	cultist_flamer = "cultist_shocktrooper",
	cultist_grenadier = "renegade_gunner",
	cultist_gunner = "cultist_assault",
	cultist_melee = "chaos_poxwalker",
	cultist_mutant = "cultist_berzerker",
	cultist_shocktrooper = "cultist_assault",
	renegade_assault = "chaos_newly_infected",
	renegade_berzerker = "renegade_melee",
	renegade_captain = "chaos_daemonhost",
	renegade_executor = "renegade_melee",
	renegade_flamer = "renegade_shocktrooper",
	renegade_grenadier = "renegade_gunner",
	renegade_gunner = "renegade_rifleman",
	renegade_melee = "chaos_newly_infected",
	renegade_netgunner = "renegade_berzerker",
	renegade_rifleman = "chaos_newly_infected",
	renegade_shocktrooper = "renegade_assault",
	renegade_sniper = "renegade_gunner",
}

templates.mutator_stimmed_minion_purple = {
	class_name = "buff",
	predicted = false,
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.stimmed,
		buff_keywords.despawn_on_death,
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
						local world, physics_world = spawn_component.world, spawn_component.physics_world
						local impact_normal, charge_level, attack_type = Vector3.up(), 1
						local power_level = 0
						local explosion_template = ExplosionTemplates.purple_stimmed_explosion

						Explosion.create_explosion(world, physics_world, POSITION_LOOKUP[unit], impact_normal, unit, explosion_template, power_level, charge_level, attack_type)
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
		node_effects_priotity = minion_effects_priorities.mutators + 3,
		node_effects = {
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = PURPLE_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = PURPLE_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "material_variable_21872256_69bf7e2a",
							value = PURPLE_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = PURPLE_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = PURPLE_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "material_variable_21872256_69bf7e2a",
							value = PURPLE_STIM_COLOR,
						},
					},
				},
			},
		},
		material_vector = {
			name = "stimmed_color",
			value = PURPLE_STIM_COLOR,
			priority = minion_effects_priorities.mutators,
		},
	},
}

local YELLOW_STIM_COLOR = {
	0.358,
	0.786,
	0.22,
}
local RED_STIM_COLOR = {
	0.9,
	0,
	0.005,
}

templates.empowered_poxwalker = {
	class_name = "buff",
	predicted = false,
	keywords = {
		buff_keywords.stimmed,
		buff_keywords.empowered,
		buff_keywords.in_toxic_gas,
	},
	stat_buffs = {
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.2,
		[buff_stat_buffs.unarmored_damage] = -0.2,
		[buff_stat_buffs.resistant_damage] = -0.2,
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.2,
		[buff_stat_buffs.berserker_damage] = -0.2,
		[buff_stat_buffs.armored_damage] = -0.2,
		[buff_stat_buffs.super_armor_damage] = -0.2,
		[buff_stat_buffs.movement_speed] = 0.30000000000000004,
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
							material_name = "eye_flash_init",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_lefteyesocket",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_flash_init",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_flash_init",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
		},
	},
}
templates.empowered_poxwalker_with_duration = {
	class_name = "buff",
	duration = 6,
	predicted = false,
	keywords = {
		buff_keywords.stimmed,
		buff_keywords.empowered,
		buff_keywords.in_toxic_gas,
	},
	stat_buffs = {
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.2,
		[buff_stat_buffs.unarmored_damage] = -0.2,
		[buff_stat_buffs.resistant_damage] = -0.2,
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.2,
		[buff_stat_buffs.berserker_damage] = -0.2,
		[buff_stat_buffs.armored_damage] = -0.2,
		[buff_stat_buffs.super_armor_damage] = -0.2,
		[buff_stat_buffs.movement_speed] = 0.30000000000000004,
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
					particle_effect = "content/fx/particles/enemies/glowing_eyes_no_flash",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_lefteyesocket",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/glowing_eyes_no_flash",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/glowing_eyes_no_flash",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
		},
	},
}
templates.empowered_by_pox_gas = {
	class_name = "buff",
	predicted = false,
	keywords = {
		buff_keywords.stimmed,
		buff_keywords.empowered,
		buff_keywords.in_toxic_gas,
	},
	stat_buffs = {
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.2,
		[buff_stat_buffs.unarmored_damage] = -0.2,
		[buff_stat_buffs.resistant_damage] = -0.2,
		[buff_stat_buffs.disgustingly_resilient_damage] = -0.2,
		[buff_stat_buffs.berserker_damage] = -0.2,
		[buff_stat_buffs.armored_damage] = -0.2,
		[buff_stat_buffs.super_armor_damage] = -0.2,
		[buff_stat_buffs.movement_speed] = 0.30000000000000004,
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

		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

		if buff_extension then
			local t = Managers.time:time("gameplay")

			buff_extension:add_internally_controlled_buff("empowered_poxwalker_with_duration", t)
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
							material_name = "eye_flash_init",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_lefteyesocket",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_flash_init",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_flash_init",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
		},
	},
}
templates.empowered_twin = {
	class_name = "buff",
	predicted = false,
	target = buff_targets.minion_only,
	keywords = {
		buff_keywords.stimmed,
		buff_keywords.empowered,
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
		[buff_stat_buffs.melee_attack_speed] = 0.5,
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
					stop_type = "destroy",
				},
			},
		},
	},
}
templates.mutant_mutator = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.movement_speed] = 0.10000000000000009,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
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
							material_name = "eye_flash_init",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_flash_init",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = YELLOW_STIM_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = YELLOW_STIM_COLOR,
						},
					},
				},
			},
		},
	},
}
templates.drop_pickup_on_death = {
	class_name = "buff",
	predicted = false,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local position = Unit.world_position(unit, 1)
		local rotation = Unit.local_rotation(unit, 1)
		local pickup_system = Managers.state.extension:system("pickup_system")

		pickup_system:spawn_pickup("skulls_01_pickup", position, rotation, nil, nil, nil, nil, "skull_reward")
	end,
	conditional_exit_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return true
		end
	end,
}
templates.drop_stolen_rations_01_pickup_small_on_death = {
	class_name = "buff",
	predicted = false,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local position = Unit.world_position(unit, 1)
		local rotation = Unit.local_rotation(unit, 1)
		local pickup_system = Managers.state.extension:system("pickup_system")

		pickup_system:spawn_pickup("stolen_rations_01_pickup_small", position, rotation, nil, nil, nil, nil, "stolen_rations")
	end,
	conditional_exit_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return true
		end
	end,
}
templates.drop_stolen_rations_01_pickup_medium_on_death = {
	class_name = "buff",
	predicted = false,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local position = Unit.world_position(unit, 1)
		local rotation = Unit.local_rotation(unit, 1)
		local pickup_system = Managers.state.extension:system("pickup_system")

		pickup_system:spawn_pickup("stolen_rations_01_pickup_medium", position, rotation, nil, nil, nil, nil, "stolen_rations")
	end,
	conditional_exit_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return true
		end
	end,
}

local drop_stolen_rations_01_pickup_medium_many_on_death_placement_settings = {
	circle_radius = 0.75,
	num_slots = 2,
	position_offset = 0.2,
	randomize_rotation = true,
}

templates.drop_stolen_rations_01_pickup_medium_many_on_death = {
	class_name = "buff",
	predicted = false,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local base_position_boxed = Vector3Box(Unit.world_position(unit, 1))

		Promise.delay(0):next(function ()
			local pickup_system = Managers.state.extension:system("pickup_system")

			if not pickup_system then
				return
			end

			local nav_world = Managers.state.nav_mesh:nav_world()

			if not nav_world then
				return
			end

			local spawn_locations = RoamerSlotPlacementFunctions.circle_placement_guaranteed(nav_world, base_position_boxed, drop_stolen_rations_01_pickup_medium_many_on_death_placement_settings, nil)

			for i = 1, #spawn_locations do
				local spawn_location = spawn_locations[i].position:unbox()
				local spawn_rotation = spawn_locations[i].rotation:unbox()

				pickup_system:spawn_pickup("stolen_rations_01_pickup_medium", spawn_location, spawn_rotation, nil, nil, nil, nil, "stolen_rations")
			end
		end)
	end,
	conditional_exit_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return true
		end
	end,
}
templates.drop_shocktrooper_grenade_on_death = {
	class_name = "buff",
	predicted = false,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local position = Unit.world_position(unit, 1)
		local projectile_template = ProjectileTemplates.renegade_frag_grenade

		SharedBuffFunctions.spawn_grenade_at_position(nil, "villains", projectile_template.item_name, projectile_template, position, Vector3.down(), 0)
	end,
	conditional_exit_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return true
		end
	end,
}

return templates
