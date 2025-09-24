-- chunkname: @scripts/settings/minion_visual_loadout/templates/renegade_melee_visual_loadout_templates.lua

local MissionSettings = require("scripts/settings/mission/mission_settings")
local zone_ids = MissionSettings.mission_zone_ids
local templates = {
	renegade_melee = {},
}
local base_visual_loadout_template = {
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
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_var_01_color_var_03",
			},
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
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_a_var_01_color_var_03",
			},
		},
		slot_face = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_tattoo_01",
				"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_tattoo_02",
			},
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
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		slot_melee_weapon = {
			drop_on_death = true,
			is_weapon = true,
			use_outline = true,
			items = {
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_02",
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_04",
				"content/items/weapons/minions/melee/chaos_traitor_guard_melee_weapon_01",
			},
		},
		slot_decal = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_a",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_d",
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/chaos_traitor_guard_decal_01_e",
			},
		},
		slot_variation_gear = {
			use_outline = true,
			items = {
				"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a",
			},
		},
		slot_flesh = {
			starts_invisible = true,
			items = {
				"content/items/characters/minions/gib_items/traitor_guard_flesh",
			},
		},
		environmental_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
			},
		},
		skin_color_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_01",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_02",
				"content/items/characters/minions/skin_color_overrides/chaos_skin_color_03",
			},
		},
	},
}
local default_1 = table.clone(base_visual_loadout_template)
local default_2 = table.clone(base_visual_loadout_template)

default_2.gib_variations = {
	"var_01",
}
default_2.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_01",
	},
}

local default_3 = table.clone(base_visual_loadout_template)

default_3.gib_variations = {
	"var_01",
}
default_3.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_02",
	},
}

local default_4 = table.clone(base_visual_loadout_template)

default_4.gib_variations = {
	"var_03",
}
default_4.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_03",
	},
}

local default_5 = table.clone(base_visual_loadout_template)

default_5.gib_variations = {
	"face_01_b",
}
default_5.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02",
	},
}

local default_6 = table.clone(base_visual_loadout_template)

default_6.gib_variations = {
	"face_01_b",
	"var_01",
}
default_6.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_01",
	},
}
default_6.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02",
	},
}

local default_7 = table.clone(base_visual_loadout_template)

default_7.gib_variations = {
	"face_01_b",
	"var_02",
}
default_7.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_02",
	},
}
default_7.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02",
	},
}

local default_8 = table.clone(base_visual_loadout_template)

default_8.gib_variations = {
	"face_01_b",
	"var_03",
}
default_8.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_03",
	},
}
default_8.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02",
	},
}

local default_9 = table.clone(base_visual_loadout_template)

default_9.gib_variations = {
	"face_02",
}
default_9.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_02",
	},
}

local default_10 = table.clone(base_visual_loadout_template)

default_10.gib_variations = {
	"face_02",
	"var_01",
}
default_10.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_01",
	},
}
default_10.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_02",
	},
}

local default_11 = table.clone(base_visual_loadout_template)

default_11.gib_variations = {
	"face_02",
	"var_02",
}
default_11.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_02",
	},
}
default_11.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_02",
	},
}

local default_12 = table.clone(base_visual_loadout_template)

default_12.gib_variations = {
	"face_02",
	"var_03",
}
default_12.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_03",
	},
}
default_12.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_tattoo_02",
	},
}

local default_13 = table.clone(base_visual_loadout_template)

default_13.gib_variations = {
	"face_02_b",
}
default_13.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_02",
	},
}

local default_14 = table.clone(base_visual_loadout_template)

default_14.gib_variations = {
	"face_02_b",
	"var_01",
}
default_14.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_01",
	},
}
default_14.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_02",
	},
}

local default_15 = table.clone(base_visual_loadout_template)

default_15.gib_variations = {
	"face_02_b",
	"var_02",
}
default_15.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_02",
	},
}
default_15.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_02",
	},
}

local default_16 = table.clone(base_visual_loadout_template)

default_16.gib_variations = {
	"face_02_b",
	"var_03",
}
default_16.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_03",
	},
}
default_16.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_02_b_tattoo_02",
	},
}

local default_17 = table.clone(base_visual_loadout_template)

default_17.gib_variations = {
	"face_03",
}
default_17.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_02",
	},
}

local default_18 = table.clone(base_visual_loadout_template)

default_18.gib_variations = {
	"face_03",
	"var_01",
}
default_18.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_01",
	},
}
default_18.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_02",
	},
}

local default_19 = table.clone(base_visual_loadout_template)

default_19.gib_variations = {
	"face_03",
	"var_02",
}
default_19.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_02",
	},
}
default_19.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_02",
	},
}

local default_20 = table.clone(base_visual_loadout_template)

default_20.gib_variations = {
	"face_03",
	"var_03",
}
default_20.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_03",
	},
}
default_20.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_tattoo_02",
	},
}

local default_21 = table.clone(base_visual_loadout_template)

default_21.gib_variations = {
	"face_03_b",
}
default_21.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_02",
	},
}

local default_22 = table.clone(base_visual_loadout_template)

default_22.gib_variations = {
	"face_03_b",
	"var_01",
}
default_22.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_01",
	},
}
default_22.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_02",
	},
}

local default_23 = table.clone(base_visual_loadout_template)

default_23.gib_variations = {
	"face_03_b",
	"var_02",
}
default_23.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_02",
	},
}
default_23.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_02",
	},
}

local default_24 = table.clone(base_visual_loadout_template)

default_24.gib_variations = {
	"face_03_b",
	"var_03",
}
default_24.slots.slot_variation_gear = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_a_var_03",
	},
}
default_24.slots.slot_face = {
	use_outline = true,
	items = {
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_01",
		"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_03_b_tattoo_02",
	},
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
	default_24,
}

local tank_foundry_variations = {}

for _, default_variation in pairs(templates.renegade_melee.default) do
	local tank_foundry_variation = table.clone(default_variation)

	tank_foundry_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/dirt_02",
	}
	tank_foundry_variations[#tank_foundry_variations + 1] = tank_foundry_variation
end

templates.renegade_melee[zone_ids.tank_foundry] = tank_foundry_variations

local dust_variations = {}

for _, default_variation in pairs(templates.renegade_melee.default) do
	local dust_variation = table.clone(default_variation)

	dust_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/sand_02",
	}
	dust_variations[#dust_variations + 1] = dust_variation
end

templates.renegade_melee[zone_ids.dust] = dust_variations

local watertown_variations = {}

for _, default_variation in pairs(templates.renegade_melee.default) do
	local watertown_variation = table.clone(default_variation)

	watertown_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/acid_02",
	}
	watertown_variations[#watertown_variations + 1] = watertown_variation
end

templates.renegade_melee[zone_ids.watertown] = watertown_variations

local void_variations = {}

for _, default_variation in pairs(templates.renegade_melee.default) do
	local void_variation = table.clone(default_variation)

	void_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/snow_01",
	}
	void_variations[#void_variations + 1] = void_variation
end

templates.renegade_melee[zone_ids.void] = void_variations

local horde_variations = {}

for _, default_variation in pairs(templates.renegade_melee.default) do
	local horde_variation = table.clone(default_variation)

	horde_variation.slots.environmental_override.items = {
		"content/items/characters/minions/environment_overrides/snow_01",
	}
	horde_variations[#horde_variations + 1] = horde_variation
end

templates.renegade_melee[zone_ids.horde] = horde_variations

return templates
