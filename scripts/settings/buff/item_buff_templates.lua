-- chunkname: @scripts/settings/buff/item_buff_templates.lua

local Attack = require("scripts/utilities/attack/attack")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local PlayerUnitAction = require("scripts/extension_systems/visual_loadout/utilities/player_unit_action")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local buff_stat_buffs = BuffSettings.stat_buffs
local damage_types = DamageSettings.damage_types
local keywords = BuffSettings.keywords
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local PI = math.pi
local PI_2 = PI * 2
local templates = {}

table.make_unique(templates)

templates.ranged_weakspot_damage = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.ranged_weakspot_damage] = 0.3,
	},
}
templates.increased_suppression = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.increased_suppression] = 0.5,
	},
}
templates.spread_reduction = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.spread_modifier] = -0.15,
	},
}
templates.spread_and_sway_reduction = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.spread_modifier] = -0.15,
		[buff_stat_buffs.sway_modifier] = 0.7,
	},
}
templates.recoil_reduction = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.recoil_modifier] = -0.3,
	},
}
templates.alternate_fire_movement_speed = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.3,
	},
}
templates.ranged_attack_speed = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.ranged_attack_speed] = 0.5,
	},
}
templates.overheat_time = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.charge_up_time] = -0.5,
	},
}
templates.reduced_overheat = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.overheat_amount] = -0.5,
	},
}
templates.braced_damage_reduction = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[buff_stat_buffs.damage] = -0.1,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local weapon_component = unit_data_extension:read_component("weapon_action")
		local braced = PlayerUnitAction.has_current_action_keyword(weapon_component, "braced")

		return braced
	end,
}

return templates
