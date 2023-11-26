-- chunkname: @scripts/settings/buff/mutator_buff_templates.lua

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
local templates = {}

templates.mutator_minion_nurgle_blessing_tougher = {
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

return templates
