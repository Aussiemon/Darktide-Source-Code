-- chunkname: @scripts/settings/minion_visual_loadout/templates/renegade_melee_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	renegade_melee = {}
}
local basic_renegade_melee_template = {
	slots = {
		slot_upperbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_color_var_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_var_01_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_var_01_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_var_01_color_var_03"
			}
		},
		slot_lowerbody = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_color_var_03",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_var_01_color_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_var_01_color_var_02",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_var_01_color_var_03"
			}
		},
		slot_face = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_tattoo_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_tattoo_02"
			}
		},
		slot_hair = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b_var_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/hair_b_var_02",
				"content/items/characters/minions/generic_items/empty_minion_item",
				"content/items/characters/minions/generic_items/empty_minion_item",
				"content/items/characters/minions/generic_items/empty_minion_item",
				"content/items/characters/minions/generic_items/empty_minion_item",
				"content/items/characters/minions/generic_items/empty_minion_item"
			}
		},
		slot_melee_weapon = {
			use_outline = true,
			is_weapon = true,
			drop_on_death = true,
			items = {
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_02",
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_04",
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_01"
			}
		},
		slot_decal = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_d",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_e"
			}
		},
		slot_variation_gear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a"
			}
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/traitor_guard_flesh"
			}
		},
		envrionmental_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item"
			}
		},
		skin_color_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_01",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_02",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_03"
			}
		}
	}
}
local default_1 = table.clone(basic_renegade_melee_template)
local default_2 = table.clone(basic_renegade_melee_template)

default_2.gib_variations = {
	"var_01"
}
default_2.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_01"
	}
}

local default_3 = table.clone(basic_renegade_melee_template)

default_3.gib_variations = {
	"var_01"
}
default_3.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_02"
	}
}

local default_4 = table.clone(basic_renegade_melee_template)

default_4.gib_variations = {
	"var_03"
}
default_4.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_03"
	}
}

local default_5 = table.clone(basic_renegade_melee_template)

default_5.gib_variations = {
	"face_01_b"
}
default_5.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02"
	}
}

local default_6 = table.clone(basic_renegade_melee_template)

default_6.gib_variations = {
	"face_01_b",
	"var_01"
}
default_6.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_01"
	}
}
default_6.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02"
	}
}

local default_7 = table.clone(basic_renegade_melee_template)

default_7.gib_variations = {
	"face_01_b",
	"var_02"
}
default_7.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_02"
	}
}
default_7.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02"
	}
}

local default_8 = table.clone(basic_renegade_melee_template)

default_8.gib_variations = {
	"face_01_b",
	"var_03"
}
default_8.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_03"
	}
}
default_8.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02"
	}
}

local default_9 = table.clone(basic_renegade_melee_template)

default_9.gib_variations = {
	"face_02"
}
default_9.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_02"
	}
}

local default_10 = table.clone(basic_renegade_melee_template)

default_10.gib_variations = {
	"face_02",
	"var_01"
}
default_10.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_01"
	}
}
default_10.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_02"
	}
}

local default_11 = table.clone(basic_renegade_melee_template)

default_11.gib_variations = {
	"face_02",
	"var_02"
}
default_11.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_02"
	}
}
default_11.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_02"
	}
}

local default_12 = table.clone(basic_renegade_melee_template)

default_12.gib_variations = {
	"face_02",
	"var_03"
}
default_12.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_03"
	}
}
default_12.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_02"
	}
}

local default_13 = table.clone(basic_renegade_melee_template)

default_13.gib_variations = {
	"face_02_b"
}
default_13.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_02"
	}
}

local default_14 = table.clone(basic_renegade_melee_template)

default_14.gib_variations = {
	"face_02_b",
	"var_01"
}
default_14.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_01"
	}
}
default_14.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_02"
	}
}

local default_15 = table.clone(basic_renegade_melee_template)

default_15.gib_variations = {
	"face_02_b",
	"var_02"
}
default_15.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_02"
	}
}
default_15.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_02"
	}
}

local default_16 = table.clone(basic_renegade_melee_template)

default_16.gib_variations = {
	"face_02_b",
	"var_03"
}
default_16.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_03"
	}
}
default_16.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_02"
	}
}

local default_17 = table.clone(basic_renegade_melee_template)

default_17.gib_variations = {
	"face_03"
}
default_17.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_02"
	}
}

local default_18 = table.clone(basic_renegade_melee_template)

default_18.gib_variations = {
	"face_03",
	"var_01"
}
default_18.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_01"
	}
}
default_18.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_02"
	}
}

local default_19 = table.clone(basic_renegade_melee_template)

default_19.gib_variations = {
	"face_03",
	"var_02"
}
default_19.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_02"
	}
}
default_19.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_02"
	}
}

local default_20 = table.clone(basic_renegade_melee_template)

default_20.gib_variations = {
	"face_03",
	"var_03"
}
default_20.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_03"
	}
}
default_20.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_02"
	}
}

local default_21 = table.clone(basic_renegade_melee_template)

default_21.gib_variations = {
	"face_03_b"
}
default_21.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_02"
	}
}

local default_22 = table.clone(basic_renegade_melee_template)

default_22.gib_variations = {
	"face_03_b",
	"var_01"
}
default_22.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_01"
	}
}
default_22.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_02"
	}
}

local default_23 = table.clone(basic_renegade_melee_template)

default_23.gib_variations = {
	"face_03_b",
	"var_02"
}
default_23.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_02"
	}
}
default_23.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_02"
	}
}

local default_24 = table.clone(basic_renegade_melee_template)

default_24.gib_variations = {
	"face_03_b",
	"var_03"
}
default_24.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_03"
	}
}
default_24.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_02"
	}
}
templates.renegade_melee.default = {
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
	default_11,
	default_12,
	default_13,
	default_14,
	default_15,
	default_16,
	default_17,
	default_18,
	default_19,
	default_20,
	default_21,
	default_22,
	default_23,
	default_24
}

