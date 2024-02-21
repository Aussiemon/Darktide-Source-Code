local BuffSettings = require("scripts/settings/buff/buff_settings")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local buff_stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_ranged_warp_charge_wield_increased_vent_speed = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.vent_warp_charge_speed] = 0.9
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		return true
	end
}
templates.weapon_trait_ranged_warp_charge_wield_reduced_vent_damage_taken = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.vent_warp_charge_damage_multiplier] = 0.9
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		return true
	end
}
templates.weapon_trait_ranged_warp_charge_wield_reduced_warp_charge_generation_firing = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.warp_charge_immediate_amount] = 0.9
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		return true
	end
}
templates.weapon_trait_ranged_warp_charge_wield_reduced_warp_charge_generation_charging = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.warp_charge_over_time_amount] = 0.9
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		return true
	end
}
templates.weapon_trait_ranged_warp_charge_wield_increased_charge_speed = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.charge_up_time] = -0.15
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		return true
	end
}
templates.weapon_trait_ranged_warp_charge_wield_increased_damage_on_full_charge = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.fully_charged_damage] = 0.1
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		return true
	end
}
templates.weapon_trait_ranged_warp_charge_wield_high_warp_charge_increased_charge_speed = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.charge_up_time] = -0.2
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		if not ConditionalFunctions.has_high_warp_charge(template_data, template_context) then
			return
		end

		return true
	end
}
templates.weapon_trait_ranged_warp_charge_wield_high_warp_charge_increased_damage_on_full_charge = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[buff_stat_buffs.fully_charged_damage] = 0.2
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return
		end

		if not ConditionalFunctions.has_high_warp_charge(template_data, template_context) then
			return
		end

		return true
	end
}

return templates
