local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local MissionSettings = require("scripts/settings/mission/mission_settings")
local gib_overrides_template = GibbingSettings.gib_overrides
local zone_ids = MissionSettings.mission_zone_ids

local function _exclude_variations_by_items(template, exclude_item_lookup)
	for i = #template, 1, -1 do
		local variation = template[i]
		local items = variation.slot_upperbody.items

		for _, item_name in ipairs(items) do
			if exclude_item_lookup[item_name] then
				table.remove(template, i)

				break
			end
		end
	end
end

local basic_newly_infected_template = {
	slot_body = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_grunge_01",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_grunge_02",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_grunge_03",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_grunge_04",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_01",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_01_grunge_01",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_01_grunge_02",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_01_grunge_03",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_01_grunge_04",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_02",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_02_grunge_01",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_02_grunge_02",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_02_grunge_03",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_02_grunge_04",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_03",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_03_grunge_01",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_03_grunge_02",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_03_grunge_03",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_03_grunge_04",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_04",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_04_grunge_01",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_04_grunge_02",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_04_grunge_03",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/newly_infected_body_a_skin_04_grunge_04"
		}
	},
	slot_upperbody = {
		items = {
			"content/items/characters/minions/generic_items/empty_minion_item"
		}
	},
	slot_upperbody_decal = {
		items = {
			"content/items/characters/minions/generic_items/empty_minion_item"
		}
	},
	slot_lowerbody = {
		items = {
			"content/items/characters/minions/generic_items/empty_minion_item"
		}
	},
	slot_melee_weapon = {
		drop_on_death = true,
		is_weapon = true,
		items = {
			"content/items/weapons/minions/melee/renegade_melee_weapon_01",
			"content/items/weapons/minions/melee/renegade_melee_weapon_02",
			"content/items/weapons/minions/melee/renegade_melee_weapon_03",
			"content/items/weapons/minions/melee/renegade_melee_weapon_04",
			"content/items/weapons/minions/melee/renegade_melee_weapon_05",
			"content/items/weapons/minions/melee/renegade_melee_weapon_06"
		}
	},
	slot_hair = {
		items = {
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_a",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_a_var_01",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_a_var_02",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_a_var_03",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b_var_01",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b_var_02",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b_var_03",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_c",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_c_var_01",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_c_var_02",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_c_var_02",
			"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_c_var_03",
			"content/items/characters/minions/generic_items/empty_minion_item",
			"content/items/characters/minions/generic_items/empty_minion_item",
			"content/items/characters/minions/generic_items/empty_minion_item"
		}
	},
	slot_flesh = {
		starts_invisible = true,
		items = {
			"content/items/characters/minions/gib_items/newly_infected_flesh"
		}
	},
	zone_decal = {
		is_material_override_slot = true,
		items = {
			"content/items/characters/minions/decal_material_overrides/decal_transit_01",
			"content/items/characters/minions/decal_material_overrides/decal_transit_02",
			"content/items/characters/minions/decal_material_overrides/decal_transit_03",
			"content/items/characters/minions/decal_material_overrides/decal_transit_04",
			"content/items/characters/minions/decal_material_overrides/decal_transit_05"
		}
	},
	envrionmental_override = {
		is_material_override_slot = true,
		items = {
			"content/items/characters/minions/environment_overrides/dirt_02"
		}
	}
}
local templates = {
	chaos_newly_infected = {
		has_gib_overrides = true,
		default = {},
		[zone_ids.tank_foundry] = {},
		[zone_ids.training_grounds] = {}
	}
}
local default_1 = table.clone(basic_newly_infected_template)
default_1.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_05"
	}
}
local default_1_gibs = table.clone(gib_overrides_template)
default_1_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_entire_leg_flesh_gib_01"
	}
}
default_1_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_entire_leg_flesh_gib_01"
	}
}
default_1_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_lower_leg_flesh_gib_01"
default_1_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_lower_leg_flesh_gib_01"
default_1.gib_overrides = default_1_gibs
templates.chaos_newly_infected.default[1] = default_1
local default_2 = table.clone(basic_newly_infected_template)
default_2.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_05"
	}
}
local default_2_gibs = table.clone(gib_overrides_template)
default_2_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_entire_leg_flesh_gib_01"
	}
}
default_2_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_entire_leg_flesh_gib_01"
	}
}
default_2_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_lower_leg_flesh_gib_01"
default_2_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_lower_leg_flesh_gib_01"
default_2.gib_overrides = default_2_gibs
templates.chaos_newly_infected.default[2] = default_2
local default_3 = table.clone(basic_newly_infected_template)
default_3.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_05"
	}
}
default_3.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_05"
	}
}
default_3.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
local default_3_gibs = table.clone(gib_overrides_template)
default_3_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/upper_torso_gib_full"
default_3_gibs.torso.default.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upper_torso_gib_cap"
default_3_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/upper_torso_gib_full"
default_3_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/upper_torso_gib_full"
default_3_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/upper_torso_flesh_gib_01"
default_3_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/upper_torso_gib_full"
default_3_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/upper_torso_gib_full"
default_3_gibs.upper_left_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/left_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/left_entire_arm_flesh_gib_01"
	}
}
default_3_gibs.upper_right_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/right_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/right_entire_arm_flesh_gib_01"
	}
}
default_3_gibs.lower_left_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/left_lower_arm_flesh_gib_01"
default_3_gibs.lower_right_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/right_lower_arm_flesh_gib_01"
default_3_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_entire_leg_flesh_gib_01"
	}
}
default_3_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_entire_leg_flesh_gib_01"
	}
}
default_3_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_lower_leg_flesh_gib_01"
default_3_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_lower_leg_flesh_gib_01"
default_3.gib_overrides = default_3_gibs
templates.chaos_newly_infected.default[3] = default_3
local default_4 = table.clone(basic_newly_infected_template)
default_4.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_05"
	}
}
default_4.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_var_05"
	}
}
default_4.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
local default_4_gibs = table.clone(gib_overrides_template)
default_4_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/upper_torso_gib_full"
default_4_gibs.torso.default.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upper_torso_gib_cap"
default_4_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/upper_torso_gib_full"
default_4_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/upper_torso_gib_full"
default_4_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/upper_torso_flesh_gib_01"
default_4_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/upper_torso_gib_full"
default_4_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/upper_torso_gib_full"
default_4_gibs.upper_left_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/left_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/left_entire_arm_flesh_gib_01"
	}
}
default_4_gibs.upper_right_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/right_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/right_entire_arm_flesh_gib_01"
	}
}
default_4_gibs.lower_left_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/left_lower_arm_flesh_gib_01"
default_4_gibs.lower_right_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_a/right_lower_arm_flesh_gib_01"
default_4_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_entire_leg_flesh_gib_01"
	}
}
default_4_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_entire_leg_flesh_gib_01"
	}
}
default_4_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_lower_leg_flesh_gib_01"
default_4_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_lower_leg_flesh_gib_01"
default_4.gib_overrides = default_4_gibs
templates.chaos_newly_infected.default[4] = default_4
local default_5 = table.clone(basic_newly_infected_template)
default_5.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_a_var_05"
	}
}
default_5.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_05"
	}
}
local default_5_gibs = table.clone(gib_overrides_template)
default_5_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/upper_torso_gib_full"
default_5_gibs.torso.default.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upper_torso_gib_cap"
default_5_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/upper_torso_gib_full"
default_5_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/upper_torso_gib_full"
default_5_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/upper_torso_flesh_gib_01"
default_5_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/upper_torso_gib_full"
default_5_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/upper_torso_gib_full"
default_5_gibs.upper_left_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/left_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/left_entire_arm_flesh_gib_01"
	}
}
default_5_gibs.upper_right_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/right_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/right_entire_arm_flesh_gib_01"
	}
}
default_5_gibs.lower_left_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/left_lower_arm_flesh_gib_01"
default_5_gibs.lower_right_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/right_lower_arm_flesh_gib_01"
default_5_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_a/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_a/left_entire_leg_flesh_gib_01"
	}
}
default_5_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_a/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_a/right_entire_leg_flesh_gib_01"
	}
}
default_5_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_a/left_lower_leg_flesh_gib_01"
default_5_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_a/right_lower_leg_flesh_gib_01"
default_5.gib_overrides = default_5_gibs
templates.chaos_newly_infected.default[5] = default_5
local default_6 = table.clone(basic_newly_infected_template)
default_6.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_05"
	}
}
default_6.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_05"
	}
}
local default_6_gibs = table.clone(gib_overrides_template)
default_6_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/upper_torso_gib_full"
default_6_gibs.torso.default.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upper_torso_gib_cap"
default_6_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/upper_torso_gib_full"
default_6_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/upper_torso_gib_full"
default_6_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/upper_torso_flesh_gib_01"
default_6_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/upper_torso_gib_full"
default_6_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/upper_torso_gib_full"
default_6_gibs.upper_left_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/left_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/left_entire_arm_flesh_gib_01"
	}
}
default_6_gibs.upper_right_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/right_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/right_entire_arm_flesh_gib_01"
	}
}
default_6_gibs.lower_left_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/left_lower_arm_flesh_gib_01"
default_6_gibs.lower_right_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/right_lower_arm_flesh_gib_01"
default_6_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_entire_leg_flesh_gib_01"
	}
}
default_6_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_entire_leg_flesh_gib_01"
	}
}
default_6_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_lower_leg_flesh_gib_01"
default_6_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_lower_leg_flesh_gib_01"
default_6.gib_overrides = default_6_gibs
templates.chaos_newly_infected.default[6] = default_6
local default_7 = table.clone(basic_newly_infected_template)
default_7.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_05"
	}
}
default_7.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_b_var_05"
	}
}
local default_7_gibs = table.clone(gib_overrides_template)
default_7_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/upper_torso_gib_full"
default_7_gibs.torso.default.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upper_torso_gib_cap"
default_7_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/upper_torso_gib_full"
default_7_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/upper_torso_gib_full"
default_7_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/upper_torso_flesh_gib_01"
default_7_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/upper_torso_gib_full"
default_7_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/upper_torso_gib_full"
default_7_gibs.upper_left_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/left_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/left_entire_arm_flesh_gib_01"
	}
}
default_7_gibs.upper_right_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/right_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/right_entire_arm_flesh_gib_01"
	}
}
default_7_gibs.lower_left_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/left_lower_arm_flesh_gib_01"
default_7_gibs.lower_right_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_b/right_lower_arm_flesh_gib_01"
default_7_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_entire_leg_flesh_gib_01"
	}
}
default_7_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_entire_leg_flesh_gib_01"
	}
}
default_7_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_lower_leg_flesh_gib_01"
default_7_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_lower_leg_flesh_gib_01"
default_7.gib_overrides = default_7_gibs
templates.chaos_newly_infected.default[7] = default_7
local default_8 = table.clone(basic_newly_infected_template)
default_8.slot_hair = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
default_8.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_05"
	}
}
default_8.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_05"
	}
}
local default_8_gibs = table.clone(gib_overrides_template)
default_8_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/upper_torso_gib_full"
default_8_gibs.torso.default.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upper_torso_gib_cap"
default_8_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/head_flesh_gib_01"
default_8_gibs.head.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/head_flesh_gib_01"
default_8_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/upper_torso_gib_full"
default_8_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/upper_torso_flesh_gib_01"
default_8_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/upper_torso_gib_full"
default_8_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/upper_torso_gib_full"
default_8_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/upper_torso_gib_full"
default_8_gibs.upper_left_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/left_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/left_entire_arm_flesh_gib_01"
	}
}
default_8_gibs.upper_right_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/right_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/right_entire_arm_flesh_gib_01"
	}
}
default_8_gibs.lower_left_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/left_lower_arm_flesh_gib_01"
default_8_gibs.lower_right_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/right_lower_arm_flesh_gib_01"
default_8_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_entire_leg_flesh_gib_01"
	}
}
default_8_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_entire_leg_flesh_gib_01"
	}
}
default_8_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_lower_leg_flesh_gib_01"
default_8_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_lower_leg_flesh_gib_01"
default_8.gib_overrides = default_8_gibs
templates.chaos_newly_infected.default[8] = default_8
local default_9 = table.clone(basic_newly_infected_template)
default_9.slot_hair = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
default_9.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_05"
	}
}
default_9.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_05"
	}
}
local default_9_gibs = table.clone(gib_overrides_template)
default_9_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/upper_torso_gib_full"
default_9_gibs.torso.default.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upper_torso_gib_cap"
default_8_gibs.head.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/head_flesh_gib_01"
default_8_gibs.head.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/head_flesh_gib_01"
default_9_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/upper_torso_gib_full"
default_9_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/upper_torso_gib_full"
default_9_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/upper_torso_flesh_gib_01"
default_9_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/upper_torso_gib_full"
default_9_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/upper_torso_gib_full"
default_9_gibs.upper_left_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/left_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/left_entire_arm_flesh_gib_01"
	}
}
default_9_gibs.upper_right_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/right_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/right_entire_arm_flesh_gib_01"
	}
}
default_9_gibs.lower_left_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/left_lower_arm_flesh_gib_01"
default_9_gibs.lower_right_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_c/right_lower_arm_flesh_gib_01"
default_9_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_entire_leg_flesh_gib_01"
	}
}
default_9_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_entire_leg_flesh_gib_01"
	}
}
default_9_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_lower_leg_flesh_gib_01"
default_9_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_lower_leg_flesh_gib_01"
default_9.gib_overrides = default_9_gibs
templates.chaos_newly_infected.default[9] = default_9
local default_10 = table.clone(basic_newly_infected_template)
default_10.slot_hair = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
default_10.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_05"
	}
}
default_10.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_05"
	}
}
local default_10_gibs = table.clone(gib_overrides_template)
default_10_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_d/upper_torso_gib_full"
default_10_gibs.torso.default.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upper_torso_gib_cap"
default_10_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_d/upper_torso_gib_full"
default_10_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_d/upper_torso_gib_full"
default_10_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_d/upper_torso_flesh_gib_01"
default_10_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_d/upper_torso_gib_full"
default_10_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_d/upper_torso_gib_full"
default_10_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_entire_leg_flesh_gib_01"
	}
}
default_10_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_entire_leg_flesh_gib_01"
	}
}
default_10_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_lower_leg_flesh_gib_01"
default_10_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_lower_leg_flesh_gib_01"
default_10.gib_overrides = default_10_gibs
templates.chaos_newly_infected.default[10] = default_10
local default_11 = table.clone(basic_newly_infected_template)
default_11.slot_hair = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
default_11.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_05"
	}
}
default_11.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_d_var_05"
	}
}
local default_11_gibs = table.clone(gib_overrides_template)
default_11_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_d/upper_torso_gib_full"
default_11_gibs.torso.default.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upper_torso_gib_cap"
default_11_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_d/upper_torso_gib_full"
default_11_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_d/upper_torso_gib_full"
default_11_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_d/upper_torso_flesh_gib_01"
default_11_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_d/upper_torso_gib_full"
default_11_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_d/upper_torso_gib_full"
default_11_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_entire_leg_flesh_gib_01"
	}
}
default_11_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_entire_leg_flesh_gib_01"
	}
}
default_11_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_lower_leg_flesh_gib_01"
default_11_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_lower_leg_flesh_gib_01"
default_11.gib_overrides = default_11_gibs
templates.chaos_newly_infected.default[11] = default_11
local default_12 = table.clone(basic_newly_infected_template)
default_12.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_05"
	}
}
default_12.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_05"
	}
}
default_12.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_decal",
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
local default_12_gibs = table.clone(gib_overrides_template)
default_12_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/upper_torso_gib_full"
default_12_gibs.torso.default.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upper_torso_gib_cap"
default_12_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/upper_torso_gib_full"
default_12_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/upper_torso_flesh_gib_01"
default_12_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/upper_torso_gib_full"
default_12_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/upper_torso_gib_full"
default_12_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/upper_torso_gib_full"
default_12_gibs.upper_left_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/left_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/left_entire_arm_flesh_gib_01"
	}
}
default_12_gibs.upper_right_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/right_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/right_entire_arm_flesh_gib_01"
	}
}
default_12_gibs.lower_left_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/left_lower_arm_flesh_gib_01"
default_12_gibs.lower_right_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/right_lower_arm_flesh_gib_01"
default_12_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_entire_leg_flesh_gib_01"
	}
}
default_12_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_entire_leg_flesh_gib_01"
	}
}
default_12_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_lower_leg_flesh_gib_01"
default_12_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_lower_leg_flesh_gib_01"
default_12.gib_overrides = default_12_gibs
templates.chaos_newly_infected.default[12] = default_12
local default_13 = table.clone(basic_newly_infected_template)
default_13.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_05"
	}
}
default_13.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_var_05"
	}
}
default_13.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_e_decal",
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
local default_13_gibs = table.clone(gib_overrides_template)
default_13_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/upper_torso_gib_full"
default_13_gibs.torso.default.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upper_torso_gib_cap"
default_13_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/upper_torso_gib_full"
default_13_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/upper_torso_flesh_gib_01"
default_13_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/upper_torso_gib_full"
default_13_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/upper_torso_gib_full"
default_13_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/upper_torso_gib_full"
default_13_gibs.upper_left_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/left_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/left_entire_arm_flesh_gib_01"
	}
}
default_13_gibs.upper_right_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/right_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/right_entire_arm_flesh_gib_01"
	}
}
default_13_gibs.lower_left_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/left_lower_arm_flesh_gib_01"
default_13_gibs.lower_right_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_e/right_lower_arm_flesh_gib_01"
default_13_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_entire_leg_flesh_gib_01"
	}
}
default_13_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_entire_leg_flesh_gib_01"
	}
}
default_13_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_lower_leg_flesh_gib_01"
default_13_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_lower_leg_flesh_gib_01"
default_13.gib_overrides = default_13_gibs
templates.chaos_newly_infected.default[13] = default_13
local default_14 = table.clone(basic_newly_infected_template)
default_14.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_05"
	}
}
default_14.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_05"
	}
}
default_14.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_decal",
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
local default_14_gibs = table.clone(gib_overrides_template)
default_14_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_f/upper_torso_gib_full"
default_14_gibs.torso.default.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upper_torso_gib_cap"
default_14_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_f/upper_torso_gib_full"
default_14_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_f/upper_torso_gib_full"
default_14_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_f/upper_torso_flesh_gib_01"
default_14_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_f/upper_torso_gib_full"
default_14_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_f/upper_torso_gib_full"
default_14_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_entire_leg_flesh_gib_01"
	}
}
default_14_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_entire_leg_flesh_gib_01"
	}
}
default_14_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_lower_leg_flesh_gib_01"
default_14_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_lower_leg_flesh_gib_01"
default_14.gib_overrides = default_14_gibs
templates.chaos_newly_infected.default[14] = default_14
local default_15 = table.clone(basic_newly_infected_template)
default_15.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_05"
	}
}
default_15.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_var_05"
	}
}
default_15.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_f_decal",
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
local default_15_gibs = table.clone(gib_overrides_template)
default_15_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_f/upper_torso_gib_full"
default_15_gibs.torso.default.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upper_torso_gib_cap"
default_15_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_f/upper_torso_gib_full"
default_15_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_f/upper_torso_gib_full"
default_15_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_f/upper_torso_flesh_gib_01"
default_15_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_f/upper_torso_gib_full"
default_15_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upperbody_f/upper_torso_gib_full"
default_15_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_entire_leg_flesh_gib_01"
	}
}
default_15_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_entire_leg_flesh_gib_01"
	}
}
default_15_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_lower_leg_flesh_gib_01"
default_15_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_lower_leg_flesh_gib_01"
default_15.gib_overrides = default_15_gibs
templates.chaos_newly_infected.default[15] = default_15
local default_16 = table.clone(basic_newly_infected_template)
default_16.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_05"
	}
}
default_16.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_05"
	}
}
default_16.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
local default_16_gibs = table.clone(gib_overrides_template)
default_16_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/upper_torso_gib_full"
default_16_gibs.torso.default.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upper_torso_gib_cap"
default_16_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/upper_torso_gib_full"
default_16_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/upper_torso_gib_full"
default_16_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/upper_torso_flesh_gib_01"
default_16_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/upper_torso_gib_full"
default_16_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/upper_torso_gib_full"
default_16_gibs.upper_left_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/left_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/left_entire_arm_flesh_gib_01"
	}
}
default_16_gibs.upper_right_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/right_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/right_entire_arm_flesh_gib_01"
	}
}
default_16_gibs.lower_left_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/left_lower_arm_flesh_gib_01"
default_16_gibs.lower_right_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/right_lower_arm_flesh_gib_01"
default_16_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_entire_leg_flesh_gib_01"
	}
}
default_16_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_entire_leg_flesh_gib_01"
	}
}
default_16_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/left_lower_leg_flesh_gib_01"
default_16_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_b/right_lower_leg_flesh_gib_01"
default_16.gib_overrides = default_16_gibs
templates.chaos_newly_infected.default[16] = default_16
local default_17 = table.clone(basic_newly_infected_template)
default_17.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_05"
	}
}
default_17.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_05"
	}
}
default_17.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
local default_17_gibs = table.clone(gib_overrides_template)
default_17_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/upper_torso_gib_full"
default_17_gibs.torso.default.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upper_torso_gib_cap"
default_17_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/upper_torso_gib_full"
default_17_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/upper_torso_gib_full"
default_17_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/upper_torso_flesh_gib_01"
default_17_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/upper_torso_gib_full"
default_17_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/upper_torso_gib_full"
default_17_gibs.upper_left_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/left_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/left_entire_arm_flesh_gib_01"
	}
}
default_17_gibs.upper_right_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/right_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/right_entire_arm_flesh_gib_01"
	}
}
default_17_gibs.lower_left_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/left_lower_arm_flesh_gib_01"
default_17_gibs.lower_right_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/right_lower_arm_flesh_gib_01"
default_17_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_entire_leg_flesh_gib_01"
	}
}
default_17_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_entire_leg_flesh_gib_01"
	}
}
default_17_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/left_lower_leg_flesh_gib_01"
default_17_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/lowerbody_c/right_lower_leg_flesh_gib_01"
default_17.gib_overrides = default_17_gibs
templates.chaos_newly_infected.default[17] = default_17
local default_18 = table.clone(basic_newly_infected_template)
default_18.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_04",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_05"
	}
}
default_18.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
local default_18_gibs = table.clone(gib_overrides_template)
default_18_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/upper_torso_gib_full"
default_18_gibs.torso.default.stump_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/upper_torso_gib_cap"
default_18_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/upper_torso_gib_full"
default_18_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/upper_torso_gib_full"
default_18_gibs.center_mass.explosion.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/upper_torso_flesh_gib_01"
default_18_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/upper_torso_gib_full"
default_18_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/upper_torso_gib_full"
default_18_gibs.upper_left_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/left_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/left_entire_arm_flesh_gib_01"
	}
}
default_18_gibs.upper_right_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/right_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/right_entire_arm_flesh_gib_01"
	}
}
default_18_gibs.lower_left_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/left_lower_arm_flesh_gib_01"
default_18_gibs.lower_right_arm.default.override_gib_unit = "content/characters/enemy/chaos_traitor_guard/gibbing/newly_infected/fullbody_a/right_lower_arm_flesh_gib_01"
default_18.gib_overrides = default_18_gibs
templates.chaos_newly_infected.default[18] = default_18
local default_19 = table.clone(default_16)
default_19.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_04"
	}
}
default_19.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_04"
	}
}
default_19.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_decal"
	}
}
default_19.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_transit_01",
	"content/items/characters/minions/decal_material_overrides/decal_transit_02",
	"content/items/characters/minions/decal_material_overrides/decal_transit_03",
	"content/items/characters/minions/decal_material_overrides/decal_transit_04",
	"content/items/characters/minions/decal_material_overrides/decal_transit_05"
}
templates.chaos_newly_infected.default[19] = default_19
local foundry_1 = table.clone(default_1)
foundry_1.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_04"
	}
}
foundry_1.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01"
}
templates.chaos_newly_infected[zone_ids.tank_foundry][1] = foundry_1
local foundry_2 = table.clone(default_2)
foundry_2.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_04"
	}
}
foundry_2.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01"
}
templates.chaos_newly_infected[zone_ids.tank_foundry][2] = foundry_2
local foundry_3 = table.clone(default_16)
foundry_3.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_04"
	}
}
foundry_3.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_04"
	}
}
foundry_3.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_decal"
	}
}
foundry_3.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_foundry_01",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_02",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_03",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_04",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_05"
}
foundry_3.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01"
}
templates.chaos_newly_infected[zone_ids.tank_foundry][3] = foundry_3
local foundry_4 = table.clone(default_8)
foundry_4.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_b_var_foundry_04"
	}
}
foundry_4.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_04"
	}
}
foundry_4.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01"
}
templates.chaos_newly_infected[zone_ids.tank_foundry][4] = foundry_4
local foundry_5 = table.clone(default_9)
foundry_5.slot_lowerbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_lowerbody_c_var_foundry_04"
	}
}
foundry_5.slot_upperbody = {
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_fullbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_c_var_foundry_04"
	}
}
foundry_5.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01"
}
templates.chaos_newly_infected[zone_ids.tank_foundry][5] = foundry_5
local training_grounds = table.clone(templates.chaos_newly_infected.default)
local training_grounds_excluded_items = table.mirror_array_inplace({
	"content/items/characters/minions/chaos_traitor_guard/attachments_gear/newly_infected_upperbody_a"
})

_exclude_variations_by_items(training_grounds, training_grounds_excluded_items)

templates.chaos_newly_infected[zone_ids.training_grounds] = training_grounds

return templates
