local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local MissionSettings = require("scripts/settings/mission/mission_settings")
local gib_overrides_template = GibbingSettings.gib_overrides
local zone_ids = MissionSettings.mission_zone_ids
local basic_poxwalker_template = {
	slot_body = {
		items = {
			"content/items/characters/minions/chaos_poxwalker/attachments_base/body",
			"content/items/characters/minions/chaos_poxwalker/attachments_base/body_skin_01",
			"content/items/characters/minions/chaos_poxwalker/attachments_base/body_skin_02",
			"content/items/characters/minions/chaos_poxwalker/attachments_base/body_skin_03",
			"content/items/characters/minions/chaos_poxwalker/attachments_base/body_skin_04"
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
	slot_upper_body_horn = {
		items = {
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_left_02",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_left_02",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_left_02",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_left_02",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_left_03",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_left_03",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_left_03",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_left_03",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_right_01",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_right_01",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_right_01",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_right_02",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_right_02",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_right_02",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_torso_01",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_torso_02",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_torso_02",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_torso_02",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_torso_02",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_torso_03",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_torso_03",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_torso_03",
			"content/items/characters/minions/generic_items/empty_minion_item",
			"content/items/characters/minions/generic_items/empty_minion_item",
			"content/items/characters/minions/generic_items/empty_minion_item"
		}
	},
	slot_head = {
		items = {
			"content/items/characters/minions/chaos_poxwalker/attachments_base/hair_a",
			"content/items/characters/minions/chaos_poxwalker/attachments_base/hair_b",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_head_01",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_head_02",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_head_03",
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_head_04",
			"content/items/characters/minions/generic_items/empty_minion_item"
		}
	},
	slot_horn = {
		items = {
			"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_left_01",
			"content/items/characters/minions/generic_items/empty_minion_item"
		}
	},
	slot_lower_body = {
		items = {
			"content/items/characters/minions/generic_items/empty_minion_item"
		}
	},
	slot_upper_body = {
		items = {
			"content/items/characters/minions/generic_items/empty_minion_item"
		}
	},
	slot_flesh = {
		starts_invisible = true,
		items = {
			"content/items/characters/minions/gib_items/poxwalker_flesh"
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
	chaos_poxwalker = {
		has_gib_overrides = true,
		default = {},
		[zone_ids.tank_foundry] = {}
	}
}
templates.chaos_poxwalker.default[1] = table.clone(basic_poxwalker_template)
local default_2 = table.clone(basic_poxwalker_template)
default_2.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06"
	}
}
default_2.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_07"
	}
}
local default_2_gibs = table.clone(gib_overrides_template)
default_2_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_entire_leg_flesh_gib_01"
	}
}
default_2_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_entire_leg_flesh_gib_01"
	}
}
default_2_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_lower_leg_flesh_gib_01"
default_2_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_lower_leg_flesh_gib_01"
default_2.gib_overrides = default_2_gibs
templates.chaos_poxwalker.default[2] = default_2
local default_3 = table.clone(basic_poxwalker_template)
default_3.slot_upper_body_horn = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
default_3.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06"
	}
}
default_3.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_07"
	}
}
default_3.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
local default_3_gibs = table.clone(gib_overrides_template)
default_3_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_a/upper_torso_gib_full"
default_3_gibs.torso.default.override_stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_cap"
default_3_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_a/upper_torso_flesh_gib_01"
default_3_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_a/upper_torso_flesh_gib_01"
default_3_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_a/upper_torso_gib_full"
default_3_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_a/upper_torso_gib_full"
default_3_gibs.upper_left_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_a/left_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_a/left_entire_arm_flesh_gib_01"
	}
}
default_3_gibs.upper_right_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_a/right_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_a/right_entire_arm_flesh_gib_01"
	}
}
default_3_gibs.lower_left_arm.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_a/left_lower_arm_flesh_gib_01"
default_3_gibs.lower_right_arm.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_a/right_lower_arm_flesh_gib_01"
default_3_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_entire_leg_flesh_gib_01"
	}
}
default_3_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_entire_leg_flesh_gib_01"
	}
}
default_3_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_lower_leg_flesh_gib_01"
default_3_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_lower_leg_flesh_gib_01"
default_3.gib_overrides = default_3_gibs
templates.chaos_poxwalker.default[3] = default_3
local default_4 = table.clone(basic_poxwalker_template)
default_4.slot_upper_body_horn = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
default_4.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06"
	}
}
default_4.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_05"
	}
}
default_4.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_decal",
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
local default_4_gibs = table.clone(gib_overrides_template)
default_4_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_b/upper_torso_gib_full"
default_4_gibs.torso.default.override_stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_cap"
default_4_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_b/upper_torso_flesh_gib_01"
default_4_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_b/upper_torso_flesh_gib_01"
default_4_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_b/upper_torso_gib_full"
default_4_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_b/upper_torso_gib_full"
default_4_gibs.upper_left_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_b/left_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_b/left_entire_arm_flesh_gib_01"
	}
}
default_4_gibs.upper_right_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_b/right_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_b/right_entire_arm_flesh_gib_01"
	}
}
default_4_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_entire_leg_flesh_gib_01"
	}
}
default_4_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_entire_leg_flesh_gib_01"
	}
}
default_4_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_lower_leg_flesh_gib_01"
default_4_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_lower_leg_flesh_gib_01"
default_4.gib_overrides = default_4_gibs
templates.chaos_poxwalker.default[4] = default_4
local default_5 = table.clone(basic_poxwalker_template)
default_5.slot_upper_body_horn = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
default_5.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06"
	}
}
default_5.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_05"
	}
}
default_5.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_decal",
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
local default_5_gibs = table.clone(gib_overrides_template)
default_5_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_d/upper_torso_gib_full"
default_5_gibs.torso.default.override_stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_cap"
default_5_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_d/upper_torso_flesh_gib_01"
default_5_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_d/upper_torso_flesh_gib_01"
default_5_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_d/upper_torso_gib_full"
default_5_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_d/upper_torso_gib_full"
default_5_gibs.upper_right_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_d/right_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_d/right_entire_arm_flesh_gib_01"
	}
}
default_5_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_entire_leg_flesh_gib_01"
	}
}
default_5_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_entire_leg_flesh_gib_01"
	}
}
default_5_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_lower_leg_flesh_gib_01"
default_5_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_lower_leg_flesh_gib_01"
default_5.gib_overrides = default_5_gibs
templates.chaos_poxwalker.default[5] = default_5
local default_6 = table.clone(basic_poxwalker_template)
default_6.slot_upper_body_horn = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
default_6.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_var_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_var_07",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_var_08"
	}
}
local default_6_gibs = table.clone(gib_overrides_template)
default_6_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_b/upper_torso_gib_full"
default_6_gibs.torso.default.override_stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_cap"
default_6_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_b/upper_torso_flesh_gib_01"
default_6_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_b/upper_torso_flesh_gib_01"
default_6_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_b/upper_torso_gib_full"
default_6_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_b/upper_torso_gib_full"
default_6_gibs.upper_left_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_b/left_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_b/left_entire_arm_flesh_gib_01"
	}
}
default_6_gibs.lower_left_arm.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/fullbody_b/left_lower_arm_flesh_gib_01"
default_6.gib_overrides = default_6_gibs
templates.chaos_poxwalker.default[6] = default_6
local default_7 = table.clone(basic_poxwalker_template)
default_7.slot_upper_body_horn = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
default_7.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06"
	}
}
default_7.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_07"
	}
}
default_7.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
local default_7_gibs = table.clone(gib_overrides_template)
default_7_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_a/upper_torso_gib_full"
default_7_gibs.torso.default.override_stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_cap"
default_7_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_a/upper_torso_flesh_gib_01"
default_7_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_a/upper_torso_flesh_gib_01"
default_7_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_a/upper_torso_gib_full"
default_7_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_a/upper_torso_gib_full"
default_7_gibs.upper_left_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_a/left_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_a/left_entire_arm_flesh_gib_01"
	}
}
default_7_gibs.upper_right_arm.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_a/right_upper_arm_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_a/right_entire_arm_flesh_gib_01"
	}
}
default_7_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_entire_leg_flesh_gib_01"
	}
}
default_7_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_entire_leg_flesh_gib_01"
	}
}
default_7_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_lower_leg_flesh_gib_01"
default_7_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_lower_leg_flesh_gib_01"
default_7.gib_overrides = default_7_gibs
templates.chaos_poxwalker.default[7] = default_7
local default_8 = table.clone(basic_poxwalker_template)
default_8.slot_upper_body_horn = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
default_8.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06"
	}
}
default_8.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_07"
	}
}
default_8.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_decal",
		"content/items/characters/minions/generic_items/empty_minion_item"
	}
}
local default_8_gibs = table.clone(gib_overrides_template)
default_8_gibs.torso.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_e/upper_torso_gib_full"
default_8_gibs.torso.default.override_stump_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upper_torso_gib_cap"
default_8_gibs.torso.plasma.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_e/upper_torso_flesh_gib_01"
default_8_gibs.center_mass.plasma.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_e/upper_torso_flesh_gib_01"
default_8_gibs.center_mass.sawing.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_e/upper_torso_gib_full"
default_8_gibs.torso.sawing.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/upperbody_e/upper_torso_gib_full"
default_8_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_entire_leg_flesh_gib_01"
	}
}
default_8_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_entire_leg_flesh_gib_01"
	}
}
default_8_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_lower_leg_flesh_gib_01"
default_8_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_lower_leg_flesh_gib_01"
default_8.gib_overrides = default_8_gibs
templates.chaos_poxwalker.default[8] = default_8
local default_9 = table.clone(basic_poxwalker_template)
default_9.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06"
	}
}
local default_9_gibs = table.clone(gib_overrides_template)
default_9_gibs.upper_left_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_entire_leg_flesh_gib_01"
	}
}
default_9_gibs.upper_right_leg.default.conditional = {
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_upper_leg_flesh_gib_01"
	},
	{
		override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_entire_leg_flesh_gib_01"
	}
}
default_9_gibs.lower_left_leg.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/left_lower_leg_flesh_gib_01"
default_9_gibs.lower_right_leg.default.override_gib_unit = "content/characters/enemy/chaos_poxwalker/gibbing/lowerbody_a/right_lower_leg_flesh_gib_01"
default_9.gib_overrides = default_9_gibs
templates.chaos_poxwalker.default[9] = default_9
local default_10 = table.clone(default_3)
default_10.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_04"
	}
}
default_10.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_foundry_04"
	}
}
default_10.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_decal"
	}
}
default_10.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_transit_01",
	"content/items/characters/minions/decal_material_overrides/decal_transit_02",
	"content/items/characters/minions/decal_material_overrides/decal_transit_03",
	"content/items/characters/minions/decal_material_overrides/decal_transit_04",
	"content/items/characters/minions/decal_material_overrides/decal_transit_05"
}
templates.chaos_poxwalker.default[10] = default_10
local foundry_1 = table.clone(default_9)
foundry_1.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_04"
	}
}
foundry_1.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01"
}
templates.chaos_poxwalker[zone_ids.tank_foundry][1] = foundry_1
local foundry_2 = table.clone(default_4)
foundry_2.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_04"
	}
}
foundry_2.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_foundry_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_foundry_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_foundry_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_foundry_04"
	}
}
foundry_2.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_decal"
	}
}
foundry_2.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_foundry_01",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_02",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_03",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_04",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_05"
}
foundry_2.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01"
}
templates.chaos_poxwalker[zone_ids.tank_foundry][2] = foundry_2
local foundry_3 = table.clone(default_2)
foundry_3.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_04"
	}
}
foundry_3.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_foundry_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_foundry_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_foundry_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_foundry_04"
	}
}
foundry_3.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01"
}
templates.chaos_poxwalker[zone_ids.tank_foundry][3] = foundry_3
local foundry_4 = table.clone(default_3)
foundry_4.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_04"
	}
}
foundry_4.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_foundry_04"
	}
}
foundry_4.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_decal"
	}
}
foundry_4.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_foundry_01",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_02",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_03",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_04",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_05"
}
foundry_4.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01"
}
templates.chaos_poxwalker[zone_ids.tank_foundry][4] = foundry_4

return templates
