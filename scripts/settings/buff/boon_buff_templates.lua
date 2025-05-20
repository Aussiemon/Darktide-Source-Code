-- chunkname: @scripts/settings/buff/boon_buff_templates.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local meta_stat_buffs = BuffSettings.meta_stat_buffs
local templates = {}

table.make_unique(templates)

templates.boon_mission_xp_increase = {
	meta_buff = true,
	predicted = false,
	meta_stat_buffs = {
		[meta_stat_buffs.mission_reward_xp_modifier] = 0.2,
	},
}
templates.boon_mission_credits_increase = {
	meta_buff = true,
	predicted = false,
	meta_stat_buffs = {
		[meta_stat_buffs.mission_reward_credit_modifier] = 0.2,
	},
}
templates.boon_mission_drop_chance_increase = {
	meta_buff = true,
	predicted = false,
	meta_stat_buffs = {
		[meta_stat_buffs.mission_reward_drop_chance_modifier] = 0.2,
	},
}
templates.boon_mission_weapon_drop_rarity_increase = {
	meta_buff = true,
	predicted = false,
	meta_stat_buffs = {
		[meta_stat_buffs.mission_reward_weapon_drop_rarity_modifier] = 0.2,
	},
}
templates.boon_increase_max_grenades = {
	class_name = "buff",
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local template = template_context.template
		local buff_stat_buffs = template.stat_buffs.extra_max_amount_of_grenades
		local extra_grenades = buff_stat_buffs
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
		[stat_buffs.extra_max_amount_of_grenades] = 2,
	},
}
templates.boon_increase_wounds = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.extra_max_amount_of_wounds] = 1,
	},
}

return templates
