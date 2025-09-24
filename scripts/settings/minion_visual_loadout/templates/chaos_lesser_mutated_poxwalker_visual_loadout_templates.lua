-- chunkname: @scripts/settings/minion_visual_loadout/templates/chaos_lesser_mutated_poxwalker_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	chaos_lesser_mutated_poxwalker = {},
}
local base_visual_loadout_template = {
	slots = {
		slot_body = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_poxwalker/attachments_base/body_tentacle_hand",
				"content/items/characters/minions/chaos_poxwalker/attachments_base/body_tentacle_hand_skin_01",
				"content/items/characters/minions/chaos_poxwalker/attachments_base/body_tentacle_hand_skin_02",
				"content/items/characters/minions/chaos_poxwalker/attachments_base/body_tentacle_hand_skin_03",
				"content/items/characters/minions/chaos_poxwalker/attachments_base/body_tentacle_hand_skin_04",
			},
		},
		slot_melee_weapon = {
			drop_on_death = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/melee/renegade_melee_weapon_01",
				"content/items/weapons/minions/melee/renegade_melee_weapon_02",
				"content/items/weapons/minions/melee/renegade_melee_weapon_03",
				"content/items/weapons/minions/melee/renegade_melee_weapon_04",
				"content/items/weapons/minions/melee/renegade_melee_weapon_05",
				"content/items/weapons/minions/melee/renegade_melee_weapon_06",
			},
		},
		slot_upper_body_horn = {
			use_outline = true,
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
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_head = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_poxwalker/attachments_base/hair_a",
				"content/items/characters/minions/chaos_poxwalker/attachments_base/hair_b",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_head_01",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_head_02",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_head_03",
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_head_04",
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_horn = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_poxwalker/attachments_gear/horn_arm_left_01",
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_lower_body = {
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_upper_body = {
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/poxwalker_body_tentacle_hand_flesh",
			},
		},
		zone_decal = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/decal_material_overrides/decal_transit_01",
				"content/items/characters/minions/decal_material_overrides/decal_transit_02",
				"content/items/characters/minions/decal_material_overrides/decal_transit_03",
				"content/items/characters/minions/decal_material_overrides/decal_transit_04",
				"content/items/characters/minions/decal_material_overrides/decal_transit_05",
			},
		},
		environmental_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/environment_overrides/dirt_02",
			},
		},
	},
}
local default_1 = table.clone(base_visual_loadout_template)
local default_2 = table.clone(base_visual_loadout_template)

default_2.gib_variations = {
	"lowerbody_a",
}
default_2.slots.slot_lower_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06",
	},
}
default_2.slots.slot_upper_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_07",
	},
}

local default_3 = table.clone(base_visual_loadout_template)

default_3.gib_variations = {
	"lowerbody_a",
	"fullbody_a",
}
default_3.slots.slot_upper_body_horn = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
default_3.slots.slot_lower_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06",
	},
}
default_3.slots.slot_upper_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_07",
	},
}
default_3.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local default_4 = table.clone(base_visual_loadout_template)

default_4.gib_variations = {
	"lowerbody_a",
	"upperbody_b",
}
default_4.slots.slot_upper_body_horn = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
default_4.slots.slot_lower_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06",
	},
}
default_4.slots.slot_upper_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_05",
	},
}
default_4.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local default_5 = table.clone(base_visual_loadout_template)

default_5.gib_variations = {
	"lowerbody_a",
	"upperbody_d",
}
default_5.slots.slot_upper_body_horn = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
default_5.slots.slot_lower_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06",
	},
}
default_5.slots.slot_upper_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_05",
	},
}
default_5.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local default_6 = table.clone(base_visual_loadout_template)

default_6.gib_variations = {
	"lowerbody_a",
	"fullbody_b",
}
default_6.slots.slot_upper_body_horn = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
default_6.slots.slot_upper_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_var_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_var_07",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_var_08",
	},
}

local default_7 = table.clone(base_visual_loadout_template)

default_7.gib_variations = {
	"lowerbody_a",
	"upperbody_a",
}
default_7.slots.slot_upper_body_horn = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
default_7.slots.slot_lower_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06",
	},
}
default_7.slots.slot_upper_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_07",
	},
}
default_7.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local default_8 = table.clone(base_visual_loadout_template)

default_8.gib_variations = {
	"lowerbody_a",
	"upperbody_e",
}
default_8.slots.slot_upper_body_horn = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
default_8.slots.slot_lower_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06",
	},
}
default_8.slots.slot_upper_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_07",
	},
}
default_8.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local default_9 = table.clone(base_visual_loadout_template)

default_9.gib_variations = {
	"lowerbody_a",
}
default_9.slots.slot_lower_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06",
	},
}

local default_10 = table.clone(default_3)

