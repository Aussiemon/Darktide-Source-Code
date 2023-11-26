-- chunkname: @scripts/settings/buff/item_buff_templates.lua

local AilmentSettings = require("scripts/settings/ailments/ailment_settings")
local Attack = require("scripts/utilities/attack/attack")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local PlayerUnitAction = require("scripts/extension_systems/visual_loadout/utilities/player_unit_action")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local ailment_effects = AilmentSettings.effects
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local keywords = BuffSettings.keywords
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local PI = math.pi
local PI_2 = PI * 2
local templates = {}

templates.ranged_weakspot_damage = {
	class_name = "buff",
	keywords = {},
	stat_buffs = {
		[buff_stat_buffs.ranged_weakspot_damage] = 0.3
	}
}
templates.increased_suppression = {
	class_name = "buff",
	keywords = {},
	stat_buffs = {
		[buff_stat_buffs.increased_suppression] = 0.5
	}
}
templates.spread_reduction = {
	class_name = "buff",
	keywords = {},
	stat_buffs = {
		[buff_stat_buffs.spread_modifier] = -0.15
	}
}
templates.spread_and_sway_reduction = {
	class_name = "buff",
	keywords = {},
	stat_buffs = {
		[buff_stat_buffs.spread_modifier] = -0.15,
		[buff_stat_buffs.sway_modifier] = 0.7
	}
}
templates.recoil_reduction = {
	class_name = "buff",
	keywords = {},
	stat_buffs = {
		[buff_stat_buffs.recoil_modifier] = -0.3
	}
}
templates.alternate_fire_movement_speed = {
	class_name = "buff",
	keywords = {},
	stat_buffs = {
		[buff_stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.3
	}
}
templates.ranged_attack_speed = {
	class_name = "buff",
	keywords = {},
	stat_buffs = {
		[buff_stat_buffs.ranged_attack_speed] = 0.5
	}
}
templates.overheat_time = {
	class_name = "buff",
	keywords = {},
	stat_buffs = {
		[buff_stat_buffs.charge_up_time] = -0.5
	}
}
templates.reduced_overheat = {
	class_name = "buff",
	keywords = {},
	stat_buffs = {
		[buff_stat_buffs.overheat_amount] = -0.5
	}
}
templates.braced_damage_reduction = {
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
}
templates.shock_grenade_interval = {
	start_interval_on_apply = true,
	buff_id = "shock_grenade_shock",
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks_cap = 1,
	duration = 6,
	start_with_frame_offset = true,
	class_name = "interval_buff",
	keywords = {
		keywords.electrocuted,
		keywords.shock_grenade_shock
	},
	interval = {
		0.3,
		0.8
	},
	interval_func = function (template_data, template_context, template, dt, t)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.shock_grenade_stun_interval
			local owner_unit = template_context.owner_unit
			local power_level = DEFAULT_POWER_LEVEL
			local random_radians = math.random_range(0, PI_2)
			local attack_direction = Vector3(math.sin(random_radians), math.cos(random_radians), 0)

			attack_direction = Vector3.normalize(attack_direction)

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.electrocution, "attacking_unit", HEALTH_ALIVE[owner_unit] and owner_unit, "attack_direction", attack_direction)
		end
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					material_emission = false,
					particle_effect = "content/fx/particles/enemies/buff_stummed",
					orphaned_policy = "destroy",
					stop_type = "stop"
				}
			}
		}
	}
}

return templates
