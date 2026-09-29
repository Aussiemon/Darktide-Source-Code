-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_legendary_buff_templates/hordes_legendary_cryptic_buff_templates.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local buff_categories = BuffSettings.buff_categories
local buff_keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.hordes_buff_cryptic_discharge_ability_always_full_charges_bonus = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.cryptic_discharge_ability_always_full_charges_bonus
	}
}
templates.hordes_buff_cryptic_chordclaw_kills_replenish_charge = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.cryptic_chordclaw_kill_restores_charge
	}
}
templates.hordes_buff_cryptic_precision_stance_duration_extension_on_kill = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.cryptic_precision_stance_duration_extension_on_elite_hit
	}
}
templates.hordes_buff_cryptic_force_field_leaves_fire_liquid_area = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.cryptic_force_field_liquid_area_when_expired
	}
}
templates.hordes_buff_cryptic_servo_skull_flamethrower_uses_no_charge = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.cryptic_servo_skull_flamethrower_uses_no_charge
	}
}

local arc_grenade_extra_arcs = HordesBuffsData.hordes_buff_cryptic_arc_grenade_extra_arcs.buff_stats.extra_arcs.value

templates.hordes_buff_cryptic_arc_grenade_extra_arcs = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.arc_grenade_extra_arcs] = 2
	}
}

local dodges_cooldown_percent_cost = HordesBuffsData.hordes_buff_cryptic_dodge_costs_cooldown.buff_stats.cooldown_percent_cost.value

templates.hordes_buff_cryptic_dodge_costs_cooldown = {
	class_name = "proc_buff",
	force_predicted_proc = true,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.free_dodges
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
	end,
	proc_events = {
		[proc_events.on_dodge_start] = 1
	},
	proc_func = function (params, template_data, template_context, t)
		template_data.ability_extension:consume_ability_resource_percentage("combat_ability", dodges_cooldown_percent_cost)
	end
}

return templates