local foundry_1 = table.clone(basic_renegade_melee_template)

foundry_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_2 = table.clone(default_2)

foundry_2.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_3 = table.clone(default_3)

foundry_3.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_4 = table.clone(default_4)

foundry_4.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_5 = table.clone(default_5)

foundry_5.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_6 = table.clone(default_6)

foundry_6.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_7 = table.clone(default_7)

foundry_7.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_8 = table.clone(default_8)

foundry_8.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_9 = table.clone(default_9)

foundry_9.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_10 = table.clone(default_10)

foundry_10.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_11 = table.clone(default_11)

foundry_11.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_12 = table.clone(default_12)

foundry_12.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_13 = table.clone(default_13)

foundry_13.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_14 = table.clone(default_14)

foundry_14.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_15 = table.clone(default_15)

foundry_15.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_16 = table.clone(default_16)

foundry_16.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_17 = table.clone(default_17)

foundry_17.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_18 = table.clone(default_18)

foundry_18.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_19 = table.clone(default_19)

foundry_19.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_20 = table.clone(default_20)

foundry_20.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_21 = table.clone(default_21)

foundry_21.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_22 = table.clone(default_22)

foundry_22.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_23 = table.clone(default_23)

foundry_23.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}

local foundry_24 = table.clone(default_24)

foundry_24.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/dirt_02"
}
templates.renegade_melee[zone_ids.tank_foundry] = {
	foundry_1,
	foundry_2,
	foundry_3,
	foundry_4,
	foundry_5,
	foundry_6,
	foundry_7,
	foundry_8,
	foundry_9,
	foundry_10,
	foundry_11,
	foundry_12,
	foundry_13,
	foundry_14,
	foundry_15,
	foundry_16,
	foundry_17,
	foundry_18,
	foundry_19,
	foundry_20,
	foundry_21,
	foundry_22,
	foundry_23,
	foundry_24
}

local dust_1 = table.clone(basic_renegade_melee_template)

dust_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_2 = table.clone(default_2)

dust_2.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_3 = table.clone(default_3)

dust_3.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_4 = table.clone(default_4)

dust_4.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_5 = table.clone(default_5)

dust_5.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_6 = table.clone(default_6)

dust_6.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_7 = table.clone(default_7)

dust_7.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_8 = table.clone(default_8)

dust_8.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_9 = table.clone(default_9)

dust_9.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_10 = table.clone(default_10)

dust_10.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_11 = table.clone(default_11)

dust_11.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_12 = table.clone(default_12)

dust_12.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_13 = table.clone(default_13)

dust_13.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_14 = table.clone(default_14)

dust_14.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_15 = table.clone(default_15)

dust_15.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_16 = table.clone(default_16)

dust_16.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_17 = table.clone(default_17)

dust_17.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_18 = table.clone(default_18)

dust_18.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_19 = table.clone(default_19)

dust_19.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_20 = table.clone(default_20)

dust_20.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_21 = table.clone(default_21)

dust_21.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_22 = table.clone(default_22)

dust_22.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_23 = table.clone(default_23)

dust_23.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}

local dust_24 = table.clone(default_24)

dust_24.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/sand_02"
}
templates.renegade_melee[zone_ids.dust] = {
	dust_1,
	dust_2,
	dust_3,
	dust_4,
	dust_5,
	dust_6,
	dust_7,
	dust_8,
	dust_9,
	dust_10,
	dust_11,
	dust_12,
	dust_13,
	dust_14,
	dust_15,
	dust_16,
	dust_17,
	dust_18,
	dust_19,
	dust_20,
	dust_21,
	dust_22,
	dust_23,
	dust_24
}

local watertown_1 = table.clone(basic_renegade_melee_template)

watertown_1.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_2 = table.clone(default_2)

watertown_2.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_3 = table.clone(default_3)

watertown_3.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_4 = table.clone(default_4)

watertown_4.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_5 = table.clone(default_5)

watertown_5.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_6 = table.clone(default_6)

watertown_6.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_7 = table.clone(default_7)

watertown_7.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_8 = table.clone(default_8)

watertown_8.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_9 = table.clone(default_9)

watertown_9.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_10 = table.clone(default_10)

watertown_10.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_11 = table.clone(default_11)

watertown_11.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_12 = table.clone(default_12)

watertown_12.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_13 = table.clone(default_13)

watertown_13.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_14 = table.clone(default_14)

watertown_14.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_15 = table.clone(default_15)

watertown_15.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_16 = table.clone(default_16)

watertown_16.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_17 = table.clone(default_17)

watertown_17.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_18 = table.clone(default_18)

watertown_18.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_19 = table.clone(default_19)

watertown_19.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_20 = table.clone(default_20)

watertown_20.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_21 = table.clone(default_21)

watertown_21.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_22 = table.clone(default_22)

watertown_22.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_23 = table.clone(default_23)

watertown_23.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}

local watertown_24 = table.clone(default_24)

watertown_24.slots.envrionmental_override.items = {
	"content/items/characters/minions/environment_overrides/acid_02"
}
templates.renegade_melee[zone_ids.watertown] = {
	watertown_1,
	watertown_2,
	watertown_3,
	watertown_4,
	watertown_5,
	watertown_6,
	watertown_7,
	watertown_8,
	watertown_9,
	watertown_10,
	watertown_11,
	watertown_12,
	watertown_13,
	watertown_14,
	watertown_15,
	watertown_16,
	watertown_17,
	watertown_18,
	watertown_19,
	watertown_20,
	watertown_21,
	watertown_22,
	watertown_23,
	watertown_24
}

return templates