default_8.gib_variations = {
	"lowerbody_a",
	"upperbody_e",
}
default_10.slots.slot_lower_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_04",
	},
}
default_10.slots.slot_upper_body = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_foundry_04",
	},
}
default_10.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_decal",
	},
}
default_10.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_transit_01",
	"content/items/characters/minions/decal_material_overrides/decal_transit_02",
	"content/items/characters/minions/decal_material_overrides/decal_transit_03",
	"content/items/characters/minions/decal_material_overrides/decal_transit_04",
	"content/items/characters/minions/decal_material_overrides/decal_transit_05",
}
templates.chaos_lesser_mutated_poxwalker.default = {
	default_1,
	default_2,
	default_3,
	default_4,
	default_5,
	default_6,
	default_7,
	default_8,
	default_9,
	default_10,
}

local foundry_1 = table.clone(default_9)

foundry_1.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_04",
	},
}
foundry_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01",
}

local foundry_2 = table.clone(default_4)

foundry_2.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_04",
	},
}
foundry_2.slots.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_foundry_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_foundry_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_foundry_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_foundry_04",
	},
}
foundry_2.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_decal",
	},
}
foundry_2.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_foundry_01",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_02",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_03",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_04",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_05",
}
foundry_2.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01",
}

local foundry_3 = table.clone(default_2)

foundry_3.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_04",
	},
}
foundry_3.slots.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_foundry_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_foundry_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_foundry_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_foundry_04",
	},
}
foundry_3.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01",
}

local foundry_4 = table.clone(default_3)

foundry_4.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_foundry_04",
	},
}
foundry_4.slots.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_foundry_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_foundry_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_foundry_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_foundry_04",
	},
}
foundry_4.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_decal",
	},
}
foundry_4.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_foundry_01",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_02",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_03",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_04",
	"content/items/characters/minions/decal_material_overrides/decal_foundry_05",
}
foundry_4.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_01",
}
templates.chaos_lesser_mutated_poxwalker[zone_ids.tank_foundry] = {
	foundry_1,
	foundry_2,
	foundry_3,
	foundry_4,
}

local dust_1 = table.clone(default_2)

dust_1.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_05",
	},
}
dust_1.slots.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_dust_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_dust_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_dust_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_dust_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_dust_05",
	},
}
dust_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_01",
}

local dust_2 = table.clone(default_5)

dust_2.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_05",
	},
}
dust_2.slots.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_dust_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_dust_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_dust_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_dust_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_dust_05",
	},
}
dust_2.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
dust_2.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_dust_01",
	"content/items/characters/minions/decal_material_overrides/decal_dust_02",
	"content/items/characters/minions/decal_material_overrides/decal_dust_03",
	"content/items/characters/minions/decal_material_overrides/decal_dust_04",
	"content/items/characters/minions/decal_material_overrides/decal_dust_05",
}
dust_2.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_01",
}

local dust_3 = table.clone(default_8)

dust_3.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_05",
	},
}
dust_3.slots.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_dust_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_dust_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_dust_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_dust_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_dust_05",
	},
}
dust_3.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
dust_3.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_dust_01",
	"content/items/characters/minions/decal_material_overrides/decal_dust_02",
	"content/items/characters/minions/decal_material_overrides/decal_dust_03",
	"content/items/characters/minions/decal_material_overrides/decal_dust_04",
	"content/items/characters/minions/decal_material_overrides/decal_dust_05",
}
dust_3.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_01",
}

local dust_4 = table.clone(default_7)

dust_4.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_05",
	},
}
dust_4.slots.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_dust_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_dust_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_dust_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_dust_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_dust_05",
	},
}
dust_4.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
dust_4.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_dust_01",
	"content/items/characters/minions/decal_material_overrides/decal_dust_02",
	"content/items/characters/minions/decal_material_overrides/decal_dust_03",
	"content/items/characters/minions/decal_material_overrides/decal_dust_04",
	"content/items/characters/minions/decal_material_overrides/decal_dust_05",
}
dust_4.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_01",
}
templates.chaos_lesser_mutated_poxwalker[zone_ids.dust] = {
	dust_1,
	dust_2,
	dust_3,
	dust_4,
}

local watertown_1 = table.clone(default_2)

watertown_1.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_07",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_08",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_09",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_10",
	},
}
watertown_1.slots.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_wt_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_wt_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_wt_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_wt_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_wt_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_wt_06",
	},
}
watertown_1.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_2 = table.clone(default_7)

watertown_2.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_07",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_08",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_09",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_10",
	},
}
watertown_2.slots.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_wt_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_wt_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_wt_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_wt_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_wt_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_wt_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_wt_07",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_wt_08",
	},
}
watertown_2.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
watertown_2.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_wt_01",
	"content/items/characters/minions/decal_material_overrides/decal_wt_02",
	"content/items/characters/minions/decal_material_overrides/decal_wt_03",
	"content/items/characters/minions/decal_material_overrides/decal_wt_04",
	"content/items/characters/minions/decal_material_overrides/decal_wt_05",
}
watertown_2.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_3 = table.clone(default_4)

watertown_3.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_07",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_08",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_09",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_10",
	},
}
watertown_3.slots.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_wt_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_wt_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_wt_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_wt_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_wt_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_wt_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_wt_07",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_wt_08",
	},
}
watertown_3.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
watertown_3.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_wt_01",
	"content/items/characters/minions/decal_material_overrides/decal_wt_02",
	"content/items/characters/minions/decal_material_overrides/decal_wt_03",
	"content/items/characters/minions/decal_material_overrides/decal_wt_04",
	"content/items/characters/minions/decal_material_overrides/decal_wt_05",
}
watertown_3.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}

