-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_cryptic_buffs_data.lua

local MissionBuffsSettings = require("scripts/managers/mission_buffs/mission_buffs_settings")
local filtering_categories = MissionBuffsSettings.filtering_categories
local hordes_legendary_cryptic_buffs_data = {}

table.make_unique(hordes_legendary_cryptic_buffs_data)

hordes_legendary_cryptic_buffs_data.hordes_buff_cryptic_discharge_ability_always_full_charges_bonus = {
	description = "Discharge ability always counts as if it had been used at 3 charges.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_cryptic_discharge_ability_always_full_charges_bonus",
	title = "Voltaic Supercharge",
	filter_category = filtering_categories.regular,
	buff_stats = {
		talent_name = {
			format_type = "loc_string",
			value = "loc_talent_cryptic_discharge",
		},
	},
}
hordes_legendary_cryptic_buffs_data.hordes_buff_cryptic_chordclaw_kills_replenish_charge = {
	description = "Kills with the Chordclaw restore an ability Charge",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_cryptic_chordclaw_kills_replenish_charge",
	title = "Wolverine",
	filter_category = filtering_categories.regular,
	buff_stats = {
		talent_name = {
			format_type = "loc_string",
			value = "loc_talent_cryptic_chordclaw",
		},
	},
}
hordes_legendary_cryptic_buffs_data.hordes_buff_cryptic_precision_stance_duration_extension_on_kill = {
	description = "Arc Grenades spread X extra Arcs",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_cryptic_precision_stance_duration_extension_on_kill",
	title = "Ultimate Combat Doctrine",
	filter_category = filtering_categories.regular,
	buff_stats = {
		capacitance = {
			format_type = "percentage",
			value = 0.05,
		},
		talent_name = {
			format_type = "loc_string",
			value = "loc_talent_cryptic_precision_stance",
		},
		capacitance_keyword = {
			format_type = "loc_string",
			value = "loc_talent_cryptic_power_keyword",
		},
	},
}
hordes_legendary_cryptic_buffs_data.hordes_buff_cryptic_force_field_leaves_fire_liquid_area = {
	description = "When the Force Shield expires, fire is spread underneath you.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_cryptic_force_field_leaves_fire_liquid_area",
	title = "Oil Spill",
	filter_category = filtering_categories.regular,
	buff_stats = {
		talent_name = {
			format_type = "loc_string",
			value = "loc_talent_cryptic_grenade_ability_force_field",
		},
	},
}
hordes_legendary_cryptic_buffs_data.hordes_buff_cryptic_servo_skull_flamethrower_uses_no_charge = {
	description = "The Flamethrower Servo Skull no longer uses charges.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_cryptic_servo_skull_flamethrower_uses_no_charge",
	title = "Purgatory",
	filter_category = filtering_categories.regular,
	buff_stats = {
		talent_name = {
			format_type = "loc_string",
			value = "loc_talent_cryptic_servo_skull_flamethrower",
		},
	},
}
hordes_legendary_cryptic_buffs_data.hordes_buff_cryptic_arc_grenade_extra_arcs = {
	description = "Arc Grenades spread X extra Arcs",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_cryptic_arc_grenade_extra_arcs",
	title = "Thunder Strike",
	filter_category = filtering_categories.regular,
	buff_stats = {
		extra_arcs = {
			format_type = "number",
			value = 2,
		},
		talent_name = {
			format_type = "loc_string",
			value = "loc_talent_cryptic_arc_grenades",
		},
	},
}
hordes_legendary_cryptic_buffs_data.hordes_buff_cryptic_dodge_costs_cooldown = {
	description = "You have infinite Dodges. Dodging cost 10% cooldown.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_cryptic_dodge_costs_cooldown",
	title = "Powered Dodges",
	filter_category = filtering_categories.regular,
	buff_stats = {
		cooldown_percent_cost = {
			format_type = "percentage",
			value = 0.05,
		},
	},
}

return hordes_legendary_cryptic_buffs_data
