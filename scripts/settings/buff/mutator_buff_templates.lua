local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local Health = require("scripts/utilities/health")
local attack_types = AttackSettings.attack_types
local buff_keywords = BuffSettings.keywords
local buff_targets = BuffSettings.targets
local buff_stat_buffs = BuffSettings.stat_buffs
local templates = {
	mutator_minion_nurgle_blessing_tougher = {
		class_name = "buff",
		target = buff_targets.minion_only,
		stat_buffs = {
			[buff_stat_buffs.unarmored_damage] = -0.25,
			[buff_stat_buffs.resistant_damage] = -0.25,
			[buff_stat_buffs.disgustingly_resilient_damage] = -0.5,
			[buff_stat_buffs.berserker_damage] = -0.5,
			[buff_stat_buffs.armored_damage] = -0.25,
			[buff_stat_buffs.super_armor_damage] = -0.25
		}
	},
	mutator_minion_nurgle_blessing_heal_over_time = {
		class_name = "interval_buff",
		interval = 0.5,
		target = buff_targets.minion_only,
		interval_func = function (template_data, template_context)
			local unit = template_context.unit

			if template_context.is_server and HEALTH_ALIVE[unit] then
				local damage_taken = Health.damage_taken(unit)
				local t = Managers.time:time("gameplay")

				if not template_data.old_damage_taken or damage_taken ~= template_data.old_damage_taken then
					template_data.old_damage_taken = damage_taken
					template_data.next_heal_at = t + 5
				end

				if template_data.next_heal_at and template_data.next_heal_at <= t then
					local health_to_recover = 100
					local heal_type = DamageSettings.heal_types.heal_over_time_tick
					local health_added = Health.add(unit, health_to_recover, heal_type)
				end
			end
		end,
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

return templates
