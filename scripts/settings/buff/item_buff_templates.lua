local AilmentSettings = require("scripts/settings/ailments/ailment_settings")
local Attack = require("scripts/utilities/attack/attack")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local PlayerUnitAction = require("scripts/extension_systems/visual_loadout/utilities/player_unit_action")
local ailment_effects = AilmentSettings.effects
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local keywords = BuffSettings.keywords
local DEFUALT_POWER_LEVEL = 500
local templates = {
	ranged_weakspot_damage = {
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.ranged_weakspot_damage] = 0.3
		}
	},
	increased_suppression = {
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.increased_suppression] = 0.5
		}
	},
	spread_reduction = {
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.spread_modifier] = -0.15
		}
	},
	spread_and_sway_reduction = {
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.spread_modifier] = -0.15,
			[buff_stat_buffs.sway_modifier] = 0.7
		}
	},
	recoil_reduction = {
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.recoil_modifier] = -0.3
		}
	},
	alternate_fire_movement_speed = {
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.3
		}
	},
	ranged_attack_speed = {
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.ranged_attack_speed] = 0.5
		}
	},
	overheat_time = {
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.charge_up_time] = -0.5
		}
	},
	reduced_overheat = {
		class_name = "buff",
		keywords = {},
		stat_buffs = {
			[buff_stat_buffs.overheat_amount] = -0.5
		}
	},
	braced_damage_reduction = {
		class_name = "buff",
		conditional_stat_buffs = {
			[buff_stat_buffs.damage] = -0.1
		},
		conditional_stat_buffs_func = function (template_data, template_context)
			local unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local weapon_component = unit_data_extension:read_component("weapon_action")
			local braced = PlayerUnitAction.has_current_action_keyword(weapon_component, "braced")

			return braced
		end
	},
	shock_grenade_interval = {
		max_stacks = 1,
		predicted = false,
		max_stacks_cap = 1,
		start_interval_on_apply = true,
		duration = 4,
		class_name = "interval_buff",
		keywords = {
			keywords.electrocuted
		},
		interval = {
			0.3,
			0.8
		},
		interval_function = function (template_data, template_context, template)
			local is_server = template_context.is_server

			if not is_server then
				return
			end

			local unit = template_context.unit

			if HEALTH_ALIVE[unit] then
				local damage_template = DamageProfileTemplates.psyker_protectorate_smite_interval
				local owner_unit = template_context.owner_unit
				local power_level = DEFUALT_POWER_LEVEL
				local attack_direction = nil
				local target_position = POSITION_LOOKUP[unit]
				local owner_position = owner_unit and POSITION_LOOKUP[owner_unit]

				if owner_position and target_position then
					attack_direction = Vector3.normalize(target_position - owner_position)
				end

				Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.electrocution, "attacking_unit", HEALTH_ALIVE[owner_unit] and owner_unit, "attack_direction", attack_direction)
			end
		end,
		minion_effects = {
			ailment_effect = ailment_effects.electrocution,
			node_effects = {
				{
					node_name = "j_spine",
					vfx = {
						material_emission = true,
						particle_effect = "content/fx/particles/enemies/buff_chainlightning",
						orphaned_policy = "destroy",
						stop_type = "stop"
					},
					sfx = {
						looping_wwise_stop_event = "wwise/events/weapon/stop_psyker_chain_lightning_hit",
						looping_wwise_start_event = "wwise/events/weapon/play_psyker_chain_lightning_hit"
					}
				}
			}
		}
	}
}

return templates
