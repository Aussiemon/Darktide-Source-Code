local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local Health = require("scripts/utilities/health")
local buff_keywords = BuffSettings.keywords
local buff_targets = BuffSettings.targets
local buff_stat_buffs = BuffSettings.stat_buffs
local templates = {
	mutator_minion_nurgle_blessing_tougher = {
		class_name = "buff",
		target = buff_targets.minion_only,
		stat_buffs = {
			[buff_stat_buffs.unarmored_damage] = -0.5,
			[buff_stat_buffs.armored_damage] = -0.5,
			[buff_stat_buffs.resistant_damage] = -0.5,
			[buff_stat_buffs.berserker_damage] = -0.5,
			[buff_stat_buffs.super_armor_damage] = -0.5,
			[buff_stat_buffs.disgustingly_resilient_damage] = -0.5
		},
		keywords = {
			buff_keywords.melee_push_immune,
			buff_keywords.ranged_push_immune,
			buff_keywords.stun_immune
		},
		minion_effects = {
			node_effects = {
				{
					node_name = "j_spine",
					vfx = {
						particle_effect = "content/fx/particles/enemies/plague_ogryn_flies"
					}
				}
			}
		}
	},
	mutator_minion_nurgle_blessing_heal_over_time = {
		interval = 1,
		class_name = "interval_buff",
		target = buff_targets.minion_only,
		interval_function = function (template_data, template_context)
			local unit = template_context.unit

			if template_context.is_server and HEALTH_ALIVE[unit] then
				local health_to_recover = 15
				local heal_type = DamageSettings.heal_types.heal_over_time_tick
				local health_added = Health.add(unit, health_to_recover, heal_type)

				if health_added > 0 then
					Health.play_fx(unit)
				end
			end
		end
	}
}

return templates