local watertown_4 = table.clone(default_3)

watertown_4.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_dust_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_07",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_08",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_09",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_wt_10",
	},
}
watertown_4.slots.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_wt_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_wt_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_wt_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_wt_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_wt_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_wt_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_var_wt_07",
	},
}
watertown_4.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
watertown_4.slots.zone_decal.items = {
	"content/items/characters/minions/decal_material_overrides/decal_wt_01",
	"content/items/characters/minions/decal_material_overrides/decal_wt_02",
	"content/items/characters/minions/decal_material_overrides/decal_wt_03",
	"content/items/characters/minions/decal_material_overrides/decal_wt_04",
	"content/items/characters/minions/decal_material_overrides/decal_wt_05",
}
watertown_4.slots.environmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_01",
}
templates.chaos_lesser_mutated_poxwalker[zone_ids.watertown] = {
	watertown_1,
	watertown_2,
	watertown_3,
	watertown_4,
}

local throneside_1 = table.clone(base_visual_loadout_template)
local throneside_2 = table.clone(base_visual_loadout_template)

throneside_2.gib_variations = {
	"lowerbody_a",
}
throneside_2.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06",
	},
}
throneside_2.slots.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_c_var_07",
	},
}

local throneside_3 = table.clone(base_visual_loadout_template)

throneside_3.gib_variations = {
	"lowerbody_a",
	"fullbody_a",
}
throneside_3.slots.slot_upper_body_horn = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
throneside_3.slots.slot_head = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_base/hair_wig_a",
	},
}
throneside_3.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_ts_var_01",
	},
}
throneside_3.slots.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_ts_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_ts_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_a_ts_var_03",
	},
}
throneside_3.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local throneside_4 = table.clone(base_visual_loadout_template)

throneside_4.gib_variations = {
	"lowerbody_a",
	"upperbody_b",
}
throneside_4.slots.slot_upper_body_horn = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
throneside_4.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06",
	},
}
throneside_4.slots.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_var_05",
	},
}
throneside_4.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_b_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local throneside_5 = table.clone(base_visual_loadout_template)

throneside_5.gib_variations = {
	"lowerbody_a",
	"upperbody_d",
}
throneside_5.slots.slot_upper_body_horn = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
throneside_5.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06",
	},
}
throneside_5.slots.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_var_05",
	},
}
throneside_5.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_d_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local throneside_6 = table.clone(base_visual_loadout_template)

throneside_6.gib_variations = {
	"lowerbody_a",
	"fullbody_b",
}
throneside_6.slots.slot_upper_body_horn = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
throneside_6.slots.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_ts_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_ts_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_ts_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/fullbody_b_ts_var_04",
	},
}

local throneside_7 = table.clone(base_visual_loadout_template)

throneside_7.gib_variations = {
	"lowerbody_a",
	"upperbody_a",
}
throneside_7.slots.slot_upper_body_horn = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
throneside_7.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06",
	},
}
throneside_7.slots.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_var_07",
	},
}
throneside_7.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_a_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local throneside_8 = table.clone(base_visual_loadout_template)

throneside_8.gib_variations = {
	"lowerbody_a",
	"upperbody_e",
}
throneside_8.slots.slot_upper_body_horn = {
	items = {
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}
throneside_8.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06",
	},
}
throneside_8.slots.slot_upper_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_06",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_var_07",
	},
}
throneside_8.slots.slot_upperbody_decal = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/upperbody_e_decal",
		"content/items/characters/minions/generic_items/empty_minion_item",
	},
}

local throneside_9 = table.clone(base_visual_loadout_template)

throneside_9.gib_variations = {
	"lowerbody_a",
}
throneside_9.slots.slot_lower_body = {
	items = {
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_01",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_02",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_03",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_04",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_05",
		"content/items/characters/minions/chaos_poxwalker/attachments_gear/lowerbody_a_var_06",
	},
}
templates.chaos_lesser_mutated_poxwalker[zone_ids.throneside] = {
	throneside_1,
	throneside_2,
	throneside_3,
	throneside_4,
	throneside_5,
	throneside_6,
	throneside_7,
	throneside_8,
	throneside_9,
}

local void_variations = {}

for _, tank_foundry_variation in pairs(templates.chaos_lesser_mutated_poxwalker[zone_ids.tank_foundry]) do
	local void_variation = table.clone(tank_foundry_variation)

	void_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/snow_01",
	}
	void_variations[#void_variations + 1] = void_variation
end

templates.chaos_lesser_mutated_poxwalker[zone_ids.void] = void_variations

local horde_variations = {}

for _, tank_foundry_variation in pairs(templates.chaos_lesser_mutated_poxwalker[zone_ids.tank_foundry]) do
	local horde_variation = table.clone(tank_foundry_variation)

	horde_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/snow_01",
	}
	horde_variations[#horde_variations + 1] = horde_variation
end

templates.chaos_lesser_mutated_poxwalker[zone_ids.horde] = horde_variations

return templates
